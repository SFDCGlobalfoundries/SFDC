/*
Author: - Suvajit Majumder 
Code creation:- Dec 2015
*/

Global without sharing class AgreementAccessCalculationBatch implements Database.Batchable<sObject>,Database.Stateful
{
    
    static String emailAddress = EnvironmentVariable.get('CLM_ADMIN_MAIL_BATCH_NOTIFICATION');
    
    global List<Apttus__APTS_Agreement__Share> NewNDAShares  = new List<Apttus__APTS_Agreement__Share>();  
    
    global Map<ID, Apttus__APTS_Agreement__c> agrMasterMap   = new Map<ID, Apttus__APTS_Agreement__c>();
   
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query= 'select id,OwnerId from Apttus__APTS_Agreement__c where isDeleted=False and RecordType.DeveloperName not in (\'Finance_Treasury_Agreements\',\'IP_EDA_Agreements\',\'Legal_Agreements\',\'Procurement_Agreements\',\'Sales_Agreements\',\'TD_Agreements\') and OwnerId in (select id from user where UserRole.DeveloperName=\'General_TD_Non_Legal\' and isActive=True)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        try 
        {
            // Create a map for the chunk of records passed into method.
            Map<ID, Apttus__APTS_Agreement__c> agrMap = new Map<ID, Apttus__APTS_Agreement__c>((List<Apttus__APTS_Agreement__c>)scope); 
            
            //add this set of records to a master map to track old shares in finish method
            
            agrMasterMap.putAll(agrMap); 
  

            List<User> usrlist=[select id from user where UserRole.DeveloperName='General_TD_Non_Legal' and IsActive=True];
            
            for(Apttus__APTS_Agreement__c agr : agrMap.values())
                {
                    for(User u: usrlist)
                    {
                        if(u.id!=agr.OwnerId)
                        {
                             Apttus__APTS_Agreement__Share NDAShare  = new Apttus__APTS_Agreement__Share();
                             NDAshare.ParentId = agr.Id;
                             NDAshare.UserOrGroupId = u.id;
                             NDAshare.AccessLevel = 'Edit';
                             NDAshare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.Share_NDA_records_with_TD_Non_Legal_Role__c;
                             NewNDAShares.add(NDAshare);
                         }
                    }
                    
                }
        } 
        catch(DmlException e) 
        {
               // Send an email to the Apex job's submitter on failure.
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {emailAddress};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Apex Sharing Recalculation Exception');
                mail.setPlainTextBody('The Apex sharing recalculation threw the following exception: '+e.getMessage());
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }     
 
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
            mail.setPlainTextBody('The Apex Batch Apex slots are full. Please try again later!');
            if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
        }
        if(jobs < 4 || Test.isRunningTest())
        {
           // Locate all existing sharing records for the records in the batch. 
           
            List<Apttus__APTS_Agreement__Share> OldNDAShares=new List<Apttus__APTS_Agreement__Share>([SELECT Id FROM Apttus__APTS_Agreement__Share WHERE ParentId IN :agrMasterMap.keySet() and RowCause not in ('Rule','Owner')]);
          
            DeleteOldAgrSharesBatch DeleteBatch = new DeleteOldAgrSharesBatch(OldNDAShares,NewNDAShares);  
            Database.executeBatch( DeleteBatch,Limits.getLimitDMLRows());
        }
            
           
        }
         
    }