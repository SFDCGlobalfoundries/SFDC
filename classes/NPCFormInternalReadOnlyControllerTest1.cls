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
private class NPCFormInternalReadOnlyControllerTest1 { 

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
        testOpptyProgram.Name = 'Test Opportunity';
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
    
     static New_Part_Creation_Form__c createNPCForm8(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST3';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 7';
        //npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
        npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        npc.STF_Activation_Steps__c = '';
        npc.NPC_Form_Status__c = 'Pending Litho Verification';
        npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');        
        insert npc;        
        return npc;
    }

     static New_Part_Creation_Form__c createNPCForm9(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST3';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 7';
        npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
        npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        npc.STF_Activation_Steps__c = 'Step 2';
        npc.NPC_Form_Status__c = 'Pending Litho Verification';        
        insert npc;        
        return npc;
    }
    
     static New_Part_Creation_Form__c createNPCForm10(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST3';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 7';
        //npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
        npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        npc.STF_Activation_Steps__c = '';
        npc.Assignee_1__c = userinfo.getuserID();
        npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC'); 
        npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');        
        
        insert npc;
        
        return npc;
    }    

    
         static testMethod void runTest1() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest11.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest11.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest11.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest11.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest1.createNPCForm8(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest1.createNPCForm9(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC2 = NPCFormInternalReadOnlyControllerTest1.createNPCForm10(testAcctId.id, testDevice.Id);        
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest1.createNPCMasks(testNPC.Id);
        
        
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
            
 
            ApexPages.currentPage().getParameters().put('id', testNPC2.Id);
            ApexPages.StandardController sc2 = new ApexPages.standardController(testNPC2);
            NPCFormInternalReadOnlyController npc2 = new NPCFormInternalReadOnlyController(sc2);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw2 = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            npc2.submitNPC();
            npc2.apprRej();
            npc2.cloneNpc();
                        
        test.stopTest();
    }

 static New_Part_Creation_Form__c createNPCForm11(Id accountId, Id deviceId) {
    New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
    npc.Account__c = accountId;
    npc.Originating_Device__c = deviceId;
    npc.BASE_Device__c = deviceId;
    npc.New_Part_ID__c = 'NPCTEST3';
    npc.CRM_DID__c = 'CDID12345';
    npc.Fab__c = 'FAB 7';
    npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
    npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');         
    npc.Assignee_1__c = userinfo.getuserID();       
    npc.Planned_Implementation_Date__c = null;
    npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
   // npc.Litho_Validate_Reticle_is_in_GF__c='YES';
   // npc.STF_Activation_Steps__c = '';               
    //npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');                
    insert npc;
    
    return npc;
}   

 static New_Part_Creation_Form__c createNPCForm12(Id accountId, Id deviceId) {
    New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
    npc.Account__c = accountId;
    npc.Originating_Device__c = deviceId;
    npc.BASE_Device__c = deviceId;
    npc.New_Part_ID__c = 'NPCTEST3';
    npc.CRM_DID__c = 'CDID12345';
    npc.Fab__c = 'FAB 7';
    npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
    npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');         
    npc.Assignee_1__c = userinfo.getuserID();       
    npc.Planned_Implementation_Date__c = system.today();
    npc.Mask_Shop_Address__c    = null;
    npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
   // npc.Litho_Validate_Reticle_is_in_GF__c='YES';
   // npc.STF_Activation_Steps__c = '';               
    //npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');                
    insert npc;
    
    return npc;
}
 static New_Part_Creation_Form__c createNPCForm13(Id accountId, Id deviceId) {
    New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
    npc.Account__c = accountId;
    npc.Originating_Device__c = deviceId;
    npc.BASE_Device__c = deviceId;
    npc.New_Part_ID__c = 'NPCTEST3';
    npc.CRM_DID__c = 'CDID12345';
    npc.Fab__c = 'FAB 7';
    npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_Customer');
    npc.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');         
    npc.Assignee_1__c = userinfo.getuserID();       
    npc.Planned_Implementation_Date__c = system.today();
    npc.PI_YE_Update_Status__c = 'Status 1';    
    npc.Actual_Implementation_Date__c =  null;
    npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
   // npc.Litho_Validate_Reticle_is_in_GF__c='YES';
   // npc.STF_Activation_Steps__c = '';               
    //npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');                
    insert npc;
    
    return npc;
}  

 static testMethod void runTest2() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest11.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest11.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest11.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest11.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest1.createNPCForm11(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC1 = NPCFormInternalReadOnlyControllerTest1.createNPCForm12(testAcctId.id, testDevice.Id);
        New_Part_Creation_Form__c testNPC2 = NPCFormInternalReadOnlyControllerTest1.createNPCForm13(testAcctId.id, testDevice.Id);        
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest1.createNPCMasks(testNPC.Id);
        
        
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
            NPCFormInternalReadOnlyController.EmailComponents ew = new NPCFormInternalReadOnlyController.EmailComponents(testNPC);
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
            
 
            ApexPages.currentPage().getParameters().put('id', testNPC2.Id);
            ApexPages.StandardController sc2 = new ApexPages.standardController(testNPC2);
            NPCFormInternalReadOnlyController npc2 = new NPCFormInternalReadOnlyController(sc2);
            NPCFormInternalReadOnlyController.FieldHistoryWrapper fhw2 = new NPCFormInternalReadOnlyController.FieldHistoryWrapper();
            npc2.submitNPC();
            npc2.apprRej();
            npc2.cloneNpc();
                        
        test.stopTest();
    }    
  
static testMethod void runTest5() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest11.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest11.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest11.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest11.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest1.createNPCForm11(testAcctId.id, testDevice.Id);         
                
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest1.createNPCMasks(testNPC.Id);
        
                          
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.PIYE_Approver_1__c = UserInfo.getUserId();
            update testNPC;
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.checkDisplayAppRejSection();           
            
            testNPC.NPC_Form_Status__c = 'Pending Litho Verification';
            testNPC.Assignee_2__c = UserInfo.getUserId();
            update testNPC;
            npc.checkDisplayAppRejSection();

            testNPC.NPC_Form_Status__c = 'Pending AM Approval';
            testNPC.Primary_Device_AM__c = UserInfo.getUserId();            
            update testNPC;
            npc.checkDisplayAppRejSection();

            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
            testNPC.Approver_1__c = UserInfo.getUserId();
            update testNPC;
            npc.checkDisplayAppRejSection();
            
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.PIYE_Approver_1__c = UserInfo.getUserId();
            update testNPC;         
            npc.checkDisplayAppRejSection();
            
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.Approver_1__c = UserInfo.getUserId();
            testNPC.PI_YE_Approval_Status__c = 'Status 1';
            update testNPC;         
            npc.checkDisplayAppRejSection();
            
            
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
    
    // check dispaly button
    

static testMethod void runTest9() {
        
        //DataUtilTest.loadEnvironmentVariables();
        /*String testAcctId = NPCFormInternalReadOnlyControllerTest11.createAccount();
        String testOpptyId = NPCFormInternalReadOnlyControllerTest11.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormInternalReadOnlyControllerTest11.createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice1 = NPCFormInternalReadOnlyControllerTest11.createDevice1(testAcctId, testOpptyProgramId);*/
        Account testAcctId = [Select Id from Account where name = 'MYTEST ACCOUNT1-Test'];
        Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity' limit 1];
        test.startTest();
        Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
        New_Part_Creation_Form__c testNPC = NPCFormInternalReadOnlyControllerTest1.createNPCForm11(testAcctId.id, testDevice.Id);         
                
        Mask__c testMask = NPCFormInternalReadOnlyControllerTest1.createNPCMasks(testNPC.Id);
        
                          
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.PIYE_Approver_1__c = UserInfo.getUserId();
            update testNPC;
            PageReference pageRef = Page.NPCFormInternalReadOnlyVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc = new NPCFormInternalReadOnlyController(sc);
            npc.checkDisplayAppRejSection();           
            
            testNPC.NPC_Form_Status__c = 'Pending Litho Verification';
            testNPC.Assignee_2__c = UserInfo.getUserId();
            update testNPC;
            ApexPages.StandardController sc1 = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc2 = new NPCFormInternalReadOnlyController(sc1);
            npc.checkDisplayAppRejSection();              

            testNPC.NPC_Form_Status__c = 'Pending AM Approval';
            testNPC.Primary_Device_AM__c = UserInfo.getUserId();            
            update testNPC;
            ApexPages.StandardController sc2 = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc3 = new NPCFormInternalReadOnlyController(sc2);
            npc.checkDisplayAppRejSection();            

            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_SUBMITTED');
            testNPC.Approver_1__c = UserInfo.getUserId();
            update testNPC;
            ApexPages.StandardController sc3 = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc4 = new NPCFormInternalReadOnlyController(sc3);
            npc.checkDisplayAppRejSection();            
            
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.PIYE_Approver_1__c = UserInfo.getUserId();
            update testNPC;         
            ApexPages.StandardController sc4 = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc5 = new NPCFormInternalReadOnlyController(sc4);
            npc.checkDisplayAppRejSection();      
            
            
            testNPC.NPC_Form_Status__c = EnvironmentVariable.get('NPC_STATUS_IN_EXEC');
            testNPC.Approver_1__c = UserInfo.getUserId();
            testNPC.PI_YE_Approval_Status__c = 'Status 1';
            update testNPC;         
            ApexPages.StandardController sc5 = new ApexPages.standardController(testNPC);
            NPCFormInternalReadOnlyController npc6 = new NPCFormInternalReadOnlyController(sc5);
            npc.checkDisplayAppRejSection();                  
            
            
        test.stopTest();
    }   
    
}