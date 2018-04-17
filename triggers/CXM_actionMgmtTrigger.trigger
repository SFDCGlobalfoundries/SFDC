/**
* Description   :   Trigger on Action Management Object CXM_actionMgmtTrigger.
* History       :   

        Initials        Date              Description
----------------------------------------------------------------------------
        DBiswal       08112016          Created the Trigger.
        DBiswal       07252017          Modified for best practices.
        
**/
trigger CXM_actionMgmtTrigger on Escalation_Complaint__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new CXM_actionMgmtTriggerHandler().run();
}