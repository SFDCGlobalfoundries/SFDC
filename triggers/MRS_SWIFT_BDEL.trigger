/*
swgp-998
delete shadow object when mrs is deleted
test class: MRSBatchRetryMSIHTest
*/
trigger MRS_SWIFT_BDEL on MRS__c (before delete) {
    delete [select id from MRS_Layer_Chip_Syncing_Status__c where MRS_Layer_Chip_Association__r.Layer__r.mrs__c in :trigger.oldMap.keyset()];
    delete [select id from MRS_Layer_Syncing_Status__c where MRS_Layer_Association__r.mrs__c in :trigger.oldMap.keySet()];
}