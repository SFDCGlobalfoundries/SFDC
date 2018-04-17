/*
    Author: Nikhil Jain
    Description: Test class for Mass Edit Controller for TrackedLotMassEditExtension
    History:
        Njain       06/01/2014    - Created the test class.
        DBiswal     04012015      - Updated code for refactoring of test class.
*/
@isTest
private class TrackedLotMassEditExtensionTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static testMethod void test_saveForNewRecord() {
       
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Account acc = getAccount('testing901');
        
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
        
         Manufacturing_Lot__c mfgLot3 = new Manufacturing_Lot__c();
        mfgLot3 .name = 'Test Mfg Lot4';
        mfgLot3 .Fab_Group__c = 'FAB 4';
        mfgLot3 .Process_Id__c = processRec.id;
        mfgLot3 .Geometry__c = '0.010UM';
        mfgLot3 .Actual_Fab_Out_Date__c = System.Today() + 5;
        insert mfgLot3 ;
        
        Lot_Tracker__c lotTrackerRec = new Lot_Tracker__c();
        lotTrackerRec.Account__c = acc.id;
        lotTrackerRec.Description__c = 'Test Description';
        insert lotTrackerRec;
        
        Lot_Tracker__c lotTrackerRec1 = new Lot_Tracker__c();
        lotTrackerRec1 .Account__c = acc.id;
        lotTrackerRec1 .Description__c = 'Test Description1';
        insert lotTrackerRec1 ;
        
        Tracked_Lot__c trackedLotRec = new Tracked_Lot__c();
        trackedLotRec.Lot_Tracker__c = lotTrackerRec.id;
        trackedLotRec.Manufacturing_Lot__c = mfgLot.id;
        insert trackedLotRec;
        
        Tracked_Lot__c trackedLotRec2 = new Tracked_Lot__c();
        trackedLotRec2.Lot_Tracker__c = lotTrackerRec.id;
        trackedLotRec.Manufacturing_Lot__c = mfgLot2.id;
        insert trackedLotRec2;
        
        Tracked_Lot__c trackedLotRec3 = new Tracked_Lot__c();
        trackedLotRec3.Lot_Tracker__c = lotTrackerRec.id;
        trackedLotRec3.Manufacturing_Lot__c = mfgLot3.id;
        insert trackedLotRec3;
        
        Test.startTest();
            Test.setCurrentPageReference(page.TrackedLot_MassEdit);
            ApexPages.currentPage().getParameters().put('id',lotTrackerRec.id);
                        
            List<Tracked_Lot__c > lstTrackedLot = new List<Tracked_Lot__c >();
            lstTrackedLot.add(trackedLotRec);
            lstTrackedLot.add(trackedLotRec2);
            
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lstTrackedLot);
            
            ssc.setSelected(new Tracked_Lot__c []{trackedLotRec});
            TrackedLotMassEditExtension trackedLotObj = new TrackedLotMassEditExtension(ssc);
                            
            ssc.setSelected(new Tracked_Lot__c[]{trackedLotRec2});
            TrackedLotMassEditExtension trackedLotObj2 = new TrackedLotMassEditExtension(ssc);
            
            trackedLotObj.saveForNewRecord();
            trackedLotObj2.saveForNewRecord();
            
            trackedLotObj.saveCustom();

            //covering the Exception block
            trackedLotObj.saveForNewRecord();
        Test.stopTest();            
    }
    
    static testMethod void test_newTrackedRecord() {
       
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Account acc = getAccount('testing901');
            
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
            Test.setCurrentPageReference(page.TrackedLot_MassEdit);
            ApexPages.currentPage().getParameters().put('id',lotTrackerRec.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(trackedLotRec);
            TrackedLotMassEditExtension trackedLotNew = new TrackedLotMassEditExtension(sc);
            trackedLotNew.saveCustom();
            trackedLotNew.saveForNewRecord();
            PageReference pageRef = new PageReference('/'+trackedLotRec.Lot_Tracker__c);
            pageRef.setRedirect(true);
            
        Test.stopTest();            
    }
     
    private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }  
}