/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for LotServiceRequestPopulateTables.
    History: 
        ZAmbat      11042014    - Code creation.
        Ashwini     05282015    - Updated code for refactoring of test class.
*/

@isTest(SeeAllData=false)
public class LotServiceRequestPopulateTablesTest {
    //Commenting the class for deletion from Production
    /*
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }   
    static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account ZA';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        
         
                
        return testAcct.Id;
        
        
    }
           
    static Fab_Cycle_Time_Table__c searchFabCycleTimeValue(string effectiveQuarter) {
        //Added by Ashwini as class was failing on 5/28/2015
        //List<Fab_Cycle_Time_Table__c >fabCycTimeTabless = new List<Fab_Cycle_Time_Table__c > ();
        Fab_Cycle_Time_Table__c fabCycTimeTable = new Fab_Cycle_Time_Table__c();
        fabCycTimeTable.Fab__c = 'FAB 2';
        fabCycTimeTable.Geometry__c = '0.010UM';
        fabCycTimeTable.Effective_Quarter__c = effectiveQuarter;
        fabCycTimeTable.Expiration_Date__c = date.today().addDays(10);
        //f.Expiration_Date__c = date.today().addDays(10);
        insert fabCycTimeTable;
        
        //f.Expiration_Date__c = date.today().addDays(10);
        //update f;
                
        Lot_Request_Price_Table__c lotReqPriceTable = new Lot_Request_Price_Table__c();
        lotReqPriceTable.Fab__c = 'FAB 2';
        lotReqPriceTable.Geometry__c = '0.010UM'; 
        lotReqPriceTable.Effective_Quarter__c = effectiveQuarter;      
        lotReqPriceTable.Expiration_Date__c = date.today().addDays(10);
        insert lotReqPriceTable;
        
        return fabCycTimeTable;
    }
    
    static testMethod void testLotServiceRequestPopulateTables1() {
        string accountId = LotServiceRequestPopulateTablesTest.createAccount();
        Fab_Cycle_Time_Table__c f = LotServiceRequestPopulateTablesTest.searchFabCycleTimeValue(date.today().year() + 'Q1');
        test.startTest();
            Lot_Request__c l = new Lot_Request__c();
            l.Account__c = accountId;
            l.Lot_Request_Type__c = 'Standard Expedite';
            l.Sales_Order_for_the_Lot__c = 'test';
            l.Customer_Requested_Lot_Quantity__c = 1;
            l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
            Date myDate =  date.newinstance(date.today().year(), 1, 1);
            l.Date_Customer_Submitted_Request__c = myDate;
            l.Fab__c = f.Fab__c;
            l.Geometry__c = f.Geometry__c;
            
            insert l;
        test.stopTest();
    }
    
    static testMethod void testLotServiceRequestPopulateTables2() {
        string accountId = LotServiceRequestPopulateTablesTest.createAccount();
        Fab_Cycle_Time_Table__c f = LotServiceRequestPopulateTablesTest.searchFabCycleTimeValue(date.today().year() + 'Q2');
        test.startTest();
            Lot_Request__c l = new Lot_Request__c();
            l.Account__c = accountId;
            l.Lot_Request_Type__c = 'Standard Expedite';
            l.Sales_Order_for_the_Lot__c = 'test';
            l.Customer_Requested_Lot_Quantity__c = 1;
            l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
            Date myDate =  date.newinstance(date.today().year(), 4, 1);
            l.Date_Customer_Submitted_Request__c = myDate;
            l.Fab__c = f.Fab__c;
            l.Geometry__c = f.Geometry__c;
            
            insert l;
        test.stopTest();
    }
    
    static testMethod void testLotServiceRequestPopulateTables3() {
        string accountId = LotServiceRequestPopulateTablesTest.createAccount();
        Fab_Cycle_Time_Table__c f = LotServiceRequestPopulateTablesTest.searchFabCycleTimeValue(date.today().year() + 'Q3');
        test.startTest();
            Lot_Request__c l = new Lot_Request__c();
            l.Account__c = accountId;
            l.Lot_Request_Type__c = 'Standard Expedite';
            l.Sales_Order_for_the_Lot__c = 'test';
            l.Customer_Requested_Lot_Quantity__c = 1;
            l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
            Date myDate =  date.newinstance(date.today().year(), 7, 1);
            l.Date_Customer_Submitted_Request__c = myDate;
            l.Fab__c = f.Fab__c;
            l.Geometry__c = f.Geometry__c;
            
            insert l;
        test.stopTest();
    }
    
    static testMethod void testLotServiceRequestPopulateTables4() {
        string accountId = LotServiceRequestPopulateTablesTest.createAccount();
        Fab_Cycle_Time_Table__c f = LotServiceRequestPopulateTablesTest.searchFabCycleTimeValue(date.today().year() + 'Q4');
        test.startTest();
            Lot_Request__c l = new Lot_Request__c();
            l.Account__c = accountId;
            l.Lot_Request_Type__c = 'Standard Expedite';
            l.Sales_Order_for_the_Lot__c = 'test';
            l.Customer_Requested_Lot_Quantity__c = 1;
            l.Does_Customer_Accept_Standard_Pricing__c = 'Yes';
            l.New_Customer_Requested_Date_CRD_CSR__c = date.today();
            Date myDate =  date.newinstance(date.today().year(), 10, 1);
            l.Date_Customer_Submitted_Request__c = myDate;
            l.Fab__c = f.Fab__c;
            l.Geometry__c = f.Geometry__c;
            
            insert l;
        test.stopTest();
    }
    */
}