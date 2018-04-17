@isTest
public class RMA_Invoice_TriggerTest{

    @TestSetup
    static void prepareTestData(){
        DataUtilTest.loadEnvironmentVariables();
        RMA_TestDataUtility.createAccount();
    }
    
    static testmethod void testInvoiceInsertion(){
        Account acc = [select id from account limit 1];
        Test.startTest();
            RMA_TestDataUtility.createManufacturingLots(1);
            
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot1';
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 1';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = acc.Id;
            invRec.GDPW__c = 1234;
            invRec.Invoice_Date__c = System.Today()-5;
            invRec.Invoice_Number__c = '123456';
            invRec.Item_Type__c = 'TK';
            invRec.Part_Number__c = 'qwerty';
            invRec.Process_Name__c = 'testProcess';
            invRec.Purchase_Order_Number__c = 'PO12345';
            invRec.Sales_Order_Number__c = 'SO12345';
            invRec.Unit_Selling_Price__c = 100;
            invRec.Wafer_Id__c = '1;2;3;4;5';
            invRec.ExternalId__c = invRec.Lot_Name__c+'-'+ invRec.Invoice_Number__c;
            insert invRec;
       Test.stopTest();            
    }
}