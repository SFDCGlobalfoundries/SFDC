/*
    History:
        ZAmbat    1208014    - Updated code to send out Yield Feedback reminders for QD and QF Manufacturing Lots.
        ZAmbat    02272015   - Updated code to update WaferWriteOff_ManufacturingLot__c records when Manufacturing_Lot__c records were updated.
        NJain     29-Jun-15  - Added logic to filter records for which Ship To Customer Date is populated/changed and then updating Lot Instr.
                               Replacing Ship To Customer Date with Last Ship Date.
*/ 

trigger ManufacturingLot_afterUpdate on Manufacturing_Lot__c (after update, before update, before insert, after insert) {
    
    if(Trigger.isAfter) {
        // ZAmbat 12082014
        Set<Id> lotIds = new Set<Id>();
        Set<Id> lotIdsUpdate = new Set<Id>();
        Set<Id> lotIdsDelete = new Set<Id>();
        
        List<Manufacturing_Lot__c> lstModifiedMfgLot = new List<Manufacturing_Lot__c>();
        
        //check for Manufacturing Lot records for which the Lot Type is changed
        for(Manufacturing_Lot__c mfgLot : Trigger.new){
            Set<string> wwoLotTypes = new Set<string>{'PB', 'PP', 'PX', 'QX'};
            if (trigger.isUpdate) {
                if(mfgLot.Lot_Type__c != Trigger.oldmap.get(mfgLot.id).Lot_Type__c ||
                   (mfgLot.Last_Ship_Date__c != NULL &&
                    mfgLot.Last_Ship_Date__c != Trigger.oldMap.get(mfglot.Id).Last_Ship_Date__c) //NJain-17Jun15-Added for Lot Service Req
                ){
                    lstModifiedMfgLot.add(mfgLot);
                }
                
                if (mfgLot.Current_Lot_Die_Quantity__c != trigger.oldMap.get(mfgLot.Id).Current_Lot_Die_Quantity__c
                    || mfgLot.Current_Wafer_Quantity_In_Lot__c != trigger.oldMap.get(mfgLot.Id).Current_Wafer_Quantity_In_Lot__c) {
                    lotIdsUpdate.add(mfgLot.Id);
                }
                
                if (!mfgLot.Active_Flag__c && trigger.oldMap.get(mfgLot.Id).Active_Flag__c
                    || (mfgLot.Lot_Type__c != trigger.oldMap.get(mfgLot.Id).Lot_Type__c
                        && !wwoLotTypes.contains(mfgLot.Lot_Type__c))) {
                    lotIdsDelete.add(mfgLot.Id);
                }
            }
            
            // ZAmbat 12082014
            if (mfgLot.Lot_Type__c != null) {
                if (trigger.isInsert) {
                    if (mfgLot.Lot_Type__c.startsWith('QD') || mfgLot.Lot_Type__c.startsWith('QF')) {
                        lotIds.add(mfgLot.Id);
                    }
                } else if (trigger.isUpdate) {
                    if ((trigger.newMap.get(mfgLot.Id).Lot_Type__c.startsWith('QD')
                         && (trigger.oldMap.get(mfgLot.Id).Lot_Type__c == null || (trigger.oldMap.get(mfgLot.Id).Lot_Type__c != null && !trigger.oldMap.get(mfgLot.Id).Lot_Type__c.startsWith('QD')))) 
                       || (trigger.newMap.get(mfgLot.Id).Lot_Type__c.startsWith('QF') 
                           && (trigger.oldMap.get(mfgLot.Id).Lot_Type__c == null || (trigger.oldMap.get(mfgLot.Id).Lot_Type__c != null && !trigger.oldMap.get(mfgLot.Id).Lot_Type__c.startsWith('QF'))))) {     
                        lotIds.add(mfgLot.Id);
                    }
                }
            }
        }
        
        if (trigger.isUpdate) {
            List<Lot_Instruction__c> lstLotInstrn = [select id,name,Manufacturing_Lot__c from Lot_Instruction__c where Manufacturing_Lot__c in :lstModifiedMfgLot limit 10000];
            if(lstLotInstrn.size()<10000 && lstLotInstrn.size()>0){
                for(Lot_Instruction__c lotInstrn : lstLotInstrn){
                    lotInstrn.Lot_Type__c = Trigger.newMap.get(lotInstrn.Manufacturing_Lot__c).Lot_Type__c;
                    //lotInstrn.Ship_to_Customer_Date_ML_AutoPopulate__c = Date.valueOf(Trigger.newMap.get(lotInstrn.Manufacturing_Lot__c).Ship_to_Customer_Date__c);
                }
                try{
                    Database.update(lstLotInstrn,false);
                }catch(Exception e){
                    system.debug('###Error Occurred during Lot Instruction Update:###'+e.getMessage());
                }
            }
        }
        
        // ZAmbat 12082014
        if (lotIds.size() > 0) {
            ManufacturingLotSendNotifications.sendEmail(lotIds);
        }
        
        // ZAmbat 02272015
        if (lotIdsUpdate.size() > 0) {
            WaferWriteOffManufacturingLotUpdate.updateWaferWriteOffManufacturingLot(lotIdsUpdate);
        }
        
        if (lotIdsDelete.size() > 0) {
            WaferWriteOffManufacturingLotUpdate.deleteWaferWriteOffManufacturingLot(lotIdsDelete);
        }
    }
    
    if(Trigger.isBefore) {
        List<Id> lstProcessIds = new List<Id>();
        for(Manufacturing_Lot__c mfgLotRec: Trigger.new) {
            lstProcessIds.add(mfgLotRec.Process_Id__c);
        }
        map<Id,Process__c> mapProcessId= new map<Id,Process__c>([select id,Tech_Geometry__c,Tech_Type__c from Process__c where Id in :lstProcessIds]);
        
        for(Manufacturing_Lot__c mfgLotRecord:Trigger.new){
            if(mfgLotRecord.Process_Id__c != NULL){
                mfgLotRecord.Geometry__c = mapProcessId.get(mfgLotRecord.Process_Id__c).Tech_Geometry__c;
                mfgLotRecord.Technology_Type__c = mapProcessId.get(mfgLotRecord.Process_Id__c).Tech_Type__c;
            }
        }
    }
}