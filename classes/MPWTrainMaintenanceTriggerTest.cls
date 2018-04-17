/*
    Author: Zymark Ambat
    Description: This Class serves as the Test Class for MPWTrainMaintenanceTrigger.
    History: 
        ZAmbat      08072014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/ 
@isTest(SeeAllData=false)
private class MPWTrainMaintenanceTriggerTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
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
        AccountDataFactory.createAccount(fieldValueMap);
    }

    static Account createAccount(Id recordTypeId) {
        // Create Account
        Account testAcct = getAccount('Test Account 007'); 
        
        return testAcct;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
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
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Account__c',testAcctId);
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
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static MPW_Train_Maintenance__c createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        return m;
    }
    static MPW_Train_Maintenance__c createMPW1() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        Insert m;
        return m;
    }
    
    static testMethod void testMPWTrainMaintenanceTrigger1() {
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = MPWTrainMaintenanceTriggerTest.createAccount(rt.Id);
        string testOpptyId = MPWTrainMaintenanceTriggerTest.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWTrainMaintenanceTriggerTest.createOpportunityProgram(testAcct.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = MPWTrainMaintenanceTriggerTest.createMPW1();
        Device__c testDevice = MPWTrainMaintenanceTriggerTest.createDevice(testAcct.Id, testOpptyProgramId, testMpw.Id);
        
        test.startTest();
            //testMpw.Name = 'MPW35T';
            //Insert testMpw;
            testMpw.Customer_Tapeout_Date__c = date.today().addDays(5);
            //testMpw.Geometry__c = '0.35um';
            //testMpw.Publish__c = True;
            //testMpw.Active__c = True;
            update testMpw;
        test.stopTest();
    }
    
    
    static testMethod void testMPWTrainMaintenanceTrigger2() {
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'GLOBALFOUNDRIES Internal'
        ];
        
        Account testAcct = MPWTrainMaintenanceTriggerTest.createAccount(rt.Id);
        string testOpptyId = MPWTrainMaintenanceTriggerTest.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWTrainMaintenanceTriggerTest.createOpportunityProgram(testAcct.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = MPWTrainMaintenanceTriggerTest.createMPW();
        Device__c testDevice = MPWTrainMaintenanceTriggerTest.createDevice(testAcct.Id, testOpptyProgramId, testMpw.Id);
        
        test.startTest();
            Insert testMpw;
            testMpw.Other_Tapeout_Date__c = date.today().addDays(5);
            update testMpw;
        test.stopTest();
    }
    static testMethod void testMPWTrainMaintenanceTrigger3() {
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = MPWTrainMaintenanceTriggerTest.createAccount(rt.Id);
        string testOpptyId = MPWTrainMaintenanceTriggerTest.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWTrainMaintenanceTriggerTest.createOpportunityProgram(testAcct.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = MPWTrainMaintenanceTriggerTest.createMPW();
        Device__c testDevice = MPWTrainMaintenanceTriggerTest.createDevice(testAcct.Id, testOpptyProgramId, testMpw.Id);
        
        test.startTest();
            testMpw.Name = 'MPW04T';
            Insert testMpw;
            testMpw.Customer_Tapeout_Date__c = date.today().addDays(5);
            testMpw.Geometry__c = '40nm';
            testMpw.Publish__c = True;
            testMpw.Active__c = True;
            update testMpw;
        test.stopTest();
    }
    static testMethod void testMPWTrainMaintenanceTrigger4() {
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = MPWTrainMaintenanceTriggerTest.createAccount(rt.Id);
        string testOpptyId = MPWTrainMaintenanceTriggerTest.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWTrainMaintenanceTriggerTest.createOpportunityProgram(testAcct.Id, testOpptyId);
        MPW_Train_Maintenance__c testMpw = MPWTrainMaintenanceTriggerTest.createMPW();
        Device__c testDevice = MPWTrainMaintenanceTriggerTest.createDevice(testAcct.Id, testOpptyProgramId, testMpw.Id);
        
        test.startTest();
            Insert testMpw;
            testMpw.Customer_Tapeout_Date__c = date.today().addDays(5);
            testMpw.Geometry__c = '55nm';
            testMpw.Publish__c = True;
            testMpw.Active__c = True;
            update testMpw;
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }
}