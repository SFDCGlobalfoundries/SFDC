trigger VoCTrigger on VoC__c (before delete) {
    VoCScoreTriggerUtil.fetchVoCScoreListOnVoCDelete(trigger.old);
}