/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for YieldFeedbackRemindersBatch.
    History: 
        ZAmbat      12292014    - Code creation.
*/

@isTest(SeeAllData = true)
public class YieldFeedbackRemindersBatchTest {
    static Id createAccount() {
        Account testAcct = new Account();
        testAcct.Name = 'Test Account ZA';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';      
        testAcct.Short_Name__c = 'TestAcct';
        
        insert testAcct;
        return testAcct.Id;
    }
    
    static void createAccountTeamProxy(Id accountId) {
        List<Account_Team_Proxy__c> listATP = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c atpCE = new Account_Team_Proxy__c();
        atpCE.Account__c = accountId;
        atpCE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF CE' AND Fab_Assigned__c in ('FAB 2') and IsActive = true LIMIT 1].Id;
        atpCE.Account_Access__c = 'Read/Write';
        atpCE.Opportunity_Access__c = 'Read/Write';
        atpCE.Team_Role__c = 'Customer Engineer';
        atpCE.Fab_Assignment__c = 'FAB 2';
        listATP.add(atpCE);
        Account_Team_Proxy__c atpFE = new Account_Team_Proxy__c();
        atpFE.Account__c = accountId;
        atpFE.User__c = [SELECT Id FROM User WHERE Profile.Name = 'GF FAE/FTS' AND IsActive = true LIMIT 1].Id;
        atpFE.Account_Access__c = 'Read/Write';
        atpFE.Opportunity_Access__c = 'Read/Write';
        atpFE.Team_Role__c = 'Field Application Engineer';
        atpFE.Fab_Assignment__c = 'FAB 2';
        listATP.add(atpFE);
        
        insert listATP;
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
            m.Name = 'testManufacturingLotZ' + i;
            m.Lot_Start_Date__c=date.today();
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
            }
            m.Lot_Start_Date__c = datetime.now();
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
        
        insert listYF;
                          
    }
    
    static testMethod void testYieldFeedbackRemindersBatch1() {
        string accountId = YieldFeedbackRemindersBatchTest.createAccount();
        YieldFeedbackRemindersBatchTest.createAccountTeamProxy(accountId);
        string opportunityId = YieldFeedbackRemindersBatchTest.createOpportunity(accountId);
        string opptyProgramId = YieldFeedbackRemindersBatchTest.createOpportunityProgram(accountId, opportunityId);
        //string deviceId = YieldFeedbackRemindersBatchTest.createDevice(accountId, opptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accountId,MSTId);
        
        test.startTest();
        string deviceId = DeviceUtilTest.createCustomerMPWDevice(accountId, opptyProgramId);
        
        YieldFeedbackRemindersBatchTest.createYieldFeedback(accountId, deviceId, YieldFeedbackRemindersBatchTest.createManufacturingLot(accountId));
        
       
            database.executeBatch(new YieldFeedbackRemindersBatch());
        test.stopTest();
    }
    
    static testMethod void testYieldFeedbackRemindersBatchScheduler() {
        test.startTest();
            YieldFeedbackRemindersBatchScheduler d = new YieldFeedbackRemindersBatchScheduler();
            String s = '0 0 23 * * ?';
            system.schedule('YieldFeedbackRemindersBatchScheduler1', s, d);
        test.stopTest();
    }
}