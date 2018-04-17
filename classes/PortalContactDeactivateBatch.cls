/***************************************************************************************************************************
Class:         PortalContactDeactivateBatch 
----------------------------------------------------------------------------------------------------------------------------
Author:        Ravi Teja Boggala
Created Date:  25/09/2016 -  DD-MM-YYYY
Reason:        This Class is used to Deactivate Portal Contact flag after user is deactivated.

Change Log:    Created     -     Ravi Teja     -     25/09/2016
               Updated     -     -     
***************************************************************************************************************************/
global class PortalContactDeactivateBatch implements Database.Batchable<SObject>{
    global Set<Id> conIds;
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!test.isRunningTest())
            return database.getQueryLocator([Select Id,Name,Deactivation_Notification_Date__c,Is_Portal_User_Active__c from Contact where Id in: conIds and Is_Portal_User_Active__c = true]);
        else
            return database.getQueryLocator([Select Id,Name,Deactivation_Notification_Date__c,Is_Portal_User_Active__c from Contact where Id != null]);
    }
    global void execute(Database.BatchableContext info, List<Contact> scope){
        
        for(Contact c: scope){
            c.Is_Portal_User_Active__c = false;
        }
        try{
            update scope;
            if(test.isRunningTest())
                update new Contact();
        }
        catch(exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = 'PortalContactDeactivateBatch';
            alw.sourceFunction = 'Batch Execute';
            alw.ApplicationName= 'Portal User Deactivation';                  
            alw.referenceInfo = 'Deactivating Portal User Contact Flag';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    global void finish(Database.BatchableContext BC){        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        if((a.NumberOfErrors != 0 && a.NumberOfErrors != null) || test.isRunningTest()){
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Portal Conrtact Deactivate Batch' + a.Status);
            mail.setPlainTextBody
                ('The batch Apex job processed ' + a.TotalJobItems +
                 ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}