/*
    Author: Abhita Bansal
    Created Date: 08/09/2015 
    Description: Test class for MPWMyMPWController
*/
@isTest
public class MPWMyMPWControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name ='GF Sales User' and isActive = true and UserRoleId != null limit 1];
         Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
         fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
                  
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        fieldValueMap.put('Tech_Geo_Granted__c','0.028UM');
        fieldValueMap.put('ownerId',thisUser.Id);
        fieldValueMap.put('recordtypeid',recordType.id );       
        AccountDataFactory.createAccount(fieldValueMap);
    
    }
    
    public static testMethod void myMPWControllerMethod() {  
        
        Account account1= getAccount('testing901'); 
        
        
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.AccountId = account1.Id;
        con.Email = 'test1@test.com';
        con.Department__c = 'Test Department';
        insert con;       
       
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
        
        MPW_Keyword_Config__c mpwKeywordConfig =  new MPW_Keyword_Config__c();
        mpwKeywordConfig.Active__c = true;
        mpwKeywordConfig.Sequence_No__c = 1;
        mpwKeywordConfig.Type__c = 'FabListing';
        mpwKeywordConfig.Value__c = 'Fab1';
        insert mpwKeywordConfig;
        
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Reservation_Open_Date__c = System.today();
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+20;
        mpwTrainMaintenance.Cancellation_Deadline__c = System.today()+7;
        mpwTrainMaintenance.Tapeout_Date_Other_Participant__c = System.today()+7;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_Start__c = System.today()+7;
        mpwTrainMaintenance.Projected_2nd_Batch_Bare_Die_Ship_End__c = System.today()+7;
        insert mpwTrainMaintenance;
        
        MPW_Train_Account__c mpwTrainAccount = new MPW_Train_Account__c();
        mpwTrainAccount.Account__c = account1.Id;
        mpwTrainAccount.MPW_Train__c = mpwTrainMaintenance.Id;
        insert mpwTrainAccount;
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        Test.startTest();
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.MPW_Train_Name__c,mpwTrainMaintenance.Id);                
        
        System.runAs(u) {
            Test.setCurrentPageReference(new PageReference('Page.MPWTrainScheduleTabVF'));
            System.currentPageReference().getParameters().put('sortField', 'Geometry__c');
            
            MPWMyMPWController appMatrixClass = new MPWMyMPWController();
            appMatrixClass.getMyMPWRecords();
            appMatrixClass.sortRecords();
            appMatrixClass.getHasPrevious();
            appMatrixClass.getHasNext();
            appMatrixClass.previous();
            appMatrixClass.next();
            appMatrixClass.first();
            appMatrixClass.last();
            appMatrixClass.refreshRecords();
            appMatrixClass.getRange();
        }
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}