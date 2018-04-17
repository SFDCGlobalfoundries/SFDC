/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormExtension class.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormExtensionTest4 {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void testNotification(){
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
            controller.searchUser = searchUser1.Name; 
            controller.SearchUser();
            controller.searchUser = searchUser2.Name; 
            controller.SearchUser();
            controller.leftSelectedUsers.add(searchUser1.Name);
            controller.leftSelectedUsers.add(searchUser2.Name);
            List<SelectOption> temp1 = controller.getSelectedUserValues();
            controller.selectUserClick();
            controller.rightSelectedUsers.add(searchUser2.Name);
            List<SelectOption> temp2 = controller.getunSelectedUserValues();
            controller.unselectUserClick();
            controller.saveRecord();  
            
            test.stopTest();       
        }
    }
    
    public static testMethod void testDelNotification(){
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
            
            CuSR_Notification_Group__c group1 = new CuSR_Notification_Group__c(
                CuSR_Form__c = testCuSRForm.Id,
                User__c = searchUser1.Id,
                User_Name__c = searchUser1.Name
            );
            insert group1;
            
            CuSR_Notification_Group__c group2 = new CuSR_Notification_Group__c(
                CuSR_Form__c = testCuSRForm.Id,
                User__c = searchUser2.Id,
                User_Name__c = searchUser2.Name
            );
            insert group2; 
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.memberId = group1.Id;
            controller.delRowFromNotificationGroupList();
            test.stopTest();
        }
    }
    
    public static testMethod void testLoginAfterImplementation(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
            //User searchUser2 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :searchUser1.Id limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser2.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            //test.startTest();
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
                Additional_FAB_2__c = true,
                Additional_FAB_3__c = true,
                Additional_FAB_3E__c = true,
                Additional_FAB_5__c = true,
                Additional_FAB_6__c = true,
                Additional_FAB_7__c = true,
                Additional_FAB_8__c = true,
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
                Customer_Specification_Name__c = 'sample',
                Dresden_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_Ready_for_Approval__c = true,
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Ready_for_Approval__c = true,
                Singapore_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
        
            CuSR_Approval_Process__c fab2Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 2',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 2 Owner'
            );
            insert fab2Approval;
        
            CuSR_Approval_Process__c fab3Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3 Owner'
            );
            insert fab3Approval;
        
        CuSR_Approval_Process__c fab3EApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 3E',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 3E Owner'
            );
            insert fab3EApproval;
        
        CuSR_Approval_Process__c fab5Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 5',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 5 Owner'
            );
            insert fab5Approval;
        
        CuSR_Approval_Process__c fab6Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Singapore',
                Fab__c = 'FAB 6',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 6 Owner'
            );
            insert fab6Approval;
        
            CuSR_Approval_Process__c fab7Approval = new CuSR_Approval_Process__c(
                    Approver1__c = testUser.Id,
                    CuSR_Form__c = testCuSRForm.Id,
                    No_of_Approvers__c = '1',
                    Site__c = 'Singapore',
                    Fab__c = 'FAB 7',
                    Status__c = 'Approved',
                    Type_of_Approver__c = 'FAB 7 Owner'
                );
                insert fab7Approval;
        
            CuSR_Approval_Process__c fab8Approval = new CuSR_Approval_Process__c(
                    Approver1__c = testUser.Id,
                    CuSR_Form__c = testCuSRForm.Id,
                    No_of_Approvers__c = '1',
                    Site__c = 'Malta',
                    Fab__c = 'FAB 8',
                    Status__c = 'Approved',
                    Type_of_Approver__c = 'FAB 8 Owner'
                );
                insert fab8Approval;
            
        system.runAs(searchUser1){
          test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            test.stopTest();         
        }
            
    }
    
    public static testMethod void testPMApproval(){
        Set<Id> userIds = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        Group pmGroup = [select Type, Id, Name from Group where Type =: 'QUEUE' and Name ='CuSR PM Queue'];
        for(GroupMember m: [select Id, UserOrGroupId, GroupId from GroupMember where GroupId =: pmGroup.Id]){
                if(((String)m.UserOrGroupId).startsWith(userType)){
                        userIds.add(m.UserOrGroupId);
                }
        }
        
        User testUser = [select Id from User where Id IN: userIds and isActive = true limit 1];
        
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
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
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
                Customer_Specification_Name__c = 'Sample Name',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.cusrForm.Any_Cost_Impact__c = 'Yes';
            controller.pmApproved();
            controller.pmRejected();
            controller.cusrForm.Any_Cost_Impact__c = 'Yes';
            controller.cusrForm.PM_Comments__c = 'sample comments';
            controller.pmApproved();
            
            test.stopTest();        
        }
    }
    
    public static testMethod void testUpdateCUSR(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
            //User searchUser2 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :searchUser1.Id limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser2.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            //test.startTest();
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
                Additional_FAB_2__c = true,
                Additional_FAB_3__c = true,
                Additional_FAB_3E__c = true,
                Additional_FAB_5__c = true,
                Additional_FAB_6__c = true,
                Additional_FAB_7__c = true,
                Additional_FAB_8__c = true,
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
                Customer_Specification_Name__c = 'sample',
                Dresden_Ready_for_Approval__c = true,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_Ready_for_Approval__c = true,
                Malta_System_Owner_Approval_Required__c = 'No',
                Singapore_Ready_for_Approval__c = true,
                Singapore_System_Owner_Approval_Required__c = 'No',
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller1.cusrForm.Remark__c = 'Updated cusr.';
            controller1.cancelUpdateCUSR();
            
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller2.cusrForm.Remark__c = 'Updated cusr.';
            controller2.saveUpdatedCUSR();

            test.stopTest();   
        }
    }
    
    public static testMethod void testNotifyCEsAfterSubmission(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
        system.runAs(testUser){
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
                Customer_Specification_Name__c = 'sample',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Status__c = 'New',
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
        
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.dresdenSubmitForApproval();
            test.stopTest();
        }
    }
    
    public static testMethod void testNotifyAfterSubmissionWithoutCEs(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
        system.runAs(testUser){
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            //User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            /*List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;*/
            
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
                Customer_Specification_Name__c = 'sample',
                Dresden_System_Owner_Approval_Required__c = 'No',
                Status__c = 'New',
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c fab1Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Dresden',
                Fab__c = 'FAB 1',
                Status__c = 'New',
                Type_of_Approver__c = 'FAB 1 Owner'
            );
            insert fab1Approval;
        
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            controller.dresdenSubmitForApproval();
            test.stopTest();
        }
    }
    
    public static testMethod void testLoginAfterImplementation2(){
            User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            
            User searchUser1 = [select Id, Name from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
            //User searchUser2 = [select Id, Name from User where Profile.Name = 'GF CE' and isActive = true and Id != :searchUser1.Id limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 9; FAB 10; ASIC', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = searchUser2.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            insert teamProxyList;
            
            //test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                Additional_FAB_9__c = true,
                Additional_FAB_10__c = true,
                Additional_ASIC__c = true,
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
                Customer_Specification_Name__c = 'sample',
                Essex_Junction_Ready_for_Approval__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                East_Fishkill_Ready_for_Approval__c = true,
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                ASIC_Ready_for_Approval__c = true,
                ASIC_System_Owner_Approval_Required__c = 'No',
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                Status__c = 'Implemented',
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c fab9Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'Essex Junction',
                Fab__c = 'FAB 9',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 9 Owner'
            );
            insert fab9Approval;
        
            CuSR_Approval_Process__c fab10Approval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'East Fishkill',
                Fab__c = 'FAB 10',
                Status__c = 'Approved',
                Type_of_Approver__c = 'FAB 10 Owner'
            );
            insert fab10Approval;
        
            CuSR_Approval_Process__c asicApproval = new CuSR_Approval_Process__c(
                Approver1__c = testUser.Id,
                CuSR_Form__c = testCuSRForm.Id,
                No_of_Approvers__c = '1',
                Site__c = 'ASIC',
                Fab__c = 'ASIC',
                Status__c = 'Approved',
                Type_of_Approver__c = 'ASIC Owner'
            );
            insert asicApproval;
            
            system.runAs(searchUser1){
            test.startTest();
            CuSRFormExtension controller = new CuSRFormExtension(new ApexPages.standardController(testCuSRForm));
            System.assertEquals(controller.cusrForm.FAB_9__c, TRUE);
            System.assertEquals(controller.cusrForm.FAB_10__c, TRUE);
            System.assertEquals(controller.cusrForm.ASIC__c, TRUE);
            test.stopTest();         
        }
            
    }
}