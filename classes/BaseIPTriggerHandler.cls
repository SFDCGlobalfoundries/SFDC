/*************************************************************************************************************************************************************
@ Class:          BaseIPTriggerHandler
@ Version:        1.0
@ Author:         Ravi Teja.B
@ Purpose:        This Handler class is handling the events of IP Element Triggers.
**************************************************************************************************************************************************************/
public class BaseIPTriggerHandler extends TriggerHandler{

	public BaseIPTriggerHelper helper { get; set; }
    
    public BaseIPTriggerHandler(){
        helper = new BaseIPTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeInsert
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/ 
    public override void beforeInsert(){
        helper.RecordTypeAssignment();
    }
    /*********************************************************************************************************************************************************
    @ Method:         beforeUpdate
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/ 
    public override void beforeUpdate(){
        helper.RecordTypeAssignment();
    }
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ravi Teja.B
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterUpdate(){
        helper.actDeactProducts();
    }

}