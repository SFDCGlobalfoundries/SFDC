/*
*   Author: Sameera Gaidhane
*   Description:  This class is helper class for Trigger ShipmentLotTrigger.
*   History:   31/03/2017    - Apex code created               

*   Modified Date : 14-06-2017
*   Modified by   : Anil Kumar Reddy L
*   Reason 	   	  : Modified the varaible initilization.
*/
Public class ShipmentLotTriggerHelper{

    Public Set<Id> ShipmentLineIds = new Set<Id>();
    public void ShipmentLotUpdated(List<Shipment_Lot__c> sLotList){
        if(sLotList !=null && !sLotList.isEmpty()){
             for(Shipment_Lot__c shipmentLot:sLotList){
                 if(shipmentLot.Ship_Item_Id__c!=null){
                            ShipmentLineIds.add(shipmentLot.Ship_Item_Id__c);
                 }
             }
             if(!ShipmentLineIds.isEmpty()){
                  ShipmentLotLogic();
             } 
        }
    }

    public void ShipmentLotDeleted(List<Shipment_Lot__c> sLotList){
        if(sLotList !=null && !sLotList.isEmpty()){
             for(Shipment_Lot__c shipmentLot:sLotList){
                    if(shipmentLot.Ship_Item_Id__c!=null){
                        ShipmentLineIds.add(shipmentLot.Ship_Item_Id__c);
                    }
              }
             if(!ShipmentLineIds.isEmpty()){
                  ShipmentLotLogic();
             }
        }  
    }
    
    
    /* Mehod to calculate total ShipmentLot quantity and display it in parent ShipmentLine record quantity field */
    public void ShipmentLotLogic(){
        try{
           	/** Start - L Anil Kumar Reddy - 14-06-2017 - Changed the posistion of initlization*/
            //Integer totalQuantity = 0;
            /** End - L Anil Kumar Reddy - 14-06-2017 - Changed the posistion of initlization*/
            List<Shipment_Line__c> ShipmentLineToUpdate = new List<Shipment_Line__c>();
            for(Shipment_Line__c shipmentLineRecord:[Select id,Ship_Qty__c,(Select id,Lot_Qty__c from Shipment_Lot__r) from Shipment_Line__c where id IN: ShipmentLineIds]){
                if(shipmentLineRecord.Shipment_Lot__r.size() > 0){
                    /** Start - L Anil Kumar Reddy - 14-06-2017 - Changed the posistion of initlization*/
                    Integer totalQuantity = 0;
                    /** End - L Anil Kumar Reddy - 14-06-2017 - Changed the posistion of initlization*/
                    for(Shipment_Lot__c shipmentLotRecord: shipmentLineRecord.Shipment_Lot__r){
                        if(shipmentLotRecord.Lot_Qty__c!=null){
                            totalQuantity = integer.valueOf(shipmentLotRecord.Lot_Qty__c) + totalQuantity ;
                        }
                    }
                   shipmentLineRecord.Ship_Qty__c =  totalQuantity;
                   ShipmentLineToUpdate.add(shipmentLineRecord); 
                }else{
                   shipmentLineRecord.Ship_Qty__c =  0;
                   ShipmentLineToUpdate.add(shipmentLineRecord); 
                }
            }
            if(!ShipmentLineToUpdate.isEmpty()){       
                Database.update(ShipmentLineToUpdate);
            }
        }catch(Exception ex){
            ApplicationLogWrapper appLog = new  ApplicationLogWrapper();
            appLog.source = 'ShipmentLotTriggerHelper';
            appLog.logMessage = ex.getMessage();
            appLog.debugLevel = 'Error';
        } 
    }

}