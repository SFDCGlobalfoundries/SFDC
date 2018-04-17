/*************************************************************************************************************************************************************
@ Trigger:        Opportunity_Trigger
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This trigger fires on Opportunity on creating or editing the Opportunities in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.10.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
trigger Opportunity_Trigger on Opportunity (After insert, After update, Before insert, Before update) {
    new Opportunity_TriggerHandler().run();
}