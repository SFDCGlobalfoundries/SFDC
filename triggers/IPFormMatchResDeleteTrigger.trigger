/*
    Author: Anirban Roy
    Description: This Trigger handles the delete operation(s) on the IP Form Matching Result object.
    History: 
        ARoy      07102013    - Code creation.
*/

trigger IPFormMatchResDeleteTrigger on IP_Form_Matching_Result__c (before delete) {
	DeletedRecordsManager.insertRecords(Trigger.old, EnvironmentVariable.get('IP_FORM_MATCH_RES_ENTITY'));
}