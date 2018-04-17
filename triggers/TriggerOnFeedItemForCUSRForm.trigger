/*
Author: Shyam Ravindra Nair
Description: Trigger for FeedItem related to CuSR Form.
History:
SNair     23042015     - code creation
*/
trigger TriggerOnFeedItemForCUSRForm on FeedItem (before delete, before insert) {
	TriggerOnFeedItemForCUSRFormHandler handler = new TriggerOnFeedItemForCUSRFormHandler();
	
	if (!IntegrationUserUtil.isSkipTrigger()) {
		if(trigger.isBefore && trigger.isDelete){
			handler.onBeforeDelete(trigger.old);
		}
		
		if(trigger.isBefore && trigger.isInsert){
			handler.onBeforeInsert(trigger.new);
		}
	}
}