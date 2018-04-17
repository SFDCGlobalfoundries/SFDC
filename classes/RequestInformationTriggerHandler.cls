/*************************************************************************************************************************************************************
@ Class:          RequestInformationTriggerHandler
@ Version:        1.0
@ Author:         Poulami Saha
@ Purpose:        This Handler class is handling the events of Request Information Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 16.12.2016 / Poulami Saha / Created the class.
**************************************************************************************************************************************************************/
public class RequestInformationTriggerHandler extends TriggerHandler{
    /*Global variable*/
    public RequestInformationTriggerHelper helper { get; set; }
     public static BnPTriggerHelper  helper1 { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    RequestInformationTriggerHandler
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/    
    public RequestInformationTriggerHandler() {
        helper = new RequestInformationTriggerHelper();
        helper1 = new BnPTriggerHelper(); //Updated by Pullarao 12/29
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0helper1
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/     
    public override void afterInsert() {
        system.debug('start>>>>>>>>>>RI Trigger afterInsert :SOQL queries:'+limits.getQueries());
        helper.afterInsertMethod();
        helper.afterInsertUpdateMethod();
        helper.updateRequestCatcher();
        system.debug('end>>>>>>>>>>RI Trigger afterInsert :SOQL queries:'+limits.getQueries());
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/       
    public override void afterUpdate() {
        system.debug('start>>>>>>>>>>RI Trigger afterUpdate :SOQL queries:'+limits.getQueries());
        helper.afterUpdateMethod();
        helper.afterInsertUpdateMethod();
        helper1.updateDecision();
        helper.updateRequestCatcher();
        system.debug('end>>>>>>>>>>RI Trigger afterUpdate :SOQL queries:'+limits.getQueries());
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeInsert() {
        system.debug('start>>>>>>>>>>RI Trigger beforeInsert :SOQL queries:'+limits.getQueries());
        helper.beforeInsertUpdMethod();
        helper.beforeInsertMethod();
        system.debug('end>>>>>>>>>>RI Trigger beforeInsert :SOQL queries:'+limits.getQueries());
    
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Poulami Saha
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/     
    public override void beforeUpdate() {
        system.debug('start>>>>>>>>>>RI Trigger beforeUpdate :SOQL queries:'+limits.getQueries());
       helper.beforeInsertUpdMethod();
       helper.beforeUpdateMethod();
       //helper1.updateDecision();
       system.debug('end>>>>>>>>>>RI Trigger beforeUpdate :SOQL queries:'+limits.getQueries());
    }
}