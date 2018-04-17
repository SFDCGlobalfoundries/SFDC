@isTest
public class ClsNewCPKReportTest{

    public static Account account1;
    public static Account account2; 
	public static Account account3; 
    public static Contact contact;
    public static User portalUser;
    public static User usr1;
    // Calling AccountData Factory class for populating 
    public static Account acc;
    public static String rt = [SELECT Id FROM Recordtype WHERE SobjectType = 'Account' and DeveloperName = 'Customer'].id;
    public static CPK_Report__c createCPKReport(String technology, String geometry, Date reportDueDate, ID fabId, String reportCycle,
                                                Id userId, String reportCycleDay){ 
        return new CPK_Report__c(Technology__c = technology, Geometry__c = geometry, Reminder__c = reportDueDate, FABS__C = fabId,
                                 Report_Cycle__c = reportCycle, PI_Owner_1__c = userId, Report_Cycle_Day__c = reportCycleDay); 
    }
    
    public static CPK_Report__c createCPKReport1(String technology, String geometry, Date reportDueDate, ID fabId, String reportCycle,
                                                Id userId, String reportCycleDay, String ASICReport){ 
        return new CPK_Report__c(Technology__c = technology, Geometry__c = geometry, Reminder__c = reportDueDate, FABS__C = fabId,
                                 Report_Cycle__c = reportCycle, PI_Owner_1__c = userId, Report_Cycle_Day__c = reportCycleDay, 
                                 ASIC_Report__c =ASICReport); 
    }
    
    public static Monthly_CPK_Report__c createMonthlyCPKReport(String name, String status, Id cpkReportId){ 
        return new Monthly_CPK_Report__c(Name = name, Approved__c = status, CPK_Report__c = cpkReportId); 
    }
    
    public static CPK_Report_Access_List__c createCPKReportAccessList(Id accountId, Id cpkReportId){
        return new CPK_Report_Access_List__c(Account__c = accountId,CPK_Report__c = cpkReportId);
    }
    
    public static Report_Upload__c createCPKReportUpload(String fileName, Id monthlyReportId ){
        return new Report_Upload__c(File_Name__c = fileName, Monthly_CPK_Report__c = monthlyReportId);
    }
    
    public static FAB__c createFab(String fabName, Boolean isActive, Boolean isQualityReports){
        return new FAB__c(Name = fabName, IsActive__c = isActive,IsQualityReports__c = isQualityReports);
    }
        
    public static Fab_User__c createFabUser(Id fabId, Boolean isQualityReports, Id userId){ 
        return new Fab_User__c(FAB__c = fabId,IsQualityReports__c = isQualityReports,user__c = userId);
    }
    
    public static User createUser(){
        
        HCM_Employee__c hcmEmployee = new HCM_Employee__c();
        hcmEmployee.Login_ID__c = 'testHCM';
        hcmEmployee.Last_Name__c = 'TestGFSysUser';
        hcmEmployee.First_Name__c = 'Test';
        hcmEmployee.Department_Name__c =  'IT';
        hcmEmployee.Email_Address__c = 'testCSRnUser@test.com';
        hcmEmployee.Job_Title__c = 'TestTitle';
        hcmEmployee.Phone_Number__c =  '999999999';
        hcmEmployee.Employee_ID__c = '123456';
        insert hcmEmployee;
        
    
        Profile systemCSRProfile = [select id from Profile  where Name like '%GF System Admin%' LIMIT 1];
        usr1 = new User();           
        usr1.Alias= 'GFsys';
        usr1.Email= 'testGFSysUser@test.com';
        usr1.EmailEncodingKey= 'UTF-8';
        usr1.LastName = 'TestGFSysUser';
        usr1.FirstName = 'Test';
        usr1.LanguageLocaleKey = 'en_US';
        usr1.LocaleSidKey = 'en_US';
        usr1.ProfileId = systemCSRProfile.Id;
        usr1.TimeZoneSidKey = 'America/Los_Angeles';
        usr1.UserName = 'testGFSysUser@test.com'; 
        usr1.Fab_Assigned__c = 'FAB 1'; 
        usr1.IsActive = true;
        usr1.FederationIdentifier = '123456';
        usr1.ManagerId = UserInfo.getUserId();
        insert(usr1);
        return usr1;
    }
    
    public static void setupData(){
        DataUtilTest.LoadATPEnvVariables();                                                         
        Schema.DescribeSObjectResult descSobjResult = Schema.SObjectType.Account; 
        Map<String, Schema.RecordtypeInfo> recordTypeMap = descSobjResult.getRecordTypeInfosByName();// = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;

        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'abc');        
        fieldValueMap.put('sub_type__c', 'mytest1');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');         
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('Tech_Geo_Granted__c','0.15UM');
        fieldValueMap.put('Tech_Geo_Granted__c','0.028UM');
        fieldValueMap.put('RecordTypeId',rt);
        fieldValueMap.put('Short_Name__c','a326gr');
        fieldValueMap.put('Authorized_for_ASIC_business__c','YES');
            
      acc =  AccountDataFactory.createAccount(fieldValueMap);
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');            
        fieldValueMap1.put('stage__c', 'abc');        
        fieldValueMap1.put('sub_type__c', 'mytest2');
        fieldValueMap1.put('site_department__c', 'test dept');          
        fieldValueMap1.put('transaction_type__c', 'transactional');                          
        fieldValueMap1.put('region__c', 'APJ');         
        fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Corporate_City__c', 'Test City');                
        fieldValueMap1.put('Corporate_Country__c', 'India');
        fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 2');          
        fieldValueMap1.put('Bill_To_City__c', 'Test City1');            
        fieldValueMap1.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap1.put('Fab_9_10__c','No');
        //fieldValueMap.put('Tech_Geo_Granted__c','0.15UM');
        fieldValueMap1.put('Tech_Geo_Granted__c','0.028UM');
        fieldValueMap1.put('RecordTypeId',rt);
        fieldValueMap1.put('Short_Name__c','a346gr');
        fieldValueMap1.put('Authorized_for_ASIC_business__c','YES');
            
      account2 =  AccountDataFactory.createAccount(fieldValueMap1);
	  
      
        Map<String,Object> fieldValueMap2 = new Map<String,Object>();
        fieldValueMap2.put('Name', 'MYTEST ACCOUNT3');            
        fieldValueMap2.put('stage__c', 'Qualified');        
        fieldValueMap2.put('sub_type__c', 'mytest3');
        fieldValueMap2.put('site_department__c', 'test dept');          
        fieldValueMap2.put('transaction_type__c', 'transactional');                          
        fieldValueMap2.put('region__c', 'APJ');         
        fieldValueMap2.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap2.put('Corporate_City__c', 'Test City');                
        fieldValueMap2.put('Corporate_Country__c', 'India');
        fieldValueMap2.put('Bill_To_Address_1__c', 'Test Address 2');          
        fieldValueMap2.put('Bill_To_City__c', 'Test City3');            
        fieldValueMap2.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap2.put('Fab_9_10__c','Yes');
        //fieldValueMap.put('Tech_Geo_Granted__c','0.15UM');
        fieldValueMap2.put('Tech_Geo_Granted__c','0.028UM');
        fieldValueMap2.put('RecordTypeId',rt);
        fieldValueMap2.put('Short_Name__c','testShortName');
        fieldValueMap2.put('Authorized_for_ASIC_business__c','YES');
		fieldValueMap2.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap2.put('Market_Segment__c','Consumer'); 
		fieldValueMap2.put('Process_Tech_Interested__c','MEM');
		fieldValueMap2.put('Total_Employee__c',11);
        fieldValueMap2.put('Bill_To_Location__c','test Location');
		fieldValueMap2.put('Financial_Territory__c','US-East');	
		
      account3=  AccountDataFactory.createAccount(fieldValueMap2);

        List<Account> listOfAcc = new List<Account>();  
        List<Id> listOfAccIds = new List<Id>();

        // Calling AccountData Factory class for populating 
        listOfAcc.add(acc);
        listOfAccIds.add(acc.Id);
    }
    
   
    //following testMethods for ClsNewCPKReport
    
    //Test method for validiating CPK Report record
    static testMethod void testSavingI(){
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        Test.startTest();
        clsNewCPKReport.Saving();
        Test.stopTest();
    }
    
    //Test method for Positive test case 
    static testMethod void testSavingQualified(){
        setupData();
        account3 = getAccount('MYTEST ACCOUNT3');
        acc = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        //DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadFabEnvVariables();
        FAB__c fab = createFab('FAB 9', true, true);
        insert fab;
        User userObj = createUser();
        Fab_User__c fabUser = createFabUser(fab.Id, true,  userObj.Id);
        insert fabUser;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        clsNewCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null,'Geometry');
        Test.startTest();
        clsNewCPKReport.category = 'Qual Customer';
        clsNewCPKReport.rightvalues = new Set<String>();
        clsNewCPKReport.leftvalues = new set<String>();
        clsNewCPKReport.rightvalues.add(acc.id);
        clsNewCPKReport.rightvalues.add(account3.id);
        clsNewCPKReport.rightvalues.add(account2.id);
        
        clsNewCPKReport.leftvalues.add(acc.id);
        clsNewCPKReport.leftvalues.add(account2.id);
        clsNewCPKReport.leftvalues.add(account3.id);
        
        Map<Id,Account> tempMap = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c,Tech_Geo_Granted__c FROM Account WHERE Id IN: clsNewCPKReport.leftvalues]);
		Map<Id,Account> tempMap1 = new Map<Id,Account>([SELECT Id,Authorized_for_ASIC_business__c,Tech_Geo_Granted__c FROM Account WHERE Id IN: clsNewCPKReport.rightvalues]);
               
        clsNewCPKReport.populateSelectList();
        clsNewCPKReport.rightvalues = new Set<String>();
        clsNewCPKReport.getPopulateCustomerSelectOption();
        clsNewCPKReport.Saving();
        
        system.assert(tempMap !=null);
        system.assert(!tempMap.isEmpty());
        //clsNewCPKReport.ShowAsicCustomer();
        Test.stopTest();
    }
    
    //Test method for Positive test case 
    static testMethod void testSavingII(){
        setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        //DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadFabEnvVariables();
        FAB__c fab = createFab('FAB 9', true, true);
        insert fab;
        User userObj = createUser();
        Fab_User__c fabUser = createFabUser(fab.Id, true,  userObj.Id);
        insert fabUser;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        clsNewCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null,'ASIC');
        Test.startTest();
        clsNewCPKReport.category = 'Customer';
        clsNewCPKReport.resetAccount();
        clsNewCPKReport.Saving();
        //clsNewCPKReport.ShowAsicCustomer();
        Test.stopTest();
    }
    
    static testMethod void testSavingIII(){
        setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        //DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadFabEnvVariables();
        FAB__c fab = createFab('FAB 9', true, true);
        insert fab;
        User userObj = createUser();
        Fab_User__c fabUser = createFabUser(fab.Id, true,  userObj.Id);
        insert fabUser;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        clsNewCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null,'ASIC');
        Test.startTest();
        clsNewCPKReport.category = 'Auth Customer';
        clsNewCPKReport.resetAccount();
        clsNewCPKReport.Saving();
        //clsNewCPKReport.ShowAsicCustomer();
        Test.stopTest();
    }
    
    static testMethod void testSavingIV(){
        setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        //DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadFabEnvVariables();
        FAB__c fab = createFab('FAB 9', true, true);
        insert fab;
        User userObj = createUser();
        Fab_User__c fabUser = createFabUser(fab.Id, true,  userObj.Id);
        insert fabUser;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        clsNewCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), null,null);
        Test.startTest();
        clsNewCPKReport.category = 'Qual Customer';
        clsNewCPKReport.asiccustomerFlag = false;
        clsNewCPKReport.custMap.put(account1.Id,account1.Name+'('+account1.Short_Name__c+')');
        clsNewCPKReport.rightvalues = new Set<String>();
        clsNewCPKReport.resetAccount();
        clsNewCPKReport.Saving();
        //clsNewCPKReport.ShowAsicCustomer();
        Test.stopTest();
    }
    //Test method for savenew functionality
    static testMethod void testSaveNew(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsNewCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 6', true, true);
        clsNewCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        Test.startTest();
        clsNewCPKReport.resetAccount();
        clsNewCPKReport.saveNew();
        Test.stopTest();
    }
    
    //Test method for Createfolder functionality positve test case
    static testMethod void testCreatefolder1(){
        Test.startTest();
        setupData();
        DataUtilTest.LoadFabEnvVariables();
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        envList.add(QS_TestUtil.createENVariable('CPK_service_enable','TRUE'));
        insert envList;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('0.028UMLPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        insert clsCPKReport.cpkReport;
        clsCPKReport.isError = false;
        clsCPKReport.Createfolder();
        Test.stopTest();
    }
    
      //Test method for Createfolder functionality positve test case
    static testMethod void testCreatefolder3(){
        setupData();
        DataUtilTest.LoadFabEnvVariables();
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        envList.add(QS_TestUtil.createENVariable('CPK_service_enable','TRUE'));
        insert envList;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('0.028UMLPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        clsCPKReport.cpkReport.ASIC_Report__c = 'ASIC';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'No';
        insert clsCPKReport.cpkReport;
        Test.startTest();
        clsCPKReport.isError = false;
        clsCPKReport.Createfolder();
        Test.stopTest();
    }
    
     //Test method for Createfolder functionality positve test case
        static testMethod void testCreatefolder4(){
        setupData();
        DataUtilTest.LoadFabEnvVariables();
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        envList.add(QS_TestUtil.createENVariable('CPK_service_enable','TRUE'));
        insert envList;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 9', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('0.028UMLPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        clsCPKReport.cpkReport.ASIC_Report__c = '';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'No';
        insert clsCPKReport.cpkReport;
        clsCPKReport.isError = false;
        Test.startTest();
        
        clsCPKReport.Createfolder();
        Test.stopTest();
    }
    
        static testMethod void testCreatefolder5(){
        setupData();
        DataUtilTest.LoadFabEnvVariables();
        List<Environment_Variable__c> envList = new List<Environment_Variable__c>();
        envList.add(QS_TestUtil.createENVariable('Quality Endpoint URl', 'Test Create Folder Service'));
        envList.add(QS_TestUtil.createENVariable('CPKReportCycleDay', '10'));
        envList.add(QS_TestUtil.createENVariable('CPK_service_enable','TRUE'));
        insert envList;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('0.028UMLPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        clsCPKReport.cpkReport.ASIC_Report__c = 'Geometry';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'No';
        insert clsCPKReport.cpkReport;
        Test.startTest();
        clsCPKReport.isError = false;
        clsCPKReport.Createfolder();
        Test.stopTest();
    }    
    
    //Test method for Createfolder functionality negative test case
    static testMethod void testCreatefolder2(){
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        Apexpages.StandardController  stdCntrl = new ApexPages.StandardController(new CPK_Report__c());
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(stdCntrl);
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        insert clsCPKReport.cpkReport;
        Test.startTest();
        clsCPKReport.isError = true;
        clsCPKReport.ErrorMessage = 'Test Error';
        clsCPKReport.Createfolder();
        Test.stopTest();
    }
    
    //Test select option scenarios
    static testMethod void testSelectOption1(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport();
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','Geometry');
        insert clsCPKReport.cpkReport; 
        Test.startTest();
        clsCPKReport.resetAccount();
        clsCPKReport.getPopulateCustomerSelectOption();
        clsCPKReport.leftselected.add(acc.Id); 
        clsCPKReport.selectclick();
        clsCPKReport.leftvalues.add(acc.Id); 
        clsCPKReport.selectallclick();
        Test.stopTest();
    }
    
    //Test unselect option scenarios
    static testMethod void testUnselectOption2(){
        setupData();
        account1 = getAccount('MYTEST ACCOUNT1');
        account2 = getAccount('MYTEST ACCOUNT2');
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env;
         ClsNewCPKReport clsCPKReport = new ClsNewCPKReport();
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        insert clsCPKReport.cpkReport;
        Test.startTest();        
        //clsCPKReport.rightvalues.add(acc.Id);
        clsCPKReport.rightvalues.add(account1.Id);
        clsCPKReport.rightvalues.add(account2.Id);
        clsCPKReport.resetAccount();
        //clsCPKReport.custMap.put(acc.Id,acc.Name+'('+acc.Short_Name__c+')');
        clsCPKReport.custMap.put(account1.Id,account1.Name+'('+account1.Short_Name__c+')');
        clsCPKReport.custMap.put(account2.Id,account2.Name+'('+account2.Short_Name__c+')');
        clsCPKReport.getPopulateCustomerUnSelectOption();
        clsCPKReport.rightselected.add(acc.Id);
        clsCPKReport.unselectclick();
        clsCPKReport.rightvalues.add(acc.Id);
        clsCPKReport.saving();
        clsCPKReport.unselectallclick();
        clsCPKReport.clickbtn();
        Test.stopTest();
    }
   // Test method for asicCustomer values
   static testMethod void testpopulateSelectList(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env; 
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(); 
        FAB__c fab1 = createFab('FAB 10', true, true);
        insert fab1; 
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab1.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        clsCPKReport.cpkReport.ASIC_Report__c = 'ASIC';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'Yes';
        insert clsCPKReport.cpkReport;
        
        
        Test.startTest();
        clsCPKReport.resetAccount();
        clsCPKReport.getPopulateCustomerSelectOption();
        clsCPKReport.leftselected.add(acc.Id);
        clsCPKReport.leftselected.add(acc.Id); 
        clsCPKReport.selectclick();
        clsCPKReport.leftvalues.add(acc.Id);
        clsCPKReport.leftvalues.add(acc.Id); 
        clsCPKReport.selectallclick(); 
        clsCPKReport.populateSelectList();
        clsCPKReport.addCustomerList(clsCPKReport.cpkReport.Id);
        Test.stopTest();
   }
   static testMethod void testpopulateSelectList1(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env; 
      ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(); 
        FAB__c fab1 = createFab('FAB 10', true, true);
        insert fab1; 
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab1.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        clsCPKReport.cpkReport.ASIC_Report__c = 'ASIC';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'No';
        insert clsCPKReport.cpkReport;
        
        
        Test.startTest();
        clsCPKReport.resetAccount();
        clsCPKReport.getPopulateCustomerSelectOption();
        clsCPKReport.leftselected.add(acc.Id);
        clsCPKReport.leftselected.add(acc.Id); 
        clsCPKReport.selectclick();
        clsCPKReport.leftvalues.add(acc.Id);
        clsCPKReport.leftvalues.add(acc.Id); 
        clsCPKReport.selectallclick(); 
        clsCPKReport.populateSelectList();
        clsCPKReport.custId = new Set<Id>();
        clsCPKReport.addCustomerList(clsCPKReport.cpkReport.Id);
        Test.stopTest();
   }
    
   static testMethod void testpopulateSelectList2(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env; 
        ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(); 
        FAB__c fab1 = createFab('FAB 10', true, true);
        insert fab1; 
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab1.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        clsCPKReport.cpkReport.ASIC_Report__c = 'Geometry';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'Yes';
        insert clsCPKReport.cpkReport;
        
        
        Test.startTest();
        clsCPKReport.resetAccount();
        clsCPKReport.getPopulateCustomerSelectOption();
        clsCPKReport.leftselected.add(acc.Id);
        clsCPKReport.leftselected.add(acc.Id); 
        clsCPKReport.selectclick();
        clsCPKReport.leftvalues.add(acc.Id);
        clsCPKReport.leftvalues.add(acc.Id); 
        clsCPKReport.selectallclick(); 
        clsCPKReport.populateSelectList();
        clsCPKReport.addCustomerList(clsCPKReport.cpkReport.Id);
        Test.stopTest();
   }
   static testMethod void testpopulateSelectList3(){
        setupData();
        Environment_Variable__c env = QS_TestUtil.createENVariable('CPKReportCycleDay', '10');
        insert env; 
      ClsNewCPKReport clsCPKReport = new ClsNewCPKReport(); 
        FAB__c fab1 = createFab('FAB 10', true, true);
        insert fab1; 
        clsCPKReport.cpkReport = createCPKReport1('28LPS', '0.15UM', System.Today() + 5, fab1.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        clsCPKReport.cpkReport.ASIC_Report__c = 'Geometry';
        clsCPKReport.cpkReport.For_All_ASIC_Customers__c = 'No';
        insert clsCPKReport.cpkReport;
        
        
        Test.startTest();
        clsCPKReport.resetAccount();
        clsCPKReport.getPopulateCustomerSelectOption();
        clsCPKReport.leftselected.add(acc.Id);
        clsCPKReport.leftselected.add(acc.Id); 
        clsCPKReport.selectclick();
        clsCPKReport.leftvalues.add(acc.Id);
        clsCPKReport.leftvalues.add(acc.Id); 
        clsCPKReport.selectallclick(); 
        clsCPKReport.populateSelectList();
        clsCPKReport.custId = new Set<Id>();
        clsCPKReport.addCustomerList(clsCPKReport.cpkReport.Id);
        Test.stopTest();
   }    
    
    //test method for before delete and after delete CPK Report operation
    static testMethod void testDeleteCPKReport(){
        setupData();
        createUser();
        DataUtilTest.LoadFabEnvVariables();
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        Fab_User__c fabUser = createFabUser(fab.Id, true,  usr1.Id);
        insert fabUser;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        cpkReport.PI_Owner_2__c = userInfo.getUserId();
        cpkReport.PI_Owner_3__c = userInfo.getUserId();
        cpkReport.QA_Approver__c = usr1.id;
        cpkReport.QA_Approver_backUp__c = usr1.id;
        insert cpkReport;
        Test.startTest();
        QS_CPKReportTriggerHandler.isExecuted = false;
        cpkReport.Stage__c = 'Pending PI Approval';
        update cpkReport;
        QS_CPKReportTriggerHandler.isExecuted = false;
        cpkReport.Stage__c = 'Approved';
        update cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;

        Report_Upload__c reportUploaded = createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        insert reportUploaded;
        CPK_Report_Access_List__c qcAssociatedCustomer = createCPKReportAccessList(acc.Id, cpkReport.Id);
        insert qcAssociatedCustomer;
        delete cpkReport;
        Test.stopTest();
    }
    
    
    //test method for before delete and after delete Report operation
    static testMethod void testDeleteReport(){
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        cpkReport.ReadyToUpload__c = true;
        cpkReport.ReportUploaded__c = true;
        insert cpkReport;
        
        Monthly_CPK_Report__c monthlyCPKReport = createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        monthlyCPKReport.OpenTextId__c = '1222222';
        update monthlyCPKReport;
        Test.startTest();
        delete monthlyCPKReport;
        Test.stopTest();
    }
    static testMethod void testUpdateAccessList(){
        setupData();
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        cpkReport.ReadyToUpload__c = true;
        cpkReport.ReportUploaded__c = true;
        insert cpkReport;
        CPK_Report_Access_List__c cpkReportAccessList = createCPKReportAccessList(acc.Id, cpkReport.Id);
        insert cpkReportAccessList;
        cpkReportAccessList = [Select Id, Account__c, FAB__c, CPK_Report__c From CPK_Report_Access_List__c where Id =: cpkReportAccessList.Id Limit 1];
        User testUser = new User(Id = UserInfo.getUserId(), Fab_Assigned__c = 'FAB 6');
        List<Account_Team_Proxy__c> lstATP = new List<Account_Team_Proxy__c>();
        Map<String, List<Account_Team_Proxy__c>> accountTeamProxyListMap = new Map<String, List<Account_Team_Proxy__c>>();
        Account_Team_Proxy__c atp = createAccountTeamProxy(cpkReportAccessList.Account__c,testUser.Id,'Customer Engineer');
        atp.User__r = testUser;
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        lstAtp.add(atp);
        accountTeamProxyListMap.put(cpkReportAccessList.Account__c,lstAtp);
        Test.startTest();
        ClsUpdateCPKReportOnReportUpload.UpdateAccessList(cpkReportAccessList, accountTeamProxyListMap );
        Test.stopTest();

    }
    
    //test method for before delete and after delete CPK Report Document operation
    static testMethod void testDeleteCPKReportDocument(){
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        insert reportUploaded;
        Test.startTest();
        delete reportUploaded;
        Test.stopTest();
    }
    
    //test method for before delete and after delete CPK Report access List operation
    static testMethod void testDeleteCPKReportAccessList(){
        createUser();
        setupData();
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Draft';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        insert reportUploaded;
        Account_Team_Proxy__c acteampr = new Account_Team_Proxy__c();
        acteampr.Account__c = acc.Id;
        acteampr.User__c = usr1.Id;
        acteampr.Team_Role__c = 'Customer Engineer';
        acteampr.Account_Access__c = 'Read/Write';
        acteampr.Opportunity_Access__c = 'Read/Write';
        acteampr.Case_Access__c = 'Read Only';
        insert acteampr;
        CPK_Report_Access_List__c qcAssociatedCustomer = createCPKReportAccessList(acc.Id, cpkReport.Id);
        insert qcAssociatedCustomer;
        
        Test.startTest();
        delete qcAssociatedCustomer;
        Test.stopTest();
    }
    
    //test method for before update and after update CPK Report Document operation
    static testMethod void testUpdateReportUpload(){
        FAB__c fab = createFab('FAB 6', true, true);
        insert fab;
        CPK_Report__c cpkReport = createCPKReport1('28LPS', '0.028UM', System.Today() + 5, fab.Id, 'Monthly',userInfo.getUserId(), '10','ASIC');
        cpkReport.Stage__c = 'Approved';
        cpkReport.OpenTextId__c = '111111';
        insert cpkReport;
        Monthly_CPK_Report__c monthlyCPKReport = createMonthlyCPKReport('Test', 'Approved', cpkReport.Id);
        monthlyCPKReport.OpenTextId__c = '1111111';
        insert monthlyCPKReport;
        Report_Upload__c reportUploaded = createCPKReportUpload('test.doc', monthlyCPKReport.Id);
        insert reportUploaded;
        Test.startTest();
        reportUploaded.Last_Report_For_the_month__c = true;
        update reportUploaded;
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name, Short_Name__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
    static Account_Team_Proxy__c createAccountTeamProxy(String AccountId,String UserId,string Role){
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = UserId,Sequence_No__c='1',
                                                              Account_Role_ID__c='test',Account__c=AccountId ,Account_Access__c='Read/Write',
                                                              Opportunity_Access__c='Read/Write',Team_Role__c=Role,
                                                              fab_assignment__c = 'FAB 6');
       
        
        return atp;
    }
    
}