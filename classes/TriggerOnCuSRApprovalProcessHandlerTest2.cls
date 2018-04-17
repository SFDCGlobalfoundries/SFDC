/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRApprovalProcess trigger.
History:
SNair     10012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class TriggerOnCuSRApprovalProcessHandlerTest2 {


    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

public static testMethod void myTestMethod4(){


    
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
           // teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8;FAB 9;FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
           teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
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
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            CuSR_Form__c testCuSRForm1 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_8__c = true,
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
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Pending Implementation'
            );
            insert testCuSRForm1;
            
            testCuSRForm1.FAB_2__c = true;
            testCuSRForm1.FAB_3__c = true;
            testCuSRForm1.FAB_3E__c = true;
            testCuSRForm1.FAB_5__c = true;
            testCuSRForm1.FAB_6__c = true;
            testCuSRForm1.FAB_7__c = true;
            update testCuSRForm1;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
           CuSR_Approval_Process__c fab7Approver1 = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver1;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;  
            
            testCuSRForm1.Singapore_Ready_for_Approval__c = true;
            testCuSRForm1.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm1.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm1;                                                                                                                                                                                                                                                                                                                              
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab2Approver.Status__c = 'Rejected';
            fab2Approver.Approved__c = false;
            update fab2Approver;
            
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod5(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
                //FAB_9_Void__c = false,
                //FAB_10_Void__c = false,
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
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab3Approver.Status__c = 'Rejected';
            fab3Approver.Approved__c = false;
                update fab3Approver;
            
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod6(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
              teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));

            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
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
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab3eApprover.Status__c = 'Rejected';
            fab3eApprover.Approved__c = false;
                update fab3eApprover;
            
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod7(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
              teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));

            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
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
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab5Approver.Status__c = 'Rejected';
            fab5Approver.Approved__c = false;
                update fab5Approver;
           
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod8(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
               // FAB_9_Void__c = false,
               // FAB_10_Void__c = false,
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
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab6Approver.Status__c = 'Rejected';
            fab6Approver.Approved__c = false;
                update fab6Approver;
            
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod9(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                FAB_8__c = true,
                FAB_1_Void__c = false,
                FAB_2_Void__c = false,
                FAB_3_Void__c = false,
                FAB_3E_Void__c = false,
                FAB_5_Void__c = false,
                FAB_6_Void__c = false,
                FAB_7_Void__c = false,
                FAB_8_Void__c = false,
              //  FAB_9_Void__c = false,
              //  FAB_10_Void__c = false,
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
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_2__c = true;
            testCuSRForm.FAB_3__c = true;
            testCuSRForm.FAB_3E__c = true;
            testCuSRForm.FAB_5__c = true;
            testCuSRForm.FAB_6__c = true;
            testCuSRForm.FAB_7__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab2Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 2',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab2Approver;
            
            CuSR_Approval_Process__c fab3Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3Approver;
            
            CuSR_Approval_Process__c fab3eApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 3E Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 3E',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab3eApprover;
            
            CuSR_Approval_Process__c fab5Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 5 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 5',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab5Approver;
            
            CuSR_Approval_Process__c fab6Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 6 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 6',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab6Approver;
            
            CuSR_Approval_Process__c fab7Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 7 Owner',
                Site__c = 'Singapore',
                Status__c = 'New',
                Fab__c = 'FAB 7',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab7Approver;
            
            /*List<CuSR_Approval_Process__c> approvalList = new List<CuSR_Approval_Process__c>();
            approvalList.add(fab7Approver);
            approvalList.add(fab2Approver);
            approvalList.add(fab3Approver);
            approvalList.add(fab3eApprover);
            approvalList.add(fab5Approver);
            approvalList.add(fab6Approver);*/
            
            testCuSRForm.Singapore_Ready_for_Approval__c = true;
            testCuSRForm.Singapore_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            
            //test.startTest();
            
                /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: fab2Approver.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            
            fab7Approver.Status__c = 'Rejected';
            fab7Approver.Approved__c = false;
                update fab7Approver;
            
            test.stopTest();
        }
    }  
    
    public static testMethod void testFabToScopeAfterImplementation(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            //teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
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
                Requested_Effective_Date__c = Date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                OwnerId = testUser.Id,
                Dresden_System_Owner_Approval_Required__c = 'No',
                Malta_System_Owner_Approval_Required__c = 'No',
                Dresden_Ready_for_Approval__c = true,
                Malta_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            testCuSRForm.FAB_8__c = true;
          //  testCuSRForm.FAB_9__c = true;
          //  testCuSRForm.FAB_10__c = true;
            update testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            CuSR_Approval_Process__c fab8Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Approved__c = false,
                Type_of_Approver__c = 'FAB 8 Owner',
                Site__c = 'Malta',
                Status__c = 'New',
                Fab__c = 'FAB 8',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab8Approver;
        /*    CuSR_Approval_Process__c fab9Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Approved__c = false,
                Type_of_Approver__c = 'FAB 9 Owner',
                Site__c = 'Malta',
                Status__c = 'New',
                Fab__c = 'FAB 9',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab9Approver;
            CuSR_Approval_Process__c fab10Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Approved__c = false,
                Type_of_Approver__c = 'FAB 10 Owner',
                Site__c = 'Malta',
                Status__c = 'New',
                Fab__c = 'FAB 10',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab10Approver;*/
            
            testCuSRForm.Malta_Ready_for_Approval__c = true;
            testCuSRForm.Malta_System_Owner_Approval_Required__c = 'No';
            //testCuSRForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            update testCuSRForm;
            
            fab8Approver.Status__c = 'Approved';
            fab8Approver.Approved__c = true;
            update fab8Approver;
            
           /* fab9Approver.Status__c = 'Approved';
            fab9Approver.Approved__c = true;
            update fab9Approver;
            
            fab10Approver.Status__c = 'Approved';
            fab10Approver.Approved__c = true;
            update fab10Approver;*/
            
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod10(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_8__c = true,
                FAB_9__c = true,
                FAB_10__c = true,
                ASIC__c = true,
                FAB_8_Void__c = false,
                FAB_9_Void__c = false,
                FAB_10_Void__c = false,
                ASIC_Void__c = false,
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
                OwnerId = testUser.Id,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Implemented'
            );
            insert testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            test.startTest();
            
            List<CuSR_Approval_Process__c> capList = new List<CuSR_Approval_Process__c>();
            CuSR_Approval_Process__c fab8Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 8 Owner',
                Site__c = 'Malta',
                Status__c = 'New',
                Fab__c = 'FAB 8',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            capList.add(fab8Approver);
            
            CuSR_Approval_Process__c fab9Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 9 Owner',
                Site__c = 'Essex Junction',
                Status__c = 'New',
                Fab__c = 'FAB 9',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            capList.add(fab9Approver);
            
            CuSR_Approval_Process__c fab10Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 10 Owner',
                Site__c = 'East Fishkill',
                Status__c = 'New',
                Fab__c = 'FAB 10',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            capList.add(fab10Approver);
            
            CuSR_Approval_Process__c asicApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'ASIC Owner',
                Site__c = 'ASIC',
                Status__c = 'New',
                Fab__c = 'ASIC',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            capList.add(asicApprover);
            insert capList;
            
            testCuSRForm.Malta_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Malta_Ready_for_Approval__c = true;
            
            testCuSRForm.Esx_Jun_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.Essex_Junction_Ready_for_Approval__c = true;
            
            testCuSRForm.EastFishkillSystemOwnerApproval_Required__c = 'No';
            testCuSRForm.East_Fishkill_Ready_for_Approval__c = true;
            
            testCuSRForm.ASIC_System_Owner_Approval_Required__c = 'No';
            testCuSRForm.ASIC_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            fab8Approver.Status__c = 'Rejected';
            fab8Approver.Approved__c = false;
            
            fab9Approver.Status__c = 'Rejected';
            fab9Approver.Approved__c = false;
            
            fab10Approver.Status__c = 'Rejected';
            fab10Approver.Approved__c = false;
            
            asicApprover.Status__c = 'Rejected';
            asicApprover.Approved__c = false;
            
            update capList;
            
            System.assertEquals(testCuSRForm.FAB_9__c, TRUE);
            System.assertEquals(testCuSRForm.FAB_10__c, TRUE);
            System.assertEquals(testCuSRForm.ASIC__c, TRUE);
            
            test.stopTest();
        }
    }
}