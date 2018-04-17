/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Handler class for ManufacturingLotTrigger trigger on Manufacturing_Lot__c  
* History:
*    Anil Kumar 06/05/2016 - Created
**/
public with sharing class ManufacturingLotTriggerHandler {

    /*
    * Description : Method to perform action on after insert of Manufacturing Lot
    */
    public void onAfterInsert(List<Manufacturing_Lot__c> lstNewMfgLot) {
        assignPrimeDieToMfgLot(lstNewMfgLot, NULL, 'INSERT');
    }   
    
    /*
    * Description : Method to perform action on after update of Manufacturing Lot
    */
    public void onAfterUpdate(List<Manufacturing_Lot__c> lstNewMfgLot, Map<Id, Manufacturing_Lot__c> mapOldMfgLot) {
        assignPrimeDieToMfgLot(lstNewMfgLot, mapOldMfgLot, 'UPDATE');
    } 
    
    /*
    * Description : Method for assignment of Prime Dies to splitted Manufacturing Lot from Parent Manufacturing Lot based on Device Id
    */
    private void assignPrimeDieToMfgLot(List<Manufacturing_Lot__c> lstNewMfgLot, Map<Id, Manufacturing_Lot__c> mapOldMfgLot, String strEvent) {
        Set<String> setParentLotIds = new Set<String>();
        List<MPW_WIP_Lot__c> lstMPWWIPLotToBeInsertUpdate = new List<MPW_WIP_Lot__c>();
        Map<String, List<Manufacturing_Lot__c>> mapParentMfgLotToChildMfgLots = new Map<String, List<Manufacturing_Lot__c>>();
        
        //Collecting Parent Lot Id for new Mfg Lot 
        for(Manufacturing_Lot__c objMfg : lstNewMfgLot) {
            if((objMfg.Parent_Lot_Id__c != null && objMfg.Parent_Lot_Id__c.trim() != '' && objMfg.Device_ID_MES__c != NULL && objMfg.Device_ID_MES__c.trim() != '') && (strEvent == 'INSERT' || (strEvent == 'UPDATE' && (objMfg.Parent_Lot_Id__c != mapOldMfgLot.get(objMfg.Id).Parent_Lot_Id__c || objMfg.Device_ID_MES__c != mapOldMfgLot.get(objMfg.Id).Device_ID_MES__c)))) {
                setParentLotIds.add(objMfg.Parent_Lot_Id__c.trim());
                String strKey = objMfg.Parent_Lot_Id__c.trim() + '-' + objMfg.Device_ID_MES__c.trim();
                
                if(!mapParentMfgLotToChildMfgLots.containsKey(strKey)) {
                    mapParentMfgLotToChildMfgLots.put(strKey, new List<Manufacturing_Lot__c>{objMfg});
                }
                else {
                    List<Manufacturing_Lot__c> lstMfgLotTemp = mapParentMfgLotToChildMfgLots.get(strKey);
                    lstMfgLotTemp.add(objMfg);
                    mapParentMfgLotToChildMfgLots.put(strKey, lstMfgLotTemp);
                }
            }
        }
        
        //Assigning Prime Die to splitted Manufacturing Lot
        for(MPW_WIP_Lot__c objMPWWIPLot : [SELECT Id, Manufacturing_Lot__c, Manufacturing_Lot__r.Manufacturing_Lot_Id__c, MPW_Prime_Die__c,  
                                            MPW_MES_Part_ID__c, Assignment_Type__c 
                                            FROM MPW_WIP_Lot__c
                                            WHERE Manufacturing_Lot__r.Manufacturing_Lot_Id__c IN: setParentLotIds ]) {
            String strKey = objMPWWIPLot.Manufacturing_Lot__r.Manufacturing_Lot_Id__c.trim() + '-' + objMPWWIPLot.MPW_MES_Part_ID__c.trim();
                                                
            if(mapParentMfgLotToChildMfgLots.containsKey(strKey)) {
                Boolean isFirstRecord = true;
                  
                for(Manufacturing_Lot__c objMfg : mapParentMfgLotToChildMfgLots.get(strKey)) {
                    if(isFirstRecord) {
                        objMPWWIPLot.Manufacturing_Lot__c = objMfg.Id;
                        lstMPWWIPLotToBeInsertUpdate.add(objMPWWIPLot);
                        isFirstRecord = false;
                    }
                    else {
                        MPW_WIP_Lot__c obj = new MPW_WIP_Lot__c();
                        obj.Manufacturing_Lot__c = objMfg.Id;
                        obj.MPW_Prime_Die__c = objMPWWIPLot.MPW_Prime_Die__c;
                        obj.MPW_MES_Part_ID__c = objMPWWIPLot.MPW_MES_Part_ID__c;
                        obj.Assignment_Type__c = objMPWWIPLot.Assignment_Type__c;
                        lstMPWWIPLotToBeInsertUpdate.add(obj);
                    }
                }
            }
        }
        
        if(lstMPWWIPLotToBeInsertUpdate.size() > 0) { 
            Savepoint sp = Database.setSavepoint();
            try {
                upsert lstMPWWIPLotToBeInsertUpdate;
            }
            catch(Exception ex) {
                Database.rollback(sp);
                MPWExceptionHandler.exceptionHandler(ex, ManufacturingLotTriggerHandler.class.getName(), 'assignPrimeDieToMfgLot()', '', 'Manufacturing Lot Trigger');
            }
        }
    }
}