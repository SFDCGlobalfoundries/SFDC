/*
* This class defines common actions for CAD Webservices. 
* It also provides virtual methods so that subclass can override to handle a specific type of request.
*/
public virtual class MRSCADGeneralService{
    
    //===START - GENERAL VARIABLES=========================
    public static String WS_SEND_DATA           = 'MRSCADSendDataService';
    public static String WS_MEBES_RECEIVED      = 'MRSCADMEBESReceivedService';
    public static String WS_REMOTE_JOBVIEW      = 'MRSCADRJVService';
    public static String WS_LG                  = 'MRSCADLGService';
    public static String WS_ORC                 = 'MRSCADORCService';
    //below are using in field map of each ws
    public static String KEY_FIELD              = 'FIELD';
    public static String KEY_IS_UPDATED         = 'ISUPDATED';
    public static String KEY_LAST_SYNC          = 'LASTSYNC';
    public static String KEY_RJV                = 'RJV';
    public static String KEY_RJV_IS_UPDATED     = 'RJV_ISUPDATED';
    public static String KEY_NOTIFIED_DATE      = 'NOTIFIEDDATE';
    public static String CHIP_PRIME             = 'PRIME';
    public static String CHIP_FRAME             = 'FRAME';
    public static String CHIP_ALL               = 'PRIME_FRAME';
    //below are generic response message
    //message format validation error
    public static String MSG_MST_REQUIRED               = 'Invalid message: MST is required';
    public static String MSG_INBOUND_TIME_REQUIRED      = 'Invalid message: Inbound time is required';
    public static String MSG_PTRF_REQUIRED              = 'Invalid message: PTRF is required';
    public static String MSG_JOBVIEW_REQUIRED           = 'Invalid message: Jobview is required';
    public static String MSG_PTRF_NO_CHIP               = 'Invalid message: Chip is required';
    public static String MSG_CHIP_NO_LAYER              = 'Invalid message: Layer is required';
    //processing error
    public static String MSG_INVALID_PTRF_STATUS        = 'Invalid PTRF status: ';//only Perform Tapeout Options can be processed 
    public static String MSG_CHIP_NOT_FOUND             = 'Chip not found';
    public static String MSG_LAYER_NOT_FOUND            = 'Layer not found';
    public static String MSG_PTRF_NOT_FOUND             = 'PTRF not found';
    public static String MSG_PTRF_HAS_NO_CHIP           = 'No PTRF chip found';
    public static String MSG_RECORD_ALREADY_SYNCED      = 'Record synced already with an updated sync request';
    public static String MSG_RECORD_SYNCED              = 'Record synced with updated request';
    public static String MSG_FIELD_UPDATED_MANUALLY     = 'Field has been manually updated';
    public static String VALID_LAYER_CHIP_STATUS        = 'Not Ready;In Progress;Released;Hold';
    public static String MSG_SERVICE_UNAVAILABLE        = 'Service is temporarily unavailable, please try again later';//response when turn off WS
    // ====================
    public set<string> setChipNotFound;//store chip not found in sfdc, use to send missing layer/chip email
    public set<string> setLayerNotFound;//store layer not found in sfdc, use to send missing layer/chip email
    // ====================
    public String wsMessage;//incoming message in json format
    public String mst;//mask set title of incoming message
    public dateTime sourceTime;//source inbound time in incoming message
    public String messageId;//incoming msg id
    public MRS_CADService.PTRFData ptrfData;//ptrf data in incoming msg
    //drt
    public String ptrfFrameDRT;//store frame drt name associated with incoming msg ptrf if exist
    public String ptrfPrimeDRT;//store prime drt name associated with incoming msg ptrf if exist
    //drt_end
    public String WS_CLASS_NAME;//name of active ws class, value in ('MRSCADSendDataService','MRSCADMEBESReceivedService','MRSCADRJVService') 
    public String WS_METHOD_NAME;//handleRequest(msg)
    public String activeWsName;//name of active ws, use in missing layer/chip email
    public Set<String> setChipName;//set of chip name found in sfdc match msg chip
    public Set<String> setLayerNumber;//set of layer name found in sfdc match msg layer
    public Set<String> setLayerRev;//set of rev found in sfdc match msg rev
    public Map<String, Message> chipErrorMap;//store all chip related error, use in response msg
    public Map<String, Message> layerChipErrorMap;//store all layer related error, use in response msg
    //====
    public Set<String> layerNumberSet;//store all layes in incoming msg
    public Set<String> layerRevSet;//store incoming msg's rev
    public Set<String> layerUniqueIdSet;//Combination of Layer Number + Rev + Rom Code
    public Set<String> chipNameSet;//store incoming msg's chip
    public Set<String> chipUniqueIdSet;//format: ptrf + chip name
    public Map<String, MRS_Layer_Chip_Association__c> layerChipMap; //store active layer chip
    public Set<String> layerChipCancelSet; //store cancel layer chip    
    public boolean isDebugMode;//debug mode, will be set at each ws class by their own custom setting flag    
    //===END - GENERAL VARIABLES
    //===SEND DATA/RJV/MEBES Received VARIABLES
    public static String GROUP_GLOBALSHUTTLE        = 'GlobalShuttle';
    public static String GROUP_TDTI_MPW             = 'TDTI_MPW';
    public static String GROUP_MDP                  = 'MDP';
    public static String GROUP_TAPEOUT_CENTRE       = 'Tapeout_Centre';
    public static String GROUP_TAPEOUT_APPLICATIONS = 'Tapeout_Applications';
    public static String GROUP_FOUNDRY              = 'Foundry';
    public static String GROUP_CUSTOMER             = 'Customer';
    //===END - SEND DATA/RJV/MEBES Received VARIABLES
    
    public MRSCADGeneralService(){
        mst                 = '';//mst extract from ws msg
        messageId           = '';//incoming ws id
        ptrfData            = new MRS_CADService.PTRFData();
        ptrfData.ptrfNumber = '';
        setChipName         = new Set<String>();//chip name set extract from ws msg
        setLayerNumber      = new Set<String>();//layer name set extract from ws msg
        setLayerRev         = new Set<String>();//layer revision set extract from ws msg
        WS_CLASS_NAME       = 'MRSCADGeneralService';//class name, use for logging, will be override with ws class if error happen at under level
        WS_METHOD_NAME      = 'handleRequest';
        
        chipErrorMap        = new Map<String, Message>();//store error at chip level
        layerChipErrorMap   = new Map<String, Message>();//store error at layer/layer chip level
        
        layerNumberSet      = new Set<String>();//set layer name retrieve from sfdc
        layerRevSet         = new Set<String>();//set layer rev retrieve from sfdc
        layerUniqueIdSet    = new Set<String>();//Combination of Layer Number + Rev + Rom Code
        chipNameSet         = new Set<String>();//set chip name retrieve from sfdc
        chipUniqueIdSet     = new Set<String>();
        ptrfFrameDRT        = '';//frame drt name of ptrf
        ptrfPrimeDRT        = '';//prime drt name of ptrf
        layerChipMap        = new map<String, MRS_Layer_Chip_Association__c>();//active layer chip
        layerChipCancelSet  = new Set<String>();//cancelled layer chip
        isDebugMode         = false; //will be override value at individual ws class
        activeWsName        = 'General Service';

        setChipNotFound     = new set<String>();
        setLayerNotFound    = new set<String>();
    }
    
    /*
    * @description fetch appropriate service to handle incoming request
    * @param approvalField 
    * @return 
    */
    public static MRSCADGeneralService fetchService(String serviceType){
        MRSCADGeneralService service = (MRSCADGeneralService)Type.forName(serviceType).newInstance();        
        return service;
    }
    
    /*
    * @description handle CAD request
    * @param  
    * @return 
    */
    public void handleRequest(String jsonMsg){
        try{            
            if(this.wsMessage == null) this.wsMessage = jsonMsg;
        
            Message validateMsg = validate(wsMessage);
            if(validateMsg.isError){
                handleResponse(validateMsg.msg); //log validation error message
                return;
            }
            
            if( retrievePtrfChip().isEmpty() ) {
                Message errorMsg = new Message(MSG_PTRF_HAS_NO_CHIP,'',true);
                handleResponse(errorMsg.msg); //build response
                return;
            }

            processWS(); //further processing
            handleResponse(false, '');//build response
            
        }catch(Exception ex){
            String ptrfNumber = (ptrfData==null)?'':ptrfData.ptrfNumber;
            SWIFT_Application_Log__c exLog = logUnhandledException(ex, wsMessage, messageId, WS_CLASS_NAME, WS_METHOD_NAME, ptrfNumber);
            sendErrorEmail(ex, exLog.Id, WS_CLASS_NAME, messageId, mst, ptrfNumber);
            handleResponse( ex.getMessage() );
        }
    }
    
    public virtual List<MRS_Layer_Chip_Association__c> retrievePtrfChip() {
        
        String layerUniqueIdentifier    = '';
        String chipUniqueIdentifier     = '';
        List<MRS_Layer_Chip_Association__c> lcList = retrieveMRSLayerChips(mst, ptrfData.ptrfNumber, setChipName, setLayerNumber, setLayerRev);//list of ptrf chip
        //loop for ptrf chip
        for(MRS_Layer_Chip_Association__c lc : lcList){
            //Add Layer Number, Layer Rev, Chip name...to data sets
            chipUniqueIdentifier    = lc.PTRF__r.Name + lc.Chip__r.Name;
            layerUniqueIdentifier   = chipUniqueIdentifier + lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;
            
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
    * @description 
    * @param  
    * @return 
    */
    public virtual void processWS(){
        // TO-DO
    }
    
    /*
    * 
    * @description handle response in case validation error happens
    * @param msg incoming message
             errorMsg validation error message
    * @return 
    */
    public void handleResponse(String errorMsg){
        
        try{
            list<MRSCADResponseCalloutService.transactionStatus> tempTransactList = new list < MRSCADResponseCalloutService.transactionStatus > ();
           
            MRSCADResponseCalloutService.transactionStatus tempTransact = new MRSCADResponseCalloutService.transactionStatus();
            tempTransact.status = 'ERROR:SFDC';
            tempTransact.ptrf = ptrfData.ptrfNumber;
            tempTransact.transactionErrorMessage = errorMsg;
            tempTransact.ChipStatus = new List<MRSCADResponseCalloutService.chipLayerStatus>();
            tempTransactList.add(tempTransact);
            
            //MSG_PTRF_HAS_NO_CHIP
            //MSG_INVALID_PTRF_STATUS
            if(errorMsg.containsIgnoreCase(MSG_PTRF_HAS_NO_CHIP) || errorMsg.containsIgnoreCase(MSG_INVALID_PTRF_STATUS)) {
                //build layer
                handleResponse(true, errorMsg);
            } else {
                //if debug mode ON => LOG all incoming msg and sfdc response 
                if(isDebugMode) 
                {
                    //serialize current response msg object in-order to convert it into new logging object (new object contains onby needful data for logging)
                    list<transactionStatus> loggingObjList = (list<transactionStatus>) JSON.deserialize(JSON.serialize(tempTransactList), List<transactionStatus>.class);
                    logValidationError(wsMessage, JSON.serialize(loggingObjList), messageId, WS_CLASS_NAME, WS_METHOD_NAME, 'DEBUG', ptrfData.ptrfNumber);
                }else{
                    logValidationError(wsMessage, errorMsg, messageId, WS_CLASS_NAME, WS_METHOD_NAME, 'ERROR', ptrfData.ptrfNumber);
                }
                sendResponse(messageId, JSON.serialize(tempTransactList));
            }
        }catch(Exception ex){
            String ptrfNumber = (ptrfData==null)?'':ptrfData.ptrfNumber;
            SWIFT_Application_Log__c exLog = logUnhandledException(ex, wsMessage, messageId, WS_CLASS_NAME, WS_METHOD_NAME, ptrfNumber);
            sendErrorEmail(ex, exLog.Id, WS_CLASS_NAME,  messageId, mst, ptrfNumber);
        }
    }
    
    /*
    * 
    * @description build & send response message
    * @param msg original message
    *        layerErrMap map of layer unique key & error message (if any) of the layer
    *        layerChipErrMap map of layer chip unique key & error message (if any) of the layer chip
    * @return 
    */
    public void handleResponse(boolean isValidationError, String errorMsg){
        
        try{
            list<MRSCADResponseCalloutService.transactionStatus> transactionStatusList = new list < MRSCADResponseCalloutService.transactionStatus >();
            
            MRSCADResponseCalloutService.transactionStatus ts = new MRSCADResponseCalloutService.transactionStatus();
            ts.transactionErrorMessage      = '';
            
            list<MRSCADResponseCalloutService.chipLayerStatus> chipStatusList = new list<MRSCADResponseCalloutService.chipLayerStatus>();
            for (MRS_CADService.chipData iChip: ptrfData.chip) {
                String chipUniqueIdentifier    = ptrfData.ptrfNumber + iChip.chipName;
                list<MRSCADResponseCalloutService.layer> layerStatusList = new list<MRSCADResponseCalloutService.layer>();
                for (MRS_CADService.layerData iLayer: iChip.layer) {
                    
                    MRSCADResponseCalloutService.layer ls = new MRSCADResponseCalloutService.layer();
                    ls.layerName        = iLayer.maskLayer;
                    ls.layerRevision    = iLayer.maskRev;
                    
                    String layerUniqueIdentifier = chipUniqueIdentifier + iLayer.maskLayer + iLayer.maskRev;
                    
                    //flag check here for all layer error response from handleResponse(error)
                    if(isValidationError) {
                        ls.status       = 'ERROR';
                        ls.errorMessage = errorMsg;
                    } else {
                        if( chipErrorMap.containsKey( chipUniqueIdentifier ) ) {
                            ls.status       = chipErrorMap.get( chipUniqueIdentifier ).getStatus();
                            ls.errorMessage = chipErrorMap.get( chipUniqueIdentifier ).msg;
                        } else if( layerChipErrorMap.containsKey( layerUniqueIdentifier ) ) {
                            ls.status       = layerChipErrorMap.get( layerUniqueIdentifier ).getStatus();
                            ls.errorMessage = layerChipErrorMap.get( layerUniqueIdentifier ).msg;
                        } else {
                            ls.status       = MRSCADGeneralService.SUCCESS;
                            ls.errorMessage = '';
                        }
                    }
                    
                    layerStatusList.add( ls );
                    
                    //update transaction error message
                    if( !ts.transactionErrorMessage.contains( ls.errorMessage ) ){
                        ts.transactionErrorMessage += ';' + ls.errorMessage;
                    }
                }
                
                MRSCADResponseCalloutService.chipLayerStatus cs = new MRSCADResponseCalloutService.chipLayerStatus();
                cs.ChipName     = iChip.chipName;
                cs.layer        = layerStatusList;
                chipStatusList.add( cs );
            }
            ts.ChipStatus       = chipStatusList;
            transactionStatusList.add(ts);
            // -------
            ts.ptrf             = ptrfData.ptrfNumber;
            
            ts.status           = MRSCADGeneralService.SUCCESS;
            if(ts.transactionErrorMessage.containsIgnoreCase('unable to obtain exclusive access')) {
                ts.status = 'ERROR:SFDC';
            }
            if( !String.isEmpty(ts.transactionErrorMessage) && ';' == ts.transactionErrorMessage.trim().substring(0,1)) { ts.transactionErrorMessage = ts.transactionErrorMessage.trim().substring(1); }
            
            // -------
            sendResponse(messageId, JSON.serialize( transactionStatusList ) );
            // -------
            if(isDebugMode) //if debug mode ON => LOG all incoming msg and sfdc response 
            {
                //serialize current response msg object in-order to convert it into new logging object (new object contains onby needful data for logging)
                list<transactionStatus> loggingObjList = (list<transactionStatus>) JSON.deserialize(JSON.serialize(transactionStatusList), List<transactionStatus>.class);
                logValidationError(wsMessage, JSON.serialize(loggingObjList), messageId, WS_CLASS_NAME, WS_METHOD_NAME, 'DEBUG', ptrfData.ptrfNumber);
            }
            
            if( !setChipNotFound.isEmpty() || !setLayerNotFound.isEmpty() ) {
                map < string, list < string >> mapchipNotFound  = new map < string, list < string >>();
                list < string > lstChipNotFound = new list < string >();
                lstChipNotFound.addAll(setChipNotFound);
                mapchipNotFound.put(ptrfData.ptrfNumber, lstChipNotFound);
                
                map < string, list < string >> maplayerNotFound = new map < string, list < string >>();                
                list < string > lstLayerNotFound = new list < string >();
                lstLayerNotFound.addAll(setLayerNotFound);
                maplayerNotFound.put(ptrfData.ptrfNumber, lstLayerNotFound);
                
                MRS_CADService.sendMailLayerChip(mapchipNotFound, mapLayerNotFound, messageId, mst, sourceTime, this.activeWsName + ' # ' + ptrfData.ptrfNumber);
            }
        }catch(Exception ex){
            SWIFT_Application_Log__c exLog = logUnhandledException(ex, wsMessage, messageId, WS_CLASS_NAME, WS_METHOD_NAME, ptrfData.ptrfNumber);
            sendErrorEmail(ex, exLog.Id, WS_CLASS_NAME,  messageId, mst, ptrfData.ptrfNumber);
            handleResponse( ex.getMessage() );
        }
    }
    
    /*
    * @description send response message
    * @param jsonMsg response message in json format
    * @return 
    */
    @future(callout=true)
    public static void sendResponse(String messageId, String jsonMsg){
        
        list<MRSCADResponseCalloutService.transactionStatus> response = (list<MRSCADResponseCalloutService.transactionStatus>)JSON.deserialize(
            jsonMsg, list<MRSCADResponseCalloutService.transactionStatus>.class
        );
        MRSCADResponseCalloutService.CADMRSLayerSyncResponseService_pt stub = new MRSCADResponseCalloutService.CADMRSLayerSyncResponseService_pt();
        //Including SSL Certificate      
        String certificate = Environment_Variable__c.getInstance('SELF_SIGNED_CERTIFICATE').value__c;
        if(certificate != NULL && certificate != 'NO'){
            stub.clientCertName_x = certificate ;
        }
        stub.timeout_x = 100000;
        if (!Test.isRunningTest()) {
            stub.ProcessCADMRSLayerSyncResponse(messageId, response);
        }
    }
    
    /*
    * @description common validation
    * @param  
    * @return 
    */
    public virtual Message validate(String msg){
        //Validate message format
        Message formatValidationResult = validateFormat(msg);
        
        //Check if the webservice is on: can turn off via Environment_Variable__c.getInstance('SWIFT_MRS_CAD_OnOff')
        Environment_Variable__c wsStatus = Environment_Variable__c.getInstance('SWIFT_MRS_CAD_OnOff');
        if( wsStatus!=null && wsStatus.Value__c != 'ON' ){
            return new Message(MSG_SERVICE_UNAVAILABLE,'', true); 
        }
        
        if(formatValidationResult.isError) return formatValidationResult;//format error, response
        
        //Perform basic validation
        if(String.isBlank(mst)){
            return new Message(MSG_MST_REQUIRED,'', true); 
        }
        
        if(sourceTime==null){
            return new Message(MSG_INBOUND_TIME_REQUIRED,'', true); 
        }
        
        //Check PTRF status
        List<PTRF__c> ptrfList = [Select Id,Frame_DRT__c,Prime_DRT__c,Status__c from PTRF__c where Name =:ptrfData.ptrfNumber and Mask_Set_Title_Name__c=:mst];
        if( ptrfList.size()==0 )  return new Message(MSG_PTRF_NOT_FOUND,'', true);
        else if( ptrfList.get(0).Status__c != 'Perform Tapeout Options' ){
            return new Message(MSG_INVALID_PTRF_STATUS + ptrfList.get(0).Status__c,'', true);
        }
        //if ptrf validation passed, then do:
        ptrfFrameDRT = String.isNotEmpty( ptrfList.get(0).Frame_DRT__c ) ? ptrfList.get(0).Frame_DRT__c.trim() : '';//use in MRSCADMEBESReceivedService
        ptrfPrimeDRT = String.isNotEmpty( ptrfList.get(0).Prime_DRT__c ) ? ptrfList.get(0).Prime_DRT__c.trim() : '';//use in MRSCADMEBESReceivedService
        return new Message('','', false);
    }
    
    /*
    * @description common validation
    * @param  
    * @return 
    */
    public virtual Message validateFormat(String msg){
        return new Message('','', false);
    }
    
    /*
    * @description send error email in case of unhandled exception
    * @param e exception
    *        logId Id of swift application log record 
    * @return 
    */
    public static void sendErrorEmail(Exception e, String logId, String wsClass, String msgId, String mst, String ptrfNumber){
        
        String source = 'CAD';
        EmailTemplate template= [Select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:MRSApprovalUtility.SWIFT_WS_Unhandled_Exception];
        
        String subject      = template.subject;
        subject             = subject.replace('<Source>', source + wsClass);
        subject             = subject.replace('<Message>', e.getMessage());
        
        String body         = template.Body ;
        body                = body.replace('<Status_Type>', 'hello world');//TODO
        body                = body.replace('<Source>', '');//TODO
        body                = body.replace('<MessageId>', msgId);//TODO
        body                = body.replace('<timestamp>', String.valueOf(System.now()));//TODO
        body                = body.replace('<MST>', mst);//TODO
        body                = body.replace('<PTRF>', ptrfNumber);//TODO
        body                = body.replace('<Message>', e.getMessage());
        body                = body.replace('<Debug_Log_Url>', URL.getSalesforceBaseUrl().toExternalForm() + '/' + logId);
        
        List<Email_Config_Settings__c> ecsList = [SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c,Foundry_Jobviewer_Type__c,Name,
                                                     MPW_PTRF__c,Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c 
                                                  FROM Email_Config_Settings__c 
                                                  WHERE Email_Template_Name__c   = :MRSApprovalUtility.SWIFT_WS_Unhandled_Exception 
                                                        and Available_For_Use__c = true 
                                                        and Source__c            = :source 
                                                        and RecordType.Name      = 'General' limit 1
        ];
                                                     
        Map<String, List<String>> recipientList = MRSApprovalUtility.buildRecipientList(ecsList);        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        System.debug(json.serialize(recipientList));
        mail.setToAddresses( recipientList.get('TO') );
        mail.setCcAddresses( recipientList.get('CC') );
        mail.setBccAddresses( recipientList.get('BCC') );
        
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        if(!recipientlist.get('TO').isEmpty() || !recipientlist.get('CC').isEmpty() || !recipientlist.get('BCC').isEmpty()) {
            if(!Test.isRunningTest()) Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail}  );
        }
    }
    
    /*
    * 
    * @description query layer chip from mask set title, ptrf, layer & chip
    * @param setMST a set of mask set title
    *        ptrfNumber PTRF number
    *        setChip a set of chip name
    *        setMaskLayer a set of mask layer number
    *        setMaskRev a set of mask layer revision
    * @return a list of layer chip
    */
    public List<MRS_Layer_Chip_Association__c> retrieveMRSLayerChips(String mst, String ptrfNumber, Set<string> setChip, Set<string> setMaskLayer, Set<string> setMaskRev){
        List<String> ptrfOrDRT = new List<String>{'PTRF'};
        //if(this.WS_CLASS_NAME == MRSCADGeneralService.WS_REMOTE_JOBVIEW) ptrfOrDRT.add('DRT');
        
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
                    AND PTRF_Number__c  =    :ptrfNumber 
                    AND Mask_Layer__c   IN   :setMaskLayer 
                    AND rev__c          IN   :setmaskrev 
                    AND MST__c          =    :mst
                    AND PTRF_Or_DRT__c  IN :ptrfOrDRT
        ];
    }
    
    /*
    * @description      - Log validation error
    *                   - Log all incoming message and respone message if debug mode is ON
    * @param errorMsg   - Validation error message
    *                   - OR: response message if debug mode is on
    * @param debugLevel     DEBUG | ERROR 
    *        msg original request message
    * @return 
    */
    public static void logValidationError(String wsMsg, String errorMsg, String msgId, String className, String methodName, String debugLevel, String ptrfNumber){
        // wsMsg is JSON format
        if(wsMsg.length() > 32000){ wsMsg   = wsMsg.subString(0,32000); }
        if(errorMsg.length() > 32000){ errorMsg   = errorMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = debugLevel     ,     Apex_Component_Name__c    = className     ,     Method__c          = methodName,    
            Integration_Payload__c    = wsMsg          ,     Stack_Trace__c          = errorMsg      ,     Error_Message__c     = '',
            Message_ID__c             = msgId + ' | ' + ptrfNumber
        );
        insert log;
    }
    
    /*
    * @description create a new swift application log record
    * @param e exception
    *        msg original request message
    * @return 
    */
    public static SWIFT_Application_Log__c logUnhandledException(Exception e, String wsMsg, String msgId, String className, String methodName, String ptrfNumber){
        if(wsMsg.length() > 32000){ wsMsg   = wsMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = 'ERROR'     ,     Apex_Component_Name__c = className        ,     Method__c        = methodName,
            Integration_Payload__c    = wsMsg       ,     Error_Message__c       = e.getMessage()   ,     Stack_Trace__c   = e.getStackTraceString(),
            Message_ID__c             = msgId + ' | ' + ptrfNumber
        );
        insert log; 
        return log;
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
            if(isError) return MRSCADGeneralService.ERROR;
            return MRSCADGeneralService.SUCCESS;
        }
    }
    
    //Logging/response classes
    public class transactionStatus {
        public String ptrf;
        public String status;
        public String transactionErrorMessage;
        public chipLayerStatus[] ChipStatus;
    }
    
    public class chipLayerStatus {
        public String ChipName;
        public layer[] layer;
    }

    public class layer {
        public String layerName;
        public String layerRevision;
        public String status;
        public String errorMessage;
    }
}