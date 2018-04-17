/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for DeviceMPWForecastedTapeoutDate.
    History: 
        ZAmbat      07312014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Devendra  10142015      - Updated to fix device validation error
*/ 

@isTest(SeeAllData=false)
private class DeviceMPWForecastedTapeoutDateTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
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
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
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
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId, Id testMpwId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Name','MPWTEST_1'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Fab__c','FAB 2'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('CRMDID__c','CDID0000001.00'); 
        fieldValueMap.put('Device_Type__c','Revise'); 
        fieldValueMap.put('MPW_Train_Number__c',testMpwId); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c','100'); 
        fieldValueMap.put('Reticle_Type__c','Small Field Reticle (SFR)'); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today()); 
        fieldValueMap.put('Previous_Enabling_Devices_MPW__c',testMpwId); 
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now()); 
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MPWTEST'); 
        fieldValueMap.put('Geometry_Filter__c','0.10UM'); 
        fieldValueMap.put('End_Application__c','Powertrain'); 
        fieldValueMap.put('PTRF_ID__c','test');
        return DeviceDataFactory.createDevice(fieldValueMap); 
        
    }
    
    static MPW_Train_Maintenance__c createMPWTrain() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'zTestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        
        insert m;
        
        return m;
    }
    
    static testMethod void testDeviceMPWForecastedTapeoutDate1() {
        Account testAccount = getAccount('MYTEST ACCOUNT1');
        testAccount.recordtypeid = EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER');
        update testAccount;
        string testOpptyId = DeviceMPWForecastedTapeoutDateTest.createOpportunity(testAccount.Id);
        string testOpptyProgramId = DeviceMPWForecastedTapeoutDateTest.createOpportunityProgram(testAccount.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = DeviceMPWForecastedTapeoutDateTest.createMPWTrain();
        
        test.startTest();
        Device__c testDevice = DeviceMPWForecastedTapeoutDateTest.createDevice(testAccount.Id, testOpptyProgramId, testMpw.Id);
        
        testDevice.MPW_Train_Number__c = testMpw.id;
        update testDevice;
        test.stopTest();
    }
    
    static testMethod void testDeviceMPWForecastedTapeoutDate2() {
        Account testAccount = getAccount('MYTEST ACCOUNT1');
        testAccount.recordtypeid = Environment_Variable__c.getInstance('ACCT_RT_ID_GF_INTERNAL').Value__c;
        update testAccount;
        string testOpptyId = DeviceMPWForecastedTapeoutDateTest.createOpportunity(testAccount.Id);
        string testOpptyProgramId = DeviceMPWForecastedTapeoutDateTest.createOpportunityProgram(testAccount.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = DeviceMPWForecastedTapeoutDateTest.createMPWTrain();
        test.startTest();
        Device__c testDevice = DeviceMPWForecastedTapeoutDateTest.createDevice(testAccount.Id, testOpptyProgramId, testMpw.Id);
        
        testDevice.MPW_Train_Number__c = testMpw.id;
        update testDevice;
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}