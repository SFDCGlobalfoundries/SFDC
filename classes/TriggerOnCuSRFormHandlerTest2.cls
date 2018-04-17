/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRForm trigger.
History:
SNair     29042015     - code created.
*/
@isTest(SeeAllData=false)
public with sharing class TriggerOnCuSRFormHandlerTest2 {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod1(){
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
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            /*User pmUser = [select Id from User where Profile.Name = 'GF Product Marketing' and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];*/
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
                //FAB_9__c = true,
               // FAB_10__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
               //FAB_9_Void__c = false,
              //  FAB_10_Void__c = false,
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
                /*Status__c = 'Pending Implementation',
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
                Malta_System_Owner_Approval_Required__c = 'No'*/
                Status__c = 'Pending Stakeholder Review',
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c approval1 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert approval1;
            
            CuSR_Approval_Process__c approval2 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert approval2;
            
            CuSR_Approval_Process__c approval3 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert approval3;
            
            CuSR_Approval_Process__c approval3e = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert approval3e;
            
            CuSR_Approval_Process__c approval5 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert approval5;
            
            CuSR_Approval_Process__c approval6 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert approval6;
            
            CuSR_Approval_Process__c approval7 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 7 Owner'
            );
            insert approval7;
            
            CuSR_Approval_Process__c approval8 = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Status__c = 'Pending',
                Type_of_Approver__c = 'FAB 8 Owner'
            );
            insert approval8;
            
            test.startTest();
            testCuSRForm.Fifth_Day_Reminder__c = true;
            update testCuSRForm;
            testCuSRForm.Ninth_Day_Reminder__c = true;
            update testCuSRForm;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod2(){
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
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            //User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
               // FAB_9__c = true,
            //    FAB_10__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
                //FAB_9_Void__c = false,
               // FAB_10_Void__c = false,
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
                /*Status__c = 'Pending Implementation',
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
                Malta_System_Owner_Approval_Required__c = 'No'*/
                Status__c = 'Pending PM Review',
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No'
            );
            insert testCuSRForm;
            
            test.startTest();
            testCuSRForm.Fifth_Day_Reminder__c = true;
            update testCuSRForm;
            testCuSRForm.Ninth_Day_Reminder__c = true;
            update testCuSRForm;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod3(){
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
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
              // FAB_9__c = true,
              //  FAB_10__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
              //  FAB_9_Void__c = false,
             //   FAB_10_Void__c = false,
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
                /*Status__c = 'Pending Implementation',
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
                Malta_System_Owner_Approval_Required__c = 'No'*/
                Status__c = 'Pending AM Review',
                Dresden_Ready_for_Approval__c = true,
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = date.today(),
                PM_Approved__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                Approved__c = false,
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
                Site__c = 'Singapore',
                Status__c = 'Pending',
                Type_of_Approver__c = 'AM'
            );
            insert amApproval;
            
            test.startTest();
            testCuSRForm.Fifth_Day_Reminder__c = true;
            update testCuSRForm;
            testCuSRForm.Ninth_Day_Reminder__c = true;
            update testCuSRForm;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod4(){
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
            
            User user1 = [select Id from User where Id !=: testUser.Id and Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
            User pmUser = [select Id from User where (Profile.Name = 'GF Product Management' or Profile.Name = 'GF Product Marketing') and isActive = true limit 1];
            //User amUser = [select Id from User where Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = user1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
              //  FAB_9__c = true,
              //  FAB_10__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
             //   FAB_9_Void__c = false,
              //  FAB_10_Void__c = false,
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
                /*Status__c = 'Pending Implementation',
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
                Malta_System_Owner_Approval_Required__c = 'No'*/
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
            insert testCuSRForm;
            
            CuSR_Implementation__c testImplementation1 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation1;
            
            CuSR_Implementation__c testImplementation2 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 2',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation2;
            
            CuSR_Implementation__c testImplementation3 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 3',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation3;
            
            CuSR_Implementation__c testImplementation3e = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 3E',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation3e;
            
            CuSR_Implementation__c testImplementation5 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 5',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation5;
            
            CuSR_Implementation__c testImplementation6 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 6',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation6;
            
            CuSR_Implementation__c testImplementation7 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 7',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation7;
            
            CuSR_Implementation__c testImplementation8 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = user1.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 8',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Pending'
            );
            insert testImplementation8;
            
            test.startTest();
            testCuSRForm.Fifth_Day_Reminder__c = true;
            update testCuSRForm;
            testCuSRForm.Ninth_Day_Reminder__c = true;
            update testCuSRForm;
            test.stopTest();
        }
    }
}