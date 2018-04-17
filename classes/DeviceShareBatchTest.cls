/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for DeviceShareBatch.
    History: 
        ZAmbat      12182013    - Code creation.
        Ashwini     04132015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
private class DeviceShareBatchTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Account acct1 = DeviceShareBatchTest.createAccount1();
        Account acct2 = DeviceShareBatchTest.createAccount2(acct1.Id);
        Contact con1 = DeviceShareBatchTest.createContact1(acct1.Id);
        Contact con2 = DeviceShareBatchTest.createContact2(acct2.Id);
        Test.startTest();
        string opptyId = DeviceShareBatchTest.createOpportunity(acct2.Id);        
        string opptyProgramId = DeviceShareBatchTest.createOpportunityProgram(acct2.Id, opptyId);        
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acct2.Id,MSTId);
        Device__c dev= DeviceUtilTest.createCustomerMPWDevice2(acct2.Id,opptyProgramId);        
        Test.stopTest();
    }
    static Account createAccount1() {
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

        return AccountDataFactory.createAccount(fieldValueMap);
        
    }
    
    static Account createAccount2(Id acctId) {
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
        fieldValueMap.put('ParentId',acctId);
        
        return AccountDataFactory.createAccount(fieldValueMap);
         
    }
    
    static Account createAccount3() {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT3');            
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
        
        return AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Contact createContact1(Id testAcctId) {
        Contact con = new Contact(
            firstName = 'Test1',
            lastName = 'Contact1',
            email = 'test1@test.com',
            accountId = testAcctId,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        
        insert con;
        return con;
    }
    
    static Contact createContact2(Id testAcctId) {
        Contact con = new Contact(
            firstName = 'Test2',
            lastName = 'Contact2',
            email = 'test2@test.com',
            accountId = testAcctId,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin',
            Department__c = 'Design'
        );
        
        insert con;
        return con;
    }
    
    static Contact createContact3(Id testAcctId) {
        Contact con = new Contact(
            firstName = 'Test3',
            lastName = 'Contact3',
            email = 'test3@test.com',
            accountId = testAcctId,
            is_portal_user_active__c = true,
            is_portal_user_created__c = true,
            role__c = 'Customers My Device Admin'
        );
        
        insert con;
        return con;
    }
    
    static Id createOpportunity(Id testAcctId) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
       
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        Opportunity_Program__c opProg = new Opportunity_Program__c(
            Name='Test OppProg',
            Account__c=testAcctId,
            Opportunity__c=testOpptyId
        );
        
        insert opProg;
        return opProg.Id;
    }
    
    /*static id createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c(
            name = 'testPT',
            PT_number__c = 'PT12323'
        );
        
        insert p;
        return p.Id;
    } */
    
    static testMethod void runTest1() {
        
        Account acct1 = [select Id, name from Account where Name='MYTEST ACCOUNT1'];
        Account acct2 = [select Id, name from Account where Name='MYTEST ACCOUNT2'];
        Contact con1 = [select Id, name from Contact where email='test1@test.com'];
        Contact con2 = [select Id, name from Contact where email='test2@test.com'];
        Test.startTest();
        string opptyId = [select Id, name from Opportunity where name='Test Opportunity'].Id;
        string opptyProgramId = [select Id, name from Opportunity_Program__c where name='Test OppProg'].Id;
        //Profile pp = [Select Id from Profile where Name='System Administrator']; 
        //User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        
        Device__c dev = [select Id, Name,Account__c,Opportunity_Program__c from Device__c where Name='TESTDEVICEZAIH12345677'];

               
        List<User> users = new List<User>();
        User portalUser1 = new User(
            contactId = con1.Id,
            firstName = 'Test1',
            lastName = 'Contact1',
            email = 'test1@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr1',
            profileId = '00e90000001AT3e',
            timezonesidkey='America/Los_Angeles', 
            username='testing001@test.com',
            FederationIdentifier='Test20151'
        );
        
        User portalUser2 = new User(
            contactId = con2.Id,
            firstName = 'Test2',
            lastName = 'Contact2',
            email = 'test2@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr2',
            profileId = '00e90000001AT3e',
            timezonesidkey='America/Los_Angeles', 
            username='testing002@test.com',
            FederationIdentifier='Test20152'
        );
        
        users.add(portalUser1);
        users.add(portalUser2);
        //system.runas(ur){ 
            insert users;
        //}
        
        Portal_Tab_Access__c pta1 =  new Portal_Tab_Access__c(
            Account__c = acct1.Id,
            User__c = portalUser1.Id,
            IP_Declaration__c = true,
            Export_Control__c = true,
            My_Devices__c = true,
            Change_request_report__c = true
        );
        
        Portal_Tab_Access__c pta2 =  new Portal_Tab_Access__c(
            Account__c = acct2.Id,
            User__c = portalUser2.Id,
            IP_Declaration__c = true,
            Export_Control__c = true,
            My_Devices__c = true,
            Change_request_report__c = true
        );
        
        
      
         
        List<Portal_Tab_Access__c> listAccess = new List<Portal_Tab_Access__c>();
        listAccess.add(pta1);
        listAccess.add(pta2);
        //insert listAccess;
        
        Database.insert(listAccess,false);
                
          /*  Device__c dev = new Device__c(
                Name = 'TESTDEVICE1313',
                Stage__c = 'Design In',
                Status__c = 'Active',
                Account__c = acct2.Id,
                Opportunity2__c = opptyId,
                Opportunity_Program__c = opptyProgramId,
                Market_Segment__c = 'Automotive',
                Semiconductor_Device__c = 'Analog Regulator',
                End_Application__c = 'Body',
                Device_Sourcing__c = '3rd Source',
                Tapeout_Type__c = 'Customer MPW',
                Siebel_Device_ID__c = '0987654321',
                IP_Gap__c = false,
                Actual_Tapeout_Date__c = date.newInstance(2013,5,20),
                Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20),
                Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20),
                Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4),
                process_technology_2__c = DeviceShareBatchTest.createProcessTechnology(),
                expose_device_to_customer__c = true,
                fab__c = 'FAB 1',
                confidence_level_tapeout__c = '50',
                PTRF_ID__c = 'PTRF123'
            );
            
            insert dev;*/
            
            ExposeDeviceToCustomer.ReturnMessage rm = new ExposeDeviceToCustomer.ReturnMessage();
            List<Device__c> listDevices = new List<Device__c>();
            listDevices.add(dev);
            Set<Id> acctIds = new Set<Id>(); 
            acctIds.add(acct2.Id);
            rm = ExposeDeviceToCustomer.validate(listDevices, acctIds);
            //system.assertEquals(rm.ErrorMessage, null);
            ExposeDeviceToCustomer.exposeCustomer(rm.recordsMap, false);
           // system.assertEquals(dev.expose_device_to_customer__c, true);
                        
            string accountIds = '(\'' + acct1.Id + '\', \'' + acct2.Id + '\')';
            string queryString = 'SELECT Id, Contact.AccountId FROM User WHERE isPortalEnabled = true AND IsActive = true AND Contact.AccountId IN ' + accountIds;
            database.executeBatch(new DeviceShareBatch(queryString));
        Test.stopTest();
       
    }
    
    static testMethod void runTest2() {
        
        Account acct1 = [select Id, name from Account where Name='MYTEST ACCOUNT1'];
        Account acct2 = [select Id, name from Account where Name='MYTEST ACCOUNT2'];
        Contact con1 = [select Id, name from Contact where email='test1@test.com'];
        Contact con2 = [select Id, name from Contact where email='test2@test.com'];
        Test.startTest(); 
        string opptyId = [select Id, name from Opportunity where name='Test Opportunity'].Id;        
        string opptyProgramId = [select Id, name from Opportunity_Program__c where name='Test OppProg'].Id;          
        Device__c dev = [select Id, Name,Account__c,Opportunity_Program__c from Device__c where Name='TESTDEVICEZAIH12345677'];
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
            
              
        List<User> users = new List<User>();
        User portalUser1 = new User(
            contactId = con1.Id,
            firstName = 'Test1',
            lastName = 'Contact1',
            email = 'test1@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr1',
            profileId = '00e90000001AT3e',
            timezonesidkey='America/Los_Angeles', 
            username='testing001@test.com',
            FederationIdentifier='Test20151'
        );
        
        User portalUser2 = new User(
            contactId = con2.Id,
            firstName = 'Test2',
            lastName = 'Contact2',
            email = 'test2@test.com',
            emailencodingkey='UTF-8',           
            communityNickname = 'Contact_'+math.random(),
            languagelocalekey='en_US',
            localesidkey='en_US',
            alias = 'portUsr2',
            profileId = '00e90000001AT3e',
            timezonesidkey='America/Los_Angeles', 
            username='testing002@test.com',
            FederationIdentifier='Test20152'
        );
        
        
        users.add(portalUser1);
       users.add(portalUser2);
        //system.runas(ur){  
            insert users;
        //}
        
        Portal_Tab_Access__c pta1 =  new Portal_Tab_Access__c(
            Account__c = acct1.Id,
            User__c = portalUser1.Id,
            IP_Declaration__c = true,
            Export_Control__c = true,
            My_Devices__c = true,
            Change_request_report__c = true
        );
        
        Portal_Tab_Access__c pta2 =  new Portal_Tab_Access__c(
            Account__c = acct2.Id,
            User__c = portalUser2.Id,
            IP_Declaration__c = true,
            Export_Control__c = true,
            My_Devices__c = true,
            Change_request_report__c = true
        );
        
        
        
        List<Portal_Tab_Access__c> listAccess = new List<Portal_Tab_Access__c>();
        listAccess.add(pta1);
        listAccess.add(pta2);
        //insert listAccess;
        Database.insert(listAccess,false);
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        //string MSTAccId = DeviceUtilTest.createMSTAccount(acct1.Id,MSTId);
        Process_Technology__c pt = new Process_Technology__c();
        pt.name = 'Test PT';
        insert pt;
        //Device__c dev = DeviceUtilTest.createCustomerMPWDevice2(acct1.Id,opptyProgramId);        
        dev.Expose_Device_to_Customer__c = true;
        dev.Process_Technology_2__c = pt.id;
        update dev; 
            ExposeDeviceToCustomer.ReturnMessage rm = new ExposeDeviceToCustomer.ReturnMessage();
            //List<Device__c> listDevices = [select Name,Opportunity_Program__c ,Fab__c ,GSOP_Assignment_Tapeout_Plan__c ,Market_Segment__c ,Semiconductor_Device__c ,End_Customer__c ,Device_Sourcing__c ,Stage__c ,Status__c ,Siebel_Device_ID__c ,Tapeout_Type__c ,Confidence_Level_Tapeout__c ,expose_device_to_customer__c ,Original_Forecasted_Tapeout_Date__c ,PLM_Device_ID__c ,Device_Mask_Set_Title__c ,CRMDID__c ,Device_Type__c ,reticle_type__c ,End_Application__c from Device__c where ID=: dev1 ];
            List<Device__c> listDevices = new List<Device__c>();
            listDevices.add(dev);
            
            Set<Id> acctIds = new Set<Id>(); 
            acctIds.add(acct1.Id);
            rm = ExposeDeviceToCustomer.validate(listDevices, acctIds);
            //system.assertEquals(rm.ErrorMessage, null);
            ExposeDeviceToCustomer.exposeCustomer(rm.recordsMap, false);
           // system.assertEquals(dev.expose_device_to_customer__c, true);
                        
            string accountIds = '(\'' + acct1.Id + '\', \'' + acct2.Id + '\')';
            string queryString = 'SELECT Id, Contact.AccountId FROM User WHERE isPortalEnabled = true AND IsActive = true AND Contact.AccountId IN ' + accountIds;
            //system.runas(ur){
                database.executeBatch(new DeviceShareBatch(queryString));
            //}
        Test.stopTest();
        
    } 
}