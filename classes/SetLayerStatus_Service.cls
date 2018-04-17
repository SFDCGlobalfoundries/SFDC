/**
* This class expose service to re-trigger/calculate mismatch roll-up status layer.
* Related classes:
* + BatchScheduleSetLayerStatus -- (batchable)
* + BatchScheduleSetLayerStatusSchedulable -- (scheduler)
* + BatchScheduleSetLayerStatusSchedulable2 -- (scheduler)
*/
global class SetLayerStatus_Service {
	
	webservice static void invokeJobToCalculateLayerStatus() {
		scheduleCalculateLayerStatus('UpdateMismatchesLayer',true);
	}
	
	/**
	* Invoke batch to re-calculated or re-check/email mismatch layer.
	* If current context has more than 4 running job, it will retry in next 10 minutes
	* @jobName			String		name of schedule job
	* @isRetrigger		boolean 	true: do retrigger > than check and email > than schedule next job base on Environment_Variable__c.SWIFT_MRS_ROLLUP_RETRIGGER_INTERVAL
	*								false: do check and email > than schedule next job base on Environment_Variable__c.SWIFT_MRS_ROLLUP_RETRIGGER_INTERVAL
	*/
	global static void scheduleCalculateLayerStatus(String jobName, boolean isRetrigger) { 
		
		Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if( jobs > 4 ) {
            Datetime sysTime = System.now().addMinutes( 10 ); // try again in 10 minutes
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            BatchScheduleSetLayerStatusSchedulable scheduledBatch = new BatchScheduleSetLayerStatusSchedulable();
            System.schedule( 'ReTriggerMRSLayer-' + jobName + ' ' + sysTime, chronExpression, scheduledBatch );                
        } else {
        	Integer batchSize = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_BATCH_SIZE').Value__c );
        	BatchScheduleSetLayerStatus rollupBatch = new BatchScheduleSetLayerStatus( isRetrigger ); 
            Database.executeBatch(rollupBatch, batchSize);
        }
	}
	
	global static void scheduleCalculateLayerChipStatus() {
		Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and status in ('Queued','Processing','Preparing')];
        if( jobs > 4 ) {
            Datetime sysTime = System.now().addMinutes( 10 ); // try again in 10 minutes
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            BatchScheduleSetLayerChipSchedulable scheduledBatch = new BatchScheduleSetLayerChipSchedulable();
            System.schedule( 'ReTriggerMRSLayerChip ' + sysTime, chronExpression, scheduledBatch );                
        } else {
        	Integer batchSize = Integer.valueOf( Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_LAYERCHIP_BATCHSIZE').Value__c );
        	BatchScheduleSetLayerChipStatus rollupBatch = new BatchScheduleSetLayerChipStatus(); 
            Database.executeBatch(rollupBatch, batchSize);
        }
	}
	
	//@future(callout = true)
    //public static void responseHandler(string messageID, string transactstatus) {
    	
    //}
}