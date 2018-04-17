/*
    Author: Nikhil Jain
    Description: Test class for export controller for LotTrackerExportExtension
    History:
        Njain       06/01/2014  - Created the test class.
        DBiswal     03312015    - Updated code for refactoring of test class.
*/
@isTest
private class LotTrackerExportExtensionTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                   
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    //Positive test method for exporting the Tracked Lots associated to Lot Tracker
    static testMethod void test_exportTrackedLots() {
      
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Process__c processRec = new Process__c();
        processRec.name = 'test Process';
        processRec.Tech_Type__c = 'CT';
        processRec.Tech_Geometry__c = '0.010UM';
        insert processRec;
        
        Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
        mfgLot.name = 'Test Mfg Lot';
        mfgLot.Fab_Group__c = 'FAB 2';
        mfgLot.Process_Id__c = processRec.id;
        mfgLot.Geometry__c = '0.010UM';
        mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
        insert mfgLot;
        
        Manufacturing_Lot__c mfgLot2 = new Manufacturing_Lot__c();
        mfgLot2.name = 'Test Mfg Lot2';
        mfgLot2.Fab_Group__c = 'FAB 3';
        mfgLot2.Process_Id__c = processRec.id;
        mfgLot2.Geometry__c = '0.010UM';
        mfgLot2.Actual_Fab_Out_Date__c = System.Today() + 5;
        insert mfgLot2;
        
        Lot_Tracker__c lotTrackerRec = new Lot_Tracker__c();
        lotTrackerRec.Account__c = acc.id;
        lotTrackerRec.Description__c = 'Test Description';
        insert lotTrackerRec;
        
        Tracked_Lot__c trackedLotRec = new Tracked_Lot__c();
        trackedLotRec.Lot_Tracker__c = lotTrackerRec.id;
        trackedLotRec.Manufacturing_Lot__c = mfgLot.id;
        insert trackedLotRec;
        
        Tracked_Lot__c trackedLotRec2 = new Tracked_Lot__c();
        trackedLotRec2.Lot_Tracker__c = lotTrackerRec.id;
        trackedLotRec.Manufacturing_Lot__c = mfgLot2.id;
        insert trackedLotRec2;
        
        Test.startTest();
            Test.setCurrentPageReference(page.TrackedLots_Export);
            ApexPages.currentPage().getParameters().put('id',lotTrackerRec.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(lotTrackerRec);
            LotTrackerExportExtension trackedLotNew = new LotTrackerExportExtension(sc);            
        Test.stopTest();
            
    }
    
    //Negative test method for exporting when no Tracked Lots are associated to Lot Tracker
    static testMethod void test_noTrackedLotRecordExport() {
       
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        Process__c processRec = new Process__c();
        processRec.name = 'test Process';
        processRec.Tech_Type__c = 'CT';
        processRec.Tech_Geometry__c = '0.010UM';
        insert processRec;
        
        Manufacturing_Lot__c mfgLot = new Manufacturing_Lot__c();
        mfgLot.name = 'Test Mfg Lot';
        mfgLot.Fab_Group__c = 'FAB 2';
        mfgLot.Process_Id__c = processRec.id;
        mfgLot.Geometry__c = '0.010UM';
        mfgLot.Actual_Fab_Out_Date__c = System.Today() + 3;
        insert mfgLot;
        
        Manufacturing_Lot__c mfgLot2 = new Manufacturing_Lot__c();
        mfgLot2.name = 'Test Mfg Lot2';
        mfgLot2.Fab_Group__c = 'FAB 3';
        mfgLot2.Process_Id__c = processRec.id;
        mfgLot2.Geometry__c = '0.010UM';
        mfgLot2.Actual_Fab_Out_Date__c = System.Today() + 5;
        insert mfgLot2;
        
        Lot_Tracker__c lotTrackerRec = new Lot_Tracker__c();
        lotTrackerRec.Account__c = acc.id;
        lotTrackerRec.Description__c = 'Test Description';
        insert lotTrackerRec;
        
        Test.startTest();
            Test.setCurrentPageReference(page.TrackedLots_Export);
            ApexPages.currentPage().getParameters().put('id',lotTrackerRec.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(lotTrackerRec);
            LotTrackerExportExtension trackedLotNew = new LotTrackerExportExtension(sc);            
        Test.stopTest();
            
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}