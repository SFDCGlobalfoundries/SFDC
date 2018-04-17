/*
Type Name: CaseCollaborationTrigger 
Author: Cognizant Case Management Team
Created Date: 27-July-2014
Reason: Creates case team member based on CCtoCase with Case Collaboration role.
Test Class: 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger CaseCollaborationTrigger on Case_Collaboration__c(after insert, after update, after delete) {

    if (!IntegrationUserUtil.isSkipTrigger()) {
        CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);

        if (Trigger.isInsert && Trigger.isAfter) {
            handler.OnAfterInsertCaseCollaboration(Trigger.new);
        } else if (Trigger.isUpdate && Trigger.isAfter) {
            handler.OnAfterUpdateCaseCollaboration(Trigger.old, Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete && Trigger.isAfter) {
            handler.OnAfterDeleteCaseCollaboration(Trigger.old, Trigger.new);
        }
    }
}