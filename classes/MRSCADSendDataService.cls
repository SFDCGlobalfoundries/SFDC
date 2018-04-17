public class MRSCADSendDataService extends MRSCADGeneralService{

    private Map<String,Map<String,String>> wsFieldMap;
    private Map<String,Map<String,String>> jvFieldMap;
    private boolean reTapeoutFlag;
    
    public MRSCADSendDataService(){
        WS_CLASS_NAME       = WS_SEND_DATA;   
        wsFieldMap = getWsFieldMap();
        jvFieldMap = getJvFieldMap();
        
        Environment_Variable__c debugMode = Environment_Variable__c.getInstance('SWIFT_CAD_WS_SEND_DATA_DEBUG'); 
        this.isDebugMode = (null != debugMode && debugMode.Value__c == 'ON') ? true : false; // if debug mode on, all response&msg will be logged
        this.activeWsName = 'Send Data';
    }
    
    /*
    * @description validate message format
    * @param  
    * @return 
    */
    public override Message validateFormat(String jsonMsg){
        
        MRS_CADService.MRSDataRecievedOnSendData msg = (MRS_CADService.MRSDataRecievedOnSendData)JSON.deserialize(jsonMsg, MRS_CADService.MRSDataRecievedOnSendData.class);
        
        this.mst            = msg.maskSetTitle;
        this.sourceTime     = msg.sourceInboundRequestTimestamp;
        this.messageId      = msg.messageID;
        this.reTapeoutFlag  = msg.reTapeoutFlag;
        
        String strInvalidMsg = '';
        if (msg.ptrf == null || msg.ptrf.size() == 0) {
            strInvalidMsg = MSG_PTRF_REQUIRED;
        }else{
            for (MRS_CADService.ptrfdata iPTRF: msg.ptrf) {
                this.ptrfData = iPTRF;
                if (iPTRF.chip == null || iPTRF.chip.size() == 0) {
                    strInvalidMsg = MSG_PTRF_NO_CHIP;
                }else{
                    for (MRS_CADService.chipData iChip: iPTRF.chip) {
                        this.setChipName.add(iChip.chipName);
                        if (iChip.layer == null || iChip.layer.size() == 0) {
                            strInvalidMsg = MSG_CHIP_NO_LAYER;
                        }else{
                            for (MRS_CADService.layerData iLayer: iChip.layer) {
                                setLayerNumber.add(iLayer.maskLayer);
                                setLayerRev.add(iLayer.maskRev);
                            }
                        }
                    }
                }
            }
        }
        if(!String.isBlank(strInvalidMsg)){
            return new Message(strInvalidMsg,'', true); 
        }
        return new Message('','', false);
    }
    
    /*
    * Override processWS() in MRSCADGeneralService
    * @description 
    * @param  
    * @return 
    */
    public override void processWS(){
        
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
                
                //invalid layer status: layer is shipped or released (without retapeout)
                if( (tmpChip.Layer__r.Layer_Status__c == 'Released' && this.reTapeoutFlag==false) || tmpChip.Layer__r.Layer_Status__c == 'Shipped' ){
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer is ' + tmpChip.Layer__r.Layer_Status__c,'',false) ); 
                    continue;
                }
                
                //invalid layer chip status, only Not Ready / In Progress / Released are processed
                if( !MRSCADGeneralService.VALID_LAYER_CHIP_STATUS.containsIgnoreCase(tmpChip.Layer_Chip_Status__c.trim()) ) {
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is ' + tmpChip.Layer_Chip_Status__c,'',false) );
                    continue;
                }
                
                String primeOrFrame = msgChip.chipName.equalsIgnoreCase(MRSCADGeneralService.CHIP_FRAME) ? MRSCADGeneralService.CHIP_FRAME : MRSCADGeneralService.CHIP_PRIME; //Prime of Frame chip
                
                map<String,String> currentFieldMap = wsFieldMap.get(primeOrFrame);
                String field            = currentFieldMap.get(KEY_FIELD);
                String isUpdatedField   = currentFieldMap.get(KEY_IS_UPDATED); 
                String lastSyncField    = currentFieldMap.get(KEY_LAST_SYNC);
                
                if( tmpChip.get(lastSyncField) != null && (DateTime) tmpChip.get(lastSyncField) >= this.sourceTime ){
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message(MSG_RECORD_SYNCED,'',false) );
                }else{
                    MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c( Id = tmpChip.Id );//Init a new object to make sure that only changed fields are save.
                    
                    chipToUpdate.put( lastSyncField, this.sourceTime );
                    
                    List<String> recordManualUpdatedError = new List<String>();
                    if( this.reTapeoutFlag==true ) { // retapeout = true
                        if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false ) {
                            if( tmpChip.get(field) != 'N.A.' ) {
                                chipToUpdate.put( field, 'Done' );
                                chipToUpdate.put( lastSyncField, this.sourceTime );
                            }
                        } else {// Field has been manually updated
                            recordManualUpdatedError.add(field);
                        }
                        
                        for( String key: jvFieldMap.keySet() ) {
                            if( key.containsIgnoreCase(primeOrFrame) ) {
                                field = jvFieldMap.get(key).get(KEY_FIELD);
                                isUpdatedField = jvFieldMap.get(key).get(KEY_IS_UPDATED);
                                if( !String.isBlank( isUpdatedField ) && (boolean) tmpChip.get( isUpdatedField ) == false ) {
                                    if( tmpChip.get(field) != 'N.A.' ) {
                                        if( field.contains('MEBES_Received__c') ){
                                            chipToUpdate.put( field, 'Not Done' );
                                        }else if( field.contains('Remote_Jobview_Setup__c') ){
                                            chipToUpdate.put( field, 'N.A.' );
                                        }else{
                                            chipToUpdate.put( field, 'Not Ready' );
                                        }
                                    }
                                } else {
                                    recordManualUpdatedError.add(field);
                                }
                            }
                        }
                        
                        lcToUpdateList.add(chipToUpdate);
                    } else { // retapeout = false
                        if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false) {
                            if( tmpChip.get(field) == 'Not Done' ) {
                                chipToUpdate.put( field, 'Done' );
                                chipToUpdate.put( lastSyncField, this.sourceTime );
                            }
                        } else { 
                            recordManualUpdatedError.add(field); 
                        }
                        
                        lcToUpdateList.add(chipToUpdate);
                    }
                    // error for fields are manual updated
                    if(!recordManualUpdatedError.isEmpty() ) {
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(String.join(recordManualUpdatedError, ', ') + ': ' + MRSCADGeneralService.MSG_FIELD_UPDATED_MANUALLY,'',false) );
                    }
                }
            }
        }

        postProcessing(lcToUpdateList);
    }
    
    /*
    * @description post processing, send out jobview ready email 
    * @param  
    * @return 
    */
    private void postProcessing(List<MRS_Layer_Chip_Association__c> lcToUpdateList) {
        
        if( !lcToUpdateList.isEmpty() ){
            
            Database.SaveResult[] updateResult = database.update(lcToUpdateList, false); //DML to update layer chip
            //this map is use to retrieve new data after perform update dml for referencing with original before update list lcToUpdateList
            map<id, mrs_layer_chip_association__c> lcToUpdateForCompare = new map<id, mrs_layer_chip_association__c>([
                SELECT ID,Chip__r.Name,Layer__r.Name,Rev__c,PTRF__r.Tech_Geo__c,Chip_Name__c,Layer_Chip_Status__c,Tapeout_Applications_MEBES_Jobview__c,
                    PTRF__c,Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,PTRF__r.Name,
                    Foundry_Frame_Remote_Jobview_Setup__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,PTRF__r.Foundry_jobview__c,Customer_Name__c,
                    Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,PTRF__r.Customer_jobview__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,PTRF__r.Order_Type__c,
                    Send_Prime_Data__c,Send_Frame_Data__c
                FROM mrs_layer_chip_association__c 
                WHERE ID IN:lcToUpdateList
            ]);
            
            list<MRS_Layer_Chip_Association__c> lcEmailList = new list<MRS_Layer_Chip_Association__c>();
            String layerUniqueIdentifier = '';
            String key = '';
            
            for (Integer i=0; i< updateResult.size(); i++) {
                key = lcToUpdateList.get(i).id;
                if( !updateResult.get(i).isSuccess() ) {
                    layerUniqueIdentifier = ptrfData.ptrfNumber + lcToUpdateForCompare.get(key).Chip__r.Name 
                    + lcToUpdateForCompare.get(key).Layer__r.Name 
                    + lcToUpdateForCompare.get(key).Rev__c;//retrieve update result
                    
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message(updateResult.get(i).getErrors().get(0).getmessage(),'',true) );
                    continue; // continue, dont do below as failures
                }
                lcEmailList.add( lcToUpdateForCompare.get(key) );
            }
            if( !lcEmailList.isEmpty()  && this.reTapeoutFlag==true ){
                MRSHandlerUtility.sendDataDoneMailToCustomerAndFoundry(lcEmailList);
            }
        }
    }
    
    /*
    * @description  build ws field map
    * @param        
    * @return       
    */
    private Map<String,Map<String,String>> getWsFieldMap() {
        Map<String,Map<String,String>> result = new Map<String,Map<String,String>>();
        //Initial field map
        result = new Map<String,Map<String,String>>{
            CHIP_PRIME => new Map<String, String>{
                KEY_FIELD       => 'Send_Prime_Data__c',
                KEY_IS_UPDATED  => 'Is_Send_Prime_Data_Updated__c',
                KEY_LAST_SYNC   => 'Last_Sync_Req_Timestamp_Send_Prime__c'
            },
            CHIP_FRAME => new Map<String, String>{
                KEY_FIELD       => 'Send_Frame_Data__c',
                KEY_IS_UPDATED  => 'Is_Send_Frame_Data_Updated__c',
                KEY_LAST_SYNC   => 'Last_Sync_Req_Timestamp_Send_Frame__c'
            }
        };
        return result;
    }
    
    /*
    * @description  build jobview field map
    * @param        
    * @return       
    */
    private Map<String,Map<String,String>> getJvFieldMap() {
        Map<String,Map<String,String>> result = new Map<String,Map<String,String>>{
            //rjv field
            CHIP_PRIME + 'CUSTOMER' => new Map<String, String>{
                KEY_FIELD       => 'Customer_Prime_Remote_Jobview_Setup__c',
                KEY_IS_UPDATED  => 'Is_Customer_Prime_Remote_Jobview_Updated__c'
            },
            CHIP_PRIME + 'FOUNDRY' => new Map<String, String>{
                KEY_FIELD       => 'Foundry_Prime_Remote_Jobview_Setup__c',
                KEY_IS_UPDATED  => 'Is_Foundry_Prime_Remote_Jobview_Updated__c'
            },
            CHIP_FRAME + 'CUSTOMER' => new Map<String, String>{
                KEY_FIELD       => 'Customer_Frame_Remote_Jobview_Setup__c',
                KEY_IS_UPDATED  => 'Is_Customer_Frame_Remote_Jobview_Updated__c'
            },
            CHIP_FRAME + 'FOUNDRY' => new Map<String, String>{
                KEY_FIELD       => 'Foundry_Frame_Remote_Jobview_Setup__c',
                KEY_IS_UPDATED  => 'Is_Foundry_Frame_Remote_Jobview_Updated__c'
            },
            //mebes received field
            //SWGP-739
            CHIP_PRIME + 'MEBES_Received__c' => new Map<String, String>{
                KEY_FIELD       => 'Prime_MEBES_Received__c',
                KEY_IS_UPDATED  => 'Is_Prime_MEBES_Received_Updated__c'
            },
            CHIP_FRAME + 'MEBES_Received__c' => new Map<String, String>{
                KEY_FIELD       => 'Frame_MEBES_Received__c',
                KEY_IS_UPDATED  => 'Is_Frame_MEBES_Received_Updated__c'
            }//SWGP-739-END
        };
        Set<String> setGroup = new Set<String>{ GROUP_GLOBALSHUTTLE, GROUP_TDTI_MPW, GROUP_MDP, GROUP_TAPEOUT_CENTRE, GROUP_FOUNDRY, GROUP_CUSTOMER };
        for(String g : setGroup){
            Map<String,String> tmpMap = new Map<String,String>{
                KEY_FIELD         => g + '_MEBES_Jobview__c',
                KEY_IS_UPDATED    => 'Is_' + g + '_MEBES_Jobview_Updated__c'
            };
            
            result.put(g + CHIP_ALL, tmpMap );
        }
        Map<String,String> tmpMap = new Map<String,String>{
            KEY_FIELD         => 'Tapeout_Applications_MEBES_Jobview__c',
            KEY_IS_UPDATED    => 'Is_Tapeout_Apps_MEBES_Jobview_Updated__c'
        };
        result.put(GROUP_TAPEOUT_APPLICATIONS + CHIP_ALL, tmpMap);
        return result;
    }
}