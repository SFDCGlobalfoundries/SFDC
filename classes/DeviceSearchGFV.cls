/*
    Author: Zymark Ambat
    Description: This serves as the Device search class for GFV.
    History: 
        ZAmbat      05232014    - Code creation.
*/
public without sharing class DeviceSearchGFV {
    public static List<Device__c> retrieveDevices(Id accountId, string searchKey) {
        // Get Account Id
        Account a = [
            SELECT      Id
                        , ParentId
            FROM        Account
            WHERE       Id = :accountId
        ];
        
        // Get Accounts in the Account Hierarchy
        Set <Id> accountIds = new Set<Id>();
        if (a.ParentId != null) {
            for (Account_Hierarchy__c ah : [SELECT      Parent_Id__c
                                            FROM        Account_Hierarchy__c
                                            WHERE       Account_Id__c = :a.Id
                                                        AND Parent_Id__c != :a.Id]) { 
                accountIds.add(ah.Parent_Id__c);
            }
        } 
           
        // Check for Devices below the Account Hierarchy
        for (Account_Hierarchy__c ah : [SELECT      Account_Id__c
                                        FROM        Account_Hierarchy__c
                                        WHERE       Parent_Id__c = :a.Id
                                                    AND Account_Id__c != :a.Id]) { 
            accountIds.add(ah.Account_Id__c);
        }
        
        // Add User's Account Id
        accountIds.add(a.Id);
        
        // Get Devices
        searchKey = '%' + searchKey + '%';
        List<Device__c> listDevice = [
            SELECT      Id
                        , Name
                        , Stage__c
                        , Account_Short_Name__c
                        , Fab__c
                        , Geometry__c
                        , Current_Forecast_Tapeout_Date__c
            FROM        Device__c
            WHERE       Account__c IN :accountIds
                        AND Name LIKE :searchKey
            ORDER BY    Name
        ];
        
        return listDevice;
    }
}