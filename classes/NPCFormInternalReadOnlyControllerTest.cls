/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the NPCFormInternalReadOnlyController.
    History: 
        ZAmbat      12182013    - Code creation.
        ARoy        02202014    - Test class updated as per case 6925.
        ZAmbat      04282014    - Updated code to SeeAllData=false as fix for SFDC test limitations.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        DBiswal     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
        SNune       12062015    - Modified code for improving code coverage.
*/

@isTest(SeeAllData=false)
private class NPCFormInternalReadOnlyControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        test.startTest();
        Insert Device;
        
        //createUsers(10);
        test.stopTest();
    }
    static void createUsers(Integer no){
        List<user> userList = new List<user>();
        for(integer i=1;i<=no;i++){
                User u = new User(
                alias = 'ts'+i, 
                email='testing'+i+'@test.com',
                emailencodingkey='UTF-8', 
                lastname='TestLast'+i, 
                firstname='TestFirst', 
                languagelocalekey='en_US',
                localesidkey='en_US', 
                profileid = '00e90000001232a',
                timezonesidkey='America/Los_Angeles', 
                username='testing'+i+''+ i + '@test.com',
                communitynickname='ts'+i,
                FederationIdentifier='Test2014'+i
            );
            userList.add(u);
        }
        insert userList;
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
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
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
        fieldValueMap.put('recordtypeid', rt.Id); 
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
        device.Stage__c = Environment_Variable__c.getInstance('DEVICE_STAGE_TAPEOUT').Value__c;
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c;
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
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

    static New_Part_Creation_Form__c createNPCForm11(Id accountId, Id deviceId) {
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
        npc.Reason_for_New_Part__c=Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        npc.Tapeout_Type__c =  Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c;
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        
        insert npc;
        
        return npc;
    }
    static New_Part_Creation_Form__c createNPCForm12(Id accountId, Id deviceId) {
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
        npc.Reason_for_New_Part__c=Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c;
        npc.Tapeout_Type__c =  Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c;
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
        Mask__History h=  new Mask__History();
         
                               h.ParentId=m.id;
                                            h.Field = 'Modified_Mask__c';
         insert h;  
         
                                     
        
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
    

      
   static testMethod void runTest1() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm11(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest.createNPCForm12(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        
        
         New_Part_Creation_Form__History h = new New_Part_Creation_Form__History();
                                                  h.ParentId = testNPC.Id;
                                                              h.Field ='Mask_Set_Title__c';
                              insert h;                                
        
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            npc.submitNPC();
            npc.apprRej();
            npc.cloneNpc();
            
            testNPC.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c;
            npc.userProfileName = Environment_Variable__c.getInstance('GF_CE').Value__c;
            npc.npcForm = testNPC;
            npc.editNPC();
            npc.cancelNPC() ;
            
            npc.userProfileName = null;
            npc.editNPC();
            npc.userProfileName = 'GF System Admin';
            
            npc.cancelNPC() ;
            
            
            ApexPages.currentPage().getParameters().put('id', testNPC1.Id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(testNPC1);
            NPCFormInternalReadOnlyController npc1 = new NPCFormInternalReadOnlyController(sc1);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw1 = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            npc1.submitNPC();
            npc1.apprRej();
            npc1.cloneNpc();
        test.stopTest();
    }
    
    static testMethod void runTest2() {
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
            
     /*   test.startTest();
        Account testAcctId = [Select Id from Account where name = 'Test Account'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        
        //system.debug('\n\n ####### in test' + [select Reason_for_New_Part__c from new_part_creation_form__c where id=:testnpc.id]);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);


            Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.npcForm.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c;
            npc.npcForm.Require_To_Create_The_New_Part__c = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;  
            npc.cancelNPC();
            
            //Checking else condition after update

          
            
            //Checking else condition (condition for GF System Admin)
            npc.npcForm.Owner__c =null;
            npc.userprofilename = null;
            npc.cancelNpc();
            
        test.stopTest(); */
    }

    
    static testmethod void checkDisplayAppRejSection(){ 
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        test.startTest();
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            
            //To display Approve/Reject section for FAE Approval
            npc.npcForm.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE');
            npc.npcForm.Reason_for_New_Part__c = 'New Probe Card Flow';
            npc.npcForm.FAE_Approver_3__c = userinfo.getUserid();
            npc.checkDisplayAppRejSection();
            
            //condition To hide Approve/Reject section for fab to fab transfer
            npc.npcForm.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN'); 
            npc.npcForm.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_CHANGE_PID');
            npc.checkDisplayAppRejSection(); 
              
            


    }
    
    static testMethod void runTest3() {// test method checkNPCFormStatus()
        
        //DataUtilTest.loadEnvironmentVariables();
       /* String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
         test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
       // Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId.id, testOpptyProgramId.id, testNPC.Id);
        
       
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController ctrl = new NPCFormInternalReadOnlyController(sc);
            //condition 1
            ctrl.npcForm.NPC_Form_Status__c = 'Pending Submission';//NPC_STATUS_PEND_SUBMISSION
            ctrl.checkNPCFormStatus();
            
            //condition 3
            ctrl.npcForm.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_PEND_MASK_ADD_FE');
            ctrl.checkNPCFormStatus();
            
            ctrl.npcForm.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_PEND_RESUB').Value__c;
            ctrl.checkNPCFormStatus();
            
            //condition 5
            RecordType rt = [
                SELECT      Id
                            , Name
                FROM        RecordType
                WHERE       Name = 'StatusRejected'
            ];
            
            ctrl.npcForm.RecordTypeId = rt.Id;
            ctrl.checkNPCFormStatus();
            
            //condition 4
            ctrl.npcForm.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN');
            ctrl.npcForm.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_CHANGE_PID');
            ctrl.checkNPCFormStatus();
            
            ctrl.npcForm.NPC_Form_Status__c = 'Executed';
            ctrl.checkNPCFormStatus();
            
            //condition 2
            ctrl.npcForm.NPC_Form_Status__c = 'Pending CE Approval'; //NPC_STATUS_SUBMITTED
            ctrl.userProfileName = 'GF CE';
            ctrl.checkNPCFormStatus();
            
            
        test.stopTest();
    }
    
    /*static testMethod void runTest4() { 
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
         test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm1(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        
        
       
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            //condition 1
            npc.npcForm.Approver_10__c = user.Id;
            npc.npcForm.NPC_Form_Status__c = 'Pending CE Approval'; 
            test.stopTest(); 
            system.runAs(user){
                npc.checkDisplayAppRejSection();
            }
            //condition 3
            npc.npcForm.NPC_Form_Status__c = 'In Execution';
            
            //update npc.npcForm;
            system.runAs(fabApprover){
                npc.checkDisplayAppRejSection();
            }
            
            //condition 2
            npc.npcForm.NPC_Form_Status__c = 'In Execution';
            npc.npcForm.PIYE_Approver_3__c = fabApprover.id;
            npc.npcForm.fab__c = 'Fab 7';
            
            system.runAs(fabApprover){
                npc.checkDisplayAppRejSection();
            }
            
            npc.npcForm.NPC_Form_Status__c = 'In Execution';
            npc.showAppRejSection = false;
            system.runAs(admin){
                npc.checkDisplayAppRejSection();
            }
       
    }*/
    
    
    static testMethod void runTest7() {
        //DataUtilTest.loadEnvironmentVariables();
       /* List<User> users = new List<User>([select id from user where profileId='00e90000001232a']);
        User u1 = users[0];
        User u2 = users[1];  
        user u3 = users[2]; */     
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        String testOpptyPrgmTeamMemberId = NPCFormInternalReadOnlyControllerTest.createOpptyPrgTM(testOpptyProgramId, user);*/
       // Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice3(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        test.startTest();
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm2(testAcctId.id, testDevice.Id);
        //Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        
        
            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
           
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.No_of_Approvers__c = 2;
           
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
                if (p.ActorId == u2.Id) {
                    p.ActorId = u3.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();
            
            testNPC.PIYE_Approver_1__c = u1.Id;
            testNPC.PIYE_Approver_2__c = u2.Id;
            testNPC.No_of_PIYE_Approvers__c = 2;
            update testNPC;
            
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setWorkitemId(newWorkItemIds.get(0));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
            req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());
            
            listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u2.Id) {
                    p.ActorId = u3.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
        //    sc = new ApexPages.standardController(testNPC);
        //    npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();
        test.stopTest();
    }
    
    static testMethod void runTest8() {
        
        //DataUtilTest.loadEnvironmentVariables();
       /* List<User> users = new List<User>([select id from user where profileId='00e90000001232a']);
        User u1 = users[0];
        User u2 = users[1];  
        User u3 = users[2];     
        User u4 = users[3];      */
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        String testOpptyPrgmTeamMemberId = NPCFormInternalReadOnlyControllerTest.createOpptyPrgTM(testOpptyProgramId, user);*/
       // Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice3(testAcctId, testOpptyProgramId);
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm2(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        
        
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
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.No_of_Approvers__c = 3;
            
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
                if (p.ActorId == u3.Id) {
                    p.ActorId = u4.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();
            
            testNPC.PIYE_Approver_1__c = u1.Id;
            testNPC.PIYE_Approver_2__c = u2.Id;
            testNPC.PIYE_Approver_3__c = u3.Id;
            testNPC.No_of_PIYE_Approvers__c = 3;
            update testNPC;
            
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setWorkitemId(newWorkItemIds.get(0));
            Approval.ProcessResult result2 =  Approval.process(req2);
            
            req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());
            
            listWorkItem = new List<ProcessInstanceWorkItem>();
            for (ProcessInstanceWorkItem p : [SELECT     Id
                                                         , ActorId
                                              FROM       ProcessInstanceWorkitem
                                              WHERE      ProcessInstance.TargetObjectId = :testNPC.Id]) {
                if (p.ActorId == u3.Id) {
                    p.ActorId = u4.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
          //  sc = new ApexPages.standardController(testNPC);
          //  npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();
        test.stopTest();
    }
        
    static testMethod void runTest9() {
        //DataUtilTest.loadEnvironmentVariables();
       /* List<User> users = new List<User>([select id from user where profileId='00e90000001232a']);
        User u1 = users[0];
        User u2 = users[1];  
        User u3 = users[2];     
        User u4 = users[3]; 
        User u5 = users[4];      */   
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        String testOpptyPrgmTeamMemberId = NPCFormInternalReadOnlyControllerTest.createOpptyPrgTM(testOpptyProgramId, user);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice3(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        test.startTest();
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm2(testAcctId.id, testDevice.Id);
        //Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        
        
            //List<User> tempList = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'GF CE' LIMIT 1];
            List<User> users = new List<User>();
            
            User u1 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast');
            users.add(u1);
            
            User u2 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast2');
            users.add(u2);
            
            User u3 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast3');
            users.add(u3);
            
            User u4 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast4');
            users.add(u4);
            
            User u5 = createTestUser('00e90000001232a', 'TestFirst', 'TestLast5');
            users.add(u5);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.No_of_Approvers__c = 4;
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
                if (p.ActorId == u4.Id) {
                    p.ActorId = u5.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();
        test.stopTest();
    }
    
    static testMethod void runTest10() {
        //DataUtilTest.loadEnvironmentVariables();
         /*List<User> users = new List<User>([select id from user where profileId='00e90000001232a']);
        User u1 = users[0];
        User u2 = users[1];  
        User u3 = users[2];     
        User u4 = users[3];  
        User u5 = users[4];
        User u6 = users[5]; */       
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        String testOpptyPrgmTeamMemberId = NPCFormInternalReadOnlyControllerTest.createOpptyPrgTM(testOpptyProgramId, user);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice3(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        test.startTest();
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm2(testAcctId.id, testDevice.Id);
        //Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        //Device__c testDevice2 = NPCFormInternalReadOnlyControllerTest.createDevice2(testAcctId, testOpptyProgramId, testNPC.Id);
        
        
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
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Approver_2__c = u2.Id;
            testNPC.Approver_3__c = u3.Id;
            testNPC.Approver_4__c = u4.Id;
            testNPC.Approver_5__c = u5.Id;
            testNPC.No_of_Approvers__c = 5;
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
                if (p.ActorId == u5.Id) {
                    p.ActorId = u6.Id;
                    listWorkItem.add(p);
                }
            }

            update listWorkItem;
            
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.updateApprover();

        test.stopTest();
    }       
    
    static testMethod void runTest11() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm11(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest.createNPCForm12(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        
        
         New_Part_Creation_Form__History h = new New_Part_Creation_Form__History();
                                                  h.ParentId = testNPC.Id;
                                                              h.Field ='Mask_Set_Title__c';
                              insert h;                                
        
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            //npc.submitNPC();
            //npc.apprRej();
            //npc.cloneNpc();
            
            testNPC.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c;
            npc.userProfileName = Environment_Variable__c.getInstance('GF_CE').Value__c;
            npc.npcForm = testNPC;
           // npc.editNPC();
            //npc.cancelNPC() ;
            
            npc.userProfileName = null;
            //npc.editNPC();
            npc.userProfileName = 'GF System Admin';
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT_ADD_ROM').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_PROBE_NEW_CARD').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_FAB_TRANSFER').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_CHANGE_PID').Value__c;
            npc.cancelNPC();
            /*
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c;
            npc.npcForm.Require_To_Create_The_New_Part__c   = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
            npc.cancelNPC();
            */
            
            ApexPages.currentPage().getParameters().put('id', testNPC1.Id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(testNPC1);
            NPCFormInternalReadOnlyController npc1 = new NPCFormInternalReadOnlyController(sc1);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw1 = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            //npc1.submitNPC();
            //npc1.apprRej();
            //npc1.cloneNpc();
        test.stopTest();
    }

    static testMethod void runTest12() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm11(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest.createNPCForm12(testAcctId.id, testDevice.Id);
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest.createNPCMasks(testNPC.Id);
        
        testNPC.Tapeout_Required__c = 'No';
        update testNPC;
        
         New_Part_Creation_Form__History h = new New_Part_Creation_Form__History();
                                                  h.ParentId = testNPC.Id;
                                                              h.Field ='Mask_Set_Title__c';
                              insert h;                                
        
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            //npc.submitNPC();
            //npc.apprRej();
            //npc.cloneNpc();
            
            testNPC.NPC_Form_Status__c = Environment_Variable__c.getInstance('NPC_STATUS_SUBMITTED').Value__c;
            npc.userProfileName = Environment_Variable__c.getInstance('GF_CE').Value__c;
            npc.npcForm = testNPC;
           // npc.editNPC();
            //npc.cancelNPC() ;
            
            npc.userProfileName = null;
            //npc.editNPC();
            npc.userProfileName = 'GF System Admin';
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_STARTINGMATERIAL').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_BACKGROUNDTHICKNESS').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_SHORTLOOP_FLOW').Value__c;
            npc.cancelNPC();
            
            npc.npcForm.Reason_for_New_Part__c  = Environment_Variable__c.getInstance('NPC_REASON_OTHERS').Value__c;
            npc.npcForm.Require_To_Create_The_New_Part__c   = Environment_Variable__c.getInstance('NPC_REQUIRE_TO_CREATE_YES').Value__c;
            npc.cancelNPC();
            
            
            ApexPages.currentPage().getParameters().put('id', testNPC1.Id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(testNPC1);
            NPCFormInternalReadOnlyController npc1 = new NPCFormInternalReadOnlyController(sc1);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw1 = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            //npc1.submitNPC();
            //npc1.apprRej();
            //npc1.cloneNpc();
        test.stopTest();
    }

    static testMethod void runTest13() {
        
        test.startTest();
        
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        //New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest.createNPCForm11(testAcctId.id, testDevice.Id);
        //New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest.createNPCForm12(testAcctId.id, testDevice.Id);
        
        User u = [
            SELECT      Id
            FROM        User
            WHERE       Profile.Name = 'GF CE'
                        AND IsActive = true
            LIMIT 1
        ];
        
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = testAcctId.Id;
        npc.Originating_Device__c = testDevice.Id;
        npc.BASE_Device__c = testDevice.Id;
        npc.New_Part_ID__c = 'NPCTEST1';
        //npc.NPC_Form_Status__c = 'Pending Submission';
        npc.NPC_Form_Status__c = 'Pending CE Approval';
        npc.NPC_Form_Submitted_Date__c = date.today().addDays(-5);
        npc.Reason_for_New_Part__c = Environment_Variable__c.getInstance('NPC_REASON_RETROFIT').Value__c;
        npc.Tapeout_Type__c =  Environment_Variable__c.getInstance('DEVICE_TAPEOUT_TYPE_RETROFIT').Value__c;
        npc.Reference_Id__c = 'ANBQP60ACO8CH-U01';
        npc.Tapeout_Required__c = 'No';
        npc.Approver_1__c = u.Id;
        
        insert npc;
        
        npc.Reason_for_New_Part__c = 'CustomerNameChange';
        npc.NPC_Form_Status__c = 'In Execution';
        
        npc.ECN_Change_Date__c = Date.today();
        update npc;
        
        npc.ECN_Change_Date__c = null;
        update npc;
        
        Test.stopTest();
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