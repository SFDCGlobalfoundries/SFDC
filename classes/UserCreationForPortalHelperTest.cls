/*
Type Name: UserCreationForPortalsHelperTest Class
Author: Ashish Jadhav
Created Date: 12-02-2016
Reason: 
Change History:
Author: Global Foundries (Dinesh M Suggala)
Modified Date: 09-02-2017
Reason: Update the code to increase the code coverage of this "UpdateUserEmailSametoContactEmailMethod" method in UserCreationForPortalsHelper class 
??..
??..
*/
@isTest
public class UserCreationForPortalHelperTest {


@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYACCTST');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Valid_Email_Domain__c','@cognizant.com,@vmware.com');           //Added by Dinesh
        AccountDataFactory.createAccount(fieldValueMap);
        
       List<Error_Codes__c> lstcodes = new List<Error_Codes__c>();
        Error_Codes__c e = new Error_Codes__c();
        e.Name = 'ACCT_PFTS_OR_BCSR_NOT_FOUND_ERROR';
        e.Message__c = 'Test';
        lstcodes.add(e);
        Error_Codes__c e1 = new Error_Codes__c();
        e1.Name = 'ACCT_TM_DUP_USER_ROLE_ERROR';
        e1.Message__c = 'Test';
        lstcodes.add(e1);
        Error_Codes__c e2 = new Error_Codes__c();
        e2.Name = 'ATP_INTEGRATION_SEQUENCE_ERROR';
        e2.Message__c = 'Test';
        lstcodes.add(e2);
        Error_Codes__c e3 = new Error_Codes__c();
        e3.Name = 'ATP_FLAG_FOR_DELETE_UPDATE_ERROR';
        e3.Message__c = 'Test';
        lstcodes.add(e3);
        Error_Codes__c e4 = new Error_Codes__c();
        e4.Name = 'ATP_FLAG_FOR_DELETE_CREATION_ERROR';
        e4.Message__c = 'Test';
        lstcodes.add(e4);
        insert lstcodes;
    }
    
   
     
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c,Valid_Email_Domain__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
  public static testMethod void portalTest(){               
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive,Email from User where IsActive=true And userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
      
        System.runAs(ur){
            Account acc =  getAccount('MYACCTST');          
          
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2345@testorg.com');
            insert u;      
      
            Account_Team_Proxy__c accntTeamProxy = new Account_Team_Proxy__c();
            accntTeamProxy.Account__c = acc.Id;
            accntTeamProxy.User__c = u.id;
            accntTeamProxy.Account_Access__c = 'Read/Write';
            accntTeamProxy.Case_Access__c = 'Read/Write';
            accntTeamProxy.Opportunity_Access__c = 'Read/Write';
            accntTeamProxy.Team_Role__c = 'Backup Customer Service Rep';
            insert accntTeamProxy;
                
            Contact con = new Contact(
               Salutation='Mr.',
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@test.com',
                Department__c = 'Design',
                Primary_CSR__c = u.id,
                FAE__c = ur.id,
                Status__c = 'Draft'
            );
            Test.startTest();
            insert con;
            con.Status__c = 'Active';
            con.Create_Portal_User__c = true;
            update con;
            
           //Code Added by Dinesh  
           Contact con1 = new Contact(
                LastName = 'test',
                FirstName = 'testing1',
                AccountId = acc.Id,
                Email = 'test@cognizant.com',
                Department__c = 'Design',
                Status__c = 'Draft',
                Is_Portal_User_Active__c=true
            );
            insert con1;
            con1.Email='test@vmware.com';
            update con1;                    
        }
        Test.stopTest();
    }
}