/*
    Author: Zymark Ambat
    Description: This Class serves as the controller for the DeviceExposeToCustomer.
    History: 
        ZAmbat      07302014    - Code creation.
        Vijay       11282014    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 'Design In' directly.
        Devendra  10142015      - Updated to fix device validation error
*/ 
@isTest(SeeAllData=false)
private class DeviceExposeToCustomerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=3;i++){
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
        
        AccountDataFactory.createAccounts(fieldValueMapList,3);        
    }

    static Account createAccount1() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
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
        testAcct.Short_Name__c = 'Test2015';//'TestAcct1Z';
        //testAcct.OwnerId = u.Id;
        
        //System.runAs(u) {
            insert testAcct;
        //}
        
        
        
        return testAcct;
    }
    
    static Account createAccount2(Id acctId) {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account2';
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
        testAcct.Short_Name__c = 'TestAcct2Z';
        testAcct.ParentId = acctId;
        
        insert testAcct;
        
        return testAcct;
    }
    
    static Account createAccount3(Id acctId) {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account2';
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
        testAcct.Short_Name__c = 'TestAcct3Z';
        testAcct.ParentId = acctId;
        
        insert testAcct;
        
        return testAcct;
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
        fieldValueMap.put('Process_Geometry__c','0.005UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;        
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    //13012016
    static MPW_Train_Maintenance__c MPWTRAIN(){
        MPW_Train_Maintenance__c MPWT=new MPW_Train_Maintenance__c();
        MPWT.Name='MPW0101';
        Insert MPWT;
        return MPWT;
    
    }
    
    static Device__c createDevice1(Id testAcctId, Id testOpptyProgramId) {
    
        /*MPW_Train_Maintenance__c MPWT=new MPW_Train_Maintenance__c();
        MPWT.Name='MPW0101';
        Insert MPWT;*/
        string mpwId = DeviceUtilTest.createMPW();
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677'); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','DVMST12345');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Revise');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Design_Partner__c',testAcctId);
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    static Device__c createDevice2(Id testAcctId, Id testOpptyProgramId, Id testPTId) {
        // Create Device
        
        string mpwId = DeviceUtilTest.createMPW();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICESP'); 
        fieldValueMap.put('Account__c',testAcctId); 
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId); 
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1'); 
        fieldValueMap.put('Actual_Tapeout_Date__c',datetime.now()); 
        fieldValueMap.put('Process_Family_Filter__c','Super Low Power'); 
        fieldValueMap.put('reticle_type__c','Small Field Reticle (SFR)'); 
        fieldValueMap.put('Geometry_Filter__c','0.10UM'); 
        fieldValueMap.put('Fab__c','FAB 2'); 
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No'); 
        fieldValueMap.put('Market_Segment__c','Mobility'); 
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier'); 
        fieldValueMap.put('End_Customer__c','Test Customer'); 
        fieldValueMap.put('Device_Sourcing__c','1st Source'); 
        fieldValueMap.put('Stage__c','Design In'); 
        fieldValueMap.put('Status__c','Active'); 
        fieldValueMap.put('Siebel_Device_ID__c','1234567890'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01'); 
        fieldValueMap.put('CRMDID__c','CDID0000001.00'); 
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('PTRF_ID__c','PTRF123');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        //fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.today());
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Process_Technology_2__c',testPTId);
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('Export_Control_Junction__c','1');
        fieldValueMap.put('Expose_Device_to_Customer__c',false);
        //fieldValueMap.put('MPW_Train_Number__c',mpwId);
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    static Process_Technology__c createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        
        insert p;
            
        return p;
    }
    
    static Id createContact(Id acctId) {
        Contact c = new Contact();
        c.AccountId = acctId;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'test@test.com';
        c.Is_Portal_User_Active__c = true;
        c.Is_Portal_User_Created__c = true;
        c.Department__c = 'Design';
        c.Role__c = 'Customers My Device Admin';
        
        insert c;
        
        return c.Id;
    }
    
    static Id createPortalUser(Id contactId) {
        User portalUser = new User();
        portalUser.contactId = contactId;
        portalUser.firstName = 'Test';
        portalUser.lastName = 'Contact';
        portalUser.email = 'test@test.com';
        portalUser.emailencodingkey='UTF-8';           
        portalUser.communityNickname = 'Contact_'+math.random();
        portalUser.languagelocalekey='en_US';
        portalUser.localesidkey='en_US';
        portalUser.alias = 'portUsrT';
        portalUser.profileId ='00e90000001C376';
        portalUser.timezonesidkey='America/Los_Angeles'; 
        portalUser.username='testing00@test.com';
        portalUser.FederationIdentifier='test2017';
        //portalUser.Role='CE Dresden Leader';
        
        insert portalUser;
        
        return portalUser.Id;
    }
    
    static Id createPortalTabAccess(Id accountId, Id portalUserId) {
        Portal_Tab_Access__c pta =  new Portal_Tab_Access__c();
        pta.Account__c = accountId;
        //pta.User__c = portalUserId;//commented to resolve test failures
        pta.IP_Declaration__c = true;
        pta.Export_Control__c = true;
        pta.My_Devices__c = true;
        pta.Change_request_report__c = true;
        
        insert pta;
        pta.User__c = portalUserId;
        update pta;
        
        return pta.Id;
    }
    
    static testMethod void testDeviceExposeToCustomer1() {
        Account testAccount1 = getAccount('MYTEST ACCOUNT1');
        
        Account testAccount2 = getAccount('MYTEST ACCOUNT2');
        testAccount2.ParentId = testAccount1.id;
        update testAccount2;
                
        Account testAccount3 = getAccount('MYTEST ACCOUNT3');
        testAccount3.ParentId = testAccount2.id;
        update testAccount3;
        test.startTest();
        string testOpptyId = DeviceExposeToCustomerTest.createOpportunity(testAccount2.Id);
        string testOpptyProgramId = DeviceExposeToCustomerTest.createOpportunityProgram(testAccount2.Id, testOpptyId);
        
        Device__c testDevice = DeviceExposeToCustomerTest.createDevice2(testAccount2.Id, testOpptyProgramId,null);
        Process_Technology__c testPT = DeviceExposeToCustomerTest.createProcessTechnology();
        

        
            test.setCurrentPageReference(new PageReference('Page.DeviceExposeToCustomerVF'));
            system.currentPageReference().getParameters().put('deviceId', testDevice.Id);
            DeviceExposeToCustomer detc = new DeviceExposeToCustomer();
            
            testDevice.Stage__c = 'Design In';
            testDevice.Semiconductor_Device__c = 'Analog - Amplifier';
            testDevice.Confidence_Level_Tapeout__c = '100';
            testDevice.Original_Forecasted_Tapeout_Date__c = date.today();
            testDevice.End_Application__c = 'Body';
            //update testDevice;
            system.currentPageReference().getParameters().put('deviceId', testDevice.Id);
            detc = new DeviceExposeToCustomer();
            
            testDevice.Process_Technology_2__c = testPT.Id;
            //update testDevice;
            system.currentPageReference().getParameters().put('deviceId', testDevice.Id);
            detc = new DeviceExposeToCustomer();
            
            testDevice.Device_Type__c = 'Base';
            testdevice.Enabled_via_previous_MPW_1__c='No';
        test.stopTest();
    }
    
    static testMethod void testDeviceExposeToCustomer2() {
       
        Account testAccount1 = getAccount('MYTEST ACCOUNT1');
       
        string testOpptyId = DeviceExposeToCustomerTest.createOpportunity(testAccount1.Id);
        string testOpptyProgramId = DeviceExposeToCustomerTest.createOpportunityProgram(testAccount1.Id, testOpptyId);
        Process_Technology__c testPT = DeviceExposeToCustomerTest.createProcessTechnology();
        test.StartTest();
        Device__c testDevice = DeviceExposeToCustomerTest.createDevice1(testAccount1.Id, testOpptyProgramId);
        //test.StartTest();
        string testContactId = DeviceExposeToCustomerTest.createContact(testAccount1.Id);
        
        string testPortalUserId = DeviceExposeToCustomerTest.createPortalUser(testContactId);
        string testPortalTabAccessId = DeviceExposeToCustomerTest.createPortalTabAccess(testAccount1.Id, testPortalUserId);
          
        test.setCurrentPageReference(new PageReference('Page.DeviceExposeToCustomerVF'));        
        system.currentPageReference().getParameters().put('deviceId', testDevice.Id);       
        //Test.setCurrentPage(pref);
        DeviceExposeToCustomer detc = new DeviceExposeToCustomer();
        //test.startTest();        
        detc.retrieveAllAccounts();
        test.stopTest();
        detc.retrieveDesignPartnerAccs();
        //test.stopTest();
        System.assert(detc.listAccounts.size()==1);
        System.assert(detc.listAccounts[0].isSelected==false);
        detc.listAccounts[0].isSelected=true;
        detc.listDPAccounts[0].isDPSelected=true;
        detc.showErrorMessage = true;
        detc.showSelectAccounts = true;
        detc.retrieveAllUsers();
        detc.backToAccountsSelection();
        //test.stopTest();
        detc.mapAccountUsers = new Map<string, DeviceExposeToCustomer.WrapperListUser>();             
        User WRUser=[select Id,Name,
                        contactId,
                        firstName,
                        lastName,
                        email,
                        emailencodingkey,
                        communityNickname,
                        languagelocalekey,
                        localesidkey,
                        alias,
                        profileId,
                        timezonesidkey,
                        username,
                        Contact.AccountId,
                        Contact.Account.Name,
                        Contact.Email,                            
                        FederationIdentifier
                        from User where Id=:testPortalUserId];
            DeviceExposeToCustomer.WrapperUser WPRUSER=new DeviceExposeToCustomer.WrapperUser();
                WPRUSER.Id = WRUser.Id;
                WPRUSER.AccountId = WRUser.Contact.AccountId;
                WPRUSER.ContactId = WRUser.ContactId;
                WPRUSER.AccountName = WRUser.Contact.Account.Name;
                WPRUSER.Name = WRUser.Contact.Account.Name;
                WPRUSER.Email = WRUser.Contact.Email;
                WPRUSER.ExportControlForm=true;
                WPRUSER.IpDeclarationForm=true;
                WPRUSER.Cdrs=true;
            DeviceExposeToCustomer.WrapperListUser wlist=new DeviceExposeToCustomer.WrapperListUser();
                wlist.AccountId = testAccount1.Id; 
                wlist.ListWrapperUsers.add(WPRUSER); 
                wlist.getListSize();            
            detc.mapAccountUsers.put(testAccount1.Id,wlist);            
            detc.exposeDevice();
            detc.cancel();
           //test.stopTest();
            
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
    
}