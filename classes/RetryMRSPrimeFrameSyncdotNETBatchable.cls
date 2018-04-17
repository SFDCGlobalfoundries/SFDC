/*
Type Name: RetryMRSPrimeFrameSyncdotNETBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetryMRSPrimeFrameSyncdotNETBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM MRS_Layer_Chip_Association__c WHERE (All_Send_Frame_Done__c = TRUE OR All_Send_Prime_Done__c=TRUE) AND Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false AND LastModifieddate < TODAY';
       global final boolean Value = TRUE;*/

       global String Query = 'SELECT Id, Name,All_Send_Prime_Done__c,All_Send_Frame_Done__c FROM MRS_Layer_Chip_Association__c WHERE (All_Send_Frame_Done__c = TRUE OR All_Send_Prime_Done__c=TRUE) AND Sync_PTRF_Layer_SendPrimeFrame_dotNET__c = false AND LastModifieddate < TODAY';
       global boolean Value = TRUE;
       
       global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(Query);
       }

       global void execute(Database.BatchableContext BC, List<sObject> scope){
         for(sobject s : scope){
             MRS_Layer_Chip_Association__c lc = new MRS_Layer_Chip_Association__c();
             lc= (MRS_Layer_Chip_Association__c) s;
             if(lc.All_Send_Prime_Done__c){
                 s.put('Trigger_Oracle_DB_SendPrimeSync_Manual__c',Value); 
             }
             if(lc.All_Send_Frame_Done__c){
                 s.put('Trigger_Oracle_DB_SendFrameSync_Manual__c',Value); 
             }
             
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
          cs.Value__c='MRSPackage';
          update cs;
          // try again in 10 minutes
          Datetime sysTime = System.now().addMinutes( 10 );
          String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

          RetryMRSSyncSchedulable scheduledBatch = new RetryMRSSyncSchedulable();
          if(!Test.isRunningTest())
          System.schedule( 'SyncMRSObjects ' + sysTime, chronExpression, scheduledBatch );                
       }
       if (jobs < 5 || Test.isRunningTest())
       {
            RetryMRSpackageSyncOracleBatchable batch = new RetryMRSpackageSyncOracleBatchable();
            Database.executeBatch( batch, 10 );             
       }
   }
}