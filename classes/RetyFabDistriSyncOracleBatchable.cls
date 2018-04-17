/*
Type Name: RetyFabDistriSyncOracleBatchable 
Author: Cognizant 
Created Date: 22-Aug-2014
Reason: This is a Batch Apex class to retry record sync with downstream systems 
Change History:
*/
global class RetyFabDistriSyncOracleBatchable implements Database.Batchable<sObject> {

       /*global final String Query = 'SELECT Id, Name FROM Fab_Distribution_Table__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate < TODAY';
       global final String Field = 'Trigger_Oracle_DB_Sync_Manual__c';
       global final boolean Value = TRUE;*/

       global String Query = 'SELECT Id, Name FROM Fab_Distribution_Table__c WHERE Synced_with_Oracle_DB__c = false AND LastModifieddate < TODAY';
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
       Environment_Variable__c  cs =[select id from Environment_Variable__c where name ='MRSSyncObject' limit 1];
       cs.Value__c='MST';
       update cs;
       Datetime tml = System.now().addDays(1);
       String chronExpression = '0 30 12'+ ' ' + tml.day() + ' ' + tml.month() + ' ? ' + tml.year();

       RetryMRSSyncSchedulable scheduledBatch = new RetryMRSSyncSchedulable();
       if(!Test.isRunningTest())
       System.schedule( 'SyncMRSObjects ' + tml, chronExpression, scheduledBatch );
       
       // Sending DRT out of Sync email
       List<Environment_Variable__c>  evList =[select id,Value__c from Environment_Variable__c where name ='Swift_Oracle_Sync_Interval' limit 1];
       Environment_Variable__c syncInterval = evList.isEmpty()? (new Environment_Variable__c(Value__c='300')): evList.get(0);
       Datetime sysTime = System.now().addSeconds( Integer.valueOf(syncInterval.Value__c) );
       String chronExpression2 = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
       MRSSyncEmailNotification mrs = new MRSSyncEmailNotification();
       System.schedule( 'MRTSyncEmailNotification ' + sysTime, chronExpression2, mrs );
       
       //Delete old scheduled jobs
       set<id> setJobIds = new set<id>();
       for(cronjobdetail cjd :[select id from cronjobdetail where name like 'SyncMRSObjects%' or name like 'MRTSyncEmailNotification%']){
            setJobIds.add(cjd.id);
       }
        
       if(setJobIds.size()>0 || test.isRunningTest()){
           for(crontrigger ct :[select id,state from crontrigger where CronJobDetailId in :setJobIds]){
               if(ct.state=='DELETED'){    
                   system.abortjob(ct.id);
                }
           }
       }
   }
}