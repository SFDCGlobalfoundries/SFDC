/*************************************************************************************************************************************************************
@ Class:          Account_TriggerHandler
@ Version:        1.0
@ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
@ Purpose:        This Handler class is handling the events of Account Triggers.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 29.11.2016 / Ishtpreet Singh / Created the class.
**************************************************************************************************************************************************************/
public class Account_TriggerHandler extends TriggerHandler{
    public Account_TriggerHelper helper { get; set; }
    
    /*************************************************************************************************************************************************************
    @ Constructor:    Account_TriggerHandler
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        Initialises the class for Handler class instances.
    **************************************************************************************************************************************************************/ 
    public Account_TriggerHandler(){
        helper = new Account_TriggerHelper();
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterInsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after insert event.
    **********************************************************************************************************************************************************/
    public override void afterInsert(){
            system.debug('afterInsert..............!!!!!!!!!');              
            helper.accTriggerAfter();
            system.debug('accTriggerAfter...........!!!!!!!!!');
            
        System.debug('accTriggerAfter'+Limits.getQueries());
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         afterupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in after update event.
    **********************************************************************************************************************************************************/
    public override void afterUpdate(){
        helper.accountDataChngeAfter();
        System.debug('accountDataChngeAfter'+Limits.getQueries());
        helper.accountIntegrationLog_auAfter();
        System.debug('accountIntegrationLog_auAfter'+Limits.getQueries());
        helper.deactAccTrigAfter();
        System.debug('deactAccTrigAfter'+Limits.getQueries());
        helper.createSharingOnAccount();
        System.debug('createSharingOnAccount'+Limits.getQueries());
        helper.accTriggerAfter();
        System.debug('accTriggerAfter'+Limits.getQueries());
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeinsert
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before insert event.
    **********************************************************************************************************************************************************/ 
    public override void beforeInsert(){
        //if(checkRecursive.runOnce()){
			helper.deactAccTrigBefore();
			System.debug('deactAccTrigBefore'+Limits.getQueries());
			helper.accTriggerBefore();
			System.debug('accTriggerBefore'+Limits.getQueries());
			helper.CountrycodeFieldMaping();
		//}
    }
    
    /*********************************************************************************************************************************************************
    @ Method:         beforeupdate
    @ Version:        1.0
    @ Author:         Ishtpreet Singh (Ishtpreet.singh@globalfoundries.com)
    @ Purpose:        This method is calling all the method which needs to be triggered in before update event.
    **********************************************************************************************************************************************************/
    public override void beforeUpdate(){
        //if(checkRecursive.runOnce()){
			helper.accountDataChngeBefore();
			System.debug('accountDataChngeBefore'+Limits.getQueries());       
			helper.accTriggerBefore();
			System.debug('accTriggerBefore'+Limits.getQueries());
			helper.CountrycodeFieldMaping();
        //}
    } 
}