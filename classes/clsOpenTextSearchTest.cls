/*
Type Name: clsOpenTextSearchTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class clsOpenTextSearch. 
Change History:
Author: 
Modified Date: 
Reason: 
     ZAmbat     05302014    - Updated test class.
    Devendra  10142015      - Updated to fix device validation error
*/
@isTest(seeAllData=false)
public class clsOpenTextSearchTest
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
    
    static testMethod void methodclsOpenTextSearch()
    {
          Account accntObj = getAccount('MYTEST ACCOUNT1');
        
          Contact conobj=new Contact(FirstName='Mr',LastName='testOTCS',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
        
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='testOTCS',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;
         
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'testOTCS';
        tm.Team_Room_Description__c = 'Test Description';
        tm.Primary_Account__c = accntObj.id;
        insert tm;

        PageReference pageRef=Page.VFOpenTextSearch;
        pageRef.getParameters().put('InputSearchText','testOTCS');
    Test.setCurrentPage(pageRef);
        clsOpenTextSearch testController =   new clsOpenTextSearch ();
        test.starttest(); 
            testController.Search();
            testController.onClickRedirect();
            system.assertEquals(testController.inputSearchText, 'testOTCS');
            testController.autoRefresh();
        test.stoptest();
    }
    
    // ZAmbat 05302014 Start
    static Id createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account ZA';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct12345';
        
        insert testAcct;
               
        return testAcct.Id;
    }
    
    static Id createContact(Id acctId) {
        Contact c = new Contact();
        c.FirstName = 'FirstName';
        c.LastName = 'LastName';
        c.AccountId = acctId;
        c.Email = 'test@test.com';
        c.Department__c = 'TestDepartment';
        
        insert c;
        
        return c.Id;
    }
    
    static User createPortalUser(Id contactId) {
        User u = new User();
        u.Alias = 'Test1';
        u.Email = 'test1@test.com'; 
        u.EmailEncodingKey = 'UTF-8'; 
        u.LastName = 'LastName';
        u.LanguageLocaleKey = 'en_US'; 
        u.LocaleSidKey = 'en_US';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Portal Admin'].Id;
        u.TimeZoneSidKey = 'America/Los_Angeles'; 
        u.UserName = 'zTestUser123@test.com';
        u.Portal_Login__c = 'xyz';
        u.contactId = contactId;
        u.IsActive = true;
        u.CommunityNickname = 'zTestUser123';
        
        insert u;
        
        return u;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity ZA');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program ZA';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static void createDevices(Id accId, Id oppProgId) {
            // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICESP');
        fieldValueMap.put('Account__c',accId);
        fieldValueMap.put('Opportunity_Program__c',oppProgId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Solutioning');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now());
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power');
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)');
        fieldValueMap.put('Geometry_Filter__c','0.10UM');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('PTRF_ID__c','test');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        
        DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static Id createPortalTabAccess(string testAcctId, string testContactId, string testPortalUserId) {
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c();
        pta.Account__c = testAcctId;
        pta.Contact__c = testContactId;
        //commented to resolve test failures
        //pta.User__c = testPortalUserId;
        pta.Export_Control__c = true;
        pta.IP_Declaration__c = true;
        
        insert pta;
        pta.User__c = testPortalUserId;
        update pta;
        
        return pta.Id;
    }
    
    static testMethod void testClsOpenTextSearch() {
        OpenTextUrlValues__c ot = new OpenTextUrlValues__c();
        ot.ScopeSelection__c = '367482';
        ot.slice__c = '367482';
        ot.name = 'OpenTextParam';
        insert ot;
        
        string testAcctId = getAccount('MYTEST ACCOUNT1').id;
        string testOpptyId = clsOpenTextSearchTest.createOpportunity(testAcctId);
         test.startTest();
        string testOpptyProgramId = clsOpenTextSearchTest.createOpportunityProgram(testAcctId, testOpptyId);
        clsOpenTextSearchTest.createDevices(testAcctId, testOpptyProgramId);
        string testContactId = clsOpenTextSearchTest.createContact(testAcctId);
        User testPortalUser = clsOpenTextSearchTest.createPortalUser(testContactId);
        string testAccessSetup = clsOpenTextSearchTest.createPortalTabAccess(testAcctId, testContactId, testPortalUser.Id);
       test.stoptest();
        System.runAs(testPortalUser) {
            PageReference pageRef = Page.VFOpenTextSearch;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('InputSearchText', 'TEST');
            clsOpenTextSearch cots = new clsOpenTextSearch();
            cots.Search();
            cots.getSortedDeviceList();
            
            cots.sortBy = 'Stage';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'ShortName';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'Fab';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'Geometry';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'CurrentForecastTapeoutDate';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'ExportControlForm';
            cots.getSortedDeviceList();
            
            cots.sortBy = 'IpDeclarationForm';
            cots.getSortedDeviceList();
            
            cots.orderBy = 'DESC';
            cots.getSortedDeviceList();
            
            cots.getHasPrevious();
            cots.getHasNext();
            try{
                cots.last();
                cots.first();
                cots.next();
                cots.previous();
            }catch(Exception e){}
            cots.onClickRedirect();
            cots.autoRefresh();
        }
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}