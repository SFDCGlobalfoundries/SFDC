@isTest(SeeAllData= false)
private class RMA_BATCH_InvoiceFabRedTest{

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        Account acc = RMA_TestDataUtility.createAccount();
    }
       
    public static testmethod void testMethod1(){
        Account acc = [select id from Account limit 1];
        Shipment_Internal__c shipment = new Shipment_Internal__c();
        shipment.Account__c = acc.Id;
        insert shipment;
        
        Shipment_Container_Internal__c sc = new Shipment_Container_Internal__c();
        sc.Shipment_Id__c = shipment.Id;
        insert sc;
        
        Sales_Order_Line__c so = new Sales_Order_Line__c();
        so.Account__c = acc.Id;
        so.Doc_Number__c = 'SONum1';
        so.Itm_Number__c = 10;
        so.Deliv_Item__c = 10;
        insert so;
        
        Shipment_Line_Internal__c sl = new Shipment_Line_Internal__c();
        sl.Shipment__c = shipment.Id;
        sl.Sales_Order__c = so.Id;
        sl.PO_Date__c = system.TODAY();
        sl.Net_Price__c = 100;
        sl.PO_Num__c = 'testPOinternal';
        sl.Ship_Qty__c = 100;
        sl.Order_Num__c = 'SalesOrderInternal1';
        sl.Cust_Shipto__c = '123456';
        sl.Delivery_Date__c = System.TODAY();
        sl.Del_Plant__c = 'BTV1';
        sl.IBM_Part_Num__c = 'InternalPt1';
        sl.Order_Item_Num__c = 10;
		sl.Invoice_Num__c = 'testInvoice';
        insert sl;
        
        Shipment_Lot_Internal__c lot = new Shipment_Lot_Internal__c();
        lot.Ship_Item_Id__c = sl.Id;
        lot.Shipment_Container__c = sc.Id;
        lot.COO__c = 'US';
        lot.Delivery_Batch_Item__c = '10';
        lot.Lot_Num__c = 'Internal1';
        lot.Lot_Qty__c = 25;
        insert lot;
        
        ERP_Device__c erp = new ERP_Device__c();
        erp.name = 'testERPInternal1';
        erp.ERP_Inventory_Id__c = 'testERPInventoryInternalId1';
        erp.Deliverable_Type__c = 'WAFER';
        erp.Part_Number__c = 'InternalPt1';
        insert erp;
        
        RMA_BATCH_InvoiceFabRed batch=new RMA_BATCH_InvoiceFabRed();
        test.startTest();
            ID jobID=Database.executeBatch(batch);
        test.stopTest();
        
    }      
           
}