/*************************************************************************************************************************************************************
@ Trigger:        MTATAssign_a_MobileCom_Trigger
@ Author:         Sridhar Gopireddy (Sridhar.gopireddy@globalfoundries.com)
@ Purpose:        This trigger fires before creating or editing the assignmobilecom in the Org.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 29.12.2016 / Sridhar Gopireddy / Created the class.
**************************************************************************************************************************************************************/
trigger MTATAssignamobilecom on Assign_a_MobileCom__c (before insert,before update) {
       
    if(trigger.isbefore){         
        MTATAssignMobileComHelper helper = new MTATAssignMobileComHelper();   
        if(trigger.isinsert){
        helper.beforeAssignMobileComInsert(trigger.new);
        }  
        if(trigger.isupdate){
        helper.beforeAssignMobileComupdate(trigger.new);
        }    
    }      
    
}