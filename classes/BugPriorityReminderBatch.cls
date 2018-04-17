/*Author: UCM Team
* Description: This class is used to send notification if no one updated the bug if Priority is P1 or P2. 
* History: Created on 01/30/2018
*/
global class BugPriorityReminderBatch implements Database.Batchable<sObject> {
   
    global string query;
    global datetime p1Date;
    global Map<String,Environment_Variable__c> asicPriorityMap = Environment_Variable__c.getall();
    
    global database.querylocator start(Database.BatchableContext BC) {
        
        query =  ' Select id,Priority__c,Problem_Class__c,Assigned_To__r.email,Projected_Availability_Date__c,Dev_Only__c,DevComplete__c,IsASICBug__c,name,LastModifiedDate,CreatedDate,owner.email,Status__c from bug__c where Status__c != \'Closed\' and Status__c != \'Resolved\' '+
                 ' and Status__c != \'Duplicate\' and Dev_Only__c = \'NO\' and DevComplete__c = false and IsASICBug__c = true ';
              
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext BC, List<Bug__c> scope){
       try {
            
            String stTargetId = [SELECT Id FROM Contact WHERE Email = 'noreply-salesforce@globalfoundries.com' LIMIT 1].id;
            
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
           
            EmailTemplate templateId = [Select id from EmailTemplate where Developername = 'Bug_Priority_Alert'];
            
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;
                                  
                
               for(Bug__c bugObj:scope){
               
               
               String[] toAddresses = new String[] {bugObj.owner.email,bugObj.Assigned_To__r.email};
                
                if(bugObj.Priority__c != null && asicPriorityMap.get(bugObj.Priority__c) != null) { 
                    p1Date = System.now() - Integer.ValueOf(asicPriorityMap.get(bugObj.Priority__c).Value__c);
                
                    if(bugObj.Problem_Class__c != 'Enhancement' && asicPriorityMap.get(bugObj.Priority__c) != null && bugObj.LastModifiedDate < p1Date) {
                        mail = new Messaging.SingleEmailMessage();                    
                        mail.setTargetObjectId(stTargetId);
                        mail.setSaveAsActivity(false);
                        mail.setOrgWideEmailAddressId(owa.Id);
                        mail.setWhatId(bugObj.id); 
                        mail.setToAddresses(toAddresses);
                        mail.setTemplateID(templateId.Id);
                        allmsg.add(mail);
                    } else if(bugObj.Problem_Class__c == 'Enhancement' && bugObj.Projected_Availability_Date__c > system.today() && asicPriorityMap.get(bugObj.Priority__c) != null && bugObj.LastModifiedDate < p1Date) {
                        mail = new Messaging.SingleEmailMessage();                    
                        mail.setTargetObjectId(stTargetId);
                        mail.setSaveAsActivity(false);
                        mail.setOrgWideEmailAddressId(owa.Id);
                        mail.setWhatId(bugObj.id); 
                        mail.setToAddresses(toAddresses);
                        mail.setTemplateID(templateId.Id);
                        allmsg.add(mail);
                    }              
                }
            }
            
                       
                        
            if(allmsg.size()>0){                                
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg,false);
                
                if (results[0].success) {
                system.debug('test assigned user success');
                } else {
                    System.debug('The email failed to send: '+ results[0].errors[0].message);
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            } 
        }
        catch (Exception e) {
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = BugPriorityReminderBatch.class.getName();
            alw.sourceFunction ='execute()';
            alw.ApplicationName='Case Management';                
            alw.referenceInfo = 'Case';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }     
    }
    global void finish(Database.BatchableContext BC){
        
    }  
    public class applicationException extends Exception {}     

}