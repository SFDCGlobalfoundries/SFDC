/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- Foundry View 2.0
* @ Description     :- Trigger Handles all after operation on Design_Spec__c object 
* @ Date            :- 17th June 2014
* @ Change History  :- 
**/

trigger SpecificationAfterTrigger on Design_Spec__c (after delete, after insert,
                                                     after undelete,after update) { 
                                                     
        FV_SpecificationAfterOperationHandler handler = new FV_SpecificationAfterOperationHandler(true);
        if (Trigger.isAfter && Trigger.isUpdate){
            system.debug('After Update OLD ----------'+Trigger.old);
            system.debug('After Update NEW--------------'+Trigger.new);
            handler.OnAfterUpdate(Trigger.new, Trigger.old, Trigger.newMap,Trigger.oldMap);
        }// End of after update trigger operation                                     

}