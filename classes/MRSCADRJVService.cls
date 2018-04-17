public class MRSCADRJVService extends MRSCADGeneralService {

    private map<String,Map<String,String>>                      jvGroupFieldMap;//FOUNDRY or CUSTOMER MEBES JV Fields
    private map<String,Map<String,String>>                      jobviewFieldMap;//others mebes JV Fields(GlobalShuttle_MEBES_Jobview,TDTI_MPW_MEBES_Jobview,MDP_MEBES_Jobview,Tapeout_Centre_MEBES_Jobview,Tapeout_Applications_MEBES_Jobview)
    private MRS_CADService.MRSDataRecievedOnSyncRemoteJobView   msgData; // contains data from ws message
    private String                                              stremaillist; //jv email recipients
    private String                                              strjobviewRemarks; //
    private String                                              strngjobviews = ''; //
    private String                                              jvGroup; //initialize data in processWS()
    //==========================================
    /*
    * @description constructor, override MRSCADGeneralService properties if needed
    * @param  
    * @return 
    */
    public MRSCADRJVService() {        
        jvGroupFieldMap = getJvGroupFields();
        jobviewFieldMap = getJobviewFields();
        this.WS_CLASS_NAME = MRSCADGeneralService.WS_REMOTE_JOBVIEW;
        Environment_Variable__c debugMode = Environment_Variable__c.getInstance('SWIFT_CAD_WS_RJV_DEBUG'); //get debug mode for RJV
        this.isDebugMode = null != debugMode && debugMode.Value__c == 'ON' ? true : false; // if debug mode on, all response&msg will be logged
        this.activeWsName = 'Remote Jobview';
    }
    
    /*
    * @description validate message format
    * @param  
    * @return 
    */
    public override Message validateFormat(String jsonMsg) {
        // deserialize json to object and use through-out this service
        msgData = (MRS_CADService.MRSDataRecievedOnSyncRemoteJobView)JSON.deserialize(jsonMsg, MRS_CADService.MRSDataRecievedOnSyncRemoteJobView.class);

        this.mst                = msgData.maskSetTitle;
        this.messageId          = msgData.messageID;
        this.sourceTime         = msgData.sourceInboundRequestTimestamp;
        String strInvalidMsg    = '';
        
        if ( msgData.jobview == null || msgData.jobview.size() == 0 ) { strInvalidMsg = MSG_JOBVIEW_REQUIRED; } 
        else {
            for(MRS_CADService.jobviewdata jobview: msgData.jobview) {
                if( null == jobview.ptrf || jobview.ptrf.size() == 0 ) { strInvalidMsg = MSG_PTRF_REQUIRED; } 
                else {
                    for (MRS_CADService.ptrfdata iPTRF: jobview.ptrf) {
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
                // jobview extraction
                if (null != jobview.JobDecks) { 
                    
                    for (MRS_CADService.jobdeckdata jd: jobview.jobdecks) {
                         
                        if (strngjobviews == null) strngjobviews = jd.jobdeck; 
                        else strngjobviews = strngjobviews + jd.jobdeck; 
                    } 
                }
                
                //list of email address which is sent from CAD
                if (null == stremaillist) stremaillist = jobview.emailToList; 
                else stremaillist = stremaillist + ';' + jobview.emailToList; 
                
                //jobviewer remarks info, currently not in use at MRS
                if (null == strjobviewRemarks) strjobviewRemarks = jobview.jobViewRemarks; 
                else strjobviewRemarks = strjobviewRemarks + jobview.jobViewRemarks; 
            }
        }
        
        if(!String.isBlank(strInvalidMsg)) return new Message(strInvalidMsg,'', true);        
        return new Message('','', false);
    }
    
    /*
    * Override processWS() in MRSCADGeneralService for particular RJV WS
    * @description 
    * @param  
    * @return 
    */
    public override void processWS() {
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>(); //store layer chip for updating
        List<MRS_CADService.ChipData> msgChips = msgData.jobView.get(0).ptrf.get(0).chip; //store chip data ( -> layer) from incoming message
        map<String, boolean> mapLayerChipToNotifyEmail = new map<String, boolean>(); // (layerUniqueIdentifier => reset_flag:true|false), this map is use for postProcessing()
        jvGroup = msgData.jobView.get(0).jobViewGroup.trim().toUpperCase(); //CUSTOMER of FOUNDRY or EJDV
        boolean ejdvFlag = jvGroup.equalsIgnoreCase('EJDV') ? true : false;//swgp-853
        
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
                
                //if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ) {
                if(!layerUniqueIdSet.contains(layerUniqueIdentifier) && !layerUniqueIdSet.contains(frameDrtKey) && !layerUniqueIdSet.contains(primeDrtKey)) {
                    //check in cancel list -> if in cancel list -> layer chip is cancel
                    if( layerChipCancelSet.contains( layerUniqueIdentifier ) ) { layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is cancel','',true) ); }
                    else { 
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(MRSCADGeneralService.MSG_LAYER_NOT_FOUND,'',true) );
                        setLayerNotFound.add( msgLayer.maskLayer + msgLayer.maskRev );//use to send missing layer/chip email
                    }
                    continue;
                }
                
                //MRS_Layer_Chip_Association__c tmpChip = layerChipMap.get(layerUniqueIdentifier);
                List<MRS_Layer_Chip_Association__c> listExistingChip = new List<MRS_Layer_Chip_Association__c>();
                
                //=================================================================================
                if( layerChipMap.containsKey(layerUniqueIdentifier) && layerChipMap.get(layerUniqueIdentifier) != null ) {
                    listExistingChip.add(layerChipMap.get(layerUniqueIdentifier));
                }
                
                if(layerChipMap.containsKey(frameDrtKey) && layerChipMap.get(frameDrtKey) != null) {
                    listExistingChip.add(layerChipMap.get(frameDrtKey));
                }
                
                if(layerChipMap.containsKey(primeDrtKey) && layerChipMap.get(primeDrtKey) != null) {
                    listExistingChip.add(layerChipMap.get(primeDrtKey));
                }
                //=================================================================================
                
                for(MRS_Layer_Chip_Association__c tmpChip: listExistingChip) {
                    
                    //swgp-853
                    //if jvgroup = CUSTOMER AND Customer_Mebes_Jobview_By_EJDV__c = TRUE
                    //>>> CONTINUE
                    if(jvGroup.equalsIgnoreCase(MRSCADGeneralService.GROUP_CUSTOMER) && tmpChip.Customer_Mebes_Jobview_By_EJDV__c == true) {
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message('This chip is triggered from EJDV, Customer_RJV is rejected','',false) );
                        continue;
                    }

                    if(null != tmpChip.PTRF_Or_DRT__c && tmpChip.PTRF_Or_DRT__c == 'DRT') {
                        //DRT chip does not need RJV signal -> Do nothing: no update
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message('RJV is not required for DRT chip','',false) );
                        continue;
                    }
                
                    //invalid layer status: layer is shipped or released (without retapeout)
                    if( ( tmpChip.Layer__r.Layer_Status__c == 'Released' && !msgLayer.resetFlag ) ||  tmpChip.Layer__r.Layer_Status__c == 'Shipped' ){
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer is ' + tmpChip.Layer__r.Layer_Status__c,'',false) ); 
                        continue;
                    }
                    
                    //invalid layer chip status, only Not Ready / In Progress / Released are processed
                    if( !MRSCADGeneralService.VALID_LAYER_CHIP_STATUS.containsIgnoreCase(tmpChip.Layer_Chip_Status__c.trim()) ) {
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message('Layer chip is ' + tmpChip.Layer_Chip_Status__c,'',false) );
                        continue;
                    }
                    
                    String primeOrFrame = msgChip.chipName.equalsIgnoreCase(MRSCADGeneralService.CHIP_FRAME) ? MRSCADGeneralService.CHIP_FRAME : MRSCADGeneralService.CHIP_PRIME; //Prime of Frame chip
                    
                    map<String,String> currentFieldMap = jvGroupFieldMap.get(jvGroup + '_' + primeOrFrame);
                    String field            = currentFieldMap.get(KEY_FIELD);           // api name of jv field to update
                    String isUpdatedField   = currentFieldMap.get(KEY_IS_UPDATED);      // api name of isUpdate flag field of jv field 
                    String lastSyncField    = currentFieldMap.get(KEY_LAST_SYNC);       // api name of rjv last sync date
                    String rjvField         = currentFieldMap.get(KEY_RJV);             // api name of rjv field
                    String rjvFieldIsUpdated= currentFieldMap.get(KEY_RJV_IS_UPDATED);
                    String notifiedDate     = currentFieldMap.get(KEY_NOTIFIED_DATE);   // api name of notified date of jv field
                    
                    if( tmpChip.get(lastSyncField) != null && (DateTime) tmpChip.get(lastSyncField) >= DateTime.valueOf(msgData.sourceInboundRequestTimestamp) ){
                        layerChipErrorMap.put( layerUniqueIdentifier, new Message(MSG_RECORD_SYNCED,'',false) );
                    }else{
                        List<String> recordManualUpdatedError = new List<String>();
                        
                        MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c( Id = tmpChip.Id );//Init a new object to make sure that only changed fields are save.
                        if( !String.isBlank( rjvFieldIsUpdated ) && (boolean) tmpChip.get( rjvFieldIsUpdated ) == false ) {
                            chipToUpdate.put( rjvField, 'Done' );
                        } else { recordManualUpdatedError.add(rjvField); } // Record has been manually updated
                        
                        chipToUpdate.put( lastSyncField, DateTime.valueOf( msgData.sourceInboundRequestTimestamp ) );
                        
                        if( msgLayer.resetFlag ) { // retapeout = true
                            if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false ) {
                                if( tmpChip.get(field) != 'N.A.' ) {
                                    chipToUpdate.put( field, 'Ready' );
                                    chipToUpdate.put( notifiedDate, system.now() );
                                    mapLayerChipToNotifyEmail.put(layerUniqueIdentifier, true); //retapeout = true
                                }   
                            } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            
                            for( String key: jobviewFieldMap.keySet() ) {
                                if( key.containsIgnoreCase( msgData.jobView.get(0).jobViewGroup.trim() ) && key.containsIgnoreCase(primeOrFrame) ) {
                                    field = jobviewFieldMap.get(key).get(KEY_FIELD);
                                    isUpdatedField = jobviewFieldMap.get(key).get(KEY_IS_UPDATED);
                                    notifiedDate = jobviewFieldMap.get(key).get(KEY_NOTIFIED_DATE);
                                    if( !String.isBlank( isUpdatedField ) && (boolean) tmpChip.get( isUpdatedField ) == false ) {
                                        if( tmpChip.get(field) != 'N.A.' ) {
                                            chipToUpdate.put( field, 'Ready' );
                                            chipToUpdate.put( notifiedDate, system.now() );
                                            mapLayerChipToNotifyEmail.put(layerUniqueIdentifier + field, true); //retapeout = true
                                        }
                                    } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                                }
                            }
                        } else { // retapeout = false
                            if( !String.isBlank( isUpdatedField ) && tmpChip.get(isUpdatedField) == false ) {
                                if( tmpChip.get(field) == 'Not Ready' ) {
                                    chipToUpdate.put( field, 'Ready' );
                                    chipToUpdate.put( notifiedDate, system.now() );
                                    mapLayerChipToNotifyEmail.put(layerUniqueIdentifier, false); //retapeout = false
                                }
                            } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                            
                            for( String key: jobviewFieldMap.keySet() ) {
                                if( key.containsIgnoreCase( msgData.jobView.get(0).jobViewGroup.trim() ) && key.containsIgnoreCase(primeOrFrame) ) {
                                    field = jobviewFieldMap.get(key).get(KEY_FIELD);
                                    isUpdatedField = jobviewFieldMap.get(key).get(KEY_IS_UPDATED);
                                    notifiedDate = jobviewFieldMap.get(key).get(KEY_NOTIFIED_DATE);
                                    if( !String.isBlank( isUpdatedField ) && tmpChip.get( isUpdatedField ) == false ) {                                         
                                        if( tmpChip.get(field) == 'Not Ready' ) {
                                            chipToUpdate.put( field, 'Ready' );
                                            chipToUpdate.put( notifiedDate, system.now() );
                                            mapLayerChipToNotifyEmail.put(layerUniqueIdentifier + field, false); //retapeout = false
                                        }
                                    } else { recordManualUpdatedError.add(field); } // Record has been manually updated
                                }
                            }
                        }
                        // error for fields are manual updated
                        if(!recordManualUpdatedError.isEmpty()) { 
                            layerChipErrorMap.put( layerUniqueIdentifier, new Message(String.join(recordManualUpdatedError, ', ') + ': ' + MRSCADGeneralService.MSG_FIELD_UPDATED_MANUALLY,'',false) ); 
                        }
                        
                        //swgp-853
                        //ejdvFlag was set a begin of this function
                        //if this rjv is triggered by ejdv >>> set Customer_Mebes_Jobview_By_EJDV to TRUE
                        //>>> flag this layer chip is ejdv
                        chipToUpdate.put('Customer_Mebes_Jobview_By_EJDV__c', ejdvFlag);
                        //swgp-853-end
                        
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
        
        //---FOUNDRY | CUSTOMER RJV EMAIL
        list < MRS_Layer_Chip_Association__c > layerChipUpdateSuccess_NotRetapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout false
        list < MRS_Layer_Chip_Association__c > layerChipUpdateSuccess_Retapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout true
        //---END_FOUNDRY | CUSTOMER RJV EMAIL
        //---Tapeout App Jobview Ready EMAIL
        list < MRS_Layer_Chip_Association__c > TapeoutApplication_NotRetapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout false
        list < MRS_Layer_Chip_Association__c > TapeoutApplication_Retapeout = new list < MRS_Layer_Chip_Association__c > (); //re-tapeout true
        //---END_Tapeout App Jobview Ready EMAIL
        
        if( !lcToUpdateList.isEmpty() ){
            boolean isCustomerJv = jvGroup == 'CUSTOMER' ? true : false;
            String layerUniqueIdentifier;
            Database.SaveResult[] updateResult = database.update(lcToUpdateList, false); //DML to update layer chip
            //this map is use to retrieve new data after perform update dml for referencing with original before update list lcToUpdateList
            map<id, mrs_layer_chip_association__c> lcToUpdateForCompare = new map<id, mrs_layer_chip_association__c>([
                SELECT ID,Chip__r.Name,Layer__r.Name,Rev__c,PTRF__r.Tech_Geo__c,Chip_Name__c,Layer_Chip_Status__c,Tapeout_Applications_MEBES_Jobview__c,
                    PTRF__c,Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,Foundry_Prime_Remote_Jobview_Setup__c,PTRF__r.Name,
                    Foundry_Frame_Remote_Jobview_Setup__c,Customer_MEBES_Jobview__c,Foundry_MEBES_Jobview__c,PTRF__r.Foundry_jobview__c,Customer_Name__c,
                    Layer__r.ROM_Code__c,Layer__r.Mask_Layer_Rev__c,PTRF__r.Customer_jobview__c,PTRF__r.Process_Technology_Lifecycle_Phase__c,PTRF__r.Order_Type__c ,
                    ptrf__r.Customer_Short_Name__c
                FROM mrs_layer_chip_association__c 
                WHERE ID IN:lcToUpdateList
            ]);
            String key = '';//hold id of current layer chip, as updateResult dont hold the id of record when failure
            for (Integer i=0; i< updateResult.size(); i++) {
                key = lcToUpdateList.get(i).id;
                layerUniqueIdentifier = ptrfData.ptrfNumber + lcToUpdateForCompare.get(key).Chip__r.Name 
                    + lcToUpdateForCompare.get(key).Layer__r.Name 
                    + lcToUpdateForCompare.get(key).Rev__c;//retrieve update result
                                   
                if( !updateResult.get(i).isSuccess() ) {
                    layerChipErrorMap.put( layerUniqueIdentifier, new Message(updateResult.get(i).getErrors().get(0).getmessage(),'',true) );
                    continue; // continue, dont do below as failures
                }
                //if the data update success (mean only jobview status change from not ready to ready will trigger email)
                if(mapLayerChipToNotifyEmail.containsKey(layerUniqueIdentifier)) {
                    if(mapLayerChipToNotifyEmail.get(layerUniqueIdentifier) == false) { 
                        layerChipUpdateSuccess_NotRetapeout.add(lcToUpdateForCompare.get(key)); //not re-tapeout   
                    }  
                    else { 
                        layerChipUpdateSuccess_Retapeout.add(lcToUpdateForCompare.get(key)); //re-tapeout     
                    }
                } 
                if(mapLayerChipToNotifyEmail.containsKey(layerUniqueIdentifier + 'Tapeout_Applications_MEBES_Jobview__c')) { //Tapeout_Applications_MEBES_Jobview__c
                    if(mapLayerChipToNotifyEmail.get(layerUniqueIdentifier + 'Tapeout_Applications_MEBES_Jobview__c') == false) { 
                        TapeoutApplication_NotRetapeout.add(lcToUpdateForCompare.get(key)); //not re-tapeout    
                    } 
                    else { 
                        TapeoutApplication_Retapeout.add(lcToUpdateForCompare.get(key)); //re-tapeout      
                    }
                }
            }
           
            if(!layerChipUpdateSuccess_NotRetapeout.isEmpty())  { 
                MRSHandlerUtility.sendDoneEmailtoRemoteJobView( layerChipUpdateSuccess_NotRetapeout , strngjobviews, isCustomerJv,      !isCustomerJv, strjobviewRemarks ); 
            }
            if(!layerChipUpdateSuccess_Retapeout.isEmpty())     { 
                MRSHandlerUtility.sendDoneEmailtoRemoteJobView( layerChipUpdateSuccess_Retapeout    , strngjobviews, isCustomerJv,      !isCustomerJv, strjobviewRemarks ); 
            }
            if(!TapeoutApplication_NotRetapeout.isEmpty())      { 
                MRSHandlerUtility.sendEmailToTapeoutApplication( TapeoutApplication_NotRetapeout     , strngjobviews, strjobviewRemarks); 
            }
            if(!TapeoutApplication_Retapeout.isEmpty())         { 
                MRSHandlerUtility.sendEmailToTapeoutApplicationSubsequent( TapeoutApplication_Retapeout        , strngjobviews, strjobviewRemarks); 
            }
        }
    }
    
    /*
    * @description build Customer/Foundry Remote jobview set of fields
    * @param  
    * @return 
    */
    private map<String,Map<String,String>> getJvGroupFields() {
        map<String,Map<String,String>> result = new map<String,Map<String,String>>();
        result = new Map<String,Map<String,String>> {
            'EJDV_' + MRSCADGeneralService.CHIP_PRIME => new Map<String, String>{
                KEY_FIELD           => 'Customer_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Customer_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_JobCust__c',
                KEY_RJV             => 'Customer_Prime_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Customer_Prime_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Customer_MEBES_Jobview_Notified_Date__c'
            },
            'EJDV_' + MRSCADGeneralService.CHIP_FRAME => new Map<String, String>{
                KEY_FIELD           => 'Customer_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Customer_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_JobCust__c',
                KEY_RJV             => 'Customer_Frame_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Customer_Frame_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Customer_MEBES_Jobview_Notified_Date__c'
            },
            'CUSTOMER_' + MRSCADGeneralService.CHIP_PRIME => new Map<String, String>{
                KEY_FIELD           => 'Customer_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Customer_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_JobCust__c',
                KEY_RJV             => 'Customer_Prime_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Customer_Prime_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Customer_MEBES_Jobview_Notified_Date__c'
            },
            'CUSTOMER_' + MRSCADGeneralService.CHIP_FRAME => new Map<String, String>{
                KEY_FIELD           => 'Customer_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Customer_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_JobCust__c',
                KEY_RJV             => 'Customer_Frame_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Customer_Frame_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Customer_MEBES_Jobview_Notified_Date__c'
            },
            'FOUNDRY_' + MRSCADGeneralService.CHIP_PRIME => new Map<String, String>{
                KEY_FIELD           => 'Foundry_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Foundry_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_Jobview__c',
                KEY_RJV             => 'Foundry_Prime_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Foundry_Prime_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Foundry_MEBES_Jobview_Notified_Date__c'
            },
            'FOUNDRY_' + MRSCADGeneralService.CHIP_FRAME => new Map<String, String>{
                KEY_FIELD           => 'Foundry_MEBES_Jobview__c',
                KEY_IS_UPDATED      => 'Is_Foundry_MEBES_Jobview_Updated__c',
                KEY_LAST_SYNC       => 'Last_Sync_Req_Timestamp_Remote_Jobview__c',
                KEY_RJV             => 'Foundry_Frame_Remote_Jobview_Setup__c',
                KEY_RJV_IS_UPDATED  => 'Is_Foundry_Frame_Remote_Jobview_Updated__c',
                KEY_NOTIFIED_DATE   => 'Foundry_MEBES_Jobview_Notified_Date__c'
            }
        };
        return result;
    }

    /*
    * @description build jobview fields set
    *        - GlobalShuttle_MEBES_Jobview
    *        - TDTI_MPW_MEBES_Jobview
    *        - MDP_MEBES_Jobview
    *        - Tapeout_Centre_MEBES_Jobview
    *        - Tapeout_Applications_MEBES_Jobview
    * @param  
    * @return 
    */
    private map<String,Map<String,String>> getJobviewFields() {
        
        map<String,Map<String,String>> result = new map<String,Map<String,String>>();
        Set<String> setGroup = new Set<String>{ GROUP_GLOBALSHUTTLE, GROUP_TDTI_MPW, GROUP_MDP, GROUP_TAPEOUT_CENTRE, GROUP_TAPEOUT_APPLICATIONS };
        for(String g : setGroup){
            String notifiedDate = g + '_MEBES_Notified_Date__c';
            String isUpdate     = 'Is_' + g + '_MEBES_Jobview_Updated__c';
            if( g == GROUP_TAPEOUT_APPLICATIONS ){
                notifiedDate    = 'Tapeout_App_MEBES_Notified_Date__c';
                isUpdate        = 'Is_Tapeout_Apps_MEBES_Jobview_Updated__c';
            }
            Map<String,String> tmpMap = new Map<String,String>{
                KEY_FIELD           => g + '_MEBES_Jobview__c', 
                KEY_IS_UPDATED      => isUpdate,
                KEY_NOTIFIED_DATE   => notifiedDate
            };
            result.put( 'FOUNDRY' + g + CHIP_ALL, tmpMap );
            result.put( 'EJDV' + g + CHIP_ALL, tmpMap );//SWGP-649
        }
        
        Map<String,String> tmpMap = new Map<String,String>{
            KEY_FIELD           => 'Foundry_MEBES_Jobview__c',
            KEY_IS_UPDATED      => 'Is_Foundry_MEBES_Jobview_Updated__c',
            KEY_NOTIFIED_DATE   => 'Foundry_MEBES_Jobview_Notified_Date__c'
        };
        result.put( 'EJDV' + 'Foundry' + CHIP_ALL, tmpMap );//SWGP-649
        
        return result;
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
}