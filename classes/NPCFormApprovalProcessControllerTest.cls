/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormApprovalProcessController.
    History: 
        ZAmbat      02142014    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for refactoring of test class.
        Vijay       05012015    - updated existing test methods.
        SNune       23102015    - Fixed test class failure issues.
*/
@isTest
public class NPCFormApprovalProcessControllerTest {
    
     
    
    
         @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
 
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
     
        
        String testAcctId = createAccount();
        Contact contact = InternalDeviceTestUtil.createContact('Test Contact', 'Test Contact', testAcctId, 'test@test.com', 'Customers My Device Admin; Primary Account Admin', 
                                            'Design; Engineering; Quality; Procurement; Supply Chain; Legal', true, true);
        insert contact;
        test.startTest();
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = createDevice(testAcctId, testOpptyProgramId);
        //test.startTest();
        Device__c testDevice = DeviceUtilTest.createSPDevice(testAcctId, testOpptyProgramId);
        Insert testDevice;
        createNPCForm1(testAcctId, testDevice.Id);
        test.stoptest();
    
    }
    static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('testing901'); 
        
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Update testAcct;
        
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
    
    static Id createPortalUser(Id contactId) {
        User u = new User();
        u.Alias = 'Test1';
        u.Email = 'test1@test.com'; 
        u.EmailEncodingKey = 'UTF-8'; 
        u.LastName = 'LastName';
        u.LanguageLocaleKey = 'en_US'; 
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Portal Admin'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles'; 
        u.UserName = 'zTestUser123@test.com';
        u.Portal_Login__c = 'xyz';
        u.contactId = contactId;
        u.IsActive = true;
        u.CommunityNickname = 'zTestUser123';
        
        insert u;
        
        return u.Id;
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
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
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
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
   /* 
    static Device__c createDevice1(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345688';
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
        device.CRMDID__c = 'CDID0000001.01';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice2(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345699';
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
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice3(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345699';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 1';
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
        //device.Device_Mask_Set_Title__c = '';
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice4(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345699';
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
        //device.Device_Mask_Set_Title__c = '';
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice5(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345699';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 1';
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
        //device.Device_Mask_Set_Title__c = '';
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice6(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH22222222';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 3';
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
        device.CRMDID__c = 'CDID0000001.01';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        Insert device;
        
        return device;
    }
    */
    static Id createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        
        insert npc;
        
        return npc.Id;
    }
    
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm2(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST2';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.Reason_for_New_Part__c = 'New Probe Card Flow' ;
        npc.NPC_Form_Status__c = 'Pending Submission';
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm3(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.Originating_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST3';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 3';
        npc.Tapeout_Required__c = 'No';
        npc.NPC_Form_Status__c = 'Pending Submission';
        
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
    
    static void createOpportunityProgramTeamMembers(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
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
            o.Core_Team_Member__c = false;
            
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    
    static List<Opportunity_Program_Team_Member__c> createOpportunityProgramTeamMembers1(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT :pNo
        ];

        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<pNo; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            o.Team_Role__c = 'Field Application Engineer';
            o.Core_Team_Member__c = false;
            
            listOPTM.add(o);
        }
        
        insert listOPTM;
        
        return listOPTM;
    }
    
    static void createOpportunityProgramTeamMembers2(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 3')
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
            o.Core_Team_Member__c = false;
            
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    
    static testMethod void testNPCFormApprovalProcessController_10Approvers() {
        test.startTest();
        Opportunity_Program__c oppProgram = [Select Id From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
        New_Part_Creation_Form__c testNPC = [Select Id From New_Part_Creation_Form__c Where New_Part_ID__c = 'NPCTEST1' ];
        createOpportunityProgramTeamMembers(10, oppProgram.Id);
        test.stopTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.currentPage().getParameters().put('portal', 'portal');
            ApexPages.currentPage().getParameters().put('share', 'share');
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
        //test.stopTest();
    }
    
       
     static testMethod void testNPCFormApprovalProcessController_CSR3() {
       test.startTest();
       Account testAcct = getAccount('testing901'); 
       Opportunity_Program__c oppProgram = [Select Id From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
        createOpportunityProgramTeamMembers1(3, oppProgram.Id);
        
        User gfCSR = [
            SELECT    Id
            FROM      User
            WHERE     Profile.Name = 'GF CSR'
                      AND IsActive = true
            LIMIT 1
        ];
        
        AccountShare as1 = new AccountShare();
        as1.AccountAccessLevel = 'Edit';
        //as1.RowCause = 'Manual';
        as1.AccountId = testAcct.id;
        as1.UserOrGroupId = gfCSR.Id;
        as1.OpportunityAccessLevel = 'Edit';
        as1.CaseAccessLevel = 'Edit';
        insert as1;
        
          Device__c Device1 = [Select id from Device__c where Name ='TESTDEVICEZAIH12345677'];
          Device__Share ds = new Device__Share();
         ds.ParentId = Device1.id;
         ds.UserOrGroupId = gfCSR.id;
         ds.AccessLevel = 'Edit';
         ds.RowCause = 'Opportunity_Program_Team__c';
         insert ds;
        
        Opportunity_Program__Share ops = new Opportunity_Program__Share();
        ops.AccessLevel = 'Edit';
        ops.RowCause = 'Manual';
        ops.ParentId = oppProgram.Id;
        ops.UserOrGroupId = gfCSR.Id;
        insert ops;
        
        
            system.runAs(gfCSR) {
               // Device__c device1= createDevice1(account.Id, oppProgram.Id);
              // Device__c Device1 = [Select id from Device__c where Name ='TESTDEVICEZAIH12345677'];
                New_Part_Creation_Form__c testNPC = createNPCForm2(testAcct.Id, Device1.Id);
                PageReference pageRef = Page.NPCFormVF;
                Test.setCurrentPageReference(pageRef);
                ApexPages.currentPage().getParameters().put('id', testNPC.Id);
                ApexPages.currentPage().getParameters().put('portal', 'portal');
                NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
                
                n.submitNPCForm();
            }
        test.stopTest();
    }
   
    
    
    static testMethod void testNoMaskValidation() {
        //New_Part_Creation_Form__c testNPC = [Select Id From New_Part_Creation_Form__c Where New_Part_ID__c = 'NPCTEST1' ];
        test.startTest();
        Account account = [Select Id From Account Where Name = 'testing901'];
        Device__c device = [Select Id From Device__c Where Name = :'TESTDEVICEZAIH12345677'];
        
        //Opportunity_Program__c oppProgram = [Select Id From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
        Id testNPCId = createNPCForm(account.Id, device.Id);
        
         Id testNPCId1 = createNPCForm(account.Id, device.Id);
         
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPCId1);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
        test.stopTest();
    }
    
    
    static testMethod void testNPCFormApprovalWithNoApprovers() {
        test.startTest();
        Opportunity_Program__c oppProgram = [Select Id From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
        New_Part_Creation_Form__c testNPC = [Select Id From New_Part_Creation_Form__c Where New_Part_ID__c = 'NPCTEST1' ];
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testCancel(){
     test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.cancel();
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            } 
    
    static testMethod void testNPCFormFAB3Approver() {
        //New_Part_Creation_Form__c testNPC1 = [Select Id From New_Part_Creation_Form__c Where New_Part_ID__c = 'NPCTEST1' ];
        Test.startTest();
        Account account = [Select Id From Account Where Name = 'testing901'];
        Opportunity_Program__c oppProgram = [Select Id From Opportunity_Program__c Where Name = 'Test Opportunity Program'];
        createOpportunityProgramTeamMembers(1, oppProgram.Id);
        
         Device__c device = [Select Id From Device__c Where Name = :'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = createNPCForm2(account.Id, device.Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
        Test.stopTest();
    }        
}