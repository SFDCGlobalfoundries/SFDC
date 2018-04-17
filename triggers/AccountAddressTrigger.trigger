trigger AccountAddressTrigger on Account_Address__c (after update, before update) {
    if(trigger.isUpdate){
        if(trigger.isBefore){
            AccountAddressTriggerHelper.validateExistAddress(trigger.new,trigger.oldmap);
        }
        if(trigger.isAfter){
            AccountAddressTriggerHelper.updateAccOnPrimaryAddrChange(trigger.new,trigger.oldmap);
            AccountAddressTriggerHelper.sendAddressToERPOnApproved(trigger.new,trigger.oldmap);
            AccountAddressTriggerHelper.resetSendSAPFormFlag(trigger.new,trigger.oldmap);
        }
    }
}