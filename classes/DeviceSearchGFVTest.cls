/*
    Author: Zymark Ambat
    Description: This serves as the Test class for DeviceSearchGFV.
    History: 
        ZAmbat      05282014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
*/
@isTest(SeeAllData=false)
public class DeviceSearchGFVTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Test.startTest();
        Account testAcct1 = getAccount('MYTEST ACCOUNT1');
        Account testAcct2 = getAccount('MYTEST ACCOUNT2');
        testAcct2.ParentId = testAcct1.id;
        update testAcct2;        
        String testOpptyId = DeviceSearchGFVTest.createOpportunity(testAcct2.Id);
        String testOpptyProgramId = DeviceSearchGFVTest.createOpportunityProgram(testAcct2.Id, testOpptyId);
        Test.stopTest();
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
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    /*static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12345';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
       

        Insert device;
        
        return device;
    }*/
    
    static testMethod void testDeviceSearchGFV1() {
        Account testAcct1 = getAccount('MYTEST ACCOUNT1');
        Account testAcct2 = getAccount('MYTEST ACCOUNT2');
        //testAcct2.ParentId = testAcct1.id;
        //update testAcct2;

         string testOpptyProgramId  = [Select Id, Name from Opportunity_Program__c where Name ='Test Opportunity Program'].Id;                       
        //String testOpptyId = DeviceSearchGFVTest.createOpportunity(testAcct2.Id);
        //String testOpptyProgramId = DeviceSearchGFVTest.createOpportunityProgram(testAcct2.Id, testOpptyId);
        //Device__c testDevice = DeviceSearchGFVTest.createDevice(testAcct2.Id, testOpptyProgramId);
         test.startTest(); 
        
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcct2.Id,MSTId);
         Id testDevice = DeviceUtilTest.createCustomerMPWDevice(testAcct2.Id, testOpptyProgramId);    
         DeviceSearchGFV.retrieveDevices(testAcct2.Id, 'TESTDEVICEZAIH');
        test.stopTest();
    }
    
    static testMethod void testDeviceSearchGFV2() {
        Account testAcct1 = getAccount('MYTEST ACCOUNT1');
        Account testAcct2 = getAccount('MYTEST ACCOUNT2');
        //testAcct2.ParentId = testAcct1.id;
       // update testAcct2;
        
        //String testOpptyId = DeviceSearchGFVTest.createOpportunity(testAcct1.Id);
        //String testOpptyProgramId = DeviceSearchGFVTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        //Device__c testDevice = DeviceSearchGFVTest.createDevice(testAcct1.Id, testOpptyProgramId);
         string testOpptyProgramId  = [Select Id, Name from Opportunity_Program__c where Name ='Test Opportunity Program'].Id;       
        test.startTest();
            String MSTId = DeviceUtilTest.createMaskSetTtitle();
            string MSTAccId = DeviceUtilTest.createMSTAccount(testAcct1.Id,MSTId);
            Id testDevice = DeviceUtilTest.createCustomerMPWDevice(testAcct1.Id, testOpptyProgramId); 
            DeviceSearchGFV.retrieveDevices(testAcct1.Id, 'TESTDEVICEZAIH');
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}