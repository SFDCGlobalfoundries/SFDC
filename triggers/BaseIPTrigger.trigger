trigger BaseIPTrigger on Base_IP__c (before insert, before update, after update) {
    
    new BaseIPTriggerHandler().run();
}