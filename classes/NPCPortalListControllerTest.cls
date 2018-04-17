/*
    Author: Anirban Roy
    Description: This serves as the test class for NPCPortalListController class.
    History: 
        ARoy      11202013    - Code creation.
        ZAmbat    12202013    - Updated code.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     05182015    - Updated code for making SeeAllData=false and refactoring of test class.                         
*/
@isTest(SeeAllData=false)
public class NPCPortalListControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static Id createAccount1() {
        // Create Account
         Account testAcct = new Account();
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        return testAcct.Id;
        
        
    }
    
    static Id createAccount2(Id testAccountId) {
        // Create Account
       Account testAcct = new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT2');            
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        return testAcct.Id;
        
        
    }
    
    static List<Account> createAccounts() {
        // Create Account
                
        List<Account> listAccount = new List<Account>();
         List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        listAccount=AccountDataFactory.createAccounts(fieldValueMapList,2); 
           
                
        return listAccount;
        
        /*Account testAcct = new Account();
        testAcct.Name = 'Test Account';
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
        testAcct.Short_Name__c = 'TestAcct';
        
        Insert testAcct;
        
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Update testAcct;
        
        return testAcct.Id;*/
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
    
    static User createPortalUser(Id contId) {
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
        u.contactId = contId;
        u.IsActive = true;
        u.CommunityNickname = 'zTestUser123';
        
        insert u;
        
        /* User u = [
            SELECT      Id
                        , Contact.AccountId
            FROM        User
            WHERE       Contact.AccountId != null
                        AND IsActive = true
            LIMIT 1
        ]; */
        
        return u;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
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
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','Fab 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12345');
        //fieldValueMap.put('CRMDID__c = 'CDID0000001.00';
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');      
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static New_Part_Creation_Form__c createNPCForm(Id accountId, Id deviceId) {
        New_Part_Creation_Form__c npc = new New_Part_Creation_Form__c();
        npc.Account__c = accountId;
        npc.Originating_Device__c = deviceId;
        npc.BASE_Device__c = deviceId;
        npc.New_Part_ID__c = 'NPCTEST1';
        npc.CRM_DID__c = 'CDID12345';
        
        insert npc;
        
        return npc;
    }
    
    static testMethod void testNPCPortalListController() {
        //DataUtilTest.loadEnvironmentVariables();
        /*List<Account> listAccount = NPCPortalListControllerTest.createAccounts();        
        listAccount[2].ParentId = listAccount[1].Id;
        update listAccount[2];
        String testAcctId = listAccount[2].Id;*/
        User usr = [Select id from User where id=: userinfo.getuserid()];
        
        
        String testAcctId1 = NPCPortalListControllerTest.createAccount1();
        String testContId = NPCPortalListControllerTest.createContact(testAcctId1);
        //test.startTest();
        User testPortalUser;
        system.runas(usr){
         testPortalUser = NPCPortalListControllerTest.createPortalUser(testContId);
        }
        String testAcctId2 = NPCPortalListControllerTest.createAccount2(testAcctId1);
        String testOpptyId = NPCPortalListControllerTest.createOpportunity(testAcctId2);
        String testOpptyProgramId = NPCPortalListControllerTest.createOpportunityProgram(testAcctId2, testOpptyId);
        
        ExpConApprovalSendMail.isRun = true;
        //Device__c testDevice = NPCPortalListControllerTest.createDevice(testAcctId2, testOpptyProgramId);
        
        test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId2,MSTId);
               
        Device__c testDevice = DeviceUtilTest.createCustomerMPWDeviceNew2(testAcctId2, testOpptyProgramId);
        
        // Share record
        /*Device__Share ds = new Device__Share();
        ds.ParentId = testDevice.Id;
        ds.UserOrGroupId = testPortalUser.Id;
        ds.AccessLevel = 'Edit';
        ds.RowCause = 'Opportunity_Program_Team__c';
        
        insert ds;*/

        New_Part_Creation_Form__c testNPC = NPCPortalListControllerTest.createNPCForm(testAcctId2, testDevice.Id);
        
        System.runAs(testPortalUser) {                           
            NPCPortalListController n = new NPCPortalListController();
            NPCPortalListController.NPCWrapper nw = new NPCPortalListController.NPCWrapper();
            n.deviceSharingMap.put(testDevice.Id, testDevice.Id);
            n.retrieveAccounts();
            string acctId;
            boolean isPrev = n.getHasPrevious();
            boolean isNext = n.getHasNext();
            //n.offsetValue = 16;
            n.sortField = 'base_device__c';
            n.sort();
            n.previous();
            n.next();
            n.first();
            n.last(); 
            n.getFabs();
            n.clearAllFilters();
            n.getSearchFor();
            n.referenceDevice = testDevice.Name;
            n.npcFormName = testNPC.Name;
            n.npcFilter.Reason_for_New_Part__c = 'Retrofit';
            n.npcFilter.Tapeout_Required__c = 'Yes';
            n.npcFilter.New_Part_ID__c = testNPC.New_Part_ID__c;
            n.npcFilter.NPC_Form_Status__c = 'Pending Submission';
            n.npcFilter.Fab__c = 'FAB 2';
            n.retrieveNPCList();
            n.refreshFilters();
            n.initPagination();
            n.retrieveNPCList();
            n.getHasNext();
            n.getHasPrevious();
        }  
        test.stopTest();
    }
}