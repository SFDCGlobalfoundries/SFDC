/*************************************************************************************************************************************************************
@ Trigger:        TaskRoutingTrigger
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This trigger fires on Task Routing on creating or editing the Task Routing in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
trigger TaskRoutingTrigger on RFQ_Tasks_Routing__c (before insert, before update,after update, after insert) {
    new TaskRoutingTriggerHandler().run();
}