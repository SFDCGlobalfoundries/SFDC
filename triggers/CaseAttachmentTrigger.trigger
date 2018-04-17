/*
Type Name: CaseAttachmentTrigger
Author: Cognizant Case Management Team
Created Date: 02-Dec-2014
Reason: This is the generic trigger for Attachment object. 
Test Class: CaseTriggerHandlerTest
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger CaseAttachmentTrigger on Attachment(After insert) {
    if (!IntegrationUserUtil.isSkipTrigger()) {
        String userKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
        List < Attachment > updatedCaseAttachments = new List < Attachment > ();

        for (Attachment att: trigger.New) {
            String parentId = att.ParentId;
            if (parentId.startsWith(userKeyPrefix)) {
                updatedCaseAttachments.add(att);
            }
        }
        
        if (updatedCaseAttachments != null && updatedCaseAttachments.size() > 0) {
            CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);

            if (Trigger.isInsert && Trigger.isAfter) {
                handler.OnAfterInsertCaseAttachment(updatedCaseAttachments);
            }
        }
    }
}