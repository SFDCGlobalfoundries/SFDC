/**
    Author: Cognizant
    Description: Apex test class for Test data class
    History: 
    Cognizant      10/05/2014    - Apex code created
            
**/
@istest(SeeAllData = false)
public without sharing class SwiftDataUtilityTest {

    @testSetup 
    static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        /*
        This Swift code should not reference an org's util class due to many severe communication issues 
        so far which in the end, Swift's codes are broken without anyone notices and it causes delay our Swift schedule. 
        */
        //AccountDataFactory.createAccount(fieldValueMap); <<< org's utils class
        createAccount(getFieldValueMap());
    }
    
    private static Map<String, Object> getFieldValueMap() {
        Map < String, Object > fieldValueMap = new Map < String, Object > ();
        fieldValueMap.put('Name', 'Test Account 009');
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c', 'Test City');
        fieldValueMap.put('Bill_To_Country__c', 'India');     
        return fieldValueMap;  
    }

    public static Mask_Set_Title__c createMST(String mstName) { //Create MST, but not insert into DB
            return new Mask_Set_Title__c(Name = mstName,
                Description__c = 'Test Description for MST',
                Synced_with_Oracle_DB__c = false,
                Status__c = 'Active',
                Is_Available_For_Use__c = true,
                Manual_Creation__c = false,
                Reticle_Type__c = 'Single Layer Reticle (SLR)'
            );
        }
        //Loading custom setting data
    public static testMethod void customSystemData() {
        //List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'SWIFTTestEnvironmentVariablesData');
        DataUtilTest.loadEnvironmentVariables();

        //List<SObject> lstErrorCodes = Test.loadData(Error_Codes__c.sObjectType,'SWIFTTestErrorCodesData');
        //List<SObject> lsEnvVar = Test.loadData(Error_Codes__c.sObjectType,'SWIFTTestEnvironmentVariablesData');
        List < SObject > lstSwiftUserGroup = Test.loadData(SWIFT_User_Group__c.sObjectType, 'SWIFTUserGroupData');
        List < SObject > lstSwift_MRS_Fields_Permission_Config_Data = Test.loadData(MRS_Fields_Permission_Config__c.sObjectType, 'Swift_MRS_Fields_Permission_Config_Data');


        MRS_Fields_Permission_Config__c MRSFPC = new MRS_Fields_Permission_Config__c();
        MRSFPC.CustomerRemoteJobviewFrame__c = true;
        MRSFPC.CustomerRemoteJobviewPrime__c = true;
        MRSFPC.DRW__c = true;
        MRSFPC.FoundryRemoteJobviewFrame__c = true;
        MRSFPC.FoundryRemoteJobviewPrime__c = true;
        MRSFPC.FrameMockupCustomer__c = true;
        MRSFPC.FrameMockupFoundry__c = true;
        MRSFPC.GDSOUTReviewCustomer__c = true;
        MRSFPC.GDSOUTReviewFoundry__c = true;
        MRSFPC.MEBESJobviewCustomer__c = true;
        MRSFPC.MEBESJobviewFoundry__c = true;
        MRSFPC.MEBESJobviewGlobalShuttle__c = true;
        MRSFPC.MEBESJobviewMDP__c = true;
        MRSFPC.MEBESJobviewTapeoutAPPLICATIONS__c = true;
        MRSFPC.MEBESJobviewTapeoutCenter__c = true;
        MRSFPC.MEBESJobviewTDTIMPW__c = true;
        MRSFPC.MEBESReceivedFrame__c = true;
        MRSFPC.MEBESReceivedPrime__c = true;
        MRSFPC.Name = 'SWIFT_FE';
        MRSFPC.ORC__c = true;
        MRSFPC.SendDataFrame__c = true;
        MRSFPC.SendDataPrime__c = true;
        insert MRSFPC;
        
        Error_Codes__c e = new Error_Codes__c();
        e.name = 'UNIQUE_COMBINATION_ERROR_SHIPPED_LAYER';
        e.Message__c = 'Note: Retrofit Mask Layer <LAYER_UNIQUE> had already been shipped. No changes are allowed on Shipped layer(s).';
        insert e;
    }

    //Method to create system admin user
    public static User createSysAdminUser() {

        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
        User u = new User(alias = 'ts', email = 'testaccs@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast', firstname = 'TestFirst', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss@test.com', communitynickname = 'tss', FederationIdentifier = 'Test');

        return u;

    }

    //Method to create portal user
    public static List < User > createPortalUser(List < Contact > con) {



        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType = : 'CustomerPortal'
            limit 1
        ];
        // retrieve portal profile
        Set < String > customerUserTypes = new Set < String > {
            'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess', 'CustomerSuccess'
        };
        Profile profileObj = [select Id, name from Profile where Name = 'Customer Portal Admin'];
        //Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin'];
        User newUser = new User();
        List < User > portalUserList = new List < User > ();

        for (integer iCount = 0; iCount < con.size(); iCount++) {
            newUser = new User(
                profileId = profileObj.id,
                UserRoleId = ur.Id,
                username = 'newUser' + String.valueOf(iCount) + '@yahoo.com',
                email = 'pb' + String.valueOf(iCount) + '@ff.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias = 'nuser' + String.valueOf(iCount),
                lastname = 'lastname' + String.valueOf(iCount),
                Portal_Login__c = 'xyz',
                contactId = con[iCount].id,
                IsActive = true
            );
            portalUserList.add(newUser);

        }
        insert portalUserList;

        Set < Id > portalUserIds = new Set < Id > ();
        for (user u: portalUserList) {
            portalUserIds.add(u.Id);
        }
        List < User > portalUserListSelected = [select id, username, email from user where id in : portalUserIds];
        system.assertEquals(con.size(), portalUserListSelected.size());

        return portalUserList;
    }

    //Method to create HCM Employee
    public static List < HCM_Employee__c > createHCMEmployee(integer iNumberofUsers) {

        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();
        List < HCM_Employee__c > testHCMEmpList = new List < HCM_Employee__c > ();

        for (integer iCount = 0; iCount < iNumberofUsers; iCount++) {
            testHCMEmployee = new HCM_Employee__c();
            testHCMEmployee.First_Name__c = 'Employee FN' + String.valueof(iCount);
            testHCMEmployee.Last_Name__c = 'Employee LN' + String.valueof(iCount);
            testHCMEmployee.Employee_ID__c = 'test' + String.valueof(iCount);
            testHCMEmployee.Login_ID__c = 'test' + String.valueof(iCount) + '.hcmemployee@gf.com';
            testHCMEmployee.Email_Address__c = 'test' + String.valueof(iCount) + '.hcmemployee@gf.com';
            testHCMEmployee.Status__c = 'Active';
            testHCMEmpList.add(testHCMEmployee);
        }
        System.debug('%%%%%%%%%%%%%%%%%%%' + testHCMEmpList);
        /**
        testHCMEmpList.add(testHCMEmployee2);
        testHCMEmpList.add(testHCMEmployee3);
        testHCMEmpList.add(testHCMEmployee4);
        testHCMEmpList.add(testHCMEmployee5);**/
        insert testHCMEmpList;

        Set < ID > hcmEmployeeIDs = new Set < Id > ();
        for (HCM_Employee__c hcm: testHCMEmpList) {
            hcmEmployeeIDs.add(hcm.Id);
        }
        List < HCM_Employee__c > HCMEmpList = [select id, Email_Address__c from HCM_Employee__c where id in : hcmEmployeeIDs];
        system.assertEquals(iNumberofUsers, HCMEmpList.size());
        return testHCMEmpList;
    }

    //Method to create Non system admin user
    public static List < User > createTestUser(List < HCM_Employee__c > testHCMEmpList) {

        List < User > users = new List < User > ();
        Profile standardUserProfile = [SELECT Id FROM Profile WHERE Name = 'GF FAE/FTS'];
        UserRole usrRole = [SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
        User u = new User(alias = 'ts', email = 'testaccs@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast', firstname = 'TestFirst', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss@test.com', communitynickname = 'tss', FederationIdentifier = testHCMEmpList[0].Employee_ID__c);


        User u1 = new User(alias = 'ts1', email = 'testaccss@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast1', firstname = 'TestFirst1', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss22@test.com', communitynickname = 'tsss', FederationIdentifier = testHCMEmpList[1].Employee_ID__c);

        User u2 = new User(alias = 'ts2', email = 'testaccss2@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast2', firstname = 'TestFirst2', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss23@test.com', communitynickname = 'tsss2', FederationIdentifier = testHCMEmpList[2].Employee_ID__c);

        User u3 = new User(alias = 'ts3', email = 'testaccss3@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast3', firstname = 'TestFirst3', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss24@test.com', communitynickname = 'tsss3', FederationIdentifier = testHCMEmpList[3].Employee_ID__c);


        User u4 = new User(alias = 'ts4', email = 'testaccss4@test.com',
            emailencodingkey = 'UTF-8', lastname = 'TestLast4', firstname = 'TestFirst4', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = standardUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey = 'America/Los_Angeles', username = 'testaccss25@test.com', communitynickname = 'tsss4', FederationIdentifier = testHCMEmpList[4].Employee_ID__c);

        users.add(u);
        users.add(u1);
        users.add(u2);
        users.add(u3);
        users.add(u4);
        insert users;

        Set < Id > userIds = new Set < Id > ();
        for (user usr: users) {
            userIds.add(usr.Id);
        }

        List < User > userList = [select id, name from user where id in : userIds];
        system.assertEquals(users.size(), userList.size());

        return users;

    }

    //Method to create test account data
    public static Account createTestAccount() {

        Account acc = getAccount('Test Account 009');
        return acc;
    }



    public static Account createTestAccountForDRT() {
        recordtype rt = [select id from recordtype where sobjecttype = 'Account'
            and developername = 'GLOBALFOUNDRIES_Internal'
        ];
        system.debug(LoggingLevel.ERROR, 'Record Type id=' + rt.Id);
        Account acc = getAccount('Test Account 009');
        return acc;
    }

    //Method to create test contact data
    public static List < Contact > createTestContact(Account acc, integer iNumberOfContact) {
        Contact con = new Contact();
        List < Contact > newContactList = new List < Contact > ();

        for (Integer iCount = 0; iCount < iNumberOfContact; iCount++) {
            con = new Contact(
                firstName = 'test' + String.valueOf(iCount),
                lastName = 'test' + String.valueOf(iCount),
                Email = 'con' + String.valueOf(iCount) + '@gf.com',
                Department__c = 'Design;Procurement',
                accountId = acc.id
            );
            newContactList.add(con);

        }
        insert newContactList;

        Set < Id > contactIds = new Set < Id > ();
        for (Contact conn: newContactList) {
            contactIds.add(conn.Id);
        }

        List < Contact > contactList = [select id, name from contact where id in : contactIds];
        system.assertEquals(iNumberOfContact, contactList.size());
        return newContactList;
    }

    //Method to create test account team proxy data
    public static Account_Team_Proxy__c createTestAccountTeamProxy(User usr, Account acc, String sRole, String sSequenceNo) {

        Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
            User__c = usr.id,
            Account__c = acc.id,
            Account_Access__c = 'Read/Write',
            Opportunity_Access__c = 'Read/Write',
            Team_Role__c = sRole,
            Sequence_No__c = sSequenceNo,
            Account_Role_ID__c = 'test'

        );
        return atp;
    }

    //Method to update test account data to authorized
    public static Account updateTestAccount(Account acc) {
        acc.stage__c = 'Authorized';

        acc.Customer_Number__c = '111';
        update acc;

        Account acct = [select id, stage__c, Customer_Number__c from Account where id = : acc.id];
        system.assertEquals('Authorized', acct.stage__c);
        system.assertEquals('111', acct.Customer_Number__c);
        return acc;
    }

    //Method to create test Mask Set Title data
    public static List < Mask_Set_Title__c > maskSetTitleList(integer iNumberOfMST) {
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        List < Mask_Set_Title__c > mstList = new List < Mask_Set_Title__c > ();
        for (Integer iCount = 0; iCount < iNumberOfMST; iCount++) {
            mst = new Mask_Set_Title__c(Name = 'MYMST0' + String.valueOf(iCount),
                Description__c = 'Test Description for MST',
                Status__c = 'Active',
                Is_Available_For_Use__c = true,
                Reticle_Type__c = 'Single Layer Reticle (SLR)');
            mstList.add(mst);
        }
        insert mstList;

        Set < Id > mstIds = new Set < Id > ();
        for (Mask_Set_Title__c mst1: mstList) {
            mstIds.add(mst1.Id);
        }

        List < Mask_Set_Title__c > mstListSelected = [select id, name, status__c from Mask_Set_Title__c where id in : mstIds];
        system.assertEquals(iNumberOfMST, mstListSelected.size());
        return mstList;

    }
    public static List < Mask_Set_Title__c > maskSetTitleListForPTRFHandler(integer iNumberOfMST) {
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        List < Mask_Set_Title__c > mstList = new List < Mask_Set_Title__c > ();
        for (Integer iCount = 0; iCount < iNumberOfMST; iCount++) {
            mst = new Mask_Set_Title__c(Name = 'MYMST0' + String.valueOf(iCount),
                Description__c = 'Test Description for MST',
                Status__c = 'Active',
                Is_Available_For_Use__c = false,
                Reticle_Type__c = 'Single Layer Reticle (SLR)');
            mstList.add(mst);
        }
        insert mstList;
        Set < Id > mstIds = new Set < Id > ();
        for (Mask_Set_Title__c mst1: mstList) {
            mstIds.add(mst1.Id);
        }

        List < Mask_Set_Title__c > mstListSelected = [select id, name, status__c from Mask_Set_Title__c where id in : mstIds];
        system.assertEquals(iNumberOfMST, mstListSelected.size());
        return mstList;

    }
    public static List < Mask_Set_Title__c > maskSetTitleList2(integer iNumberOfMST) {
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        List < Mask_Set_Title__c > mstList = new List < Mask_Set_Title__c > ();
        for (Integer iCount = 0; iCount < iNumberOfMST; iCount++) {
            mst = new Mask_Set_Title__c(Name = 'MPWMST' + String.valueOf(iCount),
                Description__c = 'Test Description for MST',
                Status__c = 'Active',
                Is_Available_For_Use__c = true,
                Manual_Creation__c = false,
                Reticle_Type__c = 'Single Layer Reticle (SLR)');
            mstList.add(mst);
        }
        insert mstList;
        Set < Id > mstIds = new Set < Id > ();
        for (Mask_Set_Title__c mst1: mstList) {
            mstIds.add(mst1.Id);
        }

        List < Mask_Set_Title__c > mstListSelected = [select id, name, status__c from Mask_Set_Title__c where id in : mstIds];
        system.assertEquals(iNumberOfMST, mstListSelected.size());
        return mstList;

    }

    public static List < DRT__c > createDRTList(Integer iNumberofDRT, Mask_Set_Title__c mst) {
        DRT__c drt = new DRT__c();
        List < DRT__c > drtList = new List < DRT__c > ();
        for (Integer iCount = 0; iCount < iNumberofDRT; iCount++) {
            drt = new DRT__C(Name = mst.Name + '-' + String.valueOf(iNumberofDRT),
                Status__c = 'Active',
                Type__c = 'PRIME',
                Mask_Set_Title__c = mst.id);
            drtList.add(drt);
        }
        insert drtList;
        Set < Id > drtIds = new Set < Id > ();
        for (DRT__c drt1: drtList) {
            drtIds.add(drt1.Id);
        }

        List < DRT__c > drtListSelected = [select id, name, status__c from DRT__c where id in : drtIds];
        system.assertEquals(iNumberofDRT, drtListSelected.size());
        return drtList;

    }
    public static List < DRT__c > createDRTList1(Integer iNumberofDRT, Mask_Set_Title__c mst, Id Accid) {
        DRT__c drt = new DRT__c();
        List < DRT__c > drtList = new List < DRT__c > ();
        for (Integer iCount = 0; iCount < iNumberofDRT; iCount++) {
            drt = new DRT__C(Name = 'MYMST_PRIME_DRT_001.001', Customer_Name__c = Accid,
                Status__c = 'Draft',
                Type__c = 'PRIME',
                Tech_Geo__c = '0.02UM',
                Mask_Set_Title__c = mst.id);
            drtList.add(drt);
        }
        insert drtList;

        Set < Id > drtIds = new Set < Id > ();
        for (DRT__c drt1: drtList) {
            drtIds.add(drt1.Id);
        }

        List < DRT__c > drtListSelected = [select id, name, status__c from DRT__c where id in : drtIds];
        system.assertEquals(iNumberofDRT, drtListSelected.size());

        return drtList;

    }
    public static List < DRT__c > createDRTList2(Integer iNumberofDRT, Mask_Set_Title__c mst, Id Accid) {
        DRT__c drt = new DRT__c();
        List < DRT__c > drtList = new List < DRT__c > ();
        for (Integer iCount = 0; iCount < iNumberofDRT; iCount++) {
            drt = new DRT__C(Name = 'MYMST_PRIME_DRT_035.001', Customer_Name__c = Accid,
                Status__c = 'Active',
                Type__c = 'PRIME',
                Mask_Set_Title__c = mst.id);
            drtList.add(drt);
        }
        insert drtList;

        Set < Id > drtIds = new Set < Id > ();
        for (DRT__c drt1: drtList) {
            drtIds.add(drt1.Id);
        }

        List < DRT__c > drtListSelected = [select id, name, status__c from DRT__c where id in : drtIds];
        system.assertEquals(iNumberofDRT, drtListSelected.size());

        return drtList;

    }

    public static List < DRT__c > createDRTListForFrame(Integer iNumberofDRT, Mask_Set_Title__c mst, Id Accid) {
        DRT__c drt = new DRT__c();
        List < DRT__c > drtList = new List < DRT__c > ();
        for (Integer iCount = 0; iCount < iNumberofDRT; iCount++) {
            drt = new DRT__C(Name = 'MYMST_PRIME_DRT_035.001', Customer_Name__c = Accid,
                Status__c = 'Draft',
                Type__c = 'FRAME',
                Mask_Set_Title__c = mst.id);
            drtList.add(drt);
        }
        insert drtList;

        Set < Id > drtIds = new Set < Id > ();
        for (DRT__c drt1: drtList) {
            drtIds.add(drt1.Id);
        }

        List < DRT__c > drtListSelected = [select id, name, status__c from DRT__c where id in : drtIds];
        system.assertEquals(iNumberofDRT, drtListSelected.size());

        return drtList;

    }
    public static List < DRT__c > createDRTCancelList(Integer iNumberofDRT, Mask_Set_Title__c mst) {
        DRT__c drt1 = new DRT__c();
        List < DRT__c > drtList1 = new List < DRT__c > ();
        for (Integer iCount = 0; iCount < iNumberofDRT; iCount++) {
            drt1 = new DRT__C(Name = mst.Name + '-' + String.valueOf(iNumberofDRT),
                Status__c = 'Cancel',
                Type__c = 'PRIME',
                Mask_Set_Title__c = mst.id);
            drtList1.add(drt1);
        }
        insert drtList1;

        Set < Id > drtIds = new Set < Id > ();
        for (DRT__c drt: drtList1) {
            drtIds.add(drt.Id);
        }

        List < DRT__c > drtListSelected = [select id, name, status__c from DRT__c where id in : drtIds];
        system.assertEquals(iNumberofDRT, drtListSelected.size());

        return drtList1;

    }

    /******code section added *****************/
    private static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';

        insert testOppty;

        Opportunity Oppty = [select id, name, AccountId from Opportunity where id = : testOppty.Id];
        system.assertEquals('Test Opportunity', Oppty.name);
        system.assertEquals(testAcctId, Oppty.AccountId);
        return testOppty.Id;
    }

    private static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = [Select Name from Opportunity where Id = : testOpptyId].Name;
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;

        insert testOpptyProgram;

        Opportunity_Program__c OpptyProgram = [select id, Name, Account__c, Opportunity__c from Opportunity_Program__c where id = : testOpptyProgram.Id];
        system.assertEquals(testAcctId, OpptyProgram.Account__c);
        system.assertEquals(testOpptyId, OpptyProgram.Opportunity__c);

        return testOpptyProgram.Id;
    }

    private static Device__c createDevice(Id oppProgramId, String stage, String crmDID, String gfDeviceID) {

        // Create Device
        Device__c device = new Device__c();

        device.Name = 'TESTDEVICE1234';
        device.Opportunity_Program__c = oppProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = stage;
        device.Status__c = 'Active';
        device.Tapeout_Type__c = 'Single Product';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.Device_Id__c = gfDeviceID;
        device.CRMDID__c = crmDID;
        device.Device_Mask_Set_Title__c = 'MST0011';
        device.PTRF_ID__c = 'ptrf1234';
        device.Actual_Tapeout_Date_GMT__c = Date.today().addDays(5);
        device.Confidence_Level_Tapeout__c = '100';
        device.End_Application__c = 'Media';

        insert device;
        return device;
    }


    private static list < Chip_Detail__c > createChipDetail(PTRF__c ptrf) {
        list < Chip_Detail__c > chipDetailList = new list < Chip_Detail__c > ();
        Chip_Detail__c chipDetail = new Chip_Detail__c();
        chipDetail.PTRF__c = ptrf.Id;
        chipDetail.Name = 'asdf';
        chipDetailList.add(chipDetail);
        Chip_Detail__c chipDetail2 = new Chip_Detail__c();
        chipDetail2.PTRF__c = ptrf.Id;
        chipDetail2.Name = 'asdf2';
        chipDetailList.add(chipDetail2);
        Chip_Detail__c chipDetail3 = new Chip_Detail__c();
        chipDetail3.PTRF__c = ptrf.Id;
        chipDetail3.Name = 'Frame';
        chipDetailList.add(chipDetail3);
        insert chipDetailList;
        return chipDetailList;
    }

    private static Mask_Layer__c createMaskLayer(PTRF__c ptrf) {

        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Name = 'AZ';
        maskLayer.Sort_Order__c = 1;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = '001';
        maskLayer.Mask_Layer_Rev__c = 'AZ';
        maskLayer.LogicalOperation__c = 'Foundry Std';
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
        insert maskLayer;
        return maskLayer;
    }

    private static PTRF__c createPTRF(String status, String custdeviceID,
        Integer totalPrimeDice, Device__c actualDeviceID,
        Boolean isPrimeTapeOut, Boolean isFrameTapeout) {

        PTRF__c ptrf = new PTRF__c();
        //ptrf.Transaction_Type__c = 'LIFECYCLE';
        ptrf.Status__c = status;
        ptrf.Mask_Set_Title__c = 'Test Mask Set title';
        ptrf.Device_Id__c = custdeviceID;
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c = '';
        ptrf.Prime_Tapeout__c = isPrimeTapeOut;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c = '';
        ptrf.Name = 'PTRF-000-1535';
        ptrf.Order_Type__c = 'Retrofit';
        //ptrf.Order_Date__c = Date.today().addDays(10);
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = false;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = '';
        ptrf.Frame_Tapeout__c = isFrameTapeout;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = false;
        ptrf.Device__c = actualDeviceID.Id;
        insert ptrf;
        return ptrf;
    }


    public static List < PRIME_DRT_Layer_Association__c > createPDLA(String drtId) {
        PRIME_DRT_Layer_Association__c pdla1 = new PRIME_DRT_Layer_Association__c(DRT__c = drtId, Name = '70', Retrofit_Mask_Rev__c = 'TT',
            Retrofit_ROM_Code__c = 'TT235', Retrofit_Tech_Geo__c = '0.02UM');

        PRIME_DRT_Layer_Association__c pdla2 = new PRIME_DRT_Layer_Association__c(DRT__c = drtId, Name = '80', Retrofit_Mask_Rev__c = 'TT',
            Retrofit_ROM_Code__c = 'TT235', Retrofit_Tech_Geo__c = '0.02UM');

        PRIME_DRT_Layer_Association__c pdla3 = new PRIME_DRT_Layer_Association__c(DRT__c = drtId, Name = '90', Retrofit_Mask_Rev__c = 'TT',
            Retrofit_ROM_Code__c = 'TT235', Retrofit_Tech_Geo__c = '0.02UM', Last_Sync_Request_Timestamp__c = null);

        List < PRIME_DRT_Layer_Association__c > lstPDLA = new List < PRIME_DRT_Layer_Association__c > ();
        lstPDLA.add(pdla1);
        lstPDLA.add(pdla2);
        lstPDLA.add(pdla3);
        insert lstPDLA;

        Set < Id > PDLAIds = new Set < Id > ();
        for (PRIME_DRT_Layer_Association__c pdla: lstPDLA) {
            PDLAIds.add(pdla.Id);
        }

        List < PRIME_DRT_Layer_Association__c > pdlaListSelected = [select id from PRIME_DRT_Layer_Association__c where id in : PDLAIds];
        system.assertEquals(3, pdlaListSelected.size());

        return lstPDLA;
    }
    public static List < PRIME_DRT_Layer_Association__c > createPDLA1(String drtId) {
        PRIME_DRT_Layer_Association__c pdla = new PRIME_DRT_Layer_Association__c(DRT__c = drtId, Retrofit_Mask_Rev__c = 'TT',
            Retrofit_ROM_Code__c = 'TT235', Retrofit_Tech_Geo__c = '0.02UM');


        List < PRIME_DRT_Layer_Association__c > Lst_pdla = new List < PRIME_DRT_Layer_Association__c > ();

        Lst_pdla.add(pdla);

        insert Lst_pdla;

        Set < Id > PDLAIds = new Set < Id > ();
        for (PRIME_DRT_Layer_Association__c pdla1: Lst_pdla) {
            PDLAIds.add(pdla1.Id);
        }

        List < PRIME_DRT_Layer_Association__c > pdlaListSelected = [select id from PRIME_DRT_Layer_Association__c where id in : PDLAIds];
        system.assertEquals(1, pdlaListSelected.size());

        return Lst_pdla;
    }

    public static List < PRIME_DRT_Chip_Association__c > createPDCA(String drtId, String mstId) {
        PRIME_DRT_Chip_Association__c pdca = new PRIME_DRT_Chip_Association__c(DRT__c = drtId, name = 'test1',
            Mask_Set_Title__c = mstId);

        PRIME_DRT_Chip_Association__c pdca1 = new PRIME_DRT_Chip_Association__c(DRT__c = drtId, name = 'test2',
            Mask_Set_Title__c = mstId);

        List < PRIME_DRT_Chip_Association__c > Lst_pdca = new List < PRIME_DRT_Chip_Association__c > ();
        Lst_pdca.add(pdca1);
        Lst_pdca.add(pdca);

        insert Lst_pdca;

        Set < Id > PDCAds = new Set < Id > ();
        for (PRIME_DRT_Chip_Association__c pdca01: Lst_pdca) {
            PDCAds.add(pdca01.Id);
        }

        List < PRIME_DRT_Chip_Association__c > pdcaListSelected = [select id from PRIME_DRT_Chip_Association__c where id in : PDCAds];
        system.assertEquals(2, pdcaListSelected.size());

        return Lst_pdca;
    }
    public static List < PRIME_DRT_Chip_Association__c > createPDCA1(String drtId, String mstId) {
        PRIME_DRT_Chip_Association__c pdca = new PRIME_DRT_Chip_Association__c(DRT__c = drtId, name = 'test',
            Mask_Set_Title__c = mstId);



        List < PRIME_DRT_Chip_Association__c > Lst_pdca = new List < PRIME_DRT_Chip_Association__c > ();

        Lst_pdca.add(pdca);

        insert Lst_pdca;

        Set < Id > PDCAds = new Set < Id > ();
        for (PRIME_DRT_Chip_Association__c pdca1: Lst_pdca) {
            PDCAds.add(pdca1.Id);
        }

        List < PRIME_DRT_Chip_Association__c > pdcaListSelected = [select id from PRIME_DRT_Chip_Association__c where id in : PDCAds];
        system.assertEquals(1, pdcaListSelected.size());

        return Lst_pdca;
    }

    public static List < PRIME_DRT_Chip_Layer_Summary__c > createPDCLS(List < PRIME_DRT_Layer_Association__c > pdlaList, List < PRIME_DRT_Chip_Association__c > pdcaList) {

        PRIME_DRT_Chip_Layer_Summary__c pdcla = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[0].id, Layer__c = pdlaList[0].id,
            Mask_Layer_Rev__c = 'TT', ROM_Code__c = 'TT34',
            IsActive__c = true, Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');

        PRIME_DRT_Chip_Layer_Summary__c pdcla1 = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[1].id, Layer__c = pdlaList[1].id,
            Mask_Layer_Rev__c = 'RR', ROM_Code__c = 'RR456', IsActive__c = true,
            Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');

        List < PRIME_DRT_Chip_Layer_Summary__c > Lst_pdcla = new List < PRIME_DRT_Chip_Layer_Summary__c > ();
        Lst_pdcla.add(pdcla);
        Lst_pdcla.add(pdcla1);

        insert Lst_pdcla;

        Set < Id > PDCLAds = new Set < Id > ();
        for (PRIME_DRT_Chip_Layer_Summary__c pdcla01: Lst_pdcla) {
            PDCLAds.add(pdcla01.Id);
        }

        List < PRIME_DRT_Chip_Layer_Summary__c > pdclaListSelected = [select id from PRIME_DRT_Chip_Layer_Summary__c where id in : PDCLAds];
        system.assertEquals(2, pdclaListSelected.size());

        return Lst_pdcla;
    }

    public static List < PRIME_DRT_Chip_Layer_Summary__c > createPDCLS2(List < PRIME_DRT_Layer_Association__c > pdlaList, List < PRIME_DRT_Chip_Association__c > pdcaList) {

        PRIME_DRT_Chip_Layer_Summary__c pdcla00 = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[0].id, Layer__c = pdlaList[0].id,
            Mask_Layer_Rev__c = 'TT', ROM_Code__c = 'TT34',
            IsActive__c = true, Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');

        PRIME_DRT_Chip_Layer_Summary__c pdcla01 = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[0].id, Layer__c = pdlaList[1].id,
            Mask_Layer_Rev__c = 'TA', ROM_Code__c = 'TT36',
            IsActive__c = true, Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');
        PRIME_DRT_Chip_Layer_Summary__c pdcla10 = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[1].id, Layer__c = pdlaList[0].id,
            Mask_Layer_Rev__c = 'SS', ROM_Code__c = 'TT34',
            IsActive__c = true, Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');

        PRIME_DRT_Chip_Layer_Summary__c pdcla11 = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[1].id, Layer__c = pdlaList[1].id,
            Mask_Layer_Rev__c = 'RR', ROM_Code__c = 'RR456', IsActive__c = true,
            Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');

        List < PRIME_DRT_Chip_Layer_Summary__c > Lst_pdcla = new List < PRIME_DRT_Chip_Layer_Summary__c > ();
        Lst_pdcla.add(pdcla00);
        Lst_pdcla.add(pdcla01);
        Lst_pdcla.add(pdcla10);
        Lst_pdcla.add(pdcla11);

        insert Lst_pdcla;

        Set < Id > PDCLAds = new Set < Id > ();
        for (PRIME_DRT_Chip_Layer_Summary__c pdcla: Lst_pdcla) {
            PDCLAds.add(pdcla.Id);
        }

        List < PRIME_DRT_Chip_Layer_Summary__c > pdclaListSelected = [select id from PRIME_DRT_Chip_Layer_Summary__c where id in : PDCLAds];
        system.assertEquals(4, pdclaListSelected.size());

        return Lst_pdcla;
    }

    public static List < PRIME_DRT_Chip_Layer_Summary__c > createPDCLS1(List < PRIME_DRT_Layer_Association__c > pdlaList, List < PRIME_DRT_Chip_Association__c > pdcaList) {

        PRIME_DRT_Chip_Layer_Summary__c pdcls = new PRIME_DRT_Chip_Layer_Summary__c(Chip__c = pdcaList[0].id, Layer__c = pdlaList[0].id,
            Mask_Layer_Rev__c = 'test', ROM_Code__c = 'test',
            IsActive__c = true, Logical_Operation_Type__c = 'test',
            Logical_Operation__c = 'test');
        List < PRIME_DRT_Chip_Layer_Summary__c > Lst_pdcls = new List < PRIME_DRT_Chip_Layer_Summary__c > ();
        Lst_pdcls.add(pdcls);

        insert Lst_pdcls;

        Set < Id > PDCLSID = new Set < Id > ();
        for (PRIME_DRT_Chip_Layer_Summary__c pdcls1: Lst_pdcls) {
            PDCLSID.add(pdcls1.Id);
        }

        List < PRIME_DRT_Chip_Layer_Summary__c > pdclsListSelected = [select id from PRIME_DRT_Chip_Layer_Summary__c where id in : PDCLSID];
        system.assertEquals(1, pdclsListSelected.size());

        return Lst_pdcls;
    }


    public static MST_Config__c createMSTconfig(String testAccId, String testmstId) {
        MST_Config__c msc = new MST_Config__c(Customer__c = testAccId, Mask_Set_Title__c = testmstId, Is_Active_Extension__c = true);
        insert msc;

        MST_Config__c mscSelected = [select id, Customer__c from MST_Config__c where id = : msc.Id];
        system.assertEquals(testAccId, mscSelected.Customer__c);

        return msc;
    }


    public static Opportunity createOpportunityDRT(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';

        insert testOppty;

        testOppty.Siebel_Opportunity_ID__c = '123123123123';

        update testOppty;

        Opportunity Oppr = [select id, name, Siebel_Opportunity_ID__c from Opportunity where id = : testOppty.Id];
        system.assertEquals('Test Opportunity', Oppr.Name);
        system.assertEquals('123123123123', Oppr.Siebel_Opportunity_ID__c);

        return testOppty;
    }

    public static Opportunity_Program__c createOpportunityProgramDRT(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = testOpptyProgram.Name = [Select Name from Opportunity where Id = : testOpptyId].Name;
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;

        insert testOpptyProgram;

        return testOpptyProgram;
    }

    public static Device__c createDeviceDRT(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';

        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';

        insert device;

        Device__c dev = [select id, name from Device__c where id = : device.Id];
        system.assertEquals('TESTDEVICEZAIH12345677', dev.Name);

        return device;
    }

    public static Device__c createDeviceDRT2(Id testAcctId, Id testOpptyProgramId, Id opportunityId) {
        // Create Device
        Device__c device = new Device__c();
        device.Opportunity2__c = opportunityId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';

        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';

        insert device;

        Device__c dev = [select id, name from Device__c where id = : device.Id];
        system.assertEquals('TESTDEVICEZAIH12345677', dev.Name);

        return device;
    }

    public static Device__c createDevicePT(Id testAcctId, Id testOpptyProgramId, Id ProcessTechnologyId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';

        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.Process_Technology_2__c = ProcessTechnologyId;

        insert device;

        return device;
    }

    public static PTRF__c createPTRF_DRT(Id mstId, Id deviceId) {
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        p.Device__c = deviceId;
        p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Mask_Set_Title__c = mstId;
        p.MaskSetTitle__c = mstId;
        p.Status__c = 'Closed';
        p.Prime_DRT__c = 'Prime';
        p.Frame_DRT__c = 'Frame';
        p.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        insert p;

        PTRF__c ptrf = [select id, name, Prime_DRT__c from PTRF__c where id = : p.Id];
        system.assertEquals('PTRF1', ptrf.Name);
        system.assertEquals('Prime', ptrf.Prime_DRT__c);

        return p;
    }
    public static PTRF__c createPTRF_ForDRT(Id mstId, Id deviceId, Id accId) {
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        p.Device__c = deviceId;
        p.Customer__c = accId;
        p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Frame_Tapeout__c = true;
        p.Frame_Mockup__c = true;
        p.Mask_Set_Title__c = mstId;
        p.MaskSetTitle__c = mstId;
        p.Status__c = 'Closed';
        p.Prime_DRT__c = 'Prime';
        p.Frame_DRT__c = 'Frame';
        p.Tech_Geo_Value__c = '0.02UM';
        p.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        insert p;

        PTRF__c ptrf = [select id, name, Prime_DRT__c from PTRF__c where id = : p.Id];
        system.assertEquals('PTRF1', ptrf.Name);
        system.assertEquals('Prime', ptrf.Prime_DRT__c);

        return p;
    }

    public static PTRF__c createPTRFForMRS(Id mstId, Id deviceId, Id accId) {
        PTRF__c p = new PTRF__c();
        p.Name = 'PTRF1';
        p.Device__c = deviceId;
        p.Customer__c = accId;
        p.Device_Id__c = deviceId;
        //p.Transaction_Type__c = 'LIFECYCLE';
        p.Transaction_Date__c = date.today();
        p.Order_Type__c = 'TEST';
        p.Prime_Tapeout__c = true;
        p.Frame_Tapeout__c = true;
        p.Frame_Mockup__c = true;
        p.Prime_GDSOUT_Review__c = true;
        p.Mask_Set_Title__c = mstId;
        p.MaskSetTitle__c = mstId;
        p.Status__c = 'Active';
        p.Recticle_Type__c = 'Multi Node Reticle (MNR)';
        insert p;

        return p;
    }

    public static Chip_Detail__c createChipDetailDRT(String testPTRFId) {
            Chip_Detail__c chip_detail = new Chip_Detail__c();
            chip_detail.PTRF__c = testPTRFId;
            chip_detail.Name = 'TestChip';
            chip_detail.Tapeout__c = true;

            insert chip_detail;

            Chip_Detail__c cd = [select id, name from Chip_Detail__c where id = : chip_detail.Id];
            system.assertEquals('TestChip', cd.name);

            return chip_detail;
        }
        /**
        @ method: createFrameChip
        @ param: ptrfId
        @ return : void
        @ description : This method will insert frame chips
        **/
    public static Chip_Detail__c createFrameChip(String testPTRFId) {
        Chip_Detail__c chip_detail = new Chip_Detail__c();
        chip_detail.PTRF__c = testPTRFId;
        chip_detail.Name = 'Frame';
        chip_detail.Tapeout__c = true;

        insert chip_detail;

        return chip_detail;
    }
    public static Chip_Detail__c createPrimeChip(String testPTRFId) {
            Chip_Detail__c chip_detail = new Chip_Detail__c();
            chip_detail.PTRF__c = testPTRFId;
            chip_detail.Name = 'Prime';
            chip_detail.Tapeout__c = true;

            insert chip_detail;

            return chip_detail;
        }
        /**
        @method: getPTRFJobViewInfo
        @param: ptrfId,userId
        @return : PTRF_JobViewer_Info__c
        @Description: insert ptrf jobviewer info
        **/
    public static PTRF_JobViewer_Info__c getPTRFJobViewInfo(Id ptrfId, Id userId) {
        PTRF_JobViewer_Info__c ptrfJobViewInfoObj = new PTRF_JobViewer_Info__c(PTRF__c = ptrfId, User__c = userId, Jobview__c = 'Customer', Jobview_Type__c = 'Frame Mockup');
        insert ptrfJobViewInfoObj;
        return ptrfJobViewInfoObj;
    }
    public static PTRF_JobViewer_Info__c getPTRFJobViewInfoForGDSOutReview(Id ptrfId, Id userId) {
        PTRF_JobViewer_Info__c ptrfJobViewInfoObj = new PTRF_JobViewer_Info__c(PTRF__c = ptrfId, User__c = userId, Jobview__c = 'Customer', Jobview_Type__c = 'Prime GDSOUT Review', Last_Notified__c = System.now());
        insert ptrfJobViewInfoObj;
        return ptrfJobViewInfoObj;
    }
    public static PTRF_JobViewer_Info__c getPTRFJobViewInfoForGDSOutReviewFoundry(Id ptrfId, Id userId) {
            PTRF_JobViewer_Info__c ptrfJobViewInfoObj = new PTRF_JobViewer_Info__c(PTRF__c = ptrfId, User__c = userId, Jobview__c = 'Foundry', Jobview_Type__c = 'Prime GDSOUT Review');
            insert ptrfJobViewInfoObj;
            return ptrfJobViewInfoObj;
        }
        /**
        @method: getPTRFJobViewInfo
        @param: ptrfId,userId
        @return : PTRF_JobViewer_Info__c
        @Description: insert ptrf jobviewer info
        **/
    public static PTRF_JobViewer_Info__c getFoundryPTRFJobViewInfo(Id ptrfId, Id userId) {
        PTRF_JobViewer_Info__c ptrfJobViewInfoObj = new PTRF_JobViewer_Info__c(PTRF__c = ptrfId, User__c = userId, Jobview__c = 'Foundry', Jobview_Type__c = 'Frame Mockup');
        insert ptrfJobViewInfoObj;
        return ptrfJobViewInfoObj;
    }
    public static List < Frame_DRT_Association__c > createFDA(DRT__c drt) {

        List < Frame_DRT_Association__c > lstFDA = new List < Frame_DRT_Association__c > ();

        Frame_DRT_Association__c FDA1 = new Frame_DRT_Association__c(Mask_Layer_No__c = 'MLN001',
            Retrofit_Mask_Rev__c = 'RMR1',
            Retrofit_ROM_Code__c = 'RRC1',
            Retrofit_Tech_Geo__c = 'RTG1',
            DRT__c = drt.id);

        Frame_DRT_Association__c FDA2 = new Frame_DRT_Association__c(Mask_Layer_No__c = 'MLN001',
            Retrofit_Mask_Rev__c = 'RMR2',
            Retrofit_ROM_Code__c = 'RRC2',
            Retrofit_Tech_Geo__c = 'RTG2',
            DRT__c = drt.id);

        Frame_DRT_Association__c FDA3 = new Frame_DRT_Association__c(Mask_Layer_No__c = 'MLN001',
            Retrofit_Mask_Rev__c = 'RMR3',
            Retrofit_ROM_Code__c = 'RRC3',
            Retrofit_Tech_Geo__c = 'RTG3',
            Last_Sync_Request_Timestamp__c = null,
            DRT__c = drt.id);

        lstFDA.add(FDA1);
        lstFDA.add(FDA2);
        lstFDA.add(FDA3);

        insert lstFDA;

        Set < Id > fdaIds = new Set < Id > ();
        for (Frame_DRT_Association__c fda: lstFDA) {
            fdaIds.add(fda.Id);
        }

        List < Frame_DRT_Association__c > FDAselected = [select id from Frame_DRT_Association__c where id in : fdaIds];
        system.assertNotEquals(0, FDAselected.size());
        system.assertEquals(3, FDAselected.size());

        return lstFDA;

    }
    public static List < Frame_DRT_Association__c > createFDA1(DRT__c drt) {
        List < Mask_Set_Title__c > mst = maskSetTitleList(1);
        List < Frame_DRT_Association__c > lstFDA = new List < Frame_DRT_Association__c > ();

        Frame_DRT_Association__c FDA1 = new Frame_DRT_Association__c(Mask_Set_Title__c = mst[0].id, Mask_Layer_No__c = 'MLN001',
            Retrofit_Mask_Rev__c = 'RMR1',
            Retrofit_ROM_Code__c = 'RRC1',
            Retrofit_Tech_Geo__c = 'RTG1',
            DRT__c = drt.id);
        lstFDA.add(FDA1);

        insert lstFDA;

        Set < Id > fdaIds = new Set < Id > ();
        for (Frame_DRT_Association__c fda: lstFDA) {
            fdaIds.add(fda.Id);
        }
        Frame_DRT_Association__c FDAselected = [select id, Retrofit_Mask_Rev__c from Frame_DRT_Association__c where id in : fdaIds limit 1];
        system.assertEquals('RMR1', FDAselected.Retrofit_Mask_Rev__c);
        return lstFDA;
    }

    public static List < Frame_DRT_Association__c > createFDA2(DRT__c drt, Mask_Set_Title__c mst) {
        List < Frame_DRT_Association__c > lstFDA = new List < Frame_DRT_Association__c > ();

        Frame_DRT_Association__c FDA1 = new Frame_DRT_Association__c(Mask_Set_Title__c = mst.id, Mask_Layer_No__c = 'MLN001',
            Retrofit_Mask_Rev__c = 'RMR1',
            Retrofit_ROM_Code__c = 'RRC1',
            Retrofit_Tech_Geo__c = 'RTG1',
            DRT__c = drt.id);

        // String layerNo,String retroMaskRev,String retroROMCode,String maskRev,String romCode,Integer counter,Boolean isFrameColor) {
        //insert FDA1;

        lstFDA.add(FDA1);

        insert lstFDA;

        return lstFDA;

    }

    public static Mask_Layer__c createMaskLayerDRT(PTRF__c ptrf) {

        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Name = '111';
        maskLayer.Tapeout__c = true;
        maskLayer.Sort_Order__c = 1;
        maskLayer.PTRF__c = ptrf.Id;
        maskLayer.ROM_Code__c = '001';
        maskLayer.Mask_Layer_Rev__c = 'AZ';
        maskLayer.LogicalOperation__c = 'Foundry Std';
        maskLayer.LogicalOperationType__c = 'Foundry Std.';
        maskLayer.Mask_Layer_Number__c = '111';
        insert maskLayer;

        Mask_Layer__c ml = [select id, Mask_Layer_Number__c from Mask_Layer__c where id = : maskLayer.Id];
        system.assertEquals('111', ml.Mask_Layer_Number__c);

        return maskLayer;
    }

    public static Process_Technology__c createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        p.Tech_Geometry__c = 'test-tech-geometry';
        insert p;

        Process_Technology__c pt = [select id, name, Tech_Geometry__c from Process_Technology__c where id = : p.Id];
        system.assertEquals('test-tech-geometry', pt.Tech_Geometry__c);
        return p;
    }

    public static Process_Technology__c createProcessTechnologyForDRT() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        p.Tech_Geometry__c = '0.02UM';
        insert p;

        Process_Technology__c pt = [select id, name, Tech_Geometry__c from Process_Technology__c where id = : p.Id];
        system.assertEquals('0.02UM', pt.Tech_Geometry__c);

        return p;
    }

    public static Device__c createDeviceWithPT(Id testAcctId, Id opportunityId, Id testOpptyProgramId, Id processTechnologyId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Test';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Sourcing__c = 'First Source';
        device.End_Application__c = 'Body';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.IP_Technology__c = 'TECH1';
        device.Process_Technology_2__c = processTechnologyId;
        device.Account__c = testAcctId;
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.Opportunity2__c = opportunityId;
        //Get MST Name
        List < Mask_Set_Title__c > mstList = [Select Name from Mask_Set_Title__c limit 1];
        if (!mstList.isEmpty()) {
            device.Device_Mask_Set_Title__c = mstList.get(0).Name;
        } else {
            Mask_Set_Title__c objMST = SwiftDataUtilityTest.createMST('MST0011');
            insert objMST;
            device.Device_Mask_Set_Title__c = 'MST0011';
        }
        insert device;

        Device__c dev = [select id, name from Device__c where id = : device.Id];
        system.assertEquals('TESTDEVICEZAIH12345677', dev.Name);

        return device;
    }

    public static DRT_PTRF_Association__c createDPA(String drtId, String testPTRFId) {
        DRT_PTRF_Association__c dpa1 = new DRT_PTRF_Association__c(DRT__c = drtId, PTRF__c = testPTRFId);
        insert dpa1;
        return dpa1;

    }


    public static PRIME_DRT_Chip_Association__c createPrimeDrt(DRT__c drt) {
        PRIME_DRT_Chip_Association__c primeDrt = new PRIME_DRT_Chip_Association__c();
        primeDrt.Name = 'PrimeDrt Test';
        primeDrt.DRT__c = drt.id;
        insert primeDrt;
        return primeDrt;
    }

    public static PRIME_DRT_Chip_Association__c createPrimeDrt1(DRT__c drt) {
        PRIME_DRT_Chip_Association__c primeDrt = new PRIME_DRT_Chip_Association__c();
        primeDrt.Name = 'PrimeDrt1 Test';
        primeDrt.DRT__c = drt.id;
        primeDrt.Last_Sync_Request_Timestamp__c = null;
        insert primeDrt;
        return primeDrt;
    }

    public static HCM_Employee__c createHCMEmployeeDrt(String dataChange) {
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();

        testHCMEmployee.First_Name__c = dataChange + ' ' + 'Employee FN';
        testHCMEmployee.Last_Name__c = dataChange + ' ' + 'Employee LN';
        testHCMEmployee.Employee_ID__c = dataChange;
        testHCMEmployee.Login_ID__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Email_Address__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Status__c = 'Active';

        return testHCMEmployee;
    }



    /*************end*****************/
    /*********** MRS Data********************/
    public static List < MRS_Layer_Chip_Association__c > getMRSLayerChipAsso(Id ptrfId) {
            List < MRS_Layer_Chip_Association__c > mrsLayerChipAssolst = [SELECT Id, PTRF__c, Customer_Name__r.Short_Name__c, PTRF__r.MaskSetTitle__c, PTRF__r.MaskSetTitle__r.Name, Tech_Geo__c, Customer_Name__c, Customer_Name__r.Name, Layer__c, Chip__c, Layer__r.Name, Mask_Set_Title_Name__c, Layer_Chip_Status__c, PTRF__r.Name, Chip__r.Name, Customer_GDSOUT_Review__c,
                Foundry_GDSOUT_Review__c, Customer_Frame_Mockup__c, Foundry_Frame_Mockup__c, Customer_MEBES_Jobview__c, Foundry_MEBES_Jobview__c, Tapeout_Centre_MEBES_Jobview__c,
                Tapeout_Applications_MEBES_Jobview__c, GlobalShuttle_MEBES_Jobview__c, TDTI_MPW_MEBES_Jobview__c, MDP_MEBES_Jobview__c
                FROM MRS_Layer_Chip_Association__c
                WHERE PTRF__c = : ptrfId
            ];
            return mrsLayerChipAssolst;
        }
        /**
            @method: getMRS()
            @param : null
            @return: void
            @description: this method will return the MRS record.
        **/
    public static MRS__c getMRS() {
            MRS__c mrsObj = [SELECT Id, Name FROM MRS__c limit 1];
            return mrsObj;
        }
        /**
            @method: getMRSLayerAsso()
            @param : mrsId
            @return: void
            @description: this method will return the list of MRS_Layer_Asso record.
        **/
    public static List < MRS_Layer_Association__c > getMRSLayerAsso() {
        List < MRS_Layer_Association__c > mrsLayerAssolst = [SELECT Layer_Status__c, Id, Name, MRS__c FROM MRS_Layer_Association__c];
        return mrsLayerAssolst;
    }


    public static Fab_Distribution_Table__c createFDL() {
        Fab_Distribution_Table__c dpa1 = new Fab_Distribution_Table__c();
        insert dpa1;
        return dpa1;
        return null;
    }

    //created for SWIFT_OracleDB_ResponseServiceTest
    public static Fab_Distribution_Table__c createFDL1() {
        Fab_Distribution_Table__c dpa1 = new Fab_Distribution_Table__c();
        dpa1.Distribution_List__c = 'New@sfdc.com';
        dpa1.Fab_No__c = 'FAB 3E';
        /* dpa1.isDeleted__c=
         dpa1.Last_Sync_Request_Timestamp__c=
         dpa1.Synced_with_Oracle_DB__c
         dpa1.Trigger_Oracle_DB_Sync_Manual__c=*/
        insert dpa1;
        return dpa1;
    }

    public static Tapeout_Applications_MEBES_Jobview_Confi__c createTA() {
        Tapeout_Applications_MEBES_Jobview_Confi__c dpa1 = new Tapeout_Applications_MEBES_Jobview_Confi__c();
        insert dpa1;
        return dpa1;
    }
    public static MST_Chip_Association__c createMSTc(Id mstId) {
        MST_Chip_Association__c dpa1 = new MST_Chip_Association__c(Mask_Set_Title__c = mstId);
        insert dpa1;
        return dpa1;
    }
    public static MRS__c createMrs(Id mstId) {
        MRS__c mrsData = new MRS__c(Mask_Set_Title__c = mstId);
        insert mrsData;
        return mrsData;
    }
    public static MRS_Layer_Chip_Association__c createMRSlc(id chipId, id layerId) {
        MRS_Layer_Chip_Association__c dpa1 = new MRS_Layer_Chip_Association__c(Chip__c = chipId, Layer__c = layerId);
        insert dpa1;
        return dpa1;
    }

    public static MRS_Layer_Association__c createMRSl(id mrsId) {
        MRS_Layer_Association__c dpa1 = new MRS_Layer_Association__c(ROM_Code__c = '001', Mask_Layer_Rev__c = 'AZ', MRS__c = mrsId, Name = 'Testing');
        insert dpa1;
        return dpa1;
    }

    public static MRS_Chip_Details__c createMRSc(id mrsId) {
        MRS_Chip_Details__c dpa1 = new MRS_Chip_Details__c(MRS__c = mrsId, Name = 'Testing');
        insert dpa1;
        return dpa1;
    }
    public static Notes__c creatent(id mrsId, id mrslcId) {
        Notes__c dpa1 = new Notes__c(MRS_Layer_Association__c = mrsId, ParentId__c = mrslcId);
        insert dpa1;
        return dpa1;
    }

    private static Account getAccount(string AccountName) {
        list<Account> accList = new list<Account>();
        accList = [SELECT Id, Name FROM Account Where Name = : AccountName];
        if(accList.isEmpty()) accList.add(createAccount(getFieldValueMap()));
        return accList.get(0);
    }
    
    /* Method to create one Account Test Data record Dynamically*/
    public static Account createAccount(Map<String,Object> fieldValueMap) {
        // Create Account with default data that is required, this will handle cases where required fields are not set
        Account acc = new Account(Name='TestAccount1',
            Site_Department__c='IT',
            Sub_Type__c='Indirect',
            Transaction_Type__c='Non-Transactional',
            Region__c='US',
            Corporate_Address_1__c = 'Test Address 1',
            Corporate_City__c = 'Test City',
            Corporate_Country__c = 'Test Country'                  
        );          
              
        for(String fieldName: fieldValueMap.keySet()) {
            acc.put(fieldName, fieldValueMap.get(fieldName));        
        }

        insert acc;
        return acc;
    }
}