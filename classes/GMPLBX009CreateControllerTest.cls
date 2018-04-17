/*
    Author: Anirban Roy
    Description: This is the test class for the GMPLBX009CreateController class.  
    History:
        ARoy        04072014    - code creation.
        ARoy        06092014    - code modified for lead account lookup name population in GMPL/BX009 create page.
        DBiswal     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class GMPLBX009CreateControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
           
    // Create User
    static User createUser(){
        
        /*HCM_Employee__c hcm = new HCM_Employee__c(First_Name__c='TestFirstName2002',
                                                  Last_Name__c='TestLastName2002',
                                                  Employee_ID__c='Test2002',
                                                  Login_ID__c='test2002',
                                                  Email_Address__c='test2002@test.com');
        insert hcm;*/
        Profile p = [select id from Profile where name = 'GF Finance'];
        User u = [select id from User where profileid = :p.id and isActive = true limit 1];
        /*User u = new User(alias = 'ts2002', email='test2002@test.com',
                          emailencodingkey='UTF-8', lastname='TestLast2002', firstname='TestFirst2002', languagelocalekey='en_US',
                          localesidkey='en_US',timezonesidkey='America/Los_Angeles', username='test2002@test.com',communitynickname='ts2002',
                          profileid = p.Id,FederationIdentifier='Test2002');
        insert u;*/
        return u;
    }
    
    static testMethod void createGMPLBX009Test1(){
    
        Test.startTest();
                
        ApexPages.currentPage().getParameters().put('retURL','/a08/o');
        GMPL_BX009__c gmpl = new GMPL_BX009__c();
        ApexPages.StandardController controller = new ApexPages.StandardController(gmpl);
        GMPLBX009CreateController gmplBX009 = new GMPLBX009CreateController(controller);
        PageReference pgr = gmplBX009.init();
        system.assert(pgr!=null);
        
        /*ApexPages.currentPage().getParameters().put('retURL','a08');
        pgr = gmplBX009.init();
        system.assert(pgr==null);*/
        
        pgr = gmplBX009.cancel();
        system.assert(pgr!=null);
        
        Test.stopTest();
        
    }
    
    static testMethod void createGMPLBX009Test2(){

        User usr = GMPLBX009CreateControllerTest.createUser();
        
        Test.startTest();
                
        system.runAs(usr){
            GMPL_BX009__c gmpl = new GMPL_BX009__c();
            ApexPages.StandardController controller = new ApexPages.StandardController(gmpl);
            GMPLBX009CreateController gmplBX009 = new GMPLBX009CreateController(controller);
            PageReference pgr = gmplBX009.init();
            system.assert(pgr==null);        
        }
        
        Test.stopTest();
        
    }
    
    // Method to test the account lookup addition to GMPL/BX009 create page
    static testMethod void createGMPLBX009Test3(){

        //User usr = GMPLBX009CreateControllerTest.createUser();
        Account acct = getAccount('MYTEST ACCOUNT1');  
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('retURL','/a08/o');
            ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('LEAD_ACCT_GMPL_LKP_ID')+'_lkid',acct.Id);
            ApexPages.currentPage().getParameters().put(EnvironmentVariable.get('LEAD_ACCT_GMPL_LKP_ID'),acct.Name);
            GMPL_BX009__c gmpl = new GMPL_BX009__c();
            ApexPages.StandardController controller = new ApexPages.StandardController(gmpl);
            GMPLBX009CreateController gmplBX009 = new GMPLBX009CreateController(controller);
            PageReference pgr = gmplBX009.init();
            system.assert(pgr!=null);       
        Test.stopTest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}