/*
    Author: Zymark Ambat
    Description: This class handles the operations on the Deleted_Record__c object.
    History: 
        ZAmbat      04192013    - Code creation.
*/

public with sharing class DeletedRecordsManager {
    
    // Insert
    public static void insertRecords(List<SObject> listSObject, String entity) {
        // Get SObject Type
        List<Deleted_Record__c> listDeletedRecords = new List<Deleted_Record__c>(); 
        for (SObject s : listSObject) {
            Deleted_Record__c dr = new Deleted_Record__c();
            dr.Record_Id__c = s.Id;
            dr.Entity__c = entity;
            
            listDeletedRecords.add(dr);
        }
        
        if (listDeletedRecords.size() > 0) {
            Insert listDeletedRecords;
        }
    }
}