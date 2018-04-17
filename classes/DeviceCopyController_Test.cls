/*
    Author: Zymark Ambat
    Description: This serves as the test class for the DeviceCopyController Class.
    History: 
        ZAmbat      02272013    - Code creation.
        ZAmbat      10102013    - updated code - added test for device revision.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false
        Vijay       12052014    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     03302015    - Refactoring test class.
  Devendra  10142015      - Updated to fix device validation error
*/
@isTest(SeeAllData=false)
public class DeviceCopyController_Test {
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
        fieldValueMap.put('Siebel_Account_ID__c','123123123123');

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
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
                
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }

    static Opportunity createOpportunity1(Id testAcctId) {
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
        
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
       
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICESP'); 
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Tapeout_Type__c','Single Product'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1'); 
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now()); 
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power'); 
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)'); 
        fieldValueMap.put('Geometry_Filter__c','0.10UM'); 
        fieldValueMap.put('PTRF_ID__c','test'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Fab__c','Fab 3'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        return DeviceDataFactory.createDevice(fieldValueMap); 
    }
    
    static void setCRMDIDSequenceValue() {
        // Set custom setting value
        CRMDID__c crmdid = CRMDID__c.getInstance('CRMDID_No');
        crmdid.CRMDID_No__c = 999;
        
        Update crmdid;
    }
    
    static testMethod void testDeviceClone1() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Successful insert
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        dcc.device.Name = 'TESTDEVICEZAIH12345678';
        dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
        dcc.save();
        
        List<Device__c> listDevice = [
            SELECT      Account__c
                        , Opportunity2__c
                        , Device_Base_Id__c
                        , CRMDID__c
            FROM        Device__c
            WHERE       Id = :dcc.device.Id
        ];
        
//        System.assertEquals(testAcctId, listDevice[0].Account__c);
//        System.assertEquals(testOpptyId, listDevice[0].Opportunity2__c);
//        System.assertEquals(listDevice[0].Device_Base_Id__c, listDevice[0].CRMDID__c.replace('.00', ''));
        
        dcc.cancel();
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone2() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Invalid originating device
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        testDevice.Siebel_Device_ID__c = null;
        //Update testDevice;
        
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        dcc.device.Name = 'TESTDEVICEZAIH12345678';
        dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
        dcc.save();
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone3() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Device Id already exists
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        dcc.device.Name = 'TESTDEVICEZAIH12345677';
        dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
        dcc.save();
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone4() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Device Id REGEX validation
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        Try {
            dcc.device.Name = 'testdevicezaih12345678';
            dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
            dcc.save();
        } Catch (Exception e) {
        }
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone5() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Geometry validation
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        Opportunity testOppty = DeviceCopyController_Test.createOpportunity1(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOppty.Id);
        
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        
        testOppty.Process_Geometry__c = null;
        testOppty.Process_Family__c = 'Generic / Nominal';
        //Update testOppty;
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        Try {
            dcc.device.Name = 'TESTDEVICE12345678';
            dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
            dcc.save();
        } Catch (Exception e) {
        }
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone6() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Process Family validation
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        Opportunity testOppty = DeviceCopyController_Test.createOpportunity1(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOppty.Id);
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = null;
        //Update testOppty;
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        Try {
            dcc.device.Name = 'TESTDEVICE12345678';
            dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
            dcc.save();
        } Catch (Exception e) {
        } 
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone7() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Successful insert
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        ApexPages.currentPage().getParameters().put('bId', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        dcc.device.Name = 'TESTDEVICEZAIH12345678';
        dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
        dcc.save();
        
        List<Device__c> listDevice = [
            SELECT      Account__c
                        , Opportunity2__c
                        , Device_Base_Id__c
                        , CRMDID__c
            FROM        Device__c
            WHERE       Id = :dcc.device.Id
        ];
        
//        System.assertEquals(testAcctId, listDevice[0].Account__c);
//       System.assertEquals(testOpptyId, listDevice[0].Opportunity2__c);
//        System.assertEquals(listDevice[0].Device_Base_Id__c, listDevice[0].CRMDID__c.replace('.00', ''));
        
        dcc.cancel();
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone8() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Successful insert
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        
        testDevice.Status__c = 'Inactive';
        //Update testDevice;
        
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        dcc.device.Name = 'TESTDEVICEZAIH12345678';
        dcc.device.Original_Forecasted_Tapeout_Date__c = System.today();
        dcc.save();
        
        test.stopTest();
    }
    
    static testMethod void testDeviceClone9() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        // Create dummy records for testing
        // Successful insert
        String testAcctId = getAccount('MYTEST ACCOUNT1').id;
        String testOpptyId = DeviceCopyController_Test.createOpportunity(testAcctId);
        String testOpptyProgramId = DeviceCopyController_Test.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
        Device__c testDevice = DeviceCopyController_Test.createDevice(testAcctId, testOpptyProgramId);
        system.AssertEquals('TESTDEVICESP', testDevice.Name);
        DeviceCopyController_Test.setCRMDIDSequenceValue();
        ApexPages.currentPage().getParameters().put('Id', testDevice.Id);
        ApexPages.currentPage().getParameters().put('mode', 'Revise');
        
        DeviceCopyController dcc = new DeviceCopyController();
        
        //dcc.device.Name = 'TESTDEVICEZAIH12345678';
        dcc.save();
        
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}