/*
Author: - Suvajit Majumder 
Code creation:- Dec 2015


*/

Global without sharing class InsertAgreSharesBatch implements Database.Batchable<Apttus__APTS_Agreement__Share>,Database.Stateful
{
    
    String emailAddress = EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION');
    global List<Apttus__APTS_Agreement__Share> AgrShares = new List<Apttus__APTS_Agreement__Share>();
    
    global InsertAgreSharesBatch(List<Apttus__APTS_Agreement__Share> AgrSharesList)
    {
        this.AgrShares = AgrSharesList;
    }

    global List<Apttus__APTS_Agreement__Share> start(Database.BatchableContext BC)
    {
        
        return this.AgrShares;

    }
    
    global void execute(Database.BatchableContext BC,List<Apttus__APTS_Agreement__Share> scope)
    {
        
       insert scope;
    }
    
    global void finish(Database.BatchableContext BC)
    {
            AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {emailAddress};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Apex Sharing Recalculation Completed.');
            mail.setPlainTextBody('The Apex sharing recalculation finished processing '+ a.TotalJobItems +' batches with '+ a.NumberOfErrors + '\nfailures.ExtendedStatus: ' + a.ExtendedStatus+'\nJob Item processed are'+a.JobItemsProcessed);
            if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}