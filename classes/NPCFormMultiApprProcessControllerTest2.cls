/*
    Author: Anirban Roy
    Description: This serves as the test class for NPCFormMultiApprProcessController class.
    History: 
        ARoy      01132013    - Code creation.
        ZAmbat    04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
        Vijay     16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                'Design In' directly and added mandatory fields.
        DBiswal   04132015    - Updated code for making SeeAllData=false and refactoring of test class.
        SNune     12062015    - Modified code for improving code coverage
        
*/
 
@isTest(SeeAllData=false)
public class NPCFormMultiApprProcessControllerTest2 {

    @testSetup static void testdata() {
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
    }

    // Get List of Users
    static List<User> getUserList1(){
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
                        AND Fab_Assigned__c INCLUDES ('FAB 7')
            ];
            
        return listUser;
    }
    
    static List<User> getUserList2(){
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
            ];
            
        return listUser;
    }
    
    static Id createAccount() {
        // Create Account
                 Account testAcct = getAccount('testing901'); 
        
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Update testAcct;
        
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
    
    static Device__c createDevice1(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345688';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 7';
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
        device.CRMDID__c = 'CDID0000002.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
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
        npc.Fab__c = 'FAB 7';
        
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
        npc.Fab__c = 'FAB 7';
        
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
        npc.Fab__c = 'FAB 7';
        npc.Reason_for_New_Part__c = 'New Probe Card Flow';
        npc.NPC_Form_Status__c = 'Pending Mask Layer Addition by FE';
        
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
    
    static void createOpportunityProgramTeamMembers(Id opportunityProgramId, Id userId) {

        Opportunity_Program_Team_Member__c opptm = new Opportunity_Program_Team_Member__c();
        opptm.Opportunity_Program__c = opportunityProgramId;
        opptm.User__c = userId;
        opptm.Opportunity_Program_Access__c = 'Read/Write';
        opptm.Device_Access__c = 'Read/Write';
        opptm.Team_Role__c = 'Customer Engineer';
        opptm.Core_Team_Member__c = false;     
        
        insert opptm;
    }
    
    public static void createUsers(){
        
    }
    
    static void createOpportunityProgramTeamMembers1(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 7')
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
    
    
    static void createOpportunityProgramTeamMembers2(integer pNo, Id opportunityProgramId) {
        List<User> listUser = [
            SELECT      Id,Fab_Assigned__c
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES ('FAB 7')
            LIMIT :pNo
        ];
     
        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<pNo; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            system.debug('\n\n ********** Fab_Assigned__c : ' + listUser[i].Fab_Assigned__c);
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            o.Team_Role__c = 'Customer Engineer';
            o.Core_Team_Member__c = false;
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    
    static void createOpportunityProgramTeamMembersForFab(integer pNo, Id opportunityProgramId, String fab) {
        List<User> listUser = [
            SELECT      Id,Fab_Assigned__c
            FROM        User
            WHERE       IsActive = true
                        AND Profile.Name LIKE 'GF%'
                        AND Fab_Assigned__c INCLUDES (:fab)
            LIMIT :pNo
        ];
     
        List<Opportunity_Program_Team_Member__c> listOPTM = new List<Opportunity_Program_Team_Member__c>();
        for (integer i = 0; i<pNo; i++) {
            Opportunity_Program_Team_Member__c o = new Opportunity_Program_Team_Member__c();
            o.Opportunity_Program__c = opportunityProgramId;
            o.User__c = listUser[i].Id;
            system.debug('\n\n ********** Fab_Assigned__c : ' + listUser[i].Fab_Assigned__c);
            o.Opportunity_Program_Access__c = 'Read/Write';
            o.Device_Access__c = 'Read/Write';
            o.Team_Role__c = 'Customer Engineer';
            o.Core_Team_Member__c = false;
            listOPTM.add(o);
        }
        
        insert listOPTM;
    }
    static testMethod void testNPCApproveByPIYE(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList2();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm1(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers(testOpptyProgramId,usrList[0].Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();
            PageReference pgRef = npcMultiApp.approveNPC();
            npcMultiApp.isPIYEApproval = true;
            pgRef = npcMultiApp.approveNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
    static testMethod void testNPCReject(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList2();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm1(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers(testOpptyProgramId,usrList[0].Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();
            npcMultiApp.comments = 'rejected';
            PageReference pgRef = npcMultiApp.rejectNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
     static testMethod void testNPCRejectWithoutComments(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList2();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
       
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm1(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers(testOpptyProgramId,usrList[0].Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();
            PageReference pgRef = npcMultiApp.rejectNPC();
            
        test.stopTest();
    }
    
    static testMethod void testNPCCancel(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList2();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm1(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers(testOpptyProgramId,usrList[0].Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();
            PageReference pgRef = npcMultiApp.cancelNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
    static testMethod void testNPCApproveByCE9(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers1(9, testOpptyProgramId);
            String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();                       
            npcMultiApp.npcForm.PIYE_Approver_3__c = usrList[2].Id;
            PageReference pgRef = npcMultiApp.approveNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
    static testMethod void testNPCApproveByCE10(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembers1(10, testOpptyProgramId);
            String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormApprovalProcessController n = new NPCFormApprovalProcessController();
            
            n.submitNPCForm();
            
            NPCFormMultiApprProcessController npcMultiApp = new NPCFormMultiApprProcessController();                       
            npcMultiApp.npcForm.PIYE_Approver_3__c = usrList[2].Id;
            PageReference pgRef = npcMultiApp.approveNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow9() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew3(testAcctId, testOpptyId, testOpptyProgramId);
            insert testDevice;
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(9, testOpptyProgramId,testDevice.fab__c);
            String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    } 
    
    static testMethod void testNPCNewProbeCardFlow10() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew3(testAcctId, testOpptyId, testOpptyProgramId);
            insert testDevice;
            New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
            String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
            NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(10, testOpptyProgramId, testdevice.fab__c);
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
     static testMethod void testNPCNewProbeCardFlow1() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(1, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow2() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(2, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow3() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(3, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow4() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;

        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(4, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow5() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
       // Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(5, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow6() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(6, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow7() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
       // Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(7, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
    static testMethod void testNPCNewProbeCardFlow8() {
        List<User> usrList = NPCFormMultiApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormMultiApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormMultiApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormMultiApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
       // Device__c testDevice = NPCFormMultiApprProcessControllerTest2.createDevice1(testAcctId, testOpptyProgramId);
        Device__c testDevice = DeviceUtilTest.createCMPWDevice(testAcctId,testOpptyProgramId);
        
        test.startTest();
        Insert testDevice;
        New_Part_Creation_Form__c testNPC = NPCFormMultiApprProcessControllerTest2.createNPCForm2(testAcctId, testDevice.Id);
        NPCFormMultiApprProcessControllerTest2.createOpportunityProgramTeamMembersForFab(8, testOpptyProgramId, testdevice.fab__c);
        String testMaskId = NPCFormMultiApprProcessControllerTest2.createNPCMasks(testNPC.Id);
        
            PageReference pageRef = Page.NPCFormMultiApproval;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormMultiApprProcessController n = new NPCFormMultiApprProcessController();            
            n.npcForm.PIYE_Approver_1__c = usrList[0].Id;
            n.approveNPC();
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}