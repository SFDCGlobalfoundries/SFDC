/*
 Type Name: ClsCustomLookupControllerTest
 Author: Cognizant Technology Solutions
 Created Date: 27-Nov-2013
 Reason: This is the test class for 'ClsCustomLookupController' class.
 Change History:
     ZAmbat      04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
 Author: Cognizant
 Modified Date: 23-Jan-2014
 Reason: Case 00004324
 …….. 
 ……..
 Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData = false)
private class ClsCustomLookupControllerTest{
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
        User portalUser =new User();
        User portalUser1 =new User();
        Account acctObj = new Account();
        Contact conobj = new Contact();
        Contact conobj1 = new Contact();
        Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
        User userobj =[Select Id,Name,Profile.Name,Contact.accountId from user where Id=:userinfo.getuserId()];        
        System.runas(userobj){ 
            
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.AccountId=acctObj.Id;
            conobj.Is_Portal_User_Active__c = true;  
            conobj.UserFoundInOT__c=true;//added by cognizant for Case 00004324
            insert conobj;
            
            conobj1.FirstName='Mr';
            conobj1.LastName='Testcon2';
            conobj1.Email='con11@gf.com';
            conobj1.Department__c='Design';
            conobj1.AccountId=acctObj.Id;
            conobj1.Is_Portal_User_Active__c = true;  
            conobj1.UserFoundInOT__c=true;  //added by cognizant for Case 00004324 
             Test.startTest();                        
            insert conobj1;
             
          portalUser = new User( ProfileId = profileObj.Id,
                                            Username = 'portaluser@testorg.com',
                                            Alias = 'auser',
                                            Email='portaluser@testorg.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce',
                                            Lastname='Wayne',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            ContactId=conobj.Id,
                                            isactive=true,
                                            TimeZoneSidKey='America/Chicago'
                                           );
                                      
         insert portalUser ;
         portalUser1 = new User( ProfileId = profileObj.Id,
                                            Username = 'portaluser1@testorg.com',
                                            Alias = 'auser1',
                                            Email='portaluser1@testorg.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce1',
                                            Lastname='Wayne1',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            ContactId=conobj1.Id,
                                            isactive=true,
                                            TimeZoneSidKey='America/Chicago'
                                           );
                                           
         insert portalUser1 ;            
        }
        Test.stopTest();     
    }
    static testMethod void ClsCustomLookupControllerTest() {
    
    
           
    User userobj =[Select Id,Name,Profile.Name,Contact.accountId from user where Id=:userinfo.getuserId()];
    
     
     List<User> userlist=new List<User>();
          
    
    /* System.runas(userobj)
     { 
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.AccountId=acctObj.Id;
            conobj.Is_Portal_User_Active__c = true;  
            conobj.UserFoundInOT__c=true;//added by cognizant for Case 00004324
            insert conobj;
            
            conobj1.FirstName='Mr';
            conobj1.LastName='Testcon2';
            conobj1.Email='con11@gf.com';
            conobj1.Department__c='Design';
            conobj1.AccountId=acctObj.Id;
            conobj1.Is_Portal_User_Active__c = true;  
            conobj1.UserFoundInOT__c=true;  //added by cognizant for Case 00004324                      
            insert conobj1;
            
          portalUser = new User( ProfileId = profileObj.Id,
                                            Username = 'portaluser@testorg.com',
                                            Alias = 'auser',
                                            Email='portaluser@testorg.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce',
                                            Lastname='Wayne',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            ContactId=conobj.Id,
                                            isactive=true,
                                            TimeZoneSidKey='America/Chicago'
                                           );
                                           
         insert portalUser ;
         portalUser1 = new User( ProfileId = profileObj.Id,
                                            Username = 'portaluser1@testorg.com',
                                            Alias = 'auser1',
                                            Email='portaluser1@testorg.com',
                                            EmailEncodingKey='UTF-8',
                                            Firstname='Bruce1',
                                            Lastname='Wayne1',
                                            LanguageLocaleKey='en_US',
                                            LocaleSidKey='en_US',
                                            ContactId=conobj1.Id,
                                            isactive=true,
                                            TimeZoneSidKey='America/Chicago'
                                           );
                                           
         insert portalUser1 ;
         userlist.add(portalUser);
         userlist.add(portalUser1);
         } */
     User portalUser = [Select Id, Name from User where Email='portaluser@testorg.com'];
    System.runas(portalUser)
     {   
   
     Test.startTest();
     
     Test.setCurrentPageReference(new PageReference('Page.VFCustomUserLookup'));
     //System.currentPageReference().getParameters().put('searchvalue','Bruce'); 
     ClsCustomLookupController CustomLookupControllerobj= new ClsCustomLookupController ();
     
     CustomLookupControllerobj.searchText='Bruce';
	 system.assertEquals(CustomLookupControllerobj.searchText,'Bruce');
     ClsCustomLookupController.clsuser clsuserobj=new ClsCustomLookupController.clsuser();
     CustomLookupControllerobj.search();     
     }  
    Test.stopTest(); 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}