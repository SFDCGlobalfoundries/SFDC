/*
Type Name: RetryMRSLayerStatusSyncdotNETBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetryMRSLayerStatusSyncdotNETBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM MRS_Layer_Chip_Association__c WHERE Trigger_Sync_Layer_Status__c= TRUE AND Sync_PTRF_Layer_to_SWIFT_dotNET__c = false AND LastModifieddate < TODAY';
       global final String Field = 'Trigger_DotNet_Sync_Manual__c';
       global final boolean Value = TRUE;*/

       global String Query = 'SELECT Id, Name FROM MRS_Layer_Chip_Association__c WHERE Trigger_Sync_Layer_Status__c= TRUE AND Sync_PTRF_Layer_to_SWIFT_dotNET__c = false AND LastModifieddate < TODAY';
       global String Field = 'Trigger_DotNet_Sync_Manual__c';
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
          Environment_Variable__c  cs =[select id from Environment_Variable__c where name ='MRSSyncObject' limit 1];
          cs.Value__c='MRSPrimeFramedotNET';
          update cs;
          // try again in 10 minutes
          Datetime sysTime = System.now().addMinutes( 10 );
          String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

          RetryMRSSyncSchedulable scheduledBatch = new RetryMRSSyncSchedulable();
          if(!Test.isRunningTest())
          System.schedule( 'SyncMRSObjects ' + sysTime, chronExpression, scheduledBatch );                
       }
       else
       {
            RetryMRSPrimeFrameSyncdotNETBatchable batch = new RetryMRSPrimeFrameSyncdotNETBatchable();
            Database.executeBatch( batch, 100 );             
       }
   }
}