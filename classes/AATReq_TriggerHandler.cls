/*************************************************************************************************************************************************************
@ Class:          AATReq_TriggerHandler
@ Version:        1.0
@ Author:         Ravi Teja.B
@ Purpose:        This Handler class is handling the events of AAT Req Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
**************************************************************************************************************************************************************/
public class AATReq_TriggerHandler extends TriggerHandler{
    public AATReq_TriggerHelper helper {get; set;}
    
    
    public AATReq_TriggerHandler(){
        helper = new AATReq_TriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/ 
    public override void afterInsert(){
    	helper.submitForApproval();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterUpdate(){
        helper.submitForApproval();
        helper.resubmitApprovalProcess2();
        helper.checkPDTQueueUpdate();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/   
    public override void beforeInsert(){
        helper.PDTApprovalPopulation();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/ 
    public override void beforeUpdate(){
        helper.commentsHandler();
        helper.AATTechCIAEvaluation();
        helper.PDTApprovalPopulation();
    }
}