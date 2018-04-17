/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Sameer Matale   02/20/2014        Case# 7056 Fix
        Sameer Matale   03/05/2014        Case# 6327, 5928, 6679, 7055, 7879 related changes
        DBiswal         04162015        - Updated code for making SeeAllData=false and refactoring of test class.
**/


@isTest(SEEALLDATA = false)
private class ROS_TestClass {
    
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
 static User createCSRUser(){
        User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
        return usr1;
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

 static ROS_Error_Messages__c assignErrorMessage(String name, String value) {
  ROS_Error_Messages__c rosErr = new ROS_Error_Messages__c();
  rosErr.name = name;
  rosErr.value__c = value;
  return rosErr;
 }

 static Environment_Variable__c assignEnvironmentVar(String name, String value) {
  Environment_Variable__c env = new Environment_Variable__c();
  env.name = name;
  env.value__c = value;
  return env;
 }

 static ROS_Column_Definition__c assignROSColumnDef(String name, String label) {
  ROS_Column_Definition__c rosColDef = new ROS_Column_Definition__c();
  rosColDef.name = name;
  rosColDef.label__c = label;
  return rosColDef;
 }

 static void createROSQueryDataSettings() {
  List < SObject > lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType, 'TestROSQueryUCData');
 }

 static user CraeteSolutionteam() {
  Profile systemAdminProfile = [select id from Profile where name = 'System Administrator'];
  User usr1 = new User();
  usr1.Alias = 'testSol';
  usr1.Email = 'testSolutionUser@test.com';
  usr1.EmailEncodingKey = 'UTF-8';
  usr1.FirstName = 'Test';
  usr1.LastName = 'TestSolutionUser';
  usr1.LanguageLocaleKey = 'en_US';
  usr1.LocaleSidKey = 'en_US';
  usr1.ProfileId = systemAdminProfile.Id;
  usr1.TimeZoneSidKey = 'America/Los_Angeles';
  usr1.UserName = 'testSolutionUser'+string.valueOf(system.now().getTime())+'@test.com';
  usr1.Fab_Assigned__c = 'FAB 1';
  usr1.FederationIdentifier = '111111';
  usr1.IsActive = true;
  system.debug('+++++'+usr1.UserName);
  insert(usr1);
  return usr1;
 }

 static Contact createContact(string testAccountId) {
  Contact testContact = new Contact();
  testContact.AccountId = testAccountId;
  testContact.FirstName = 'test23';
  testContact.LastName = 'test32';
  testContact.Email = 'test23@test.com';

  insert testContact;

  return testContact;
 }

 static Id createShippingAddress(String AccountId) {
  Shipping_Address__c shipAddress = new Shipping_Address__c(Account__c = AccountId, Address1__c = 'test', Address2__c = 'Test', Shipping_Country__c = 'Country', Shipping_State__c = 'State', zip_code__c = '11111');
  insert shipAddress;
  return shipAddress.Id;
 }

 static Id createForwarderInfo(String AccountId) {
  Forwarder_Information__c fwdInfo = new Forwarder_Information__c(Account__c = AccountId, Contact_Name__c = 'test', Contact_Phone_No__c = '12345', Forwarder_Name__c = 'fwd name', Account_No__c = '11111');
  insert fwdInfo;
  return fwdInfo.Id;
 }

 static id createFab() {
  FAB__c FB = new FAB__c(Name = 'FAB 3');
  insert FB;
  return FB.id;
 }

 static User createFabUser(string FABId, String UserId) {
  Fab_User__c FUser = new Fab_User__c(Fab__c = Fabid, user__c = userid, Is_ROS_User__c = true);
  insert FUser;
  User u = [Select Id, name from User where id = : Fuser.User__c];
  return u;
 }

 static Id createReticleDatawareHouse(Integer DayInactive, String RetcileId) {

  Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();

  DW.Customer_ID__c = 'broadcom';
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
  ROS_Cycle__c RC = new ROS_Cycle__c(Name = '1H14', Cycle_Year__c = '2014', Cycle_Month__c = 'May', Cycle_Start_Date__c = System.TODAY() - 10);
  insert RC;
  return RC.Id;
 }
 static testMethod void methodRDWHbatchhelper() {
    loadCustomSettings();
      Id ROScycleId = createReticleCycle();  
        String acctId = ROS_TestClass.createAccount1();
        User CSRuser = ROS_TestClass.createCSRUser();
        String oppId = ROS_TestClass.createOpp(acctId);
        String oppProgId = ROS_TestClass.createOppProg(acctId, oppId);
        Opportunity_Program_Team_Member__c oppProgTM = ROS_TestClass.createOppProgTmMem(oppProgId, CSRuser.Id);  
        //Device__c dev = ROS_TestClass.createDevice(acctId,oppId,oppProgId);
        /*Device__c dev = DeviceUtilTest.createCMPWDevice(acctId, oppProgId);
        dev.Opportunity2__c = oppId;
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        insert dev;*/
        
        //Device__c dev = DeviceUtilTest.createCustomerMPWDeviceNew1(acctId,oppId,oppProgId);
        
        
        List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 456,Job_Id__c ='1111111');
        lDwNew.add(DW);
        
        Test.startTest();  
        insert lDwNew;
        
             
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
         
        String Cycle = ROS_Util.getCurrentROSCycle();
        Id CycleId;
      
        ROS_Cycle__c ROSCycleRecord   = [select id from ROS_Cycle__c where name=:ROS_Util.getCurrentROSCycle() limit 1];
       
        if(ROSCycleRecord!=NULL){
            CycleId = ROSCycleRecord.Id;
        }
        
        Reticle__c RT = ROS_TestClass.createReticle(acctId, CycleId, 456, retcileOwner.id);
        Reticle_Datawarehouse__c RT1 = new Reticle_Datawarehouse__c(Name = 'Test',CustomerDevice_ID__c='34E21SA-75AZ',GlobalFoundries_DeviceID__c='34E21SA-75AZ',InactiveDay__c = 200,Job_Id__c ='1111111');
       
        
        insert RT1;                   
        
        
        List<RecordType> rtypes = [Select Name, Id From RecordType 
        where sObjectType='Reticle__c' and isActive=true and developername='Default' limit 1]; 
        
        ROS_ReticleDatawareHouseBatchHelper.ValidateDatawareHouseReticles(lDwNew,rtypes[0].Id,CycleId); 
        Test.stopTest();         
        }

 static Id createReticleDevice(String RetcileId) {
  Reticle_Device__c RD = new Reticle_Device__c(Reticle__c = RetcileId, CRM_Device_ID__c = '1313AA-U011',
   GF_Device_Id__c = '1313AA-U011',
   Global_foundries_device_Id__c = '1313AA-U011');
  insert RD;
  return RD.Id;
 }

 static Id createReticleFab(String RetcileId, String fabId) {
  Fab_Reticle__c RD = new Fab_Reticle__c(Reticle__c = RetcileId, fab__C = fabId);
  insert RD;
  return RD.Id;
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


 /*
 static Reticle__c createReticle(String name, Id accountId, String rosCycle, Integer dayInactive, Id ownerId,
  Boolean solTeamConfirm, String reticleType, String region, String workflowStatus) {
  return new Reticle__c(Name = name, Account__c = accountId, ROS_Cycle__c = rosCycle, Day_Inactive__c = dayInactive,
   OwnerId = Ownerid, Solution_Team_Confirm__c = solTeamConfirm, Reticle_Type__c = reticleType,
   Region__c = region, Reticle_workflow_Status__c = workflowStatus);
 }*/


 static string createOpp(Id testAcctId) {
  // Create Opportunity
  Opportunity testOppty = new Opportunity();
  testOppty.Name = 'Test Opportunity1';
  testOppty.AccountId = testAcctId;
  testOppty.StageName = '1. Discovery';
  testOppty.CloseDate = Date.Today().addDays(10);
  testOppty.Target_Process_Node__c = '14XM';
  testOppty.Market_Segment__c = 'Mobility';
  testOppty.Process_Platform__c = 'GF Baseline';
  testOppty.Fab_Split__c = 100;
  testOppty.Process_Geometry__c = '0.055UM';
  testOppty.Process_Family__c = 'Generic / Nominal';

  insert testOppty;

  testOppty.Siebel_Opportunity_ID__c = '123123123321';

  update testOppty;

  return testOppty.id;
 }

 static string createOppProg(Id testAcctId, Id testOpptyId) {
  // Create Opportunity Program
  Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
  testOpptyProgram.Name = testOpptyProgram.Name = [Select Name from Opportunity where Id = : testOpptyId].Name;
  testOpptyProgram.Account__c = testAcctId;
  testOpptyProgram.Opportunity__c = testOpptyId;

  insert testOpptyProgram;

  return testOpptyProgram.id;
 }

 static Device__c createDev(Id accId, Id oppId, Id oppProgId, String name) {
  Device__c dev = new Device__c();
  dev.Name = name;
  dev.Stage__c = 'Design In';
  dev.Status__c = 'Active';
  dev.Account__c = accId;
  dev.Opportunity2__c = oppId;
  dev.Opportunity_Program__c = oppProgId;
  dev.Market_Segment__c = 'Automotive';
  dev.Semiconductor_Device__c = 'Analog Regulator';
  dev.End_Application__c = 'Body';
  dev.Device_Sourcing__c = 'First Source';
  dev.Tapeout_Type__c = 'GlobalShuttle MPW';
  dev.Export_Control_Waiver_Flag__c = 'Yes';
  dev.Siebel_Device_ID__c = '0987654521';
  dev.IP_Gap__c = false;
  dev.BX041_Status__c = 'Closed';
  dev.Device_Type__c = 'Base';
  dev.Actual_Tapeout_Date__c = date.newInstance(2016, 5, 20);
  dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2016, 5, 20);
  dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2016, 3, 4);
  dev.Geometry_Filter__c = '0.010UM';
  dev.Fab__c = 'FAB 3';
  dev.Confidence_Level_Tapeout__c = '100';
  dev.Device_Mask_Set_Title__c = 'MSTTRT1';
  dev.Reticle_Type__c = 'Single Layer Reticle (SLR)';
  insert dev;
  return dev;
 }
 
 static testMethod void methodForWebService(){
      loadCustomSettings();
      createROSQueryDataSettings();
        //system.debug('####UC###'+[select id,name from ROS_Query_UserType_Category__c]);
        //Id ROScycleId = createReticleCycle();
        String Cycle = ROS_Util.getCurrentROSCycle();
        String UserType =  ROS_Util.UserType();
        system.debug('####UC###1'+UserType);
        String fab = ROS_TestClass.createFab();
        //User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        //Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        Id accountId =DeviceUtilTest.createAccount();
        
        Test.startTest();
            
            Reticle__c RT = ROS_TestClass.createReticle(accountId, Cycle, 500, Userinfo.getUserId());
            String Devid = ROS_TestClass.createReticleDevice(RT.Id);
            String Fabid = ROS_TestClass.createReticleFab(RT.Id, fab);
            PageReference pgRefGE = Page.ROS_GEForm;
            Test.setCurrentPageReference (pgRefGE);
            ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
            obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(RT, true));
            ROS_GEFormModel ObjGE = obj.getGEFormRequest();
            ObjGE.SetShipToCompany('Test');
            ObjGE.SetRequestNo('134');
            ObjGE.SetFab('FAB 3');
            ObjGE.SetRaiseDate('20/10/2014');
            obj.selectedReticles = obj.getselectedReticles();
            obj.selectedReticles.add(RT);
            test.SetMock(WebServiceMock.class, new WebServiceMockImpl());
            obj.formSearch();
        Test.stopTest();
    }
    
    static testMethod void method_ROS_TRIGGER_HELPER_ReticleDatawarehouse() {
         loadCustomSettings();
  
       // Id ROScycleId = createReticleCycle();
        List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
        lDwNew.add(DW);
        
        insert lDwNew;
        
        List<Reticle_Datawarehouse__c> lDwOld = new List<Reticle_Datawarehouse__c>(); 
        Reticle_Datawarehouse__c DW1 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
        lDwOld.add(DW1);
        Test.startTest();
        insert lDwOld;  
        Test.stopTest();   
    }
        
    static testMethod void method_ROS_PreventDuplicateDevicereticle() {
         loadCustomSettings();
  
        //Id ROScycleId = createReticleCycle();
        String Cycle = ROS_Util.getCurrentROSCycle();
        String fab = ROS_TestClass.createFab();      
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        
        Id accountId =DeviceUtilTest.createAccount();
        Test.startTest();
            Reticle__c RT = ROS_TestClass.createReticle(accountId, Cycle, 500, retcileOwner.id);
            String Devid = ROS_TestClass.createReticleDevice(RT.Id);
            String Fabid = ROS_TestClass.createReticleFab(RT.Id, fab);
            Reticle_Device__c RD = [Select Id from Reticle_Device__c where Id =: Devid ];
            Delete RD; 
        Test.stopTest();
    }
    
    static testMethod void method_ROS_PreventDuplicateDevicereticle2() {
         loadCustomSettings();
        //Id ROScycleId = createReticleCycle();
        String Cycle = ROS_Util.getCurrentROSCycle();
        String fab = ROS_TestClass.createFab();      
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        Id accountId =DeviceUtilTest.createAccount();
        Test.startTest();
            Reticle__c RT = ROS_TestClass.createReticle(accountId, Cycle, 500, retcileOwner.id);
            String Devid = ROS_TestClass.createReticleDevice(RT.Id);
            String Fabid = ROS_TestClass.createReticleFab(RT.Id, fab);
            Fab_Reticle__c RD1 = [Select Id from Fab_Reticle__c where Id =: Fabid ];
            Delete RD1 ;
        Test.stopTest(); 
    }
    
    static testMethod void method_ROS_FABUserTrigger() {
        
         loadCustomSettings();
        //Id ROScycleId = createReticleCycle();
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        Id accountId =DeviceUtilTest.createAccount();
        User CSRuser = ROS_TestClass.createCSRUser();
        String fab = ROS_TestClass.createFab();      
        User FuserCSR = ROS_TestClass.createFabUser(fab, CSRuser.Id);
        String Cycle = ROS_Util.getCurrentROSCycle();
        
        Test.startTest();
        Reticle__c RT = ROS_TestClass.createReticle(accountId, Cycle, 500, retcileOwner.id);
        Reticle__Share RS =  New Reticle__Share(ParentId=RT.Id,UserorGroupId=CSRUser.Id,Accesslevel='edit');
        Insert RS ;
        Test.stopTest();
        
         Delete [Select Id from Fab_User__c where User__C =: FuserCSR.Id limit 1]; 
    }
     
    static testMethod void method_ROS_FABUserTrigger2() {
         loadCustomSettings();
 
        //Id ROScycleId = createReticleCycle();
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        Id accountId =DeviceUtilTest.createAccount();
        User CSRuser = ROS_TestClass.createCSRUser();
        String fab = ROS_TestClass.createFab();     
        String Cycle = ROS_Util.getCurrentROSCycle();
       
        Test.startTest();
            User FuserCSR = ROS_TestClass.createFabUser(fab, CSRuser.Id);
            Fab_User__c FUser = new Fab_User__c(Fab__c =fab,user__c=CSRuser.Id,Is_ROS_User__c=true);
            insert FUser;
            delete FUser;
        Test.stopTest();    
    }    
    // Creation of an Account
    static Id createAccount1(){
        Account acc= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'testing901');            
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
        acc= AccountDataFactory.createAccount(fieldValueMap);
        return acc.Id;
    }
    
    static testmethod void sendNotification(){
        //DataUtilTest.loadEnvironmentVariables();
        //Id ROScycleId = createReticleCycle();
        loadCustomSettings();
  
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account limit 1];
        
        User CSRuser = ROS_TestClass.createCSRUser();
        Id accountId =DeviceUtilTest.createAccount();
        String fab = ROS_TestClass.createFab();      
        String Cycle = ROS_Util.getCurrentROSCycle();
       
        Test.startTest();
            User FuserCSR = ROS_TestClass.createFabUser(fab, CSRuser.Id);
            EmailTemplate temp = [select id from EmailTemplate limit 1];
            ROS_Util.sendNotification(temp.id,FuserCSR.id);
        Test.stopTest();
    }
    
    static testmethod void testMethod_updateInvalidReason(){
         loadCustomSettings();
  
       // Id ROScycleId = createReticleCycle();
        String acctId = ROS_TestClass.createAccount1();
        String Cycle = ROS_Util.getCurrentROSCycle();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        
        List<Reticle__c> lstReticle = new List<Reticle__c >();
        Reticle__c RT = ROS_TestClass.createReticle(acctId, Cycle, 500,retcileOwner.id);
        lstReticle.add(RT);
        
        List<Reticle_Datawarehouse__c> lDwNew = new List<Reticle_Datawarehouse__c>();
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111',Customer_id__c='broadcom');
        Reticle_Datawarehouse__c DW2 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
       Test.startTest(); 
        insert DW;
        insert DW2;
        lDwNew.add(DW);
        lDwNew.add(DW2);
        
        
            ROS_ReticleDataWarehouseBatchHelper.updateInvalidReason(lstReticle,lDwNew,'1111111');
        Test.stopTest();
    }

    @isTest(SEEALLDATA = false)
    static void testMethod_NegativeBatch(){
         loadCustomSettings();
  
        //Id ROScycleId = createReticleCycle();
        test.startTest();
            try {
               
                FAB__c FB1 = new FAB__c(Name='FAB 3');
                insert FB1;
                Reticle_Datawarehouse__c DW2 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111', FAB__c = FB1.Name);
            
                Reticle__c RT                 = new Reticle__c();
                RT.Account__c                 = ROS_TestClass.createAccount1();
               
                RT.ROS_Cycle__c               = ROS_Util.getCurrentROSCycle();
                RT.Day_Inactive__c            = 100;
                RT.Solution_Team_Confirm__c   = true;
                RT.Name                       = 'Test1';
                RT.Reticle_Type__c            = 'BINARY';
                RT.Region__c                  = 'US';
                RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
                RT.Invalid__c = true;
                RT.Job_Id__c = '123';
                insert RT;
            
                insert DW2 ;  
                FAB__c FB2 = new FAB__c(Name='FAB 2');
                insert FB2;
                ROS_BatchRTDW DWB2 = new ROS_BatchRTDW();
                DWB2.isTestClass = true;
                DWB2.JOBID = '123';
                ID batchprocessid = Database.executeBatch(DWB2);
    
                Reticle_Datawarehouse__c DW3 = new Reticle_Datawarehouse__c(Name = 'Test2',InactiveDay__c = 350,Job_Id__c ='1111111', FAB__c = FB2.Name);        
                insert DW3 ;  
            
                ROS_BatchRTDW DWB3 = new ROS_BatchRTDW();
                DWB3.isTestClass = true;
                DWB3.JOBID = '123';
                ID batchprocessid3 = Database.executeBatch(DWB3);
            }catch(Exception ex) {
                System.debug('Exception: ' + ex.getMessage());
            }
        test.stopTest();
    }

    static testmethod void testMethod_NegativeShipping(){
          loadCustomSettings();
  
         test.startTest();//sunita
         //Id ROScycleId = createReticleCycle();
         try{
         Shipping_Address__c newAddressObj1 = new Shipping_Address__c();
         newAddressObj1.id = '123456';
         boolean sucess = ROS_ShippingAddressProcess.saveNewAddress(newAddressObj1 );
         test.stopTest();//sunita
         }catch(exception ex){
             ROS_Util.insertException(ex,'Test class','ROS');
         }
    }
    
    static testmethod void testMethod_shareActiveReticle(){
         loadCustomSettings();
  
        test.startTest();//sunita
        //Id ROScycleId = createReticleCycle();
        String Cycle = ROS_Util.getCurrentROSCycle();
        String fab = ROS_TestClass.createFab();      
        
        User SolutionUser = ROS_TestClass.CraeteSolutionteam();
        Group retcileOwner = [Select id from Group where Name = 'WWMS ROS Team' limit 1];
        //Account A = [Select Id from Account where Short_Name__c =: 'amd' limit 1];
        Reticle_Datawarehouse__c DW3 = new Reticle_Datawarehouse__c(Name = 'Test',InactiveDay__c = 350,Job_Id__c ='1111111');
       
        Reticle_Datawarehouse__c DW = new Reticle_Datawarehouse__c();
        DW.Customer_ID__c= 'amd';
        DW.CustomerDevice_ID__c = '1313AA-U01';
        DW.FAB__c = 'FAB 3';
        DW.GlobalFoundries_DeviceID__c = '1313AA-U01';
        DW.InactiveDay__c = 100;
        DW.Region_Name__c = 'US';
        DW.Reticle_Status__c = '';
        DW.Reticle_Type__c = 'BINARY';   
        DW.Name = '1313AA-U01';
        insert DW;
        List<Reticle_Datawarehouse__c> listDw = new List<Reticle_Datawarehouse__c>();
        listDw.add(DW);
        ROS_ReticleDatawareHouseBatchHelper.createActiveReticles(listDw);
        
        test.stopTest();//sunita
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
}