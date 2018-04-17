public class MRSApprovalUtility {

    public static String SWIFT_WS_Unhandled_Exception   = 'SWIFT_Approval_Service_Unhandled_Exception';
    
    /*
    * @description log validation error 
    * @param errorMsg validation error message
    *        msg original request message
    * @return 
    */
    public static SWIFT_Application_Log__c logValidationError(MRSGeneralService.Message errorMsg, MRSApprovalService.MRSApprovalMsg msg){
        String strStrackTrace = JSON.serializePretty(msg);
        if(strStrackTrace.length() > 32000){ strStrackTrace   = strStrackTrace.subString(0,32000); }
        String strMsg = errorMsg.msg;
        if(strMsg.length() > 32000){ strMsg   = strMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
                                                Debug_Level__c            = errorMsg.isError==true?'ERROR':'DEBUG',
                                                Apex_Component_Name__c    = MRSApprovalService.WS_CLASS_NAME,
                                                Method__c                 = MRSApprovalService.WS_METHOD_NAME,
                                                Message_ID__c             = msg.messageId,
                                                Stack_Trace__c            = strMsg,
                                                Integration_Payload__c    = strStrackTrace
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
    public static SWIFT_Application_Log__c logUnhandledException(Exception e, MRSApprovalService.MRSApprovalMsg msg){
        String strMsg = JSON.serializePretty(msg);
        if(strMsg.length() > 32000){ strMsg   = strMsg.subString(0,32000); }
        SWIFT_Application_Log__c log  = new SWIFT_Application_Log__c(
                                                Debug_Level__c            = 'ERROR',
                                                Apex_Component_Name__c    = MRSApprovalService.WS_CLASS_NAME,
                                                Method__c                 = MRSApprovalService.WS_METHOD_NAME,
                                                Message_ID__c             = msg.messageId,
                                                Error_Message__c          = e.getMessage(),
                                                Stack_Trace__c            = e.getStackTraceString(),
                                                Integration_Payload__c    = strMsg
                                            );
        insert log;
        return log;
    }
    
    /*
    * @description Validate if a user exists & belongs to a specific group
    * @param employeeID HCM Login ID of user
    * @return true if user exists and belongs to the group
    */
    public static User getUserFromEmployeeID(String employeeID, String source){
        List<User> users = [Select Id from User where HCM_Login_Id__c=:employeeId];
        if( users.size()==0 ) return null;
        
        Integer c = [select count() from GroupMember where UserOrGroupId=:users.get(0).Id and Group.DeveloperName=:source];
        if(c==0) return null;
        
        return users.get(0);
    }
    
    /*
    * @description send error email in case of unhandled exception
    * @param e exception
    *        msg original message
    *        logId Id of swift application log record 
    * @return 
    */
    public static void sendErrorEmail(Exception e, MRSApprovalService.MRSApprovalMsg msg, String logId){
        EmailTemplate template= [Select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:SWIFT_WS_Unhandled_Exception];
        
        List<Email_Config_Settings__c> ecsList = [SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c,Foundry_Jobviewer_Type__c,Name,
                                                     MPW_PTRF__c,Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c 
                                                     FROM Email_Config_Settings__c 
                                                     where Email_Template_Name__c=:SWIFT_WS_Unhandled_Exception and Available_For_Use__c=true and Source__c=:msg.source and RecordType.Name='General' limit 1];
                                                     
        String subject      = template.subject;
        subject             = subject.replace('<Source>', msg.source);
        subject             = subject.replace('<Message>', e.getMessage());
        
        sendEmailNotification(subject, e.getMessage(), msg, logId, template, ecsList);
    }
    
    /*
    * @description send error email in case of unhandled exception
    * @param e exception
    *        msg original message
    *        logId Id of swift application log record 
    * @return 
    */
    public static void sendInvalidStatusEmail(String message, MRSApprovalService.MRSApprovalMsg msg, String logId){
        EmailTemplate template= [Select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:SWIFT_WS_Unhandled_Exception];
        
        List<Email_Config_Settings__c> ecsList = [SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c,Foundry_Jobviewer_Type__c,Name,
                                                     MPW_PTRF__c,Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c 
                                                     FROM Email_Config_Settings__c 
                                                     where Email_Template_Name__c=:SWIFT_WS_Unhandled_Exception and Available_For_Use__c=true and Source__c='DRR' and RecordType.Name='General' limit 1];
                                                     
        String subject      = template.subject;
        subject             = subject.replace('<Source>', 'DRR');
        subject             = subject.replace('<Message>', '#' + msg.ptrfNumber + ': Invalid Layer Chip Status');
        
        sendEmailNotification(subject, message, msg, logId, template, ecsList);
    }
    
    /*
    * @description send error email in case of unhandled exception
    * @param e exception
    *        msg original message
    *        logId Id of swift application log record 
    * @return 
    */
    public static void sendEmailNotification(String subject, String message, MRSApprovalService.MRSApprovalMsg msg, String logId, EmailTemplate template, List<Email_Config_Settings__c> ecsList){
        
        String body         = template.Body ;
        body                = body.replace('<Status_Type>', msg.statusType);
        body                = body.replace('<Source>', msg.source);
        body                = body.replace('<MessageId>', msg.messageId);
        body                = body.replace('<timestamp>', '' + msg.sourceInboundRequestTimestamp);//removed .format() / SWGP-605 / SWIFT
        body                = body.replace('<MST>', msg.maskSetTitle);
        body                = body.replace('<PTRF>', msg.ptrfNumber);
        body                = body.replace('<Message>', message);
        body                = body.replace('<Debug_Log_Url>', URL.getSalesforceBaseUrl().toExternalForm() + '/' + logId);
        
        Map<String, List<String>> recipientList = buildRecipientList(ecsList);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses( recipientList.get('TO') );
        mail.setCcAddresses( recipientList.get('CC') );
        mail.setBccAddresses( recipientList.get('BCC') );
        
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        if(!recipientlist.get('TO').isEmpty() || !recipientlist.get('CC').isEmpty() || !recipientlist.get('BCC').isEmpty())
            if(!Test.isRunningTest()) Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail}  );
    }
    
    /*
    * @description build TO, CC, BCC list from email configs
    * @param ecsList a list of email config
    * @return a map contains TO, CC, BCC list
    */
    public static Map<String, List<String>> buildRecipientList(List<Email_Config_Settings__c> ecsList){
        Map<String, List<String>> recipientList = new Map<String, List<String>>();
        recipientList.put('TO', new List<String>());
        recipientList.put('CC', new List<String>());
        recipientList.put('BCC', new List<String>());
        
        if(ecsList.isEmpty()) return recipientList;
        
        Map<String,String> mapKeytoTo      = new Map<String,String>();
        Map<String,String> mapKeytoCc      = new Map<String,String>();
        Map<String,String> mapKeytoBcc     = new Map<String,String>();
        
        for(Email_Config_Settings__c ecs: ecsList){
            mapKeytoTo.put(ecs.Email_Template_Name__c, ecs.TO__c);
            mapKeytoCc.put(ecs.Email_Template_Name__c, ecs.CC__c);
            mapKeytoBcc.put(ecs.Email_Template_Name__c, ecs.BCC__c);
        }
        
        Map<String,List<String>> MapKeyToRecvdTo  = EmailHandlerUtility.buildRecipientList(mapKeytoTo,null,null,false,null);
        Map<String,List<String>> MapKeyToRecvdCc  = EmailHandlerUtility.buildRecipientList(mapKeytoCc,null,null,false,null);
        Map<String,List<String>> MapKeyToRecvdBcc = EmailHandlerUtility.buildRecipientList(mapKeytoBcc,null,null,false,null);
        
        for(Email_Config_Settings__c ecs: ecsList){
            recipientList.get('TO').addAll( MapKeyToRecvdTo.get(ecs.Email_Template_Name__c) );
            recipientList.get('CC').addAll( MapKeyToRecvdCc.get(ecs.Email_Template_Name__c) );
            recipientList.get('BCC').addAll( MapKeyToRecvdBcc.get(ecs.Email_Template_Name__c) );
        }
        
        return recipientList;
    }
}