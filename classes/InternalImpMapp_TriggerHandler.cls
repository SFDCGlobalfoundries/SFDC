public class InternalImpMapp_TriggerHandler extends TriggerHandler{
	
    public InternalImpMapp_TriggerHelper helper { get; set; } 
    
    /*************************************************************************************************************************************************************
    @ Constructor:    InternalImpMapp_TriggerHandler
    @ Version:        1.0
    @ Author:         Sandesh Singh
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/   
    public InternalImpMapp_TriggerHandler(){
        helper = new InternalImpMapp_TriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Sandesh Singh 
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/ 
    public override void afterInsert(){
        if (!IntegrationUserUtil.isSkipTrigger()){
        	helper.insertMeritIndexAccess(Trigger.new);
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Sandesh Singh 
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterUpdate(){
       if (!IntegrationUserUtil.isSkipTrigger()){
       		helper.updateMeritIndexAccess(Trigger.new,Trigger.old);
       }
    }
}