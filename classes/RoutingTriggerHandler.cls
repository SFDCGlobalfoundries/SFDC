/*************************************************************************************************************************************************************
@ Class:          RoutingTriggerHandler
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This Handler class is handling the events of Routing Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
public class RoutingTriggerHandler extends TriggerHandler{
    /*Global variable*/
    public RoutingTriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    RoutingTriggerHandler
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public RoutingTriggerHandler() {
        helper = new RoutingTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
        helper.beforeInsertUpdMethod();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void beforeUpdate() {
       helper.beforeInsertUpdMethod();
       helper.beforeUpdateMethod();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
       helper.afterInsertMethod();
       helper.afterInsertUpdMethod();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterUpdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void afterUpdate() {
       helper.afterUpdateMethod();
       helper.afterInsertUpdMethod();
    }
}