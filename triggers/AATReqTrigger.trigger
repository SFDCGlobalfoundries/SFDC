trigger AATReqTrigger on AAT_Request__c (before update,before insert,after update, after Insert) {
    new AATReq_TriggerHandler().run();
}