/*
    Class Name:    BX041PermissionHandlerTest
    Author:        Thomas Lai(TL)
    Description:   Test class for BX041PermissionHandler.
    History: 
      TL           15082013    - Code creation.
      Vijay     16012015       - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.  
  Devendra  10142015      - Updated to fix device validation error
*/


@isTest(SeeAllData=false)
private class BX041PermissionHandlerTest
{

     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
       
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = UserInfo.getUserId(), Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        Test.startTest();
        Id contactId = createAccountAndContact();
        createUsers(contactId);
        Test.stopTest();
     }
          
     static Id createAccount(){
        
      Map<String,Object> fieldValueMap = new Map<String,Object>();
      fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
      fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
      fieldValueMap.put('sub_type__c', 'Indirect');
      fieldValueMap.put('site_department__c', 'test dept');          
      fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
      fieldValueMap.put('region__c', 'US');        
      fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Corporate_City__c', 'Test City');                
      fieldValueMap.put('Corporate_Country__c', 'India');
      fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Bill_To_City__c', 'Test City');            
      fieldValueMap.put('Bill_To_Country__c', 'India');        
      fieldValueMap.put('Fab_9_10__c','No');
      fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
      Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        insert testContact;   
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
                   
        return acc.Id;
    }
    
    static Id createAccountAndContact(){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
      fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
      fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
      fieldValueMap.put('sub_type__c', 'Indirect');
      fieldValueMap.put('site_department__c', 'test dept');          
      fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
      fieldValueMap.put('region__c', 'US');        
      fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Corporate_City__c', 'Test City');                
      fieldValueMap.put('Corporate_Country__c', 'India');
      fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Bill_To_City__c', 'Test City');            
      fieldValueMap.put('Bill_To_Country__c', 'India');        
      fieldValueMap.put('Fab_9_10__c','No');
      fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
      Account acc = AccountDataFactory.createAccount(fieldValueMap);
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;
        
        Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        testContact.Department__c = 'Design';
        insert testContact;              
        return testContact.Id;
    }

    static void createAccountTeamProxy(id accountId, list<id> userIdList, list<string> roleList){
        list<Account_Team_Proxy__c> atpList = new list<Account_Team_Proxy__c>();
        for(integer i = 0; i < userIdlist.size(); i++){
            Account_Team_Proxy__c  atp = new Account_Team_Proxy__c();
            atp.Account__c = accountId;
            atp.Account_Access__c = 'Read/Write';
            atp.Opportunity_Access__c = 'Read/Write';
            atp.Team_Role__c = roleList[i];
            if (roleList[i].equals('Customer Engineer')||roleList[i].equals('Fab Planner'))
            {
                atp.Fab_Assignment__c = 'FAB 3';
            }
            atp.User__c = userIdList[i];
            
            
            atpList.add(atp);
        }
        
        insert atpList;
    }
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
        fieldValueMap.put('OwnerId',userinfo.getUserid());
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
        /*Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c','0.055UM');
        fieldValueMap.put('Process_Family__c','MEMS');
        fieldValueMap.put('Fab_Assignment_1__c','Fab 3');
        fieldValueMap.put('OwnerId',userinfo.getUserid());     
        return OpportunityDataFactory.createOpportunity(fieldValueMap).Id;*/
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
    
    static Id createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        
        insert m;
        return m.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyId,  Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Tapeout_Type__c', 'Single Product');
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');
        fieldValueMap.put('Process_Family_Filter__c', 'MEMS');
        fieldValueMap.put('End_Application__c', 'Single Body'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');    
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', System.today());   
        fieldValueMap.put('Enabled_via_previous_MPW_1__c', 'No');           
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity2__c',testOpptyId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        
        return DeviceDataFactory.createDevice(fieldValueMap);       
    }
    
    static Device__c createInternalReadOnlyDevice(Id testAcctId, Id testOpptyId,  Id testOpptyProgramId) {
        Id RCTypeId = Schema.SObjectType.Device__c.getRecordTypeInfosByName().get('Internal Device Read Only').getRecordTypeId();
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Tapeout_Type__c', 'Single Product');
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');
        fieldValueMap.put('Process_Family_Filter__c', 'MEMS');
        fieldValueMap.put('Internal_Device_Process_Family__c', 'MEMS');
        fieldValueMap.put('End_Application__c', 'Single Body'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');    
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', System.today());   
        fieldValueMap.put('Enabled_via_previous_MPW_1__c', 'No');           
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity2__c',testOpptyId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('RecordTypeId',RCTypeId);
        
        return DeviceDataFactory.createDevice(fieldValueMap); 
    }
    
    static Device__c createMPWDevice(Id testAcctId, Id testOpptyId, Id testOpptyProgramId) {
        Id mpId = createMPW();
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');
        fieldValueMap.put('Process_Family_Filter__c', 'MEMS');
        fieldValueMap.put('Internal_Device_Process_Family__c', 'MEMS');
        fieldValueMap.put('End_Application__c', 'Body');    
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');    
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', System.today());   
        fieldValueMap.put('Enabled_via_previous_MPW_1__c', 'No');
        fieldValueMap.put('MPW_Train_Number__c',mpId);
                
        return DeviceDataFactory.createDevice(fieldValueMap); 
    }
    static Process__c createProcess(){
        Process__c process1 = new Process__c();
        process1.name = 'Test Process1';
        process1.Available_to_Sell__c = 'Registered/TBO';//Prototype Ready; MPW Ready;'Registered/TBO
        process1.Bias_Table_Spec__c = 'Test bais tabel spec';
        process1.Tech_Geometry__c = '0.055UM';
        process1.Process_Family__c = 'MEMS';
        insert process1;
        return process1;
    }
    static BX_041__c createCDRS(Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId ){
        
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.id;
        bx041.Approval_status__c = appstatus;
       // bx041.Approval_status__c ='Approved by FAE'; 
        bx041.Initial_Submitter__c = 'FAE/FTS';
        bx041.BX_041_Status__c = cdrsStatus;
        bx041.Approval_Step__c = appStep;
        bx041.Next_WorkItem_Id__c = workitemid;
        bx041.approver_1__c = apprId;   
        bx041.No_of_CE_Approver__c =4;      
        bx041.Geometry_Filter__c = device.Geometry_Filter__c;
        bx041.Process_Family_Filter__c = device.Process_Family_Filter__c;

        insert bx041;  
        return bx041;  
    }
    
        static BX_041__c createCDRS_3(Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId ){
        
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.id;
        bx041.Approval_status__c = appstatus;
        bx041.Initial_Submitter__c = 'FAE/FTS';
        bx041.BX_041_Status__c = cdrsStatus;
        bx041.Approval_Step__c = appStep;
        bx041.Next_WorkItem_Id__c = workitemid;
        bx041.approver_1__c = apprId;
        bx041.Geometry_Filter__c = device.Geometry_Filter__c;
        bx041.Process_Family_Filter__c = device.Process_Family_Filter__c;

        insert bx041;  
        return bx041;  
    }
   
   
    static BX_041__c createCDRS_2(Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId ){
        
        BX_041__c bx041 = new BX_041__c ();
        bx041.Device__c = device.id;
        bx041.Approval_status__c ='Approved by PI/YE'; //'Approved by CE';
        bx041.Initial_Submitter__c = 'FAE/FTS';
        bx041.BX_041_Status__c = cdrsStatus;
        bx041.Approval_Step__c = 'Pending for CE';
        bx041.Next_WorkItem_Id__c = workitemid;
        bx041.No_of_CE_Approver__c =4;    
        bx041.Geometry_Filter__c = device.Geometry_Filter__c;
        bx041.Process_Family_Filter__c = device.Process_Family_Filter__c;

        insert bx041;  
        return bx041;  
    }
    
    Static MPW_Train_Maintenance__c CreateMPWTrainMaintenance(){
        MPW_Train_Maintenance__c MPWTrainMain=new MPW_Train_Maintenance__c();
        MPWTrainMain.Name='MPW4907';
        MPWTrainMain.Close_Date__c=system.Today()-10;
        MPWTrainMain.Customer_Tapeout_Date__c=system.Today()+60;
        MPWTrainMain.MPW_Train_No__c='MPW4907';
        MPWTrainMain.Open_Date__c=system.today().addYears(-1);
        MPWTrainMain.Other_Tapeout_Date__c=system.today().addYears(-1);
        MPWTrainMain.Status__c='';
        Insert MPWTrainMain;
        return MPWTrainMain;
    }
    
     Static MPW_Train_Maintenance__c CreateMPWTrainMaintenance_2(){
        MPW_Train_Maintenance__c MPWTrainMain=new MPW_Train_Maintenance__c();
        MPWTrainMain.Name='MPW3768';
        MPWTrainMain.Close_Date__c=system.Today()-12;
        MPWTrainMain.Customer_Tapeout_Date__c=system.Today()+60;
        MPWTrainMain.MPW_Train_No__c='MPW3768';
        MPWTrainMain.Open_Date__c=system.today().addYears(-1);
        MPWTrainMain.Other_Tapeout_Date__c=system.today().addYears(-1);
        MPWTrainMain.Status__c='';
        Insert MPWTrainMain;
        return MPWTrainMain;
    }
    static Id createAccount_2() {
        // Create Account
        
  
  Map<String,Object> fieldValueMap = new Map<String,Object>();
      fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
      fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
      fieldValueMap.put('sub_type__c', 'Indirect');
      fieldValueMap.put('site_department__c', 'test dept');          
      fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
      fieldValueMap.put('region__c', 'US');        
      fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Corporate_City__c', 'Test City');                
      fieldValueMap.put('Corporate_Country__c', 'India');
      fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
      fieldValueMap.put('Bill_To_City__c', 'Test City');            
      fieldValueMap.put('Bill_To_Country__c', 'India');        
      fieldValueMap.put('Fab_9_10__c','No');
      fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
      Account testAcct = AccountDataFactory.createAccount(fieldValueMap);
        
        testAcct.Siebel_Account_ID__c = '123123123123';
        
        Update testAcct;
        
        return testAcct.Id;
    }
    
    static Map<String, Id> getProfileMap()
    {
        List<Profile> profiles = [select ID, Name from Profile WHERE Name In('System Administrator','GF FAE/FTS','GF CE','GF PIYE Platform','Customer Portal Profile')];
        Map<String, Id> profileMap = new Map<String, Id>();
        for(Profile p : profiles)
        {
            profileMap.put(p.Name, p.Id);
        }
        
        return profileMap;
    }
    
    static void createUsers(Id contactId)
    {
        Map<String, Id> profileMap = getProfileMap();
        List<User> users = new List<User>();
        List<HCM_Employee__c> HCMEmployees = new List<HCM_Employee__c>();
        Integer iCount = 1;
        Id custPortalId = profileMap.get('Customer Portal Profile');
        
        for(Id profileId : profileMap.values()) {
        
            User u = new User(Alias = 'ts'+iCount, Email= 'testing' + iCount + '@cy.com',
                 EmailEncodingKey='UTF-8', LastName='TestCY' + iCount, LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = profileId, communitynickname='ts' + iCount, Fab_Assigned__c='FAB 3',
                 FederationIdentifier='Test2014'+iCount, TimeZoneSidKey='America/Los_Angeles', UserName= 'testing' + iCount + '@cy.com');
                 
            HCM_Employee__c testHCMEmployee = new HCM_Employee__c(First_Name__c='TestFirst' + iCount, Last_Name__c='TestCY' + iCount,
                 Employee_ID__c='Test2014'+iCount, Login_ID__c='testing' + iCount + '@cy.com', Email_Address__c='testing' + iCount + '@cy.com',
                 Status__c='Active');      
        
            if (profileId == custPortalId)
                u.ContactId = contactId;
                 
            users.add(u);  
            HCMEmployees.add(testHCMEmployee);  
            iCount++;
        }
        
        insert HCMEmployees;
        insert users;
       
    }
    
    static Portal_Tab_Access__c createPortalTabAccess(Id accountId, Id userId)
    {
        Portal_Tab_Access__c accessSetup = new Portal_Tab_Access__c(Account__c=accountId, User__c=userId, Change_request_report__c=true,My_Devices__c=true);  
        return accessSetup;   
    }
    
   static Device__c createMPWDevices(Id testAcctId, Id testOpptyProgramId,Id MPWID) {
        // Create Device
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'TESTDEVICEZAIH12345677');            
        fieldValueMap.put('Opportunity_Program__c', testOpptyProgramId);        
        fieldValueMap.put('Fab__c', 'Fab 1');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');          
        fieldValueMap.put('Market_Segment__c', 'Mobility');                          
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');        
        fieldValueMap.put('End_Customer__c', 'Test Customer');          
        fieldValueMap.put('Device_Sourcing__c', '1st Source');                
        fieldValueMap.put('Stage__c', 'Active');
        fieldValueMap.put('Status__c', 'Test Address 1');          
        fieldValueMap.put('Tapeout_Type__c', 'GlobalShuttle MPW');            
        fieldValueMap.put('Geometry_Filter__c', '0.055UM');        
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Confidence_Level_Tapeout__c','MEMS');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('MPW_Train_Number__c',MPWID);
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Reticle_Type__c', 'Single Layer Reticle (SLR)');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',system.today());
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
     
    static testmethod void testBX041PermissonHandler1()
    {
        String testAcctId = createAccount();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);       
        
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        test.startTest();
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
         
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        //test.startTest();
        BX_041__c bx041 = createCDRS(testDevice,'','Pending Submission','Pending for Customer',null,null);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler2()
    {
        String testAcctId = createAccount();
        test.startTest();        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_3(testDevice,'','Pending Submission','Pending for FAE/FTS','wkid',fae.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler3()
    {
        String testAcctId = createAccount();
        test.startTest();
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by FAE/FTS','Pending Submission','Pending for FAE/FTS',null, null);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler4()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);

        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by FAE/FTS','Pending Review','Pending for CE','wkid',ce.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler5()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by CE','Pending Review','Pending for CE',null,ce.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        //added by sunita
        bx041.Approval_Status__c='Approved by FAE';
        
        update bx041;
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler6()
    {
        String testAcctId = createAccount();
        test.startTest();
 
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by CE','Pending Acknowledgement','Pending for PIYE','wkid',piye.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler7()
    {
        String testAcctId = createAccount();
        test.startTest();
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by PI/YE','Frozen/Pending PID Assignment','Approved',null,piye.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler8()
    {
        String testAcctId = createAccount();
        test.startTest();
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by PI/YE','Closed','Approved',null,piye.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
     static testmethod void testBX041PermissonHandlerX1()
    {
        String testAcctId = createAccount();
        test.startTest();
   
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS(testDevice,'Approved by FAE/FTS','Pending Review','Pending for CE','wkid',null);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler8_1()
    {
        String testAcctId = createAccount();
        test.startTest();
      
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        
        MPW_Train_Maintenance__c MPWTM=BX041PermissionHandlerTest.CreateMPWTrainMaintenance();
        
        Device__c DEV=BX041PermissionHandlerTest.createMPWDevices(testAcctId,testOpptyProgramId,MPWTM.Id);
        DEV.Fab__c = 'Fab 8';
        update DEV;
        
        BX_041__c bx041 = createCDRS_2(DEV,'Approved by PI/YE','Closed','Approved',null,piye.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler8_2()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_2(testDevice,'Approved by PI/YE','Closed','Approved',null,piye.id);
       
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testBX041PermissonHandler2_2()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_2(testDevice,'','Pending Review','Pending for CE','wkid',fae.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
     static testmethod void testBX041PermissonHandler2_3()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createMPWDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_3(testDevice,'','Pending Submission','Pending for CE','wkid',fae.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testInternalDevicePendingSubmission()
    {
        String testAcctId = createAccount();
        test.startTest();
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createInternalReadOnlyDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_3(testDevice,'','Pending Submission','Pending for CE','wkid',fae.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();        
    }
    
    static testmethod void testInternalDevicePendingReview()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createInternalReadOnlyDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_2(testDevice,'','Pending Review','Pending for CE','wkid',fae.id);
        //Device__c  device, String appstatus,string cdrsStatus, string appStep, string workItemId, id apprId
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
    
    static testmethod void testInternalDeviceApproved()
    {
        String testAcctId = createAccount();
        test.startTest();
        
        User admin = [SELECT Id FROM user WHERE profile.Name='System Administrator' and isactive = true limit 1];
        User fae = [SELECT Id FROM user WHERE profile.Name='GF FAE/FTS' and isactive = true limit 1];
        User ce = [SELECT Id FROM user WHERE profile.Name='GF CE' and isactive = true and   Fab_Assigned__c includes('Fab 3')  limit 1];
        User piye = [SELECT Id FROM user WHERE profile.Name='GF PIYE Platform' and isactive = true limit 1];
        User cp = [SELECT Id FROM user WHERE profile.Name='Customer Portal Profile' and isactive = true limit 1];
        
        Portal_Tab_Access__c pta = createPortalTabAccess(testAcctId,cp.Id);
        createAccountTeamProxy(testAcctId, new list<id>{fae.id, ce.id, admin.id}, new list<string>{'Primary Field Application Engineer','Customer Engineer','Account Manager'});
        
        String testOpptyId = createOpportunity(testAcctId);
        String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        Device__c testDevice =  createInternalReadOnlyDevice(testAcctId, testOpptyId, testOpptyProgramId);
        
        BX_041__c bx041 = createCDRS_2(testDevice,'Approved by PI/YE','Closed','Approved',null,piye.id);
       
        BX041PermissionHelper.getPermissions(bx041.Id, admin.id, 'System Administrator');
        BX041PermissionHelper.getPermissions(bx041.Id, fae.id, 'GF FAE/FTS');
        BX041PermissionHelper.getPermissions(bx041.Id, ce.id, 'GF CE');
        BX041PermissionHelper.getPermissions(bx041.Id, piye.id, 'GF PIYE Platform');
        BX041PermissionHelper.getPermissions(bx041.Id, pta.user__c, 'Customer Portal Profile');
        
        test.stopTest();
        
    }
}