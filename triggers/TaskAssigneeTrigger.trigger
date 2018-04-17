/*************************************************************************************************************************************************************
@ Trigger:        TaskAssigneeTrigger
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This trigger fires on Task assignee on creating or editing the Task Assignees in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
trigger TaskAssigneeTrigger on RFQ_Task_Assignee__c (before insert,before update, after insert, after update) {
    new TaskAssigneeTriggerHandler().run();
}