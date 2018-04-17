Global without sharing class CLMAgreementTaskNotificationBatch implements Database.Batchable<sObject> 
{
    Global Database.QueryLocator start(Database.BatchableContext BC)
    {
    String query = 'select id,subject from Task where Status<>\'Completed\' and IsReminderSet=TRUE and ReminderDateTime= TOMORROW and what.type=\'Apttus__APTS_Agreement__c\' and IsDeleted=FALSE and IsProcessedByCLMBatch__c=FALSE';
    return Database.getQueryLocator(query);
    }
    Global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
    
    
     Map<Id,Task> TaskMap=new Map<Id,Task>();
     
     for (sObject objScope: scope) 
     { 
        Task newObjScope = (Task)objScope ;//type casting from generic sOject to Task
        TaskMap.put(newObjScope .id,newObjScope);//Add records to the Map
        
     }
 
    AgreementTaskNotificationEmail.AgreementAssigneeIdMapProcessor(TaskMap);
    }
    
    Global void finish(Database.BatchableContext BC) 
    {
    
 
    
    
    if(!String.isEmpty(EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION')) || Test.isRunningTest())
    {
    
    
    
    AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
  
    String CLM_ADMIN_MAIL_BATCH_NOTIFICATION = String.valueOf(EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION'));  
    String AdminMail= CLM_ADMIN_MAIL_BATCH_NOTIFICATION;
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new String[] {AdminMail});
    mail.setReplyTo(CLM_ADMIN_MAIL_BATCH_NOTIFICATION);
    mail.setSenderDisplayName('CLM Agreement Task Reminder Batch Processing');
    mail.setSubject('Batch Processing '+a.Status);
    mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus+'Job Item processed are'+a.JobItemsProcessed);
    if(!Test.isRunningTest())Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    }
    
    
  
}