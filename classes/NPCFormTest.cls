/*
    Author: Zymark Ambat
    Description: This serves as the test class for NPC Form.
    History: 
        ZAmbat      10142013    - Code creation.
        ZAmbat      12202013    - Updated test class.
        ZAmbat      04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*/
@isTest(SeeAllData=false)
public class NPCFormTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    static Id createAccount() {
        // Create Account
         Account testAcct = new Account();
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
        testAcct=AccountDataFactory.createAccount(fieldValueMap);
        
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
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity ZA');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
         
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program ZA';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
	static Id createMaskSetTtitle(){
		Map<String, String> tempMap = new Map<String, String>();
		tempMap.put('Name', 'MSTTRT1');
		tempMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        
		Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle1(tempMap);
        return mst.Id;
	}
	
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Fab__c','FAB 2'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c','100'); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today().addDays(7)); 
        fieldValueMap.put('CRMDID__c','CDID0000001.00'); 
        fieldValueMap.put('Device_Type__c','Base'); 
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)'); 
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
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
        device.Device_Mask_Set_Title__c = 'DVMST12';
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
    
    static Id createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.BASE_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.NPC_Form_Status__c = 'Pending Submission';
        
        insert npc;
        
        return npc.Id;
    }
    
    static New_Part_Creation_Form__c createNPCForm1(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1-U02';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 2';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Tapeout_Required__c = 'No';
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Reason_for_New_Part__c = 'CustomerNameChange';
        npc.New_Customer_Name__c = 'NewCustomerName';
        
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
    
    public static MESService.processResponse_element MESServiceMockResponse() {
        // Reference Id
        List<MESService.NPC_PART_MAST_TYPE_TOUT_element> listReferenceId = new List<MESService.NPC_PART_MAST_TYPE_TOUT_element>();
        MESService.NPC_PART_MAST_TYPE_TOUT_element r = new MESService.NPC_PART_MAST_TYPE_TOUT_element();
        r.PART_ID = 'REFERENCEID1';
        r.CUST_INITIAL = null;
        r.FAB_GROUP = null;
        
        listReferenceId.add(r);
        
        // Mask
        List<MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element> listMask = new List<MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element>();
        MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element m = new MESService.WEB_PART_PHOTO_STAGE_TYPE_TOUT_element();
        m.PART_ID = 'REFERENCEID1';
        m.RECTICLE_ID = 'RECTICLE1';
        m.LAYER_NO = 'LAYER1';
        
        listMask.add(m);
        
        MESService.processResponse_element pre = new MESService.processResponse_element();
        pre.NPC_PART_MAST_TYPE_TOUT = listReferenceId;
        pre.WEB_PART_PHOTO_STAGE_TYPE_TOUT = listMask;
        
        return pre;
    }
    
    /*static testMethod void testNPCFormApprovalProcessController_Errors() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            n.submitNPCForm();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            //n.submitNPCForm();
            
            n.cancel();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_1Approver() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(1, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_2Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(2, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_3Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(3, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_4Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(4, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_5Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(5, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_6Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(6, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_7Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(7, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_8Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(8, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_9Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(9, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }
    
    static testMethod void testNPCFormApprovalProcessController_10Approvers() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);
        NPCFormTest.createOpportunityProgramTeamMembers(10, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            //testNPC.Comments__c = 'test';
            //update testNPC;
            
            n.submitNPCForm();
        test.stopTest();
    }*/
    
    static testMethod void testNPCFormUpdateStatus_SetStatusToClose() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);*/
    String testAcctId = DeviceUtilTest.createAccount();
        String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        test.startTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(testAcctId, testOpptyProgramId);//testAcctId, testOpptyProgramId
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDeviceId);
        
        
            /*PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            testNPC.Comments__c = 'test';
            update testNPC;
            
            n.submitNPCForm();*/
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = UserInfo.getUserId();
            testNPC.No_of_Approvers__c = 1;
            update testNPC;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());
            
            List<string> listNPC = new List<string>();
            listNPC.add(testNPC.Id);
            NPCFormUpdateStatus.setStatusToClose(listNPC);
        test.stopTest();
    }
    
    static testMethod void testNPCFormUpdateStatus_UpdateNPC() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);*/
    String testAcctId = DeviceUtilTest.createAccount();
        String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        test.startTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(testAcctId, testOpptyProgramId);//testAcctId, testOpptyProgramId
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDeviceId);
        
        
            /*Set<string> setCRMDIDs = new Set<string>();
            setCRMDIDs.add(testNPC.CRM_DID__c);
            NPCFormUpdateStatus.updateNPC(setCRMDIDs);*/
            
            //PageReference pageRef = Page.NPCFormVF;
            //Test.setCurrentPageReference(pageRef);

            testNPC.NPC_Form_Status__c = 'In Execution';
            update testNPC;
            
            /*Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(psr);
            system.assertEquals(result.isSuccess(), true);*/

            Set<string> setCRMDIDs = new Set<string>();
            setCRMDIDs.add(testNPC.CRM_DID__c);
            
            NPCFormUpdateStatus.updateNPC(setCRMDIDs);
        test.stopTest();
    }
    
    static testMethod void testNPCMasksController() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        String testNPCId = NPCFormTest.createNPCForm(testAcctId, testDevice.Id);*/
    String testAcctId = DeviceUtilTest.createAccount();
        String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        test.startTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(testAcctId, testOpptyProgramId);//testAcctId, testOpptyProgramId
        //New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDeviceId);
        String testNPCId = NPCFormTest.createNPCForm(testAcctId, testDeviceId);
        String testMaskId = NPCFormTest.createNPCMasks(testNPCId);
        
        
            NPCMasksController n = new NPCMasksController();
            n.paramId = testNPCId;
            string s = n.newLine;
            List<Mask__c> listMask = n.getMasks();
            
            system.assertEquals(testMaskId, listMask[0].Id);
        test.stopTest();
    }
    
    static testMethod void testNPCEmailSendBatchAndScheduler() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        String testNPCId = NPCFormTest.createNPCForm(testAcctId, testDevice.Id);*/
    String testAcctId = DeviceUtilTest.createAccount();
        String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        test.startTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(testAcctId, testOpptyProgramId);//testAcctId, testOpptyProgramId
        //New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDeviceId);
        String testNPCId = NPCFormTest.createNPCForm(testAcctId, testDeviceId);
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        Integer second = currTime.second();
        String sch = second + ' ' + min + ' ' + '* * * ? ' + currTime.year();
        
        
            /*NPCEmailScheduler obj = new NPCEmailScheduler();                
            String jobId = system.schedule('test', sch, obj);        
            CronTrigger ct = [SELECT    id
                                        , CronExpression
                                        , TimesTriggered
                                        , NextFireTime 
                              FROM      CronTrigger 
                              WHERE     id = :jobId];        
            System.assertEquals(sch, ct.CronExpression);                                      
            database.executeBatch(new NPCEmailSendBatch(), 1);*/
        test.stopTest();
    }
    
    static testMethod void testNPCFormTrigger() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDevice.Id);*/
        String testAcctId = DeviceUtilTest.createAccount();
        String testOpptyId = DeviceUtilTest.createOpp(testAcctId,'0.10UM');
        String testOpptyProgramId = DeviceUtilTest.createOppProg(testAcctId, testOpptyId);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        test.startTest();
        Id testDeviceId = DeviceUtilTest.createCustomerMPWDevice(testAcctId, testOpptyProgramId);//testAcctId, testOpptyProgramId
        New_Part_Creation_Form__c testNPC = NPCFormTest.createNPCForm1(testAcctId, testDeviceId);
        
        
            testNPC.NPC_Form_Status__c = 'Pending CE Approval';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'In Execution';
            update testNPC;
            
            testNPC.NPC_Form_Status__c = 'Executed';
            update testNPC;
        test.stopTest();
    }
    
    /*static testMethod void testNPCFormController1() {
        // From NPC Tab
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            
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
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        
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
            
            n.save();
            n.getRemoveAttachment();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController3() {
        // From Device page
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        
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
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController4() {
        // From NPC Tab
        // Search for Base Device - CRMDID
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        Device__c testDevice1 = NPCFormTest.createDevice1(testAcctId, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice1.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController5() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        Device__c testDevice2 = NPCFormTest.createDevice2(testAcctId, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice2.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC00001';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController6() {
        // Edit NPC
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        String testNPCId = NPCFormTest.createNPCForm(testAcctId, testDevice.Id);
        String testMaskId = NPCFormTest.createNPCMasks(testNPCId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPCId);
            NPCFormController n = new NPCFormController();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController7() {
        // Portal User
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testContactId = NPCFormTest.createContact(testAcctId);
        String testPortalUserId = NPCFormTest.createPortalUser(testContactId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('userId', testPortalUserId);
            NPCFormController n = new NPCFormController();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController8() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);       
        
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
            n.addRows();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController9() {
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);       
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            NPCFormController n = new NPCFormController();
            
            n.maskLayerOptions.add(new SelectOption('test', 'test'));
            n.populateMaskLayers(new MESService.processResponse_element());
        test.stopTest();
    }
    
    static testMethod void testNPCFormController10() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice(testAcctId, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController11() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice3(testAcctId, testOpptyProgramId);
        
        test.startTest();
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            NPCFormController n = new NPCFormController();
            n.npcForm.Account__c = testAcctId;
            n.npcForm.BASE_Device__c = testDevice.Id;
            
            n.advancedSearchReferenceIds();
            
            n.device = testDevice;
            system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            n.npcForm.New_Part_ID__c = 'TESTNPC0000-U01';
            n.npcForm.Secure_Device__c = 'No';
            n.npcForm.Reason_for_New_Part__c = 'Retrofit';
            n.npcForm.Automotive_Device__c = 'No';
            n.npcForm.Tapeout_Required__c = 'No';
            n.npcForm.Comments__c = 'test';
            
            n.save();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController12() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice4(testAcctId, testOpptyProgramId);
        
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
            system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            system.assertEquals(n.device.Fab__c, 'FAB 2');
            n.retrieveDeviceDetails();
        test.stopTest();
    }
    
    static testMethod void testNPCFormController13() {
        // From NPC Tab
        // Search for Base Device - Device Base Id
        //DataUtilTest.loadEnvironmentVariables();
        String testAcctId = NPCFormTest.createAccount();
        String testOpptyId = NPCFormTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice = NPCFormTest.createDevice5(testAcctId, testOpptyProgramId);
        
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
            system.assertEquals(n.device.Device_Mask_Set_Title__c, null);
            system.assertEquals(n.device.Fab__c, 'FAB 1');
            n.retrieveDeviceDetails();
            n.retrieveObjectPrefix('New_Part_Creation_Form__c');
        test.stopTest();
    }*/
}