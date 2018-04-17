/*
    Author: Abhita Bansal
    Description: This serves as the trigger for MPW_Change_Request__c.
    History: 
        ABansal      27072015    - Code creation.
*/ 
trigger MPWChangeRequestTrigger on MPW_Change_Request__c (after insert, after update, after delete) {
    
    MPWChangeRequestTriggerHandler handler = new MPWChangeRequestTriggerHandler();
    public List<MPW_Change_Request__c> mpwChangeReqList = new List<MPW_Change_Request__c>();
    public List<MPW_Change_Request__c> mpwChangeReqListExtraDies = new List<MPW_Change_Request__c>();
    
    if (!IntegrationUserUtil.isSkipTrigger()) {
        if(trigger.isUpdate && trigger.isAfter){
            for(MPW_Change_Request__c ch: trigger.new){
                MPW_Change_Request__c oldChangeValue = Trigger.oldMap.get(ch.Id);
                System.debug('========Double trigger'+ch.Extra_Dies_Status__c);
                if((ch.Status__c == 'Accepted by MPW Tapeout' || ch.Status__c == 'Accepted by CE' || ch.Status__c == 'Accepted by Turnkey') && ch.Extra_Dies_Status__c == false){
                    if(ch.Request_Type__c != 'Extra Dies/Wafer Re-start') {
                        mpwChangeReqList.add(ch);
                    } else {
                        mpwChangeReqListExtraDies.add(ch);
                    }
                } 
            }
        }
        
        if(!mpwChangeReqList.isEmpty()){
            handler.updatePrimeDie(mpwChangeReqList);
        }
        
        if(!mpwChangeReqListExtraDies.isEmpty()){
             handler.updateExtraDie(mpwChangeReqListExtraDies);
        }
        
        // Added by Anil : MPW-PP103 
        if(trigger.isAfter && trigger.isInsert){
            handler.onAfterInsert(trigger.new);
        }
        
        // Added by Anil : MPW-PP103 
        if(trigger.isAfter && trigger.isUpdate){
            handler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
        
        // Added by Anil : MPW-PP103 
        if(trigger.isAfter && trigger.isDelete){
            handler.onAfterDelete(trigger.old);
        }
    }
}