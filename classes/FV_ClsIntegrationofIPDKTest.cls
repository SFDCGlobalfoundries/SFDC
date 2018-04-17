/*
Type Name: FV_ClsIntegrationofIPDKTest.
Author: Cognizant
Created Date: 13-Nov-2014
Reason: This is the Test class for trigger FV_ClsIntegrationofIPDK. 

……..
……..
Ashwini     05152015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(seeAllData = false)
public class FV_ClsIntegrationofIPDKTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Austria');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Austria');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static testMethod void methodFV_ClsIntegrationofIPDKTest()
    {
     
     Account accntObj = getAccount('MYTEST ACCOUNT1');
    
     Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);   
        
     insert conobj;
     
     
     Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin']; //added by cognizant for Case 00004324
       

     User portalUser = new User( ProfileId = profile2.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id///added by cognizant for Case 00004324
                                               );

      insert portaluser;  
     
     test.startTest();
     
     list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
     lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007,Specification_Type__c='IP Design Kit'));
     //lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007,Specification_Type__c='IP Design Kit'));
     insert lstspec;
     
     list<IPDK_License_Information__c > lstIPLA=new list<IPDK_License_Information__c>();
     lstIPLA.add(new IPDK_License_Information__c (Account__c=accntObj.id,Specification__c=lstSpec[0].id));
     //lstIPLA.add(new IPDK_License_Information__c (Account__c=accntObj1.id,Specification__c=lstSpec[1].id));
     
     insert lstIPLA;
     

     list<Document_Provisioning__c > lstDP=new list<Document_Provisioning__c >();
     
     Document_Provisioning__c dp = new Document_Provisioning__c ();
     dp.User__c = portalUser.Id;
     dp.Design_Spec__c = lstspec[0].Id;
     dp.Status__c = 'Provisioned';              
     lstDP.add(dp);
                   
     insert lstDP;
     
     
     FV_ClsIntegrationofIPDK.integrateIPDK('Spec-001');
     test.StopTest();
     
    
    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}