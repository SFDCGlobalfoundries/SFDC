/*************************************************************************************************************************************************************
@ Class:          TaskRoutingTriggerHandler
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This Handler class is handling the events of Task Routing Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
public class TaskRoutingTriggerHandler extends TriggerHandler{
    /*Global variable*/
    public TaskRoutingTriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    TaskRoutingTriggerHandler
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public TaskRoutingTriggerHandler() {
        helper = new TaskRoutingTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        if ( ! BNPStopTrigger.bypassTriggerLogic) {
            helper.afterInsertMethod();
            helper.afterInsertUpdMethod();
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/       
    public override void afterUpdate() {
        if ( ! BNPStopTrigger.bypassTriggerLogic) {
            helper.afterUpdateMethod();
            helper.afterInsertUpdMethod();
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
        if ( ! BNPStopTrigger.bypassTriggerLogic) {
            helper.beforeInsertMethod();
            helper.beforeInsertUpdMethod();
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void beforeUpdate() {
        if ( ! BNPStopTrigger.bypassTriggerLogic) {
            helper.beforeUpdateMethod();
            helper.beforeInsertUpdMethod();
        }
    }
}