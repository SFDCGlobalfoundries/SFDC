trigger DevicePEOLRequestDetailTrigger on Device_PEOL_Request_Detail__c (before insert, before update, after update) {
    DevicePEOLRequestDetailsTriggerHandler.handle();
}