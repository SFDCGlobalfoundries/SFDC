/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRForm trigger.
History:
SNair     10012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class TriggerOnCuSRFormHandlerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static testMethod void myTestMethod1(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        
        system.runAs(testUser){
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
                FAB_2__c = false,
                FAB_3__c = false,
                FAB_3E__c = false,
                FAB_5__c = false,
                FAB_6__c = false,
                FAB_7__c = false,
                FAB_8__c = false,
                //FAB_9__c = false,
                //FAB_10__c = false,
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
                Scope__c = 'FAB 1',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User notificationUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            CuSR_Notification_Group__c notificationGroupUser = new CuSR_Notification_Group__c();
            notificationGroupUser.User__c = notificationUser.Id;
            notificationGroupUser.User_Name__c = notificationUser.Name;
            notificationGroupUser.CuSR_Form__c = testCuSRForm.Id;
            insert notificationGroupUser;
            
            test.startTest();
            testCuSRForm.Status__c = 'Implemented';
            update testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            testCuSRForm.FAB_8__c = true;
            //testCuSRForm.FAB_9__c = true;
            //testCuSRForm.FAB_10__c = true;
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
                //FAB_10__c = true,
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
                Customer_Specification_Name__c = 'sample',
                Status__c = 'New'
            );
            insert testCuSRForm;
            test.stopTest();
        }
        
    }
    
    public static testMethod void myTestMethod3(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<User> ceUsers = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 5];
            
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
            insert testCuSRForm;
            
            CuSR_Approval_Process__c systemApproval = new CuSR_Approval_Process__c(
                Approver1__c = ceUsers[0].Id,
                Approver2__c = ceUsers[1].Id,
                Approver3__c = ceUsers[2].Id,
                Approver4__c = ceUsers[3].Id,
                Approver5__c = ceUsers[4].Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Status__c = 'Pending Approval',
                Type_of_Approver__c = 'System Owner'
            );
            insert systemApproval;
            
            test.startTest();
            
            testCuSRForm.Seventh_Day_Reminder_to_System_Owner__c = true;
            update testCuSRForm;
            
            test.stopTest();
        }
    }
    
    
    
    public static testMethod void myTestMethod5(){
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
            
            List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }
            
            insert teamProxyList;
            
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
                Stakeholder_Approval_Completed__c = true,
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            update testCuSRForm;
            test.startTest();
            testCuSRForm.PM_Approved__c = true;
            testCuSRForm.Any_Cost_Impact__c = 'No';
            testCuSRForm.PM_Comments__c = 'Sample';
           // testCuSRForm.Status__c = 'Implemented';
            //update testCuSRForm;
            test.stopTest();
            
        }

    }    
   
    
    public static testMethod void myTestMethod6(){
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
            
            /*List<User> amUserList = new List<User>();
            amUserList = [select Id from User where Profile.Name = 'GF Sales Team' and isActive = true limit 5];*/
            
            User ceUserList1 = new User();
            ceUserList1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Fab_Assigned__c != '' limit 1];
            
            User ceUserList2 = new User();
            ceUserList2 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Id != :userInfo.getUserId() and Id != :ceUserList1.Id and Fab_Assigned__c != '' limit 1];
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            
            /*for(User amUser: amUserList){
                teamProxyList.add(new Account_Team_Proxy__c(User__c = amUser.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));   
            }*/
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E');  
            insert ceUser1;
            Account_Team_Proxy__c ceUser2 = new Account_Team_Proxy__c(User__c = ceUserList2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 5; FAB 6; FAB 7; FAB 8');
            insert ceUser2;
            
            //insert teamProxyList;
            
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
             //   FAB_10__c = true,
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
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                PM_Approved_By__c = pmUser.Id,
                PM_Approved_On__c = Date.newInstance(2015,1,31),
                Any_Cost_Impact__c = 'Yes',
                PM_Comments__c = 'Sample',
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm;
            
            CuSR_Notification_Group__c notificationGroupUser = new CuSR_Notification_Group__c();
            notificationGroupUser.User__c = testUser.Id;
            notificationGroupUser.User_Name__c = testUser.Name;
            notificationGroupUser.CuSR_Form__c = testCuSRForm.Id;
            insert notificationGroupUser;
            
            CuSR_Approval_Process__c approval1 = new CuSR_Approval_Process__c(
                Approved__c = true,
                No_of_Approvers__c = '5',
                Approver1__c = user1.Id,
                Approver2__c = user1.Id,
                Approver3__c = user1.Id,
                Approver4__c = user1.Id,
                Approver5__c = user1.Id,
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Do_you_require_approval_from_all_users__c = true,
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
                Site__c = 'Singapore',
                Status__c = 'Approved',
                Type_of_Approver__c = 'AM'
            );
            insert amApproval;
    
            
            test.startTest();
            testCuSRForm.Status__c = 'Implemented';
            update testCuSRForm;
            TriggerOnCuSRFormHandler hr=new TriggerOnCuSRFormHandler();
            hr.updateCuSRAfterPMApproval(testCuSRForm.Id+'');
             //testCuSRForm.Status__c = 'Pending ';
            
            test.stopTest();
            
        }
    }
    
    public static testMethod void myTestMethod7(){
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
            
            Account_Team_Proxy__c ceUser1 = new Account_Team_Proxy__c(User__c = ceUserList1.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E');  
            insert ceUser1;
            Account_Team_Proxy__c ceUser2 = new Account_Team_Proxy__c(User__c = ceUserList2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer', Fab_Assignment__c = 'FAB 5; FAB 6; FAB 7; FAB 8');
            insert ceUser2;
            
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
                Singapore_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Singapore_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                PM_Comments__c = 'Sample',
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            CuSR_Notification_Group__c notificationGroupUser = new CuSR_Notification_Group__c();
            notificationGroupUser.User__c = testUser.Id;
            notificationGroupUser.User_Name__c = testUser.Name;
            notificationGroupUser.CuSR_Form__c = testCuSRForm.Id;
            insert notificationGroupUser;
            
            test.startTest();
            testCuSRForm.Remark__c = 'Updated CUSR';
            update testCuSRForm;
            testCuSRForm.Any_Cost_Impact__c='No';
            update testCuSRForm;
            test.stopTest();
            
        }
    }

}