trigger VoCScoreTrigger on VoC_Score__c (before insert, before update, before delete) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            VoCScoreTriggerUtil.manageTrends(trigger.new,null,'insert');
        }
        else if(trigger.isUpdate){
            VoCScoreTriggerUtil.manageTrends(trigger.new,trigger.oldmap,'update');
        }
        else if(trigger.isDelete){
            VoCScoreTriggerUtil.manageTrends(trigger.old,null,'delete');
        }        
    }       
}