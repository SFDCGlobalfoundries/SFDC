/*
    Author: Ariz Solito
    Description: Apex test class for VCIDMatchingBatch
    History: 
        Asolito     07/23/2013    - Code creation.
        Sunil Arora 01092014    - Added Department__c='Design' into contact object.    
*/
@isTest(SeeAllData=false)    
public with sharing class VCIDMatchingBatch_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    static Id createAccount() {
        Account testAcct = new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT101');            
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        
       
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        
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
    
    static Id createDevice(Id testAcctId, Id testOpptyProgramId) {
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
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.End_Application__c = 'Body';
        
        insert device;
        return device.Id;
    }
    
    static testMethod void testClass(){  
        string accountId = VCIDMatchingBatch_Test.createAccount();
        string opportunityId = VCIDMatchingBatch_Test.createOpportunity(accountId);
        string opptyProgramId = VCIDMatchingBatch_Test.createOpportunityProgram(accountId, opportunityId);
        Test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        
        Process__c pr = new Process__c(
            name = 'test process',
            PID_number__c = '12345',
            process_technology__c = 'tech1'
        );
        insert pr;
        
        IP_Declaration_Form__c dec = new IP_Declaration_Form__c(
            //device__c = dev.id,
            device__c = deviceId,
            status__c = 'Pending Reconciliation'        
        );
        insert dec;  
        
        String query = 'SELECT id '+
                       '   FROM IP_Declaration_Form__c '+
                       '   WHERE status__c = \'Pending Reconciliation\' '+
                       '   AND id = \''+ dec.id +'\'';
       
        VCIDMatchingBatch job = new VCIDMatchingBatch();
        
        Database.executebatch(job,10);               
        Test.stopTest();
    }                                   
    private static Account getAccount(string AccountName)
    {
        Account acc = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acc;
    }                             
}