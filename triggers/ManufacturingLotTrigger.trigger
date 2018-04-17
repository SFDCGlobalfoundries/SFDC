/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Trigger on Manufacturing Lot
* History:
*    Anil Kumar 06/05/2016 - Created
**/
trigger ManufacturingLotTrigger on Manufacturing_Lot__c (after insert, after update) {
    ManufacturingLotTriggerHandler objHandler = new ManufacturingLotTriggerHandler();
    
    if(trigger.isInsert && trigger.isAfter) {
        objHandler.onAfterInsert(trigger.new);
    }
    
    if(trigger.isUpdate && trigger.isAfter) {
        objHandler.onAfterUpdate(trigger.new, trigger.oldMap);
    } 
}