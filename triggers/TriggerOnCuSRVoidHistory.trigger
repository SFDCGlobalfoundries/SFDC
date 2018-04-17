/*
Author: Shyam Ravindra Nair
Description: Trigger writte on CuSR_Void_History.
History:
SNair     13042015     - code creation
*/
trigger TriggerOnCuSRVoidHistory on CuSR_Void_History__c (after insert) {
	TriggerOnCuSRVoidHistoryHandler handler = new TriggerOnCuSRVoidHistoryHandler();
	
	if (!IntegrationUserUtil.isSkipTrigger()){
		if(trigger.isAfter && trigger.isInsert){
			handler.afterInsert(trigger.new);
		}
	}
}