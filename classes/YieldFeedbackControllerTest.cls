/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for YieldFeedbackController.
    History: 
        ZAmbat      12242014    - Code creation.
*/

@isTest(SeeAllData = false)

 
public class YieldFeedbackControllerTest {

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
    
    static void createManufacturingLot(Id accountId) {
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
    }
    
    static testMethod void testYieldFeedbackController1() {
        string accountId = YieldFeedbackControllerTest.createAccount();
        string opportunityId = YieldFeedbackControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackControllerTest.createManufacturingLot(accountId);
        
            test.setCurrentPageReference(new PageReference('Page.YieldFeedbackControllerVF'));
            System.currentPageReference().getParameters().put('accountId', accountId);
            YieldFeedbackController y = new YieldFeedbackController();
            y.yieldFeedback.Device__c = deviceId;
            y.searchKey = 'testManufacturingLotZ';
            y.searchLots();
            y.getHasPreviousAR();
            y.getHasNextAR();
            y.nextAR();
            y.previousAR();
            y.lastAR();
            y.firstAR();
            y.availableYFRecords.get(1)[0].isSelected = true;
            y.availableYFRecords.get(1)[1].isSelected = true;
            y.availableYFRecords.get(1)[2].isSelected = true;
            y.availableYFRecords.get(1)[3].isSelected = true;
            y.availableYFRecords.get(1)[4].isSelected = true;
            y.availableYFRecords.get(2)[0].isSelected = true;
            y.availableYFRecords.get(2)[1].isSelected = true;
            y.availableYFRecords.get(2)[2].isSelected = true;
            y.save();
            y.getHasPreviousSR();
            y.getHasNextSR();
            y.nextSR();
            y.previousSR();
            y.lastSR();
            y.firstSR();
            y.backToPage();
            y.getSelectedLots();
            y.getAvailableLots();
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackController2() {
        string accountId = YieldFeedbackControllerTest.createAccount();
        string opportunityId = YieldFeedbackControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackControllerTest.createManufacturingLot(accountId);
        
            test.setCurrentPageReference(new PageReference('Page.YieldFeedbackControllerVF'));
            System.currentPageReference().getParameters().put('deviceId', deviceId);
            YieldFeedbackController y = new YieldFeedbackController();
            y.yieldFeedback.Device__c = deviceId;
            y.searchKey = 'testManufacturingLotZ';
            y.searchLots();
            y.backToPage();
    }
    
    static testMethod void testYieldFeedbackController3() {
        string accountId = YieldFeedbackControllerTest.createAccount();
        string opportunityId = YieldFeedbackControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackControllerTest.createManufacturingLot(accountId);
        
            test.setCurrentPageReference(new PageReference('Page.YieldFeedbackControllerVF'));
            System.currentPageReference().getParameters().put('accountId', accountId);
            YieldFeedbackController y = new YieldFeedbackController();
            y.searchKey = 'testManufacturingLotZ';
            y.searchLots();
            y.availableYFRecords.get(1)[0].isSelected = true;
            y.save();
            y.tabSelectedInfo = 'manualDevice';
            y.save(); 
            y.yieldFeedback.Manual_Device__c = 'TESTMANUALDEVICEZ1.1';
            y.save(); 
            y.yieldFeedback.Tapeout_Type__c = 'Retrofit';
            y.save();
            y.yieldFeedback.Fab__c = 'FAB 2';
            y.save();
        test.stopTest();    
    }
    
    static testMethod void testYieldFeedbackController4() {
        string accountId = YieldFeedbackControllerTest.createAccount();
        string opportunityId = YieldFeedbackControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackControllerTest.createManufacturingLot(accountId);
        
        User ceUser = [
            SELECT    Id
            FROM      User
            WHERE     Profile.Name = 'GF CE'
                      AND IsActive = true
            LIMIT 1
        ];
        
            system.runAs(ceUser) {
                test.setCurrentPageReference(new PageReference('Page.YieldFeedbackControllerVF'));
                System.currentPageReference().getParameters().put('accountId', accountId);
                YieldFeedbackController y = new YieldFeedbackController();
            }
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackController5() {
        string accountId = YieldFeedbackControllerTest.createAccount();
        string opportunityId = YieldFeedbackControllerTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackControllerTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackControllerTest.createDevice(accountId, opptyProgramId);
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        YieldFeedbackControllerTest.createManufacturingLot(accountId);
        
        User ceUser = [
            SELECT    Id
            FROM      User
            WHERE     Profile.Name = 'GF FAE/FTS'
                      AND IsActive = true
            LIMIT 1
        ];
        
            system.runAs(ceUser) {
                test.setCurrentPageReference(new PageReference('Page.YieldFeedbackControllerVF'));
                System.currentPageReference().getParameters().put('accountId', accountId);
              //  YieldFeedbackController y = new YieldFeedbackController();
            }
        test.stopTest();
    }
}