/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormExtension class.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormExtensionTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static testMethod void testTechnologySelected(){
        
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
            Process__c fab2Process = new Process__c(
                Name = 'FAB 2 Process',
                Org_ID__c = 'FAB 2',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab2Process;
            
            Process__c fab3Process = new Process__c(
                Name = 'FAB 3 Process',
                Org_ID__c = 'FAB 3',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3Process;
            
            Process__c fab3eProcess = new Process__c(
                Name = 'FAB 3e Process',
                Org_ID__c = 'FAB 3e',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3eProcess;
            
            Process__c fab5Process = new Process__c(
                Name = 'FAB 5 Process',
                Org_ID__c = 'FAB 5',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab5Process;
            
            Process__c fab6Process = new Process__c(
                Name = 'FAB 6 Process',
                Org_ID__c = 'FAB 6',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab6Process;
            
            Process__c fab7Process = new Process__c(
                Name = 'FAB 7 Process',
                Org_ID__c = 'FAB 7',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab7Process;
            
            Process__c fab8Process = new Process__c(
                Name = 'FAB 8 Process',
                Org_ID__c = 'FAB 8',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab8Process;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.Today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller1.leftselected.add('FAB 1 Process');
            controller1.leftselected.add('FAB 2 Process');
            controller1.leftselected.add('FAB 3 Process');
            controller1.leftselected.add('FAB 5 Process');
            List<SelectOption> temp1 = controller1.getSelectedValues();
            controller1.selectclick();
            controller1.rightselected.add('FAB 5 Process');
            List<SelectOption> temp2 = controller1.getunSelectedValues();
            controller1.unselectclick();
            controller1.saveRecord();
            system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
            test.stopTest();
        }
    }
    
    public static testMethod void testTechnology(){
        
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
            Process__c fab2Process = new Process__c(
                Name = 'FAB 2 Process',
                Org_ID__c = 'FAB 2',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab2Process;
            
            Process__c fab3Process = new Process__c(
                Name = 'FAB 3 Process',
                Org_ID__c = 'FAB 3',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3Process;
            
            Process__c fab3eProcess = new Process__c(
                Name = 'FAB 3e Process',
                Org_ID__c = 'FAB 3e',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3eProcess;
            
            Process__c fab5Process = new Process__c(
                Name = 'FAB 5 Process',
                Org_ID__c = 'FAB 5',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab5Process;
            
            Process__c fab6Process = new Process__c(
                Name = 'FAB 6 Process',
                Org_ID__c = 'FAB 6',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab6Process;
            
            Process__c fab7Process = new Process__c(
                Name = 'FAB 7 Process',
                Org_ID__c = 'FAB 7',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab7Process;
            
            Process__c fab8Process = new Process__c(
                Name = 'FAB 8 Process',
                Org_ID__c = 'FAB 8',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab8Process;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.Today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller1.queryFab1Technologies();
            controller1.queryFab2Technologies();
            controller1.queryFab3Technologies();
            controller1.queryFab3eTechnologies();
            controller1.queryFab5Technologies();
            controller1.queryFab6Technologies();
            controller1.queryFab7Technologies();
            controller1.queryFab8Technologies();
            system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
            test.stopTest();
        }
    }
    
    public static testMethod void testCancel(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() limit 1];
            User searchUser2 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :searchUser1.Id limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
               // FAB_9__c = true,
               // FAB_10__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.cancelAction();
            //yash
            controller.cancelPM();
            controller.closeReceivedDatePopup();
            controller.pmRejected();
            controller.sendEmailAfterPMRejection();
            //controller.checkNewButton();
            //yash
            controller.retrieveAccountId();
            controller.resetCuSRForm();
            system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
            test.stopTest();    
        }
    }
   
    
    /*public static testMethod void testVoid(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() limit 1];
            User searchUser2 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :searchUser1.Id limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.voidAction();
            controller.cusrForm.Reason_to_Void__c = 'Sample';
            controller.submitToVoid();
            test.stopTest();    
        }
    }*/
    
    public static testMethod void testLoggedInUserasCE(){
        User gfUser = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
        
        
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
        
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = gfUser.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = gfUser.Id
            );
            insert testCuSRForm;
            
            system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
            
            system.runAs(gfUser){
                test.startTest();
                CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));                
                test.stopTest();
            }
            
    }
    
    public static testMethod void testLoggedInUserAsAM(){
        User amUser = [select Id, Name from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
        
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
       
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = amUser.Id
            );
            insert testCuSRForm;
            
            system.runAs(amUser){
                test.startTest();
                CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
                system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
                test.stopTest();
            }
            
    }
    
    public static testMethod void testLoggedInUserAsAdmin(){
        User sysUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
       
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented',
                OwnerId = sysUser.Id
            );
            insert testCuSRForm;
            
            system.runAs(sysUser){
                test.startTest();
                CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
                system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');
                test.stopTest();
            }
            
    }
    
    public static testMethod void testValidationSave(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
        system.runAs(testUser){
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Scope_of_the_CuSR__c = 'Others';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'No';
            controller1.saveRecord();
            system.assertEquals(controller1.cusrForm.Is_this_a_one_time_requirement__c, 'No');
            test.stopTest();
        }
    }
    
    
    public static testMethod void testDresden(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            User ceUserList2 = new User();
            ceUserList2 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :ceUserList1.Id and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 1');  
            insert ceUser1;
            Account_Team_Proxy__c ceUser2 = new Account_Team_Proxy__c(User__c = ceUserList2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 5');
            insert ceUser2;
            
            insert teamProxyList;
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            
            test.startTest();
            
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_1__c = true;
            controller1.rightValues.add(fab1Process.Tech_Type__c+' '+fab1Process.Tech_Geometry__c);
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            //controller1.getRequestorEmail();
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.fileBody = Blob.valueOf('Unit Testing Body');
            //controller1.fileName = 'Test Name';
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Dresden_System_Owner_Approval_Required__c = 'Yes';
            controller2.dresdenSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.dresdenSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.dresdenSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab1Approver.No_of_Approvers__c = '5';
            controller2.fab1Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab1Approver.Approver1__c = notifyUser.Id;
            controller2.fab1Approver.Approver2__c = notifyUser.Id;
            controller2.fab1Approver.Approver3__c = notifyUser.Id;
            controller2.fab1Approver.Approver4__c = notifyUser.Id;
            controller2.fab1Approver.Approver5__c = notifyUser.Id;
            controller2.fab1Approver.Status__c = 'New';
            
            controller2.saveDresden();
            controller2.dresdenSubmitForApproval();
            controller2.validateRequestReceivedDate();
            test.stopTest();
            
            CuSR_Approval_Process__c sysAppr = controller2.dresdenSystemOwnerApproval;
            sysAppr.Status__c = 'Approved';
            update sysAppr;
            
            //--yash
            CuSR_Approval_Process__c sysAppr1 = controller2.dresdenSystemOwnerApproval;
            sysAppr1.Status__c = 'New';
            update sysAppr1;
            //yash
            
            CuSR_Approval_Process__c fab1Appr = controller2.fab1Approver;
            fab1Appr.Status__c = 'Approved';
            update fab1Appr;
            
            CuSR_Approval_Process__c fab1Appr1 = controller2.fab1Approver;
            fab1Appr1.Status__c = 'New';
            update fab1Appr1;
            
            CuSR_Form__c testCuSRForm1 = new CuSR_Form__c();
            testCuSRForm1 = controller2.cusrForm;
            system.assertEquals(testCuSRForm.Technology__c, 'Sample Sample');
            
        }
    }
    
    public static testMethod void testDresdenApprovals(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            //Test.StopTest();
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            User ceUserList2 = new User();
            ceUserList2 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :ceUserList1.Id and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 1');  
            insert ceUser1;
            Account_Team_Proxy__c ceUser2 = new Account_Team_Proxy__c(User__c = ceUserList2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 5');
            insert ceUser2;
            
            insert teamProxyList;
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            Test.StartTest();
            insert testCuSRForm;
            
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            insert systemApproval;
           //---start Yash 
           CuSR_Approval_Process__c systemApproval3 = new CuSR_Approval_Process__c(
                Approver2__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            insert systemApproval3;
            CuSR_Approval_Process__c systemApproval1 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'AM'
            );
            insert systemApproval1;
            
            CuSR_Approval_Process__c AMsystemApproval2 = new CuSR_Approval_Process__c(
                Approver2__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'AM'
            );
            insert AMsystemApproval2;
            
            CuSR_Approval_Process__c AMsystemApproval3 = new CuSR_Approval_Process__c(
                Approver3__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'AM'
            );
            insert AMsystemApproval3;
            
            CuSR_Approval_Process__c AMsystemApproval4 = new CuSR_Approval_Process__c(
                Approver4__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'AM'
            );
            insert AMsystemApproval4;
            
            CuSR_Approval_Process__c AMsystemApproval5 = new CuSR_Approval_Process__c(
                Approver5__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'AM'
            );
            insert AMsystemApproval5;
            
            CuSR_Approval_Process__c systemApproval2 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB Owner'
            );
            insert systemApproval2;
            
            CuSR_Approval_Process__c systemApproval4 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '2',
                Site__c = 'Singapore',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB Owner'
            );
            insert systemApproval4;
            
             CuSR_Approval_Process__c fab1Approval1 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert fab1Approval1;
            // ---end yash
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
            
            CuSR_Approval_Process__c fab1Approval11 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '2',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval11;
            
            CuSR_Approval_Process__c fab1Approval12 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '2',
                Site__c = 'Malta',
                Fab__c = 'FAB 9',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            insert fab1Approval12;
            
            CuSR_Approval_Process__c fab1Approval13 = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                Approver2__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '2',
                Site__c = 'Malta',
                Fab__c = 'FAB 10',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            insert fab1Approval13;
            
            //test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            system.assertEquals(testCuSRForm.Technology__c, 'CA 0.045UM');            
            test.stopTest();
            
        }
    }
    
    
    
    public static testMethod void testMalta(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            Process__c fab8Process = new Process__c(
                Name = 'FAB 8 Process',
                Org_ID__c = 'FAB 8',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab8Process;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_8__c = true;
            controller1.rightValues.add(fab8Process.Tech_Type__c+' '+fab8Process.Tech_Geometry__c);
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Malta_System_Owner_Approval_Required__c ='Yes';
            controller2.maltaSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.maltaSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.maltaSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab8Approver.No_of_Approvers__c = '5';
            controller2.fab8Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab8Approver.Approver1__c = notifyUser.Id;
            controller2.fab8Approver.Approver2__c = notifyUser.Id;
            controller2.fab8Approver.Approver3__c = notifyUser.Id;
            controller2.fab8Approver.Approver4__c = notifyUser.Id;
            controller2.fab8Approver.Approver5__c = notifyUser.Id;
            controller2.saveMalta();
            controller2.maltaSubmitForApproval();
            test.stopTest();
            
            CuSR_Approval_Process__c sysAppr = controller2.maltaSystemOwnerApproval;
            sysAppr.Status__c = 'Approved';
            update sysAppr;
            
            CuSR_Approval_Process__c fab8Appr = controller2.fab8Approver;
            fab8Appr.Status__c = 'Approved';
            update fab8Appr;
            system.assertEquals(fab8Process.Name, 'FAB 8 Process');
            
            
        }
    }
    
    public static testMethod void testMaltaApprovals(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            User ceUserList2 = new User();
            ceUserList2 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :ceUserList1.Id and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 1');  
            insert ceUser1;
            Account_Team_Proxy__c ceUser2 = new Account_Team_Proxy__c(User__c = ceUserList2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 5');
            insert ceUser2;
            
            insert teamProxyList;
            
            Process__c fab8Process = new Process__c(
                Name = 'FAB 8 Process',
                Org_ID__c = 'FAB 8',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab8Process;
            
            Process__c fab9Process = new Process__c(
                Name = 'FAB 9 Process',
                Org_ID__c = 'FAB 9',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab9Process;
            
            Process__c fab10Process = new Process__c(
                Name = 'FAB 10 Process',
                Org_ID__c = 'FAB 10',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab10Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Malta_Ready_for_Approval__c = true,
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            /*CuSR_Form__c testCuSRForm9 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Malta_Ready_for_Approval__c = true,
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm9;
            CuSR_Form__c testCuSRForm10 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_10__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Malta_Ready_for_Approval__c = true,
                Malta_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm10;*/
            
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Malta',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            insert systemApproval;
            
            CuSR_Approval_Process__c fab8Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 8',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert fab8Approval;
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 9',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            insert fab9Approval;
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 10',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            insert fab10Approval;
            system.assertEquals(fab10Approval.Site__c, 'Dresden');
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();            
            test.stopTest();
            
        }
    }
    
    public static testMethod void testSingapore(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Process__c fab2Process = new Process__c(
                Name = 'FAB 2 Process',
                Org_ID__c = 'FAB 2',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab2Process;
            
            Process__c fab3Process = new Process__c(
                Name = 'FAB 3 Process',
                Org_ID__c = 'FAB 3',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3Process;
            
            Process__c fab3eProcess = new Process__c(
                Name = 'FAB 3e Process',
                Org_ID__c = 'FAB 3e',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab3eProcess;
            
            /*Process__c fab5Process = new Process__c(
                Name = 'FAB 5 Process',
                Org_ID__c = 'FAB 5',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab5Process;
            
            Process__c fab6Process = new Process__c(
                Name = 'FAB 6 Process',
                Org_ID__c = 'FAB 6',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab6Process;
            
            Process__c fab7Process = new Process__c(
                Name = 'FAB 7 Process',
                Org_ID__c = 'FAB 7',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab7Process;*/
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_2__c = true;
            controller1.cusrForm.FAB_3__c = true;
            controller1.cusrForm.FAB_3E__c = true;
            /*controller1.cusrForm.FAB_5__c = true;
            controller1.cusrForm.FAB_6__c = true;
            controller1.cusrForm.FAB_7__c = true;*/
            controller1.rightValues.add(fab2Process.Tech_Type__c+' '+fab2Process.Tech_Geometry__c);
            controller1.rightValues.add(fab3Process.Tech_Type__c+' '+fab3Process.Tech_Geometry__c);
            controller1.rightValues.add(fab3eProcess.Tech_Type__c+' '+fab3eProcess.Tech_Geometry__c);
            /*controller1.rightValues.add(fab5Process.Tech_Type__c+' '+fab5Process.Tech_Geometry__c);
            controller1.rightValues.add(fab6Process.Tech_Type__c+' '+fab6Process.Tech_Geometry__c);
            controller1.rightValues.add(fab7Process.Tech_Type__c+' '+fab7Process.Tech_Geometry__c);*/
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            //controller1.getRequestorEmail();
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab2Approver.No_of_Approvers__c = '5';
            controller2.fab2Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab2Approver.Approver1__c = notifyUser.Id;
            controller2.fab2Approver.Approver2__c = notifyUser.Id;
            controller2.fab2Approver.Approver3__c = notifyUser.Id;
            controller2.fab2Approver.Approver4__c = notifyUser.Id;
            controller2.fab2Approver.Approver5__c = notifyUser.Id;
            controller2.fab3Approver.No_of_Approvers__c = '5';
            controller2.fab3Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab3Approver.Approver1__c = notifyUser.Id;
            controller2.fab3Approver.Approver2__c = notifyUser.Id;
            controller2.fab3Approver.Approver3__c = notifyUser.Id;
            controller2.fab3Approver.Approver4__c = notifyUser.Id;
            controller2.fab3Approver.Approver5__c = notifyUser.Id;
            controller2.fab3eApprover.No_of_Approvers__c = '5';
            controller2.fab3eApprover.Do_you_require_approval_from_all_users__c = false;
            controller2.fab3eApprover.Approver1__c = notifyUser.Id;
            controller2.fab3eApprover.Approver2__c = notifyUser.Id;
            controller2.fab3eApprover.Approver3__c = notifyUser.Id;
            controller2.fab3eApprover.Approver4__c = notifyUser.Id;
            controller2.fab3eApprover.Approver5__c = notifyUser.Id;
            /*controller2.fab5Approver.No_of_Approvers__c = '5';
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.Approver3__c = notifyUser.Id;
            controller2.fab5Approver.Approver4__c = notifyUser.Id;
            controller2.fab5Approver.Approver5__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '5';
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.Approver3__c = notifyUser.Id;
            controller2.fab6Approver.Approver4__c = notifyUser.Id;
            controller2.fab6Approver.Approver5__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '5';
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.Approver3__c = notifyUser.Id;
            controller2.fab7Approver.Approver4__c = notifyUser.Id;
            controller2.fab7Approver.Approver5__c = notifyUser.Id;*/
            controller2.saveSingapore();
            controller2.singaporeSubmitForApproval();
            system.assertEquals(controller2.fab3eApprover.Approver5__c, notifyUser.Id);
            test.stopTest();
            
        }
    }
    
    public static testMethod void testSingapore2(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Process__c fab5Process = new Process__c(
                Name = 'FAB 5 Process',
                Org_ID__c = 'FAB 5',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab5Process;
            
            Process__c fab6Process = new Process__c(
                Name = 'FAB 6 Process',
                Org_ID__c = 'FAB 6',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab6Process;
            
            Process__c fab7Process = new Process__c(
                Name = 'FAB 7 Process',
                Org_ID__c = 'FAB 7',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab7Process;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_5__c = true;
            controller1.cusrForm.FAB_6__c = true;
            controller1.cusrForm.FAB_7__c = true;
            controller1.rightValues.add(fab5Process.Tech_Type__c+' '+fab5Process.Tech_Geometry__c);
            controller1.rightValues.add(fab6Process.Tech_Type__c+' '+fab6Process.Tech_Geometry__c);
            controller1.rightValues.add(fab7Process.Tech_Type__c+' '+fab7Process.Tech_Geometry__c);
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            //controller1.getRequestorEmail();
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab5Approver.No_of_Approvers__c = '5';
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.Approver3__c = notifyUser.Id;
            controller2.fab5Approver.Approver4__c = notifyUser.Id;
            controller2.fab5Approver.Approver5__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '5';
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.Approver3__c = notifyUser.Id;
            controller2.fab6Approver.Approver4__c = notifyUser.Id;
            controller2.fab6Approver.Approver5__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '5';
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.Approver3__c = notifyUser.Id;
            controller2.fab7Approver.Approver4__c = notifyUser.Id;
            controller2.fab7Approver.Approver5__c = notifyUser.Id;
            controller2.saveSingapore();
            controller2.singaporeSubmitForApproval();
            system.assertEquals(controller2.fab5Approver.Approver1__c,notifyUser.Id);
            test.stopTest();
            
        }
    }   
        public static testMethod void testSingapore3(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            Process__c fab5Process = new Process__c(
                Name = 'FAB 5 Process',
                Org_ID__c = 'FAB 5',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab5Process;
            
            Process__c fab6Process = new Process__c(
                Name = 'FAB 6 Process',
                Org_ID__c = 'FAB 6',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab6Process;
            
            Process__c fab7Process = new Process__c(
                Name = 'FAB 7 Process',
                Org_ID__c = 'FAB 7',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab7Process;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_5__c = true;
            controller1.cusrForm.FAB_6__c = true;
            controller1.cusrForm.FAB_7__c = true;
            controller1.rightValues.add(fab5Process.Tech_Type__c+' '+fab5Process.Tech_Geometry__c);
            controller1.rightValues.add(fab6Process.Tech_Type__c+' '+fab6Process.Tech_Geometry__c);
            controller1.rightValues.add(fab7Process.Tech_Type__c+' '+fab7Process.Tech_Geometry__c);
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            //controller1.getRequestorEmail();
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'No';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.status__c = 'New';
            controller2.fab5Approver.No_of_Approvers__c = '5';
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.Approver3__c = notifyUser.Id;
            controller2.fab5Approver.Approver4__c = notifyUser.Id;
            controller2.fab5Approver.Approver5__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '5';
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.Approver3__c = notifyUser.Id;
            controller2.fab6Approver.Approver4__c = notifyUser.Id;
            controller2.fab6Approver.Approver5__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '5';
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.Approver3__c = notifyUser.Id;
            controller2.fab7Approver.Approver4__c = notifyUser.Id;
            controller2.fab7Approver.Approver5__c = notifyUser.Id;
            controller2.saveSingapore();
            controller2.singaporeSubmitForApproval();
            system.assertEquals(controller2.fab7Approver.Approver5__c,notifyUser.Id);
            test.stopTest();
            
        }
    }
    
    public static testMethod void testEssexJunction(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            Process__c fab9Process = new Process__c(
                Name = 'FAB 9 Process',
                Org_ID__c = 'FAB 9',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab9Process;
            
            Process__c fab10Process = new Process__c(
                Name = 'FAB 10 Process',
                Org_ID__c = 'FAB 10',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab10Process;
            
            Process__c asicProcess = new Process__c(
                Name = 'ASIC Process',
                Org_ID__c = 'ASIC',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert asicProcess;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(new CuSR_Form__c()));
            controller1.cusrForm.OwnerId = testUser.Id;
            controller1.cusrForm.Request_Received_Date__c = Date.today();
            controller1.cusrForm.FAB_9__c = true;
            controller1.cusrForm.FAB_10__c = true;
            controller1.cusrForm.ASIC__c = true;
            controller1.rightValues.add(fab9Process.Tech_Type__c+' '+fab9Process.Tech_Geometry__c);
            controller1.rightValues.add(fab10Process.Tech_Type__c+' '+fab10Process.Tech_Geometry__c);
            controller1.rightValues.add(asicProcess.Tech_Type__c+' '+asicProcess.Tech_Geometry__c);
            //controller1.cusrForm.Technology__c = 'CA 0.045UM';
            controller1.cusrForm.Customer_Name__c = testAccount.Id;
            controller1.cusrForm.System__c = 'CPK';
            controller1.customerReqId = testContact.Id;
            //controller1.cusrForm.Customer_Requestor__c = testContact.Id;
            controller1.cusrForm.Customer_Requestor_Email__c = testContact.Email;
            controller1.cusrForm.Notify_Customer_after_Implementation__c = 'No';
            controller1.cusrForm.Requested_Effective_Date__c = Date.today();
            controller1.cusrForm.Validity_Period_of_this_Request__c = 'EOL';
            controller1.cusrForm.Actual_Requirement__c = 'Test Requirement';
            controller1.cusrForm.Justification_for_Request__c = 'Test Justification';
            controller1.cusrForm.Scope_of_the_CuSR__c = 'RTP Parts';
            controller1.cusrForm.Is_this_a_one_time_requirement__c = 'Yes';
            controller1.cusrForm.Special_Requirement__c = 'Test Special Requirements';
            controller1.cusrForm.Customer_Specification_Name__c = 'Test Specification Name';
            controller1.searchUser = notifyUser.Name;
            //controller1.SearchUser();
            //controller1.leftSelectedUsers.add(notifyUser.Name);
            //controller1.selectUserClick();
            controller1.saveRecord();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c();
            testCuSRForm = controller1.cusrForm;
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Esx_Jun_System_Owner_Approval_Required__c ='Yes';
            controller2.essexJunctionSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.essexJunctionSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.essexJunctionSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.essexJunctionSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.essexJunctionSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.essexJunctionSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.essexJunctionSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab9Approver.No_of_Approvers__c = '5';
            controller2.fab9Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab9Approver.Approver1__c = notifyUser.Id;
            controller2.fab9Approver.Approver2__c = notifyUser.Id;
            controller2.fab9Approver.Approver3__c = notifyUser.Id;
            controller2.fab9Approver.Approver4__c = notifyUser.Id;
            controller2.fab9Approver.Approver5__c = notifyUser.Id;
            
            controller2.cusrForm.EastFishkillSystemOwnerApproval_Required__c ='Yes';
            controller2.eastFishkillSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.eastFishkillSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.eastFishkillSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.eastFishkillSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.eastFishkillSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.eastFishkillSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.eastFishkillSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.fab10Approver.No_of_Approvers__c = '5';
            controller2.fab10Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab10Approver.Approver1__c = notifyUser.Id;
            controller2.fab10Approver.Approver2__c = notifyUser.Id;
            controller2.fab10Approver.Approver3__c = notifyUser.Id;
            controller2.fab10Approver.Approver4__c = notifyUser.Id;
            controller2.fab10Approver.Approver5__c = notifyUser.Id;
            
            controller2.cusrForm.ASIC_System_Owner_Approval_Required__c ='Yes';
            controller2.asicSystemOwnerApproval.No_of_Approvers__c = '5';
            controller2.asicSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.asicSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.asicSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.asicSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.asicSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.asicSystemOwnerApproval.Approver5__c = notifyUser.Id;
            controller2.asicApprover.No_of_Approvers__c = '5';
            controller2.asicApprover.Do_you_require_approval_from_all_users__c = true;
            controller2.asicApprover.Approver1__c = notifyUser.Id;
            controller2.asicApprover.Approver2__c = notifyUser.Id;
            controller2.asicApprover.Approver3__c = notifyUser.Id;
            controller2.asicApprover.Approver4__c = notifyUser.Id;
            controller2.asicApprover.Approver5__c = notifyUser.Id;
            
            controller2.saveEssexJunction();
            controller2.essexJunctionSubmitForApproval();
            
            controller2.saveEastFishkill();
            controller2.eastFishkillSubmitForApproval();
            
            controller2.saveASIC();
            controller2.asicSubmitForApproval();
            test.stopTest();
            
            CuSR_Approval_Process__c sysAppr = controller2.essexJunctionSystemOwnerApproval;
            sysAppr.Status__c = 'Approved';
            update sysAppr;
            
            CuSR_Approval_Process__c sysAppr1 = controller2.eastFishkillSystemOwnerApproval;
            sysAppr1.Status__c = 'Approved';
            update sysAppr1;
            
            CuSR_Approval_Process__c sysAppr2 = controller2.asicSystemOwnerApproval;
            sysAppr2.Status__c = 'Approved';
            update sysAppr2;
            
            CuSR_Approval_Process__c fab9Appr = controller2.fab9Approver;
            fab9Appr.Status__c = 'Approved';
            update fab9Appr;
            
            CuSR_Approval_Process__c fab10Appr = controller2.fab10Approver;
            fab10Appr.Status__c = 'Approved';
            update fab10Appr;
            
            CuSR_Approval_Process__c asicAppr = controller2.asicApprover;
            asicAppr.Status__c = 'Approved';
            update asicAppr;
            System.assertEquals(controller1.cusrForm.FAB_9__c, TRUE);
            System.assertEquals(controller1.cusrForm.FAB_10__c, TRUE);
            System.assertEquals(controller1.cusrForm.ASIC__c, TRUE);
        }
    }
    
    public static testMethod void testEssexJunctionApprovals(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 9');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c fab9Process = new Process__c(
                Name = 'FAB 9 Process',
                Org_ID__c = 'FAB 9',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab9Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Essex_Junction_Ready_for_Approval__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Fab__c = 'FAB 9',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            capList.add(fab9Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableEssexJunctionSystemApprover1, TRUE);
            
            capList[0].No_of_Approvers__c = '2';
            capList[1].No_of_Approvers__c = '2';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEssexJunctionSystemApprover2, TRUE);
            
            capList[0].No_of_Approvers__c = '3';
            capList[1].No_of_Approvers__c = '3';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEssexJunctionSystemApprover3, TRUE);
            
            test.stopTest();
            
        }
    }
    
    public static testMethod void testEssexJunctionApprovals1(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 9');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c fab9Process = new Process__c(
                Name = 'FAB 9 Process',
                Org_ID__c = 'FAB 9',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab9Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Essex_Junction_Ready_for_Approval__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'Essex Junction',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'Essex Junction',
                Fab__c = 'FAB 9',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            capList.add(fab9Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableEssexJunctionSystemApprover4, TRUE);
            
            capList[0].No_of_Approvers__c = '5';
            capList[1].No_of_Approvers__c = '5';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEssexJunctionSystemApprover5, TRUE);
            
            capList[0].No_of_Approvers__c = '';
            capList[1].No_of_Approvers__c = '';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            
            test.stopTest();
            
        }
    }
    
    public static testMethod void testEastFishkillApprovals(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 10');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c fab10Process = new Process__c(
                Name = 'FAB 10 Process',
                Org_ID__c = 'FAB 10',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab10Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_10__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                East_Fishkill_Ready_for_Approval__c = true,
                EastFishkillSystemOwnerApproval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Fab__c = 'FAB 10',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            capList.add(fab10Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableEastFishkillSystemApprover1, TRUE);
            
            capList[0].No_of_Approvers__c = '2';
            capList[1].No_of_Approvers__c = '2';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEastFishkillSystemApprover2, TRUE);
            
            capList[0].No_of_Approvers__c = '3';
            capList[1].No_of_Approvers__c = '3';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEastFishkillSystemApprover3, TRUE);
            
            test.stopTest();
        }
    }
    
    public static testMethod void testEastFishkillApprovals1(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 10');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c fab10Process = new Process__c(
                Name = 'FAB 10 Process',
                Org_ID__c = 'FAB 10',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab10Process;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_10__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                East_Fishkill_Ready_for_Approval__c = true,
                EastFishkillSystemOwnerApproval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'East Fishkill',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'East Fishkill',
                Fab__c = 'FAB 10',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            capList.add(fab10Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableEastFishkillSystemApprover4, TRUE);
            
            capList[0].No_of_Approvers__c = '5';
            capList[1].No_of_Approvers__c = '5';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableEastFishkillSystemApprover5, TRUE);
            
            capList[0].No_of_Approvers__c = '';
            capList[1].No_of_Approvers__c = '';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            
            test.stopTest();
        }
    }
    
    public static testMethod void testASICApprovals(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'ASIC');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c asicProcess = new Process__c(
                Name = 'ASIC Process',
                Org_ID__c = 'ASIC',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert asicProcess;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                ASIC_Ready_for_Approval__c = true,
                ASIC_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Fab__c = 'ASIC',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'ASIC Owner'
            );
            capList.add(fab10Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableASICSystemApprover1, TRUE);
            
            capList[0].No_of_Approvers__c = '2';
            capList[1].No_of_Approvers__c = '2';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableASICSystemApprover2, TRUE);
            
            capList[0].No_of_Approvers__c = '3';
            capList[1].No_of_Approvers__c = '3';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableASICSystemApprover3, TRUE);
            
            test.stopTest();
        }
    }
    
    public static testMethod void testASICApprovals1(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'test@email.com'
            );
            insert testContact;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'ASIC');  
            insert ceUser1;
            
            insert teamProxyList;
            
            Process__c asicProcess = new Process__c(
                Name = 'ASIC Process',
                Org_ID__c = 'ASIC',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert asicProcess;
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                ASIC__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c ='Yes',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                ASIC_Ready_for_Approval__c = true,
                ASIC_System_Owner_Approval_Required__c = 'Yes',
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'ASIC',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            capList.add(systemApproval);
            
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '4',
                Site__c = 'ASIC',
                Fab__c = 'ASIC',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'ASIC Owner'
            );
            capList.add(fab10Approval);
            insert capList;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.deleteFeedAttachment();
            System.assertEquals(controller.enableASICSystemApprover4, TRUE);
            
            capList[0].No_of_Approvers__c = '5';
            capList[1].No_of_Approvers__c = '5';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.enableASICSystemApprover5, TRUE);
            
            capList[0].No_of_Approvers__c = '';
            capList[1].No_of_Approvers__c = '';
            update capList;
            controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            
            test.stopTest();
        }
    }
}