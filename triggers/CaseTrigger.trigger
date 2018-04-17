/*
Type Name: CaseTrigger 
Author: Cognizant Case Management Team
Created Date: 30-July-2014
Reason: This is the generic trigger for Case object. 
Test Class: CaseTriggerHandlerTest
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger CaseTrigger on Case(after insert, after update, before insert, before update) {

    if (!IntegrationUserUtil.isSkipTrigger()) {
        if (CaseHandlerUtility.runOnce()) {
            CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);

            if (Trigger.isInsert && Trigger.isBefore) {
                handler.OnBeforeInsertCase(Trigger.new);
            } else if (Trigger.isInsert && Trigger.isAfter) {
                handler.OnAfterInsertCase(Trigger.new);
            } else if (Trigger.isUpdate && Trigger.isBefore) {
                handler.OnBeforeUpdateCase(Trigger.old, Trigger.new, Trigger.oldMap);
            } else if (Trigger.isUpdate && Trigger.isAfter) {
                handler.OnAfterUpdateCase(Trigger.old, Trigger.new, Trigger.oldMap);
            }
        }
    }

}