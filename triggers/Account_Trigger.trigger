/*************************************************************************************************************************************************************
@ Trigger:        Account_Trigger
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This trigger fires on Account on creating or editing the Accounts in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 29.11.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
trigger Account_Trigger on Account (after insert, after update, before insert, before update) {
    new Account_TriggerHandler().run();
}