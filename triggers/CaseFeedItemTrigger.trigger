/*
Type Name: CaseFeedItemTrigger 
Author: Cognizant Case Management Team
Created Date:  06112014
Modified Date: 
Reason: To restrict internal users to post public Comments.
Test Class: CaseTriggerHandlerTest
Change History:
--- 
--
*/
trigger CaseFeedItemTrigger on FeedItem(before insert, after insert, before update, after update) {

    if (!IntegrationUserUtil.isSkipTrigger()) {

        String userKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
        List < FeedItem > newFeedItems = new List < FeedItem > ();

        for (FeedItem fi: trigger.new) {
            String parentId = fi.ParentId;
            if (parentId.startsWith(userKeyPrefix)) {
                newFeedItems.add(fi);
            }
        }
        if (newFeedItems != null && newFeedItems.size() > 0) {
            CaseTriggerHandler handler = new CaseTriggerHandler(Trigger.isExecuting, Trigger.size);

            if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore) {
                handler.OnBeforeInsertFeedItem(newFeedItems);
            } else if ((Trigger.isInsert || Trigger.isUpdate ) && Trigger.isAfter) {
                handler.OnAfterInsertFeedItem(newFeedItems);
            }
        }
        /*
        if(Trigger.isAfter){
            // For Bug updates
            String bugKeyPrefix = Bug__c.sObjectType.getDescribe().getKeyPrefix();
            List < String > bugFeedItems = new List < String > ();
            for (FeedItem fi: trigger.new) {
                String parentId = fi.ParentId;
                if (parentId.startsWith(bugKeyPrefix)) {
                    bugFeedItems.add(fi.parentId);
                }
            }
            
            if(bugFeedItems.size()>0){
                List<Bug__c> listASICBugs = new List<Bug__c>();
                listASICBugs    =   [SELECT Id, Name FROM Bug__c WHERE Id IN: bugFeedItems AND RecordType.DeveloperName = 'ASIC_Bug'];
                ASICBugEmailTemplateHandler.sendEmailOnBugCreation(listASICBugs, true);
            }
        }
        */
    }
}