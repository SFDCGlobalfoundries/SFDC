/*************************************************************************************************************************************************************
@ Trigger:        InternalImpersonationMapping_Trigger
@ Version:        1.0
@ Author:         Sandesh Singh
@ Purpose:        This trigger fires on Internal_Impersonation_Mapping__c object after creating 
                  or editing the records is assigin user to sharing access of Customer Satisfaction object in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.08.2017 / Sandesh Singh / Created the class.
**************************************************************************************************************************************************************/
trigger InternalImpersonationMapping_Trigger on Internal_Impersonation_Mapping__c (after insert, after update){
    //new InternalImpMapp_TriggerHandler().run();
}