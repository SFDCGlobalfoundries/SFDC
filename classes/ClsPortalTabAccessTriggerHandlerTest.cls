/*
Type Name: ClsPortalTabAccessTriggerHandlerTest
Author: Cognizant
Created Date: 16-April-2013
Reason: This is the Test class for class ClsPortalTabAccessTriggerHandler. 
Change History:
Author: IBM
Modified Date: 01-Sept-2014
Reason: - Added Department__c='Design' into contact object.                       
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/

@isTest
public class ClsPortalTabAccessTriggerHandlerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    static Map<String,Object> CreatefieldValueAccMap() {

        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

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

        return fieldValueMap;
    }

    public static testmethod void TestforNonOverageProfile() {

        User thisUser = [select id from User where id= :UserInfo.getUserId()];
        System.runAs (thisUser) {  
            
            Map<String,Object> fieldValueAccMap = CreatefieldValueAccMap();
        
            Account accntObj = AccountDataFactory.createAccount(fieldValueAccMap);
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcontact1',AccountId=accntObj.Id,Email='con1@gf1.com',Department__c='Design');   
            insert conobj; 
                     
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
      
            List<User> userList=new List<User>();
            User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser1@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce1',
                                                Lastname='Wayne1',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc112'
                                               );                                              
            insert   portalUser ; 

            test.starttest();   

            conobj.Is_Portal_User_Active__c =true;
            conobj.department__c='';
            update conobj;
     		
     		System.assertNotEquals(conobj,null); 

            test.stoptest();   
        }
    }

    public static testmethod void TestforNonOverageProfile1() {

        User thisUser = [select id from User where id= :UserInfo.getUserId()];
        System.runAs (thisUser) {  
            
            Map<String,Object> fieldValueAccMap = CreatefieldValueAccMap();
        
            Account accntObj = AccountDataFactory.createAccount(fieldValueAccMap);
            accntObj.Fab_9_10__c = 'Yes';
            update accntObj;

            Contact conobj=new Contact(FirstName='Mr',LastName='Testcontact1',AccountId=accntObj.Id,Email='con1@gf1.com',Department__c='Design');   
            insert conobj; 
                     
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
      
            List<User> userList=new List<User>();
            User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser1@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce1',
                                                Lastname='Wayne1',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc112'
                                               );                                              
            insert   portalUser ; 

            test.starttest();   

            conobj.Is_Portal_User_Active__c =true;
            update conobj;

            System.assertNotEquals(conobj,null);
     
            test.stoptest();   
        }
    }

    public static testmethod void TestforOverageProfile() {

        User thisUser = [select id from User where id= :UserInfo.getUserId()];
        System.runAs (thisUser) {  
            Map<String,Object> fieldValueAccMap = CreatefieldValueAccMap();
                                   
            Account accntObj = AccountDataFactory.createAccount(fieldValueAccMap);
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcontact1',AccountId=accntObj.Id,Email='con1@gf1.com',Department__c='Design');   
            insert conobj; 
           
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Admin'];

            List<User> userList=new List<User>();
            User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser1@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce1',
                                                Lastname='Wayne1',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc112'
                                               );                                              
            insert portalUser; 

            test.starttest();   

            conobj.Is_Portal_User_Active__c =true;
            conobj.department__c='';
            update conobj;
     		
			System.assertNotEquals(conobj,null);

            test.stoptest();   
        } 
    }

    public static testmethod void TestforOverageProfile1() {

        User thisUser = [select id from User where id= :UserInfo.getUserId()];
        System.runAs (thisUser) {  
            Map<String,Object> fieldValueAccMap = CreatefieldValueAccMap();
                  
            Account accntObj = AccountDataFactory.createAccount(fieldValueAccMap);
            accntObj.Fab_9_10__c = 'Yes';
            update accntObj;
            
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcontact1',AccountId=accntObj.Id,Email='con1@gf1.com',Department__c='Design');   
            insert conobj; 
           
            Profile profile1 = [Select Id from Profile where name = 'Overage Customer Portal Admin'];

            List<User> userList=new List<User>();
            User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser1@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce1',
                                                Lastname='Wayne1',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc112'
                                               );                                              
            insert portalUser; 

            test.starttest();   

            conobj.Is_Portal_User_Active__c =true;
            update conobj;

            System.assertNotEquals(conobj,null);
     
            test.stoptest();   
        }       
    }

}