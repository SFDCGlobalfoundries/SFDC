trigger STM_TRIGGER_TaskChild on STMTaskChild__c (After Insert,After Update) {
    if(System.Label.STM_TRIGGER_TaskChild_Enable.equalsIgnoreCase('True')){
        if(Trigger.isAfter){
            if(Trigger.isUpdate || Trigger.isInsert){
                STM_TRIGGER_HELPER_TaskChild.STMTaskChild_AfterInsert(Trigger.New);
            }
        }
    }
}