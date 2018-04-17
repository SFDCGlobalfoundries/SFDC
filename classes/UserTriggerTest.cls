@isTest(SeeAllData=false)
private class UserTriggerTest
{
     static Map<String, Id> profileMap = new Map<String, Id>();

     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables(); 
        RecordType recType = [select id from RecordType where Name='Customer' and SobjectType='Account' limit 1];
        Account acc = new Account(Name='Test Account1',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;  
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acc.Id;
        update env;      
     }
     
     static void getProfileMap()
     {
         if (profileMap.size() == 0)
         {
             List<Profile> profiles = [select ID, Name from Profile];
        
             for(Profile p : profiles)
             {
                 profileMap.put(p.Name, p.Id);
             }
         }
     }
     
     static Id createAccountAndContact(){
        /*RecordType recType = [select id from RecordType where Name='Customer' limit 1];
        Account acc = new Account(Name='Test Account1',RecordTypeId=recType.id,Site_Department__c='IT',Sub_Type__c='Indirect',
                                Transaction_Type__c='Non-Transactional',Region__c='US',Bill_To_Address_1__c='Test Address',
                                Bill_To_City__c='Test City',Bill_To_Country__c='India',Corporate_Address_1__c='Test Address',
                                Corporate_City__c='Test City',Corporate_Country__c='India', Account_Manager__c = userinfo.getuserid());
        
        insert acc;
        */
        Account acc = [Select Id, name from Account where Name = 'Test Account1' limit 1];
        Contact testContact = new Contact();
        testContact.accountid = acc.id;
        testContact.lastname = 'testln';
        testContact.firstname = 'testfn';
        testContact.email = 'blank@blank.com';
        testContact.Department__c = 'Design';
        insert testContact;              
        return testContact.Id;
    }
    
    static User createUser(Id contactId, string profileName)
    {
        Integer iCount = 1;
        getProfileMap();
        Id custPortalId;
        if(profileName == 'Customer Portal Profile')
            custPortalId = profileMap.get('Customer Portal Profile');
        if(profileName == 'Overage Customer Portal Profile')
            custPortalId = profileMap.get('Overage Customer Portal Profile');
        Id profileId = profileMap.get(profileName);
        
        User user = new User(Alias = 'ts'+iCount, Email= 'testing' + iCount + '@cy.com',
                 EmailEncodingKey='UTF-8', LastName='TestCY' + iCount, LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = profileId, communitynickname='ts' + iCount, Fab_Assigned__c='FAB 3',
                 FederationIdentifier='Test2014'+iCount, TimeZoneSidKey='America/Los_Angeles', UserName= 'testing' + iCount + '@cy.com');
                 
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c(First_Name__c='TestFirst' + iCount, Last_Name__c='TestCY' + iCount,
                 Employee_ID__c='Test2014'+iCount, Login_ID__c='testing' + iCount + '@cy.com', Email_Address__c='testing' + iCount + '@cy.com',
                 Status__c='Active');      
        
        if (profileId == custPortalId)
            user.ContactId = contactId;
                 
        
        insert testHCMEmployee;
        insert user;
        return user;
       
    }
    
    static List<User> createUsers(Id contactId, string profileName, Integer numberOfUsersToCreate)
    {
        getProfileMap();
        Id custPortalId = profileMap.get('Customer Portal Profile');
        Id profileId = profileMap.get(profileName);
        List<User> users = new List<User>();
        List<HCM_Employee__c> hcmEmployees = new List<HCM_Employee__c>();
        
        for(Integer i=0;i<numberOfUsersToCreate; i++) {
            User user = new User(Alias = 'ts'+i, Email= 'testing' + i + '@cy.com',
                 EmailEncodingKey='UTF-8', LastName='TestCY' + i, LanguageLocaleKey='en_US',
                 LocaleSidKey='en_US', ProfileId = profileId, communitynickname='ts' + i, Fab_Assigned__c='FAB 3',
                 FederationIdentifier='Test2014'+i, TimeZoneSidKey='America/Los_Angeles', UserName= 'testing' + i + '@cy.com');
                 
            HCM_Employee__c testHCMEmployee = new HCM_Employee__c(First_Name__c='TestFirst' + i, Last_Name__c='TestCY' + i,
                 Employee_ID__c='Test2014'+i, Login_ID__c='testing' + i + '@cy.com', Email_Address__c='testing' + i + '@cy.com',
                 Status__c='Active');      
        
            if (profileId == custPortalId)
                user.ContactId = contactId;
                 
            users.add(user);
            hcmEmployees.add(testHCMEmployee);
        }
        
        insert hcmEmployees;
        insert users;
        
        return users;
    }
    
    static testMethod void createSystemAdmin() {
        User u = createUser(null, 'System Administrator');  
        System.assertNotEquals(u.Id, null);  
    }
    
    static testMethod void createGFUser() {
        User u = createUser(null, 'GF CE');  
        System.assertNotEquals(u.Id, null);  
    }

    static testMethod void createOverageCustomerPortalUser() {
        Id contactId = createAccountAndContact();
        List<Contact_Portal_Tab_Access__c> lstContactPortalCustomSettingsObj = new List<Contact_Portal_Tab_Access__c>();
        lstContactPortalCustomSettingsObj.add(new Contact_Portal_Tab_Access__c(
                                                                    Name='Design',My_Devices__c=true,My_wafers__c=true,Product_Services__c=true,
                                                                    PDK_Design_Documents__c = true,IP_Declaration__c=true,BOM__c=true,
                                                                    Electrical_Test__c = true,Wafer_Inspection__c = true,Yield_Sort_ETest_Reporting__c = true,
                                                                    CPK__c = true,Tester_Gauge_R_R__c = true,Product_Wafer_Compliance_Analysis__c = true,
                                                                    PCRB__c = true,Export_Control__c = true,PTRF__c = true,Web_View__c = true,
                                                                    Global_Shuttle_reservation__c = true,Stepper_Tooling_Form__c = true,
                                                                    New_Part_Creation_after_Proto_form__c = true,
                                                                    Process_Request_Form_PRF__c = true,Risk_Waiver__c = true,RTR_RTP__c = true,
                                                                    Process_Reliability_Monitoring__c = true,Reticle_Obsolescence__c = true,
                                                                    Orders__c= true,Production__c= true,Shipping__c= true,Order_Query__c = true,
                                                                    Production_Query__c = true,Shipping_Query__c = true,Forecast_Fab_Cycle_Time__c = true,
                                                                    Wafer_Start__c = true,WIP_Status__c = true,Fab_Out_Schedule__c = true,
                                                                    Finish_Goods_Report__c = true,Lot_Control_table__c = true,Account_Statement__c = true,
                                                                    Backlog__c = true,Billing__c = true,Credit_and_Debit_Note__c = true,NRE_Invoice__c = true,
                                                                    Order_Acknowledgement__c = true,Purchase_Order_Tracking__c = true,Tax_Invoice__c = true,
                                                                    ROM_Blanket__c = true,Certificate_of_Compliance__c = true,Custom_Shipment_Report__c = true,
                                                                    On_Time_Delivery__c = true,Shipment_Alert_Report__c = true,Shipment_Detail_Unsort_and_Sort__c = true,
                                                                    Ship_Alert_by_Location__c = true,Packaging_List_Report__c = true,Configurator__c = true,
                                                                    Design_Enablement__c = true,Process_Technology__c = true,Process_ID__c = true,IP__c = true,
                                                                    X3rd_Party_IP__c = true,Price_List__c = true,MPW__c = true,Turnkey__c = true,Services__c = true,
                                                                    Design_Specification_Packages__c = true,Design_Technology_Documents__c = true,
                                                                    IP_PLM__c= true,Construction_Analysis_report__c=true,Change_request_report__c=true,
                                                                    WLR_Monitoring_report__c=true,Engineering_Lot_status_report__c=true,ET_and_Inline_CPK_report__c=true,Wafer_Scrap__c=true,
                                                                    Scrap_Reports__c =true,Lot_History__c =true,Fab_WIP__c =true,Custom_Order_Report__c =true,Custom_Mfg_Report__c=true,
                                                                    Procedure__c=True)); 
    
        
        insert lstContactPortalCustomSettingsObj;        
        Test.startTest();
        User u = createUser(contactId, 'Overage Customer Portal Profile');  
        //User_TriggerHelper.insertASN(new list<string>{u.Id});  
        //User_TriggerHelper.insertPTAFuture(new Set<Id>{u.Id});  
        map<Id,string> m = new map<Id,string>();
        m.put(contactId,u.Id);   
        //User_TriggerHelper.updateContactPortalLogin(new set<Id>{contactId},m);      
        Test.stopTest();
        System.assertNotEquals(u.Id, null);  
    }
    
    static testMethod void createCustomerPortalUser() {
        Id contactId = createAccountAndContact();
        List<Contact_Portal_Tab_Access__c> lstContactPortalCustomSettingsObj = new List<Contact_Portal_Tab_Access__c>();
        lstContactPortalCustomSettingsObj.add(new Contact_Portal_Tab_Access__c(
                                                                    Name='Design',My_Devices__c=true,My_wafers__c=true,Product_Services__c=true,
                                                                    PDK_Design_Documents__c = true,IP_Declaration__c=true,BOM__c=true,
                                                                    Electrical_Test__c = true,Wafer_Inspection__c = true,Yield_Sort_ETest_Reporting__c = true,
                                                                    CPK__c = true,Tester_Gauge_R_R__c = true,Product_Wafer_Compliance_Analysis__c = true,
                                                                    PCRB__c = true,Export_Control__c = true,PTRF__c = true,Web_View__c = true,
                                                                    Global_Shuttle_reservation__c = true,Stepper_Tooling_Form__c = true,
                                                                    New_Part_Creation_after_Proto_form__c = true,
                                                                    Process_Request_Form_PRF__c = true,Risk_Waiver__c = true,RTR_RTP__c = true,
                                                                    Process_Reliability_Monitoring__c = true,Reticle_Obsolescence__c = true,
                                                                    Orders__c= true,Production__c= true,Shipping__c= true,Order_Query__c = true,
                                                                    Production_Query__c = true,Shipping_Query__c = true,Forecast_Fab_Cycle_Time__c = true,
                                                                    Wafer_Start__c = true,WIP_Status__c = true,Fab_Out_Schedule__c = true,
                                                                    Finish_Goods_Report__c = true,Lot_Control_table__c = true,Account_Statement__c = true,
                                                                    Backlog__c = true,Billing__c = true,Credit_and_Debit_Note__c = true,NRE_Invoice__c = true,
                                                                    Order_Acknowledgement__c = true,Purchase_Order_Tracking__c = true,Tax_Invoice__c = true,
                                                                    ROM_Blanket__c = true,Certificate_of_Compliance__c = true,Custom_Shipment_Report__c = true,
                                                                    On_Time_Delivery__c = true,Shipment_Alert_Report__c = true,Shipment_Detail_Unsort_and_Sort__c = true,
                                                                    Ship_Alert_by_Location__c = true,Packaging_List_Report__c = true,Configurator__c = true,
                                                                    Design_Enablement__c = true,Process_Technology__c = true,Process_ID__c = true,IP__c = true,
                                                                    X3rd_Party_IP__c = true,Price_List__c = true,MPW__c = true,Turnkey__c = true,Services__c = true,
                                                                    Design_Specification_Packages__c = true,Design_Technology_Documents__c = true,
                                                                    IP_PLM__c= true,Construction_Analysis_report__c=true,Change_request_report__c=true,
                                                                    WLR_Monitoring_report__c=true,Engineering_Lot_status_report__c=true,ET_and_Inline_CPK_report__c=true,Wafer_Scrap__c=true,
                                                                    Scrap_Reports__c =true,Lot_History__c =true,Fab_WIP__c =true,Custom_Order_Report__c =true,Custom_Mfg_Report__c=true,
                                                                    Procedure__c=True)); 
    
        
        insert lstContactPortalCustomSettingsObj;        
        Test.startTest();
        User u = createUser(contactId, 'Customer Portal Profile');  
        //User_TriggerHelper.insertASN(new list<string>{u.Id});
        
        Test.stopTest();
        System.assertNotEquals(u.Id, null);  
    }

    static testMethod void updateFabAssignments() {
        User u = createUser(null, 'GF CE');  
        System.assertNotEquals(u.Id, null);
        
        Test.startTest();
        
        u.Fab_Assigned__c = 'FAB 1';
        update u;
        
        u = [SELECT ID, Fab_Assigned__c, Fab_Assignment_Change__c FROM USER WHERE ID =: u.Id];
        System.assertEquals(u.Fab_Assigned__c, 'FAB 1');
        System.assertEquals(u.Fab_Assignment_Change__c, true);
        
        //Update Fab Again
        u.Fab_Assigned__c = 'FAB 2';
        update u;
        
        u = [SELECT ID, Fab_Assigned__c, Fab_Deleted__c FROM USER WHERE ID =: u.Id];
        System.assertEquals(u.Fab_Assigned__c, 'FAB 2');
        System.assertEquals(u.Fab_Deleted__c, 'FAB 3;FAB 1');
        
        Test.stopTest();    
    }
    
    static testMethod void updateManagers() {
        List<User> users = createUsers(null, 'GF CE', 2);  
        System.assertEquals(users.size(), 2);
        
        // Update HCM Supervisor ID
        HCM_Employee__c testHCMEmployee = [SELECT ID, Supervisor_ID__c FROM HCM_Employee__c WHERE Login_ID__c='testing0@cy.com'];
        testHCMEmployee.Supervisor_ID__c = 'Test20141';
        update testHCMEmployee;
        User u = [SELECT ID FROM USER WHERE FederationIdentifier = 'Test20140'];
        User manager = [SELECT ID FROM USER WHERE FederationIdentifier = 'Test20141'];
        
        Test.startTest();
        
        Map<Id,Id> userManagerMap = new Map<Id,Id>();
        userManagerMap.put(u.Id, manager.Id);
        ManagerUpdater.process(userManagerMap);
        
        Test.stopTest();
        
        u = [SELECT ID, ManagerID FROM USER WHERE FederationIdentifier = 'Test20140'];
        System.assertNotEquals(u.ManagerId, null);
        
    }
}