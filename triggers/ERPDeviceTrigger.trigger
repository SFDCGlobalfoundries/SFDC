trigger ERPDeviceTrigger on ERP_Device__c (before insert,after insert, before update,after update) {
    /*
    * Intensionally left IntegrationUserUtil skip. We should not skip
    */
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate)){
        ERPDeviceTriggerHandler.handle(Trigger.new);
    } else if(Trigger.isAfter && Trigger.isUpdate) {
         ERPDeviceTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }else if(Trigger.Isafter && Trigger.isinsert){
        ERPDeviceTriggerHandler.insertJunctionSPDBOM(Trigger.new);
    }
    
}