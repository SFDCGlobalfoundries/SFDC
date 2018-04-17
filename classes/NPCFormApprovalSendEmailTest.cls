/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPC Form.
    History: 
        ZAmbat      10302013    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*/
@isTest(SeeAllData=false)
private class NPCFormApprovalSendEmailTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        
        //string acctId = DeviceUtilTest.createAccount();
         Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'Test Account');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept1');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        string acctId = AccountDataFactory.createAccount(fieldValueMap).id;
        
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Device__c Device = DeviceUtilTest.createSPDevice(acctId,opptyProgramId);
        Insert Device;
        Test.stopTest();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acctId;
        update env;
    }
    
    static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
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
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct1';
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Insert testAcct;
        
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Insert testOppty;
        
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
    
    static Id createUser(){        
        HCM_Employee__c hcmEmployee = new HCM_Employee__c();
        hcmEmployee.Login_ID__c = 'test1HCM';
        hcmEmployee.Last_Name__c = 'TestGFceUser';
        hcmEmployee.First_Name__c = 'Test1';
        hcmEmployee.Department_Name__c =  'IT';
        hcmEmployee.Email_Address__c = 'testceUser1@test.com';
        hcmEmployee.Job_Title__c = 'TestTitle1';
        hcmEmployee.Phone_Number__c =  '999999345';
        hcmEmployee.Employee_ID__c = '654321';
        insert hcmEmployee;
        
        Profile ceProfile = [select id from Profile  where Name like '%GF CE%' LIMIT 1];
        User usr1 = new User();           
        usr1.Alias= 'GFce';
        usr1.Email= 'testGFceUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.LastName = 'TestGFceUser';
        usr1.FirstName = 'Testce';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = ceProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testGFceUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 2'; 
        usr1.IsActive = true;
        usr1.FederationIdentifier = '654321';
        usr1.ManagerId = UserInfo.getUserId();
        insert(usr1);
        
        return usr1.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
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
        device.End_Application__c = 'test';
        
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice1(Id testAcctId, Id testOpptyProgramId, id npcId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH123456777';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Retrofit';
        device.Device_Type__c = 'Retrofit';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'test';
        device.NPC_Form__c = npcId;
        
        Insert device;
        
        return device;
    }
    
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.Comments__c = 'test';
        
        /* Profile p = [SELECT    Id
                     FROM      Profile
                     WHERE     Name LIKE 'GF%'
                     LIMIT     1];
        
        npc.Approver_1__c = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId = :p.Id
                        AND ManagerId != null
                        AND Id != :UserInfo.getUserId()
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT 1
        ].Id; */
        
        npc.Approver_1__c = NPCFormApprovalSendEmailTest.createUser();
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.Comments__c = 'test';
        npc.Reason_for_New_Part__c = 'Fab to Fab Transfer';
        npc.Tapeout_Required__c = 'No';
        
        /* Profile p = [SELECT    Id
                     FROM      Profile
                     WHERE     Name LIKE 'GF%'
                     LIMIT     1];
        
        npc.Approver_1__c = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId = :p.Id
                        AND ManagerId != null
                        AND Id != :UserInfo.getUserId()
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT 1
        ].Id; */
        
        npc.Approver_1__c = NPCFormApprovalSendEmailTest.createUser();
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCFormBatch(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.NPC_Form_Status__c = 'Not Executed';
        npc.Comments__c = 'test';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-3);

        insert npc;
        
        return npc;
    }
    
    static void createOpportunityProgramTeamMembers(Id opportunityProgramId) {
        Set<Id> profileIds = new Set<Id>();
        for (Profile p : [SELECT    Id
                          FROM      Profile
                          WHERE     Name LIKE 'GF%']) {
            profileIds.add(p.Id);               
        }
        
        List<User> listUser = [
            SELECT      Id, Fab_Assigned__c
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId IN :profileIds
                        AND Id != :UserInfo.getUserId()
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT       3
        ];
        
        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<3; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            if (i == 0) {
                o.Team_Role__c = 'Field Application Engineer';
            } else if (i == 1) {    
                o.Team_Role__c = 'Customer Engineer';
            } else if (i == 2) {
                o.Team_Role__c = 'Customer Service';
            } 
            
            listOPTM.add(o); 
        }
        
        insert listOPTM;
    }
    
    static testMethod void runTest1A() {
        //DataUtilTest.loadEnvironmentVariables();
        //String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        //String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        //String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
       // Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();
            testNPC.NPC_Form_Status__c = 'Pending CE Approval';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'Pending Resubmission';
            update testNPC;
        test.stopTest();
    }
    
    static testMethod void runTest1B() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];        
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();
            testNPC.NPC_Form_Status__c = 'Pending CE Approval';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'In Execution';
            //update testNPC;
            
           // NPCFormApprovalSendEmail.generateNPCDeviceLink(testNPC.Id);
            
            testNPC.NPC_Form_Status__c = 'Not Executed';
            update testNPC;
        test.stopTest();
    }
    
    static testMethod void runTest1C() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];        
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();
            testNPC.NPC_Form_Status__c = 'Pending CE Approval';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'In Execution';
           // update testNPC;
            
            testNPC.NPC_Form_Status__c = 'Executed';
            update testNPC;
        test.stopTest();
    }
    
    static testMethod void runTest1D() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();            
            testNPC.Send_Reject_Email_Flag__c = true;
            testNPC.NPC_Form_Status__c = 'Not Executed';
            update testNPC;
        test.stopTest();
    }
    
    static testMethod void runTest1E() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();            
            testNPC.NPC_Form_Status__c = 'In Execution';
            update testNPC;
            testNPC.Send_Reject_Email_Flag__c = true;
            testNPC.NPC_Form_Status__c = 'Pending Resubmission';
            
            List<User> listUser = [
                SELECT      Id
                FROM        User
                WHERE       IsActive = true
                            AND Profile.Name LIKE 'GF%'
                LIMIT 3
            ];
            
            testNPC.PIYE_Approver_1__C = listUser[0].Id;
            testNPC.PIYE_Approver_2__C = listUser[1].Id;
            testNPC.PIYE_Approver_3__C = listUser[2].Id;
            
            update testNPC;
        test.stopTest();
    }
    
    static testMethod void runTest1F() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];        
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();            
            testNPC.NPC_Form_Status__c = 'In Execution';
            update testNPC;
            testNPC.Send_Recall_Email_Flag__c = true;
            testNPC.NPC_Form_Status__c = 'Pending Resubmission';
            update testNPC;
            
            NPCFormApprovalSendEmail.EmailComponents e = new NPCFormApprovalSendEmail.EmailComponents(testNPC);
            e.addMasks(new List<Mask__c>());
        test.stopTest();
    }
    
     static testMethod void runTest1G() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormApprovalSendEmailTest.createAccount();
        String testOpptyId = NPCFormApprovalSendEmailTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormApprovalSendEmailTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormApprovalSendEmailTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];        
        New_Part_Creation_Form__c testNPC = NPCFormApprovalSendEmailTest.createNPCForm(testAcctId.id, testDevice.Id);
        NPCFormApprovalSendEmailTest.createOpportunityProgramTeamMembers(testOpptyProgramId.id);
        
        test.startTest();
            testNPC.NPC_Form_Status__c = 'Pending CE Approval';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'Pending PID Reassignment';
            testNPC.Reason_for_New_Part__c = 'Change in PID';
            //update testNPC;
        test.stopTest();
    }
    
}