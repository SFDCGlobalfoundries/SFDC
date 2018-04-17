/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- SwiftGen
* @ Description     :- Trigger Handles all after operation on PTRF__c object 
* @ Date            :-7th April 2014
* @ Change History  :- 
        Vijay   15082014    added the check to control the Trigger execution
**/

trigger PTRFAfterTrigger on PTRF__c (after delete, after insert, 
                                     after undelete,after update) { 
    
    String isTriggerExecuted = '';
    if (Environment_Variable__c.getInstance('PTRF_TRIGGER_ENABLED')!=null){
            String isTriggerEnabled = Environment_Variable__c.getInstance('PTRF_TRIGGER_ENABLED').Value__c;
            isTriggerExecuted = (!String.isBlank(isTriggerEnabled))  ? isTriggerEnabled:'TRUE';
    }else{
        isTriggerExecuted = 'TRUE';
    }
                                         
    if(!String.isBlank(isTriggerExecuted) && Boolean.valueOf(isTriggerExecuted)){
        PTRF_PTRFAfterOperationHandler handler = new PTRF_PTRFAfterOperationHandler(true);
         
        // below condition is use to skip execution of trigger
        //if(!IntegrationUserUtil.isSkipTrigger()){  
            //After Insert
            if (Trigger.isAfter && Trigger.isInsert){
                system.debug('After Insert Trigger called !!!!! ');
                handler.OnAfterInsert(Trigger.new);
            }// End of after insert trigger operation 
            else if (Trigger.isAfter && Trigger.isUpdate){
                system.debug('After Update OLD ----------'+Trigger.old);
                system.debug('After Update NEW--------------'+Trigger.new);
                handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap,Trigger.oldMap);
            }// End of after update trigger operation                                    
       // }//End of integration user util.
    }
}