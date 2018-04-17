/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_ControllerSearchReticleGFForm
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    02/24/2014        Test class created.
        DBiswal        03082016          Modified according to code review.
**/


@isTest
private class ROS_ControllerSearchReticleGFForm2_Test {

 //DBiswal 01082016
 @testSetup static void testdata() {
  EUC_Form__c eucformrec = new EUC_Form__c(End_User_Stmt_Sec_1__c = 'Test data2');
  insert eucformrec;
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
  usr1.UserName = 'testSolutionUser@test.com';
  usr1.Fab_Assigned__c = 'FAB 1';
  usr1.FederationIdentifier = '111111';
  usr1.IsActive = true;
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

 static Reticle__c createReticle(String name, Id accountId, String rosCycle, Integer dayInactive, Id ownerId,
  Boolean solTeamConfirm, String reticleType, String region, String workflowStatus) {
  return new Reticle__c(Name = name, Account__c = accountId, ROS_Cycle__c = rosCycle, Day_Inactive__c = dayInactive,
   OwnerId = Ownerid, Solution_Team_Confirm__c = solTeamConfirm, Reticle_Type__c = reticleType,
   Region__c = region, Reticle_workflow_Status__c = workflowStatus);
 }


 static Opportunity createOpp(Id testAcctId) {
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

  return testOppty;
 }

 static Opportunity_Program__c createOppProg(Id testAcctId, Id testOpptyId) {
  // Create Opportunity Program
  Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
  testOpptyProgram.Name = testOpptyProgram.Name = [Select Name from Opportunity where Id = : testOpptyId].Name;
  testOpptyProgram.Account__c = testAcctId;
  testOpptyProgram.Opportunity__c = testOpptyId;

  insert testOpptyProgram;

  return testOpptyProgram;
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

 static testMethod void methodForDisposition_NotifyCustomer() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();

  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  Reticle__c reticle = createReticle('A1000', accountId, cycle, 500, userInfo.getUserId(), true, 'Binary',
   'US', 'Pending to Notify Customer');
  insert reticle;

  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
   GF_Device_Id__c = '1313AA-U011',
   Global_foundries_device_Id__c = '1313AA-U011');
  reticleDeviceList.add(reticleDevice);
  fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  insert reticleDeviceList;
  insert fabReticleList;
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
  obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));


  reticle.Reticle_Workflow_Status__c = 'Pending for Customer Feedback';
  reticle.Invalid__c = false;
  update reticle;

  PageReference pgRefAdd = Page.ROSVF_shippingAddress;
  Test.setCurrentPageReference(pgRefAdd);
  ApexPages.currentPage().getParameters().put('AccountId', accountId);

  obj.ShippingAddress = 'test shipping address';

  String Id = createShippingAddress(accountId);
  obj.ForwarderAccountNumber = '1234';
  obj.ForwarderName = 'test';
  obj.selectedAddress1 = 'Other';
  obj.NewAddress = obj.getNewAddress();
  obj.NewAddress.Address1__c = 'Test';
  obj.NewAddress.Address2__c = 'Test';
  obj.NewAddress.Shipping_Country__c = 'US';
  obj.NewAddress.Shipping_State__c = 'Test';
  obj.NewAddress.zip_code__c = 'Test';
  obj.selectedFwdInfo1 = 'Other';
  obj.ShippingAddressSave();
  obj.ShippingAddressAssign();

  obj.NewFwdInfo = obj.getNewFwdInfo();
  obj.NewFwdInfo.Contact_Name__c = 'Test';
  obj.NewFwdInfo.Contact_Phone_No__c = '12345';
  obj.NewFwdInfo.Forwarder_Name__c = 'Test';
  obj.NewFwdInfo.Account_No__c = '123456';
  obj.FwdInfoSave();
  System.assertEquals(null, obj.selectedFwdInfo1);

  obj.selectedAddress1 = Id;
  System.debug('----> ' + obj.SelReturnReticles.size());
  obj.ShippingAddressAssign();
  obj.selectAddress();
  obj.CleanAddress();
  obj.CancelShippingAddress();
  obj.ShippingAddressInsert();
  Reticle__c RTTest = obj.getAddress();
  obj.setselectedAddress1('Other');
  obj.ShipaddressAccountId();
  obj.showaddress();
  System.assert(obj.shipaddressaccount != null);
  System.assertEquals('Other', obj.selectedAddress1);

  string Str1 = obj.getLDataString();

  String STr2 = obj.getselectedAddress1();
  Shipping_Address__c add = new Shipping_Address__c();
  add.Account__c = accountId;
  add.Address1__c = 'Test';
  insert add;
  obj.addressId = add.Id;

  obj.ShowAddressAccount();
  Shipping_Address__c Shobj = obj.getShipaddress_1();
  obj.res = reticle;
  List < SelectOption > optionS = obj.getShippingAddresses();

  List < SelectedReticleWrapper > StList = obj.getReturnReticles();

  reticle.ROS_Status__c = 'Return'; // added on 8/8/14
  update reticle;


  obj.Category = 'pStfObsel';
  obj.ReticleSearch();
  System.assertEquals('Pending for STF Obsolescence', [Select id, Reticle_Workflow_Status__c from Reticle__c where id = : reticle.Id].Reticle_Workflow_Status__c);
  obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.reticlewrapper(reticle, true));
  List < ROS_ControllerSearchReticleGFForm.Reticlewrapper > TestWr = obj.getSelectedRetwrapper();

  Map < Device__c, ROS_STFObsolescenceProcess.STFclassWrapper > getRetcileListDevice = obj.getRetcileListDevice();

  obj.RedirectSTF();
  PageReference pgRefSTF = Page.ROSVF_STFObsolescence;
  Test.setCurrentPageReference(pgRefSTF);
  obj.StfFill();
  obj.performSTFObsolescence();
  obj.Category = 'pGeForm';
  obj.ReticleSearch();

  obj.NavigatetoGEForm();
  PageReference pgRefGE = Page.ROS_GEForm;
  Test.setCurrentPageReference(pgRefGE);
  ROS_GEFormModel ObjGE = obj.getGEFormRequest();
  ObjGE.SetShipToCompany('Test');
  ObjGE.SetRequestNo('134');
  ObjGE.SetFab('FAB 3');
  ObjGE.SetRaiseDate('20/10/2014');
  obj.selectedReticles = obj.getselectedReticles();
  obj.selectedReticles.add(reticle);
  obj.applyGEForm();
  PageReference back = obj.Cancel();
  System.assert(back != null);
  Test.stopTest();
 }

 public static TestMethod void testShippingAddressAssign() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;
  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();

  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 5; i++) {
   Reticle__c reticle = createReticle('A1000' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending to Notify Customer');
   reticleList.add(reticle);
  }
  insert reticleList;
  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  for (Reticle__c reticle: reticleList) {
   Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
    GF_Device_Id__c = '1313AA-U011',
    Global_foundries_device_Id__c = '1313AA-U011');
   reticleDeviceList.add(reticleDevice);
   fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  }
  insert reticleDeviceList;
  insert fabReticleList;
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();
  for (Reticle__c reticle: reticleList) {
   rosControllerSearchReticleGFForm.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  }

  rosControllerSearchReticleGFForm.setselectedAddress1(shippingAddrId);
  rosControllerSearchReticleGFForm.setselectedFwdInfo1(fwdInfoId);
  rosControllerSearchReticleGFForm.getselectedFwdInfo1();
  System.assertEquals(fwdInfoId, rosControllerSearchReticleGFForm.selectedFwdInfo1);

  rosControllerSearchReticleGFForm.SelReturnReticles.add(new SelectedReticleWrapper(reticleList[0]));
  rosControllerSearchReticleGFForm.SelReturnReticles.get(0).isChecked = true;
  rosControllerSearchReticleGFForm.shipaddressaccount = accountId;
  PageReference processAdd = rosControllerSearchReticleGFForm.addressProcess();
  PageReference shipAdd = rosControllerSearchReticleGFForm.ShippingAddressAssign();
  rosControllerSearchReticleGFForm.hscode = 'test2';
  rosControllerSearchReticleGFForm.item = 'test2';
  rosControllerSearchReticleGFForm.assign();
  System.assertEquals(true, rosControllerSearchReticleGFForm.showhsSection);
  PageReference cleanAdd = rosControllerSearchReticleGFForm.CleanAddress();
  System.assertEquals(null, rosControllerSearchReticleGFForm.selectedFwdInfo1);
  PageReference nullAddRef = rosControllerSearchReticleGFForm.nullifyAddress();
  System.assertEquals(null, rosControllerSearchReticleGFForm.selectedFwdInfo1);
  Test.stopTest();
 }

 public static TestMethod void testUpdateReticleStatus() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;
  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();

  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 5; i++) {
   Reticle__c reticle = createReticle('A1000' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending to Notify Customer');
   reticleList.add(reticle);
  }
  Test.StartTest();
  insert reticleList;

  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  for (Reticle__c reticle: reticleList) {
   Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
    GF_Device_Id__c = '1313AA-U011',
    Global_foundries_device_Id__c = '1313AA-U011');
   reticleDeviceList.add(reticleDevice);
   fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  }
  insert reticleDeviceList;
  insert fabReticleList;

  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();
  for (Reticle__c reticle: reticleList) {
   rosControllerSearchReticleGFForm.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  }

  rosControllerSearchReticleGFForm.updateReticleStatus();
  String retworkflowstatus = [select id, name, Reticle_Workflow_Status__c FROM Reticle__c WHERE id = : reticleList[0].Id].Reticle_Workflow_Status__c;
  System.assertEquals('Pending for Customer Feedback', retworkflowstatus);
  Test.stopTest();
 }

 public static TestMethod void testMoveToActiveReticles1() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;
  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  //createFabUser(fab, UserInfo.getUserId());
  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 5; i++) {
   Reticle__c reticle = createReticle('A1000' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending to Notify Customer');
   reticle.New_Inactive_Days__c = 100;
   reticleList.add(reticle);
  }
  insert reticleList;
  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  for (Reticle__c reticle: reticleList) {
   Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
    GF_Device_Id__c = '1313AA-U011',
    Global_foundries_device_Id__c = '1313AA-U011');
   reticleDevice.Is_Temporary__c = true;
   reticleDeviceList.add(reticleDevice);
   fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  }
  insert reticleDeviceList;
  insert fabReticleList;
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();
  for (Reticle__c reticle: reticleList) {
   rosControllerSearchReticleGFForm.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  }

  rosControllerSearchReticleGFForm.moveToActiveReticles();
  System.assertEquals(null, reticleList[0].New_Inactive_Days__c);
  Test.stopTest();
 }

 public static TestMethod void testContinueProcessing1() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;
  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 2; i++) {
   Reticle__c reticle = createReticle('A1100' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending to Notify Customer');
   reticle.New_Inactive_Days__c = 100;
   reticleList.add(reticle);
  }
  insert reticleList;
  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  for (Reticle__c reticle: reticleList) {
   Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
    GF_Device_Id__c = '1313AA-U011',
    Global_foundries_device_Id__c = '1313AA-U011', Is_Temporary__c = true);
   reticleDeviceList.add(reticleDevice);
   fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  }
  insert reticleDeviceList;
  insert fabReticleList;
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();
  for (Reticle__c reticle: reticleList) {
   rosControllerSearchReticleGFForm.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  }

  rosControllerSearchReticleGFForm.ContinueProcessing();
  System.assertEquals(null, reticleList[0].New_Inactive_Days__c);
  Test.stopTest();
 }

 public static TestMethod void testContinueProcessing2() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;
  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();

  rosControllerSearchReticleGFForm.ContinueProcessing();
  System.assert(rosControllerSearchReticleGFForm.summaries.size() == 0);
  Test.stopTest();
 }

 public static TestMethod void testPerformSTFObsolescence() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 2; i++) {
   Reticle__c reticle = createReticle('A1100' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending for Customer Feedback'); //changed the Reticle WF Status-- 8/8/14
   reticleList.add(reticle);
  }
  insert reticleList;
  reticleList[0].ROS_Status__c = 'Return';
  Test.StartTest();
  update reticleList[0];

  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  for (Reticle__c reticle: reticleList) {
   Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
    GF_Device_Id__c = '1313AA-U011',
    Global_foundries_device_Id__c = '1313AA-U011', Is_Temporary__c = true);
   reticleDeviceList.add(reticleDevice);
   fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  }
  insert reticleDeviceList;

  insert fabReticleList;


  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();
  for (Reticle__c reticle: reticleList) {
   rosControllerSearchReticleGFForm.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  }

  rosControllerSearchReticleGFForm.HSCode = 'testHSCode';
  rosControllerSearchReticleGFForm.Item = 'testItem';

  rosControllerSearchReticleGFForm.setselectedAddress1(shippingAddrId);
  rosControllerSearchReticleGFForm.setselectedFwdInfo1(fwdInfoId);
  rosControllerSearchReticleGFForm.getselectedFwdInfo1();
  rosControllerSearchReticleGFForm.SelReturnReticles.add(new SelectedReticleWrapper(reticleList[0]));
  rosControllerSearchReticleGFForm.SelReturnReticles.get(0).isChecked = true;
  rosControllerSearchReticleGFForm.shipaddressaccount = accountId;
  PageReference processAdd = rosControllerSearchReticleGFForm.addressProcess();
  PageReference shipAdd = rosControllerSearchReticleGFForm.ShippingAddressAssign();

  rosControllerSearchReticleGFForm.StfFill();
  system.assertEquals('testHSCode', reticleList[0].HS_Code__c);
  rosControllerSearchReticleGFForm.performSTFObsolescence();
  Test.stopTest();
 }

 public static testMethod void testAllMethods() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_All_Active_Reticles', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_All_Archive_Reticles', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_All_Inactive_Reticles', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_All_Reticles', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Active_Ver', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Customer_Feedback', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Debit_Note', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Fab_FollowUp', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_for_Shipment', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Notify_Customer', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_Scrap_Certificate', 'test'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_HelpText_Pending_STF_Obsolescence', 'test'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  List < Reticle__c > reticleList = new List < Reticle__c > ();

  for (Integer i = 1; i < 2; i++) {
   Reticle__c reticle = createReticle('A1100' + i, accountId, cycle, 500 + i, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending for Customer Feedback'); //changed the Reticle WF Status-- 8/8/14
   reticleList.add(reticle);
  }
  insert reticleList;

  Test.startTest();
  ROS_ControllerSearchReticleGFForm rosControllerSearchReticleGFForm = new ROS_ControllerSearchReticleGFForm();

  rosControllerSearchReticleGFForm.UserType = 'System Administrator';
  rosControllerSearchReticleGFForm.getHelpText();

  rosControllerSearchReticleGFForm.addressId = shippingAddrId;
  rosControllerSearchReticleGFForm.showaddress();
  rosControllerSearchReticleGFForm.getShipaddress_1();
  rosControllerSearchReticleGFForm.ShowAddressAccount();
  rosControllerSearchReticleGFForm.selectAddress();
  System.assert(rosControllerSearchReticleGFForm.CancelShippingAddress() != null);
  rosControllerSearchReticleGFForm.getselectedAddress1();
  rosControllerSearchReticleGFForm.getAddress();

  rosControllerSearchReticleGFForm.UserType = 'Customer';
  rosControllerSearchReticleGFForm.getHelpText();
  rosControllerSearchReticleGFForm.UserType = 'None';
  rosControllerSearchReticleGFForm.getHelpText();
  rosControllerSearchReticleGFForm.UserType = 'CSR';
  rosControllerSearchReticleGFForm.getHelpText();
  rosControllerSearchReticleGFForm.UserType = 'FAB';
  rosControllerSearchReticleGFForm.getHelpText();
  rosControllerSearchReticleGFForm.UserType = 'Solution Team';
  rosControllerSearchReticleGFForm.getHelpText();

  Test.stopTest();
 }

 static testMethod void methodForDisposition_stf() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();

  String shippingAddrId = createShippingAddress(accountId);
  String fwdInfoId = createForwarderInfo(accountId);

  Reticle__c reticle = createReticle('A1000', accountId, cycle, 500, userInfo.getUserId(), true, 'Binary',
   'US', 'Pending to Notify Customer');
  insert reticle;

  List < Reticle_Device__c > reticleDeviceList = new List < Reticle_Device__c > ();
  List < Fab_Reticle__c > fabReticleList = new List < Fab_Reticle__c > ();
  Reticle_Device__c reticleDevice = new Reticle_Device__c(Reticle__c = reticle.Id, CRM_Device_ID__c = '1313AA-U011',
   GF_Device_Id__c = '1313AA-U011',
   Global_foundries_device_Id__c = '1313AA-U011');
  reticleDeviceList.add(reticleDevice);
  fabReticleList.add(new Fab_Reticle__c(Reticle__c = reticle.Id, fab__c = fab));
  insert reticleDeviceList;
  insert fabReticleList;
  Test.StartTest();
  ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
  obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));


  reticle.Reticle_Workflow_Status__c = 'Pending for Customer Feedback';
  reticle.Invalid__c = false;
  reticle.Made_Valid_by_CSR_Team__c = true;
  update reticle;

  obj.UserType = 'System Administrator';
  obj.Category = 'pNotifyCust';
  obj.ReticleSearch();
  obj.getRetcileListDevice();
  for (Device__c rtcDevid: obj.RetcileListDevice.keySet()) {
   obj.RetcileListDevice.get(rtcDevid).isSelected = true;
   for (Reticle__c rtc: obj.RetcileListDevice.get(rtcDevid).deviveRetcileList) {
    rtc.HS_Code__c = 'test';
    rtc.Item__c = 'test';
   }
  }

  PageReference stfPage = Page.ROSVF_STFObsolescence;
  PageReference redirect = obj.redirectSTF();
  Test.setCurrentPageReference(stfPage);
  System.assertEquals(null, redirect);
  obj.hscode = 'test2';
  obj.item = 'test2';
  obj.assign();
  obj.performSTFObsolescence();
  List < Selectoption > cycles = obj.getCycles();
  System.assert(cycles.size() > 0);
  obj.updateEvidenceCertificate();
  Test.stopTest();
 }

 static testMethod void method_SearchReticlePortalUsers() {
   loadCustomSettings();
   List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
   lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
   lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
   lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
   lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
   insert lstEnv;

   String accountId = DeviceUtilTest.createAccount();
   String Cycle = createReticleCycle();
   String fab = createFab();
   createROSQueryDataSettings();

   String shippingAddrId = createShippingAddress(accountId);
   String fwdInfoId = createForwarderInfo(accountId);

   Reticle__c reticle = createReticle('A1000', accountId, cycle, 500, userInfo.getUserId(), true, 'Binary',
    'US', 'Pending to Notify Customer');
   insert reticle;

   Test.startTest();
   List < Reticle__c > lstReticle = ROS_ControllerSearchReticlePortalUsers.queryReticlesSystemMode('select id from Reticle__c limit 1');
   PageReference myVfPage = Page.ROS_ReticleDetail;
   Test.setCurrentPage(myVfPage);
   ApexPages.StandardController sc = new ApexPages.StandardController(reticle);
   ROS_ControllerSearchReticlePortalUsers testController = new ROS_ControllerSearchReticlePortalUsers(sc);
   testController.UserType = 'Customer';
   testController.displayReticle();
   Database.QueryLocator dq = ROS_ControllerSearchReticlePortalUsers.queryReticlesSystemMode2('select id from Reticle__c limit 5');
   System.assert(dq.getQuery() != null);
   Test.stopTest();
  }
  //DBiswal 01112016
 static testMethod void method_eucformtest1() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW', 'GlobalShuttle MPW'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();
  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();
  Opportunity opp = createOpp(accountId);
  Opportunity_Program__c oppProg = createOppProg(accountId, opp.Id);

  Reticle__c reticle = createReticle('A1005', accountId, cycle, 500, userInfo.getUserId(), true, 'PSM', 'US', 'Pending for Customer Feedback');
  insert reticle;
  reticle.FabStr__c = 'FAB 3;FAB 2';
  reticle.HS_Code__c = 'hs123';
  reticle.GlobalFoundries_Device_ID__c = '1313AA-U011';
  Test.startTest();
  update reticle;


  Device__c device = createDev(accountId, opp.Id, oppProg.Id, '1313AA-U011');

  ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
  obj.Summaries.add(new ROS_ControllerSearchReticleGFForm.ReticleWrapper(reticle, true));
  obj.SelReturnReticles.add(new SelectedReticleWrapper(reticle));
  obj.SelReturnReticles.get(0).isChecked = true;
  obj.devselected = device.Id;
  obj.Category = 'pCstfdbk';
  obj.eucEmailId = 'xyz@xyz.com';
  obj.shippingArea = 'Within Singapore';
  obj.Reticlesearch();
  obj.ShipaddressAccountId();
  obj.sendeucMail();
  obj.closeeucPopup();
  System.assertEquals(false, obj.displayeucPopup);
  obj.editeucForm();

  //System.assertEquals('',obj.eucEmailId);
  obj.saveeucForm();
  //obj.disPSMRets();
  // System.assertEquals(true,obj.dispRetsec); 
  obj.eucAttachReset();
  obj.eucAttachupload();
  System.assertEquals(false, obj.checkeucupload);
  obj.refresheucForm();
  obj.getAreas();
  obj.getAddress();
  //obj.getselectedFwdInfo1();
  string add = 'add';
  obj.setselectedAddress1(add);
  obj.getTotalRecords();
  // obj.exportCsvFile();
  Test.stopTest();
 }
 static testMethod void method_eucformtest2() {
  loadCustomSettings();
  List < Environment_Variable__c > lstEnv = new List < Environment_Variable__c > ();
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE', '50'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_RETROFIT', 'Retrofit'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', 'Single Product'));
  lstEnv.add(ROS_ControllerSearchReticleGFForm2_Test.assignEnvironmentVar('DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW', 'GlobalShuttle MPW'));
  insert lstEnv;

  String accountId = DeviceUtilTest.createAccount();

  String Cycle = createReticleCycle();
  String fab = createFab();
  createROSQueryDataSettings();

  Reticle__c reticle = createReticle('A1005', accountId, cycle, 500, userInfo.getUserId(), true, 'PSM', 'US', 'Pending for Customer Feedback');
  insert reticle;
  reticle.FabStr__c = 'FAB 3;FAB 2';
  reticle.Invalid__c = false;
  reticle.ROS_Status__c = 'Return';
  reticle.GlobalFoundries_Device_ID__c = '1313AA-U011';
  reticle.Reticle_Workflow_Status__c = 'Pending for EUC Form';
  Opportunity opp = createOpp(accountId);
  Opportunity_Program__c oppProg = createOppProg(accountId, opp.Id);
  Test.startTest();
  Device__c device = createDev(accountId, opp.Id, oppProg.Id, '1313AA-U011');
  update reticle;
  Contact con = createContact(accountId);

  System.assert(device.Id != null);
  List < Reticle__c > rctL = new List < Reticle__c > ();
  rctL.add(reticle);
  System.assertEquals('Pending for EUC Form', reticle.Reticle_Workflow_Status__c);
  PageReference pageRef = Page.ROSVF_SearchReticlesGFForm;
  Test.setCurrentPage(pageRef);
  //ApexPages.StandardSetController conSet = new ApexPages.StandardSetController(rctL));

  ROS_ControllerSearchReticleGFForm obj = new ROS_ControllerSearchReticleGFForm();
  ROS_ControllerSearchReticleGFForm.eucConWrapper eucwrap = new ROS_ControllerSearchReticleGFForm.eucConWrapper(con, true);

  obj.devselected = device.Id;
            obj.Category = 'pEucForm';
            obj.accId = accountId;
            obj.eucEmailId = '';
            obj.Reticlesearch();
            obj.euclookupinit();
            obj.closeeucPopup();
            obj.editeucForm();
            obj.reseteucform();
            obj.saveeucForm();
            obj.disPSMRets();
            obj.eucAttachReset();
            obj.sendeucMail();
            obj.attachCusFeedback();
            obj.retIdSet.add(reticle.id);
            obj.reDirectForm();
            
           // System.assertEquals(true,obj.displayeucMsg);
            
            PageReference pgRef1 = Page.ROSVF_eucConLookup;
            Test.setCurrentPageReference(pgRef1);
            ApexPages.currentPage().getParameters().put('accid', accountId);
            ApexPages.currentPage().getParameters().put('eucEmailId', 'xyz@xyz.com');
            obj.euclookupinit();
           // System.assert(obj.accId != null);
            
            PageReference pgRef2 = Page.ROSVF_eucAttachment;
            Test.setCurrentPageReference(pgRef2);
            ApexPages.currentPage().getParameters().put('devid', device.Id);
            ApexPages.currentPage().getParameters().put('retid', reticle.Id);
            ApexPages.currentPage().getParameters().put('status', 'Pending for STF Obsolescence');
            Attachment testAttach = new Attachment();
            testAttach.Name = 'Unit Test Attachment';
            testAttach.Body = Blob.valueOf('Unit Test Attachment Body');
            obj.shippingArea = 'Outside of Singapore';
            obj.eucAttach = testAttach;
            obj.eucAttachupload();
            obj.refresheucForm();
            obj.cancelCustFeedback();
            obj.notifyCSR();
            Set<string>stList = new  Set<string>();
            string cycle1='';
            obj.findDevRet(stList,cycle1);
            //System.assertEquals(true,obj.displayeucPopup);
             updateHSCodeBatch bt = new updateHSCodeBatch();
            database.executebatch(bt);
           Test.stopTest();
 }

}