/*
Type Name: ClsUpdateManagerInContactTest
Author: Cognizant
Created Date: 30-May-2013
Reason: This is the Test class for class ClsUpdateManagerInContact. 
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    ARoy        10182013    - Insertion of users by list rather than using individual user insert 
                              to prevent too many future calls error. 
    Ashwini     05142015    - Updated code for refactoring of test class.                          
*/
@isTest
public class ClsUpdateManagerInContactTest
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
  static testMethod void updateManager()
    {
        
        // Load Environment Variables   
       // DataUtilTest.loadEnvironmentVariables();
   
   //Test.startTest();
   
   Profile profileObj = [Select Name,Id from Profile where Name = 'System Administrator'];
   List<Account> accList = new List<Account>();
   List<User> usrList = new List<User>();
   
   User userObj = new User(ProfileId = profileObj.Id,
                            Username = System.now().millisecond() + 'test2@test.com',
                            Alias = 'batman',
                            Email='bruce.wayne@wayneenterprises.com',
                            EmailEncodingKey='UTF-8',
                            Firstname='Bruce',
                            Lastname='Wayne',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US',
                            TimeZoneSidKey='America/Chicago'
                             );
                     
   usrList.add(userObj);

   User userObj1 = new User(ProfileId = profileObj.Id,
                            Username = System.now().millisecond() + 'test1@test.com',
                            Alias = 'batman1',
                            Email='mrbruce.wayne@wayneenterprises.com',
                            EmailEncodingKey='UTF-8',
                            Firstname='Mr Bruce',
                            Lastname='Wayne',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US',
                            TimeZoneSidKey='America/Chicago'
                             );
                     
   usrList.add(userObj1);
   insert usrList;
                             
   Account accntObj = getAccount('MYTEST ACCOUNT1');
   accList.add(accntObj);
   
   Contact conobj=new Contact(FirstName='Mr',
                             LastName='Testcon1',AccountId= accntObj.Id,Email='con1@gf.com',
                             Account_Manager__c = userObj.Id
                             ); 
                                 
   insert conobj; 
   accntObj.Account_Manager__c=userObj.Id;
   
   Test.startTest();
   
   update accntObj;
   conobj.Account_Manager__c=accntObj.Account_Manager__c;
   update conobj;   
   accntObj.Account_Manager__c=userObj1.Id;
   update accntObj;
   conobj.Account_Manager__c=accntObj.Account_Manager__c;
   update conobj;   
      
   ClsUpdateManagerInContact.updateManager(accList);
   
   Test.stopTest();
   
    }    
        
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }   
}