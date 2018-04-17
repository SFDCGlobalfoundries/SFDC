/*
Author: Cognizant
Company: Cognizant
Description: Retry Schedulable Class
History:
created     22/08/2014     
*/
global class RetryMRSSyncSchedulable implements Schedulable {
             
 global void execute(SchedulableContext ctx) {
    
               
    Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
    if( jobs > 4 )
    {
      // try again in 10 minutes
      Datetime sysTime = System.now().addMinutes( 10 );
      String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

      RetryMRSSyncSchedulable scheduledBatch = new RetryMRSSyncSchedulable();
      System.schedule( 'SyncMRSObjects ' + sysTime, chronExpression, scheduledBatch );                
    }
    else
    {
        Map<String, Environment_Variable__c> mcs = Environment_Variable__c.getAll();
        string obj = mcs.get('MRSSyncObject').Value__c;
        if(obj=='MRS'){
            RetryMRSsyncOracleBatchable batch = new RetryMRSsyncOracleBatchable();
            Database.executeBatch( batch, 10 );        
        }
        else if(obj=='MRSChip'){
            RetryMRSChipSyncOracleBatchable batch = new RetryMRSChipSyncOracleBatchable();
            Database.executeBatch( batch, 5 );        
        }
        else if(obj=='MRSLayer'){
            RetryMRSLayerSyncOracleBatchable batch = new RetryMRSLayerSyncOracleBatchable();
            Database.executeBatch( batch, 5 );        
        }
        else if(obj=='MRSLayerChip'){
            RetryMRSLayerChipSyncOracleBatchable batch = new RetryMRSLayerChipSyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MRSNotes'){
            retryMRSNotesSyncOracleBatchable batch = new retryMRSNotesSyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MRSLayerStatusdotNET'){
            RetryMRSLayerStatusSyncdotNETBatchable batch = new RetryMRSLayerStatusSyncdotNETBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MRSPrimeFramedotNET'){
            RetryMRSPrimeFrameSyncdotNETBatchable batch = new RetryMRSPrimeFrameSyncdotNETBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MRSPackage'){
            RetryMRSpackageSyncOracleBatchable batch = new RetryMRSpackageSyncOracleBatchable();
            Database.executeBatch( batch, 10 );        
        }
        else if(obj=='FrameDisapprove'){
            RetryFrameDisapprvlSyncdotNETBatchable batch = new RetryFrameDisapprvlSyncdotNETBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='TapeoutApp'){
            RetryTapeoutAppSyncOracleBatchable batch = new RetryTapeoutAppSyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='FabDistri'){
            RetyFabDistriSyncOracleBatchable batch = new RetyFabDistriSyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MST'){
            RetryMSTsyncOracleBatchable batch = new RetryMSTsyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
        else if(obj=='MSTConfig'){
            RetryMSTconfigSyncOracleBatchable batch = new RetryMSTconfigSyncOracleBatchable();
            Database.executeBatch( batch, 100 );        
        }
    }

 }   
}