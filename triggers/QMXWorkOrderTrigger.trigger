/*************************************************************************************************************************************************************
@ Trigger:        QMXWorkOrderTrigger
@ Version:        1.0
@ Author:         Pradosh Samal/Yathish (pradosh.samal@globalfoundries.com/yathish.ns1@globalfoundries.com)
@ Purpose:        This trigger fires on Work_Order__c object before/after creating or editing the records of Work_Order__c object.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 11.09.2017 / Pradosh Samal / Created the class.
**************************************************************************************************************************************************************/
trigger QMXWorkOrderTrigger on Work_Order__c (after Insert,before update,before insert) {
    new QMXWorkOrderTriggerHandler().run();
     /*Set<Id> rmaIdSet = new Set<Id>();
     List<Work_Order_Lot__c> wolList= new List<Work_Order_Lot__c>();
     Map<Id,RMA__c> rmaRetInvoice = new Map<Id,RMA__c>();
     if(trigger.isafter && trigger.isinsert){
         QMXWorkOrderTriggerHelper.createWOLot(trigger.new);
     }
     if(trigger.isbefore && trigger.isinsert){
         QMXWorkOrderTriggerHelper.updateCusIns(trigger.new);
        
        QMXWorkOrderTriggerHelper.populateExpirationDate(Trigger.new);
     }
     if(trigger.isbefore && trigger.isupdate){
         QMXWorkOrderTriggerHelper.handleUpdate(trigger.new); 
         QMXWorkOrderTriggerHelper.declaredLOTValidation();   
     } */   
}