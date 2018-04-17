/*
SWGP-998
Clear child shadow obj when parent is deleted
*/
trigger MRS_Layer_Association_SWIFT_BDEL on MRS_Layer_Association__c (before delete) {
    
    set<id> lidSet = new set<id>();
    for(MRS_Layer_Association__c m: trigger.old) {
        lidSet.add(m.Id);
    }
    
    delete [select id from MRS_Layer_Syncing_Status__c where MRS_Layer_Association__c in :lidSet];
    
    delete [select id from MRS_Layer_Chip_Syncing_Status__c where MRS_Layer_Chip_Association__r.Layer__c in :lidSet];
}