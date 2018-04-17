/*************************************************************************************************************************************************************
@ Class:          User_TriggerHandler
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of User Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 26.08.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
public class User_TriggerHandler extends TriggerHandler{

    /* Global variables declaration */
    public static User_TriggerHelper helper { get; set; } /* Variable created for Helper_UserTrigger class */
    
/*************************************************************************************************************************************************************
@ Constructor:    User_TriggerHandler
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        Initialises the class for Handler class instances.
**************************************************************************************************************************************************************/      
    public User_TriggerHandler(){
         helper = new User_TriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/     
    public override void beforeinsert(){
        helper.UserTrigger_biu();
        helper.userTriggerBefore();
         
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/    
    public override void beforeupdate(){
        helper.UserTrigger_biu();
        helper.userTriggerBefore();        
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/    
    public override void afterupdate(){
        helper.userTriggerAfter();  
    } 
      
    /*********************************************************************************************************************************************************
    @ Method:         afterinsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/      
    public override void afterinsert(){
        helper.userTriggerAfter();
    
    }
}