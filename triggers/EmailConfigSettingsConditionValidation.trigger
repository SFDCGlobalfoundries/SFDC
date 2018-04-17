trigger EmailConfigSettingsConditionValidation on Email_Config_Settings__c (before insert, before update) {
    
    if(checkRecursive.runOnce() || system.Test.isRunningTest()){
        if(Trigger.isBefore && Trigger.isInsert) {
            ECSRecordValidationHandler.handleBeforeInsert(Trigger.new);
        }else if(Trigger.isBefore && Trigger.isUpdate){
            ECSRecordValidationHandler.handleBeforeUpdate(Trigger.new);
        }
    }  
}