/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWTrainScheduleTabController
*/
@isTest
public class MPWTrainScheduleTabControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
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
            fieldValueMap.put('ownerId',thisUser.Id);
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    private static Account utilDataAccMethod() {
        
         Account account = getAccount('MYTEST ACCOUNT1');
        return account;
    }
    
    private static Account utilDataAccMethod1(Account account) {
        
        Account account1 = getAccount('MYTEST ACCOUNT2');
        return account1;
    }
    
    private static Contact utilDataConMethod(Account account) {
        
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = account.Id;
        con.Email = 'test1@test.com';
        con.Department__c = 'Test Department';
        insert con; 
        
        return con;
    }
    
    private static MPW_Train_Account__c utilDataTAMethod(Account account, MPW_Train_Maintenance__c mpwTrainMaintenance) {
    
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        return mpwTrainAccount;
    }
    
    private static MPW_Train_Account__c utilDataTAMethod1(Account account1, MPW_Train_Maintenance__c mpwTrainMaintenance) {
    
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account1.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        return mpwTrainAccount;
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
    
    private static List<MPW_Settings__c> utilDataSettingMethod() {
        
        List<MPW_Settings__c> mpwSettingList = new List<MPW_Settings__c>();      
              
        MPW_Settings__c mpwSetting = new MPW_Settings__c();
        mpwSetting.Name = '28nm_GlobalShuttle_Prefix';
        mpwSetting.Value__c = 'MPW03';
        mpwSettingList.add(mpwSetting);
        
        MPW_Settings__c mpwSetting1 = new MPW_Settings__c();
        mpwSetting1.Name = 'View_MPW_Schedule_Tab_Id';
        mpwSetting1.Value__c = System.Label.MPW_View_Schedule_Tab_Id;
        mpwSettingList.add(mpwSetting1);
        
        if(!mpwSettingList.isEmpty()) {
            insert mpwSettingList;
        }
        
        return mpwSettingList;
        
    }
    
    private static MPW_Keyword_Config__c utilDataKCMethod() {
    
        MPW_Keyword_Config__c mpwKeywordConfig =  new MPW_Keyword_Config__c();
        mpwKeywordConfig.Active__c = true;
        mpwKeywordConfig.Sequence_No__c = 1;
        mpwKeywordConfig.Type__c = 'FabListing';
        mpwKeywordConfig.Value__c = 'Fab1';
        insert mpwKeywordConfig;
        
        return mpwKeywordConfig;
    }
    
    public static testMethod void myTrainScheduleTabMethod() {
    
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Keyword_Config__c mpwKeywordConfig = utilDataKCMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Close_Start_Date__c = System.today()+3;
        mpwTrainMaintenance.Reservation_Close_End_Date__c = System.today()+11;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+2;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+4;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+5;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
        MPW_Train_Account__c mpwTrainAccount1 = utilDataTAMethod(account1, mpwTrainMaintenance);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTabVF'));
        System.currentPageReference().getParameters().put('sfdc.tabName', mpwSettingList[1] .Value__c);
        System.currentPageReference().getParameters().put('sortField', 'Geometry__c');
        System.currentPageReference().getParameters().put('userId', u.Id);
        
        MPWTrainScheduleTabController appMatrixClass = new MPWTrainScheduleTabController();
        appMatrixClass.getGeometryList();
        appMatrixClass.getFab();
        appMatrixClass.getIsPortalType();
        appMatrixClass.retrieveMPWRecords();
        appMatrixClass.sortRecords();
        appMatrixClass.addNewMPWSchedule();
        appMatrixClass.getMPWScheduleRecords();
        appMatrixClass.getStatus();
        appMatrixClass.getPublish();
        appMatrixClass.getpageList();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        appMatrixClass.reset();
        appMatrixClass.exportToPDF();
        appMatrixClass.saveMPW();
               
        Test.stopTest();
    }
    
    public static testMethod void myTrainScheduleTabMethod1() {

        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Keyword_Config__c mpwKeywordConfig = utilDataKCMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTabVF'));
        System.currentPageReference().getParameters().put('sfdc.tabName', System.Label.MPW_Maintain_Schedule_Tab_Id);
        System.currentPageReference().getParameters().put('sortField', 'Geometry__c');
        System.currentPageReference().getParameters().put('userId', u.Id);
        System.currentPageReference().getParameters().put('geometry', '28nm');
        
        MPWTrainScheduleTabController appMatrixClass = new MPWTrainScheduleTabController();
        appMatrixClass.mpwtm.Name = 'MPW0311';
        appMatrixClass.geometry = '28nm';
        appMatrixClass.retrieveMPWRecords();
        appMatrixClass.getMPWScheduleRecords();
        
        Test.stopTest();
    }
    
    public static testMethod void myTrainScheduleTabMethod2() {
    
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Contact con = utilDataConMethod(account);
        List<MPW_Settings__c> mpwSettingList = utilDataSettingMethod();
        MPW_Keyword_Config__c mpwKeywordConfig = utilDataKCMethod();
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Close_Start_Date__c = System.today()+3;
        mpwTrainMaintenance.Reservation_Close_End_Date__c = System.today()+11;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+2;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+4;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+5;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
        MPW_Train_Account__c mpwTrainAccount1 = utilDataTAMethod(account1, mpwTrainMaintenance);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTabVF'));
        System.currentPageReference().getParameters().put('sfdc.tabName', mpwSettingList[1] .Value__c);
        System.currentPageReference().getParameters().put('sortField', 'Geometry__c');
        
        MPWTrainScheduleTabController appMatrixClass = new MPWTrainScheduleTabController();
        appMatrixClass.mpwtm.Name = 'MPW0311';
        appMatrixClass.mpwtm.Reservation_Close_Start_Date__c = System.today()+3;
        appMatrixClass.mpwtm.Reservation_Close_End_Date__c = System.today()+11;
        appMatrixClass.geometry = '28nm';
        appMatrixClass.retrieveMPWRecords();
  
        Test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  

}