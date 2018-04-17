/*
Type Name: RetryDRTPTRFsyncOracleBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetryDRTPTRFsyncOracleBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM DRT_PTRF_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifiedDate < TODAY';
       global final String Field = 'Trigger_Oracle_DB_Sync_Manual__c';
       global final boolean Value = TRUE;*/
       
       global String Query = 'SELECT Id, Name FROM DRT_PTRF_Association__c WHERE Synced_with_Oracle_DB__c = false AND LastModifiedDate < TODAY';
       global String Field = 'Trigger_Oracle_DB_Sync_Manual__c';
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
          cs.Value__c='DRTLayerChip';
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
            RetryDRTLayerChipSyncOracleBatchable batch = new RetryDRTLayerChipSyncOracleBatchable();
            Database.executeBatch( batch, 100 );             
       }
   }
}