/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ApproverValidatorUtilTest {
    public static Id acc;
    public static Id opp;
    public static string processId;
    public static Device__c dev = new Device__c();

    Public String newWorkItemIds3;

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();

        List < Error_Codes__c > lst = new List < Error_Codes__c > ();
        lst.add(new Error_Codes__c(Name = 'CONFIG_STAGE_VALIDATION_MSG', Message__c = 'test'));
        insert lst;


    }
    static void createApprovalSetting(string accId) {
        ConfiguratorApprovalSetting__c obj = new ConfiguratorApprovalSetting__c(Default_Approver__c = UserInfo.getUserId(), FAB_Name__c = 'FAB 2,FAB 3,FAB 3E,FAB 7,FAB 5,FAB 6', Maximum_Approver__c = 15);
        insert obj;
    }

    public static testmethod void sendEmailtest() {
        Test.StartTest();
        Contact objContact = new Contact(LastName = 'Test' + UserInfo.getUserId(), FirstName = 'Test', email = 'test@test731723.com');
        insert objContact;
        EmailTemplate objTemplate = [Select id from EmailTemplate where developername = 'CUSTOMER_ENGINEER_NOTIFICATION'];

        OrgWideEmailAddress[] owdEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply-salesforce@globalfoundries.com'];
        String strDefaultAddress = '';
        if (owdEmail != null && owdEmail.size() > 0) {
            strDefaultAddress = owdEmail.get(0).Id;
        }

        // Test.starttest();
        List < String > toAddress = new List < string > ();
        for (integer ii = 0; ii < 110; ii++) {
            toAddress.add('no-reply' + ii + '@salesforce.com');
        }
        ApproverValidatorUtil.createEmailNotificationEnvelop(objContact.id, strDefaultAddress, objTemplate.id, toAddress, objContact.id);
        Test.stopTest();

    }
    static Id createMaskSetTitle() {

        Map < String, Object > fieldValueMap = new Map < String, Object > ();

        fieldValueMap.put('Name', 'MSTTRT1');
        fieldValueMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        Mask_Set_Title__c mstRec = MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap);

        return mstRec.Id;
    }
    static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map < String, Object > fieldValueMap = new Map < String, Object > ();
        fieldValueMap.put('Name', 'Test Opportunity');
        fieldValueMap.put('AccountId', acctId);
        fieldValueMap.put('StageName', '1. Discovery');
        fieldValueMap.put('CloseDate', Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c', '14XM');
        fieldValueMap.put('Market_Segment__c', 'Mobility');
        fieldValueMap.put('Process_Platform__c', 'GF Baseline');
        fieldValueMap.put('Fab_Split__c', 100);
        fieldValueMap.put('Process_Geometry__c', processGeometry); //'0.60UM'
        fieldValueMap.put('Process_Family__c', 'Super Low Power');

        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
    }

    static Id createOppProg(Id acctId, Id oppId) {
        // Create Opportunity Program
        Map < String, Object > fieldValueMap = new Map < String, Object > ();
        fieldValueMap.put('Name', 'Test Opportunity Program');
        fieldValueMap.put('Account__c', acctId);
        fieldValueMap.put('Opportunity__c', oppId);

        return OpportunityProgramDataFactory.createOpportunityProgram(fieldValueMap).id;
    }

    static Id createAccount() {
        // Create Opportunity Program
        Map < String, Object > fieldValueMap = new Map < String, Object > ();
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
        fieldValueMap.put('Fab_9_10__c', 'No');

        return AccountDataFactory.createAccount(fieldValueMap).id;
    }

    public static testmethod void Approvaltest() {
       try{
        acc = createAccount();
        //opp=DeviceUtilTest.createOpp(acc,'0.014UM');
        opp = createOpp(acc, '0.014UM');

        Device__c dev = createDevice(acc, opp, '0.014UM', 'On Hold');
        createApprovalSetting(acc);

        Test.StartTest();
     
        createConfig(dev.id);
        Apttus_Proposal__Proposal__c configupdate = [Select id from Apttus_Proposal__Proposal__c where Apttus_Proposal__Proposal_Name__c = 'TestConfig'];
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setNextApproverIds(new Id[] { UserInfo.getUserId() });
        req.setObjectId(configupdate.Id);

        Approval.ProcessResult resu = Approval.process(req);
        // Verify the result
        System.assert(resu.isSuccess());
        List < Id > newWorkItemIds = resu.getNewWorkitemIds();


        User unauthUser = createUser(null, 'GF PIYE Platform');

        System.runAs(unauthUser) {
          
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] { UserInfo.getUserId() }); //UserInfo.getUserId()
            system.debug('req2::' + req2);
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(newWorkItemIds.get(0));
            // newWorkItemIds2  = req2.getWorkitemId();
            system.debug('req3::' + req2);
            // Submit the request for approval
            Approval.ProcessResult result2 = Approval.process(req2);

            System.debug('status 2------>' + result2.getInstanceStatus());
            // Verify the results
            System.assert(result2.isSuccess(), 'Result Status:' + result2.isSuccess());

            System.assertEquals('Approved', result2.getInstanceStatus(), 'Instance Status' + result2.getInstanceStatus());
       

            Test.StopTest();

        } }catch(exception ex){}
        
    }

    static User createUser(Id contactId, string profileName) {
        Integer iCount = 1;
        Id profileId = [select ID, Name from Profile where Name =: 'GF PIYE Platform'].id;

        User user = new User(Alias = 'ts' + iCount, Email = 'testing' + iCount + '@cy.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestCY' + iCount, LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = profileId, communitynickname = 'ts' + iCount, Fab_Assigned__c = 'FAB 2',
            FederationIdentifier = 'Test2014' + iCount, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testing' + iCount + '@cy.com');

        HCM_Employee__c testHCMEmployee = new HCM_Employee__c(First_Name__c = 'TestFirst' + iCount, Last_Name__c = 'TestCY' + iCount,
            Employee_ID__c = 'Test2014' + iCount, Login_ID__c = 'testing' + iCount + '@cy.com', Email_Address__c = 'testing' + iCount + '@cy.com',
            Status__c = 'Active');

        insert testHCMEmployee;
        insert user;

        return user;

    }

    public static Device__c createDevice(string acctId, string opptyId, string geometry, string status) {

        //string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string opptyProgramId = createOppProg(acctId, opptyId);
        //string mpwId = DeviceUtilTest.createMPWTrainMnt();
        //processId = DeviceUtilTest.createProcess('0.014UM');
        //string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        String MSTId = createMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId, MSTId);

        Map < String, Object > fieldValueMap = new Map < String, Object > ();

        fieldValueMap.put('Account__c', acctId);
        fieldValueMap.put('Name', 'TESTDEVICE');
        fieldValueMap.put('Opportunity2__c', opptyId);
        fieldValueMap.put('Opportunity_Program__c', opptyProgramId);
        fieldValueMap.put('Fab__c', 'FAB 1');
        fieldValueMap.put('Internal_Device_Geometry__c', '0.014UM');
        fieldValueMap.put('Internal_Device_Process_Family__c', 'Generic / Nominal');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');
        fieldValueMap.put('Market_Segment__c', 'Automotive');
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');
        fieldValueMap.put('End_Customer__c', 'Test Customer');
        fieldValueMap.put('Device_Sourcing__c', '1st Source');
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', status);
        fieldValueMap.put('Siebel_Device_ID__c', '1234567890');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c', 'ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MSTTRT1');
        fieldValueMap.put('CRMDID__c', 'CDID0000001.00');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013, 5, 20));
        fieldValueMap.put('Device_Type__c', 'Base');
        fieldValueMap.put('End_Application__c', 'Body');
        fieldValueMap.put('Reason_For_Status_On_Hold__c', 'Test');
        fieldValueMap.put('Confidence_Level_Tapeout__c', '50');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }




    public static void createConfig(String devid) {

        Process_Technology__c PT = new Process_Technology__c();
        PT.Tech_Geometry__c = '0.040UM';
        insert PT;

        Apttus_Proposal__Proposal__c testcon = new Apttus_Proposal__Proposal__c();
        testcon.Apttus_Proposal__Proposal_Name__c = 'TestConfig';
        testcon.Apttus_Proposal__Primary__c = true;
        testcon.Apttus_Proposal__Approval_Stage__c = 'Draft';
        testcon.Apttus_Proposal__Account__c = acc;
        testcon.Apttus_Proposal__Opportunity__c = opp;
        testcon.Device__c = devid;
        testcon.Assigned_Process_ID__c = DeviceUtilTest.createProcess('0.014UM');
        testcon.Process_Technology_Lookup__c = PT.id;
        testcon.Approval_Check__c = false;
        testcon.Purpose_of_the_Configuration__c = 'Final';


        testcon.SRAM__c = 'Yes';
        testcon.SRAM_Gate_Orientation__c = 'Horizontal';
        testcon.ACLV_Gate_Orientation__c = 'Horizontal';
        testcon.Gate_Orientation_PFET__c = 'Horizontal';
        testcon.Justification_of_Retrofit__c = 'test';
        testcon.PTRF_Rotation__c = '';
        testcon.Process_Technology__c = 'PT0030791';
        // testcon.Consolidated_IP_Status_Check__c = 'No';
        system.assertEquals(PT.id, testcon.Process_Technology_Lookup__c);
        // system.assertEquals('0.040UM',testcon.Process_Technology_Lookup__r.Tech_Geometry__c); 
        // system.assertEquals(true,testcon.Poly_Orientation_Status_1__c); 
        system.assertNotequals(testcon.Process_Technology__c, null);
        system.assertNotequals(testcon.Apttus_Proposal__Account__c, null);
        insert testcon;


    }
}