/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormExtension class.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormExtensionTest3 {
	
	@testSetup static void testdata() {
    	DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void testEnableFields1(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
        
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
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
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.Standardcontroller(testCuSRForm));
            controller2.cusrForm.Dresden_System_Owner_Approval_Required__c = 'Yes';
            controller2.dresdenSystemOwnerApproval.No_of_Approvers__c = '4';
            controller2.enableDresdenSystemOwnerApprovers();
            controller2.dresdenSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.dresdenSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.fab1Approver.No_of_Approvers__c = '4';
            controller2.enableFab1OwnerApprovers();
            controller2.fab1Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab1Approver.Approver1__c = notifyUser.Id;
            controller2.fab1Approver.Approver2__c = notifyUser.Id;
            controller2.fab1Approver.Approver3__c = notifyUser.Id;
            controller2.fab1Approver.Approver4__c = notifyUser.Id;
            controller2.saveDresden();
            controller2.cusrForm.Malta_System_Owner_Approval_Required__c = 'Yes';
            controller2.maltaSystemOwnerApproval.No_of_Approvers__c = '4';
            controller2.enableMaltaSystemOwnerApprovers();
            controller2.maltaSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.maltaSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.fab8Approver.No_of_Approvers__c = '4';
            controller2.enableFab8OwnerApprovers();
            controller2.fab8Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab8Approver.Approver1__c = notifyUser.Id;
            controller2.fab8Approver.Approver2__c = notifyUser.Id;
            controller2.fab8Approver.Approver3__c = notifyUser.Id;
            controller2.fab8Approver.Approver4__c = notifyUser.Id;
            controller2.saveMalta();
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '4';
            controller2.enableSingaporeSystemOwnerApprovers();
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver4__c = notifyUser.Id;
            controller2.fab2Approver.No_of_Approvers__c = '4';
            controller2.enableFab2OwnerApprovers();
            controller2.fab2Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab2Approver.Approver1__c = notifyUser.Id;
            controller2.fab2Approver.Approver2__c = notifyUser.Id;
            controller2.fab2Approver.Approver3__c = notifyUser.Id;
            controller2.fab2Approver.Approver4__c = notifyUser.Id;
            controller2.fab3Approver.No_of_Approvers__c = '4';
            controller2.enableFab3OwnerApprovers();
            controller2.fab3Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3Approver.Approver1__c = notifyUser.Id;
            controller2.fab3Approver.Approver2__c = notifyUser.Id;
            controller2.fab3Approver.Approver3__c = notifyUser.Id;
            controller2.fab3Approver.Approver4__c = notifyUser.Id;
            controller2.fab3eApprover.No_of_Approvers__c = '4';
            controller2.enableFab3eOwnerApprovers();
            controller2.fab3eApprover.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3eApprover.Approver1__c = notifyUser.Id;
            controller2.fab3eApprover.Approver2__c = notifyUser.Id;
            controller2.fab3eApprover.Approver3__c = notifyUser.Id;
            controller2.fab3eApprover.Approver4__c = notifyUser.Id;
            controller2.fab5Approver.No_of_Approvers__c = '4';
            controller2.enableFab5OwnerApprovers();
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.Approver3__c = notifyUser.Id;
            controller2.fab5Approver.Approver4__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '4';
            controller2.enableFab6OwnerApprovers();
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.Approver3__c = notifyUser.Id;
            controller2.fab6Approver.Approver4__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '4';
            controller2.enableFab7OwnerApprovers();
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.Approver3__c = notifyUser.Id;
            controller2.fab7Approver.Approver4__c = notifyUser.Id;
            controller2.saveSingapore();
            //controller2.dresdenSubmitForApproval();
            //controller2.maltaSubmitForApproval();
            //controller2.singaporeSubmitForApproval();
            
            test.stopTest();
        }
    }
    
    public static testMethod void testEnableFields2(){
        
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
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
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            
            test.startTest();
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.Standardcontroller(testCuSRForm));
            controller2.cusrForm.Dresden_System_Owner_Approval_Required__c = 'Yes';
            controller2.dresdenSystemOwnerApproval.No_of_Approvers__c = '3';
            controller2.enableDresdenSystemOwnerApprovers();
            controller2.dresdenSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.dresdenSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.fab1Approver.No_of_Approvers__c = '3';
            controller2.enableFab1OwnerApprovers();
            controller2.fab1Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab1Approver.Approver1__c = notifyUser.Id;
            controller2.fab1Approver.Approver2__c = notifyUser.Id;
            controller2.fab1Approver.Approver3__c = notifyUser.Id;
            controller2.saveDresden();
            controller2.cusrForm.Malta_System_Owner_Approval_Required__c = 'Yes';
            controller2.maltaSystemOwnerApproval.No_of_Approvers__c = '3';
            controller2.enableMaltaSystemOwnerApprovers();
            controller2.maltaSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.maltaSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.fab8Approver.No_of_Approvers__c = '3';
            controller2.enableFab8OwnerApprovers();
            controller2.fab8Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab8Approver.Approver1__c = notifyUser.Id;
            controller2.fab8Approver.Approver2__c = notifyUser.Id;
            controller2.fab8Approver.Approver3__c = notifyUser.Id;
            controller2.saveMalta();
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '3';
            controller2.enableSingaporeSystemOwnerApprovers();
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver3__c = notifyUser.Id;
            controller2.fab2Approver.No_of_Approvers__c = '3';
            controller2.enableFab2OwnerApprovers();
            controller2.fab2Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab2Approver.Approver1__c = notifyUser.Id;
            controller2.fab2Approver.Approver2__c = notifyUser.Id;
            controller2.fab2Approver.Approver3__c = notifyUser.Id;
            controller2.fab3Approver.No_of_Approvers__c = '3';
            controller2.enableFab3OwnerApprovers();
            controller2.fab3Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3Approver.Approver1__c = notifyUser.Id;
            controller2.fab3Approver.Approver2__c = notifyUser.Id;
            controller2.fab3Approver.Approver3__c = notifyUser.Id;
            controller2.fab3eApprover.No_of_Approvers__c = '3';
            controller2.enableFab3eOwnerApprovers();
            controller2.fab3eApprover.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3eApprover.Approver1__c = notifyUser.Id;
            controller2.fab3eApprover.Approver2__c = notifyUser.Id;
            controller2.fab3eApprover.Approver3__c = notifyUser.Id;
            controller2.fab5Approver.No_of_Approvers__c = '3';
            controller2.enableFab5OwnerApprovers();
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.Approver3__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '3';
            controller2.enableFab6OwnerApprovers();
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.Approver3__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '3';
            controller2.enableFab7OwnerApprovers();
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.Approver3__c = notifyUser.Id;
            controller2.saveSingapore();
            //controller2.dresdenSubmitForApproval();
            //controller2.maltaSubmitForApproval();
            //controller2.singaporeSubmitForApproval();
            
            test.stopTest();
        }
                
    }
    
    public static testMethod void testEnableFields3(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
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
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.Standardcontroller(testCuSRForm));
            controller2.cusrForm.Dresden_System_Owner_Approval_Required__c = 'Yes';
            controller2.dresdenSystemOwnerApproval.No_of_Approvers__c = '2';
            controller2.enableDresdenSystemOwnerApprovers();
            controller2.dresdenSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.dresdenSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.dresdenSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.fab1Approver.No_of_Approvers__c = '2';
            controller2.enableFab1OwnerApprovers();
            controller2.fab1Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab1Approver.Approver1__c = notifyUser.Id;
            controller2.fab1Approver.Approver2__c = notifyUser.Id;
            controller2.saveDresden();
            controller2.cusrForm.Malta_System_Owner_Approval_Required__c = 'Yes';
            controller2.maltaSystemOwnerApproval.No_of_Approvers__c = '2';
            controller2.enableMaltaSystemOwnerApprovers();
            controller2.maltaSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.maltaSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.maltaSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.fab8Approver.No_of_Approvers__c = '2';
            controller2.enableFab8OwnerApprovers();
            controller2.fab8Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab8Approver.Approver1__c = notifyUser.Id;
            controller2.fab8Approver.Approver2__c = notifyUser.Id;
            controller2.saveMalta();
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '2';
            controller2.enableSingaporeSystemOwnerApprovers();
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.singaporeSystemOwnerApproval.Approver2__c = notifyUser.Id;
            controller2.fab2Approver.No_of_Approvers__c = '2';
            controller2.enableFab2OwnerApprovers();
            controller2.fab2Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab2Approver.Approver1__c = notifyUser.Id;
            controller2.fab2Approver.Approver2__c = notifyUser.Id;
            controller2.fab3Approver.No_of_Approvers__c = '2';
            controller2.enableFab3OwnerApprovers();
            controller2.fab3Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3Approver.Approver1__c = notifyUser.Id;
            controller2.fab3Approver.Approver2__c = notifyUser.Id;
            controller2.fab3eApprover.No_of_Approvers__c = '2';
            controller2.enableFab3eOwnerApprovers();
            controller2.fab3eApprover.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3eApprover.Approver1__c = notifyUser.Id;
            controller2.fab3eApprover.Approver2__c = notifyUser.Id;
            controller2.fab5Approver.No_of_Approvers__c = '2';
            controller2.enableFab5OwnerApprovers();
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.Approver2__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '2';
            controller2.enableFab6OwnerApprovers();
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.Approver2__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '2';
            controller2.enableFab7OwnerApprovers();
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.Approver2__c = notifyUser.Id;
            controller2.saveSingapore();
            //controller2.dresdenSubmitForApproval();
            //controller2.maltaSubmitForApproval();
            //controller2.singaporeSubmitForApproval();
            
            test.stopTest();
        }                
    }
    
    public static testMethod void testEnableFields4(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
        
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
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
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User notifyUser = [select Id, Name from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
            
            test.startTest();
            CuSRFormExtension controller2 = new CuSRFormExtension(new ApexPages.Standardcontroller(testCuSRForm));
            controller2.cusrForm.Dresden_System_Owner_Approval_Required__c = 'Yes';
            controller2.dresdenSystemOwnerApproval.No_of_Approvers__c = '1';
            controller2.enableDresdenSystemOwnerApprovers();
            controller2.dresdenSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.dresdenSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.fab1Approver.No_of_Approvers__c = '1';
            controller2.enableFab1OwnerApprovers();
            controller2.fab1Approver.Do_you_require_approval_from_all_users__c = false;
            controller2.fab1Approver.Approver1__c = notifyUser.Id;
            controller2.saveDresden();
            controller2.cusrForm.Malta_System_Owner_Approval_Required__c = 'Yes';
            controller2.maltaSystemOwnerApproval.No_of_Approvers__c = '1';
            controller2.enableMaltaSystemOwnerApprovers();
            controller2.maltaSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.maltaSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.fab8Approver.No_of_Approvers__c = '1';
            controller2.enableFab8OwnerApprovers();
            controller2.fab8Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab8Approver.Approver1__c = notifyUser.Id;
            controller2.saveMalta();
            controller2.cusrForm.Singapore_System_Owner_Approval_Required__c = 'Yes';
            controller2.cusrForm.Singapore_Individual_Fab_Owner_Approval__c = 'Yes';
            controller2.singaporeSystemOwnerApproval.No_of_Approvers__c = '1';
            controller2.enableSingaporeSystemOwnerApprovers();
            controller2.singaporeSystemOwnerApproval.Do_you_require_approval_from_all_users__c = false;
            controller2.singaporeSystemOwnerApproval.Approver1__c = notifyUser.Id;
            controller2.fab2Approver.No_of_Approvers__c = '1';
            controller2.enableFab2OwnerApprovers();
            controller2.fab2Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab2Approver.Approver1__c = notifyUser.Id;
            controller2.fab3Approver.No_of_Approvers__c = '1';
            controller2.enableFab3OwnerApprovers();
            controller2.fab3Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3Approver.Approver1__c = notifyUser.Id;
            controller2.fab3eApprover.No_of_Approvers__c = '1';
            controller2.enableFab3eOwnerApprovers();
            controller2.fab3eApprover.Do_you_require_approval_from_all_users__c = true;
            controller2.fab3eApprover.Approver1__c = notifyUser.Id;
            controller2.fab5Approver.No_of_Approvers__c = '1';
            controller2.enableFab5OwnerApprovers();
            controller2.fab5Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab5Approver.Approver1__c = notifyUser.Id;
            controller2.fab6Approver.No_of_Approvers__c = '1';
            controller2.enableFab6OwnerApprovers();
            controller2.fab6Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab6Approver.Approver1__c = notifyUser.Id;
            controller2.fab7Approver.No_of_Approvers__c = '1';
            controller2.enableFab7OwnerApprovers();
            controller2.fab7Approver.Do_you_require_approval_from_all_users__c = true;
            controller2.fab7Approver.Approver1__c = notifyUser.Id;
            controller2.saveSingapore();
            //controller2.dresdenSubmitForApproval();
            //controller2.maltaSubmitForApproval();
            //controller2.singaporeSubmitForApproval();
            
            test.stopTest();
        }                
    }
    
    /*public static testMethod void testAttachment(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
        
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
        List<CUSR_Tab_Id__c> cusrTabList = new List<CUSR_Tab_Id__c>();
            cusrTabList.add(new CUSR_Tab_Id__c(Name='CuSR Tab URL',Tab_URL__c='a6K/o'));
            insert cusrTabList;
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            User testUser1 = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
            
            Process__c fab1Process = new Process__c(
                Name = 'FAB 1 Process',
                Org_ID__c = 'FAB 1',
                Tech_Type__c = 'Sample',
                Tech_Geometry__c = 'Sample'
            );
            insert fab1Process;
            
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
                OwnerId = testUser1.Id,
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            
            test.startTest();
            CuSRFormExtension controller1 = new CuSRFormExtension(new ApexPages.Standardcontroller(testCuSRForm));
            controller1.fileBody = Blob.valueOf('Unit Testing Body');
            controller1.fileName = 'Test Name';
            controller1.saveRecord();
            test.stopTest();
        }
    }*/
    
    
}