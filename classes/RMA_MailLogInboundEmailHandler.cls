/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: Return Material Authorization
* Description: This class is used to log emails sent from Workflows and Apex.
* History:
*    SurendranadhNune 04012016  -   Created.
*    NJain - 23Aug16 -  Included the NULL check for TO and CC Addresses. 
*                       Removing the log for noreply@salesforce.com entry from TO address    
**/
public class RMA_MailLogInboundEmailHandler implements Messaging.InboundEmailHandler {
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env){           
        try{  
            if(!email.subject.startsWith('Resend:')){
                string tempMatch='';
                boolean taskMatchFound = false;
                String rmaRegex = '(RMA[a-zA-Z0-9-]{13})';
                Pattern rmaPattern = Pattern.compile(rmaRegex);
                Matcher rmaMatcher = rmaPattern.matcher(email.subject);
                while (rmaMatcher.find()){
                    if(rmaMatcher.group(0) != NULL && rmaMatcher.group(0) != ''){
                        if(tempMatch.length() < rmaMatcher.group(0).length()){
                            tempMatch = rmaMatcher.group(0);
                            taskMatchFound = True;
                        }
                        break;
                    }
                }

                List<RMA__c> rmaList = new List<RMA__c>([SELECT ID FROM RMA__C WHERE Name like :tempMatch+'%']);
    
                if(!rmaList.isEmpty()){
                    RMA_Audit_log__c auditLog = new RMA_Audit_log__c(RecordTypeId  = RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.MAIL_LOG), 
                                                                     rma__c = rmaList[0].id);
                    auditLog.From__c = email.fromAddress;
                    if(email.toAddresses != NULL){
                        auditLog.To__c  = string.valueOf(JSON.serialize(email.toAddresses)).replace('"','').replace('[','').replace(']','').replace(',',', '); 
                        auditLog.To__c = auditLog.To__c.replace('noreply@salesforce.com','');
                    }
                    if(email.ccAddresses != NULL){
                        auditLog.CC__c  = string.valueOf(JSON.serialize(email.ccAddresses)).replace('"','').replace('[','').replace(']','').replace(',',', ');
                    }
                    auditlog.Subject__c = email.subject;  
                    auditlog.email_body__c= email.htmlbody;
                    insert auditlog;
                }
            }
        }catch(Exception e){
			GlobalUtility.logMessage('Error', RMA_MailLogInboundEmailHandler.class.getName(), 'handleInboundEmail', '','Mail Log',
                                      'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString(), 
                                      '','RMA',e, NULL);
        }
        return null;                                               
    }
}