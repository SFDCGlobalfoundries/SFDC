/*************************************************************************************************************************************************************
@ Trigger:        OpportunityProgramTrigger
@ Version:        1.0
@ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
@ Purpose:        This trigger fires on Opportunity Program on creating or editing the Opportunity Programs in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 07.02.2018 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
trigger OpportunityProgramTrigger on Opportunity_Program__c (After insert, After update, Before insert, Before update) {
    new OpportunityProgramTriggerHandler().run();
}