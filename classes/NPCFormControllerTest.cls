/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormController.
    History: 
        ZAmbat      02142014    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        Vijay       12052014    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 'Design In' directly and set the Device mandatory fields.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
        SNune       12012015    - Updated code coverage
*/ 
@isTest(SeeAllData=false)
public class NPCFormControllerTest { 
    
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
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

        Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        string opptyId = DeviceUtilTest.createOpp(acc.Id,'0.10UM');
        
        test.startTest();
        createContact(acc.Id);
        string opptyProgramId = DeviceUtilTest.createOppProg(acc.Id,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acc.Id,opptyProgramId);
        Insert Device;
        test.stopTest();
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
        
        insert testAcct;
        
        return testAcct.Id;
    }
    
    static Id createAccount2(Id parentId) {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account2';
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
        testAcct.Short_Name__c = 'TestAcct2';
        testAcct.ParentId = parentId;
        
        insert testAcct;
        
        return testAcct.Id;
    }
    
    static Id createAccount3(Id parentId) {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account3';
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
        testAcct.Short_Name__c = 'TestAcct3';
        testAcct.ParentId = parentId;
        
        insert testAcct;
        
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
        u.PortalRole = 'Manager';
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
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Generate_Standard_Frame__c='Yes';
        Insert device;
        
        return device;
    }
    
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
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.01';
        device.Device_Base_Id__c = 'CDID0000001.03';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
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
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
        Insert device;
        
        return device;
    }
    
    static Device__c createDevice3(Id testAcctId, Id testOpptyProgramId, String deviceName, Id npcformId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = deviceName;
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
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.NPC_Form__c = npcformId;
        
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
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
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
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
        Insert device;
        
        return device;
    }
    
    static Id createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        insert npc;
        
        return npc.Id;
    }
    
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.New_Customer_Name__c = 'Test Account';
        npc.New_Customer_Short_Name__c = 'TestAcct';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm2(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.Reason_For_New_Part__c = 'Others';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm3(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTESTU1378';
        npc.CRM_DID__c = 'CDID123456';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'Yes';
        npc.Reason_For_New_Part__c = 'Retrofit';
        //npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        insert npc;
        
        return npc;
    }
    
    static Id createNPCForm4(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.Reason_For_New_Part__c = 'New Probe Card Flow';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        insert npc;
        
        return npc.Id;
    }
    
    static New_Part_Creation_Form__c createNPCForm5(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 1';
        npc.Tapeout_Required__c = 'Yes';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
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
        /*Profile p = [
            SELECT      Id
            FROM        Profile
            WHERE       Name = 'System Administrator'
        ];
        
        List<User> listUser = new List<User>();
        for (integer i = 1; i<=pNo; i++) {
            User u = new User();
            u.LastName = 'test' + i;
            u.FirstName = 'test' + i;
            u.Alias = 'test' + i;
            u.Email = 'test' + i + '@test.com';
            u.EmailEncodingKey = 'UTF-8';
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.ProfileId = p.Id;
            u.IsActive = true;
            u.UserName = 'zTestUser' + i + '@test.com';
            u.CommunityNickname = 'test' + i;
            
            listUser.add(u);
        }
        
        insert listUser;*/
        
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
    
    static testMethod void testNPCFormController1() {
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();TESTDEVICEZAIH12345677
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            blob attachmentBody = blob.valueOf('test');
            attachment a = new attachment();
            a.name = 'test';
            a.body = attachmentBody;
            
            n.addMore();
            for (NPCFormController.AttachmentWrapper aw : n.listAttachments) {
                aw.attachment = a;
            }
            
            n.save();
            
            n.getRemoveAttachment();
            n.attachId = 'test';
            n.getRemoveAttachment();
            
            n.retrieveMaskDetails();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController2() {
        // From Device page
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();

            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
            n.getRemoveAttachment();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController3() {
        // From Device page
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();

            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController4() {
        // From NPC Tab
        // Search for Base Device - CRMDID
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);
        Device__c testDevice1 = NPCFormControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        Device__c testDevice1 = DeviceUtilTest.createSPDevice(testAcctId.id,testOpptyProgramId.id);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice1.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController5() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);
        Device__c testDevice2 = NPCFormControllerTest.createDevice2(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        Device__c testDevice2 = DeviceUtilTest.createSPDevice(testAcctId.id,testOpptyProgramId.id);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice2.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController6() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        String testNPCId = NPCFormControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        String testMaskId = NPCFormControllerTest.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPCId);
            NPCFormController n = new NPCFormController();
        test.stopTest();
    }
    
  /*  static testMethod void testNPCFormController7() {
        // Portal User
        //DataUtilTest.loadEnvironmentVariables();
        User usr1 = [select Id
                            , AccountId
                            , profile.name
                    from User where profileId in (select id from Profile where Name='GF Global Admin') and IsActive=true and UserRoleId != null limit 1];
        //String testAcctId = NPCFormControllerTest.createAccount();
        //String testContactId = NPCFormControllerTest.createContact(testAcctId);
        //String testPortalUserId = NPCFormControllerTest.createPortalUser(testContactId);
        
        String testAcctId;
        String testContactId;
        String testPortalUserId;
        
        System.runAs(usr1){
            testAcctId = NPCFormControllerTest.createAccount();
           
            testContactId = NPCFormControllerTest.createContact(testAcctId);
            testPortalUserId = NPCFormControllerTest.createPortalUser(testContactId);
        }
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('userId', testPortalUserId);
            NPCFormController n = new NPCFormController();
        test.stopTest();
    }*/
    
    static testMethod void testNPCFormController8A() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);  */
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
                
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            NPCFormController.toDelIdent = 0;
            NPCFormController.addCount = 0;
            
            pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('host', 'globalfoundryview');
            n = new NPCFormController();
            n.isFromPortal = true;
            n.cancel();
            
            NPCFormController.MaskWrapper m = new NPCFormController.MaskWrapper(0, new Mask__c());
            List<NPCFormController.MaskWrapper> tempList = new List<NPCFormController.MaskWrapper>();
            tempList.add(m);
            n.maskWrappers = new List<NPCFormController.MaskWrapper>();
            n.maskWrappers = tempList;
            n.delWrapper();
            NPCFormController.addCount = 1;
            
            n.npcForm.Reference_Id__c = 'Available';
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.addRows();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
            n.addRows();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController8B() {
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);  */
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];        
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            NPCFormController.toDelIdent = 0;
            NPCFormController.addCount = 0;
            
            pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('host', 'globalfoundryview');
            n = new NPCFormController();
            
            NPCFormController.MaskWrapper m = new NPCFormController.MaskWrapper(0, new Mask__c(), true);
            List<NPCFormController.MaskWrapper> tempList = new List<NPCFormController.MaskWrapper>();
            tempList.add(m);
            n.maskWrappers = new List<NPCFormController.MaskWrapper>();
            n.maskWrappers = tempList;
        test.stopTest();
    }
    
    static testMethod void testNPCFormController9() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);       */
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            
            n.maskLayerOptions.add(new SelectOption('test', 'test'));
            n.populateMaskLayers(new MESService.processResponse_element());
            List<SelectOption> testfabList = n.getFabList();
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c;
            string testMaskDiv = n.getShowMaskDiv();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController10() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        String testNPCId = NPCFormControllerTest.createNPCForm4(testAcctId.id, testDevice.Id);
        String testMaskId = NPCFormControllerTest.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPCId);
            NPCFormController n = new NPCFormController();
            n.npcForm.Comments__c = 'test';
            Attachment testAttach = n.getRemoveAttachment();
            PageReference testSave = n.save();
        test.stopTest();
    }
    
    static testMethod void testSaveMethod1() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormControllerTest.createNPCForm3(testAcctId.id, testDevice.Id);
        String testMaskId = NPCFormControllerTest.createNPCMasks(testNPC.Id);
       // Device__c testDevice1 = NPCFormControllerTest.createDevice3(testAcctId.id, testOpptyProgramId.id, testNPC.New_Part_ID__c, testNPC.Id);
         
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Current_Forecast_Tapeout_Date__c = null; 
            n.device.Fab__c = 'FAB 1';
           
            n.npcForm.Tapeout_Required__c = 'No';
            n.save();
             
            n.npcForm.Tapeout_Required__c = 'Yes';
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c;
            n.npcForm.New_Fab__c = null;
            n.save();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            n.npcForm.New_Part_ID__c = 'npc';
            n.save();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.npcForm.New_Part_ID__c = '1npc';
            n.save();
            
            n.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_OTHERS').value__c;
            n.save();
            
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
            n.save();
            
        test.stopTest();
    }
    
     
    static testmethod void testSaveMethod2(){
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = createNPCForm5(testAcctId.id, testDevice.Id);
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
            n.device.fab__c = 'FAB 1';
            n.npcform.new_part_id__c = 'TESTDEVICEZAIH12345677-XY'; 
            n.isEdit = false;
            n.isClone = true;
            n.save();
        test.stopTest();
    }
    
    static testmethod void testCancel(){
         Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = createNPCForm5(testAcctId.id, testDevice.Id);
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getHeaders().put('host', 'salesforce');
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
            n.isEdit = false;
            n.cancel();
            
            n.fromDevicePage = true;
            n.cancel();
            
            n.isEdit = true;
            n.cancel();
            
            ApexPages.currentPage().getHeaders().put('host', 'globalfoundries');
            NPCFormController n1 = new NPCFormController();
            n1.cancel();
        test.stopTest();
        
    }
    
    static testmethod void testNPCFormControllerConstructor(){
        
          test.startTest();
          List<user> userList = new List<user>();
          Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
          for(integer i =0; i< = 5; i++){
             
             User u = new User(Alias = 'standt', Email='standarduser@testorg.com'+i, 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            firstname = 'fname' + i,
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'+i);
            userlist.add(u);
          } 
           
          insert userlist;
          Map<String, User> userMap = new Map<String, user>();
          userlist.clear();
          for(User u : [select id,name from user limit 10]){
            userMap.put(u.id, u);
            userlist.add(u);
          }      
          List<String> userIdList = new List<string>();
          userIdList.addAll(userMap.keyset());  
          set<user> usersSet = new Set<user>();
          usersSet.addAll(userList);
          
          NPCFormController n = new NPCFormController();
            
          n.listSelectedRecipients = usersSet;
          n.getSelectedRecipientsList();
        
          n.listUnselectedRecipients = usersSet;
          n.getUnselectedRecipientsList();
        
          n.selectedRecipients = userIdList;
          n.unselectValues();
        
          userIdList.remove(0);
          userIdList.remove(1);
          userIdList.remove(2);
          n.unselectedRecipients = userIdList;
          n.selectValues();
          
          n.retrieveObjectPrefix('Contact');
          n.retrieveBaseDevice('CDID0000001.00', 'CDID0000001.00');  
          test.stopTest();
          
    }
    
    static testmethod void testRetrieveAdditionalRecipients(){
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        String testNPCId = NPCFormControllerTest.createNPCForm4(testAcctId.id, testDevice.Id);
        String testMaskId = NPCFormControllerTest.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPCId);
            NPCFormController n = new NPCFormController();
            n.npcForm.Additional_Recipient_1__c = n.npcForm.Additional_Recipient_2__c = userinfo.getUserid();
            n.npcForm.Additional_Recipient_3__c = n.npcForm.Additional_Recipient_4__c = userinfo.getUserid();
            n.npcForm.Additional_Recipient_5__c = userinfo.getUserid();
            n.RetrieveAdditionalRecipients();
        test.stopTest();
    }
    
    static testMethod void testRun11() {
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        //Id testNPC = createNPCForm(testAcctId.id, testDevice.Id);
        
        String tempName = Environment_Variable__c.getInstance('NPC_STATUSREJECTED').Value__c;
        
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE RecordType.Name = :tempName];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = testAcctId.Id;
        npc.Originating_Device__c = testDevice.Id;
        npc.BASE_Device__c = testDevice.Id;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c;
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        if(recordTypeList.size() > 0){
            npc.RecordTypeID = recordTypeList[0].Id;
        }
        
        insert npc;
        
        test.startTest();
        
        PageReference pageRef = Page.NPCFormVF;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', npc.Id);
        NPCFormController n = new NPCFormController();
        n.accountName = 'Test';
        n.blankString = 'Test';
        
        test.stopTest();
    }
    
    static testmethod void testRun12(){
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        //Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        //Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        //String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId.Id);
        
         Opportunity testOppty = new Opportunity();
        testOppty.Name = 'skdczxBMczx';
        testOppty.AccountId = testAcctId.Id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        
        Insert testOppty;
        
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId.Id, testOppty.Id);
        
        test.startTest();
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = null;
        device.Generate_Standard_Frame__c='Yes';
        Insert device;
        
        String tempName = Environment_Variable__c.getInstance('NPC_STATUSREJECTED').Value__c;
        
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE RecordType.Name = :tempName];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = testAcctId.Id;
        npc.Originating_Device__c = device.Id;
        npc.BASE_Device__c = device.Id;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c;
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        
        if(recordTypeList.size() > 0){
            npc.RecordTypeID = recordTypeList[0].Id;
        }
        
        insert npc;
        
        
        
        PageReference pageRef = Page.NPCFormVF;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', npc.Id);
        NPCFormController n = new NPCFormController();
        n.accountName = 'Test';
        n.blankString = 'Test';
        
        List<Error_Codes__c> ecList = [SELECT Id FROM Error_Codes__c WHERE Name = 'DEVICE_COMPLETION'];
        if(ecList.size() > 0){
            delete ecList;
        }
        
        pageRef = Page.NPCFormVF;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', npc.Id);
        n = new NPCFormController();
        
       test.stopTest();
    }
    
    static testMethod void testRun13() {
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        //Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId.Id;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = null;
        device.Generate_Standard_Frame__c='Yes';
        /*
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId.Id;
        device.Fab__c = 'FAB 1';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        //device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        */
        /*
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = null;
        */
        Insert device;
        
        Device__c testDevice = device;
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            blob attachmentBody = blob.valueOf('test');
            attachment a = new attachment();
            a.name = 'test';
            a.body = attachmentBody;
            
            n.addMore();
            for (NPCFormController.AttachmentWrapper aw : n.listAttachments) {
                aw.attachment = a;
            }
            
            n.save();
            
            n.getRemoveAttachment();
            n.attachId = 'test';
            n.getRemoveAttachment();
            
            //n.retrieveMaskDetails();
        test.stopTest();
    }
    
    static testmethod void testRun14(){
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();TESTDEVICEZAIH12345677
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        testAcctId.Short_Name__c = 'TestAcc';
        update testAcctId;
        
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.retrieveMaskDetails();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.retrieveMaskDetails();
            
        test.stopTest();
    }
    
    static testmethod void testRun15(){
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        //Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        //Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        //String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId.Id);
        
         Opportunity testOppty = new Opportunity();
        testOppty.Name = 'skdczxBMczx';
        testOppty.AccountId = testAcctId.Id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        
        Insert testOppty;
        
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId.Id, testOppty.Id);
        
        test.startTest();
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = null;
        device.Generate_Standard_Frame__c='Yes';
        Insert device;
        
        String tempName = Environment_Variable__c.getInstance('NPC_STATUSREJECTED').Value__c;
        
        List<RecordType> recordTypeList = [SELECT Id FROM RecordType WHERE RecordType.Name = :tempName];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = testAcctId.Id;
        npc.Originating_Device__c = device.Id;
        npc.BASE_Device__c = device.Id;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_IN_EXEC').Value__c;
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        npc.Reason_for_New_Part__c = 'STF Reactivation';
        
        if(recordTypeList.size() > 0){
            npc.RecordTypeID = recordTypeList[0].Id;
        }
        
        insert npc;
        
        PageReference pageRef = Page.NPCFormVF;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', npc.Id);
        NPCFormController n = new NPCFormController();
        n.isEdit = false;
        n.retrieveReferenceIds();
        
        npc.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
        update npc;
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
        n.retrieveReferenceIds();
        
        npc.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        update npc;
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.retrieveReferenceIds();
        
        n.hasDevice = true;
        n.retrieveReferenceIds();
        
        n.isEdit = true; 
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
        n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.retrieveReferenceIds();
        
        n.isEdit = true; 
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.isClone = true; 
        n.retrieveReferenceIds();
        
        n.isEdit = false; 
        n.hasDevice = false;
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
        n.retrieveReferenceIds();
        
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.retrieveReferenceIds();
        
        n.isEdit = true; 
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
        n.retrieveReferenceIds();
        
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        n.origRequireToCreateTheNewPart = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        n.retrieveReferenceIds();
        
        /*
        testAcctId.Short_Name__c = 'TestAcc';
        update testAcctId;
        n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
        //device.Account_Short_Name__c = 'TestDevice';      
        n.advancedSearchReferenceIds();
        */
        Test.stopTest();
    }
    
    static testmethod void testRun16(){
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();TESTDEVICEZAIH12345677
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        testAcctId.Short_Name__c = 'TestAcc';
        update testAcctId;
        
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.retrieveMaskDetails();
            
            n.isEdit = true;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
            n.npcForm.Reference_Id__c = 'ANBQP60ACO8CH-U01';
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
            n.advancedSearchReferenceIds();
            
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            n.advancedSearchReferenceIds();
            
            n.hasDevice = false;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            n.advancedSearchReferenceIds();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.advancedSearchReferenceIds();
            
        test.stopTest();
    }
    
    static testmethod void testRun17(){
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();TESTDEVICEZAIH12345677
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        testAcctId.Short_Name__c = 'TestAcc';
        update testAcctId;
        
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.hasDevice = true;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.isEdit = true;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.isEdit = true;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.isClone = true;
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();

            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.origNPCReason = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.isClone = false;
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            
        test.stopTest();
    }
    
    static testMethod void testRun18() {
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest.createAccount();
        String testOpptyId = NPCFormControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        //Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId.Id;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
        /*
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId.Id;
        device.Fab__c = 'FAB 1';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        //device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Revision';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
        */
        /*
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677132123';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 7';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'RF - Others';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890111';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U0111';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID000000111.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = null;
        */
        Insert device;
        
        Device__c testDevice = device;
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_STF').Value__c;
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            blob attachmentBody = blob.valueOf('test');
            attachment a = new attachment();
            a.name = 'test';
            a.body = attachmentBody;
            
            n.addMore();
            for (NPCFormController.AttachmentWrapper aw : n.listAttachments) {
                aw.attachment = a;
            }
            
            n.save();
            
            n.getRemoveAttachment();
            n.attachId = 'test';
            n.getRemoveAttachment();
            
            //n.retrieveMaskDetails();
        test.stopTest();
    }   
}