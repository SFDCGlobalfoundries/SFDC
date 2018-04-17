/*
    Author: Cognizant
    Description: This serves as the test class for NPCFormAssigneApprProcessController class.

*/ 

@isTest(SeeAllData=false)
public class NPCFormAssigneApprProcessControllerTest2 {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        //Environment_Variable__c tu=new Environment_Variable__c(Name='NPC_REASON_STF',Value__c='Device Reactivation');
        //insert tu;
        Environment_Variable__c ev = [SELECT ID,Value__c FROM Environment_Variable__c WHERE Name =: 'NPC_REASON_STF'];
            ev.Value__c = 'Device Reactivation';
            update ev;
        
        
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
    
    static List<User> getUserList3(){
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
                        AND Fab_Assigned__c INCLUDES ('FAB 5')
            ];
            
        return listUser;
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
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
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
        //device.Device_Mask_Set_Title__c = 'MSTTRT';
        device.CRMDID__c = 'CDID0000001.00';
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
        npc.New_Part_ID__c = 'NPCTEST3';
        npc.CRM_DID__c = 'CDID12345';
        npc.Fab__c = 'FAB 7';
        npc.Is_reticle_available__c = EnvironmentVariable.get('NPC_STF_Reticle_GF');
        npc.Reason_for_New_Part__c = EnvironmentVariable.get('NPC_REASON_STF');
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        
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
        npc.Litho_Validate_Reticle_is_in_GF__c='NO';
        npc.Is_reticle_available__c='Yes,at GF';
       // npc.No_of_PIYE_Approvers__c=1;
        insert npc;
        
        return npc;
    }
    
    
    
    static New_Part_Creation_Form__c createNPCForm2(Id accountId, Id deviceId) {
        List<User> usrList = NPCFormAssigneApprProcessControllerTest2.getUserList3();
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST2';
        npc.CRM_DID__c = 'CDID12341';
        npc.Fab__c = 'FAB 5';
        npc.Reason_for_New_Part__c='Device Reactivation';
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        npc.Is_reticle_available__c='Yes,at GF';
        npc.No_of_PIYE_Approvers__c=1;
        npc.Assignee_1__c = usrList[0].Id;
        npc.Assignee_2__c = usrList[0].Id;
        npc.No_of_PI_YE_Assignes__c = 1;
        npc.Planned_Implementation_Date__c=date.today();
        npc.Actual_Implementation_Date__c=date.today(); 
        insert npc;
        
        return npc;
    }
    
    static New_Part_Creation_Form__c createNPCForm3(Id accountId, Id deviceId) {
        List<User> usrList = NPCFormAssigneApprProcessControllerTest2.getUserList3();
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST7';
        npc.Reason_for_New_Part__c='Device Reactivation';
        npc.CRM_DID__c = 'CDID12346';
        npc.Fab__c = 'FAB 5';
        npc.Litho_Validate_Reticle_is_in_GF__c='YES';
        npc.Is_reticle_available__c='Yes,at GF';
        npc.No_of_PIYE_Approvers__c=1;
        npc.Assignee_1__c = usrList[0].Id;
        npc.Assignee_2__c = usrList[0].Id;
        npc.No_of_PI_YE_Assignes__c = 2; 
        insert npc;
        
        return npc;
    }   
    
     static New_Part_Creation_Form__c createNPCForm4(Id accountId, Id deviceId) {
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
    
  /*  static Id createNPCMasks(Id npcId) {
        Mask__c m = new Mask__c();
        m.New_Part_Creation_Form__c = npcId;
        m.Layer__c = 'TestLayer';
        m.Modified_Mask__c = 'TestLayerMask';
        m.Original_Mask__c = 'TestLayerMask';
        
        insert m;
        
        return m.Id;
    }*/
    
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
    
    static User createUsers(){
       // List<user> userList = new List<user>();
      //  for(integer i=1;i<=no;i++){
                User testUser = new User();
                testUser.alias = 'ts';
                testUser.email='testing@test3.com';
                testUser.emailencodingkey='UTF-8';
                testUser.lastname='TestLast';
                testUser.firstname='TestFirst';
                testUser.languagelocalekey='en_US';
                testUser.localesidkey='en_US';
                testUser.profileid = '00e90000001232a';
                testUser.timezonesidkey='America/Los_Angeles';
                testUser.username='testing@NPCtest2.com';
                testUser.communitynickname='tsasd';
                testUser.FederationIdentifier='Test2014asd';
                testUser.isActive=true;
        insert testUser;
        return testUser;
    }
    
    static Account_Team_Proxy__c createActprxy(Id testAcctId, Id testUserId) {
    Account_Team_Proxy__c testAccttp = new Account_Team_Proxy__c();
      testAccttp.Account__c= testAcctId; 
      testAccttp.User__c=testUserId;
      testAccttp.Team_Role__c='Backup Customer Service Rep';
      testAccttp.Account_Access__c='Read/Write';
        Insert testAccttp;
        return testAccttp;
    }
    
    static Account_Team_Proxy__c createActprxy2(Id testAcctId, Id testUserId) {
    Account_Team_Proxy__c testAccttp2 = new Account_Team_Proxy__c();
      testAccttp2.Account__c= testAcctId; 
      testAccttp2.User__c=testUserId;
      testAccttp2.Team_Role__c='Primary Customer Service Rep';
      testAccttp2.Account_Access__c='Read/Write';
        Insert testAccttp2;
        return testAccttp2;
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
    
    static List<Account_Team_Proxy__c> getActpList3(){
         String testAcctId = NPCFormAssigneApprProcessControllerTest2.createAccount();       
        List<Account_Team_Proxy__c> listActp = [
            SELECT      Id
            FROM        Account_Team_Proxy__c
            WHERE       Account__c= :testAcctId
                        AND Team_Role__c='Primary Customer Service Rep'
            ];
            
        return listActp;
    }
    
    static testMethod void testNPCFormAssigneApprProcessController1(){ 
       User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

              
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Unqualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        update account;
        String testAcctId = ''+account.ID;        
        String testOpptyId = NPCFormAssigneApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormAssigneApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        test.startTest();
            // Device__c testDevice = [Select Id,Device_Mask_Set_Title__c from Device__c where name = 'TESTDEVICEZAIH12345677'];
            List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
            Device__c testDevice = InternalDeviceTestUtil.createDevice('TestInternalDevice1', 'Fab 3', 'Design In', 'Active', '100', System.today(), 
                                                                '11111111111', 'Single Product',  testAcctId, '0.028UM', 'Super Low Power');
            if(!deviceRecTypeList.isEmpty()){                       
                testDevice.RecordTypeId = deviceRecTypeList[0].Id;
            } 
            testDevice.Device_Mask_Set_Title__c ='VMSTML';
            testDevice.Enabled_via_previous_MPW_1__c ='No';
            testDevice.Reticle_Type__c ='Multi Layer Reticle (MLR)';
            testDevice.Device_type__C = 'Base';            
            
            insert testDevice;
                                   
            New_Part_Creation_Form__c testNPC =NPCFormAssigneApprProcessControllerTest2.createNPCForm(testAcctId, testDevice.ID);
            User testUser = NPCFormAssigneApprProcessControllerTest2.createUsers();
            Account_Team_Proxy__c testACTP = NPCFormAssigneApprProcessControllerTest2.createActprxy(testAcctId,testUser.Id);        
            PageReference pageRef  = Page.NPCFormInternalReadOnlyVF;
            PageReference pageRef2 = Page.NPCPIYUpdate;
            PageReference pageRef3 = Page.NPCPIYUpdate;
            
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('deviceId', testDevice.Id);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            ApexPages.currentPage().getHeaders().put('referer', 'NPCPIYUpdate');
            ApexPages.currentPage().getHeaders().put('referer', 'NPCPIYUpdate');
            List<User> users = new List<User>();
            User u1 = new User(
                alias = 'ts', 
                email='testing@test.com',
                emailencodingkey='UTF-8', 
                lastname='TestLast', 
                firstname='TestFirst', 
                languagelocalekey='en_US',
                localesidkey='en_US', 
                profileid = '00e90000001232a',
                timezonesidkey='America/Los_Angeles', 
                username='testing11@NPCtest.com',
                communitynickname='ts',
                FederationIdentifier='Test2014'
                //Manager='test manager1'
            );
            users.add(u1);
            
            insert users;
            
            testNPC.NPC_Form_Status__c = 'Pending Submission';
            testNPC.Approver_1__c = u1.Id;
            testNPC.Assignee_1__c = testACTP.User__c;
            testNPC.Assignee_2__c = testACTP.User__c;
            testNPC.Primary_Device_AM__c = testACTP.User__c;
            testNPC.No_of_AM_Approvers__c = 1;
            testNPC.Planned_Implementation_Date__c = system.today();
            testNPC.Actual_Implementation_Date__c = system.today();
                        
            //testNPC.BASE_Device__c = testDevice.Id;
            update testNPC;
            system.debug('****testNPC***'+testNPC);
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(result.isSuccess());
            System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status' + result.getInstanceStatus());
            
            List<ProcessInstanceWorkItem> listWorkItem = [
                SELECT     Id
                           , ProcessInstance.Status
                           , ProcessInstance.TargetObjectId
                           , ProcessInstanceId
                           , OriginalActorId
                           , ActorId
                           , Actor.Name
                           , Actor.Type
                FROM       ProcessInstanceWorkitem 
                WHERE      ProcessInstance.TargetObjectId = :testNPC.Id
                ORDER BY   Id limit 1
            ];
            
            listWorkItem[0].ActorId = u1.Id;
            update listWorkItem;
                        
            ApexPages.StandardController sc = new ApexPages.standardController(testNPC);
            NPCFormAssigneApprProcessController npc = new NPCFormAssigneApprProcessController();

            
            testNPC.Approver_1__c = u1.Id;
            testNPC.No_of_PIYE_Approvers__c = 1;
            update testNPC;
            npc.getWorkItemId(testNPC.Id);
            npc.rejectNPC();
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setWorkitemId(newWorkItemIds.get(0));            
            req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(testNPC.Id);
           
            npc.approveNPC();
            sc = new ApexPages.standardController(testNPC);
            npc.isPIYEApproval=true;
            npc.comments='sdfsdf';     
            npc.npcFabCheck=true;
            
            npc.cancelNPC();         
           }
        test.stopTest();
    
    }
    
    static testMethod void testNPCReject(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormAssigneApprProcessControllerTest2.getUserList2();
        String testAcctId = NPCFormAssigneApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormAssigneApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormAssigneApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormAssigneApprProcessControllerTest2.createNPCForm1(testAcctId, testDevice.Id);
            NPCFormAssigneApprProcessControllerTest2.createOpportunityProgramTeamMembers(testOpptyProgramId,usrList[0].Id);
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
            NPCFormAssigneApprProcessController n = new NPCFormAssigneApprProcessController();
            
            n.approveNPC();
            
            NPCFormAssigneApprProcessController npcMultiApp = new NPCFormAssigneApprProcessController();
            npcMultiApp.comments = 'rejected';
            PageReference pgRef = npcMultiApp.rejectNPC();
            system.assert(pgRef!=null);
            
        test.stopTest();
    }
    
    static testMethod void testNPCApproveByCE3(){
        //DataUtilTest.loadEnvironmentVariables();
        List<User> usrList = NPCFormAssigneApprProcessControllerTest2.getUserList1();
        String testAcctId = NPCFormAssigneApprProcessControllerTest2.createAccount();
        String testOpptyId = NPCFormAssigneApprProcessControllerTest2.createOpportunity(testAcctId);
        String testOpptyProgramId = NPCFormAssigneApprProcessControllerTest2.createOpportunityProgram(testAcctId, testOpptyId);
        
        test.startTest();
            Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew1(testAcctId, testOpptyId, testOpptyProgramId);
            New_Part_Creation_Form__c testNPC = NPCFormAssigneApprProcessControllerTest2.createNPCForm(testAcctId, testDevice.Id);
            NPCFormAssigneApprProcessControllerTest2.createOpportunityProgramTeamMembers1(3, testOpptyProgramId);
        
            PageReference pageRef = Page.NPCFormVF;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('id', testNPC.Id);
           // ApexPages.currentPage().getHeaders().put('referer', 'NPCPIYUpdate');
          //  ApexPages.currentPage().getHeaders().put('referer', 'NPCPIYUpdate');
            NPCFormAssigneApprProcessController n = new NPCFormAssigneApprProcessController();
            
            n.approveNPC();
            
            NPCFormAssigneApprProcessController npcMultiApp = new NPCFormAssigneApprProcessController();
            npcMultiApp.npcForm.Approver_1__c = usrList[0].Id;
            npcMultiApp.npcForm.Approver_2__c = usrList[0].Id;
            npcMultiApp.npcForm.Assignee_1__c  = usrList[0].Id;
            npcMultiApp.npcForm.Assignee_2__c  = usrList[0].Id;
            PageReference pgRef = npcMultiApp.approveNPC();
           // system.assert(pgRef!=null);
            
        test.stopTest();
    }            
}