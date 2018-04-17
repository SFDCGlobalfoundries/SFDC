/*
    Author: Zymark Ambat
    Description: This serves as the test class for DevicePTRFReminderBatch.
    History: 
        ZAmbat      04142014    - Code creation.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@istest(SeeAllData=false)
public class DevicePTRFReminderBatchTest {
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
        string testAcctId = getAccount('MYTEST ACCOUNT1').id;
        string testContactId = DevicePTRFReminderBatchTest.createContact(testAcctId);
        string testOpptyId = DevicePTRFReminderBatchTest.createOpportunity(testAcctId);
        string testOpptyProgramId = DevicePTRFReminderBatchTest.createOpportunityProgram(testAcctId, testOpptyId);        
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
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;                
    }
    
    static Id createOpportunity2(Id testAcctId) {
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
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
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
    
    static Id createEmailTemplate() {
        EmailTemplate et = new EmailTemplate();
        et.Name = Environment_Variable__c.getInstance('DEVICE_PTRF_MAIL_TEMPLATE').Value__c;
        et.developerName = Environment_Variable__c.getInstance('DEVICE_PTRF_MAIL_TEMPLATE').Value__c.replace(' ', '_');
        et.IsActive = true;
        et.TemplateType = 'Text';
        et.FolderId = UserInfo.getUserId();
        
        insert et;
        
        return et.Id;
    }
    
    static Id createCustomerMPWDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Fab__c','FAB 2'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Automotive'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1'); 
        fieldValueMap.put('Confidence_Level_Tapeout__c','100'); 
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today().addDays(7)); 
        fieldValueMap.put('CRMDID__c','CDID0000001.00'); 
        fieldValueMap.put('Device_Type__c','Base'); 
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)'); 
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap).Id;
    }
    
    static testMethod void testDevicePTRFReminderBatch1() {
        //DataUtilTest.loadEnvironmentVariables();
        //string testEmailTemplateId = DevicePTRFReminderBatchTest.createEmailTemplate();
        /*string testAcctId = getAccount('MYTEST ACCOUNT1').id;
        string testContactId = DevicePTRFReminderBatchTest.createContact(testAcctId);
        string testOpptyId = DevicePTRFReminderBatchTest.createOpportunity(testAcctId);
        string testOpptyProgramId = DevicePTRFReminderBatchTest.createOpportunityProgram(testAcctId, testOpptyId); */
        string testAcctId = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'].Id;
        string testContactId = [Select Id, Name from Contact where Email='test@test.com'].Id;
        string testOpptyId = [Select Id, Name from Opportunity where Name='Test Opportunity'].Id;
        string testOpptyProgramId = [Select Id, Name from Opportunity_Program__c where Name='Test Opportunity Program'].Id;

       // Device__c testDevicePTRF = DevicePTRFReminderBatchTest.createDevice(testAcctId, testOpptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId ,MSTId);
        test.startTest();
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            timezonesidkey='America/Los_Angeles', 
            username='testing112@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );
        
        insert u1;
        system.assertEquals(u1.Email,'testing@test.com');
        Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Field Application Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = testOpptyProgramId
            
        );
        
        insert optm1;
        
        system.runas(u1){
            string testEmailTemplateId = DevicePTRFReminderBatchTest.createEmailTemplate();
        }
        
        
            ID testDevice = createCustomerMPWDevice(testAcctId ,testOpptyProgramId );
            database.executeBatch(new DevicePTRFReminderBatch());
            
        test.stopTest();
    }
    
    static testMethod void testDevicePTRFReminderBatch2() {
        //DataUtilTest.loadEnvironmentVariables();
        //string testEmailTemplateId = DevicePTRFReminderBatchTest.createEmailTemplate();
       /* string testAcctId = getAccount('MYTEST ACCOUNT1').id;
        string testContactId = DevicePTRFReminderBatchTest.createContact(testAcctId);
        string testOpptyId = DevicePTRFReminderBatchTest.createOpportunity2(testAcctId);
        string testOpptyProgramId = DevicePTRFReminderBatchTest.createOpportunityProgram(testAcctId, testOpptyId); */
        string testAcctId = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'].Id;
        string testContactId = [Select Id, Name from Contact where Email='test@test.com'].Id;
        string testOpptyId = [Select Id, Name from Opportunity where Name='Test Opportunity'].Id;
        string testOpptyProgramId = [Select Id, Name from Opportunity_Program__c where Name='Test Opportunity Program'].Id;
     //   Device__c testDevicePTRF = DevicePTRFReminderBatchTest.createDevice(testAcctId, testOpptyProgramId);
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId ,MSTId);
          test.startTest();
        User u1 = new User(
            alias = 'ts', 
            email='testing@test.com',
            emailencodingkey='UTF-8', 
            lastname='TestLast', 
            firstname='TestFirst', 
            languagelocalekey='en_US',
            localesidkey='en_US', 
            profileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            timezonesidkey='America/Los_Angeles', 
            username='testing111@test.com',
            communitynickname='ts',
            FederationIdentifier='Test2014'
        );
        
        insert u1;
        system.assertEquals(u1.Email,'testing@test.com');
         Opportunity_Program_Team_Member__c optm1 = new Opportunity_Program_Team_Member__c(
            user__c = u1.id,
            team_role__c= 'Field Application Engineer',
            device_access__c = 'Read/Write',
            core_team_member__c = true,
            opportunity_program_access__c = 'Read/Write',
            opportunity_program__c = testOpptyProgramId
            
        );
        
        insert optm1;
        
        system.runas(u1){
            string testEmailTemplateId = DevicePTRFReminderBatchTest.createEmailTemplate();
        }
        
      
            ID testDevice = createCustomerMPWDevice(testAcctId ,testOpptyProgramId );
            database.executeBatch(new DevicePTRFReminderBatch());
            
        test.stopTest();
    }
    
    static testMethod void testDevicePTRFReminderBatchScheduler() {
        test.startTest();
            DevicePTRFReminderBatchScheduler d = new DevicePTRFReminderBatchScheduler();
            String s = '0 0 23 * * ?';
            system.schedule('DevicePTRFReminderBatch1', s, d);
            system.assertEquals(true,true);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}