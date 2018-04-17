/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormInternalReadOnlyController.
    History: 
        ZAmbat      09022013    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
        SNune       12062015    - Modified code for improving code coverage.
*/

@isTest(SeeAllData=false)
private class NPCFormInternalReadOnlyControllerTest2 { 

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
       
        string acctId = DeviceUtilTest.createAccount();
        
        String oppId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        
        String oppProgId = DeviceUtilTest.createOppProg(acctId, oppId);
        
        Device__c device = DeviceUtilTest.createCMPWDevice(acctId, oppProgId);
        Test.startTest();
        insert device;
        Test.stopTest();
        
    }
    
    static Device__c getDevice(){
    
        return [SELECT Id FROM Device__c LIMIT 1];
    }
    
    
    static User getFab2Usr(){
        
        Set<Id> profileIds = new Set<Id>();
        for (Profile p : [SELECT    Id
                          FROM      Profile
                          WHERE     Name LIKE 'GF%']) {
            profileIds.add(p.Id);               
        }
        
        User usr = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId IN :profileIds
                        AND Fab_Assigned__c INCLUDES ('FAB 2')
            LIMIT 1
            ];
            
        return usr;
    }
    
    static User getFab7Usr(){
        Set<Id> profileIds = new Set<Id>();
        for (Profile p : [SELECT    Id
                          FROM      Profile
                          WHERE     Name LIKE 'GF%']) {
            profileIds.add(p.Id);               
        }
        
        User usr = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND ProfileId IN :profileIds
                        AND Fab_Assigned__c INCLUDES ('FAB 7')
            LIMIT 1
            ];
            
        return usr;
    }
    
    static User getFabApprovers(){        
        
        String fabApprover = Environment_Variable__c.getInstance('Fab235Approvers').Value__c.split(',')[0];
                
        User usr = [
            SELECT      Id
            FROM        User
            WHERE       IsActive = true
                        AND Id = :fabApprover
            ];
            
        return usr;
    }
    
    static Id createAccount() {
        // Create Account
         Account testAcct = new Account();
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
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
    
    static Id createOpptyPrgTM(Id opptyId, User user){
        Opportunity_Program_Team_Member__c optm = new Opportunity_Program_Team_Member__c();
        optm.Opportunity_Program__c = opptyId;
        optm.User__c = user.Id;
        optm.Opportunity_Program_Access__c = 'Read/Write';
        optm.Device_Access__c = 'Read/Write';
        optm.Team_Role__c = 'Customer Engineer'; 
        insert optm;
        return optm.Id;
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
    
    static Device__c createDevice3(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 7';
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
        device.CRMDID__c = 'CDID0000003.00';
        device.Device_Type__c = 'Base';
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
        npc.Originating_Device__c = deviceId;
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
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        npc.Fab__c = 'FAB 2';
        
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm2(Id accountId, Id deviceId) {
        User u = [
            SELECT      Id
            FROM        User
            WHERE       Profile.Name = 'GF CE'
                        AND IsActive = true
            LIMIT 1
        ];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.NPC_Form_Status__c = 'Pending Submission';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        npc.Fab__c = 'FAB 7';
        
        insert npc;
        
        return npc;
    }
    
    static Mask__c createNPCMasks(Id npcId) {
        Mask__c m = new Mask__c();
        m.New_Part_Creation_Form__c = npcId;
        m.Layer__c = 'TestLayer';
        m.Modified_Mask__c = 'TestLayerMask';
        m.Original_Mask__c = 'TestLayerMask';
        
        insert m;
        
        return m;
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
    
    static testMethod void runTest11() {  
        
        Test.startTest(); 
        
        User user = NPCFormInternalReadOnlyControllerTest2.getFab7Usr();
        User user1 = NPCFormInternalReadOnlyControllerTest2.getFab2Usr();  
          
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = getDevice();
        
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest2.createNPCForm2(testAcctId.id, testDevice.Id);
        
            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast1');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            User u6 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast6');
            users.add(u6);
            
            User u7 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast7');
            users.add(u7);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.Approver_6__c = u6.Id;
            testNPC.No_of_Approvers__c = 6;
            update testNPC;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());           
            
            List<ProcessInstanceWorkItem> listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u6.Id) {
                    p.ActorId = u7.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.init();
        test.stopTest();
    }
    
    

    static testMethod void runTest12() {
        
        Test.startTest(); 
        //DataUtilTest.loadEnvironmentVariables();
        User user = NPCFormInternalReadOnlyControllerTest2.getFab7Usr();
        User user1 = NPCFormInternalReadOnlyControllerTest2.getFab2Usr();        
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest2.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        String testOpptyPrgmTeamMemberId = NPCFormInternalReadOnlyControllerTest2.createOpptyPrgTM(testOpptyProgramId, user);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest2.createDevice3(testAcctId, testOpptyProgramId);*/
        
        
        
        
        
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = getDevice();
        
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest2.createNPCForm2(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest2.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest2.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        

            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast1');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            User u6 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast6');
            users.add(u6);
            
            User u7 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast7');
            users.add(u7);
            
            User u8 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast8');
            users.add(u8);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.Approver_6__c = u6.Id;
            testNPC.Approver_7__c = u7.Id;
            testNPC.No_of_Approvers__c = 7;
            update testNPC;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());           
            
            List<ProcessInstanceWorkItem> listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u7.Id) {
                    p.ActorId = u8.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.init();
        test.stopTest();
    }
    
    static testMethod void runTest13() {
        
        Test.startTest();
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = getDevice();
        
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest2.createNPCForm2(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest2.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest2.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        
        
            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast1');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            User u6 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast6');
            users.add(u6);
            
            User u7 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast7');
            users.add(u7);
            
            User u8 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast8');
            users.add(u8);
            
            User u9 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast9');
            users.add(u9);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.Approver_6__c = u6.Id;
            testNPC.Approver_7__c = u7.Id;
            testNPC.Approver_8__c = u8.Id;
            testNPC.No_of_Approvers__c = 8;
            update testNPC;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());           
            
            List<ProcessInstanceWorkItem> listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u8.Id) {
                    p.ActorId = u9.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.init();
        test.stopTest();
    }
    
    static testMethod void runTest14() {
        
        Test.startTest();
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = getDevice();
        
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest2.createNPCForm2(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest2.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest2.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
              

            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast1');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            User u6 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast6');
            users.add(u6);
            
            User u7 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast7');
            users.add(u7);
            
            User u8 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast8');
            users.add(u8);
            
            User u9 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast9');
            users.add(u9);
            
            User u10 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast10');
            users.add(u10);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.Approver_6__c = u6.Id;
            testNPC.Approver_7__c = u7.Id;
            testNPC.Approver_8__c = u8.Id;
            testNPC.Approver_9__c = u9.Id;
            testNPC.No_of_Approvers__c = 9;
            update testNPC;
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());           
            
            List<ProcessInstanceWorkItem> listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u9.Id) {
                    p.ActorId = u10.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.init();
        test.stopTest();
    }
      
    static testMethod void runTest15() {
        
        Test.startTest();
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = getDevice();
        
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest2.createNPCForm2(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest2.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest2.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        

            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast1');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            User u6 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast6');
            users.add(u6);
            
            User u7 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast7');
            users.add(u7);
            
            User u8 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast8');
            users.add(u8);
            
            User u9 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast9');
            users.add(u9);
            
            User u10 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast10');
            users.add(u10);
            
            User u11 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast11');
            users.add(u11);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.Approver_6__c = u6.Id;
            testNPC.Approver_7__c = u7.Id;
            testNPC.Approver_8__c = u8.Id;
            testNPC.Approver_9__c = u9.Id;
            testNPC.Approver_10__c = u10.Id;
            testNPC.No_of_Approvers__c = 10;
            testNPC.Mask_Set_Title__c = 'test12141';
            update testNPC;
            
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());           
            
            List<ProcessInstanceWorkItem> listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u10.Id) {
                    p.ActorId = u11.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.init();
          /*  user oUser = [SELECT ID FROM USer WHERE isActive =: true and Profile.Name like: 'GF Litho' LIMIT 1];
            system.runAs(oUser){
                npc.checkNPCFormStatus();
            }
          */  
        test.stopTest();
    }
    
    public static User createTestUser(String profID, String fName, String lName) {
    
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User tuser = new User(  Alias = uniqueName.substring(18, 23),
                                email = uniqueName + '@test' + orgId + '.org',
                                emailencodingkey = 'UTF-8',
                                lastName = lName,
                                firstname = fName,
                                languagelocalekey = 'en_US',
                                localesidkey = 'en_US', 
                                ProfileId = profID,
                                timezonesidkey = 'America/Los_Angeles', 
                                Username = uniqueName + '@test' + orgId + '.org',
                                communitynickname = String.valueOf(randomInt),
                                FederationIdentifier = uniqueName + '@test' + orgId + '.org'
                                );
        return tuser;
    }
}