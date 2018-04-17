/*
    Author: Zymark Ambat
    Description: This Class serves as the trigger for the Wafer_Write_Off__c.
    History: 
        ZAmbat      02082015    - Code creation.
*/

trigger WaferWriteOffTrigger on Wafer_Write_Off__c (before update, after update) {
    List<Wafer_Write_Off__c> listWaferWriteOff = new List<Wafer_Write_Off__c>();
    Set<Id> wwoIds = new Set<Id>();

    if (trigger.isBefore) {
        for (Wafer_Write_Off__c w : trigger.new) {
            if (w.Status__c == 'Pending Account Manager Confirmation' && trigger.oldMap.get(w.Id).Status__c != 'Pending Account Manager Confirmation') {
                listWaferWriteOff.add(w);
            }
        }
        
        if (listWaferWriteOff.size() > 0) {
            WaferWriteOffSearchATPMembers.retrieveAccountManager(listWaferWriteOff);
        }
    } else if (trigger.isAfter) {
        for (Wafer_Write_Off__c w : trigger.new) {
            if ((w.Status__c == 'Draft' && trigger.oldMap.get(w.Id).Status__c != 'Draft')
                 || (w.Status__c == 'Rejected' && trigger.oldMap.get(w.Id).Status__c != 'Rejected')) {
                wwoIds.add(w.Id);
            }
        }
    }
    
    if (wwoIds.size() > 0) {
        List<WaferWriteOff_ManufacturingLot__c> listWWOML = new List<WaferWriteOff_ManufacturingLot__c>();
        for (WaferWriteOff_ManufacturingLot__c w : [SELECT    Id
                                                              , Wafer_Qty__c
                                                              , Die_Qty__c
                                                              , Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c
                                                              , Manufacturing_Lot__r.Current_Lot_Die_Quantity__c
                                                    FROM      WaferWriteOff_ManufacturingLot__c
                                                    WHERE     Wafer_Write_Off__c IN :wwoIds]) {
            w.Wafer_Qty__c = w.Manufacturing_Lot__r.Current_Wafer_Quantity_In_Lot__c;
            w.Die_Qty__c = w.Manufacturing_Lot__r.Current_Lot_Die_Quantity__c;
            w.Aged_Days__c = null;
            listWWOML.add(w);
        }
        
        if (listWWOML.size() > 0) {
            update listWWOML;
        }
    }
}