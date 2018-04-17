/*
    Author: Zymark Ambat
    Description: This Trigger handles the delete operation(s) on the Lot Prefix object.
    History: 
        ZAmbat      04192013    - Code creation.
*/

trigger LotPrefixDeleteTrigger on Lot_Prefix__c (before delete) {
	DeletedRecordsManager.insertRecords(Trigger.old, EnvironmentVariable.get('LOT_PREFIX_ENTITY'));
}