/*************************************************************************************************************************************************************
@ Trigger:        Device_Trigger
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This trigger fires on Device__c object after creating or editing the records in Device object in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
trigger Device_Trigger on Device__c (Before insert, Before update, after insert, after update) {
    new Device_TriggerHandler().run();                
}