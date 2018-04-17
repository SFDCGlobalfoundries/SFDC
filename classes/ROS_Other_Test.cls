/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for Triggers
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    02/24/2014           Test class created.
**/
 
@isTest(SeeAllData = false)
private class ROS_Other_Test {
    @testSetup static void testdata() {
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
  bl.Name = 'Update Bill To Address No';
  bl.Bill_To_Address_Number__c = 2072;
  insert bl;
  Environment_Variable__c envvar1 = new Environment_Variable__c(Name = 'ROS_EUCForm_Table_Headers', Value__c = 'Product Description;Product Code;HS Code;Brand;Model;Quantity;Value;');
  Environment_Variable__c envvar2 = new Environment_Variable__c(Name = 'ROS_EUCForm_Fabs', Value__c = 'FAB 2;FAB 3;FAB 3E;FAB 5;FAB 6;FAB 7');
  Environment_Variable__c envvar3 = new Environment_Variable__c(Name = 'SIEBEL_OPPTY_ID_SEQUENCE_NO', Value__c = '34342');
  Environment_Variable__c envvar4 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_HS_Code_Assign', Value__c = 'Pending HS Code Assignment');
  Environment_Variable__c envvar5 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_Wit_Arriv_Date', Value__c = 'Pending Witness Arrival Date');
  Environment_Variable__c envvar6 = new Environment_Variable__c(Name = 'ROS_HelpText_Pending_EUC_Form', Value__c = 'Pending EUC Form');
  Environment_Variable__c envvar7 = new Environment_Variable__c(Name = 'ACCT_RT_ID_CUSTOMER', Value__c = '012900000004Ba9');
  Environment_Variable__c envvar8 = new Environment_Variable__c(Name = 'ACCT_RT_ID_GF_INTERNAL', Value__c = '012900000004Aa8');
  List < Environment_Variable__c > lstenvvar = new List < Environment_Variable__c > {
   envvar1,
   envvar2,
   envvar3,
   envvar4,
   envvar5,
   envvar6,
   envvar7,
   envvar8
  };
  insert lstenvvar;

  Error_Codes__c err = new Error_Codes__c(Name = 'CONFIG_STAGE_VALIDATION', Message__c = 'Test Error Message');
  insert err;
    }

    static void loadCustomSettings() {
  DataUtilTest.LoadFabEnvVariables();
  DataUtilTest.LoadATPEnvVariables();
  DataUtilTest.LoadDeviceEnvVariable();
  DataUtilTest.LoadFabReticleEnvVariables();
  //DataUtilTest.LoadHCMEnvVariables();
  DataUtilTest.LoadOpptyEnvVariables();
  DataUtilTest.LoadOPTMEnvVariables();
  DataUtilTest.LoadReticleDeviceEnvVariables();
  DataUtilTest.LoadReticleDWEnvVariables();
  DataUtilTest.LoadReticleEnvVariables();
  list < Environment_Variable__c > evList = [select name, value__c from Environment_Variable__c where Name = 'HCM Account Id'];
  system.debug(logginglevel.error, evList);
  ROS_Witness_Arrival_Accounts__c roswa = new ROS_Witness_Arrival_Accounts__c(SetupOwnerId = UserInfo.getOrganizationId(), Account_Short_Name__c = 'TestAcct1N');
  insert roswa;
 }
 
static Id createReticleCycle() {
  ROS_Cycle__c RC = new ROS_Cycle__c(Name = '1H14', Cycle_Year__c = '2014', Cycle_Month__c = 'May', Cycle_Start_Date__c = System.TODAY() - 10);
  insert RC;
  return RC.Id;
 }


static Reticle__c createReticle(String AccountId, String ROSCycle, Integer DayInactive, string OwnerId) {
  Reticle__c RT = new Reticle__c();
  RT.Account__c = AccountId;
  RT.OwnerId = Ownerid;
  RT.ROS_Cycle__c = ROSCycle;
  RT.Day_Inactive__c = DayInactive;
  RT.Solution_Team_Confirm__c = true;
  RT.Name = '1313AA-05AZ1';
  RT.Reticle_Type__c = 'BINARY';
  RT.Region__c = 'US';
  RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
  insert RT;
  return RT;
 }
 
 static Id createReticleDevice(String RetcileId) {
  Reticle_Device__c RD = new Reticle_Device__c(Reticle__c = RetcileId, CRM_Device_ID__c = '1313AA-U011',
   GF_Device_Id__c = '1313AA-U011',
   Global_foundries_device_Id__c = '1313AA-U011');
  insert RD;
  return RD.Id;
 }
 static id createFab() {
  FAB__c FB = new FAB__c(Name = 'FAB 3');
  insert FB;
  return FB.id;
 }
 
 static Id createReticleFab(String RetcileId,String fabId){
        Fab_Reticle__c RD = new Fab_Reticle__c(Reticle__c =RetcileId,fab__C=fabId);
        insert RD;
        return RD.Id;
    }
    
    static User createFabUser(string FABId, String UserId) {
  Fab_User__c FUser = new Fab_User__c(Fab__c = Fabid, user__c = userid, Is_ROS_User__c = true);
  insert FUser;
  User u = [Select Id, name from User where id = : Fuser.User__c];
  return u;
 }
 
 static User createCSRUser(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
        return usr1;
    }
    
    static user CraeteSolutionteam(){
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
        usr1.UserName = 'testSolutionUser8888@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.FederationIdentifier = '111111';
        usr1.IsActive = true;
        insert(usr1);
        return usr1;        
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(String AccountId,String UserId,string Role){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = UserId,Sequence_No__c='1',
                                                              Account_Role_ID__c='test',Account__c=AccountId ,Account_Access__c='Read/Write',
                                                              Opportunity_Access__c='Read/Write',Team_Role__c=Role,
                                                              fab_assignment__c = 'FAB 3');
       
        insert atp;
        return atp;
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
static testMethod void method_ROS_TRIGGER_HELPER_ReticleDatawarehouse() {
        loadCustomSettings();
        List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
        lDwNew.add(DW);
        insert lDwNew;
        
        List<Reticle_Datawarehouse__c> lDwOld = new List<Reticle_Datawarehouse__c>(); 
        Reticle_Datawarehouse__c DW1 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
        lDwOld.add(DW1);
        insert lDwOld;
}
        
        
        
        static testMethod void method_ROS_FABUserTrigger() {
            loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
            user CSRuser =ROS_Other_Test.createCSRUser();
            User FuserCSR = ROS_Other_Test.createFabUser(fab, CSRuser.Id);
             Test.startTest();
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.ROS_Status__c = 'Scrap';
            RT.STF_Obsolence__c = true;
            update RT;
            Reticle__Share RS =  New Reticle__Share(ParentId=RT.Id,UserorGroupId=CSRUser.Id,Accesslevel='edit');
            Insert RS ;
            Delete [Select Id from Fab_User__c where User__C =: FuserCSR.Id limit 1]; 
            Test.stopTest();
     }
     static testMethod void method_ROS_FABUserTrigger2() {
        loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Other_Test.createGroup();        
            User SolutionUser = ROS_Other_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Other_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
            user CSRuser =ROS_Other_Test.createCSRUser();
            User FuserCSR = ROS_Other_Test.createFabUser(fab, CSRuser.Id);
            
            Fab_User__c FUser = new Fab_User__c(Fab__c =fab,user__c=CSRuser.Id,Is_ROS_User__c=true);
            insert FUser;
            
            delete FUser;
        Test.stopTest();    
    } 
    static testmethod void testMethod_selectedWrapper(){
      
         loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Other_Test.createGroup();        
            User SolutionUser = ROS_Other_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Other_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        
        
        Test.startTest();
        Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 100, Userinfo.getUserId());
            RT.Invalid__c = true;
            RT.Job_Id__c = '123';
          update RT;
            SelectedReticleWrapper obj = new SelectedReticleWrapper(RT,true);
            SelectedReticleWrapper obj2 = new SelectedReticleWrapper(RT);
        
        Test.stopTest();
    }
    static testmethod void method_ROS_PreventDuplicateDeviceReticle(){
      
         loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Other_Test.createGroup();        
            User SolutionUser = ROS_Other_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Other_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        
        
        Test.startTest();
        Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
        String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
         Reticle_Device__c RD = [Select Id from Reticle_Device__c where Id =: Devid ];
            Delete RD; 
        
        Test.stopTest();
    }
    static testMethod void methodROS_PreventDuplicateDeviceReticle2() {
       loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Other_Test.createGroup();        
            User SolutionUser = ROS_Other_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Other_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
           
            Fab_Reticle__c RD1 = [Select Id from Fab_Reticle__c where Id =: Fabid];
            Delete RD1 ; 
        Test.stopTest();
    }
    static testMethod void method_ROS_FABUserTrigger3() {
          loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Other_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Other_Test.createGroup();        
            User SolutionUser = ROS_Other_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Other_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
            user CSRuser =ROS_Other_Test.createCSRUser();
            User FuserCSR = ROS_Other_Test.createFabUser(fab, CSRuser.Id);
            
            Fab_User__c FUser = new Fab_User__c(Fab__c =fab,user__c=CSRuser.Id,Is_ROS_User__c=true);
            insert FUser;
            FUser.Is_ROS_User__c = false;
            update FUser;
        Test.stopTest();    
    } 
    static testMethod void method_ROS_ReticleTriggerHelpertest1() {
        loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          Test.startTest();
           user CSRuser =ROS_Other_Test.createCSRUser();
           Account_Team_Proxy__c atp1 = ROS_Other_Test.createAccountTeamProxy(accountId,CSRuser.Id,'Customer Service Rep');
          Id accountId1 =DeviceUtilTest.createAccount();
          Account_Team_Proxy__c atp2 = ROS_Other_Test.createAccountTeamProxy(accountId1,CSRuser.Id,'Customer Service Rep');
          string cycle= ROS_Other_Test.createReticleCycle();
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
            RT.Account__c = accountId1 ;
            RT.ROS_Status__c = 'Return';
            update RT;
             Test.stopTest(); 
    }
    static testMethod void method_ROS_ReticleTriggerHelpertest2() {
        loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          Test.startTest();
           user CSRuser =ROS_Other_Test.createCSRUser();
           Account_Team_Proxy__c atp1 = ROS_Other_Test.createAccountTeamProxy(accountId,CSRuser.Id,'Customer Engineer');
          string cycle= ROS_Other_Test.createReticleCycle();
            Reticle__c RT = ROS_Other_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Other_Test.createReticleDevice(RT.Id);
            string fab =ROS_Other_Test.createFab();
            String Fabid = ROS_Other_Test.createReticleFab(RT.Id, fab);
            
              RT.ROS_Status__c = 'Scrap';
              RT.Reticle_workflow_Status__c = 'Pending Witness Arrival Date';
            update RT;
             Test.stopTest(); 
    
    }  
}