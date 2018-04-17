/**
* Author: Sameera Gaidhane
* Description: Test class for ShipmentLotTrigger.
**/
@isTest
private class ShipmentLotTriggerTest{
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                                 
        fieldValueMap.put('site_department__c', 'test dept');                                           
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');                   
        fieldValueMap.put('Copy_Address__c', true);        
        fieldValueMap.put('Fab_9_10__c','No');
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    public static testmethod void testMethod1(){
        Account acc = [SELECT id from Account LIMIT 1];
        Shipment__c Shipment1 = new Shipment__c();
        Shipment1.Name = 'Shpmnt1';
        Shipment1.Account__c = acc.id;
        Database.insert(Shipment1);
        
        Sales_Order_Line__c salesOrderLine1 = new Sales_Order_Line__c();
        salesOrderLine1.Account__c = acc.Id;
        salesOrderLine1.Doc_Number__c = 'SONum1';
        Database.insert(salesOrderLine1); 
        
        Shipment_Line__c ShipmentLine1 = new Shipment_Line__c();
        ShipmentLine1.Name = 'ShipmntLn1';
        ShipmentLine1.Shipment__c = Shipment1.id;
        ShipmentLine1.Sales_Order__c = salesOrderLine1.id;
        //ShipmentLine1.Ship_Qty__c =0;
        Database.insert(ShipmentLine1);
        
        Shipment_Line__c ShipmentLine2 = new Shipment_Line__c();
        ShipmentLine2.Name = 'ShipmntLn2';
        ShipmentLine2.Shipment__c = Shipment1.id;
        ShipmentLine2.Sales_Order__c = salesOrderLine1.id;
       // ShipmentLine2.Ship_Qty__c =0;
        Database.insert(ShipmentLine2);
        
        Shipment_Container__c ShipmentContainer1 = new Shipment_Container__c();
        ShipmentContainer1.Shipment_Id__c = Shipment1.id;
        Database.insert(ShipmentContainer1);
        
        Shipment_Lot__c Shipment_Lot_1 = new Shipment_Lot__c();
        Shipment_Lot_1.Shipment_Container__c = ShipmentContainer1.id;
        Shipment_Lot_1.Ship_Item_Id__c = ShipmentLine1.id;
        Shipment_Lot_1.Lot_Qty__c = 150;
        Database.insert(Shipment_Lot_1);
        
        Shipment_Lot__c Shipment_Lot_2 = new Shipment_Lot__c();
        Shipment_Lot_2.Shipment_Container__c = ShipmentContainer1.id;
        Shipment_Lot_2.Ship_Item_Id__c = ShipmentLine1.id;
        Shipment_Lot_2.Lot_Qty__c = 200;
        Database.insert(Shipment_Lot_2);
        
        Shipment_Lot__c Shipment_Lot_3 = new Shipment_Lot__c();
        Shipment_Lot_3.Shipment_Container__c = ShipmentContainer1.id;
        Shipment_Lot_3.Ship_Item_Id__c = ShipmentLine2.id;
        Shipment_Lot_3.Lot_Qty__c = 500;
        Database.SaveResult result = Database.insert(Shipment_Lot_3);
        system.debug('******Shipment_Lot_3'+Shipment_Lot_3);
        
        String ShipQty1 ='';
        for(Shipment_Line__c shipmentLINErecord:  [SELECT Ship_Qty__c FROM Shipment_Line__c WHERE id =: ShipmentLine2.id]){
            ShipQty1 = String.valueOf(shipmentLINErecord.Ship_Qty__c);
            system.debug(shipmentLINErecord.Ship_Qty__c +'$$$$$$$$2');
            system.debug('******ShipQty1'+ShipQty1);
        }
        system.debug('******ShipQty1.contains 500$'+ShipQty1.contains('500'));
        System.assert(ShipQty1.contains('500'));
        
        Database.delete(Shipment_Lot_3);
        

        for(Shipment_Line__c shipmentLINErecord:  [SELECT Ship_Qty__c FROM Shipment_Line__c WHERE id =: ShipmentLine1.id]){
            ShipQty1 = String.valueOf(shipmentLINErecord.Ship_Qty__c);
            system.debug(shipmentLINErecord.Ship_Qty__c +'$$$$$$$$1');
            system.debug('******ShipQty1'+ShipQty1);
        }
        system.debug('******ShipQty1.contains 500$'+ShipQty1.contains('500'));
        System.assert(ShipQty1.contains('350'));
    
        Database.undelete(Shipment_Lot_3);
    } 
   

}