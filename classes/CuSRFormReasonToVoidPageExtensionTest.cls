/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormReasonToVoidPageExtension.
History:
SNair     24042015     - code creation
SNair     29042015     - code creation
*/
@isTest(SeeAllData=false)
public with sharing class CuSRFormReasonToVoidPageExtensionTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static testMethod void myUnitTest1(){
        User testUser = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
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
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
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
                OwnerId = testUser.Id,
                Status__c = 'Pending Implementation',
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = date.today(),
                PM_Approved__c = true,
                AM_Approved__c = true,
                CEsInformed__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No'
            );
            test.startTest();
            insert testCuSRForm;
            
            CuSR_Approval_Process__c approval1 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Site__c = 'Dresden',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert approval1;
            
            CuSR_Approval_Process__c approval2 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert approval2;
            
            CuSR_Approval_Process__c approval3 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert approval3;
            
            CuSR_Approval_Process__c approval3e = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3E',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert approval3e;
            
            CuSR_Approval_Process__c approval5 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 5',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert approval5;
            
            CuSR_Approval_Process__c approval6 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 6',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert approval6;
            
            CuSR_Approval_Process__c approval7 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 7',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert approval7;
            
            CuSR_Approval_Process__c approval8 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Site__c = 'Malta',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert approval8;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            insert amApproval;
            
            CuSR_Cost__c testCuSRCost1 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Site__c = 'Dresden',
                Labour_Cost__c = cusrLabourCostSetting.get('Dresden').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost1;
            
            CuSR_Cost__c testCuSRCost2 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost2;
            
            CuSR_Cost__c testCuSRCost3 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 3,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 30,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost3;
            
            CuSR_Cost__c testCuSRCost3E = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3E',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 3,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 30,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost3E;
            
            CuSR_Cost__c testCuSRCost5 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 5',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost5;
            
            CuSR_Cost__c testCuSRCost6 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 6',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost6;
            
            CuSR_Cost__c testCuSRCost7 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 7',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost7;
            
            CuSR_Cost__c testCuSRCost8 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Site__c = 'Malta',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost8;
            
            CuSR_Notification_Group__c notification = new CuSR_Notification_Group__c(
                CuSR_Form__c =  testCuSRForm.Id,
                User__c = testUser.Id,
                User_Name__c = testUser.Name         
            );
            insert notification;
            
            
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormReasonToVoidForm'));
            system.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm.Id);
            CuSRFormReasonToVoidPageExtension controller = new CuSRFormReasonToVoidPageExtension();
            controller.cusrForm.Reason_to_Void__c = 'Voided';
            controller.submitToVoidForm();  
            test.stopTest();
        }
    }
    
    public static testMethod void myUnitTest2(){
        User testUser = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
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
                OwnerId = testUser.Id,
                Status__c = 'Pending Implementation',
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = date.today(),
                PM_Approved__c = true,
                AM_Approved__c = true,
                CEsInformed__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No'
            );
            
            Test.startTest();
            insert testCuSRForm;
            
            CuSR_Approval_Process__c approval1 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Site__c = 'Dresden',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert approval1;
            
            CuSR_Approval_Process__c approval2 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert approval2;
            
            CuSR_Approval_Process__c approval3 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert approval3;
            
            CuSR_Approval_Process__c approval3e = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3E',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert approval3e;
            
            CuSR_Approval_Process__c approval5 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 5',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert approval5;
            
            CuSR_Approval_Process__c approval6 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 6',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert approval6;
            
            CuSR_Approval_Process__c approval7 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 7',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert approval7;
            
            CuSR_Approval_Process__c approval8 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Site__c = 'Malta',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert approval8;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                Approved__c = true,
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            insert amApproval;
            
            CuSR_Cost__c testCuSRCost1 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Site__c = 'Dresden',
                Labour_Cost__c = cusrLabourCostSetting.get('Dresden').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost1;
            
            CuSR_Cost__c testCuSRCost2 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost2;
            
            CuSR_Cost__c testCuSRCost3 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 3,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 30,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost3;
            
            CuSR_Cost__c testCuSRCost3E = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 3E',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 3,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 30,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost3E;
            
            CuSR_Cost__c testCuSRCost5 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 5',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost5;
            
            CuSR_Cost__c testCuSRCost6 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 6',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost6;
            
            CuSR_Cost__c testCuSRCost7 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 7',
                Site__c = 'Singapore',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost7;
            
            CuSR_Cost__c testCuSRCost8 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Site__c = 'Malta',
                Labour_Cost__c = cusrLabourCostSetting.get('Singapore').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            insert testCuSRCost8;
            
            CuSR_Notification_Group__c notification = new CuSR_Notification_Group__c(
                CuSR_Form__c =  testCuSRForm.Id,
                User__c = testUser.Id,
                User_Name__c = testUser.Name         
            );
            insert notification;
            system.assertEquals(notification.User__c, testUser.Id);
            //test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormReasonToVoidForm'));
            system.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm.Id);
            CuSRFormReasonToVoidPageExtension controller = new CuSRFormReasonToVoidPageExtension();
            controller.selectFabs = 'FAB 2; FAB 3; E; FAB 5; FAB 6; FAB 7';
            controller.cusrVoidForSelectedFab.Reason_to_Void__c = 'Voided';
            controller.submitSelectedFabsToVoid();  
            test.stopTest();
        }
    }
    
    public static testMethod void myUnitTest3(){
        User testUser = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 9; FAB 10; ASIC', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Essex Junction', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'East Fishkill', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'ASIC', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                FAB_9_Void__c = false,
                FAB_10_Void__c = false,
                ASIC_Void__c = false,
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
                OwnerId = testUser.Id,
                Status__c = 'Pending Implementation',
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = date.today(),
                PM_Approved__c = true,
                AM_Approved__c = true,
                CEsInformed__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No'
            );
            test.startTest();
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c approvalFab9 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            capList.add(approvalFab9);
            
            CuSR_Approval_Process__c approvalFab10 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            capList.add(approvalFab10);
            
            CuSR_Approval_Process__c approvalFabASIC = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Status__c = 'Approved',
                Type_of_Approver__c = 'ASIC Owner'
            );
            capList.add(approvalFabASIC);
            
            CuSR_Approval_Process__c amApprovalFab9 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalFab9);
            
            CuSR_Approval_Process__c amApprovalFab10 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalFab10);
            
            CuSR_Approval_Process__c amApprovalASIC = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalASIC);
            insert capList;
            
            List<CuSR_Cost__c> cusrCostList = new List<CuSR_Cost__c>();
            CuSR_Cost__c cuSRCostFab9 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Labour_Cost__c = cusrLabourCostSetting.get('Essex Junction').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(cuSRCostFab9);
            
            CuSR_Cost__c cuSRCostFab10 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Labour_Cost__c = cusrLabourCostSetting.get('East Fishkill').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(cuSRCostFab10);
            
            CuSR_Cost__c cuSRCostASIC = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Labour_Cost__c = cusrLabourCostSetting.get('ASIC').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cusrCostList.add(cuSRCostASIC);
            insert cusrCostList;
            
            CuSR_Notification_Group__c notification = new CuSR_Notification_Group__c(
                CuSR_Form__c =  testCuSRForm.Id,
                User__c = testUser.Id,
                User_Name__c = testUser.Name         
            );
            insert notification;
            
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormReasonToVoidForm'));
            System.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm.Id);
            CuSRFormReasonToVoidPageExtension controller = new CuSRFormReasonToVoidPageExtension();
            controller.cusrForm.Reason_to_Void__c = 'Voided';
            controller.submitToVoidForm();  
            System.assertEquals(controller.availableFabs , 3);
            
            test.stopTest();
        }
    }
    
    public static testMethod void myUnitTest4(){
        User testUser = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 9; FAB 10; ASIC', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            List<CuSR_Labour_Cost_Settings__c> cusrLabourCostList = new List<CuSR_Labour_Cost_Settings__c>();
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Dresden', Labour_Cost__c = 45.19230769));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Singapore', Labour_Cost__c = 37.01923077));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Malta', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'Essex Junction', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'East Fishkill', Labour_Cost__c = 61.05769231));
            cusrLabourCostList.add(new CuSR_Labour_Cost_Settings__c(Name = 'ASIC', Labour_Cost__c = 61.05769231));
            insert cusrLabourCostList;
            
            Map<String, CuSR_Labour_Cost_Settings__c> cusrLabourCostSetting = CuSR_Labour_Cost_Settings__c.getAll();
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
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
                OwnerId = testUser.Id,
                Status__c = 'Pending Implementation',
                Essex_Junction_Ready_for_Approval__c = true,
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = date.today(),
                PM_Approved__c = true,
                AM_Approved__c = true,
                CEsInformed__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_System_Owner_Approval_Required__c = 'No'
            );
            
            Test.startTest();
            insert testCuSRForm;
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c approval9 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            capList.add(approval9);
            
            CuSR_Approval_Process__c approval10 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            capList.add(approval10);
            
            CuSR_Approval_Process__c approvalASIC = new CuSR_Approval_Process__c(
                Approved__c = true,
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = false,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Status__c = 'Approved',
                Type_of_Approver__c = 'ASIC Owner'
            );
            capList.add(approvalASIC);
            
            CuSR_Approval_Process__c amApprovalFab9 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalFab9);
            
            CuSR_Approval_Process__c amApprovalFab10 = new CuSR_Approval_Process__c(
                Approved__c = true,
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalFab10);
            
            CuSR_Approval_Process__c amApprovalASIC = new CuSR_Approval_Process__c(
                Approved__c = true,
                Am_Info_Added__c = true,
                Approver1__c = amUser.Id,
                Approver2__c = amUser.Id,
                Approver3__c = amUser.Id,
                Approver4__c = amUser.Id,
                Approver5__c = amUser.Id,
                Do_you_require_approval_from_all_users__c = false,
                AM_Approved_By__c = amUser.Id,
                AM_Approved_On__c = date.today(),
                Comments__c = 'Test Comments',
                Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes',
                Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes',
                Pricing_quote_reference_number__c = 'test reference no',
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            capList.add(amApprovalASIC);
            insert capList;
            
            List<CuSR_Cost__c> cuSRCostList = new List<CuSR_Cost__c>();
            CuSR_Cost__c testCuSRCost9 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 9',
                Site__c = 'Essex Junction',
                Labour_Cost__c = cusrLabourCostSetting.get('Essex Junction').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cuSRCostList.add(testCuSRCost9);
            
            CuSR_Cost__c testCuSRCost10 = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 10',
                Site__c = 'East Fishkill',
                Labour_Cost__c = cusrLabourCostSetting.get('East Fishkill').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cuSRCostList.add(testCuSRCost10);
            
            CuSR_Cost__c testCuSRCostASIC = new CuSR_Cost__c(
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'ASIC',
                Site__c = 'ASIC',
                Labour_Cost__c = cusrLabourCostSetting.get('ASIC').Labour_Cost__c,
                Labour_Hours__c = 2,
                Comments_Labour_Cost__c = 'Sample',
                Software_Cost__c = 15,
                Comments_Software_Cost__c = 'Sample',
                Hardware_Cost__c = 20,
                Comments_Hardware_Cost__c  = 'Sample',
                Other_Cost__c = 5,
                Comments_Other_Cost__c = 'Sample',
                Implementation__c = Date.newInstance(2015,1,26),
                Implementation_Comments__c = 'Test'
            );
            cuSRCostList.add(testCuSRCostASIC);
            insert cuSRCostList;
            
            CuSR_Notification_Group__c notification = new CuSR_Notification_Group__c(
                CuSR_Form__c =  testCuSRForm.Id,
                User__c = testUser.Id,
                User_Name__c = testUser.Name         
            );
            insert notification;
            
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormReasonToVoidForm'));
            system.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm.Id);
            CuSRFormReasonToVoidPageExtension controller = new CuSRFormReasonToVoidPageExtension();
            controller.selectFabs = 'FAB 9; FAB 10; ASIC';
            controller.cusrVoidForSelectedFab.Reason_to_Void__c = 'Voided';
            controller.submitSelectedFabsToVoid();  
            
            System.assertEquals(controller.fab9CEUser , TRUE);
            System.assertEquals(controller.fab10CEUser , TRUE);
            System.assertEquals(controller.asicCEUser , TRUE);
            test.stopTest();
        }
    }
}