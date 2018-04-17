/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This trigger is used to handle the dml operations performed on RMA_Audit_log__c object.
 * History:
 *    SurendranadhNune 23122016  -   Created.
 *                            
 **/
trigger RMA_Audit_log_Trigger on RMA_Audit_log__c (after insert) {
    
    if(!IntegrationUserUtil.isSkipTrigger()){
        //Reset queue-in/queue out times for RMA when RMA is rejected.
        Id cycleTimeRecTypeId =  RMA_utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.CYCLE_TIME_LOG);
        if(Trigger.isInsert && Trigger.isAfter){
            Set<Id> rejectedRMASet = new Set<Id>();
            for(RMA_Audit_log__c cy : Trigger.new){
                if(cy.recordTypeId == cycleTimeRecTypeId){
                    rejectedRMASet.add(cy.rma__c);
                }
            }
            RMA_Audit_log_TriggerHandler.updateRejectedRMA(rejectedRMASet);
        }
    }
}