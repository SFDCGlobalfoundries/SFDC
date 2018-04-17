/*************************************************************************************************************************************************************
@ Trigger:        RequestInformationTrigger
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This trigger fires on Request Information on creating or editing the Request Information in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
trigger RequestInformationTrigger on Request_Information__c (before insert, before update, after insert, after update) {
    new RequestInformationTriggerHandler().run();
}