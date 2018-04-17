/**
* @ Author :- Navneet Rajput
* @ Company :- Globalfoundries
* @ Description :- This class is helper class for DRC service class. It will handle common operations of DRC service              
* @ Date :- 10/03/2016
* @ Change History :- 
**/

public with sharing class GF_CommonErrorLogger {
    
    
    public static void creatLogs (String applicationName,String moduleName,String contextType,
                                    Exception exp, DateTime errorLogTime){
        	
        	string ErrorMessage = exp.getMessage();
        	string stackStrace = exp.getStackTraceString();
            
            Map<String,string> mapOfEloggerInfoFiels = new Map<String,string> {
                        'applicationName'   => applicationName,
                        'moduleName'        => moduleName,
                        'contextType'       => contextType,
                        'ErrorMessage'      => ErrorMessage,
                        'errorLogTime'      => string.valueOf(errorLogTime)
            };
                                                                    
            if (MandatoryFieldValidator.createDFM(mapOfEloggerInfoFiels).contains('Success')) {
                GF_ErrorLogger__c errorLogger = new GF_ErrorLogger__c(
                                                 Application_Name__c = applicationName
                                                ,Module_Name__c = moduleName
                                                ,Context_Type__c = contextType
                                                ,Error_Message__c = ErrorMessage
                                                ,Time_Stamp__c = errorLogTime
                                                ,Stack_Trace__c = stackStrace);
                        
                insert errorLogger;                                         
            }                                               
        
    }
    
    // notify error/exception to developer team, Admin as well app owner
    
    public static void sendErrorNotification (String appName,Exception e,List<String> toAddresses) {
        
        List<String> ccAddresses = new List<String>();
        String orgName = UserInfo.getOrganizationName();
        Integer lineNo = e.getLineNumber();
        String message = e.getMessage();
        String stackTrace = e.getStackTraceString();
        string eType = e.getTypeName();
        String subject = 'Notification : Error has been reported in '+orgName;
        String body = '<html>'
	                    +'<h3> <b>Title:</b> Error Notification </h3><br>'
	                    +'<p> <b>Exception on line number</b>  '+lineNo+' <br>'
	                    +'<b> Exception Type </b> '+eType +'<br>'
	                    +'<b>Stack Trace</b> '+ stackTrace+'<br>'
	                    +'<b>Message</b> '+ message +'<br><br>'
	                    +'Thanks & Regards,<br><br>'
	                    +UserInfo.getFirstName()+' '+UserInfo.getLastName()+
	                 '</html>';
	    
	    toAddresses = Emails_4_Exception_Notifications__c.getValues('Email_Ids')!=null?
	    				Emails_4_Exception_Notifications__c.getValues('Email_Ids').value__c.split(';'):null;  
	                 
        //send plain text body
        List<String> bccAddr = new List<String>();
        List<String> ccAddr = new List<String>();
        DfmEmailUtility emailUtil = new DfmEmailUtility(toAddresses,ccAddr,bccAddr); 
         if(!Test.isRunningTest()){
        emailUtil.htmlBody(body)
                 .senderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName())
                 .subject(subject)
                 .sendEmail();
         }
    }
    
}