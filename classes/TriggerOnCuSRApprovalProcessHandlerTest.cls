/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRApprovalProcess trigger.
History:
SNair     10012015     - code creation
*/
@isTest(SeeAllData=false)
public class TriggerOnCuSRApprovalProcessHandlerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod1(){
        //User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != ''  limit 1];
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
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
                Dresden_System_Owner_Approval_Required__c = 'Yes',
                Dresden_Ready_for_Approval__c = true,
                Status__c = 'Pending Stakeholder Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c fab1Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 1 Owner',
                Site__c = 'Dresden',
                Status__c = 'New',
                Fab__c = 'FAB 1',
                No_of_Approvers__c = '1',
                Approver1__c = testUser.Id
            );
            insert fab1Approver;
            
            CuSR_Approval_Process__c sysApprover = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'System Owner',
                Site__c = 'Dresden',
                Status__c = 'New',
                No_of_Approvers__c = '1',
                Approver1__c = testUser.Id
            );
            insert sysApprover;
            
            test.startTest();
            testCuSRForm.Dresden_Ready_for_Approval__c = true;
            update testCuSRForm;
            
            /*Approval.ProcessWorkItemRequest req1 = new Approval.ProcessWorkItemRequest();
                req1.setComments('Recalled as another approval request is rejected.');
                req1.setAction('Reject');
                Id workItemId1 = null;
                for(ProcessInstanceWorkitem workItem: [select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: sysApprover.Id]){
                workItemId1 = workItem.Id;
                }       
                req1.setWorkitemId(workItemId1);
                Approval.ProcessResult result1 =  Approval.process(req1);*/
            sysApprover.Status__c = 'Rejected';
            update sysApprover;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod2(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
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
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Status__c = 'Pending AM Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c();
            amApproval.CuSR_Form__c = testCuSRForm.Id;
            amApproval.Type_of_Approver__c = 'AM';
            amApproval.Status__c = 'Pending Approval';
            amApproval.Approver1__c = testUser.Id;
            amApproval.Do_you_require_approval_from_all_users__c = false;
            insert amApproval;
            
            test.startTest();
            amApproval.Status__c = 'Rejected';
            update amApproval;
            test.stopTest();    
        }
    }
    
    public static testMethod void myTestMethod3(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
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
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User approver = [select Id from User where Id != :testUser.Id and Profile.Name = 'GF CE' and ManagerId != null and isActive = true limit 1];
            
            CuSR_Approval_Process__c fab1Approver = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'FAB 1 Owner',
                Site__c = 'Dresden',
                Status__c = 'New',
                Fab__c = 'FAB 1',
                Do_you_require_approval_from_all_users__c = false,
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id
            );
            insert fab1Approver;
            
            test.startTest();
            testCuSRForm.Dresden_Ready_for_Approval__c = true;
            //testCuSRForm.Dresden_System_Owner_Approval_Required__c = 'No';
            update testCuSRForm; 
            
                    /*Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('Submitting Request for Approval.');
                    req.setObjectId(fab1Approver.Id);
                    Approval.ProcessResult result = Approval.process(req);*/
            
            /*testCuSRForm.Status__c = 'Pending StakeHolder Review';
            update testCuSRForm;*/
            
            //test.startTest();
            fab1Approver.Remind_On_3rd_Day__c = true;
            fab1Approver.Status__c = 'Pending Approval';
            update fab1Approver;
            
            List<CuSR_Approval_Process__c> apprList = new List<CuSR_Approval_Process__c>();
            apprList.add(fab1Approver);
            
            TriggerOnCuSRApprovalProcessHandler con = new TriggerOnCuSRApprovalProcessHandler();
            con.sendReminder(apprList);
            
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
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'Yes',
                PM_Comments__c = 'sample',
                Status__c = 'Pending PM Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'AM',
                Status__c = 'New',
                No_of_Approvers__c = '1',
                Approver1__c = ceUser2.Id
            );
            insert amApproval;
            
            test.startTest();
            amApproval.Status__c = 'Pending Approval';
            update amApproval;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod11(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
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
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'Yes',
                PM_Comments__c = 'sample',
                Status__c = 'Pending PM Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'AM',
                Status__c = 'New',
                No_of_Approvers__c = '1',
                Approver1__c = ceUser2.Id
            );
            insert amApproval;
            
            test.startTest();
            amApproval.Status__c = 'Rejected';
            update amApproval;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod12(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8; FAB 9; FAB 10; ASIC', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
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
                FAB_2__c = true,
                FAB_3__c = true,
                FAB_3E__c = true,
                FAB_5__c = true,
                FAB_6__c = true,
                FAB_7__c = true,
                FAB_8__c = true,
                FAB_9__c = true,
                FAB_10__c = true,                
                ASIC__c = true,                
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
                Dresden_Ready_for_Approval__c = true,
                Singapore_System_Owner_Approval_Required__c = 'No',
                Singapore_Ready_for_Approval__c = true,
                Singapore_Individual_Fab_Owner_Approval__c = 'Yes',
                Malta_System_Owner_Approval_Required__c = 'No',
                Malta_Ready_for_Approval__c = true,
                Esx_Jun_System_Owner_Approval_Required__c = 'No',
                Essex_Junction_Ready_for_Approval__c = true,
                EastFishkillSystemOwnerApproval_Required__c = 'No',
                East_Fishkill_Ready_for_Approval__c = true,
                ASIC_System_Owner_Approval_Required__c = 'No',
                ASIC_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'Yes',
                PM_Comments__c = 'sample',
                Status__c = 'Pending PM Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'AM',
                Status__c = 'New',
                No_of_Approvers__c = '1',
                Approver1__c = ceUser2.Id
            );
            insert amApproval;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Implementation__c testImplementation1 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation1; 
            
            CuSR_Implementation__c testImplementation2 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 2',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation2; 
            
            CuSR_Implementation__c testImplementation3 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 3',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation3; 
            
            CuSR_Implementation__c testImplementation4 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 3E',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation4; 
            
            CuSR_Implementation__c testImplementation5 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 5',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation5; 
            
            CuSR_Implementation__c testImplementation6 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 6',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation6; 
            
            CuSR_Implementation__c testImplementation7 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 7',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation7; 
            
            CuSR_Implementation__c testImplementation8 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 8',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation8; 
            
            CuSR_Implementation__c testImplementation9 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 9',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation9;
            
            CuSR_Implementation__c testImplementation10 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 10',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementation10;
            
            CuSR_Implementation__c testImplementationASIC = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'ASIC',
                Planned_End_Date__c = Date.today(),
                Status__c = 'Completed',
                Actual_End_Date__c = Date.today()
            );
            insert testImplementationASIC;
            
            test.startTest();
            amApproval.Status__c = 'Approved';
            update amApproval;
            test.stopTest();
        }
    }
    
    public static testMethod void myTestMethod13(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            User ceUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true and Fab_Assigned__c != '' limit 1];
            User ceUser2 = [select Id from User where Id != :ceUser1.Id and Profile.Name = 'GF Sales User' and isActive = true limit 1];
            
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            List<Account_Team_Proxy__c> teamProxyList = new List<Account_Team_Proxy__c>();
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser1.Id, Account__c = testAccount.Id, Fab_Assignment__c = 'FAB 1; FAB 2; FAB 3; FAB 3E; FAB 5; FAB 6; FAB 7; FAB 8', Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Customer Engineer'));
            teamProxyList.add(new Account_Team_Proxy__c(User__c = ceUser2.Id, Account__c = testAccount.Id, Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write', Team_Role__c = 'Account Manager'));
            insert teamProxyList; 
            
            Contact testContact = new Contact(
                FirstName = 'Test1',
                LastName = 'Contact1',
                AccountId = testAccount.Id,
                Email = 'testsample.nair@cognizant.com'
            );
            insert testContact;
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
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
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                Any_Cost_Impact__c = 'No',
                //PM_Comments__c = 'sample',
                Status__c = 'Pending PM Review'
            );
            insert testCuSRForm;
            
            CuSR_Approval_Process__c amApproval = new CuSR_Approval_Process__c(
                CuSR_Form__c = testCuSRForm.Id,
                Type_of_Approver__c = 'AM',
                Status__c = 'New',
                No_of_Approvers__c = '1',
                Approver1__c = ceUser2.Id
            );
            insert amApproval;
            
            test.startTest();
            amApproval.Status__c = 'Pending Approval';
            update amApproval;
            test.stopTest();
        }
    }
}