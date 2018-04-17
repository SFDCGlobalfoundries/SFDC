/*
    Author: Abhita Bansal
    Created Date: 14/09/2015 
    Description: Test class for MPWTrainScheduleTranxController
*/
@isTest
public class MPWTrainScheduleTranxControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static Account utilDataAccMethod() {
    
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        
         Account account= new Account();
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
        fieldValueMap.put('ownerId',thisUser.Id);
        fieldValueMap.put('recordtypeid', recordType.id);  
        account= AccountDataFactory.createAccount(fieldValueMap);
        return account;
    }
    
    private static Account utilDataAccMethod1(Account account) {
    
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
         Account account1= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT3');            
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
        
        fieldValueMap.put('recordtypeid', recordType.id);  
        account1= AccountDataFactory.createAccount(fieldValueMap);
        
        return account1;
    }
    
    private static Account utilDataAccMethod2() {
    
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
         Account account1= new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT2');            
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
                fieldValueMap.put('recordtypeid', recordType.id);  
        account1= AccountDataFactory.createAccount(fieldValueMap);
        return account1;
        
        
    }
    
    private static Account_Hierarchy__c utilDataAccHMethod(Account account , Account account1) {
        
        Account_Hierarchy__c mpwAccountH = new Account_Hierarchy__c();
        mpwAccountH.Account_Id__c = account1.Id;
        mpwAccountH.Parent_Id__c = account.Id;
        insert mpwAccountH;
        
        return mpwAccountH;
    }
    
    private static Contact utilDataConMethod(Account account) {
    
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = account.Id;
        con.Email = 'test1@test.com';
        con.Department__c='Design';
        insert con;  
        
        return con;
    }
    
    private static User utilDataUserMethod(Contact con) {
        
        User u = new User();
        u.LastName = 'LastName';
        u.Alias = 'Test1';
        u.Email = 'test1@test.com';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [Select Id,Name from Profile where Name = 'Customer Portal Admin'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.UserName = 'test1@test.com.mpwdev';
        u.Portal_login__c = 'xyz';
        u.ContactId = con.Id;
        u.IsActive = true;
        u.CommunityNickname = 'Testtest123';
        insert u;
        
        return u;
    }
    
    private static MPW_Train_Account__c utilDataTAMethod(Account account1, MPW_Train_Maintenance__c mpwTrainMaintenance) {
    
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account1.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        return mpwTrainAccount;
    }
    
    private static List<Account_Team_Proxy__c> utilDataAccPMethod(Account a) {
        
        List<Account_Team_Proxy__c> accountProxyList =  new List<Account_Team_Proxy__c>();
        
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = a.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        insert accProxy;
        accountProxyList.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = a.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        insert accProxy1;
        accountProxyList.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = a.Id;
        accProxy2.Team_Role__c = 'Primary Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        insert accProxy2;
        accountProxyList.add(accProxy2);
        
        return accountProxyList;
    }  
    
    private static MPW_Geometry_Mapping__c utilDataGMMethod() {
    
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';  
        mpwGeoMap.Active__c = true;
        mpwGeoMap.Use_Process_Type__c = true; 
        mpwGeoMap.T2__c = 5;
        mpwGeoMap.T3__c = 6; 
        insert mpwGeoMap;
        
        return mpwGeoMap;
    }
    
    private static List<MPW_Settings__c> utilDataSettingMethod() {
        
        List<MPW_Settings__c> mpwSettingList = new List<MPW_Settings__c>();
        
        MPW_Settings__c mpwSetting = new MPW_Settings__c();
        mpwSetting.Name = '28nm_GlobalShuttle_Prefix';
        mpwSetting.Value__c = 'MPW03';
        mpwSettingList.add(mpwSetting);
        
        MPW_Settings__c mpwSetting1 = new MPW_Settings__c();
        mpwSetting1.Name = 'Maintenance_MPW_Schedule_Tab_Id';
        mpwSetting1.Value__c = System.Label.MPW_Maintain_Schedule_Tab_Id;
        mpwSettingList.add(mpwSetting1);
        
        if(!mpwSettingList.isEmpty()){
            insert mpwSettingList;
        }
        
        return mpwSettingList;       
    }
    
    private static MPW_Month__c utilDataMonthMethod() {
        
        MPW_Month__c  mpw = new MPW_Month__c();
        mpw.Name = 'Mid Sept';
        mpw.Sequence_No__c = 1;
        insert mpw;
        
        return mpw;       
    }
    
    private static MPW_Year__c utilDataYearMethod() {
        
        MPW_Year__c mpw = new MPW_Year__c();
        mpw.Name = '2015';
        insert mpw;
        
        return mpw;       
    }
    
    private static MPW_Process_Group__c utilDataPGMethod() {
    
        MPW_Process_Group__c mpwProcessGp = new MPW_Process_Group__c();
        mpwProcessGp.Name = '28nmGpName';
        mpwProcessGp.Active__c = true;
        mpwProcessGp.Fab__c = 'Fab1';
        mpwProcessGp.Geometry__c = '28nm';
        mpwProcessGp.Process__c = '28nmLP';
        
        insert mpwProcessGp;
        
        return mpwProcessGp;
    }
    
    private static MPW_Config_Settings__c utilDataCSMethod() {
        
        RecordType recordType =  [Select Id from RecordType where Name = 'Process' AND SObjectType = 'MPW_Config_Settings__c'];
    
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmLP';
        mpwConfig.RecordTypeId = recordType.Id;
        insert mpwConfig; 
        
        return mpwConfig;
    }
    
    private static MPW_Tech_Module__c utilDataTMMethod() {
    
        MPW_Tech_Module__c mpwTechModule = new MPW_Tech_Module__c();
        mpwTechModule.Active__c = true;
        mpwTechModule.Answers__c = 'Yes;No';
        mpwTechModule.Geometry__c = '28nm';
        mpwTechModule.Module_Description__c = 'N3';
        mpwTechModule.Module_Name__c = 'Triple well';
        mpwTechModule.Question__c = 'Do you need Triple well?:';
        insert mpwTechModule;
        
        return mpwTechModule;
    }    
      
    private static MPW_Train_Maintenance_Details__c utilDataTMDMethod(MPW_Tech_Module__c mpwTechModule, MPW_Train_Maintenance__c mpwTrain, MPW_Config_Settings__c mpwConfig) {
      
        MPW_Train_Maintenance_Details__c mpwTrainDetails = new MPW_Train_Maintenance_Details__c();
        mpwTrainDetails.Answers__c = 'Yes,No';
        mpwTrainDetails.MPW_Tech_Module__c = mpwTechModule.Id;
        mpwTrainDetails.MPW_Train_Maintenance__c = mpwTrain.Id;
        mpwTrainDetails.Process_Type__c = mpwConfig.Id;
        insert mpwTrainDetails;
        
        return mpwTrainDetails;
    }
    
    private static MPW_Reservation__c utilDataRFMethod(MPW_Train_Maintenance__c mpwTrainMaintenance) {
    
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        return mpwReservation1;        
    }
    
    private static MPW_Process_Information_Question__c utilDataPIQMethod(MPW_Train_Maintenance_Details__c mpwTrainDetails, MPW_Reservation__c mpwReservation1) {
        
        MPW_Process_Information_Question__c mpwprocessInfo = new MPW_Process_Information_Question__c();
        mpwprocessInfo.Answer__c = 'Yes;No';
        mpwprocessInfo.MPW_Maintenance_Details__c = mpwTrainDetails.Id;
        mpwprocessInfo.MPW_Reservation_Form__c = mpwReservation1.Id;
        insert mpwprocessInfo;
        
        return mpwprocessInfo;
    }
    
    public static testMethod void myTrainScheduleTranxMethod() {
    
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Status__c = '28nmGpName';
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.Cancellation_Deadline__c =  System.today()+5;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0311');
        
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Account account2 = utilDataAccMethod2();
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account1, mpwTrainMaintenance);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Edit');
        System.currentPageReference().getParameters().put('processId', mpwConfig.Id);
        System.currentPageReference().getParameters().put('processName', mpwConfig.Name);
        System.currentPageReference().getParameters().put('id', mpwTrainMaintenance.Id);
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.getProcessGroup();
        appMatrixClass.getFab();
        appMatrixClass.getProcesses();
        appMatrixClass.retrieveTechModules();
        appMatrixClass.editSelectedProcessModule();
        appMatrixClass.addProcess();
        appMatrixClass.getSelectedProcessTechModules();
        appMatrixClass.save();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.removeSelectedProcessModule();
        appMatrixClass.associateSelectedAccounts();
        appMatrixClass.searchAccountsKey = 'Test MPW1';
        appMatrixClass.searchAccounts();       
        appMatrixClass.getRenderAssociatedAccounts();
        appMatrixClass.calculateOtherDates();
        appMatrixClass.removeSelectedAccount();
        appMatrixClass.cloneMPW();
             
        appMatrixClass.selectedMonth = 'Mid Oct';
        appMatrixClass.selectedYear = '2015';
        appMatrixClass.selectedMonth1 = 'Early Oct';
        appMatrixClass.selectedYear1 = '2015';
        appMatrixClass.selectedMonth2 = 'End Nov';
        appMatrixClass.selectedYear2 = '2015';
        appMatrixClass.selectedMonth3 = 'Early Dec';
        appMatrixClass.selectedYear3 = '2015';
        appMatrixClass.monthValueStartOne();
        appMatrixClass.yearValueStartOne();
        appMatrixClass.monthValueEndOne();
        appMatrixClass.yearValueEndOne();
        appMatrixClass.monthValueStartTwo();
        appMatrixClass.yearValueStartTwo();
        appMatrixClass.monthValueEndTwo();
        appMatrixClass.yearValueEndTwo();
               
        Test.stopTest();
    }  
        
    public static testMethod void myTrainScheduleTranxMethod1() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0311');
        
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('processId', mpwConfig.Id);
        System.currentPageReference().getParameters().put('processName', mpwConfig.Name);
        System.currentPageReference().getParameters().put('id', mpwTrainMaintenance.Id);
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.save();
        appMatrixClass.getRenderAssociatedAccounts();
        appMatrixClass.getmonthList();
        appMatrixClass.getyearList();
        appMatrixClass.selectedMonth = 'Mid Sept';
        appMatrixClass.selectedYear = '2015';
        appMatrixClass.selectedMonth1 = 'Early Sept';
        appMatrixClass.selectedYear1 = '2015';
        appMatrixClass.selectedMonth2 = 'End Sept';
        appMatrixClass.selectedYear2 = '2015';
        appMatrixClass.selectedMonth3 = 'Early Oct';
        appMatrixClass.selectedYear3 = '2015';
        appMatrixClass.monthValueStartOne();
        appMatrixClass.yearValueStartOne();
        appMatrixClass.monthValueEndOne();
        appMatrixClass.yearValueEndOne();
        appMatrixClass.monthValueStartTwo();
        appMatrixClass.yearValueStartTwo();
        appMatrixClass.monthValueEndTwo();
        appMatrixClass.yearValueEndTwo();
        
        Test.stopTest();
    }  
    
    public static testMethod void myTrainScheduleTranxMethod2() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Train_Number__c = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0311');
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'GlobalShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
    
    public static testMethod void myTrainScheduleTranxMethod3() {
        
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Account_Hierarchy__c mpwAccountH = utilDataAccHMethod(account, account1);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);        
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Status__c = '28nmGpName';
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0311');
        
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account1, mpwTrainMaintenance);
        
        Test.startTest();
        
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
            System.currentPageReference().getParameters().put('tranx', 'View');
            System.currentPageReference().getParameters().put('id', mpwTrainMaintenance.Id);
       
            MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        }
        
        Test.stopTest();
    }
    
    public static testMethod void myTrainScheduleTranxMethod4() {
        
        User User1 = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
        Account account = utilDataAccMethod();
        Test.startTest();        
        Contact con = utilDataConMethod(account);       
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(account);
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Status__c = '28nmGpName';
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0311');
        
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
                
        system.runAs(User1){
            Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
            System.currentPageReference().getParameters().put('tranx', 'View');
            System.currentPageReference().getParameters().put('id', mpwTrainMaintenance.Id);
       
            MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        }
        
        Test.stopTest();
    }
    
    public static testMethod void myTrainScheduleTranxMethod5() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0399';
        mpwTrainMaintenance.Train_Number__c = 'MPW0399';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW0399');
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'GlobalShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
    
    public static testMethod void myTrainScheduleTranxMethod6() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW03A9';
        mpwTrainMaintenance.Train_Number__c = 'MPW03A9';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW03A9');
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'GlobalShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
    
    public static testMethod void myTrainScheduleTranxMethod7() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW03Z9';
        mpwTrainMaintenance.Train_Number__c = 'MPW03Z9';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW03Z9');
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'GlobalShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
    
    public static testMethod void myTrainScheduleTranxMethod8() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW03AZ';
        mpwTrainMaintenance.Train_Number__c = 'MPW03AZ';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPW03AZ');
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'GlobalShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
    
    public static testMethod void myTrainScheduleTranxMethod9() {
        
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Year__c mpwY = utilDataYearMethod();
        MPW_Month__c mpwM = utilDataMonthMethod();
        MPW_Process_Group__c mpwProcessGp = utilDataPGMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTMMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPWCSBH';
        mpwTrainMaintenance.Train_Number__c = 'MPWCSBH';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.CDRS_Submit_Date__c = System.today()+10;
        mpwTrainMaintenance.GDSII_Cutoff_for_Dry_Run_DRC__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'CustomizedShuttle';
        insert mpwTrainMaintenance;
        system.assertEquals(mpwTrainMaintenance.Name,'MPWCSBH');
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTranxVF'));
        System.currentPageReference().getParameters().put('tranx', 'Add');
        
        MPWTrainScheduleTranxController appMatrixClass = new MPWTrainScheduleTranxController(new ApexPages.Standardcontroller(new MPW_Train_Maintenance__c()));
        appMatrixClass.mpwtm.Geometry__c = '28nm';
        appMatrixClass.mpwtm.Train_Type__c = 'CustomizedShuttle';
        appMatrixClass.refreshAvailableProcesses();
        appMatrixClass.save();  
        appMatrixClass.cancel();           
        
        Test.stopTest();  
    }
}