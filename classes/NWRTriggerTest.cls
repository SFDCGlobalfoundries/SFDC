/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for NWRTrigger.
    History: 
        ZAmbat      11042014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/

@isTest(SeeAllData=false)
private class NWRTriggerTest {

@testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }   
    static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('testing901'); 
           
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity ZA');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program ZA';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Id createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        
        insert m;
        
        return m.Id;
    }
    static Id CreateMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MasksetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    static Id createDevice(Id testAcctId, Id testOpptyProgramId, string tapeoutType) {
        string mpwId = DeviceUtilTest.createMPW();
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Tapeout_Type__c',tapeoutType);
        fieldValueMap.put('Fab__c','FAB 2');        
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c ','100');
        
        if (tapeoutType != 'Single Product') {
            fieldValueMap.put('MPW_Train_Number__c',mpwId);
            fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
            
        }
        if (tapeoutType == 'Single Product') {
            fieldValueMap.put('Device_Mask_Set_Title__c','MSTXXX1');
        }
        
        if (tapeoutType != 'Retrofit') {
            fieldValueMap.put('Device_Type__c','Base');
        } else {
            fieldValueMap.put('Device_Type__c','Retrofit');
            fieldValueMap.put('PTRF_ID__c','test');
        }
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
    }
    
    static void createNWR(Id opptyId, Id deviceId, string nrType, string subType, string po) {
        Non_Wafer_Revenue__c n = new Non_Wafer_Revenue__c();
        n.Opportunity__c = opptyId;
        n.Device__c = deviceId;
        n.Non_Wafer_Revenue_Type__c = nrType;
        n.Sub_Type__c = subType;
        n.Billing_Date__c = date.today();
        n.Billing_Revenue__c = 100;
        n.PO__c = po;
        
        insert n;
        
    }
    
    // Customer MPW
    static testMethod void testNWRTrigger1() {
     test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Customer MPW');
            Device__c deviceId = DeviceUtilTest.createCMPWDevice(acctId, opptyProgramId);
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.id, 'Reticle', 'First Tape-out', 'test');
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger2() {
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Customer MPW');
            Device__c deviceId = DeviceUtilTest.createCMPWDevice(acctId, opptyProgramId);
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'MPW', null);
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger3() {
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Customer MPW');
            Device__c deviceId = DeviceUtilTest.createCMPWDevice(acctId, opptyProgramId);
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'Retrofit', 'test');
        test.stopTest();
    }
    
    // GlobalShuttle MPW
    static testMethod void testNWRTrigger4() {
     
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'GlobalShuttle MPW');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'GlobalShuttle MPW');
            test.startTest();
            insert deviceId;
            test.stopTest();
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'MPW', 'First Tape-out', 'test');
        
    }
    
    static testMethod void testNWRTrigger5() {
       
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
       
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'GlobalShuttle MPW');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'GlobalShuttle MPW');
         test.startTest();
            insert deviceId;
         test.stopTest();  
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'MPW', 'MPW', null);
        
    }
    
    static testMethod void testNWRTrigger6() {
       
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
      
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'GlobalShuttle MPW');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'GlobalShuttle MPW');
           test.startTest();
            insert deviceId;
           test.stopTest(); 
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'MPW', 'Retrofit', 'test');
        
    }
    
    // Retrofit
    static testMethod void testNWRTrigger7() {
    
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'NRE', 'First Tape-out', 'test');
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger8() {
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'NRE', 'MPW', null);
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger9() {
       test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'NRE', 'Retrofit', 'test');
        test.stopTest();
    }
    
    // Single Product
    static testMethod void testNWRTrigger10() {
      
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Single Product');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Single Product');
            deviceId.Name = 'TESTDEVICEZAIH123456345';
          test.startTest();  
            insert deviceId;
          test.stopTest(); 
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'First Tape-out', 'test');
        
    }
    
    static testMethod void testNWRTrigger11() {
    
      
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
       
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Single Product');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Single Product');
            deviceId.Name = 'TESTDEVICEZAIH123456123';
           test.startTest();
            insert deviceId;
           test.stopTest();  
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'MPW', null);
        
    }
    
    static testMethod void testNWRTrigger12() {
    
     
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
         
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Single Product');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Single Product');
            deviceId.Name = 'TESTDEVICEZAIH123456678';
           test.startTest();
            insert deviceId;
           test.stopTest(); 
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'Retrofit', 'test');
       
    }
    
    // Full Layer Retrofit
    static testMethod void testNWRTrigger13() {
    
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Full Layer Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Full Layer Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'First Tape-out', 'test');
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger14() {
    
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Full Layer Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Full Layer Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'MPW', null);
        test.stopTest();
    }
    
    static testMethod void testNWRTrigger15() {
    
      test.startTest();
        string acctId = NWRTriggerTest.createAccount();
        string opptyId = NWRTriggerTest.createOpportunity(acctId);
        string opptyProgramId = NWRTriggerTest.createOpportunityProgram(acctId, opptyId);
        
            //string deviceId = NWRTriggerTest.createDevice(acctId, opptyProgramId, 'Full Layer Retrofit');
            Device__c deviceId = DeviceUtilTest.createDeviceNew(acctId, opptyProgramId, 'Full Layer Retrofit');
            insert deviceId;
            NWRTriggerTest.createNWR(opptyId, deviceId.Id, 'Reticle', 'Retrofit', 'test');
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}