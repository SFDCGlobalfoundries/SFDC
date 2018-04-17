/*
Test class for Batch Class to clean all existing AccountShare, OpportunityShare and CaseShare records of Cutomer Portal users
Author: Rahul Majumder
Version: 1

Added Ravikiran Nadella for code coverage
*/


@isTest
public class ICC_Test_BatchCleanup
{
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    @isTest
   static void test()
    {
        try
        {
            User portalUser;
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            
            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = ur.id,
                TimeZoneSidKey='America/Los_Angeles', UserName='stduser@testingorg.com');
    
            System.runAs(u) 
            {
                 Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
            fieldValueMap.put('Account_Type__c', 'Customer');                           
            fieldValueMap.put('sub_type__c', 'Indirect');        
            fieldValueMap.put('site_department__c', 'IT');  
            fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
            fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
            fieldValueMap.put('region__c', 'US');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
            
            AccountDataFactory.createAccount(fieldValueMap);
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');  
            fieldValueMap1.put('Account_Type__c', 'Customer');                           
            fieldValueMap1.put('sub_type__c', 'Indirect');        
            fieldValueMap1.put('site_department__c', 'IT');  
            fieldValueMap1.put('Account_Manager__c', userinfo.getuserid());        
            fieldValueMap1.put('transaction_type__c', 'Non-Transactional');                          
            fieldValueMap1.put('region__c', 'US');        
            fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap1.put('Corporate_City__c', 'Test City');                
            fieldValueMap1.put('Corporate_Country__c', 'Singapore');
            fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap1.put('Bill_To_City__c', 'Test City');            
            fieldValueMap1.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap1.put('Fab_9_10__c','No');
            fieldValueMap1.put('parentid',getAccount('MYTEST ACCOUNT1').id);
            
            AccountDataFactory.createAccount(fieldValueMap1);
            
            
              Account accntObj = getAccount('MYTEST ACCOUNT1'); 
              
              Account accntObj1 = getAccount('MYTEST ACCOUNT2'); 
              
                 Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj1.Id,Email='con1@gf.com',Department__c='Procurement'); 
              insert conobj;
              
              
              Profile profile1 = [Select Id, name from Profile where name = 'Customer Portal Admin'];
              portalUser = new User( ProfileId = profile1.Id,
                                                    Username = 'portaluser@testorg.com',
                                                    Alias = 'auser',
                                                    Email='portaluser@testorg.com',
                                                    EmailEncodingKey='UTF-8',
                                                    Firstname='Bruce',
                                                    Lastname='Wayne',
                                                    LanguageLocaleKey='en_US',
                                                    LocaleSidKey='en_US',
                                                    TimeZoneSidKey='America/Chicago',
                                                    ContactId=conobj.id,
                                                    Portal_Login__c='abc12'
                                                   );
                                                   
             insert   portalUser   ;
             Test.startTest();
                Database.executeBatch(new ICC_Batch_CleanUpAccountShare(), 5);
                Test.stopTest();
            }
             
             
            
            ICC_CleanUpAccountShare.ShareAccounts([select contact.Accountid, id from user where username= 'portaluser@testorg.com']);
            ICC_CleanUpAccountShare.cleanData([select accountid from accountshare]);
            
        }
        catch(Exception e)
        {
            ApplicationLogWrapper alw = new ApplicationLogWrapper();
            alw.source = ICC_Test_BatchCleanup.class.getName();
            alw.sourceFunction ='test()';
            alw.ApplicationName='ICC';
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);
        }
        
    }
    
    private static testmethod void test_Batch()
    {
        Test.startTest();
        Database.executeBatch(new ICC_Batch_ShareAccounts_with_PortalUsers(), 5);
        test.stopTest();
    }
   
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}