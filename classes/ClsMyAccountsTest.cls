/*
 Type Name: ClsMyAccountsTest
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'ClsMyAccounts' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/


@isTest
private class ClsMyAccountsTest 
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
            fieldValueMap.put('Corporate_Country__c', 'Singapore');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
            fieldValueMap.put('Fab_9_10__c','No');
    
            AccountDataFactory.createAccount(fieldValueMap);
   } 
   /**
        This method helps to test  for My Accounts to check the Page Redirection phase.
        
        @method name: testClsMyAccounts
       
     */
     
    static testmethod void testClsMyAccounts()
    {
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
        
            Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
                        
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
                                      
            insert conobj;
            
            
            userObj.Alias = 'Shyam';
            userObj.Email='shyam@test.com'; 
            userObj.EmailEncodingKey='UTF-8'; 
            userObj.LastName='Paul';
            userObj.LanguageLocaleKey='en_US'; 
            userObj.LocaleSidKey='en_US';
            userObj.ProfileId = profileObj.Id;
            userObj.TimeZoneSidKey='America/Los_Angeles'; 
            userObj.UserName='shyam@test.com';
            userObj.Portal_Login__c = 'xyz';
            userObj.contactId = conobj.Id;
            userObj.IsActive = true;
                        
            insert userObj;
            
            System.runAs(userObj)
            {
            
                Test.startTest();
                ClsMyAccounts  clsMyAccountsObj = new ClsMyAccounts ();
                clsMyAccountsObj.Page = 'preferences';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'subscription';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'subacct';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'newacctreq';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'nda';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'contract';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'survey';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'ipdeclare';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'exportcntrl';  
                clsMyAccountsObj.redirect();
                clsMyAccountsObj.Page = 'companyprofile';  
                clsMyAccountsObj.redirect();
                Test.stopTest();    
            }  
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}