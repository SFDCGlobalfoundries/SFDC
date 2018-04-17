trigger ASICNewsandAlertTrigger on ASIC_News_Alert__c (after insert, after update) {


	FV_ASICNewsAlertTriggerHandler.onAfterInsertUpdate(trigger.newmap,trigger.oldmap);
}