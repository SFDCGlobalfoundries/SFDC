/*
Type Name: FV_AccountUpdateClsTest
Author: Cognizant
Created Date: 23-Feb 2015
Reason: This is the Test class for class FV_AccountUpdateCls. 
Change History:

*/
@isTest
public class FV_AccountUpdateClsTest
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
        fieldValueMap.put('Account_Present_In_OT__c',true);

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void testImpersonationUpdate()
    {
        
       Account accntObj = getAccount('MYTEST ACCOUNT1');
         
       Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
       User User1 = new User( ProfileId = profile1.Id,
                                                Username = 'userimper@testorg.com',
                                                Alias = 'userim',
                                                Email='user@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='user',
                                                Lastname='imper',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                HCM_Login_ID__c='E101234'
                                                 );
                                               
    insert User1 ;
    
    List<Account_Team_Proxy__c> ListofATP=new List<Account_Team_Proxy__c>();
    Account_Team_Proxy__c atpobj=new Account_Team_Proxy__c();
    atpobj.Account__c=accntObj.id;
    atpobj.User__c=  User1.Id;
    atpobj.Account_Access__c='Read/Write';
    atpobj.Opportunity_Access__c='Read/Write';
    atpobj.Team_Role__c='DE - IP Technical';
    
    
   
    ListofATP.add(atpobj);
    
    insert ListofATP;
    
    Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
    obj.User_Shortname__c=User1.HCM_Login_ID__c;
    obj.Accounts_ShortName__c='Test1';
    obj.Sync_Needed__c =True ;
  
    insert obj;
    
    test.startTest();
    accntObj.Account_Present_In_OT__c=false;
    update accntObj ;
    
    accntObj.Account_Present_In_OT__c=true;
    update accntObj ;
    test.stopTest();
        
     }
     
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}