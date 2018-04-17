/*************************************************************************************************************************************************************
@ Class:          QMXWorkOrderTriggerHandler
@ Version:        1.0
@ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Work Order Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.09.2017 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
public class QMXWorkOrderTriggerHandler extends TriggerHandler{

    /*Global variable*/
    public QMXWorkOrderTriggerHelper helper { get; set; }
    //public static boolean firstRun = true;
    
    /*********************************************************************************************************************************************************
    @ Constructor:    QMXWorkOrderTriggerHandler
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances. 
    *********************************************************************************************************************************************************/
    public QMXWorkOrderTriggerHandler() {
        
        helper = new QMXWorkOrderTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeInsert
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    *********************************************************************************************************************************************************/  
    public override void beforeInsert() {    
        helper.updateCusIns(trigger.new);
        helper.populateExpirationDate(Trigger.new);    
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    *********************************************************************************************************************************************************/
    public override void afterInsert() {
        helper.createWOLot(trigger.new);  
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeUpdate
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    *********************************************************************************************************************************************************/
    public override void beforeUpdate() {
        if(QMXWorkOrderTriggerHelper.firstRun){
            helper.handleUpdate(trigger.new); 
            helper.declaredLOTValidation();
            QMXWorkOrderTriggerHelper.firstRun = false;
        }
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterUpdate
    @ Version:        1.0
    @ Author:         Pradosh Samal (pradosh.samal@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    *********************************************************************************************************************************************************/
    public override void afterUpdate() {
        
    }
}