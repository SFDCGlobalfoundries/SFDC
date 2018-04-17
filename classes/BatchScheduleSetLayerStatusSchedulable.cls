/**
* This class will schedule a job for re-calculate the roll-up of layer
* It will invoke a batch class to retrigger
* This class will be invoked by:
* - Schedule a job
*/
global class BatchScheduleSetLayerStatusSchedulable implements Schedulable {
	
	global void execute(SchedulableContext ctx) {
		
		// parse param true means this run will retrigger then schedule next job to check and sendout notify email on remain mismatch layer
		SetLayerStatus_Service.scheduleCalculateLayerStatus('UpdateMismatchesLayer',true);
	}
}