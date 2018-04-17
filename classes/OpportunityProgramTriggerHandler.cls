/*************************************************************************************************************************************************************
@ Class:          OpportunityProgramTriggerHandler
@ Version:        1.0
@ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Opportunity Program Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.10.2016 / Pradosh Samal / Created the class.
                  
**************************************************************************************************************************************************************/
public class OpportunityProgramTriggerHandler extends TriggerHandler{

    /*Global variable*/
    public OpportunityProgramTriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    OpportunityProgramTriggerHandler
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public OpportunityProgramTriggerHandler() {
        helper = new OpportunityProgramTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        
        helper.createDefaultOppIssue();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/       
    public override void afterUpdate() {
        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
        
    
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void beforeUpdate() {
       
    }
}