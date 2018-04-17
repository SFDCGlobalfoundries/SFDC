/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for DeviceYieldFeedbackBatch.
    History: 
        ZAmbat      12302014    - Code creation.
*/

@isTest(SeeAllData = false)
public class DeviceYieldFeedbackBatchTest {
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
    
    Public static Id createOpportunity(Id testAcctId) {
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
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12345';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.End_Application__c = 'Body';
        //device.Process_Technology_2__c = testPTId;
        insert device;
        return device;
    }
    */
    static List<Manufacturing_Lot__c> createManufacturingLot(Id accountId) {
        List<Manufacturing_Lot__c> listML = new List<Manufacturing_Lot__c>();
        for (integer i=1; i<=21; i++) {    
            Manufacturing_Lot__c m = new Manufacturing_Lot__c();
            m.Account_Name__c = accountId;
            m.Name = 'testManufacturingLotZ.' + i;
            if (i <= 5) {
                m.Lot_Type__c = 'QD' + i;
                m.Last_Ship_Date__c = date.today().addDays(-3);
            } else if (i > 5 && i <= 10) {
                m.Lot_Type__c = 'QF1D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 10 && i <= 15) {
                m.Lot_Type__c = 'QF15D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 15 && i <= 20) {
                m.Lot_Type__c = 'QF30D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 20) {
                m.Lot_Type__c = 'ABC' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            }
            m.Lot_Start_Date__c = datetime.now();
            listML.add(m);
        }
        
        insert listML;
        return listML;
    }
    
    static List<Yield_Feedback__c> createYieldFeedback(Id accountId, Id deviceId, List<Manufacturing_Lot__c> listML) {
        List<Yield_Feedback__c> listYF = new List<Yield_Feedback__c>();
        for (Manufacturing_Lot__c l : listML) {
            if (l.Lot_Type__c.startsWith('QD') || l.Lot_Type__c.startsWith('QF')) {
                Yield_Feedback__c y = new Yield_Feedback__c();
                y.Account__c = accountId;
                y.Device__c = deviceId;
                y.Manufacturing_Lot__c = l.Id;
                y.Fab__c = 'FAB 2';
                y.First_Time_Not_Right__c = 'Fab issue';
                y.Functional__c = 'Yes';
                y.Lot_Purpose__c = 'Proto Lot';
                y.Sort_Yield__c = 1;
                if (l.Lot_Type__c.startsWith('QD')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today();
                } else if (l.Lot_Type__c.startsWith('QF1D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(1);
                } else if (l.Lot_Type__c.startsWith('QF15D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(15);
                } else if (l.Lot_Type__c.startsWith('QF30D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(30);
                }
                listYF.add(y);
            }
        }
        
        insert listYF;
        return listYF;
    }
    
    static testMethod void testYieldFeedbackRemindersBatch1() {
        string accountId = getAccount('MYTEST ACCOUNT1').id;
        string opportunityId = DeviceYieldFeedbackBatchTest.createOpportunity(accountId);
        string opptyProgramId = DeviceYieldFeedbackBatchTest.createOpportunityProgram(accountId, opportunityId);
        //Device__c device = DeviceYieldFeedbackBatchTest.createDevice(accountId, opptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        test.startTest();
        Device__c device = DeviceUtilTest.createCustomerMPWDevice2(accountId, opptyProgramId);
        List<Yield_Feedback__c> listYF = DeviceYieldFeedbackBatchTest.createYieldFeedback(accountId, device.Id, DeviceYieldFeedbackBatchTest.createManufacturingLot(accountId));
        
        
            device.Proto_Lot_Start_ID__c = 'testManufacturingLotZ.21';
            update device;
            database.executeBatch(new DeviceYieldFeedbackBatch());
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackRemindersBatch2() {
        string accountId = getAccount('MYTEST ACCOUNT1').id;
        string opportunityId = DeviceYieldFeedbackBatchTest.createOpportunity(accountId);
        string opptyProgramId = DeviceYieldFeedbackBatchTest.createOpportunityProgram(accountId, opportunityId);
        //Device__c device = DeviceYieldFeedbackBatchTest.createDevice(accountId, opptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        test.startTest();
        Device__c device = DeviceUtilTest.createCustomerMPWDevice2(accountId, opptyProgramId);
        List<Yield_Feedback__c> listYF = DeviceYieldFeedbackBatchTest.createYieldFeedback(accountId, device.Id, DeviceYieldFeedbackBatchTest.createManufacturingLot(accountId));
        
        
            device.Proto_Lot_Start_ID__c = 'testManufacturingLotZ.20';
            update device;
            database.executeBatch(new DeviceYieldFeedbackBatch());
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackRemindersBatch3() {
        string accountId = getAccount('MYTEST ACCOUNT1').id;
        string opportunityId = DeviceYieldFeedbackBatchTest.createOpportunity(accountId);
        string opptyProgramId = DeviceYieldFeedbackBatchTest.createOpportunityProgram(accountId, opportunityId);
        //Device__c device = DeviceYieldFeedbackBatchTest.createDevice(accountId, opptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        test.startTest();
        Device__c device = DeviceUtilTest.createCustomerMPWDevice2(accountId, opptyProgramId);
        DeviceYieldFeedbackBatchTest.createManufacturingLot(accountId);
        
        
            device.Proto_Lot_Start_ID__c = 'testManufacturingLotZ.21';
            update device;
            database.executeBatch(new DeviceYieldFeedbackBatch());
        test.stopTest();
    }
    
    static testMethod void testDeviceYieldFeedbackBatchScheduler() {
        test.startTest();
            DeviceYieldFeedbackBatchScheduler d = new DeviceYieldFeedbackBatchScheduler();
            String s = '0 0 23 * * ?';
            system.schedule('DeviceYieldFeedbackBatchScheduler1', s, d);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}