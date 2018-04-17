/*
Type Name: ClsUpdateAccountDeactivationErrorTest
Author: Cognizant
Created Date: 31-May-2013
Reason: This is the Test class for class ClsUpdateAccountDeactivationError. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05142015    - Updated code for refactoring of test class.
*/
@isTest
public class ClsUpdateAccountDeactivationErrorTest
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
    static testMethod void createData()
    {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
    
         List<Account> accList=new List<Account>();
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         accList.add(accntObj);
         User portalUser=new User();
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         System.runAs ( thisUser ) 
         {
      
             Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
                
             insert conobj;
            
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            portalUser = new User( ProfileId = profile1.Id,
                                                        Username = 'portaluser1@testorg.com',
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
             Database.BatchableContext bc;
             ClsUpdateAccountDeactivationError accountdeactivationObj = new ClsUpdateAccountDeactivationError();
             database.executebatch(accountdeactivationObj);
             accountdeactivationObj.execute(bc,accList);
             accountdeactivationObj.finish(bc);
             Test.stopTest();
        }
 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}