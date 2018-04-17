/*
* @ Author :- Navneet Rajput
* @ Company :- CTS
* @ Description :- Trigger is used to hadle all before and after operation on Document provisioning object
* @ Date :- 11/11/2014
* @ History :- 
*/

trigger FV_DocumentProvisioningTrigger on Document_Provisioning__c (after insert, after update, before insert, 
                                                                    before update,before delete) {
    
    FV_DocumentProvisioningTriggerHandler handler = new FV_DocumentProvisioningTriggerHandler();
    if(!IntegrationUserUtil.isSkipTrigger()){
        //handles before insert operations
        if (Trigger.isBefore && Trigger.isInsert){
            handler.onBeforeInsert(Trigger.new);
        }
        // handles before update operations
        if (Trigger.isBefore && Trigger.isUpdate){
            handler.onBeforeUpdate(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
        }
        // handles before delete operations
        if (Trigger.isBefore && Trigger.isDelete){
            handler.onBeforeDelete(Trigger.old);
        }
        // handles after insert operations
        if (Trigger.isAfter && Trigger.isInsert){
            handler.onAfterInsert(Trigger.new,Trigger.newMap);
        }
        // handles after update operations
        if (Trigger.isAfter && Trigger.isUpdate){
            handler.onAfterUpdate(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
        }
    }   
}