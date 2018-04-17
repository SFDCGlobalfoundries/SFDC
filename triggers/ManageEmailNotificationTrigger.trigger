/*
Author: Cognizant Case Mgmt Team
Created Date: 13/08/2015
Reason: Reason: This is the trigger for Manage Email Notification
Test Class: 
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
trigger ManageEmailNotificationTrigger on Manage_Email_Notification__c (after Insert,after Update,before Insert) {
    if (!IntegrationUserUtil.isSkipTrigger()) {
        ManageEmailNotificationTriggerHandler handler = new ManageEmailNotificationTriggerHandler();
        if (Trigger.isInsert && Trigger.isAfter) {
            handler.OnAfterInsertManageEmail(Trigger.new);
        } 
        else if (Trigger.isUpdate && Trigger.isAfter) {
            handler.OnAfterUpdateManageEmail(Trigger.old, Trigger.new, Trigger.oldMap);
        } 
        else if (Trigger.isInsert && Trigger.isBefore) {
            handler.OnBeforeInsertManageEmail(Trigger.new);
        }
    }
}