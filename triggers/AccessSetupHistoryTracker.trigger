trigger AccessSetupHistoryTracker on Portal_Tab_Access__c (after insert, after update) {
    AccessSetupHistoryTrackerHelper acc = new AccessSetupHistoryTrackerHelper();
    if(trigger.isAfter && trigger.isUpdate){
		//update values
    	acc.AccessSetupMethod(trigger.new,trigger.oldmap);
    }
}