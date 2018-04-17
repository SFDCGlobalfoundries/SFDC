/*
Type Name: CaseCommentTrigger  
Author: Cognizant
Created Date:  03132014
Modified Date: Cognizant on 03182014
Reason: To Capture Last Comments in Case object field Last_Case_Comments__c, which will be emailed to Case Creator\Owner.
Test Class: 
Change History:
--- 
--
*/
trigger CaseCommentTrigger on CaseComment(after insert, after update, before insert, before update) {

    if (!IntegrationUserUtil.isSkipTrigger()) {
        CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);
        CaseHandlerUtility.isCompleted = false;
        if (Trigger.isInsert && Trigger.isBefore) {
            handler.OnBeforeInsertCaseComment(Trigger.new);
        } else if (Trigger.isInsert && Trigger.isAfter) {
            handler.OnAfterInsertCaseComment(Trigger.new);
        } else if (Trigger.isUpdate && Trigger.isAfter) {
            handler.OnAfterUpdateCaseComment(Trigger.old, Trigger.new, Trigger.oldMap);
        } else if (Trigger.isUpdate && Trigger.isBefore) {
            handler.OnBeforeUpdateCaseComment(Trigger.old, Trigger.new, Trigger.oldMap);
        }
        CaseHandlerUtility.isCompleted = true;
    }
}