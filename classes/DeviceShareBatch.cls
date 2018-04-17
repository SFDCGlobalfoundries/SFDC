/*
    Author: Zymark Ambat
    Description: This batch class is created to refresh the Device Sharing of Exposed Devices.
    History: 
        ZAmbat      03282014    - Code creation.
*/

global class DeviceShareBatch implements Database.Batchable<sObject> {
    global String query = '';
    
    // Constructor
    global DeviceShareBatch(string queryString) {
        if (queryString != null) {
            query = queryString;
        } else {
            query = 'SELECT     Id, Contact.AccountId ' +
                    'FROM       User ' + 
                    'WHERE      isPortalEnabled = true AND IsActive = true';
        }
    }
    
    // Start method to execute the query
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject> scope) {
        Set<Id> userIds = new Set<Id>();
        for (User u : (List<User>)scope) {
            userIds.add(u.Id);
        }
        
        // Create map of Devices per Account
        Map<id, Account> mapDevicesPerAccount = new Map<id, Account>([
            SELECT      Id
                        , (SELECT Id FROM Devices__r WHERE Expose_Device_to_Customer__c = true)
            FROM        Account
        ]);
        
        // Create map of Export Control Forms per Device
        Map<id, Device__c> mapExportControlFormPerDevice = new Map<id, Device__c>([
            SELECT      Id
                        , (SELECT Export_Control_Form__c FROM Device_Export_Control_Junctions__r WHERE Export_Control_Form__c != null)
            FROM        Device__c
            WHERE       Expose_Device_to_Customer__c = true
        ]);
        
        // Store Account Hierarchy in map
        Map<id, id> mapAccountsAboveHierarchy = new Map<id, id>();
        Map<id, id> mapAccountsBelowHierarchy = new Map<id, id>();
        for (Account a : [SELECT    Id
                                    , ParentId
                          FROM      Account
                          WHERE     ParentId != null]) {
            mapAccountsAboveHierarchy.put(a.Id, a.ParentId);
            mapAccountsBelowHierarchy.put(a.ParentId, a.Id);
        }
        
        // Loop thru the users for each account and add sharing rule to Device and Export Control
        List<Device__Share> shareDevices = new List<Device__Share>(); 
        List<Export_Control_Form__Share> shareExps = new List<Export_Control_Form__Share>();
        for (User u : [SELECT       Id
                                    , Contact.AccountId
                       FROM         User
                       WHERE        isPortalEnabled = true
                                    AND isActive = true
                                    AND Id IN :userIds]) {
            // Give access to exposed Devices and Export Control Forms under the user's Account
            if (mapDevicesPerAccount.containsKey(u.Contact.AccountId)) {    
                if (mapDevicesPerAccount.get(u.Contact.AccountId).Devices__r.size() > 0) {
                    for (Device__c d : mapDevicesPerAccount.get(u.Contact.AccountId).Devices__r) {
                        // Add Device share
                        Device__Share rec = new Device__Share();
                        rec.AccessLevel = 'Edit';
                        rec.ParentId = d.Id;
                        rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                        rec.UserOrGroupId = u.Id;
                        shareDevices.add(rec);
                        
                        // Add Export Control share
                        if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                            if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                    Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                    rec2.AccessLevel = 'Edit';
                                    rec2.ParentId = j.Export_Control_Form__c;
                                    rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                    rec2.UserOrGroupId = u.Id;
                                    shareExps.add(rec2);
                                }
                            }
                        }
                    }   
                }
            }
            
            // Give access to exposed Devices and Export Control Forms above the user's Account hierarchy
            string tempAccountId = u.Contact.AccountId;
            while(mapAccountsAboveHierarchy.containsKey(tempAccountId)) {
                tempAccountId = mapAccountsAboveHierarchy.get(tempAccountId);
                if (mapDevicesPerAccount.containsKey(tempAccountId)) {  
                    if (mapDevicesPerAccount.get(tempAccountId).Devices__r.size() > 0) {
                        for (Device__c d : mapDevicesPerAccount.get(tempAccountId).Devices__r) {
                            // Add Device share
                            Device__Share rec = new Device__Share();
                            rec.AccessLevel = 'Edit';
                            rec.ParentId = d.Id;
                            rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                            rec.UserOrGroupId = u.Id;
                            shareDevices.add(rec);
                            
                            // Add Export Control share
                            if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                                if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                    for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                        Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                        rec2.AccessLevel = 'Edit';
                                        rec2.ParentId = j.Export_Control_Form__c;
                                        rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                        rec2.UserOrGroupId = u.Id;
                                        shareExps.add(rec2);
                                    }
                                }
                            }
                        }   
                    }
                }
            }
            
            // Give access to exposed Devices and Export Control Forms below the user's Account hierarchy
            tempAccountId = u.Contact.AccountId;
            while(mapAccountsBelowHierarchy.containsKey(tempAccountId)) {
                tempAccountId = mapAccountsBelowHierarchy.get(tempAccountId);
                if (mapDevicesPerAccount.containsKey(tempAccountId)) {  
                    if (mapDevicesPerAccount.get(tempAccountId).Devices__r.size() > 0) {
                        for (Device__c d : mapDevicesPerAccount.get(tempAccountId).Devices__r) {
                            // Add Device share
                            Device__Share rec = new Device__Share();
                            rec.AccessLevel = 'Edit';
                            rec.ParentId = d.Id;
                            rec.RowCause = Schema.Device__Share.RowCause.FoundryView_User__c;
                            rec.UserOrGroupId = u.Id;
                            shareDevices.add(rec);
                            
                            // Add Export Control share
                            if (mapExportControlFormPerDevice.containsKey(d.Id)) {
                                if (mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r.size() > 0) {
                                    for (Device_Export_Control_Junction__c j : mapExportControlFormPerDevice.get(d.Id).Device_Export_Control_Junctions__r) {
                                        Export_Control_Form__Share rec2 = new Export_Control_Form__Share();
                                        rec2.AccessLevel = 'Edit';
                                        rec2.ParentId = j.Export_Control_Form__c;
                                        rec2.RowCause = Schema.Export_Control_Form__Share.RowCause.FoundryView_User__c;
                                        rec2.UserOrGroupId = u.Id;
                                        shareExps.add(rec2);
                                    }
                                }
                            }
                        }   
                    }
                }
            }
        }
        
        system.debug('shareDevices.size() ============================> ' + shareDevices.size());
        if (shareDevices.size() > 0) { 
            insert shareDevices;  
        }
        
        system.debug('shareExps.size() ============================> ' + shareExps.size());
        if (shareExps.size() > 0) {
            insert shareExps;
        }          
    }
    
    global void finish(Database.BatchableContext BC){}
}