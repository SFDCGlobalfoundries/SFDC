/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPCFormController.
    History: 
        ZAmbat      02142014    - Code creation.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
        SNune       12012015    - Updated code coverage
*/
@isTest(SeeAllData=false)
public class NPCFormControllerTest1 {
    
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
        string opptyProgramId = DeviceUtilTest.createOppProg(acc.Id,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acc.Id,opptyProgramId);
        Insert Device;
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
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        
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
    
    static Device__c createDevice6(Id testAcctId, Id testOpptyProgramId, Id npcFormId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH123456999';
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
        device.Tapeout_Type__c = 'Retrofit';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        //device.Device_Mask_Set_Title__c = '';
        device.CRMDID__c = 'CDID0000002.01';
        device.Device_Base_Id__c = 'CDID0000001.00';
        device.Device_Type__c = 'Retrofit';
        device.NPC_Form__c = npcFormId;
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
        npc.New_Part_ID__c = 'TESTDEVICEZAIH123456999';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Current_Forecast_Tapeout_Date__c = date.today();
        npc.Mask_Set_Title__c = 'test';
        
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
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.Tapeout_Required__c = 'No';
        npc.Reason_For_New_Part__c = 'StartingMaterial Change';
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
    
    static testMethod void testNPCFormController10() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController11() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice3(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.device = testDevice;
           // system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController12() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice4(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Fab__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            ApexPages.currentPage().getParameters().put('gfce', 'test');
            NPCFormController n = new NPCFormController();
            n.device = testDevice;
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
           // system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            system.assertEquals(n.device.Fab__c, 'FAB 2');
            n.retrieveDeviceDetails();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController13() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice5(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Fab__c,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            ApexPages.currentPage().getParameters().put('gfce', 'test');
            NPCFormController n = new NPCFormController();
            n.device = testDevice;
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'CustomerNameChange';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            //system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            system.assertEquals(n.device.Fab__c, 'FAB 2');
            n.retrieveDeviceDetails();
            n.retrieveObjectPrefix('New_Part_Creation_Form__c');
            n.getAccountShortName();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController14() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        New_Part_Creation_Form__c testNPC = NPCFormControllerTest1.createNPCForm2(testAcctId.id, testDevice.Id);
        //String testMaskId = NPCFormControllerTest1.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController15A() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
       // String testAcctId1 = NPCFormControllerTest1.createAccount();
        //String testAcctId2 = NPCFormControllerTest1.createAccount2(testAcctId1);
        //String testAcctId3 = NPCFormControllerTest1.createAccount3(testAcctId2);
       // String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId2);
        //String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId2, testOpptyId);
       // Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId2, testOpptyProgramId);
          Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
          Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
          Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        New_Part_Creation_Form__c testNPC = NPCFormControllerTest1.createNPCForm3(testAcctId.id, testDevice.Id);
        //String testMaskId = NPCFormControllerTest1.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
            
            n.portalUserAccountId = testAcctId.id;
            n.isFromPortal = true;
            n.retrieveAccountNamesByHierarchy();
            n.npcForm.New_Part_ID__c = 'TEST123###';
            
            List<string> tempList = new List<string>(); 
            for (User u : [SELECT       Id
                                        , Name
                           FROM         User
                           WHERE        IsActive = true
                           LIMIT 5]) {
                n.listUnselectedRecipients.add(u);
                n.mapRecipients.put(u.Id, u);
                n.unselectedRecipients.add(u.Id);
                tempList.add(u.Id);
            }
            
            n.selectValues();
            n.selectedRecipients.addAll(tempList);
            n.unselectValues();
            n.getUnselectedRecipientsList();
            n.getSelectedRecipientsList();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController15B() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
        //String testAcctId1 = NPCFormControllerTest1.createAccount();
        //String testAcctId2 = NPCFormControllerTest1.createAccount2(testAcctId1);
        //String testAcctId3 = NPCFormControllerTest1.createAccount3(testAcctId2);
        //String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId1);
        //String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId1, testOpptyId);
        //Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId1, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        New_Part_Creation_Form__c testNPC = NPCFormControllerTest1.createNPCForm3(testAcctId.id, testDevice.Id);
        //String testMaskId = NPCFormControllerTest1.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormController n = new NPCFormController();
            
            n.isFromPortal = false;
            n.portalUserAccountId = testAcctId.id;
            n.isFromPortal = true;
            n.retrieveAccountNamesByHierarchy();
            n.npcForm.New_Part_ID__c = 'TEST123###';
            
            List<string> tempList = new List<string>(); 
            for (User u : [SELECT       Id
                                        , Name
                           FROM         User
                           WHERE        IsActive = true
                           LIMIT 5]) {
                n.listUnselectedRecipients.add(u);
                n.mapRecipients.put(u.Id, u);
                n.unselectedRecipients.add(u.Id);
                tempList.add(u.Id);
            }
            
            n.selectValues();
            n.selectedRecipients.addAll(tempList);
            n.unselectValues();
            n.getUnselectedRecipientsList();
            n.getSelectedRecipientsList();
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController16() {
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
       // Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId.id, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId.id;
            n.npcForm.Originating_Device__c = testDevice.Id;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.retrieveDeviceDetails();
            n.advancedSearchReferenceIds();
            
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            n.npcForm.Mask_Set_Title__c = 'test';
            
            blob attachmentBody = blob.valueOf('test');
            attachment a = new attachment();
            a.name = 'test';
            a.body = attachmentBody;
            
            n.addMore();
            for (NPCFormController.AttachmentWrapper aw : n.listAttachments) {
                aw.attachment = a;
            }
            
            n.npcForm.New_Part_ID__c = 'SLTESTNPC00001';
            n.save();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001!!!';
            n.save();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001-U01';
            n.save();
            
            n.npcForm.Current_Forecast_Tapeout_Date__c = date.today();
            
            for (User u : [SELECT    Id
                           FROM      User
                           WHERE     IsActive = true
                           LIMIT 5]) {
                n.listSelectedRecipients.add(u);
            }
            
            n.save();
        test.stopTest();
    }
    
   /* static testMethod void testNPCFormController17() {
       //String testAcctId = NPCFormControllerTest1.createAccount();
        //String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        //String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        string testNPCId = NPCFormControllerTest1.createNPCForm(testAcctId.id, testDevice.Id);
        Device__c testRetrofitDevice = NPCFormControllerTest1.createDevice6(testAcctId.id, testOpptyProgramId.id, testNPCId);
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            
            test.setCurrentPageReference(new PageReference('Page.NPCFormVF'));
            system.currentPageReference().getParameters().put('id', testNPCId);
            NPCFormController n = new NPCFormController();
            n.npcForm.Reason_for_New_Part__c = 'New Probe Card Flow';
            n.save();
        test.stopTest();
    }
    */
    static testMethod void testNPCFormController18() {
       /* String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        string testNPCId = NPCFormControllerTest1.createNPCForm(testAcctId.id, testDevice.Id);
        //Device__c testRetrofitDevice = NPCFormControllerTest1.createDevice6(testAcctId.id, testOpptyProgramId, testNPCId);
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            
            test.setCurrentPageReference(new PageReference('Page.NPCFormVF'));
            system.currentPageReference().getParameters().put('id', testNPCId);
            system.currentPageReference().getParameters().put('clone', '1');
            NPCFormController n = new NPCFormController();
            n.npcForm.Reason_for_New_Part__c = 'New Probe Card Flow';
            n.retrieveReferenceIds();
            n.advancedSearchReferenceIds();
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController19() {
       /* String testAcctId = NPCFormControllerTest1.createAccount();
        String testOpptyId = NPCFormControllerTest1.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormControllerTest1.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormControllerTest1.createDevice(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        
        string testNPCId = NPCFormControllerTest1.createNPCForm(testAcctId.id, testDevice.Id);
        
        //Device__c testRetrofitDevice = NPCFormControllerTest1.createDevice6(testAcctId.id, testOpptyProgramId, testNPCId);
        test.startTest();
            createNPCMasks(testNPCId);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            
            test.setCurrentPageReference(new PageReference('Page.NPCFormVF'));
            system.currentPageReference().getParameters().put('id', testNPCId);
            system.currentPageReference().getParameters().put('clone', '1');
            NPCFormController n = new NPCFormController();
            n.isEdit = true;
            n.isClone = false;
            n.npcForm.Reason_for_New_Part__c = 'New Probe Card Flow';
            n.retrieveReferenceIds();
            n.advancedSearchReferenceIds();
            n.save();
        test.stopTest();
    }
}