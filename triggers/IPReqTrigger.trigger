trigger IPReqTrigger on CMOS_BU_IP_Request__c (before insert, before update) {
    new IPReqTriggerHandler().run();
}