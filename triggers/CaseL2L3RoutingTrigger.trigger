trigger CaseL2L3RoutingTrigger on CaseL2L3Routing__c (before insert, before update, after insert, after update) {
     if (!IntegrationUserUtil.isSkipTrigger()) {
         CaseL2L3RoutingTriggerHandler handler = new CaseL2L3RoutingTriggerHandler (Trigger.isExecuting, Trigger.size);
         if (Trigger.isInsert && Trigger.isBefore) {
             handler.OnBeforeInsertL2L3Routing(Trigger.new);
         } else if (Trigger.isUpdate && Trigger.isBefore) { 
             handler.OnBeforeUpdateL2L3Routing(Trigger.old, Trigger.new, Trigger.oldMap);          
         } else if (Trigger.isInsert && Trigger.isAfter) {
             handler.OnAfterInsertL2L3Routing(Trigger.new);
         } else if (Trigger.isUpdate && Trigger.isAfter) {
             handler.OnAfterUpdateL2L3Routing(Trigger.old, Trigger.new, Trigger.oldMap);
         } 
     }    
}