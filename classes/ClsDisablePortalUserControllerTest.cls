/*
 Type Name: ClsDisablePortalUserController
 Author: Cognizant Technology Solutions
 Created Date: 30-May-2013
 Reason: This is the test class for 'clsDisablePortalUserController' class.
 Change History:
 Author: 
 Modified Date: 
 Reason: 
 …….. 
 ……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     03262015    - Updated code for refactoring of test class.
*/


@isTest
private class ClsDisablePortalUserControllerTest
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
        This method is used to test the deactivateContact method in 'clsDisablePortalUserController' class.
        
        @method name: testclsDisablePortalUserController
       
     */
     
    static testmethod void testclsDisablePortalUserController()
    {            
            
            Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
           
            User userObj = new User();
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj = new Contact();
                       
            String parent_domain = 'globalfoundriesview1.uat.cs5.force.com';
                        
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.Is_Portal_User_Active__c = true;                          
            insert conobj;
            
            Test.startTest();
            ApexPages.currentPage().getParameters().put('parent_domain', parent_domain);
            ApexPages.StandardController controller = new ApexPages.StandardController(conobj) ;
            clsDisablePortalUserController clsDisablePortalUserControllerObj = new clsDisablePortalUserController(controller);
            clsDisablePortalUserControllerObj.deactivateContact();
            system.assertEquals(conobj.Email,'con1@gf.com');
            Test.stopTest();    
            
            
    }
    
    static testmethod void testclsDisablePortalUserControllerastrue()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
            
            
            Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
                     
          
                   
            User userObj = new User();
           
            Account acctObj = getAccount('MYTEST ACCOUNT1');
         
            Contact conobj=new Contact();
         
           
            AccountTeamMember acctTeamMemberObj = new AccountTeamMember();
            String parent_domain = 'abc';
                        
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.Is_Portal_User_Active__c = true;         
            insert conobj;
            
           
          system.assertEquals(conobj.Email,'con1@gf.com');
            
                Test.startTest(); 
                ApexPages.currentPage().getParameters().put('parent_domain', parent_domain);
                
                ApexPages.StandardController controller = new ApexPages.StandardController(conobj) ;
                clsDisablePortalUserController clsDisablePortalUserControllerObj = new clsDisablePortalUserController(controller);
                clsDisablePortalUserControllerObj.deactivateContact();
                
                 
                Test.stopTest();
           
            
    }
     static testmethod void testclsDisablePortalUserControllerasfalse()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
            
            
            Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
                     
          
                   
            User userObj = new User();
           
            Account acctObj = getAccount('MYTEST ACCOUNT1');
         
            Contact conobj=new Contact();
         
           
            AccountTeamMember acctTeamMemberObj = new AccountTeamMember();
            String parent_domain = 'abc';
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.Is_Portal_User_Active__c = true;   
            Test.startTest();       
            insert conobj;
            system.assertEquals(conobj.Email,'con1@gf.com');
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
          
            System.runas(userObj)
            {
                
                ApexPages.currentPage().getParameters().put('parent_domain', parent_domain);
                
                ApexPages.StandardController controller = new ApexPages.StandardController(conobj) ;
                clsDisablePortalUserController clsDisablePortalUserControllerObj = new clsDisablePortalUserController(controller);
                clsDisablePortalUserControllerObj.deactivateContact();
                
                 
                Test.stopTest();
            }
           
            
    }
    
    
    
    
    
    //method added by Sunil
    static testmethod void testclsDisablePortalUserControllerasfalse2()
    {
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
            
            
            Profile profileObj = [Select Name,Id from Profile where Name ='Customer Portal Admin'];
                     
          
                   
            User userObj = new User();
           
            Account acctObj = getAccount('MYTEST ACCOUNT1');
         
            Contact conobj=new Contact();
         
            AccountTeamMember acctTeamMemberObj = new AccountTeamMember();
            String parent_domain = 'abc';
            
            conobj.FirstName='Mr';
            conobj.LastName='Testcon1';
            conobj.AccountId=acctObj.Id;
            conobj.Email='con1@gf.com';
            conobj.Department__c='Design';
            conobj.Is_Portal_User_Active__c = true;     
            Test.startTest();     
            insert conobj;
            system.assertEquals(conobj.Email,'con1@gf.com');
            
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
          
            System.runas(userObj)
            {
                
                String sDomain=System.Label.Salesforce_Domain_URL;
                ApexPages.currentPage().getParameters().put('parent_domain', sDomain);
                
                ApexPages.StandardController controller = new ApexPages.StandardController(conobj) ;
                clsDisablePortalUserController clsDisablePortalUserControllerObj = new clsDisablePortalUserController(controller);
                clsDisablePortalUserControllerObj.deactivateContact();
                
                 
                Test.stopTest();
            }
           
            
    }
  
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}