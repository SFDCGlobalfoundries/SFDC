/*
Author: - Suvajit Majumder 
Code creation:- Dec 2015


*/

Global without sharing class DeleteOldAgrSharesBatch implements Database.Batchable<Apttus__APTS_Agreement__Share>,Database.Stateful
{
    
    String emailAddress = EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION');
    global List<Apttus__APTS_Agreement__Share> OldAgrShares = new List<Apttus__APTS_Agreement__Share>();
    global List<Apttus__APTS_Agreement__Share> NewAgrShares = new List<Apttus__APTS_Agreement__Share>();
    
    global DeleteOldAgrSharesBatch(List<Apttus__APTS_Agreement__Share> OldAgrSharesList,List<Apttus__APTS_Agreement__Share> NewAgrSharesList)
    {
        this.OldAgrShares = OldAgrSharesList;
        this.NewAgrShares = NewAgrSharesList;
    }

    global List<Apttus__APTS_Agreement__Share> start(Database.BatchableContext BC)
    {
     return this.OldAgrShares;
    }
    
    global void execute(Database.BatchableContext BC,List<Apttus__APTS_Agreement__Share> scope)
    {
    delete scope;
    }
    
    global void finish(Database.BatchableContext BC)
    {
        AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];
        if( jobs > 4 || Test.isRunningTest())
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {emailAddress};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Apex Slots Full.');
            mail.setPlainTextBody('The Apex Batch Apex slots are full. Deletion job cannot be excuted.Please try again later!');
            if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
        if( jobs < 4 || Test.isRunningTest())
        {
            InsertAgreSharesBatch InsertBatch = new InsertAgreSharesBatch(this.NewAgrShares);  
            if(!Test.isRunningTest()) Database.executeBatch( InsertBatch,Limits.getLimitDMLRows());
        }
            
           
    }

}