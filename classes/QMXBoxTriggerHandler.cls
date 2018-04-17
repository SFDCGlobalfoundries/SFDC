/*************************************************************************************************************************************************************
@ Class:          QMXBoxTriggerHandler
@ Version:        1.0
@ Author:         Pradosh Samal
@ Purpose:        This Handler class is handling the events of QMXBOx Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.09.2017 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
public class QMXBoxTriggerHandler extends TriggerHandler{

    /*Global variable*/
    public QMXBoxTriggerHelper helper { get; set; }
    
    
    /*********************************************************************************************************************************************************
    @ Constructor:    QMXBoxTriggerHandler
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        Initialises the class for Handler class instances. 
    *********************************************************************************************************************************************************/
    public QMXBoxTriggerHandler() {
        
        helper = new QMXBoxTriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeInsert
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    *********************************************************************************************************************************************************/  
    public override void beforeInsert() {    
        
        helper.calculateBoxNumber();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    *********************************************************************************************************************************************************/
    public override void afterInsert() {
        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeUpdate
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    *********************************************************************************************************************************************************/
    public override void beforeUpdate() {
        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterUpdate
    @ Version:        1.0
    @ Author:         Pradosh Samal
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    *********************************************************************************************************************************************************/
    public override void afterUpdate() {
        
    }
}