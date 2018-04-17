/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_Util
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.
        DBiswal        07112015             Test class modification.
**/

 
@isTest(SEEALLDATA = false)
private class ROS_Util_Test {

@testSetup static void testdata(){
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
static Group createGroup1(String gname,String dname){        
        Group retcileOwner = new Group();
        retcileOwner.Name = gname;
        retcileOwner.DeveloperName = dname;
        INSERT retcileOwner;
        return retcileOwner;
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
     static User createTestUser(string prof){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name=:prof) and IsActive=true and Fab_Assigned__c != null limit 1];
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
    
    
    static testMethod void method_updateReticleAccess() {
        loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Util_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Util_Test.createGroup();        
            User SolutionUser = ROS_Util_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Util_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            user CSRuser =ROS_Util_Test.createCSRUser();
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);
             
            RT.Reticle_workflow_Status__c = 'Pending for Customer Feedback';
            RT.Made_Valid_by_CSR_Team__c = true;
            RT.Fabstr__c = 'FAB 3';
            update RT;
            
            set<String> setReticle = new Set<String>();
            setReticle.add(RT.id);
            
            ROS_Util.updateReticleAccess(setReticle, 'Sharing with CSR', 'Edit');
        Test.stopTest();
    }
    static testMethod void method_ROS_Util() {
         try{
         Integer Res = 1/0;
         }catch(exception ex){
          ROS_Util.insertException(ex,'Test class','ROS');
         }
        
    }
    static testmethod void method_sendNotification(){
        loadCustomSettings();
          Id accountId =DeviceUtilTest.createAccount();
          string cycle= ROS_Util_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Util_Test.createGroup();        
            User SolutionUser = ROS_Util_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Util_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            user CSRuser =ROS_Util_Test.createCSRUser();
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);
            User FuserCSR = ROS_Util_Test.createFabUser(fab, CSRuser.Id);
            EmailTemplate temp = [select id from EmailTemplate limit 1];
            ROS_Util.sendNotification(temp.id,FuserCSR.id);
        Test.stopTest();
    }
    static testmethod void method_UserType1(){
        loadCustomSettings();
          User SolutionUser;
          string cycle= ROS_Util_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Util_Test.createGroup();        
            SolutionUser= ROS_Util_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Util_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
          Id accountId =DeviceUtilTest.createAccount();
          Account_Team_Proxy__c atp1 = createAccountTeamProxy(accountId,SolutionUser.Id,'Customer Service Rep');
        Test.startTest();
            user CSRuser =ROS_Util_Test.createCSRUser();
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);
            User FuserCSR = ROS_Util_Test.createFabUser(fab, CSRuser.Id);
            EmailTemplate temp = [select id from EmailTemplate limit 1];
            ROS_Util.UserType();
            System.runAs (SolutionUser) {
                ROS_Util.UserType();
            }
        Test.stopTest();
    }
    static testmethod void method_UserType2(){
        loadCustomSettings();
        string cycle= ROS_Util_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User SolutionUser;
         user CSRuser =ROS_Util_Test.createCSRUser();
        System.runAs (thisUser) {
            //Group groupGSM = ROS_Util_Test.createGroup();        
            SolutionUser = ROS_Util_Test.CraeteSolutionteam();
            Group groupGSM1 = ROS_Util_Test.createGroup1('ROS Trade Compliance Team', 'ROS_Trade_Compliance');
            GroupMember gm1 = ROS_Util_Test.createGroupMember(groupGSM1.Id,SolutionUser.Id);
                
            Group groupGSM2 = ROS_Util_Test.createGroup1('PI/YE ROS FAB Team','PIYE_ROS_FAB_Team');
            GroupMember gm2 = ROS_Util_Test.createGroupMember(groupGSM2.Id,CSRuser.id);            
        }        
        
         Id accountId =DeviceUtilTest.createAccount();
        
        Test.startTest();
           
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);      
            
            System.runAs(SolutionUser) {
                ROS_Util.UserType();
            }
            System.runAs(CSRuser) {
                ROS_Util.UserType();
            }
        Test.stopTest();
    }
    static testmethod void method_UserType3(){
        loadCustomSettings();
        string cycle= ROS_Util_Test.createReticleCycle();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User testUser1 = ROS_Util_Test.createTestUser('GF FAE/FTS');    
        
        Id accountId =DeviceUtilTest.createAccount();
        
        Test.startTest();
           user CSRuser =ROS_Util_Test.createCSRUser();
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);            
            
            System.runAs(thisUser) {
                ROS_Util.UserType();
            }
            System.runAs(CSRuser) {
                ROS_Util.UserType();
            }
            System.runAs(testUser1) {
                ROS_Util.UserType();
            }            
        Test.stopTest();
    }
    static testmethod void method_getUserReticles(){
       loadCustomSettings();
       Id accountId =DeviceUtilTest.createAccount();
       string cycle= ROS_Util_Test.createReticleCycle();
       User SolutionUser;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Group groupGSM = ROS_Util_Test.createGroup();        
            SolutionUser = ROS_Util_Test.CraeteSolutionteam();
            GroupMember gm = ROS_Util_Test.createGroupMember(groupGSM.Id,SolutionUser.Id);            
        }        
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        Test.startTest();
            user CSRuser =ROS_Util_Test.createCSRUser();
            Reticle__c RT = ROS_Util_Test.createReticle(accountId, Cycle, 500, CSRuser.id);
            String Devid = ROS_Util_Test.createReticleDevice(RT.Id);
            string fab =ROS_Util_Test.createFab();
            String Fabid = ROS_Util_Test.createReticleFab(RT.Id, fab);
            User FuserCSR = ROS_Util_Test.createFabUser(fab, CSRuser.Id);
            EmailTemplate temp = [select id from EmailTemplate limit 1];
            ROS_Util.getUserReticles(SolutionUser.Id);
        Test.stopTest();
    }
    static testmethod void rosCycle_Trigger_test(){
        String Cycle1 = ROS_Util_Test.createReticleCycle();
        ROS_Cycle__c rosCycleRecord = [select id from ROS_Cycle__c limit 1];
        if(rosCycleRecord != NULL){
            rosCycleRecord.Cycle_End_date__c = System.TODAY() +10;
            rosCycleRecord.Next_Cycle_Name__c = '1H15';
            update rosCycleRecord;
        }
        
    }
    static testmethod void rosCycle_Trigger_negative_test(){
        String Cycle1 = ROS_Util_Test.createReticleCycle();
        ROS_Cycle__c rosCycleRecord = [select id from ROS_Cycle__c limit 1];
        try{
        if(rosCycleRecord != NULL){
            rosCycleRecord.Cycle_End_date__c = System.TODAY() +10;
            rosCycleRecord.Next_Cycle_Name__c = '1H14';
            update rosCycleRecord;
        }
        }catch(Exception e){}
        
        try{
            String Cycle2 = ROS_Util_Test.createReticleCycle();
        }catch(Exception e){}
    }
    
    
}