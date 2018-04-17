global class BatchScheduleSetLayerChipSchedulable implements Schedulable {
	
	global void execute(SchedulableContext ctx) {
		if (Environment_Variable__c.getInstance('SWIFT_MRS_ROLLUP_RETRIGGER_ONOFF').Value__c == 'ON') {
			SetLayerStatus_Service.scheduleCalculateLayerChipStatus();
		}
	}
}