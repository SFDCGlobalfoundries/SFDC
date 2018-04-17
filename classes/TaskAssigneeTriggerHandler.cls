/*************************************************************************************************************************************************************
@ Class:          TaskAssigneeTriggerHandler
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This Handler class is handling the events of Task Assignee Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
public class TaskAssigneeTriggerHandler extends TriggerHandler{
    /*Global variable*/
    public TaskAssigneeTriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    TaskAssigneeTriggerHandler
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public TaskAssigneeTriggerHandler() {
        helper = new TaskAssigneeTriggerHelper();
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
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterinsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        if ( ! BNPStopTrigger.bypassTriggerLogic) {
            helper.afterInsertUpdateMethod();
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
            helper.afterInsertUpdateMethod();
        }
    }
}