/**
* Author: Sreedhar Karukonda 
* Timeline: 
*		Created Jan 28, 2015
**/

trigger AgreementSignatureSyncTrigger on Signatory__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	if (Trigger.isAfter) {
		if(Trigger.isInsert){
			AgreemntSignatureSyncHandler.handler.onAfterInsert(Trigger.newMap);
		} else if(Trigger.isDelete){
			AgreemntSignatureSyncHandler.handler.onAfterDelete(Trigger.oldMap);
		}
	    
	}
}