/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This is a test class for RMA_MassUploadExtension
 * History:
 *    SurendranadhNune 09022016  -   Created.
 *                            
 **/
@isTest(seeAllData=false)
private class RMA_MassUploadExtensionTest {
    @Testsetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
         RMA_TestDatautility.createRMA(1, acc);
    }
    
    static void insertTemplate(){
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.Title = 'RMA-CSV-Import-Format';
        contentVersionObj.PathOnClient = 'RMA-CSV-Import-Format.txt';
        contentVersionObj.VersionData = Blob.valueOf('Test Content');
        contentVersionObj.IsMajorVersion = true;
        insert contentVersionObj;
    }
    static testmethod void testUploadCSV(){
        UtilClassToGetAllFields util = new UtilClassToGetAllFields(); 
        String rmaFields = util.getAllFields('RMA__c');   
        RMA__c rmaRec = database.query('select '+rmaFields+' from RMA__c limit 1');
        Account acc = [select id from account limit 1];
        Test.startTest();
            RMA_TestDatautility.createInvoices(1, acc);
             insertTemplate();
         
            Test.setCurrentPage(Page.RMA_MassUpload);
            RMA_MassUploadExtension extn = new RMA_MassUploadExtension(new ApexPages.StandardController(new RMA__c()));
            extn = new RMA_MassUploadExtension(new ApexPages.StandardController(rmaRec));
            
            //catchblock
            extn.csvFileBody = null;
            extn.importCSVFile();
            
            //inserting duplicate lots
            String csv = 'Lot Number,Adjusted Unit Price,Scrap Limit,Yield,Die Quantity\n'+
                         'testLot1,1,10,5,20\n'+
                         'testLot1,1,10,5,20\n';
            extn.csvFileBody = Blob.valueOf(csv);           
            extn.importCSVFile();
            
            csv = 'Lot Number,Adjusted Unit Price,Scrap Limit,Yield,Die Quantity\n'+
                  'testLot1,1,10,5,20\n';
            extn.csvFileBody = Blob.valueOf(csv);           
            //extn.importCSVFile();     
            
            //Test import csv with invalid customer data
            delete [select id from invoice__c];
            
            Invoice__c invRec = new Invoice__c();
            invRec.Lot_Name__c = 'testLot1';
            invRec.Fab_Code__c = 'FS1';
            invRec.Fab_Group__c = 'FAB 0';
            invRec.Bill_Quantity__c = 100;
            invRec.Customer_Name__c = null;
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
            extn.importCSVFile();   
            
            //Test import csv with invalid fab data
            delete [select id from invoice__c];
            
            Invoice__c invRec1 = new Invoice__c();
            invRec1.Lot_Name__c = 'testLot1';
            invRec1.Fab_Code__c = 'FS1';
            invRec1.Fab_Group__c = 'FAB 0';
            invRec1.Bill_Quantity__c = 100;
            invRec1.Customer_Name__c = acc.id;
            invRec1.GDPW__c = 1234;
            invRec1.Invoice_Date__c = System.Today()-5;
            invRec1.Invoice_Number__c = '123456';
            invRec1.Item_Type__c = 'TK';
            invRec1.Part_Number__c = 'qwerty';
            invRec1.Process_Name__c = 'testProcess';
            invRec1.Purchase_Order_Number__c = 'PO12345';
            invRec1.Sales_Order_Number__c = 'SO12345';
            invRec1.Unit_Selling_Price__c = 100;
            invRec1.Wafer_Id__c = '1;2;3;4;5';
            invRec1.ExternalId__c = invRec1.Lot_Name__c+'-'+ invRec1.Invoice_Number__c;
            insert invRec1;
            extn.importCSVFile();   
            
            
            //Test import csv with invalid item data
            delete [select id from invoice__c];
            
            Invoice__c invRec2 = new Invoice__c();
            invRec2.Lot_Name__c = 'testLot1';
            invRec2.Fab_Code__c = 'FS1';
            invRec2.Fab_Group__c = 'FAB 1';
            invRec2.Bill_Quantity__c = 100;
            invRec2.Customer_Name__c = acc.id;
            invRec2.GDPW__c = 1234;
            invRec2.Invoice_Date__c = System.Today()-5;
            invRec2.Invoice_Number__c = '123456'; 
            invRec2.Item_Type__c = 'TK';
            invRec2.Part_Number__c = 'qwerty';
            invRec2.Process_Name__c = 'testProcess';
            invRec2.Purchase_Order_Number__c = 'PO12345';
            invRec2.Sales_Order_Number__c = 'SO12345';
            invRec2.Unit_Selling_Price__c = 100;
            invRec2.Wafer_Id__c = '1;2;3;4;5';
            invRec2.ExternalId__c = invRec2.Lot_Name__c+'-'+ invRec2.Invoice_Number__c;
            insert invRec2;
            extn.importCSVFile();   
            
            //Test with valid data
            delete [select id from invoice__c];
            delete [select id from manufacturing_lot__c];
            RMA_TestDatautility.createInvoices(1, acc);
            extn.importCSVFile();       
            extn.LotInvToEdit = 'testLot1';
            extn.InvNumToEdit = '123456';
            extn.WaferToEdit = '1;2;3;4;5'; 
            extn.mapRMARIwrapper.get('testLot1-123456').waferNotSelected = '1;2;3;';   
            extn.EditLotInfo(); 
            extn.UpdateLineItems();
            extn.InsertLineItems();
            extn.CancelPopup();
            extn.returnToRMA();
            
        Test.stopTest();
    }
    
}