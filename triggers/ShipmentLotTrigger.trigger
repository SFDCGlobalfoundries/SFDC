/**
* Author: Sameera Gaidhane
* Description: This trigger is used to calculate total ShipmentLot quantity and display it in parent ShipmentLine record quantity field.
**/

trigger ShipmentLotTrigger on Shipment_Lot__c (after insert,after update,after delete,after undelete) {
    ShipmentLotTriggerHelper helper = new ShipmentLotTriggerHelper();
  
        if(!Trigger.isDelete){
            helper.ShipmentLotUpdated(Trigger.New);
        }else{
          helper.ShipmentLotDeleted(Trigger.Old);
        } 

}