/*
Type Name: RetryDRTsyncdotNETBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetryDRTsyncdotNETBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM DRT__c WHERE Old_Rev_DRT__c!=null AND Sync_DRT_Rev_dot_NET__c = false AND LastModifieddate < TODAY';
       global final String Field = 'Trigger_Oracle_DB_ReviseSync_Manual__c';
       global final boolean Value = TRUE;*/

       global String Query = 'SELECT Id, Name FROM DRT__c WHERE Old_Rev_DRT__c!=null AND Sync_DRT_Rev_dot_NET__c = false AND LastModifieddate < TODAY and status__c = \'Active\'';
       global String Field = 'Trigger_Oracle_DB_ReviseSync_Manual__c';
       global boolean Value = TRUE;
       
       global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(Query);
       }

       global void execute(Database.BatchableContext BC, List<sObject> scope){
         for(sobject s : scope){
             s.put(Field,Value); 
         }
         try{
             update scope;
         }catch(exception e){}
      }
      
   global void finish(Database.BatchableContext BC){
       Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if(jobs > 4 || Test.isRunningTest())
       {
          Environment_Variable__c  cs =[select id from Environment_Variable__c where name ='DRTSyncObject' limit 1];
          cs.Value__c='DRTPackage';
          update cs;
          // try again in 10 minutes
          Datetime sysTime = System.now().addMinutes( 10 );
          String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

          RetryDRTSyncSchedulable scheduledBatch = new RetryDRTSyncSchedulable();
          if(!Test.isRunningTest())
          System.schedule( 'SyncDRTObjects ' + sysTime, chronExpression, scheduledBatch );                
       }
       else
       {
            RetryDRTpackageSyncOracleBatchable batch = new RetryDRTpackageSyncOracleBatchable();
            Database.executeBatch( batch, 10 );             
       }
   }
}