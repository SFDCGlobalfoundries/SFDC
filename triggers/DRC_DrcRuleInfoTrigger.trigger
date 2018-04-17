/*
* @ Author :- Navneet Rajput
* @ Description :- Trigger will help to calculate aggregated waiver status on Designwaiver collaborator object (parent object) 
* @ Date :- 5th April 2016
* @ Change History :-  Added condition in if statement to skip trigger execution for integration user
**/

trigger DRC_DrcRuleInfoTrigger on Waiver_Rule_List__c (after update,after insert) {

    if(!DfmUtilityCls.stopTrigger || !IntegrationUserUtil.isSkipTrigger()){
    
        List<Waiver_Rule_List__c> wrLst = new List<Waiver_Rule_List__c>();
        
        for (Waiver_Rule_List__c ruleRecord : Trigger.New){     
            
           // if (Trigger.isInsert || (Trigger.isUpdate && ruleRecord.Final_Stage__c != Trigger.oldMap.get(ruleRecord.Id).Final_Stage__c)) {
           if (Trigger.isInsert || Trigger.isUpdate) {
                
                wrLst.add(ruleRecord);
            }
        }
        
        if (wrLst<>NULL && !wrLst.isEmpty()) {
            
            DRC_DrcRuleInfoTriggerHandler.prepareRuleTable(wrLst);
        }
        
        if(trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
            if(!WaiverCustomRecordSharing.isExecuted && trigger.new[0].Delegation__c 
            ) 
            //trigger.old[0].Delegation__c != trigger.new[0].Delegation__c
            WaiverCustomRecordSharing.shareRecord(trigger.new[0].Waiver_Collaborator__c, trigger.new[0].id);
        }
    
    }
}