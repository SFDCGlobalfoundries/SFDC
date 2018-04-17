/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_ReticleDatawarehousehelper
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.
        ZAmbat         07/19/2014           Added Environment Variables to fix deployment issue.
**/

@isTest(SEEALLDATA = false)
private class ROS_ReticleDatawarehousehelper_Test {
     static String Cycle;
     static User CSRuser;
     static String fab;
     
     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();        
        
    }
    
    static void createROSQueryDataSettings() {
        List<SObject> lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType,'TestROSQueryUCData');
    }
    
    static void createHCMEmplyee(){
        List<HCM_Employee__c> lstHCMEmployee = new List<HCM_Employee__c >();
        
        HCM_Employee__c hcmEmp= new HCM_Employee__c();
        hcmEmp.Login_ID__c = 'testHCM';
        hcmEmp.Last_Name__c = 'TestCSRUser';
        hcmEmp.First_Name__c = 'Test';
        hcmEmp.Department_Name__c =  'IT';
        hcmEmp.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmp.Job_Title__c = 'TestTitle';
        hcmEmp.Phone_Number__c =  '999999999';
        hcmEmp.Employee_ID__c = '123456';
        lstHCMEmployee.add(hcmEmp);
        
        HCM_Employee__c hcmEmp2= new HCM_Employee__c();
        hcmEmp2.Login_ID__c = 'testHCM2';
        hcmEmp2.Last_Name__c = 'TestUser';
        hcmEmp2.First_Name__c = 'Test';
        hcmEmp2.Department_Name__c =  'IT';
        hcmEmp2.Email_Address__c = 'testAdminUser@test.com';
        hcmEmp2.Job_Title__c = 'TestTitle';
        hcmEmp2.Phone_Number__c =  '999999998';
        hcmEmp2.Employee_ID__c = '222222';
        lstHCMEmployee.add(hcmEmp2);
        
        HCM_Employee__c hcmEmp3= new HCM_Employee__c();
        hcmEmp3.Login_ID__c = 'testHCM3';
        hcmEmp3.Last_Name__c = 'TestSolutionUser';
        hcmEmp3.First_Name__c = 'Test';
        hcmEmp3.Department_Name__c =  'IT';
        hcmEmp3.Email_Address__c = 'testSolutionUser@test.com';
        hcmEmp3.Job_Title__c = 'TestTitle';
        hcmEmp3.Phone_Number__c =  '999999997';
        hcmEmp3.Employee_ID__c = '111111';
        lstHCMEmployee.add(hcmEmp3);
        
        insert lstHCMEmployee;
    }
    
    static void createCRMDIDSettings(){
        List<CRMDID__c> lstCRMDID = new List<CRMDID__c>();
        lstCRMDID.add(ROS_ReticleDatawarehousehelper_Test.assignCRMDID('CRMDID_No',15908));
        insert lstCRMDID;
    }
    
    static CRMDID__c assignCRMDID(String name,Decimal crmdid){
        CRMDID__c crddidRec = new CRMDID__c();
        crddidRec.name = name;
        crddidRec.CRMDID_No__c = crmdid;
        return crddidRec;
    }
    
    
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    static User createAdminUser(){
        
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        //User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='System Administrator') and IsActive=true and Fab_Assigned__c != null limit 1];
        User usr1 = new User();           
        usr1.Alias= 'testAdm';
        usr1.Email= 'testAdmin@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testAdminUser@test.com';  
        usr1.Fab_Assigned__c = 'FAB 1';
        usr1.IsActive = true;
        usr1.FederationIdentifier = '222222';
        insert(usr1);
        return usr1;
    }
    
   
    static User createCSRUser(){
        //User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
        //HCM_Employee__c  hcmEmployee = ROS_ReticleDatawarehousehelper_Test.createHCMEmplyee();
        Profile systemCSRProfile = [select id from Profile where name = 'GF CSR'];
        User usr1 = new User();           
        usr1.Alias= 'testCSR';
        usr1.Email= 'tesCSR@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.LastName = 'TestCSRUser';
        usr1.FirstName = 'Test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemCSRProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testCSRnUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.IsActive = true;
        usr1.FederationIdentifier = '123456';
        insert(usr1);
        return usr1;
    }
    
    static user CraeteSolutionteam(){
        //User usr1 = [select id,name,email from User where Profile.name = 'System Administrator' and IsActive=true and Id in (SELECT UserOrGroupId FROM GroupMember where Group.Name = 'WWMS ROS Team') limit 1];
        Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
        User usr1 = new User();           
        usr1.Alias= 'testSol';
        usr1.Email= 'testSolutionUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.FirstName = 'Test';
        usr1.LastName = 'TestSolutionUser';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemAdminProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testSolutionUsergfTest@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.FederationIdentifier = '111111';
        usr1.IsActive = true;
        insert(usr1);
        return usr1;        
    }

    // Creation of an Group and GroupMember
    static Group createGroup(){        
        Group retcileOwner = new Group();
        retcileOwner.Name = 'WWMS ROS Team';
        retcileOwner.DeveloperName = 'WWMS_ROS_Team';
        INSERT retcileOwner;
        return retcileOwner;
    }
    
    //Creation of Group Member
    static GroupMember createGroupMember(String groupId,String userId){
        GroupMember gm= new GroupMember();
        gm.GroupId= groupId;
        gm.UserOrGroupId = userId;
        insert gm;     
        return gm;   
    }
            
    // Creation of an Account
    static Account createAccount(){
         Account acc= new Account();
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
        acc= AccountDataFactory.createAccount(fieldValueMap);
        return acc;
    }
    
    // Creation of an Account
    static Id createAccount1(){
        Account acc= new Account();
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
        acc= AccountDataFactory.createAccount(fieldValueMap);
        
        return acc.Id;
    }
    
    static Id createShippingAddress(String AccountId){
        Shipping_Address__c shipAddress=new Shipping_Address__c(Account__c=AccountId,Address1__c='test',Address2__c='Test',Shipping_Country__c='Country',Shipping_State__c='State',zip_code__c='11111');
        insert shipAddress;
        return shipAddress.Id;
    }
    
    static id createFab(){
        FAB__c FB = new FAB__c(Name='FAB 3');
        insert FB;
        return FB.id;   
    }
    
    static User createFabUser(string FABId,String UserId){
            Fab_User__c FUser = new Fab_User__c(Fab__c =Fabid,user__c=userid,Is_ROS_User__c=true);
            insert FUser;
            User u=[Select Id,name from User where id=:Fuser.User__c];
            return u;
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(String AccountId,String UserId,string Role){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = UserId,Sequence_No__c='1',
                                                              Account_Role_ID__c='test',Account__c=AccountId ,Account_Access__c='Read/Write',
                                                              Opportunity_Access__c='Read/Write',Team_Role__c=Role,
                                                              fab_assignment__c = 'FAB 3');
       
        insert atp;
        return atp;
    }
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of an opportunity program
    static Id createOppProg(Id acctId,Id oppId){
        Opportunity_Program__c opProg = new Opportunity_Program__c(Name='Test OppProg',Account__c=acctId,Opportunity__c=oppId);
        insert opProg;
        return opProg.Id;
    }
    
    // Creation of an opportunity program team member
    static Opportunity_Program_Team_Member__c createOppProgTmMem(Id oppProgId, Id userId){
        Opportunity_Program_Team_Member__c oppProgTM = new Opportunity_Program_Team_Member__c(Core_Team_Member__c=false,
                                        Device_Access__c='Read/Write',Opportunity_Program_Access__c='Read/Write',
                                        Opportunity_Program__c=oppProgId,Team_Role__c='Field Application Engineer',
                                        User__c=userId,Flag_for_Delete__c=false);
        insert oppProgTM;
        return oppProgTM;
    }
     
    // Creation of Device
    static Device__c createDevice(Id accId, Id oppId, Id oppProgId){
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','34E21SA-75AZZZ'); 
        fieldValueMap.put('Stage__c','Solutioning'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Account__c',accId); 
        fieldValueMap.put('Opportunity2__c',oppId); 
        fieldValueMap.put('Opportunity_Program__c',oppProgId); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Regulator'); 
        fieldValueMap.put('End_Application__c','Body'); 
        fieldValueMap.put('Device_Sourcing__c','3rd Source'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('Siebel_Device_ID__c','0987654321'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1'); 
        fieldValueMap.put('IP_Gap__c',false); 
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20)); 
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4)); 
        fieldValueMap.put('Configuration_Status__c','PROCESS FLOW ACCEPTED'); 
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
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
    static Id createReticleDatawareHouse(Integer DayInactive,String RetcileId) {
      
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
        
        DW.Customer_ID__c= 'CIRRUS';
        DW.CustomerDevice_ID__c = '1313AA-U01';
        DW.FAB__c = 'FAB 3';
        DW.GlobalFoundries_DeviceID__c = '1313AA-U01';
        DW.InactiveDay__c = DayInactive;
        DW.Region_Name__c = 'US';
        DW.Reticle_Status__c = '';
        DW.Reticle_Type__c = 'BINARY';   
        DW.Name = RetcileId;
        insert DW;
        return DW.Id;
    }  
    static Id createReticleCycle() {
        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
    }
    static Id createReticleDevice(String RetcileId){
        Reticle_Device__c RD = new Reticle_Device__c(Reticle__c =RetcileId,CRM_Device_ID__c='1313AA-U011',
                                                        GF_Device_Id__c='1313AA-U011',
                                                        Global_foundries_device_Id__c='1313AA-U011');
        insert RD;
        return RD.Id;
    }  
    static Id createReticleFab(String RetcileId,String fabId){
        Fab_Reticle__c RD = new Fab_Reticle__c(Reticle__c =RetcileId,fab__C=fabId);
        insert RD;
        return RD.Id;
    }
    
    static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.GlobalFoundries_Device_ID__c= '1313AA-05AZ1';
        RT.Device_ID__c               = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }
    
    static Reticle__c createReticle1(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = 'Test';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        insert RT;
        return RT;
    }    
    
    static void prepareData(){
        
        ROS_ReticleDatawarehousehelper_Test.createROSQueryDataSettings();
        ROS_ReticleDatawarehousehelper_Test.createHCMEmplyee();
        Cycle = ROS_ReticleDatawarehousehelper_Test.createReticleCycle();
        CSRuser = ROS_ReticleDatawarehousehelper_Test.createCSRUser();
        fab = ROS_ReticleDatawarehousehelper_Test.createFab();
    }
    static testMethod void methodROS_createMapIdPortalUsers() {
        ManagerUpdater.executed = true;
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=a.Id;
       update env;
       
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
       
        System.runAs (thisUser) {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Contact c= new Contact();
            c.firstname = 'test';
            c.lastname = 'test2';
            c.email = 'test@test.com';
            c.AccountId = A.Id; 
            insert c;
            
            List<Contact> lstContact = new List<Contact>();
            lstContact.add(c);
            Map<Id,List<Contact>> MIdContacts = new Map<Id,List<Contact>>();
            MIdContacts.put(RT.Id,lstContact);
            ROS_ReticleDatawarehousehelper.createMapIdPortalUsers(MIdContacts);
        Test.stopTest();
    }
    
    static testMethod void methodROS_ROS_ReticleDatawarehousehelper() {
        ManagerUpdater.executed = true;
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=a.Id;
       update env;
       
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            UserIds.add(userinfo.getuserid());
            RS.add(RT);
            Set<Reticle__share> RS1 = ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs_1(RT.Id,UserIds,'Edit','');
            //ROS_ReticleDatawarehousehelper.SharingRecordswithFabUsers(RS);
        Test.stopTest();
    }
    
    static testMethod void methodROS_SharingRecordswithContacts() {
        ManagerUpdater.executed = true;
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=a.Id;
       update env;
       
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs (thisUser) {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Map<Id,Set<Id>> mapIdSetUserId = new Map<Id,Set<Id>>();
            mapIdSetUserId.put(RT.Id,UserIds);
            List<Reticle__share> RS1 = ROS_ReticleDatawarehousehelper.SharingRecordswithContacts(mapIdSetUserId);
        Test.stopTest();
    }
    
    static testMethod void methodROS_SharingRecordswithCSRs() {
        ManagerUpdater.executed = true;
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=a.Id;
       update env;
       
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Account_Team_Proxy__c atpRec = createAccountTeamProxy(A.Id,CSRUser.Id,'Customer Service Rep');
            List<Account_Team_Proxy__c> lstAtp = new List<Account_Team_Proxy__c >();
            lstAtp.add(atpRec );
            Map<Id,List<Account_Team_Proxy__c>> mapIdlstATP = new Map<Id,List<Account_Team_Proxy__c>>();
            mapIdlstATP.put(RT.Id,lstAtp);
            ROS_ReticleDatawarehousehelper.SharingRecordswithCSRs(mapIdlstATP);
        Test.stopTest();
    }
    /*
    static testMethod void methodROS_RemoveSharingRecordsFabUsers() {
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Map<Id,List<ID>> mapIdLstId = new Map<Id,List<ID>>();
            List<Id> lstUserIds =new List<Id>();
            lstUserIds.addAll(UserIds);
            mapIdLstId.put(RT.id,lstUserIds);
            
            Fab_User__c fbUser = new Fab_User__c();
            fbUser.FAB__c = fab;
            fbUser.Is_ROS_User__c = true;
            fbUser.User__c = CSRuser.Id;
            insert fbUser;
            
            List<Fab_User__c> fabUsers = new List<Fab_User__c>();
            fabUsers.add(fbUser);
            List<Reticle__Share> lstRetShare = [select id,UserorGroupId,ParentId from Reticle__Share where parentId = :RT.Id];
            ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsers(RT.Id,mapIdLstId,fabUsers,lstRetShare);
        Test.stopTest();
    }
    */
    /*
    static testMethod void methodROS_RemoveSharingRecordsFabUsersNew() {
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Map<Id,List<ID>> mapIdLstId = new Map<Id,List<ID>>();
            List<Id> lstUserIds =new List<Id>();
            lstUserIds.addAll(UserIds);
            mapIdLstId.put(RT.id,lstUserIds);
            
            Fab_User__c fbUser = new Fab_User__c();
            fbUser.FAB__c = fab;
            fbUser.Is_ROS_User__c = true;
            fbUser.User__c = CSRuser.Id;
            insert fbUser;
            
            List<Fab_User__c> fabUsers = new List<Fab_User__c>();
            fabUsers.add(fbUser);
            List<Reticle__Share> lstRetShare = [select id,UserorGroupId,ParentId from Reticle__Share where parentId = :RT.Id];
            ROS_ReticleDatawarehousehelper.RemoveSharingRecordsFabUsersNew(RT.Id,mapIdLstId,fabUsers,lstRetShare);
        Test.stopTest();
    }
    */
    /*
    static testMethod void methodROS_SharingRecordswithFabUser() {
        prepareData();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
            User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
            GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        Account A = ROS_ReticleDatawarehousehelper_Test.createAccount();
        
        Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(A.Id, Cycle, 500, CSRuser.id);
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;

            Set<id> UserIds = new Set<Id>();
            List<Reticle__c> RS = new List<Reticle__c>();
            UserIds.add(CSRuser.Id);
            RS.add(RT);
            
            Map<Id,List<ID>> mapIdLstId = new Map<Id,List<ID>>();
            List<Id> lstUserIds =new List<Id>();
            lstUserIds.addAll(UserIds);
            mapIdLstId.put(RT.id,lstUserIds);
            
            Fab_User__c fbUser = new Fab_User__c();
            fbUser.FAB__c = fab;
            fbUser.Is_ROS_User__c = true;
            fbUser.User__c = CSRuser.Id;
            insert fbUser;
            
            List<Fab_User__c> fabUsers = new List<Fab_User__c>();
            fabUsers.add(fbUser);
            List<Reticle__Share> lstRetShare = [select id,UserorGroupId,ParentId from Reticle__Share where parentId = :RT.Id];
            ROS_ReticleDatawarehousehelper.SharingRecordswithFabUser(RT.Id,mapIdLstId,fabUsers,'Read','Sharing with FAB Users');
        Test.stopTest();
    }
    */
    static testMethod void methodROS_createdevicereticles() {
        ManagerUpdater.executed = true;
        String acctId;
        acctId = ROS_ReticleDatawarehousehelper_Test.createAccount1();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=acctId;
       update env;
       
        prepareData();
        
        
           
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser) {
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
                insert skipUser;
                Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
                User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
                GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
            }        
            //Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Test.stopTest(); 
            Test.startTest();
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(acctId, Cycle, 500, CSRuser.id);
            
            
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            //Test.startTest();
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            
            String oppId = ROS_ReticleDatawarehousehelper_Test.createOpp(acctId);
            String oppProgId = ROS_ReticleDatawarehousehelper_Test.createOppProg(acctId, oppId);
            //Test.stopTest();
            Opportunity_Program_Team_Member__c oppProgTM = ROS_ReticleDatawarehousehelper_Test.createOppProgTmMem(oppProgId, CSRuser.Id);  
           
            //Device__c dev = ROS_ReticleDatawarehousehelper_Test.createDevice(acctId,oppId,oppProgId);
            /*Device__c dev = DeviceUtilTest.createCMPWDevice(acctId, oppProgId);
            dev.Opportunity2__c = oppId;
            dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            insert dev;*/
            //Test.stopTest();
            //Test.startTest();
            Device__c dev = DeviceUtilTest.createCustomerMPWDeviceNew1(acctId,oppId,oppProgId);
             Test.stopTest();
            map<String,Device__c> mapReticleIdDevice = new map<String,Device__c>();
            mapReticleIdDevice.put('1313AA-05AZ1',dev);
            
            Map<Id,Set<String>> MNewDeviceReticles = new Map<Id,Set<String>>();
            Set<String> setDev = new Set<String>();
            setDev.add('1313AA-05AZ1,1313AA-05AZ1');
            MNewDeviceReticles.put(RT.Id,setDev);
            //Test.stopTest();
            //ROS_ReticleDatawarehousehelper.createdevicereticles(MNewDeviceReticles,mapReticleIdDevice);
            
    }
    
    static testMethod void methodROS_createfabreticles() {
        ManagerUpdater.executed = true;
        string acctId;
        acctId = ROS_ReticleDatawarehousehelper_Test.createAccount1();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=acctId;
       update env;
       
        prepareData();
        
        //Test.startTest();
            
            User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
            System.runAs (thisUser) {
                IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
                insert skipUser;
                Group groupGSM = ROS_ReticleDatawarehousehelper_Test.createGroup();        
                User SolutionUser = ROS_ReticleDatawarehousehelper_Test.CraeteSolutionteam();
                GroupMember gm = ROS_ReticleDatawarehousehelper_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
            }        
            Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Test.stopTest();  
            
            Reticle__c RT = ROS_ReticleDatawarehousehelper_Test.createReticle(acctId, Cycle, 500, CSRuser.id);
            
            Test.startTest();
            String Devid = ROS_ReticleDatawarehousehelper_Test.createReticleDevice(RT.Id);
            String Fabid = ROS_ReticleDatawarehousehelper_Test.createReticleFab(RT.Id, fab);
            //Test.stopTest(); 
            String oppId = ROS_ReticleDatawarehousehelper_Test.createOpp(acctId);
            String oppProgId = ROS_ReticleDatawarehousehelper_Test.createOppProg(acctId, oppId);
            Opportunity_Program_Team_Member__c oppProgTM = ROS_ReticleDatawarehousehelper_Test.createOppProgTmMem(oppProgId, CSRuser.Id);  
            //Device__c dev = ROS_ReticleDatawarehousehelper_Test.createDevice(acctId,oppId,oppProgId);
            
            /*Device__c dev = DeviceUtilTest.createCMPWDevice(acctId, oppProgId);
            dev.Opportunity2__c = oppId;
            dev.IP_Gap__c = false;
            dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            insert dev;*/
            
            Device__c dev = DeviceUtilTest.createCustomerMPWDeviceNew1(acctId,oppId,oppProgId);
            
            Map<Id,Set<String>> MInsertReticles = new Map<Id,Set<String>>();
            Set<String> setFabs = new Set<String>();
            setFabs.add('FAB 3');
            MInsertReticles.put(RT.id,setFabs);
            
            ROS_ReticleDatawarehousehelper.createfabreticles(MInsertReticles);
           Test.stopTest(); 
    }
    
}