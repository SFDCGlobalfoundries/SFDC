public class MRSCADMEBESReceivedService extends MRSCADGeneralService{

    private Map<String,Map<String,String>> wsFieldMap;
    private Map<String,Map<String,String>> jvFieldMap;
    private MRS_CADService.MRSDataRecievedOnSyncMEBESReceive msgData;
    private string strngjobdecks;
    private string strjobviewRemarks = '';
    
    public MRSCADMEBESReceivedService(){        
        WS_CLASS_NAME       = WS_MEBES_RECEIVED;
        wsFieldMap = getWsFieldMap();
        jvFieldMap = getJvFieldMap();
        Environment_Variable__c debugMode = Environment_Variable__c.getInstance('SWIFT_CAD_WS_MEBES_RECEIVED_DEBUG'); //get debug mode for RJV
        this.isDebugMode = null != debugMode && debugMode.Value__c == 'ON' ? true : false; // if debug mode on, all response&msg will be logged
        this.activeWsName = 'MEBES Received';
    }
    
    /*
    * @description validate message format
    * @param  
    * @return 
    */
    public override Message validateFormat(String jsonMsg){
        msgData = (MRS_CADService.MRSDataRecievedOnSyncMEBESReceive)JSON.deserialize(jsonMsg, MRS_CADService.MRSDataRecievedOnSyncMEBESReceive.class);
        
        this.mst        = msgData.maskSetTitle;
        this.messageId  = msgData.messageID;
        this.sourceTime = msgData.sourceInboundRequestTimestamp; system.debug('source time: ' + sourceTime);
        String strInvalidMsg = '';
        if ( msgData.ptrf == null || msgData.ptrf.size() == 0 ) { strInvalidMsg = MSG_PTRF_REQUIRED; }
        else {
            for (MRS_CADService.ptrfdata iPTRF: msgData.ptrf) {
                this.ptrfData = iPTRF;
                if ( iPTRF.chip == null || iPTRF.chip.size() == 0 ) { strInvalidMsg = MSG_PTRF_NO_CHIP; }
                else{
                    for (MRS_CADService.chipData iChip: iPTRF.chip) {
                        this.setChipName.add(iChip.chipName);
                        if ( iChip.layer == null || iChip.layer.size() == 0 ) { strInvalidMsg = MSG_CHIP_NO_LAYER; }
                        else{
                            for (MRS_CADService.layerData iLayer: iChip.layer) {
                                this.setLayerNumber.add(iLayer.maskLayer);
                                this.setLayerRev.add(iLayer.maskRev);
                            }
                        }
                    }
                }
            }
        }
        
        if (msgData.jobdecks != null) {
            for(MRS_CADService.JobDeckData jd: msgData.jobdecks){
                if(jd != null) {
                    if(strngjobdecks == null){ strngjobdecks = jd.jobdeck; } else { strngjobdecks = strngjobdecks + '|' + jd.jobdeck; }
                }
             }
        }
        
        if (null != msgData.jobViewRemarks)  { strjobviewRemarks = msgData.jobViewRemarks; }
            
        if(!String.isBlank(strInvalidMsg)){ return new Message(strInvalidMsg,'', true); }
        return new Message('','', false);
    }
    
    /*
    * @description validate message format
    * @param  
    * @return 
    */
    public override void processWS(){
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>(); //store layer chip for updating
        List<MRS_CADService.ChipData> msgChips = msgData.ptrf.get(0).chip; //store chip data ( -> layer) from incoming message
        map<String, boolean> mapLayerChipToNotifyEmail = new map<String, boolean>(); // (layerUniqueIdentifier => reset_flag:true|false), this map is use for postProcessing()
        
        for(MRS_CADService.ChipData msgChip: msgChips) {
            
            String chipUniqueIdentifier = this.ptrfData.ptrfNumber + msgChip.chipName; //follow format in MRSCADGeneralService
            
            if( !chipNameSet.contains( msgChip.chipName ) ) {
                chipErrorMap.put( chipUniqueIdentifier, new Message(MRSCADGeneralService.MSG_CHIP_NOT_FOUND,'',true) ); //this error map will be processed in handleResponse()
                setChipNotFound.add(msgChip.chipName);//use to send missing layer/chip email
                continue;
            }
            
            for(MRS_CADService.LayerData msgLayer: msgChip.layer) {
                
                String layerUniqueIdentifier = chipUniqueIdentifier + msgLayer.maskLayer + msgLayer.maskRev;
                String frameDrtKey = ptrfFrameDRT + msgChip.chipName + msgLayer.maskLayer + msgLayer.maskRev;
                String primeDrtKey = ptrfPrimeDRT + msgChip.chipName + msgLayer.maskLayer + msgLayer.maskRev;
                
                //if( !layerUniqueIdSet.contains( layerUniqueIdentifier ) ) {
                if(!layerUniqueIdSet.contains(layerUniqueIdentifier) && !layerUniqueIdSet.contains(frameDrtKey) && !layerUniqueIdSet.contains(primeDrtKey)) {                    
                    //check in cancel list -> if in cancel list -> layer chip is cancel
                    if( layerChipCancelSet.contains( layerUniqueIdentifier ) ) { layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is cancel','',true) ); }
                    else { 
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(MRSCADGeneralService.MSG_LAYER_NOT_FOUND,'',true) );
                        setLayerNotFound.add( msgLayer.maskLayer + msgLayer.maskRev );//use to send missing layer/chip email
                    }
                    continue;
                }
                
                List<MRS_Layer_Chip_Association__c> listExistingChip = new List<MRS_Layer_Chip_Association__c>();
                if( layerChipMap.containsKey(layerUniqueIdentifier) && layerChipMap.get(layerUniqueIdentifier) != null ) {
                    listExistingChip.add(layerChipMap.get(layerUniqueIdentifier));
                }
                
                if(layerChipMap.containsKey(frameDrtKey) && layerChipMap.get(frameDrtKey) != null) {
                    listExistingChip.add(layerChipMap.get(frameDrtKey));
                }
                
                if(layerChipMap.containsKey(primeDrtKey) && layerChipMap.get(primeDrtKey) != null) {
                    listExistingChip.add(layerChipMap.get(primeDrtKey));
                }
                
                for(MRS_Layer_Chip_Association__c tmpChip: listExistingChip) {
                
                    //invalid layer status: layer is shipped or released (without retapeout)
                    if( ( tmpChip.Layer__r.Layer_Status__c == 'Released' && !msgLayer.resetFlag ) || tmpChip.Layer__r.Layer_Status__c == 'Shipped' ){
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
                    String lastSyncField    = currentFieldMap.get(KEY_LAST_SYNC);       // api name of rjv last sync date
                    String isUpdatedField   = currentFieldMap.get(KEY_IS_UPDATED);      // api name of isUpdate flag field of jv field 
                    String field            = currentFieldMap.get(KEY_FIELD);           // api name of jv field to update
                    String notifiedDate     = '';//use for jvFieldMap
                    
                    if( tmpChip.get(lastSyncField) != null && (DateTime) tmpChip.get(lastSyncField) >= DateTime.valueOf(msgData.sourceInboundRequestTimestamp) ){
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(MSG_RECORD_SYNCED,'',false) );
                    } else {
                        MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c( Id = tmpChip.Id );//Init a new object to make sure that only changed fields are save.
                        List<String> recordManualUpdatedError = new List<String>();
                        
                        chipToUpdate.put( lastSyncField, DateTime.valueOf( msgData.sourceInboundRequestTimestamp ) ); //last sync date
                        
                        if( msgLayer.resetFlag ) { // retapeout = true
                            
                            if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false ) {             
                                if( tmpChip.get(field) != 'N.A.' ) { 
                                    chipToUpdate.put( field, 'Done' );
                                }
                            } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            
                            //swgp-853
                            //if ejdv >>> remove customer mebes jobview from the field map 
                            //>>> thus customer mebes jobview will not be reset
                            if(tmpChip.get('Customer_Mebes_Jobview_By_EJDV__c') == true) jvFieldMap.remove(GROUP_CUSTOMER + CHIP_ALL);
                            
                            for( String key: jvFieldMap.keySet() ) {
                                
                                field            = jvFieldMap.get(key).get(KEY_FIELD);           // api name of jv field to update
                                notifiedDate     = jvFieldMap.get(key).get(KEY_NOTIFIED_DATE);   // api name of notified date field
                                isUpdatedField   = jvFieldMap.get(key).get(KEY_IS_UPDATED);      // api name of isUpdate flag field of jv field
                                
                                if( !String.isBlank( isUpdatedField ) && (boolean) tmpChip.get( isUpdatedField ) == false ) {
                                    if( tmpChip.get(field) != 'N.A.' ) {
                                        chipToUpdate.put( field, 'Ready' );
                                        chipToUpdate.put( notifiedDate, system.now() );
                                        mapLayerChipToNotifyEmail.put(layerUniqueIdentifier + field, true); //retapeout = true
                                    }
                                } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            }
                            
                            //swgp-853
                            //to set the field map back to its original values
                            if(tmpChip.get('Customer_Mebes_Jobview_By_EJDV__c') == true) jvFieldMap = getJvFieldMap();
                        } else { // retapeout = false
                            if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false ) {
                                if( tmpChip.get(field) == 'Not Done' ) {
                                    chipToUpdate.put( field, 'Done' );
                                }
                            } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            
                            for( String key: jvFieldMap.keySet() ) {
                                
                                notifiedDate     = jvFieldMap.get(key).get(KEY_NOTIFIED_DATE);   // api name of notified date field
                                isUpdatedField   = jvFieldMap.get(key).get(KEY_IS_UPDATED);      // api name of isUpdate flag field of jv field 
                                field            = jvFieldMap.get(key).get(KEY_FIELD);           // api name of jv field to update
                                
                                if( !String.isBlank( isUpdatedField ) && (boolean) tmpChip.get( isUpdatedField ) == false ) {
                                    if( tmpChip.get(field) == 'Not Ready' ) {
                                        chipToUpdate.put( field, 'Ready' );
                                        chipToUpdate.put( notifiedDate, system.now() );
                                        mapLayerChipToNotifyEmail.put(layerUniqueIdentifier + field, false); //retapeout = false
                                    }
                                } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            }
                        }
                        
                        // error for fields are manual updated
                        if(!recordManualUpdatedError.isEmpty()) { 
                            layerChipErrorMap.put( layerUniqueIdentifier, new Message(String.join(recordManualUpdatedError, ', ') + ': ' + MRSCADGeneralService.MSG_FIELD_UPDATED_MANUALLY,'',false) );
                        }
                        // update chip with only changed fields
                        lcToUpdateList.add(chipToUpdate);
                    }
                }
            }
        }
        
        postProcessing(lcToUpdateList, mapLayerChipToNotifyEmail);
    }
    
    /*
    * @description post processing, send out jobview ready email 
    * @param  
    * @return 
    */
    private void postProcessing(List<MRS_Layer_Chip_Association__c> lcToUpdateList, map<String, boolean> mapLayerChipToNotifyEmail) {
        
        //---FOUNDRY Jobview Ready EMAIL
        list < MRS_Layer_Chip_Association__c > TapeoutApplication_NotRetapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout false
        list < MRS_Layer_Chip_Association__c > TapeoutApplication_Retapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout true
        //---END_FOUNDRY Jobview Ready EMAIL
        
        if( !lcToUpdateList.isEmpty() ){
            
            Database.SaveResult[] updateResult = database.update(lcToUpdateList, false); //DML to update layer chip
            
            String layerUniqueIdentifier = '';
            //this map is use to retrieve new data after perform update dml for referencing with original before update list lcToUpdateList
            map<id, mrs_layer_chip_association__c> lcToUpdateForCompare = new map<id, mrs_layer_chip_association__c>([
                SELECT ID,Chip__r.Name,Layer__r.Name,Rev__c,PTRF__r.Tech_Geo__c,Chip_Name__c,Layer_Chip_Status__c,Tapeout_Applications_MEBES_Jobview__c,
                    PTRF__c,Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,
                    Foundry_Frame_Remote_Jobview_Setup__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,PTRF__r.Foundry_jobview__c,Customer_Name__c,
                    Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,PTRF__r.Customer_jobview__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,PTRF__r.Order_Type__c,
                    Tapeout_Centre_MEBES_Jobview__c,MDP_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c,GlobalShuttle_MEBES_Jobview__c,PTRF__r.Name,
                    ptrf__r.Customer_Short_Name__c
                FROM mrs_layer_chip_association__c 
                WHERE ID IN:lcToUpdateList
            ]);
            
            String key = '';
            for (Integer i=0; i< updateResult.size(); i++) {
                key = lcToUpdateList.get(i).id;
                layerUniqueIdentifier = ptrfData.ptrfNumber + lcToUpdateForCompare.get(key).Chip__r.Name + lcToUpdateForCompare.get(key).Layer__r.Name + lcToUpdateForCompare.get(key).Rev__c;//retrieve update result                
                if( !updateResult.get(i).isSuccess() ) {
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message(updateResult.get(i).getErrors().get(0).getmessage(),'',true) );
                    continue; // continue, dont do below as failures
                }
                //TO-DO email
                if(mapLayerChipToNotifyEmail.containsKey(layerUniqueIdentifier + 'Tapeout_Applications_MEBES_Jobview__c')) { //Tapeout_Applications_MEBES_Jobview__c
                    if(mapLayerChipToNotifyEmail.get(layerUniqueIdentifier + 'Tapeout_Applications_MEBES_Jobview__c') == false) { 
                        TapeoutApplication_NotRetapeout.add(lcToUpdateForCompare.get(key)); //not re-tapeout    
                    } 
                    else { 
                        TapeoutApplication_Retapeout.add(lcToUpdateForCompare.get(key)); //re-tapeout      
                    }
                }
            }

            if(!TapeoutApplication_NotRetapeout.isEmpty()) { 
                MRSHandlerUtility.sendEmailToTapeoutApplication( TapeoutApplication_NotRetapeout , strngjobdecks, strjobviewRemarks ); 
            }
            
            if(!TapeoutApplication_Retapeout.isEmpty()) { 
                MRSHandlerUtility.sendEmailToTapeoutApplicationSubsequent( TapeoutApplication_Retapeout    , strngjobdecks, strjobviewRemarks); 
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
                KEY_FIELD           => 'Prime_MEBES_Received__c',
                KEY_IS_UPDATED      => 'Is_Prime_MEBES_Received_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Receive_MEBES__c'
            },
            CHIP_FRAME => new Map<String, String>{
                KEY_FIELD           => 'Frame_MEBES_Received__c',
                KEY_IS_UPDATED      => 'Is_Frame_MEBES_Received_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Receive_MEBES__c'
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
        Map<String,Map<String,String>> result = new Map<String,Map<String,String>>();
        Set<String> setGroup = new Set<String>{ GROUP_GLOBALSHUTTLE, GROUP_TDTI_MPW, GROUP_MDP, GROUP_TAPEOUT_CENTRE, GROUP_TAPEOUT_APPLICATIONS, GROUP_FOUNDRY, GROUP_CUSTOMER };
        for(String g : setGroup){
            Map<String,String> tmpMap = new Map<String,String>{
                            KEY_FIELD         => g + '_MEBES_Jobview__c',
                            KEY_IS_UPDATED    => 'Is_' + g + '_MEBES_Jobview_Updated__c'
                        };
            String notifiedDate = g + '_MEBES_Notified_Date__c';
            if( g == GROUP_TAPEOUT_APPLICATIONS ){
                notifiedDate    = 'Tapeout_App_MEBES_Notified_Date__c';
                tmpMap.put(KEY_IS_UPDATED, 'Is_Tapeout_Apps_MEBES_Jobview_Updated__c');
            }else if( g == GROUP_FOUNDRY ){
                notifiedDate    = 'Foundry_MEBES_Jobview_Notified_Date__c';
            }else if( g == GROUP_CUSTOMER ){
                notifiedDate    = 'Customer_MEBES_Jobview_Notified_Date__c';
            }
            tmpMap.put( KEY_NOTIFIED_DATE, notifiedDate );
            
            result.put(g + CHIP_ALL, tmpMap );
        }        
        return result;
    }
    
    
    /*
    * @description  - retrieve drt chip (drt chip could belong to different ptrf)
    * @param        String mst, Set<string> setChip, Set<string> setMaskLayer, Set<string> setMaskRev, String frameDrt, String primeDrt
    * @return       list of mrs_layer_chip_association__c
    */
    public List<MRS_Layer_Chip_Association__c> retrieveMRSDRTLayerChips(String mst, Set<string> setChip, Set<string> setMaskLayer, Set<string> setMaskRev, String frameDrt, String primeDrt){
        Set<String> drtSet = new Set<String>{ frameDrt, primeDrt };
        return [SELECT  PTRF__r.Tech_Geo__c,                    Layer_Name__c,                                  lastmodifieddate_sgt__c,
                        Tech_Geo__c,                            Tapeout_Centre_MEBES_Jobview__c,                Tapeout_Centre_MEBES_Jobview_Date__c,   
                        Tapeout_Applications_MEBES_Jobview__c,  Tapeout_Applications_MEBES_Jobview_Date__c,     TDTI_MPW_MEBES_Jobview__c,
                        TDTI_MPW_MEBES_Date__c,                 Send_Prime_Data__c,                             Send_Prime_Data_Date__c,
                        Send_Frame_Data__c,                     Send_Frame_Data_Date__c,                        Rev__c,DRT_Name__c,DRT__c,
                        ROM_Code__c,                            Prime_TapeOut__c,                               Prime_MEBES_Received__c,
                        Prime_MEBES_Received_Date__c,           PTRF__c,                                        PTRF_Number__c,
                        ORC__c,                                 ORC_Date__c,                                    Name,
                        Mask_Set_Title_Name__c,                 Mask_Layer__c,                                  Mask_Layer_Status__c,
                        MST__c,                                 MDP_MEBES_Jobview__c,                           MDP_MEBES_Jobview_Date__c,
                        Layer__r.Mask_Layer_Rev__c,             Layer__r.ROM_Code__c,                           PTRF__r.Customer_jobview__c,
                        PTRF__r.Foundry_Jobview__c,             PTRF__r.Order_Type__c,                          PTRF__r.MaskSetTitle__c,
                        PTRF__r.MaskSetTitle__r.Name,           Customer_Name__r.Name,                          PTRF__r.Name,
                        Chip__r.Name,                           Layer__r.Name,                                  Customer_Name__r.Short_Name__c,
                        Layer_Send_Prime_Data__c,               Layer_Send_Frame_Data__c,                       Layer_Chip_Status__c,
                        Layer_Chip_Status_Date__c,              Layer_Chip_Old_Status__c,                       Last_Sync_Req_Timestamp__c,
                        Last_Sync_Req_Timestamp_Send_Prime__c,  Last_Sync_Req_Timestamp_Send_Frame__c,          Last_Sync_Req_Timestamp_Remote_JobCust__c,
                        Last_Sync_Req_Timestamp_ORCN_Job__c,    Last_Sync_Req_Timestamp_Receive_MEBES__c,       Last_Sync_Req_Timestamp_Remote_Jobview__c,
                        Last_Sync_Req_Timestamp_Layer_Gen__c,   Is_Tapeout_Centre_MEBES_Jobview_Updated__c,     Is_Tapeout_Apps_MEBES_Jobview_Updated__c,
                        Is_TDTI_MPW_MEBES_Jobview_Updated__c,   Is_Send_Prime_Data_Updated__c,                  Is_Send_Frame_Data_Updated__c,
                        Is_Prime_MEBES_Received_Updated__c,     Is_ORC_Updated__c,                              Is_MDP_MEBES_Jobview_Updated__c,
                        Is_Frame_MEBES_Received_Updated__c,     Is_Foundry_Prime_Remote_Jobview_Updated__c,     Is_GlobalShuttle_MEBES_Jobview_Updated__c,
                        Is_Foundry_MEBES_Jobview_Updated__c,    Is_Foundry_GDSOUT_Review_Updated__c,            Is_Foundry_Frame_Remote_Jobview_Updated__c,
                        Is_Foundry_Frame_Mockup_Updated__c,     Is_DRW_Updated__c,                              Is_Customer_Prime_Remote_Jobview_Updated__c,
                        Is_Customer_MEBES_Jobview_Updated__c,   Is_Customer_GDSOUT_Review_Updated__c,           Is_Customer_Frame_Remote_Jobview_Updated__c,
                        Is_Customer_Frame_Mockup_Updated__c,    Is_Active__c,                                   IsDeleted,
                        Id,                                     GlobalShuttle_MEBES_Jobview__c,                 GlobalShuttle_MEBES_Jobview_Date__c,
                        Frame_TapeOut__c,                       Frame_MEBES_Received__c,                        Frame_MEBES_Received_Date__c,
                        Foundry_Prime_Remote_Jobview_Setup__c,  Foundry_Prime_Remote_Jobview_Setup_Date__c,     Foundry_MEBES_Jobview__c,
                        Foundry_MEBES_Jobview_Date__c,          Foundry_GDSOUT_Review__c,                       Foundry_GDSOUT_Review_Date__c,
                        Foundry_Frame_Remote_Jobview_Setup__c,  Foundry_Frame_Remote_Jobview_Setup_Date__c,     Foundry_Frame_Mockup__c,
                        Foundry_Frame_Mockup_Date__c,           Customer_Prime_Remote_Jobview_Setup__c,         Customer_Prime_Remote_Jobview_Setup_Date__c,
                        Customer_Name__c,                       Customer_MEBES_Jobview__c,                      Customer_MEBES_Jobview_Date__c,
                        Customer_GDSOUT_Review__c,              Customer_GDSOUT_Review_Date__c,                 Customer_Frame_Remote_Jobview_Setup__c,
                        Customer_Frame_Mockup__c,               Customer_Frame_Mockup_Date__c,                  Customer_Frame_Remote_Jobview_Setup_Date__c,
                        Chip__c,DRW__c,PTRF__r.Status__c,       PTRF__r.Customer_Short_Name__c,                 Chip_Name__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,                         
                        Layer__r.Layer_Status__c,               PTRF_Or_DRT__c,              
                        //,swgp-853: retrieve flag for ejdv      
                        Customer_Mebes_Jobview_By_EJDV__c               
                FROM MRS_Layer_Chip_Association__c                         
                WHERE   Chip_Name__c    IN   :setChip 
                    AND PTRF_Or_DRT__c  =    'DRT'
                    AND DRT_Name__c    IN    :drtSet
                    AND Mask_Layer__c   IN   :setMaskLayer 
                    AND rev__c          IN   :setmaskrev 
                    AND MST__c          =    :mst
        ];
    }
    
    /*
    * @description  - override general's method, as mebes received ws handle both ptrf chip and drt chip
    *               - this override method return the combination of both ptrf chip and drt chip into a single list 
    * @param        none
    * @return       list of mrs_layer_chip_association__c
    */
    public override List<MRS_Layer_Chip_Association__c> retrievePtrfChip() {
        
        String layerUniqueIdentifier    = '';
        String chipUniqueIdentifier     = '';
        List<MRS_Layer_Chip_Association__c> lcList = retrieveMRSLayerChips(mst, ptrfData.ptrfNumber, setChipName, setLayerNumber, setLayerRev);//list of ptrf chip
        List<MRS_Layer_Chip_Association__c> lcList2 = retrieveMRSDRTLayerChips(mst, this.setChipName, this.setLayerNumber, this.setLayerRev, this.ptrfFrameDRT, this.ptrfPrimeDRT);
        lcList.addAll(lcList2);
        
        for(MRS_Layer_Chip_Association__c lc : lcList){
            
            //Add Layer Number, Layer Rev, Chip name...to data sets, if drt chip: include DRT name to key
            if(lc.PTRF_Or_DRT__c == 'PTRF') {
                chipUniqueIdentifier    = lc.PTRF__r.Name + lc.Chip__r.Name;
                layerUniqueIdentifier   = chipUniqueIdentifier + lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;    
            } else {
                chipUniqueIdentifier    = lc.DRT_Name__c + lc.Chip__r.Name;
                layerUniqueIdentifier   = chipUniqueIdentifier + lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;
            }
            
            if( !chipUniqueIdSet.contains( chipUniqueIdentifier ) )     { chipUniqueIdSet.add(chipUniqueIdentifier);        }
            if( !chipNameSet.contains(lc.Chip__r.Name) )                { chipNameSet.add(lc.Chip__r.Name);                 }
            if( !layerNumberSet.contains(lc.Layer__r.Name) )            { layerNumberSet.add(lc.Layer__r.Name);             }
            if( !layerRevSet.contains(lc.Layer__r.Mask_Layer_Rev__c) )  { layerRevSet.add(lc.Layer__r.Mask_Layer_Rev__c);   }
            
            if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ){
                if(lc.Layer_Chip_Status__c == 'Cancel') {
                    layerChipCancelSet.add(layerUniqueIdentifier);    
                } else {
                    layerUniqueIdSet.add(layerUniqueIdentifier);
                    layerChipMap.put(layerUniqueIdentifier, lc);    
                }
            }
        }

        return lcList;
    }
}