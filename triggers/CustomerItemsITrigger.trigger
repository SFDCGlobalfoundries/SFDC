trigger CustomerItemsITrigger on Customer_Item__c (before insert, before update) {
	/*
	* Intensionally left IntegrationUserUtil skip. We should not skip
	*/
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
		CustomerItemTriggerHandler.handle(Trigger.new);
    }
}