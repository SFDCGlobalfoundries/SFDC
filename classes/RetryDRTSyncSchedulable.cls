/*
Author: Cognizant
Company: Cognizant
Description: Retry Schedulable Class
History:
created     22/08/2014     
*/
global class RetryDRTSyncSchedulable implements Schedulable {

    global void execute(SchedulableContext ctx) {
        
        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if( jobs > 4 )
        {
            // try again in 10 minutes
            Datetime sysTime = System.now().addMinutes( 10 );
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

            RetryDRTSyncSchedulable scheduledBatch = new RetryDRTSyncSchedulable();
            System.schedule( 'SyncDRTObjects ' + sysTime, chronExpression, scheduledBatch );                
        }
        else
        {
            //BatchScheduleSetLayerStatus rollupBatch=new BatchScheduleSetLayerStatus();
            //Database.executeBatch(rollupBatch,10);    
            
            Map<String, Environment_Variable__c> mcs = Environment_Variable__c.getAll();
            string obj = mcs.get('DRTSyncObject').Value__c;
            if(obj=='DRT'){
                RetryDRTsyncOracleBatchable batch = new RetryDRTsyncOracleBatchable();
                Database.executeBatch(batch,10);    
            }
            else if(obj=='DRTChip'){
                RetryPrimeDRTchipSyncOracleBatchable batch = new RetryPrimeDRTchipSyncOracleBatchable();
                Database.executeBatch( batch, 5 );    
            }
            else if(obj=='DRTLayer'){
                RetryPrimeDRTLayerSyncOracleBatchable batch = new RetryPrimeDRTLayerSyncOracleBatchable();
                Database.executeBatch( batch, 5 );
            }
            else if(obj=='FrameDRT'){
                RetryDRTassctnSyncOracleBatchable batch = new RetryDRTassctnSyncOracleBatchable();
                Database.executeBatch( batch, 50 );
            }
            else if(obj=='DRTPTRF'){
                RetryDRTPTRFsyncOracleBatchable batch = new RetryDRTPTRFsyncOracleBatchable();
                Database.executeBatch( batch, 50 );
            }
            else if(obj=='DRTLayerChip'){
                RetryDRTLayerChipSyncOracleBatchable batch = new RetryDRTLayerChipSyncOracleBatchable();
                Database.executeBatch( batch, 100 );
            }
            else if(obj=='DRTdotNET'){
                RetryDRTsyncdotNETBatchable batch = new RetryDRTsyncdotNETBatchable();
                Database.executeBatch( batch, 100 );
            }
            else if(obj=='DRTPackage'){
                RetryDRTpackageSyncOracleBatchable batch = new RetryDRTpackageSyncOracleBatchable();
                Database.executeBatch( batch, 10 );
            }
        }

    }   
}