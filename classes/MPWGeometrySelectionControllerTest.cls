/*
    Author: Abhita Bansal
    Created Date: 27/08/2015 
    Description: Test class for MPWGeometrySelectionController
*/
@isTest
public class MPWGeometrySelectionControllerTest {

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
    
    private static Account_Hierarchy__c utilDataAccHMethod(Account account , Account account1) {
        
        Account_Hierarchy__c mpwAccountH = new Account_Hierarchy__c();
        mpwAccountH.Account_Id__c = account1.Id;
        mpwAccountH.Parent_Id__c = account.Id;
        insert mpwAccountH;
        
        return mpwAccountH;
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
    
    public static testMethod void myGeometrySelectionTabMethod() {
    
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';       
        insert mpwGeoMap;
        
        Account account = utilDataAccMethod();
        Account account1 = utilDataAccMethod1(account);
        Account_Hierarchy__c mpwAccountH = utilDataAccHMethod(account, account1);
        Contact con = utilDataConMethod(account);
        User u = utilDataUserMethod(con);
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+5;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        insert mpwTrainMaintenance;
        
        MPW_Train_Account__c mpwTrainAccount = utilDataTAMethod(account, mpwTrainMaintenance);
        MPW_Train_Account__c mpwTrainAccount1 = utilDataTAMethod(account1, mpwTrainMaintenance);
        
        Test.startTest();
        
        system.runAs(u){
        
            Test.setCurrentPageReference(new PageReference('Page.MPWGeometrySelectionForReservationFormVF'));
            System.currentPageReference().getParameters().put('retURL','/apex/MPWGeometrySelectionForReservationFormVF');
            
            MPWGeometrySelectionController appMatrixClass = new MPWGeometrySelectionController();
            appMatrixClass.geometry = '28nm';
            appMatrixClass.retreiveTrainOptions();
            appMatrixClass.getMPWTrainList();
            appMatrixClass.back();
            appMatrixClass.go();
            appMatrixClass.getGeometryList();
            
        }

        Test.stopTest();     
    }
    
     private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}