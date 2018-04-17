/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormReadOnlyController.
    History: 
        ZAmbat      11282013    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
private class NPCFormReadOnlyControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        Test.startTest();
        Insert Device;
        Test.stopTest();
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
        testAcct.Name = 'Test Account';
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
        testAcct.Short_Name__c = 'TestAcct';
        
        Insert testAcct;
 
        return testAcct.Id;
    }
    
    static Id createContact(Id acctId) {
        Contact c = new Contact();
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        c.AccountId = acctId;
        c.Email = 'test@test.com';
        c.Department__c = 'TestDepartment';
        
        insert c;
        
        return c.Id;
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
    
    static Device__c createDevice1(Id testAcctId, Id testOpptyProgramId) {
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
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice2(Id testAcctId, Id testOpptyProgramId, Id testNPCId) {
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
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Retrofit';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000002.00';
        device.Device_Type__c = 'Retrofit';
        device.NPC_Form__c = testNPCId;
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
    
   static Device__c createDevice3(Id testAcctId, Id testOpptyProgramId, Id testNPCId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEJACK123321';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Tapeout';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '123456756';
        device.Tapeout_Type__c = 'Retrofit';
        device.PLM_Device_ID__c = 'ANBQP60ACO8-U02';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000004.03';
        device.Device_Type__c = 'Retrofit';
        device.NPC_Form__c = testNPCId;
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
    
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        User u = [
            SELECT      Id
            FROM        User
            WHERE       Profile.Name = 'GF CE'
                        AND IsActive = true
            LIMIT 1
        ];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        User u = [
            SELECT      Id
            FROM        User
            WHERE       Profile.Name = 'GF CE'
                        AND IsActive = true
            LIMIT 1
        ];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.Reason_for_New_Part__c = 'Retrofit + Add ROM Code';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        npc.Comments__c='not satisfied';//added by sunita
        insert npc;
        
        return npc;
    }
    
    static Id createNPCMasks(Id npcId) {
        Mask__c m = new Mask__c();
        m.New_Part_Creation_Form__c = npcId;
        m.Layer__c = 'TestLayer';
        m.Modified_Mask__c = 'TestLayerMask';
        m.Original_Mask__c = 'TestLayerMask';
        
        insert m;
        
        return m.Id;
    }
    
    static Id createAttachment(Id npcId) {
        Attachment a = new Attachment();
        a.ParentId = npcId;
        a.Body = blob.valueOf('Test');
        a.Name = 'Test';
        
        insert a;
        
        return a.Id;
    }
    
    static void createOpportunityProgramTeamMembers(integer pNo, Id opportunityProgramId) {
        Set<Id> profileIds = new Set<Id>();
        for (Profile p : [SELECT    Id
                          FROM      Profile
                          WHERE     Name LIKE 'GF%']) {
            profileIds.add(p.Id);               
        }
        
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId IN :profileIds
            LIMIT :pNo
        ];

        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<pNo; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            o.Team_Role__c = 'Customer Engineer';
            
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    
    static testMethod void runTest1() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        test.startTest();
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        
        testDevice.NPC_Form__c = testNPC.id;
        update testDevice;
        
        String testMask = NPCFormReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        String testAttachment = NPCFormReadOnlyControllerTest.createAttachment(testNPC.Id);
        NPCFormReadOnlyControllerTest.createOpportunityProgramTeamMembers(1, testOpptyProgramId.id);
        
        
            PageReference pageRef = Page.NPCFormReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormReadOnlyController npc = new NPCFormReadOnlyController(sc);
            npc.submitNPC();
        test.stopTest();
    }
    
    static testMethod void runTest2() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        test.startTest();

        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        String testMask = NPCFormReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        String testAttachment = NPCFormReadOnlyControllerTest.createAttachment(testNPC.Id);
       // Device__c testDevice2 = NPCFormReadOnlyControllerTest.createDevice2(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
        
                    
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            req1.setComments('Reject request.');//sunita

            Approval.ProcessResult result1 = Approval.process(req1);   
            System.assert(result1.isSuccess());
            
            PageReference pageRef = Page.NPCFormReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormReadOnlyController npc = new NPCFormReadOnlyController(sc);
            
            npc.recallNPC();
            npc.cloneNPC();
            
        test.stopTest();
    }
    
    static testMethod void runTest3() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        test.startTest();

        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        String testMask = NPCFormReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        String testAttachment = NPCFormReadOnlyControllerTest.createAttachment(testNPC.Id);
      //  Device__c testDevice2 = NPCFormReadOnlyControllerTest.createDevice2(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
        NPCFormReadOnlyControllerTest.createOpportunityProgramTeamMembers(1, testOpptyProgramId.id);
        
                    PageReference pageRef = Page.NPCFormReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormReadOnlyController npc = new NPCFormReadOnlyController(sc);
            npc.cancelNPC();
        test.stopTest();
    }
    
    static testMethod void runTest4() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
         test.startTest();

        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        String testMask = NPCFormReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        String testAttachment = NPCFormReadOnlyControllerTest.createAttachment(testNPC.Id);
       // Device__c testDevice2 = NPCFormReadOnlyControllerTest.createDevice2(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
        
                   PageReference pageRef = Page.NPCFormReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.currentPage().getHeaders().put('host', 'test');
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormReadOnlyController npc = new NPCFormReadOnlyController(sc);
            npc.checkInstance();
            npc.editNPC();
            npc.checkNPCStatus();
        test.stopTest();
    }
    
    static testMethod void runTest5() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        test.startTest();

        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormReadOnlyControllerTest.createNPCForm1(testAcctId.id, testDevice.Id);
        String testMask = NPCFormReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        String testAttachment = NPCFormReadOnlyControllerTest.createAttachment(testNPC.Id);
        //Device__c testDevice2 = NPCFormReadOnlyControllerTest.createDevice3(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
        NPCFormReadOnlyControllerTest.createOpportunityProgramTeamMembers(1, testOpptyProgramId.id);
        
                    PageReference pageRef = Page.NPCFormReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormReadOnlyController npc = new NPCFormReadOnlyController(sc);
            npc.cancelNPC();
            npc.getTypes();
        test.stopTest();
    }
}