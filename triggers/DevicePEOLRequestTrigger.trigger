/*
    Author: Ariz Solito
    Description: Various trigger related logic for Device PEOL Requests
    History: 
    Asolito      07/07/2015    - Apex code created 
    Sreedhar Karukonda 22/09/2015  - moved logic to handler class
*/
trigger DevicePEOLRequestTrigger on Device_PEOL_Request__c (before insert, after insert, before update, after update) {
      DevicePEOLRequestTriggerHandler.handle();  
}