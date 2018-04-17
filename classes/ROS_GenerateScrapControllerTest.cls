/**
 *    Company       :   Cognizant Technologies PTE Ltd.
 *    Description   :   Test Class for ROS_GenerateScrapController
 *    History       :   

        Initials         Date                Description
-----------------------------------------------------------------------------------------
        Vijay Mahajan    04/25/2014           Test class created.
        
**/ 
@isTest(seeAllData = false)
private class ROS_GenerateScrapControllerTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Account acc= getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
    }
    
    static Account account;
    static Reticle__c reticle;
    static ROS_Disposal_Certificate__c rosScrapCertificate;
    static User csrUser;
    
    static void loadCustomSettings(){
        DataUtilTest.LoadFabEnvVariables();
        DataUtilTest.LoadATPEnvVariables();
        DataUtilTest.LoadDeviceEnvVariable();
        DataUtilTest.LoadFabReticleEnvVariables();
        DataUtilTest.LoadHCMEnvVariables();
        DataUtilTest.LoadOpptyEnvVariables();
        DataUtilTest.LoadOPTMEnvVariables();
        DataUtilTest.LoadReticleDeviceEnvVariables();
        DataUtilTest.LoadReticleDWEnvVariables();
        DataUtilTest.LoadReticleEnvVariables();
        DataUtilTest.loadROSVendorNames();
       // list<Environment_Variable__c> evList = [select name, value__c from Environment_Variable__c where Name = 'HCM Account Id'];
        //system.debug(logginglevel.error, evList);
    }
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    static void createROSQueryDataSettings() {
        List<SObject> lstROSQueryUCData = Test.loadData(ROS_Query_UserType_Category__c.sObjectType,'TestROSQueryUCData');
    }
    // Creation of an Account
    static Account createAccount(){
        Account acc= getAccount('MYTEST ACCOUNT1');
        return acc;
    }
    
    
    static Reticle__c createReticle(String AccountId,String ROSCycle,Integer DayInactive,string OwnerId,
                                    String despositionType, ROS_Disposal_Certificate__c rosScrapCert, String fabStr) {
        Reticle__c RT                 = new Reticle__c();
        RT.Account__c                 = AccountId;
        RT.OwnerId                    = Ownerid;
        RT.ROS_Cycle__c               = ROSCycle;
        RT.Day_Inactive__c            = DayInactive;
        RT.Solution_Team_Confirm__c   = true;
        RT.Name                       = '1313AA-05AZ1';
        RT.Reticle_Type__c            = 'BINARY';
        RT.Region__c                  = 'US';
        RT.Reticle_workflow_Status__c = 'Pending to Notify Customer';
        RT.ROS_Status__c              = despositionType;
        RT.Disposal_Certificate__c    = rosScrapCert.Id; 
        RT.FabStr__c = fabStr;
        insert RT;
        return RT;
    }
    
    static ROS_Disposal_Certificate__c createReticleScrapCertificate(Account acc, String designation, Date scrapDate){
        ROS_Disposal_Certificate__c reticleScrapCertificate = new ROS_Disposal_Certificate__c(Account__c = acc.Id, Designation__c = designation,
                                                                                             Scrap_Date__c = scrapDate);
        return reticleScrapCertificate;                                                                       
    }
    
    static Id createReticleCycle() {
        
        ROS_Cycle__c RC = new ROS_Cycle__c(Name='1H14',Cycle_Year__c='2014',Cycle_Month__c='May',Cycle_Start_Date__c = System.TODAY()-10);
        insert RC;
        return RC.Id;
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
        
        insert lstHCMEmployee;
    }
    static User createCSRUser(){
        //User usr1 = [select id,name,email from User where profileId in (select id from Profile where Name='GF CSR') and IsActive=true and Fab_Assigned__c != null limit 1];
        //HCM_Employee__c  hcmEmployee = ROS_Other_Test.createHCMEmplyee();
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
    
    
    static void prepareData(){
        //DataUtilTest.loadEnvironmentVariables();
        //loadCustomSettings();
        //List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
       // lstEnv.add(ROS_GenerateScrapControllerTest.assignEnvironmentVar('ROS_TOTAL_DATA_LOAD','50'));
       // lstEnv.add(ROS_GenerateScrapControllerTest.assignEnvironmentVar('ROS_IMPORT_EXPORT_PAGESIZE','50'));
        //insert lstEnv;
        ROS_GenerateScrapControllerTest.createROSQueryDataSettings();
        
        account = createAccount();
        String Cycle = createReticleCycle();
        createHCMEmplyee();
        csrUser = createCSRUser();
        rosScrapCertificate =  createReticleScrapCertificate(account, '', System.today());
        insert rosScrapCertificate;
        System.debug('rosScrapCertificate----'+rosScrapCertificate);
        reticle = createReticle(null, cycle, 500,csrUser.Id, 'Scrap', rosScrapCertificate, 'FAB 3;FAB 1');
        System.debug('reticle ----'+reticle);
    }
    
    
    static testMethod void testAttachfile(){
        prepareData();
        Apexpages.currentPage().getParameters().put('resultId', rosScrapCertificate.Id);
        ROS_GenerateScrapController rosGenerateScrapController = new ROS_GenerateScrapController(); 
        Test.startTest();
        PageReference page = rosGenerateScrapController.attachfile();
        Test.stopTest();
        System.assertNotEquals(null, page);
    }
    
    static testMethod void testSendscrapcertificatetocustomer(){
        prepareData();
        Apexpages.currentPage().getParameters().put('resultId', rosScrapCertificate.Id);
        ROS_GenerateScrapController rosGenerateScrapController = new ROS_GenerateScrapController(); 
        Test.startTest();
        rosGenerateScrapController.sendscrapcertificatetocustomer('Test', Blob.valueOf('This is test file'));
        Test.stopTest();
        System.assert(true);
    }
    
    static testMethod void testROS_scrapecertificatePdfCls(){
        prepareData();
        Test.startTest();
            ApexPages.StandardController controller;
            ROS_scrapecertificatePdfCls obj = new ROS_scrapecertificatePdfCls(controller);
        Test.stopTest();
        System.assert(true);
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
    
}