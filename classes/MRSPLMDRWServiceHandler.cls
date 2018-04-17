/*
This class handle all the util methods required for PLM DRW webservice.
Invoke from MRSPLMDRWService and <retrigger controller> 
*/
public class MRSPLMDRWServiceHandler {
    
    //below are generic response message
    public static String ERR_MSG_NO_MSGID           = 'Invalid msg: Message ID is required';
    public static String ERR_MSG_NO_PTRF            = 'Invalid msg: PTRF Number is required';
    public static String ERR_MSG_PTRF_NO_LAYER      = 'Invalid msg: Layer is required';
    public static String ERR_MSG_PTRF_NO_PRIMEDIE   = 'Invalid msg: Prime Die is required';
    public static String MSG_PTRF_HAS_NO_CHIP       = 'No PTRF chip found';
    public static String MSG_LAYER_NOT_FOUND        = 'Layer not found';
    //==========================
    public Set<String> layerUniqueKeySet;//Combination of ptrf number + Layer Number + Rev
    public Set<String> setLayerNumber;//set of layer name found in sfdc match msg layer
    public Set<String> setLayerRev;//set of rev found in sfdc match msg rev
    public Set<String> setPrimeDie;//set of prime die found in sfdc match msg
    public MRSPLMDRWService.PlmDrwPTRF plmPtrfData;//ptrf data in incoming msg
    public Map<String, Message> layerErrorMap;//store all layer related error, use in response msg
    map<String, MRS_Layer_Chip_Association__c> mapLayerChipByLayer;//use to store list of layer chip by each layer
    //==========================
    //public boolean onOffSwitch;//flag for turning on/off ws: currently off, may be removed
    //==========================
    
    public MRSPLMDRWServiceHandler() {
        plmPtrfData         = new MRSPLMDRWService.PlmDrwPTRF();
        layerUniqueKeySet   = new Set<String>();
        setLayerNumber      = new Set<String>();
        setLayerRev         = new Set<String>();
        setPrimeDie         = new Set<String>();
        layerErrorMap       = new Map<String, Message>();
        mapLayerChipByLayer = new map<String, MRS_Layer_Chip_Association__c>();
        //==========================
        //Environment_Variable__c switchValue = Environment_Variable__c.getInstance('SWIFT_PLM_DRWR_SWITCH'); 
        //onOffSwitch = (null != switchValue && switchValue.Value__c == 'ON') ? true : false; // if switch off, incoming request will be fail
    }
    
    /*
    * @description currently only 1 ws, if change to multiple services, this function use to fetch corresponding ws
    * @param 
    * @return 
    */
    public static MRSPLMDRWServiceHandler fetch() { 
        return new MRSPLMDRWServiceHandler(); 
    }
    
    /*
    * @description handle PLM request, main function
    * @param  
    * @return 
    */
    public void handleRequest(String jsonMsg) {
        
        try {
            Message validateMsg = validate(jsonMsg);
            if(validateMsg.isError){
                handleResponse(validateMsg.msg); //log validation error message, send error email
                return;
            }
            
            list<MRS_Layer_Chip_Association__c> layerChips = retrievePTRFLayerChips(plmPtrfData.ptrfNumber.trim(), setLayerNumber, setLayerRev, setPrimeDie);
            
            if(layerChips.isEmpty()) {
                Message errorMsg = new Message(MSG_PTRF_HAS_NO_CHIP,'',true);
                handleResponse(errorMsg.msg); //build response, send error email
                return;
            }
            
            for(MRS_Layer_Chip_Association__c lc: layerChips) {
                
                //layer unique key: ptrf number + layer number + rev
                String layerUniqueIdentifier = lc.ptrf__r.Name + lc.layer__r.Name + lc.layer__r.Mask_Layer_Rev__c;
                
                //add to layerUniqueKeySet: key
                if(!layerUniqueKeySet.contains(layerUniqueIdentifier)) { layerUniqueKeySet.add(layerUniqueIdentifier); }
                
                String layerChipUniqueIdentifier = layerUniqueIdentifier + lc.chip__r.name;
                mapLayerChipByLayer.put(layerChipUniqueIdentifier, lc);
                
                /*
                if(mapLayerChipByLayer.containsKey(layerUniqueIdentifier)) {                
                    list<MRS_Layer_Chip_Association__c> listLayerChipByLayer = mapLayerChipByLayer.get(layerUniqueIdentifier);
                    listLayerChipByLayer.add(lc);
                    mapLayerChipByLayer.put(layerUniqueIdentifier, listLayerChipByLayer);
                } else {                    
                    list<MRS_Layer_Chip_Association__c> listLayerChipByLayer = new list<MRS_Layer_Chip_Association__c>();
                    listLayerChipByLayer.add(lc);
                    mapLayerChipByLayer.put(layerUniqueIdentifier, listLayerChipByLayer);
                }
                */
            }
            
            processWS(); //main processing: update DRW status
            handleResponse();//build response, send error email
        } catch(Exception e) {
            String ptrfNumber = (null == plmPtrfData) ? '' : plmPtrfData.ptrfNumber;
            SWIFT_Application_Log__c exLog = logUnhandledException(e, jsonMsg, plmPtrfData.messageId, 'MRSPLMDRWServiceHandler', 'handleRequest', ptrfNumber);
            sendErrorEmail('Unhandled Exception', e, e.getMessage(), exLog.id, 'MRSPLMDRWServiceHandler', plmPtrfData.messageID, '', plmPtrfData.ptrfNumber, '');
        }
    }
    
    /*
    * @description 
    *       - perform runtime error validation (missing layer, incorrect status...)
    *       - perform DRW complete for matching layer chip records
    *       - call out for response
    * @param  
    * @return 
    */
    public void processWS() {
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>(); //store layer chip for updating
        
        //loop through all layers in message
        for(MRSPLMDRWService.PlmDrwLayer layer: plmPtrfData.layers) {
            
            //msg layer unique key: ptrf number + layer number + rev
            String layerUniqueIdentifier = plmPtrfData.ptrfNumber.trim() + layer.maskLayerNumber.trim() + layer.maskRev.trim();
            
            //layer not found
            if(!layerUniqueKeySet.contains(layerUniqueIdentifier)) {
                layerErrorMap.put( layerUniqueIdentifier, new Message(MSG_LAYER_NOT_FOUND,'',true) );
                continue;
            }
            
            for(MRSPLMDRWService.PlmDrwPrimeDie primeDie: layer.primeDies) {
                
                String layerChipUniqueIdentifier = layerUniqueIdentifier + primeDie.primeDie.trim();
                
                if(!mapLayerChipByLayer.containsKey(layerChipUniqueIdentifier)) {
                    layerErrorMap.put( layerChipUniqueIdentifier, new Message('PrimeDie not found','',true) );
                    continue;
                }
                
                MRS_Layer_Chip_Association__c tempChip = mapLayerChipByLayer.get(layerChipUniqueIdentifier);
                
                //invalid layer status: only 'In Progress' will be proceed
                if('Shipped;Released'.containsIgnoreCase(tempChip.layer__r.layer_status__c)) {
                    layerErrorMap.put( layerChipUniqueIdentifier, new Message('Invalid layer status: ' + tempChip.layer__r.layer_status__c,'',true) );
                    continue;
                }
                
                if(tempChip.layer_chip_status__c == 'Cancel') { 
                    layerErrorMap.put( layerChipUniqueIdentifier, new Message('Layer/Chip is deselected','',false) );
                    continue; 
                }
                
                if('In Progress' == tempChip.DRW__c) {
                    lcToUpdateList.add( new MRS_Layer_Chip_Association__c(Id = tempChip.Id,DRW__c = 'Done') );
                } else if('Not Ready' == tempChip.DRW__c) {
                    layerErrorMap.put( layerChipUniqueIdentifier, new Message('DRW Start signal is not done','',true) );
                }
            }
        }
        //post processing: save DML
        postProcessing(lcToUpdateList);
    }
    
    /*
    * @description post processing
    *       - Save DML to DB -> check if saving error then response
    * @param  
    *       - List<MRS_Layer_Chip_Association__c> lcToUpdateList
    * @return void
    */
    public void postProcessing(List<MRS_Layer_Chip_Association__c> lcToUpdateList) {
        
        if(lcToUpdateList.isEmpty()) { return; }
        
        //lcToUpdateList only contain id and drw__c field in purpose of not override other request by race condition
        //query again the list to get other value for comparing and logging, key to map is record Id
        map<Id, MRS_Layer_Chip_Association__c> mapGetValueList = new map<Id, MRS_Layer_Chip_Association__c>([select id,layer__r.Name,layer__r.Mask_Layer_Rev__c,ptrf__r.Name,chip__r.name from MRS_Layer_Chip_Association__c where id IN :lcToUpdateList]);
        Database.SaveResult[] updateResult = database.update(lcToUpdateList, false); //DML to update layer chip        
        
        for (Integer i=0; i< updateResult.size(); i++) {            
            if( !updateResult.get(i).isSuccess() ) {
                String key = lcToUpdateList.get(i).id;
                String layerChipUniqueIdentifier = mapGetValueList.get(key).ptrf__r.Name 
                    + mapGetValueList.get(key).layer__r.Name 
                    + mapGetValueList.get(key).layer__r.Mask_Layer_Rev__c 
                    + mapGetValueList.get(key).chip__r.name;
                layerErrorMap.put( layerChipUniqueIdentifier, new Message(updateResult.get(i).getErrors().get(0).getmessage(),'',true) );
            }
        }
    }
    
    /*
    * @description handle response in case validation error happens
    *       - log request and error response
    *       - send out error email to swift_admin
    * @param msg incoming message
             errorMsg validation error message
    * @return 
    */
    public void handleResponse(String errorMsg) {
        String logId = logValidationError(json.serialize(plmPtrfData), errorMsg, plmPtrfData.messageID, 'MRSPLMDRWServiceHandler', 'handleRequest', 'ERROR', plmPtrfData.ptrfNumber).Id;
        list<PTRF__c> thisPtrf = [select id,Mask_Set_Title_Name__c from ptrf__c where name = :plmPtrfData.ptrfNumber.trim()]; 
        String mst = !thisPtrf.isEmpty() ? thisPtrf.get(0).Mask_Set_Title_Name__c : '';
        sendErrorEmail('', null, errorMsg, logId, 'MRSPLMDRWServiceHandler', plmPtrfData.messageID, mst, plmPtrfData.ptrfNumber, errorMsg);
    }
    
    /*
    * @description build & send response message if ws process ok without validation error (runtime error will response as failures)
    *       - log request and error response
    *       - send out error email to swift_admin
    * @param 
    * @return 
    */
    public void handleResponse() {
        
        String logLevel = 'DEBUG';
        //consolidate error into 1 response (log capturing)
        TransactionStatus trStatus = new TransactionStatus(plmPtrfData.messageID, plmPtrfData.ptrfNumber, 'SUCCESS', '');//String transactionStatus, String transactionErrorMsg
        set<String> trErrorMsg = new set<String>();//use to store all layer level error message, deduplicate and consolidate into transaction error msg 
                
        //loop through all layers in message, build response with same structure
        for(MRSPLMDRWService.PlmDrwLayer layer: plmPtrfData.layers) {
            
            LayerStatus laStatus = new LayerStatus('', '', layer.maskLayerNumber, layer.maskRev);
            
            //msg layer unique key: ptrf number + layer number + rev
            String layerUniqueIdentifier = plmPtrfData.ptrfNumber.trim() + layer.maskLayerNumber.trim() + layer.maskRev.trim();
            
            if(layerErrorMap.containsKey(layerUniqueIdentifier)) {
                laStatus.status     = layerErrorMap.get(layerUniqueIdentifier).getStatus();//layer status
                laStatus.errorMsg   = layerErrorMap.get(layerUniqueIdentifier).msg;//layer error msg
                logLevel            = 'ERROR';//use to save log
                trErrorMsg.add(laStatus.errorMsg);//put errors in a set
            } else {
                
                for(MRSPLMDRWService.PlmDrwPrimeDie primeDie: layer.primeDies) {
                    String layerChipUniqueIdentifier = layerUniqueIdentifier + primeDie.primeDie.trim();
                    PrimeDieStatus pdStatus= new PrimeDieStatus();
                    pdStatus.primeDie = primeDie.primeDie;
                    
                    if(layerErrorMap.containsKey(layerChipUniqueIdentifier)) {
                        pdStatus.status     = layerErrorMap.get(layerChipUniqueIdentifier).getStatus();
                        pdStatus.errorMsg   = layerErrorMap.get(layerChipUniqueIdentifier).msg;
                        trErrorMsg.add(pdStatus.errorMsg);
                        logLevel            = 'ERROR';//use to save log
                    } else {
                        pdStatus.status     = 'SUCCESS';
                        pdStatus.errorMsg   = '';
                    }
                    
                    laStatus.primeDies.add(pdStatus);
                }
                
                laStatus.status     = 'SUCCESS';
                laStatus.errorMsg   = '';
                
                if(trStatus.transactionErrorMsg.containsIgnoreCase('unable to obtain exclusive access')) {
                    laStatus.status     = 'ERROR';
                }
            }            
            trStatus.layerStatus.add(laStatus);//put layer status in transaction status
        }
        
        //transaction error message, consolidate all errors at layer level
        trStatus.transactionErrorMsg = String.join(new list<String>(trErrorMsg), ', ');
        
        //if concurrency: transaction status is ERROR, else processing complete mean SUCCESS
        if(trStatus.transactionErrorMsg.containsIgnoreCase('unable to obtain exclusive access')) {
            trStatus.transactionStatus = 'ERROR:SFDC';
        }
      
        //log: payload, response
        String logId = logValidationError(json.serialize(plmPtrfData), json.serialize(trStatus), plmPtrfData.messageID, 'MRSPLMDRWServiceHandler', 'handleRequest', logLevel, plmPtrfData.ptrfNumber).Id;
        PTRF__c thisPtrf = [select id,Mask_Set_Title_Name__c from ptrf__c where name = :plmPtrfData.ptrfNumber.trim()];
        //if layerErrorMap.size > 0: send email
        if(!trErrorMsg.isEmpty()) {
            sendErrorEmail('', null, json.serialize(trStatus), logId, 'MRSPLMDRWServiceHandler', plmPtrfData.messageID, thisPtrf.Mask_Set_Title_Name__c, plmPtrfData.ptrfNumber, trStatus.transactionErrorMsg);
        }
    }
    
    /*
    * @description common validation
    * @param  
    * @return 
    */
    public Message validate(String msg) {
        
        Message formatValidationResult = validateFormat(msg);
        if(formatValidationResult.isError) return formatValidationResult;
        
        list<PTRF__c> ptrfList = [select Id,Tech_Geo_Value__c,Status__c from PTRF__c where Name = :plmPtrfData.ptrfNumber];
        if( ptrfList.isEmpty() ) {  
            return new Message('PTRF not found in MRS','', true);//check ptrf exist in mrs
        } else if( ptrfList.get(0).Status__c != 'Perform Tapeout Options' ) {
            return new Message('Invalid PTRF Status: ' + ptrfList.get(0).Status__c,'', true);//check ptrf status is PTO
        } else {
            //add validation for tech geo cut-off
        }
        
        return new Message('','', false);//no validation error
    }
    
    /*
    * @description validate format of msg
    *               - Extract json msg to MRSPLMDRWService.PlmDrwPTRF class
    * @param  
    * @return 
    */
    public Message validateFormat(String msg) {
        
        this.plmPtrfData = (MRSPLMDRWService.PlmDrwPTRF) JSON.deserialize(msg, MRSPLMDRWService.PlmDrwPTRF.class);//parse data from incoming message
        set<String> strInvalidMsg = new set<String>();
        
        if( String.isBlank(plmPtrfData.messageID) )                         { strInvalidMsg.add( ERR_MSG_NO_MSGID ); }//msgId is required
        if( String.isBlank(plmPtrfData.ptrfNumber) )                        { strInvalidMsg.add( ERR_MSG_NO_PTRF ); }//ptrf is required
        if( null == plmPtrfData.layers || plmPtrfData.layers.isEmpty() )    { strInvalidMsg.add( ERR_MSG_PTRF_NO_LAYER ); }//layer is required
        else {
            //extract layer & chip from message
            for(MRSPLMDRWService.PlmDrwLayer layer: plmPtrfData.layers) {
                
                this.setLayerNumber.add(layer.maskLayerNumber.trim());
                this.setLayerRev.add(layer.maskRev.trim());
                
                if(null == layer.primeDies || layer.primeDies.size() == 0) { strInvalidMsg.add( ERR_MSG_PTRF_NO_PRIMEDIE ); }
                else {
                   for(MRSPLMDRWService.PlmDrwPrimeDie prime: layer.primeDies) {
                       this.setPrimeDie.add(prime.primeDie.trim());
                   }
                }
            }
        }
        list<string> errList = new list<string>();
        errList.addAll(strInvalidMsg);
        if( !strInvalidMsg.isEmpty() ) { return new Message(String.join( errList, ','),'', true); }//if there are any format error: response failure
        
        return new Message('','', false);//no format validation error
    }
    
    /*
    * @description query layer chip from ptrf & layer & rev
    * @param
    *        ptrfNumber PTRF number        
    *        setMaskLayer a set of mask layer number
    *        setMaskRev a set of mask layer revision
    * @return a list of layer chip
    */
    public List<MRS_Layer_Chip_Association__c> retrievePTRFLayerChips(String ptrfNumber, set<string> setMaskLayer, set<string> setMaskRev, set<string> setChip) {
        return [
            SELECT ID,ptrf__r.Name,layer__r.Name,layer__r.Mask_Layer_Rev__c,layer__r.layer_status__c,DRW__c,DRW_Date__c,layer_chip_status__c,chip__r.name
            FROM MRS_Layer_Chip_Association__c
            WHERE PTRF_Number__c    =   :ptrfNumber
                AND Mask_Layer__c   IN  :setMaskLayer
                AND Rev__c          IN  :setmaskrev
                AND Chip_Name__c    IN  :setChip
        ];
    }
    
    /*
    * @description send response message
    *           - currently there are no separate service for response at PLM side
    * @param jsonMsg response message in json format
    * @return 
    */
    @future(callout=true)
    public static void sendResponse(String messageId, String jsonMsg) {  }
    
    /*
    * @description      - Log validation error
    *                   - Log all incoming message and respone message if debug mode is ON
    * @param errorMsg   - Validation error message
    *                   - OR: response message if debug mode is on
    * @param debugLevel     DEBUG | ERROR 
    *        msg original request message
    * @return 
    */
    public static SWIFT_Application_Log__c logValidationError(String wsMsg, String errorMsg, String msgId, String className, String methodName, String debugLevel, String ptrfNumber){
        if(wsMsg.length() > 32000){ wsMsg   = wsMsg.subString(0,32000); }
        if(errorMsg.length() > 32000){ errorMsg   = errorMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
            Debug_Level__c            = debugLevel     ,     Apex_Component_Name__c  = className    ,     Method__c          = methodName,    
            Integration_Payload__c    = wsMsg          ,     Stack_Trace__c          =       ''     ,     Error_Message__c   =  errorMsg,
            Message_ID__c             = msgId + ' | ' + ptrfNumber
        );
        insert log; 
        return log;
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
        
        //if(e.getTypeName() == 'DmlException') {
        if(e != null && e.getMessage().containsIgnoreCase('unable to obtain exclusive access')) {
            //if(e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) {
            log.Is_Auto_Retry__c = true;
            log.Retry_Status__c = 'New';    
            //}
        }
        
        insert log; 
        return log;
    }
    
    /*
    * @description send error email in case of unhandled exception or validation/runtime error
    * @param 
    *       - Exception e       : can be null
    *       - Message errorMsg  : if e == null > this field required, else null
    *       - String logId      : id of application log record 
    *       - String wsClass    : name of running class
    *       - String msgId      : id of incoming msg
    *       - String mst        : mask set title of ptrf
    *       - String ptrfNumber
    * @return void (send email)
    */
    public static void sendErrorEmail(String subjectPrefix, Exception e, String errorMsg, String logId, String wsClass, String msgId, String mst, String ptrfNumber, String errorAppendToSubject){
        
        String source = 'MRS-PLM-DRWR';
        EmailTemplate template= [select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:MRSApprovalUtility.SWIFT_WS_Unhandled_Exception];
        
        String subject = ('' == subjectPrefix || null == subjectPrefix) ? template.subject : template.subject + ' ' + subjectPrefix;
        subject        = subject.replace('<Source>', source);
        
        String subMsg = ' <' + ptrfNumber + '> ';//append to subject
        String bodyMsg = '';//put in error of body
        if(null != e) { 
            subMsg += e.getMessage();
            bodyMsg += e.getMessage();
        } else { 
            subMsg += ' # ' + errorAppendToSubject;
            bodyMsg += errorMsg;
        }
        
        subject             = subject.replace('<Message>', subMsg);
        //===========================================================================
        String body         = template.Body ;
        body                = body.replace('<Status_Type>', '');//TODO
        body                = body.replace('<Source>', '');//TODO
        //===========================================================================
        body                = body.replace('<MessageId>', msgId);
        body                = body.replace('<timestamp>', String.valueOf(System.now()));
        body                = body.replace('<MST>', mst);
        body                = body.replace('<PTRF>', ptrfNumber + '\r\n');
        body                = body.replace('<Message>', '\r\n**********************\r\n' + bodyMsg + '\r\n**********************\r\n');
        body                = body.replace('<Debug_Log_Url>', URL.getSalesforceBaseUrl().toExternalForm() + '/' + logId);
        
        List<Email_Config_Settings__c> ecsList = [
            SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c,Foundry_Jobviewer_Type__c,Name,MPW_PTRF__c,Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c 
            FROM Email_Config_Settings__c 
            WHERE Email_Template_Name__c = :MRSApprovalUtility.SWIFT_WS_Unhandled_Exception and Available_For_Use__c = true and Source__c = :source and RecordType.Name = 'General' limit 1
        ];
        
        //build recipients
        Map<String, List<String>> recipientList = MRSApprovalUtility.buildRecipientList(ecsList);
        //construct email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        mail.setToAddresses( recipientList.get('TO') );
        mail.setCcAddresses( recipientList.get('CC') );
        mail.setBccAddresses( recipientList.get('BCC') );
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        if(!recipientlist.get('TO').isEmpty() || !recipientlist.get('CC').isEmpty() || !recipientlist.get('BCC').isEmpty()) {
            if(!Test.isRunningTest()) Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail}  );
        }
    }
    
    public static String SUCCESS   = 'SUCCESS';
    public static String ERROR     = 'ERROR';
    public class Message {
        public String msg;
        public String description;
        public boolean isError;
        
        public Message(String msg, String description, boolean isError) {
            this.msg            = msg;
            this.description    = description;
            this.isError        = isError;
        }
        
        public String getStatus() {
            if(isError) return MRSPLMDRWServiceHandler.ERROR;
            return MRSPLMDRWServiceHandler.SUCCESS;
        }
    }
    
    /**
    * This class is used to stored response message.
    * For PLM-DRW, this class specific use in logging
    */
    public class TransactionStatus {
        public String messageId;
        public String ptrfNumber;
        public String transactionStatus;
        public String transactionErrorMsg;
        public list<LayerStatus> layerStatus;
        
        public TransactionStatus(String messageId, String ptrfNumber, String transactionStatus, String transactionErrorMsg) {
            this.messageId = messageId;
            this.ptrfNumber = ptrfNumber;
            this.transactionStatus = transactionStatus;
            this.transactionErrorMsg = transactionErrorMsg;
            this.layerStatus = new list<LayerStatus>();
        }
    }
    
    public class LayerStatus {
        public String status;
        public String errorMsg;
        public String maskLayerNumber;
        public String maskLayerRev;
        public list<PrimeDieStatus> primeDies;
        
        public LayerStatus(String status, String errorMsg, String masklayerNumber, String maskLayerRev) {
            this.masklayerNumber = masklayerNumber;
            this.maskLayerRev = maskLayerRev;
            this.status = status;
            this.errorMsg = errorMsg;
            this.primeDies = new list<PrimeDieStatus>();
        }
    }
    
    public class PrimeDieStatus {
        public String status;
        public String errorMsg;
        public String primeDie;
    }
}