/*
    Author: Zymark Ambat
    Description: This is a class that updates the related Devices when Last Ship Date is modified.
    History: 
        ZAmbat      01132015    - Code creation.
*/

public class ManufacturingLotUpdateDevice {
    public static void updateDevices(Set<string> lotNames) {
        Set<Id> deviceIds = new Set<Id>();
        for (AggregateResult a : [SELECT    Device__c
                                  FROM      Yield_Feedback__c
                                  WHERE     Manufacturing_Lot__r.Name LIKE :lotNames
                                  GROUP BY  Device__c]) {
            deviceIds.add((Id)a.get('Device__c'));
        }
        
        List<Device__c> listDevice = new List<Device__c>();
        if (deviceIds.size() > 0) {
            for (Device__c d : [SELECT    Id
                                          , Proto_Lot_Start_ID_Change_Date__c
                                FROM      Device__c
                                WHERE     Id IN :deviceIds]) {
                d.Proto_Lot_Start_ID_Change_Date__c = date.today();
                listDevice.add(d);
            }
            
            if (listDevice.size() > 0) {
                update listDevice;
            }
        }
    }
}