/**
* This class will schedule a job for search for all layer which have mismatch of roll-up calculation
* It will invoke a batch class to search then send out email notify on which layer
* This class will be invoked by:
* - Finish action of BatchScheduleSetLayerStatus class
*/
global class BatchScheduleSetLayerStatusSchedulable2 implements Schedulable {
	
	global void execute(SchedulableContext ctx) {
		SetLayerStatus_Service.scheduleCalculateLayerStatus('NotifyMismatcheLayers',false);
	}
}