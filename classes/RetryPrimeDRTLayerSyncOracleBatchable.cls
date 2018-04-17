/*
Type Name: RetryPrimeDRTLayerSyncOracleBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetryPrimeDRTLayerSyncOracleBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM PRIME_DRT_Chip_Layer_Summary__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate < TODAY';
       global final String Field = 'Trigger_Oracle_DB_Sync_Manual__c';
       global final boolean Value = TRUE;*/

       global String Query = 'SELECT Id,IsSoftDeleted__c, Name FROM PRIME_DRT_Chip_Layer_Summary__c WHERE Synced_with_Oracle_DB__c = false AND IsSoftDeleted__c = False AND LastModifieddate < TODAY';
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
       if( jobs > 4 || Test.isRunningTest())
       {
          Environment_Variable__c  cs =[select id from Environment_Variable__c where name ='MRSSyncObject' limit 1];
          cs.Value__c='FrameDRT';
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
            RetryDRTassctnSyncOracleBatchable batch = new RetryDRTassctnSyncOracleBatchable();
            Database.executeBatch( batch, 50 );             
       }
   }
}