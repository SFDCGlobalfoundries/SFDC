/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for YieldFeedbackInlineController.
    History: 
        ZAmbat      12262014    - Code creation.
*/

@isTest(SeeAllData = false)
public class YieldFeedbackInlineControllerTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static Id createAccount() {
         // Create Account
        Account testAcct = new Account();
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        return testAcct.Id;
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
    
    static Id createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Application__c','Others');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12345');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Base');
        
        return DeviceDataFactory.createDevice(fieldValueMap).id;
        
    }
    
    static List<Manufacturing_Lot__c> createManufacturingLot(Id accountId) {
        List<Manufacturing_Lot__c> listML = new List<Manufacturing_Lot__c>();
        for (integer i=1; i<=20; i++) {    
            Manufacturing_Lot__c m = new Manufacturing_Lot__c();
            m.Account_Name__c = accountId;
            m.Name = 'testManufacturingLotZ.' + i;
            m.Lot_Type__c = 'MLT' + i;
            m.Lot_Start_Date__c = datetime.now();
            m.Last_Ship_Date__c = date.today().addDays(50);
            m.Device_ID_MES__c = 'TESTMESDEVICE123Z';
            listML.add(m);
        }
        
        insert listML;
        return listML;
    }
    
    static void createYieldFeedback(Id accountId, Id deviceId, List<Manufacturing_Lot__c> listML) {
        List<Yield_Feedback__c> listYF = new List<Yield_Feedback__c>();
        for (Manufacturing_Lot__c l : listML) {
            Yield_Feedback__c y = new Yield_Feedback__c();
            y.Account__c = accountId;
            y.Device__c = deviceId;
            y.Manufacturing_Lot__c = l.Id;
            y.Fab__c = 'FAB 2';
            y.First_Time_Not_Right__c = 'Fab issue';
            y.Functional__c = 'Yes';
            y.Lot_Purpose__c = 'Proto Lot';
            y.Sort_Yield__c = 1;
            y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(3);
            listYF.add(y);
        }
        
        insert listYF;
    }
    
    static testMethod void testYieldFeedbackInlineController1() {
        string accountId = YieldFeedbackInlineControllerTest.createAccount();
        string opportunityId = YieldFeedbackInlineControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackInlineControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackInlineControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackInlineControllerTest.createYieldFeedback(accountId, deviceId, YieldFeedbackInlineControllerTest.createManufacturingLot(accountId));
        
        
            test.setCurrentPageReference(new PageReference('Page.YieldFeedbackInlineAccountVF'));
            System.currentPageReference().getParameters().put('id', accountId);
            YieldFeedbackInlineController y = new YieldFeedbackInlineController();
            y.getRecords();
            y.getHasPrevious();
            y.getHasNext();
            y.last();
            y.first();
            y.next();
            y.previous();
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackInlineController2() {
        string accountId = YieldFeedbackInlineControllerTest.createAccount();
        string opportunityId = YieldFeedbackInlineControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackInlineControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackInlineControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackInlineControllerTest.createYieldFeedback(accountId, deviceId, YieldFeedbackInlineControllerTest.createManufacturingLot(accountId));
        
        
            test.setCurrentPageReference(new PageReference('Page.YieldFeedbackInlineDeviceVF'));
            System.currentPageReference().getParameters().put('id', deviceId);
            YieldFeedbackInlineController y = new YieldFeedbackInlineController();
            y.getHasPrevious();
            y.getHasNext();
            y.last();
            y.first();
            y.next();
            y.previous();
        test.stopTest();
    }
}