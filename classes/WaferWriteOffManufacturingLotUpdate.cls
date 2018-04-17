/*
    Author: Zymark Ambat
    Description: This Class updates WaferWriteOff_ManufacturingLot__c records.
    History: 
        ZAmbat      02272015    - Code creation.
*/

public class WaferWriteOffManufacturingLotUpdate {
    public static void updateWaferWriteOffManufacturingLot(Set<Id> lotIds) {
        List<WaferWriteOff_ManufacturingLot__c> tempList = retrieveRecords(lotIds);
        if (tempList.size() > 0) {
            for (WaferWriteOff_ManufacturingLot__c w : tempList) {
                w.Wafer_Qty__c = w.Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c;
                w.Die_Qty__c = w.Manufacturing_Lot__r.Current_Lot_Die_Quantity__c;
            }
        
            update tempList;
        }
    }

    public static void deleteWaferWriteOffManufacturingLot(Set<Id> lotIds) {
        List<WaferWriteOff_ManufacturingLot__c> tempList = retrieveRecords(lotIds);
        if (tempList.size() > 0) {
            delete tempList;
        }
    }
    
    static List<WaferWriteOff_ManufacturingLot__c> retrieveRecords(Set<Id> lotIds) {
        return [SELECT    Id
                          , Wafer_Qty__c
                          , Die_Qty__c
                          , Manufacturing_Lot__r.Current_Lot_Die_Quantity__c
                          , Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c
                FROM      WaferWriteOff_ManufacturingLot__c
                WHERE     Manufacturing_Lot__c IN :lotIds
                          AND Wafer_Write_Off_Status__c IN ('Draft', 'Rejected')];        
    }
}