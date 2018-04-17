/*************************************************************************************************************************************************************
@ Class:          Opportunity_TriggerHandler
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Opportunity Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 24.10.2016 / Ishtpreet Singh / Created the class.
                  04.04.2017 / Pradosh Samal / Case-00067002. Called method Opportunity_TriggerHelper.updateLastEditorOfIPDF() from beforeUpdate().
                  06.02.2018 / Pradosh Samal / Case-00085238. Called method Opportunity_TriggerHelper.updateDeafaultOppIssue() from afterUpdate(). 
**************************************************************************************************************************************************************/
public class Opportunity_TriggerHandler extends TriggerHandler{

    /*Global variable*/
    public Opportunity_TriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    Opportunity_TriggerHandler
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public Opportunity_TriggerHandler() {
        helper = new Opportunity_TriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        helper.oppAfterTrigger();
        helper.OpportunityGenerateOptyProgramAfterInsert();//added by Meghna
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/       
    public override void afterUpdate() {    		
    	if(!IntegrationUserUtil.isSkipTrigger()){
	        helper.oppProcessAfter();
	        helper.OpportunityGenerateOptyProgram(); 
	        helper.opportunityIntegrationLog_au();
	        helper.oppAfterTrigger();
            helper.updtChipOptionStageAfter();
            helper.updateDeafaultOppIssue();
    	}
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
        helper.oppProcessBefore();
        helper.oppBeforeTrigger();
        helper.oppPreDiscovery();//Added by meghna
        helper.updateoptyPLMMarketSegment(); //Added by abhishek
        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void beforeUpdate() {
    	if(!IntegrationUserUtil.isSkipTrigger()){
	        helper.oppProcessBefore();
	        helper.oppBeforeTrigger();
	        helper.oppCalculateRevenueValues();
	     //   helper.updateTrOptionStage();
	     	helper.updateoptyPLMMarketSegment(); //Added by abhishek
	     	helper.updateLastEditorOfIPDF();
	     	helper.UpdateOpportunity();//added by jabee
	     	helper.oppCheckforFeedback();
    	}
    }
}