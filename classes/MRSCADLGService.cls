public class MRSCADLGService extends MRSCADGeneralService {
    
    private MRS_CADService.MRSDataRecievedOnLayerGeneration msgData;
    private set<id> setUpdatedId;//store id of layer chip record which has foundry/customer gdsout review update from not ready to ready
    
    public MRSCADLGService() {
        setUpdatedId = new set<id>();
        Environment_Variable__c debugMode = Environment_Variable__c.getInstance('SWIFT_CAD_WS_LG_DEBUG'); 
        this.isDebugMode = (null != debugMode && debugMode.Value__c == 'ON') ? true : false; // if debug mode on, all response&msg will be logged
        this.activeWsName = 'LG';
        this.WS_CLASS_NAME = MRSCADGeneralService.WS_LG;
    }
    
    public override Message validateFormat(String jsonMsg) {

        MRS_CADService.MRSDataRecievedOnLayerGeneration msg = 
            (MRS_CADService.MRSDataRecievedOnLayerGeneration)JSON.deserialize(jsonMsg, MRS_CADService.MRSDataRecievedOnLayerGeneration.class);
        
        this.msgData    = msg;  
        this.mst        = msg.maskSetTitle;
        this.sourceTime = msg.sourceInboundRequestTimestamp;
        this.messageId  = msg.messageID;
        
        if (msg.ptrf == null || msg.ptrf.size() == 0) return new Message(MSG_PTRF_REQUIRED,'', true);
        
        for (MRS_CADService.ptrfdata iPTRF: msg.ptrf) {
            this.ptrfData = iPTRF;
            if (iPTRF.chip == null || iPTRF.chip.size() == 0) return new Message(MSG_PTRF_NO_CHIP,'', true);
        
            for (MRS_CADService.chipData iChip: iPTRF.chip) {
                this.setChipName.add(iChip.chipName);
                if (iChip.layer == null || iChip.layer.size() == 0) return new Message(MSG_CHIP_NO_LAYER,'', true);
                
                for (MRS_CADService.layerData iLayer: iChip.layer) {
                    setLayerNumber.add(iLayer.maskLayer);
                    setLayerRev.add(iLayer.maskRev);
                }
            }
        }
        
        return new Message('','', false);
    }
    
    public override void processWS() {
        
        Map<String,Map<String,String>> fieldMap = getFieldMap();
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>(); //store layer chip for updating
        
        for(MRS_CADService.ChipData msgChip: ptrfData.chip) {
            
            String chipUniqueIdentifier = this.ptrfData.ptrfNumber + msgChip.chipName; //follow format in MRSCADGeneralService
            
            if( !chipNameSet.contains( msgChip.chipName ) ) {
                chipErrorMap.put( chipUniqueIdentifier, new Message(MRSCADGeneralService.MSG_CHIP_NOT_FOUND,'',true) ); //this error map will be processed in handleResponse()
                setChipNotFound.add(msgChip.chipName);//use to send missing layer/chip email
                continue;
            }
            
            for(MRS_CADService.LayerData msgLayer: msgChip.layer) {
                
                String layerUniqueIdentifier = chipUniqueIdentifier + msgLayer.maskLayer + msgLayer.maskRev;
                
                if( !layerUniqueIdSet.contains( layerUniqueIdentifier ) ) {
                    //check in cancel list -> if in cancel list -> layer chip is cancel
                    if( layerChipCancelSet.contains( layerUniqueIdentifier ) ) {
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is cancel','',false) ); 
                    }else { 
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(MRSCADGeneralService.MSG_LAYER_NOT_FOUND,'',true) );
                        setLayerNotFound.add( msgLayer.maskLayer + msgLayer.maskRev );//use to send missing layer/chip email
                    }
                    continue;
                }
                
                MRS_Layer_Chip_Association__c tmpChip = layerChipMap.get(layerUniqueIdentifier);
                
                //invalid layer status: layer is shipped or released
                if( tmpChip.Layer__r.Layer_Status__c == 'Released'  || tmpChip.Layer__r.Layer_Status__c == 'Shipped' ){
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer is ' + tmpChip.Layer__r.Layer_Status__c,'',false) ); 
                    continue;
                }
                
                //invalid layer chip status, only Not Ready / In Progress / Released / Hold are processed
                if( !'Not Ready;In Progress;Hold'.containsIgnoreCase(tmpChip.Layer_Chip_Status__c.trim()) ) {
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is ' + tmpChip.Layer_Chip_Status__c,'',false) );
                    continue;
                }
                
                String lastSyncField = 'Last_Sync_Req_Timestamp_Layer_Gen__c';
                if( tmpChip.get(lastSyncField) != null && (DateTime) tmpChip.get(lastSyncField) >= this.sourceTime ) {
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message(MSG_RECORD_SYNCED,'',false) );
                    continue;
                }
                    
                MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c( Id = tmpChip.Id );
                chipToUpdate.put(lastSyncField, this.sourceTime);
                
                String field;
                String isUpdatedField;
                List<String> recordManualUpdatedError = new List<String>();
                
                for(String masterKey: fieldMap.keySet()) {
                    field           = fieldMap.get(masterKey).get(KEY_FIELD);
                    isUpdatedField  = fieldMap.get(masterKey).get(KEY_IS_UPDATED);
                    
                    if(!String.isBlank(isUpdatedField) && (boolean) tmpChip.get(isUpdatedField) == false) {
                        if(tmpChip.get(field) == 'Not Ready') {
                            chipToUpdate.put(field, 'Ready');
                            setUpdatedId.add(tmpChip.Id);//will be used in postProcessing
                        }
                    } else {
                        recordManualUpdatedError.add(field);
                    }
                }
                
                if(!recordManualUpdatedError.isEmpty() ) {
                    layerChipErrorMap.put(layerUniqueIdentifier, 
                        new Message(String.join(recordManualUpdatedError, ', ') + ': ' + MRSCADGeneralService.MSG_FIELD_UPDATED_MANUALLY,'',false));
                }
                
                lcToUpdateList.add(chipToUpdate);
            }
        }
        
        //include send email
        postProcessing(lcToUpdateList);
    }
    
    @TestVisible
    private void postProcessing(List<MRS_Layer_Chip_Association__c> lcToUpdateList) {

        if(lcToUpdateList.isEmpty()) return;
        Database.SaveResult[] updateResult = database.update(lcToUpdateList, false); //DML to update layer chip
        //this map is use to retrieve new data after perform update dml for referencing with original before update list lcToUpdateList
        map<id, mrs_layer_chip_association__c> lcToUpdateForCompare = new map<id, mrs_layer_chip_association__c>([
            SELECT ID,Chip__r.Name,Layer__r.Name,Rev__c,Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Layer_Chip_Status__c,
                PTRF__c
            FROM mrs_layer_chip_association__c 
            WHERE ID IN:lcToUpdateList
        ]);
        
        String layerUniqueIdentifier = '';
        String key = '';
        list<mrs_layer_chip_association__c> listLcForEmail = new list<mrs_layer_chip_association__c>();
        
        for (Integer i=0; i< updateResult.size(); i++) {
            key = lcToUpdateList.get(i).id;
            if( !updateResult.get(i).isSuccess() ) {
                String error = updateResult.get(i).getErrors().get(0).getmessage();
                if(error.containsIgnoreCase('unable to obtain exclusive access to this record')) error = 'unable to obtain exclusive access to this record';
                layerUniqueIdentifier = ptrfData.ptrfNumber + lcToUpdateForCompare.get(key).Chip__r.Name + lcToUpdateForCompare.get(key).Layer__r.Name + lcToUpdateForCompare.get(key).Rev__c;                  
                layerChipErrorMap.put(layerUniqueIdentifier, new Message(error,'',true));
                continue;
            }
            
            if(setUpdatedId.contains(lcToUpdateForCompare.get(key).Id)) listLcForEmail.add(lcToUpdateForCompare.get(key));
        }
        
        //send email on foundry/customer gdsout ready for approval
        //additionalEmailContent_customer: swgp-805
        if (listLcForEmail.size() > 0) MRSHandlerUtility.sendRedyMailToGDSOUTReview(listLcForEmail, msgData.additionalEmailContent, msgData.additionalEmailContent_customer);
    }
    
    
    private Map<String,Map<String,String>> getFieldMap() {
         Map<String,Map<String,String>> result = new Map<String,Map<String,String>>{
            'CUSTOMER' => new Map<String, String>{
                KEY_FIELD       => 'Customer_GDSOUT_Review__c',
                KEY_IS_UPDATED  => 'Is_Customer_GDSOUT_Review_Updated__c'
            },
            'FOUNDRY'  => new Map<String, String>{
                KEY_FIELD       => 'Foundry_GDSOUT_Review__c',
                KEY_IS_UPDATED  => 'Is_Foundry_GDSOUT_Review_Updated__c'
            }
         };     
        return result;
    }
}