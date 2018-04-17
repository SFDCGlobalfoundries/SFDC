/*************************************************************************************************************************************************************
@ Trigger:        RoutingTrigger
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This trigger fires on Routing on creating or editing the Route in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
trigger RoutingTrigger on RFQ_Routing__c (before insert, before update, after insert, after update) {
     new RoutingTriggerHandler().run();
}