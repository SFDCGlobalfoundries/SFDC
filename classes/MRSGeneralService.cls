/*
* This class defines common actions for review/jobview approval. 
* It also provides virtual methods so that subclass can override to handle a specific type of request.
*/
public virtual class MRSGeneralService {

    //Valid sources
    public static String SOURCE_MDP             = 'Swift_MDP';
    public static String SOURCE_TDTI_MPW        = 'Swift_TDTI_MPW';
    //Valid approval types
    public static String MDP_MEBES_JOBVIEW      = 'MDP_MEBES_Jobview';
    public static String TDTI_MEBES_JOBVIEW     = 'TDTI_MPW_MEBES_Jobview';
    public static String FOUNDRY_MEBES_JOBVIEW  = 'Foundry_MEBES_Jobview';
    public static String CUSTOMER_MEBES_JOBVIEW = 'Customer_MEBES_Jobview';    
    //Keys mapped to Layer Chip fields to be updated
    public static String FIELD_JV               = 'Jobview';
    public static String FIELD_APPROVAL_DATE    = 'ApprovalDate';
    public static String FIELD_APPROVER         = 'Approver';
    //Config parameters
    public static String DEBUG_MODE             = loadEnvVariable('SWIFT_MRS_Approval_DEBUG_MODE', 'ON');// Default ON - log all validation errors. If OFF - just log unhandled exceptions
    public static String BYPASS_USER_VALIDATION = loadEnvVariable('SWIFT_MRS_BYPASS_USER_VALIDATION', 'ON');// By default user must exist in MRS system & belong to appropriate group
    public static String WS_ONOFF               = loadEnvVariable('SWIFT_MRS_Approval_OnOff', 'ON');// If OFF: deny all requests.
    public static String WS_ENDPOINT            = loadEnvVariable('SWIFT_MRS_Approval_EndPoint', 'http://google.com');
    //For testing purpose
    public static String TESTING_MODE           = loadEnvVariable('SWIFT_MRS_Approval_Testing_Mode', null);//Log all incoming & outgoing messages
    public static String CONCURRENCY_ERROR_MSG  = 'unable to obtain exclusive access to this record';

    /*
    * @description fetch appropriate service to handle incoming request
    * @param approvalField 
    */
    public static MRSGeneralService fetchService(String approvalField){
        
        if(approvalField == MDP_MEBES_JOBVIEW) 
        {
            return new MRSMDPService();
        } 
        else if(approvalField == TDTI_MEBES_JOBVIEW || approvalField == FOUNDRY_MEBES_JOBVIEW) 
        {
            //SWGP-557 - Combine Foundry and TDTI into 1 call
            return new MRSFoundryMEBESJVService();//return new MRSTDTIMPWService();
        } 
        else if(approvalField == CUSTOMER_MEBES_JOBVIEW) 
        {
            return new MRSCustomerMEBESJVService();//SWGP-631 - New ws from mdp to update customer mebes jobview
        }
        
        //should not reach here
        return new MRSGeneralService();
    }
    
    /*
    * @description handle approval request
    */
    public void handleRequest(MRSApprovalService.MRSApprovalMsg msg) {
        
        //if(TESTING_MODE=='ON') MRSApprovalUtility.logValidationError(new Message('Log incoming request','',true), msg);
        try{
            Message validationMsg = initialValidation(msg);
            if(validationMsg.isError){
                if( isValidationErrorLogged() ) MRSApprovalUtility.logValidationError(validationMsg, msg);
                handleResponse(msg, validationMsg);
                return;
            }
            //Test unhandled exception
            if(msg.messageId=='TestUnhandledException' && TESTING_MODE=='ON'){
                Integer i = Integer.valueOf( '1.o' );
            }
            performApproval(msg);
        } catch(Exception ex) {
            //Log exception & send error email
            SWIFT_Application_Log__c log = MRSApprovalUtility.logUnhandledException(ex, msg);
            MRSApprovalUtility.sendErrorEmail(ex, msg,  String.valueOf(log.Id));
            String errorMsg = ex.getMessage();
            if( errorMsg.containsIgnoreCase ( CONCURRENCY_ERROR_MSG ) ){ errorMsg = CONCURRENCY_ERROR_MSG; }
            handleResponse( msg, new Message(errorMsg, '', true) );
        }
    }
    
    /*
    * @description Validate if a message is valid
    * @param msg An instance of MRSApprovalService.MRSApprovalMsg
    * @return An instance of Message
    */
    public Message initialValidation(MRSApprovalService.MRSApprovalMsg msg) {
        
        if( String.isBlank(msg.source) || !getSources().contains(msg.source)){//Invalid Source
            return new Message('Invalid Source: ' + msg.source,'', true);
        }else{
            //Valid source
            //Invalid Status update
            //if( !getFields().contains(msg.statusType) ) return new Message('Invalid approval field: ' + msg.statusType, '', true);            
            if( !String.valueOf(getFields()).containsIgnoreCase(msg.statusType) ) return new Message('Invalid approval field: ' + msg.statusType, '', true);
            if((String.isBlank(msg.employeeID) || MRSApprovalUtility.getUserFromEmployeeID( msg.employeeID, msg.source )==null)) if( !'ON'.equalsIgnoreCase(BYPASS_USER_VALIDATION)) return new Message('Invalid Employee ID: ' + msg.employeeID,'', true);
        }
        //Invalid MST or PTRF Number
        if( String.isBlank(msg.ptrfNumber) ||  String.isBlank(msg.maskSetTitle) ) return new Message('Mask Set Title & PTRF Number must not be empty.','', true);
        
        Message msgPTRFValidation = validatePTRF( msg.ptrfNumber, msg.maskSetTitle, msg.source);
        if(msgPTRFValidation.isError) return msgPTRFValidation;
        if(msg.layers==null || msg.layers.isEmpty()) return new Message('Layer list must not be empty','', true);
        return new Message('','', false);
    }
    
    /*
    * Do approval: can be overriden at child class (e.g: Foundry)
    */
    public virtual void performApproval(MRSApprovalService.MRSApprovalMsg msg) {
        
        Set<String> mstSet              = new Set<String>{ msg.maskSetTitle };
        Set<String> ptrfSet             = new Set<String>{ msg.ptrfNumber };
        Set<String> inputLayerNumberSet      = new Set<String>();
        Set<String> inputLayerRevSet         = new Set<String>();
        Map<String,String> commentMap   = new Map<String,String>();//Key map is layer unique id, this is used to create note for layer chip
        Set<String> inputChipNameSet         = new Set<String>();
        String layerUniqueIdentifier    = '';
        String chipUniqueIdentifier     = '';
        
        for(MRSApprovalService.MRSLayerData layer: msg.layers){
            
            if( !inputLayerNumberSet.contains(layer.layerNumber) ){
                inputLayerNumberSet.add(layer.layerNumber);
            }
            
            if( !inputLayerRevSet.contains(layer.layerRev) ){
                inputLayerRevSet.add(layer.layerRev);
            }
            
            layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
            
            if( !commentMap.containsKey(layerUniqueIdentifier) ){
                commentMap.put(layerUniqueIdentifier, String.isBlank(layer.comment)? '': layer.comment);
            }
            
            for(MRSApprovalService.MRSLayerChipData chip: layer.layerChips){
                if( !inputChipNameSet.contains(chip.chipName) ){
                    inputChipNameSet.add(chip.chipName);
                }
            }
        }
        
        List<MRS_Layer_Chip_Association__c> lcList          = retrieveMRSLayerChips(mstSet, ptrfSet, inputChipNameSet, inputLayerNumberSet, inputLayerRevSet);
        
        if(lcList.isEmpty()){
            Message errorMsg = new Message('Layer or chip not found','',true);
            if( isValidationErrorLogged() ) MRSApprovalUtility.logValidationError( errorMsg, msg);
            //build response
            handleResponse(msg, errorMsg);
            return;
        }
        
        Set<String> layerNumberSet      = new Set<String>();
        Set<String> layerRevSet         = new Set<String>();
        Set<String> layerUniqueIdSet    = new Set<String>();//Combination of Layer Number + Rev + Rom Code
        Set<String> chipNameSet         = new Set<String>();
        Set<String> chipUniqueIdSet     = new Set<String>();
        Map<String, MRS_Layer_Chip_Association__c> layerChipMap = new Map<String, MRS_Layer_Chip_Association__c>();
        Map<String, Message> layerErrMap                        = new Map<String, Message>();
        Map<String, Message> layerChipErrMap                    = new Map<String, Message>();
        
        for(MRS_Layer_Chip_Association__c lc : lcList){
            
            //Add Layer Number, Layer Rev, Chip name...to data sets
            if( !layerNumberSet.contains(lc.Layer__r.Name) ){
                layerNumberSet.add(lc.Layer__r.Name);
            }
            if( !layerRevSet.contains(lc.Layer__r.Mask_Layer_Rev__c) ){
                layerRevSet.add(lc.Layer__r.Mask_Layer_Rev__c);
            }
            
            layerUniqueIdentifier = lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;
            if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ){
                layerUniqueIdSet.add(layerUniqueIdentifier);
            }
            
            if( !chipNameSet.contains(lc.Chip__r.Name) ){
                chipNameSet.add(lc.Chip__r.Name);
            }
            
            chipUniqueIdentifier    = layerUniqueIdentifier + lc.Chip__r.Name;
            
            if( !chipUniqueIdSet.contains( chipUniqueIdentifier ) ){
                chipUniqueIdSet.add(chipUniqueIdentifier);
                layerChipMap.put(chipUniqueIdentifier, lc);
            }
        }
        
        Set<string> layerReleasedShippedMap = new Set<string>();
        
        list<MRS_Layer_Association__c> listLayerShipRelease = [
            select Mask_Set_Title_Name__c, Name, Mask_Layer_Rev__c, ROM_Code__c 
            from MRS_Layer_Association__c 
            where Mask_Set_Title_Name__c in :mstSet and Name in :layerNumberSet and Mask_Layer_Rev__c in :layerRevSet and Layer_Status__c in ('Released','Shipped')
        ];
        
        for(MRS_Layer_Association__c lyr: listLayerShipRelease){ layerReleasedShippedMap.add(lyr.Name+lyr.Mask_Layer_Rev__c ); }
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>();
        
        User approver   = MRSApprovalUtility.getUserFromEmployeeID(msg.employeeID, msg.source);
        
        for(MRSApprovalService.MRSLayerData layer: msg.layers){
            
            layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
            
            //Check if Layer Status is valid
            if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ){
                //Missing Layer
                if( layerReleasedShippedMap.contains(layerUniqueIdentifier) ){
                    layerErrMap.put( layerUniqueIdentifier, new Message('Layer is Released or Shipped','',true) );
                }else{
                    layerErrMap.put( layerUniqueIdentifier, new Message('MRS Layer not found.','',true) );
                }
                continue;
            }
            
            //Get fields to be updated
            Map<String,String> fieldMap = getFieldMap();
            String jvField                  = fieldMap.get( FIELD_JV );
            String approvalDateField        = fieldMap.get( FIELD_APPROVAL_DATE );
            String approverField            = fieldMap.get( FIELD_APPROVER );
            
            //Process layer chips
            for(MRSApprovalService.MRSLayerChipData chip: layer.layerChips){
                
                chipUniqueIdentifier    = layerUniqueIdentifier + chip.chipName;
                //Missing chip
                if( !chipUniqueIdSet.contains(chipUniqueIdentifier) ){layerChipErrMap.put(chipUniqueIdentifier, new Message('MRS Layer Chip not found.','',true));continue;}
                
                //Get layer chip from the map
                MRS_Layer_Chip_Association__c tmpChip = layerChipMap.get(chipUniqueIdentifier);
                
                //Check chip status
                if( String.valueOf( tmpChip.get( jvField ) )== 'Released'){layerChipErrMap.put(chipUniqueIdentifier, new Message('Layer Chip has been Released','',false));continue;}
                
                if( String.valueOf( tmpChip.get( jvField ) )== 'N.A.'){layerChipErrMap.put(chipUniqueIdentifier, new Message('Approval Status is N.A.','',false));continue;}
                
                if( String.isBlank(chip.status) || !chip.status.equalsIgnoreCase('Released') ){layerChipErrMap.put(chipUniqueIdentifier, new Message('Invalid approval status: ' + chip.status,'',false));continue;}
                
                //Invalid Chip status
                if( String.valueOf( tmpChip.get( jvField ) )!='Ready' ){layerChipErrMap.put( chipUniqueIdentifier, new Message('Invalid Layer Chip status: ' + String.valueOf( tmpChip.get( jvField ) ),'',true) );continue;}

                //Check inbound timestamp
                /* SWGP-396: Remove date time check
                if( Datetime.valueOf(tmpChip.get( approvalDateField )) > msg.sourceInboundRequestTimestamp ){
                    layerChipErrMap.put( chipUniqueIdentifier, new Message('Layer Chip has already synced','',false) );
                    continue;
                }
                */
                
                //Update chip jobview status, date & approver 
                MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c(Id = tmpChip.Id);//Init a new object to make sure that only changed fields are save.
                chipToUpdate.put( jvField, chip.status );
                
                chipToUpdate.put( approvalDateField, System.now() );
                if(approver!=null) chipToUpdate.put( approverField, String.valueOf(approver.ID) );
                //Bypass validation
                else chipToUpdate.put( approverField, UserInfo.getUserId() );
                
                //=========================
                //Update 12-Aug-2016: SWGP-893: [eJDV - Customer Mebes Jv WS] Exclude back-patching of SendData/MebesReceived
                if(getSourceForApprovalEmail() != 'MEBES Jobview - Customer') {
                    //SWGP-588
                    if(String.valueOf(tmpChip.get('Send_Prime_Data__c')) == 'Not Done') chipToUpdate.put('Send_Prime_Data__c','Done');
                    if(String.valueOf(tmpChip.get('Send_Frame_Data__c')) == 'Not Done') chipToUpdate.put('Send_Frame_Data__c','Done');
                    if(String.valueOf(tmpChip.get('Frame_MEBES_Received__c')) == 'Not Done') chipToUpdate.put('Frame_MEBES_Received__c','Done');
                    if(String.valueOf(tmpChip.get('Prime_MEBES_Received__c')) == 'Not Done') chipToUpdate.put('Prime_MEBES_Received__c','Done');                
                    //SWGP-588
                    //=========================
                }
                
                //Set value for Jobview approver
                lcToUpdateList.add(chipToUpdate);
            }
        }
        
        //Update layer chip
        if( !lcToUpdateList.isEmpty() ){
            update lcToUpdateList;
            //Send email
            doPostApprovalActions(lcToUpdateList, commentMap);
        }
        
        //build response
        handleResponse(msg, layerErrMap, layerChipErrMap, new Message('','', false));
    }
    
    /*
    * @description send email & create note for approved layer chip
    * @param lsList         list of approved layer chips
    *        commentMap     map of layer unique key & comment
    */
    public void doPostApprovalActions(List<MRS_Layer_Chip_Association__c> lcList, Map<String,String> commentMap) {
        
        //Query necessary fields
        List<MRS_Layer_Chip_Association__c> lcToProcess = [SELECT Customer_MEBES_Jobview_Date__c,Customer_MEBES_Jobview__c,
                                                Foundry_MEBES_Jobview_Date__c,Foundry_MEBES_Jobview__c,
                                                GlobalShuttle_MEBES_Jobview_Date__c,GlobalShuttle_MEBES_Jobview__c,
                                                MDP_MEBES_Jobview_Date__c,MDP_MEBES_Jobview__c,PTRF__c,
                                                Tapeout_Applications_MEBES_Jobview_Date__c,Tapeout_Applications_MEBES_Jobview__c,
                                                Tapeout_Centre_MEBES_Jobview_Date__c,Tapeout_Centre_MEBES_Jobview__c,
                                                TDTI_MPW_MEBES_Date__c,TDTI_MPW_MEBES_Jobview__c,Id,Name,
                                                ROM_Code__c,Layer__r.Name,Layer__r.Mask_Layer_Rev__c,
                                                Chip__c,Chip__r.Name,PTRF__r.Tech_Geo__c,PTRF__r.MaskSetTitle__r.Name,
                                                PTRF__r.MaskSetTitle__c,PTRF__r.Device__c,PTRF__r.Device__r.Name,
                                                PTRF__r.Device_Id__c,PTRF__r.Name,Layer__c,LastModifiedById,Layer__r.ROM_Code__c,
                                                Layer__r.Layer_Status__c,Device_Id__c,Tech_Geo__c,PTRF__r.Recticle_Type__c
                                                FROM MRS_Layer_Chip_Association__c where Id IN :lcList];
        Map<Id,List<MRS_Layer_Chip_Association__c>> ptrfToLayerChipsMap = new Map<Id,List<MRS_Layer_Chip_Association__c>>();
        ptrfToLayerChipsMap.put(lcToProcess.get(0).PTRF__c, lcToProcess);
        
        //Send approval emails
        MRSHandlerUtility.sendEmailToReviewers(ptrfToLayerChipsMap, getSourceForApprovalEmail(),'',null,'','');
        
        //After releasing the Chips/Frames, populating the Release Comments in the child Notes object, if Release Comments was required         
        List<Notes__c> lstNote = new List<Notes__c>();
        String layerUniqueId = '';
        
        for(MRS_Layer_Chip_Association__c lc : lcToProcess){
            layerUniqueId = lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;
            Notes__c objNote = new Notes__c(
                ParentId__c = lc.Id,
                Body__c = (commentMap.containsKey(layerUniqueId)? commentMap.get(layerUniqueId): ''),
                Category__c = getNoteCategory()
            );
            lstNote.add(objNote);
        }
        
        insert lstNote;
    }
    
    /*
    * @description Validate if a PTRF & MST is valid for a specific group
    * @param ptrf: PTRF Number
    * @param mst :Mask Set Title
    * @param groupName Group name
    * @return true if the group has access to PTRF
    */
    public Message validatePTRF(String ptrfNumberSet, String mstSet, String groupName) {
        
        //Check if the PTRF exist in the system
        List<PTRF__c> ptrfList = [
            select Id, Tech_Geo__c, MaskSetTitle__r.Name, Status__c 
            from PTRF__c 
            where Name = :ptrfNumberSet and MaskSetTitle__r.Name = :mstSet 
            limit 1
        ];
        
        if(ptrfList.isEmpty()) return new Message('MST - PTRF combination not found.', '', true);
        else if(ptrfList.get(0).Status__c!='Perform Tapeout Options') return new Message('Invalid PTRF status: ' + ptrfList.get(0).Status__c, '', true);
        else if( String.isBlank(ptrfList.get(0).Tech_Geo__c) ) return new Message('Tech Geo must not be empty', '', true);
        
        PTRF__c ptrf = ptrfList.get(0);
        //Validate PTRF for each group
        if(groupName == SOURCE_MDP){
            String TECH_GEO = loadEnvVariable('Swift_Default_Tech_Geo_MDP', '0.020');
            Double techGeo = Double.valueOf( ptrf.Tech_Geo__c.toUpperCase().substringBefore('UM').trim() );
            if(techGeo > Double.valueOf(TECH_GEO)) return new Message('Invalid Tech Geo: ' + ptrf.Tech_Geo__c, '', true);
        }
        
        /*
        else if(groupName == SOURCE_TDTI_MPW){
            String TECH_GEO                 = loadEnvVariable('Swift_Default_Tech_Geo_TDTIMPW', '0.020');
            Double techGeo = Double.valueOf( ptrf.Tech_Geo__c.toUpperCase().substringBefore('UM').trim() );
            if(techGeo > Double.valueOf( TECH_GEO ) )  return new Message('Invalid Tech Geo: ' + ptrf.Tech_Geo__c, '', true);
            else if(!ptrf.MaskSetTitle__r.Name.startsWith('MPW'))  return new Message('Invalid Mask Set Title: ' + ptrf.MaskSetTitle__r.Name, '', true);
        }
        */
        
        return validatePTRF(ptrfList.get(0));
    }
    
    
    
    /*
    * 
    * @description handle response in case validation error happens
    * @param msg incoming message
             errorMsg validation error message
    */
    public void handleResponse(MRSApprovalService.MRSApprovalMsg msg, Message errorMsg) {
        
        try{
            //Create Layer error map & layer chip error map
            Map<String, Message> layerErrMap                        = new Map<String, Message>();
            Map<String, Message> layerChipErrMap                    = new Map<String, Message>();
            String layerUniqueIdentifier    = '';
            String chipUniqueIdentifier     = '';
            
            //In case the error happens at transaction level (like validation error) then the error message should be included at layer & chip level.
            if(msg.layers!=null && msg.layers.size() > 0){
                for(MRSApprovalService.MRSLayerData layer: msg.layers){
                    layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
                    if( !layerErrMap.containsKey(layerUniqueIdentifier) ){
                        layerErrMap.put(layerUniqueIdentifier, new Message(errorMsg.msg, '', true));
                    }
                    
                    if(layer.layerChips!=null && layer.layerChips.size() > 0){
                        for(MRSApprovalService.MRSLayerChipData chip: layer.layerChips){
                            chipUniqueIdentifier    = layerUniqueIdentifier + chip.chipName;
                            if( !layerChipErrMap.containsKey(chipUniqueIdentifier) ){
                                layerChipErrMap.put(chipUniqueIdentifier, new Message(errorMsg.msg, '', true));
                            }
                        }
                    }
                }
            }
            
            handleResponse(msg, layerErrMap, layerChipErrMap, errorMsg);
            
        }catch(Exception ex){
            SWIFT_Application_Log__c log = MRSApprovalUtility.logUnhandledException(ex, msg);
            MRSApprovalUtility.sendErrorEmail(ex, msg, String.valueOf(log.Id) );
        }
    }
    
    /*
    * 
    * @description build & send response message
    * @param msg original message
    *        layerErrMap map of layer unique key & error message (if any) of the layer
    *        layerChipErrMap map of layer chip unique key & error message (if any) of the layer chip
    */
    public void handleResponse(MRSApprovalService.MRSApprovalMsg msg, Map<String, Message> layerErrMap, Map<String, Message> layerChipErrMap, Message errorMsg) {
        
        try{
            List<MRSMDPResponseService.mdpLayerStatus> layerStatusList = new List<MRSMDPResponseService.mdpLayerStatus>();
            String layerUniqueIdentifier    = '';
            String chipUniqueIdentifier     = '';
            Map<String,Set<String>> mapInvalidChips = new Map<String,Set<String>>();
            
            //Build response message
            if(msg.layers!=null && msg.layers.size() > 0){
                
                for(MRSApprovalService.MRSLayerData layer : msg.layers){
                    MRSMDPResponseService.mdpLayerStatus layerStatus = new MRSMDPResponseService.mdpLayerStatus();
                    layerStatus.layerNumber         = layer.layerNumber;
                    layerStatus.layerRevision       = layer.layerRev;
                    
                    layerStatus.layerChipStatus                 = new List<MRSMDPResponseService.mdpLayChip>();
                    
                    layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
                
                    if( layerErrMap.containsKey(layerUniqueIdentifier) ){
                        layerStatus.layerStatus         = layerErrMap.get(layerUniqueIdentifier).getStatus();
                        layerStatus.message             = layerErrMap.get(layerUniqueIdentifier).msg;
                    }else{
                        layerStatus.layerStatus         = MRSGeneralService.SUCCESS;
                    }
                
                    if(layer.layerChips==null) continue;
                    for(MRSApprovalService.MRSLayerChipData lc : layer.layerChips){
                        MRSMDPResponseService.mdpLayChip chip = new MRSMDPResponseService.mdpLayChip();
                        chip.chipName       = lc.chipName;
                        
                        chipUniqueIdentifier    = layerUniqueIdentifier + lc.chipName;
                        if( layerChipErrMap.containsKey(chipUniqueIdentifier) ){
                            chip.chipStatus     = layerChipErrMap.get(chipUniqueIdentifier).getStatus();
                            chip.message        = layerChipErrMap.get(chipUniqueIdentifier).msg;
                            if(chip.message.contains('Invalid Layer Chip status')){
                                if(!mapInvalidChips.containsKey( layer.layerNumber + layer.layerRev )) mapInvalidChips.put( layer.layerNumber + layer.layerRev, new Set<String>{chip.chipName + ':' + chip.message.substringAfter(':')} );
                                else mapInvalidChips.get( layer.layerNumber + layer.layerRev ).add( chip.chipName  + ':' + chip.message.substringAfter(':') );
                            }
                        }else{
                            chip.chipStatus     = MRSGeneralService.SUCCESS;
                        }
                        
                        layerStatus.layerChipStatus.add(chip);
                    }
                    layerStatusList.add(layerStatus);
                }
            }
            
            MRSMDPResponseService.serviceMDPfeedbackRequest responseMsg = new MRSMDPResponseService.serviceMDPfeedbackRequest();
            responseMsg.messageID               = msg.messageId;
            responseMsg.transactionStatus       = errorMsg.getStatus();
            responseMsg.transactionErrorMessage = errorMsg.msg;
            responseMsg.ptrfNumber              = msg.ptrfNumber;
            responseMsg.layerStatus             = layerStatusList;
            
            SWIFT_Application_Log__c validationLog;
            
            if(TESTING_MODE=='ON') {
                String loggedMsg = JSON.serialize(responseMsg);
                serviceMDPfeedbackRequest response = (serviceMDPfeedbackRequest)JSON.deserialize( loggedMsg, serviceMDPfeedbackRequest.class );
                validationLog   = MRSApprovalUtility.logValidationError(new Message( JSON.serialize(response),'',false), msg);
            }
            
            if(!mapInvalidChips.isEmpty()) {
                String vMsg = '';
                for(String key : mapInvalidChips.keySet()){
                    for(String val : mapInvalidChips.get( key ) ){
                        vMsg += key + '-' + val + '\n';
                    }
                }
                vMsg = 'Invalid Layer Chip Status: \n' + vMsg.removeEnd(',');
                MRSApprovalUtility.sendInvalidStatusEmail( vMsg, msg, validationLog!=null?String.valueOf(validationLog.Id):'' );
            }
            
            MRSGeneralService.sendResponse( JSON.serialize(responseMsg) );
            
        }catch(Exception ex){
            SWIFT_Application_Log__c log = MRSApprovalUtility.logUnhandledException(ex, msg);
            MRSApprovalUtility.sendErrorEmail(ex, msg, String.valueOf(log.Id) );
        }
    }
    
    /*
    * @description send response message
    * @param jsonMsg response message in json format
    */
    @future(callout=true)
    public static void sendResponse(String jsonMsg){
        
        MRSMDPResponseService.serviceMDPfeedbackRequest response = 
            (MRSMDPResponseService.serviceMDPfeedbackRequest)JSON.deserialize(jsonMsg, MRSMDPResponseService.serviceMDPfeedbackRequest.class);
            
        MRSMDPResponseService.MDPMRSResponseService_pt stub = new MRSMDPResponseService.MDPMRSResponseService_pt();
        
        //Including SSL Certificate      
        String certificate = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
        
        if(certificate != NULL && certificate != 'NO'){
            stub.clientCertName_x = certificate ;
        }
        
        stub.timeout_x = 100000;
        
        if(!Test.isRunningTest()) stub.process(response.messageID, response.transactionStatus, response.transactionErrorMessage, response.ptrfNumber, response.layerStatus);
    }
    
    /*
    * @description check if validation error logged
    */
    public boolean isValidationErrorLogged() {
        return 'ON'.equalsIgnoreCase( DEBUG_MODE );
    }
    
    /*
    * @description load environment variable, create a new one with default value if not exist
    * @param name variable name
    *        defaultValue 
    */
    public static String loadEnvVariable(String name, String defaultValue) {
        if( Environment_Variable__c.getInstance( name )==null ){
            if(defaultValue==null) return null;
            else insert new Environment_Variable__c( Name=name, Value__c=defaultValue);
        }
        return Environment_Variable__c.getInstance( name ).Value__c;
    }
    
    /*
    * @description extra validation implemented by subclass
    * @param ptrf: a PTRF record
    * @return Message
    */
    public virtual Message validatePTRF(PTRF__c ptrf) {
        return new Message('', '', false);// return success message
    }
    
    /*
    * @description return valid sources, this method could be overridden in subclass to restrict the sources which could approve each field 
    * @return a list of sources that can perform approval
    */
    public virtual Set<String> getSources() { 
        return new Set<String>{ SOURCE_MDP }; 
    }
    
    /*
    * @description  return all fields could be approved by this webservice
                    override this method in subclass to restrict the fields to be approved by that specific subclass
    * @param ptrf
    */
    public virtual Set<String> getFields() {
        return new Set<String>{ MDP_MEBES_JOBVIEW, TDTI_MEBES_JOBVIEW, FOUNDRY_MEBES_JOBVIEW, CUSTOMER_MEBES_JOBVIEW};
    }
    
    /*
    * @description must be overriden by subclass to return list of fields to be updated
    */
    public virtual Map<String, String> getFieldMap() {
        return new Map<String, String>();
    }
    
    /*
    * @description must be overriden by subclass for approval email
                   acceptable values: MEBES Jobview - Customer, MEBES Jobview - Foundry, 
                   MEBES Jobview - TapeoutCenter, MEBES Jobview - TapeoutApplication,
                   MEBES Jobview - GlobalShuttle, MEBES Jobview - MDP, MEBES Jobview - TDTIMPW
    */
    public virtual String getSourceForApprovalEmail() {
        return '';
    }
    
    /*
    * @description must be overrided by subclass for approval email
            - acceptable values: 
                    Customer MEBES Jobview, Foundry MEBES Jobview, 
                    Tapeout Centre/MDP MEBES Jobview,Tapeout Applications MEBES Jobview, 
                    GlobalShuttle/TDTI-MPW MEBES Jobview,Tapeout Centre/MDP MEBES Jobview, 
                    GlobalShuttle/TDTI-MPW MEBES Jobview
    */
    public virtual String getNoteCategory() {
        return '';
    }
    
    /*
    * @description query layer chip from mask set title, ptrf, layer & chip
    * @param setMST a set of mask set title
    *        setPTRF a set of PTRF
    *        setChip a set of chip name
    *        setMaskLayer a set of mask layer number
    *        setMaskRev a set of mask layer revision
    * @return a list of layer chip
    */
    public List<MRS_Layer_Chip_Association__c> retrieveMRSLayerChips(Set<string> setMST, Set<string> setPTRF, 
                                        Set<string> setChip, Set<string> setMaskLayer, Set<string> setMaskRev) {
            
        return [
            select 
                Id,                                             Layer_Name__c,                              lastmodifieddate_sgt__c,                                 
                Tapeout_Centre_MEBES_Jobview_Date__c,           Tapeout_Applications_MEBES_Jobview__c,      Tapeout_Applications_MEBES_Jobview_Date__c,                    
                TDTI_MPW_MEBES_Jobview__c,                      TDTI_MPW_MEBES_Date__c,                     Send_Prime_Data__c,                                 
                Send_Frame_Data_Date__c,                        Rev__c,                                     DRT_Name__c,                                
                ROM_Code__c,                                    Prime_TapeOut__c,                           Prime_MEBES_Received__c,                    
                Prime_MEBES_Received_Date__c,                   PTRF__c,                                    PTRF_Number__c,                                     
                ORC_Date__c,                                    Mask_Set_Title_Name__c,                     Name,                                                               
                Mask_Layer_Status__c,                           MST__c,                                     MDP_MEBES_Jobview__c,                                   
                Layer__r.ROM_Code__c,                           PTRF__r.Customer_jobview__c,                PTRF__r.Foundry_Jobview__c,                                 
                PTRF__r.MaskSetTitle__c,                        PTRF__r.MaskSetTitle__r.Name,               Customer_Name__r.Name,                               
                Layer__r.Name,                                  Customer_Name__r.Short_Name__c,             Layer_Send_Prime_Data__c,                              
                Layer_Chip_Status_Date__c,                      Layer_Chip_Old_Status__c,                   Last_Sync_Req_Timestamp__c,                                       
                Last_Sync_Req_Timestamp_Send_Frame__c,          Last_Sync_Req_Timestamp_Remote_JobCust__c,  Last_Sync_Req_Timestamp_Remote_Jobview__c,                    
                Last_Sync_Req_Timestamp_Receive_MEBES__c,       Last_Sync_Req_Timestamp_ORCN_Job__c,        Last_Sync_Req_Timestamp_Layer_Gen__c,                    
                Is_Tapeout_Centre_MEBES_Jobview_Updated__c,     Is_Tapeout_Apps_MEBES_Jobview_Updated__c,   Is_TDTI_MPW_MEBES_Jobview_Updated__c,                    
                Is_Send_Prime_Data_Updated__c,                  Is_Send_Frame_Data_Updated__c,              Is_Prime_MEBES_Received_Updated__c,                                      
                Is_MDP_MEBES_Jobview_Updated__c,                Is_GlobalShuttle_MEBES_Jobview_Updated__c,  Is_Frame_MEBES_Received_Updated__c,                    
                Is_Foundry_Prime_Remote_Jobview_Updated__c,     Is_Foundry_MEBES_Jobview_Updated__c,        Is_Foundry_GDSOUT_Review_Updated__c,                    
                Is_Foundry_Frame_Remote_Jobview_Updated__c,     Is_Foundry_Frame_Mockup_Updated__c,         Is_DRW_Updated__c,                    
                Is_Customer_Prime_Remote_Jobview_Updated__c,    Is_Customer_MEBES_Jobview_Updated__c,       Is_Customer_GDSOUT_Review_Updated__c,                    
                Is_Customer_Frame_Remote_Jobview_Updated__c,    Is_Customer_Frame_Mockup_Updated__c,        Is_Active__c,                                        
                PTRF__r.Tech_Geo__c,                            GlobalShuttle_MEBES_Jobview__c,             GlobalShuttle_MEBES_Jobview_Date__c,                                     
                Frame_MEBES_Received_Date__c,                   Foundry_Prime_Remote_Jobview_Setup__c,      Foundry_Prime_Remote_Jobview_Setup_Date__c,                    
                Foundry_MEBES_Jobview__c,                       Foundry_MEBES_Jobview_Date__c,              Foundry_GDSOUT_Review__c,                                       
                Foundry_Frame_Remote_Jobview_Setup__c,          Foundry_Frame_Remote_Jobview_Setup_Date__c, Foundry_Frame_Mockup__c,                              
                Customer_Prime_Remote_Jobview_Setup__c,         Customer_Prime_Remote_Jobview_Setup_Date__c,Customer_Name__c,                                       
                Customer_MEBES_Jobview_Date__c,                 Customer_GDSOUT_Review__c,                  Customer_GDSOUT_Review_Date__c,                                        
                Customer_Frame_Remote_Jobview_Setup_Date__c,    Customer_Frame_Mockup__c,                   Customer_Frame_Mockup_Date__c,                                       
                PTRF__r.Status__c,                              Chip_Name__c,                               PTRF__r.Process_Technology_Lifecycle_Phase__c,                    
                Tech_Geo__c,                                    Tapeout_Centre_MEBES_Jobview__c,            Send_Prime_Data_Date__c,                    
                Send_Frame_Data__c,                             Mask_Layer__c,                              DRT__c,         
                ORC__c,                                         MDP_MEBES_Jobview_Date__c,                  Layer__r.Mask_Layer_Rev__c,     
                PTRF__r.Name,                                   Chip__r.Name,                               PTRF__r.Order_Type__c,   
                Layer_Send_Frame_Data__c,                       Layer_Chip_Status__c,                       Last_Sync_Req_Timestamp_Send_Prime__c, 
                Is_ORC_Updated__c,                              IsDeleted,                                  Frame_TapeOut__c,                    
                Frame_MEBES_Received__c,                        Foundry_GDSOUT_Review_Date__c,              Foundry_Frame_Mockup_Date__c,        
                Customer_MEBES_Jobview__c,                      Customer_Frame_Remote_Jobview_Setup__c,     Chip__c,                    
                DRW__c,                                         PTRF__r.Customer_Short_Name__c
            from MRS_Layer_Chip_Association__c 
            where Chip_Name__c    IN :setChip       and PTRF_Number__c       IN : setPTRF 
                and Mask_Layer__c IN :setMaskLayer  and rev__c               IN :setmaskrev 
                and MST__c        IN :setMST        and Layer_Chip_Status__c != 'Cancel'
        ];
    }
    
    public static String SUCCESS   = 'SUCCESS';
    public static String ERROR     = 'ERROR';        
    public class Message{
        
        public String msg;
        public String description;
        public boolean isError;
        
        public Message(String msg, String description, boolean isError){
            this.msg            = msg;
            this.description    = description;
            this.isError        = isError;
        }
        
        public String getStatus(){
            if(isError) return MRSGeneralService.ERROR;
            return MRSGeneralService.SUCCESS;
        }
    }
    
    //Classes for logging purpose
    private class mdpLayerStatus {
        public String layerNumber;
        public String layerRevision;
        public String ROMcode;
        public String layerStatus;
        public String message;
        public mdpLayChip[] layerChipStatus;
    }
    
    private class serviceMDPfeedbackRequest {
        public String messageID;
        public String transactionStatus;
        public String transactionErrorMessage;
        public String ptrfNumber;
        public mdpLayerStatus[] layerStatus;
    }
    
    private class mdpLayChip {
        public String chipName;
        public String chipStatus;
        public String message;
    }
}