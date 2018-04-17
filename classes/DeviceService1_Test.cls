@isTest(SeeAllData=false)
public class DeviceService1_Test {
    
        
    @testSetup static void loadCustomSettings(){
        DataUtilTest.loadEnvironmentVariables();
        Error_Codes__c erroCode = new Error_Codes__c(Name='PTRF_NUMBER_NOT_FOUND',Message__c='Test');
        Database.insert(erroCode ,false);
        
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
        fieldValueMap.put('Siebel_Account_ID__c','123123123123');
        
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        String opptyId = createOpportunity(acc.Id);
        String oppProgramId = createOpportunityProgram(acc.Id, opptyId);
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
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
         
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
    
    
    static testMethod void testNewDevice1(){
        Test.startTest();
        DeviceService.DeviceInsertStruct objInsert = new DeviceService.DeviceInsertStruct();
        DeviceService.newDevice(objInsert);
        objInsert.sDeviceID = '111111111';
        DeviceService.newDevice(objInsert);
        objInsert.sCRMDID = 'CDID555555.00';
        DeviceService.newDevice(objInsert);
        objInsert.sStage = 'Design In';
        DeviceService.newDevice(objInsert);
        objInsert.sStatus = 'Active';
        DeviceService.newDevice(objInsert);
        objInsert.sSiebelAccountID = '22222222';
        DeviceService.newDevice(objInsert);
        objInsert.sSiebelOptyID = '3333333';
        DeviceService.newDevice(objInsert);
        objInsert.sCRMDID = 'CDIDABCDEFG.00';
        DeviceService.newDevice(objInsert);
        Test.stopTest();
    }
    
    static testMethod void testNewDevice3(){
        Test.startTest();
        DeviceService.DeviceInsertStruct objInsert = new DeviceService.DeviceInsertStruct();
        objInsert.sDeviceID = 'TestDevice3';
        objInsert.sCRMDID = 'CDID9999999.00';
        objInsert.sStage = 'Design In';
        objInsert.sStatus = 'Active';
        objInsert.sSiebelAccountID = '123123123123';
        objInsert.sSiebelOptyID = '123123123123';
        objInsert.sDeviceType = 'Revision';
        objInsert.sTapeoutType = 'Customer MPW';
        objInsert.sFab = 'FAB 3';
        objInsert.sConfidenceLvlTapeout = '50';
        objInsert.sEndApplication = 'Media';
        objInsert.sSemiConductorDevice = 'Analog Amplifier';
        objInsert.dtOriginalTapeoutDate =  System.today() + 5;
        objInsert.sMarketSegment = 'Mobility';
        objInsert.sDeviceSourcing = 'First Source';
        objInsert.sGSOPAssignmentTapeoutPlan = 'No';
        DeviceService.newDevice(objInsert);
        
        Test.stopTest();
    }
    
     static testMethod void testUpdateDevice(){
        Test.startTest();
        DeviceService.DeviceUpdateStruct DeviceUpdateStruct = new DeviceService.DeviceUpdateStruct();
        DeviceService.updateDevice(DeviceUpdateStruct);
        Test.stopTest();
    } 
}