/**
 * This trigger syncs geometries from NDAs to Account based on Signatories
 * Change Control:
 * 	3/11/2015  Sreedhar Karukonda Created
 * COMMENTS: Once TD NDA and General NDA is deployed to production, Please merge this with other trigger and disble this trigger.
 **/
trigger AgreementSyncToAccountTrigger on Apttus__APTS_Agreement__c (after insert, after update) {
	if(Trigger.isUpdate && Trigger.isAfter){
      AgreementSyncHandler.handler.onAfterUpdate(Trigger.oldMap, Trigger.newMap); 
    } else  if(Trigger.isInsert && Trigger.isAfter){
      AgreementSyncHandler.handler.onAfterInsert(Trigger.newMap);
    }
}