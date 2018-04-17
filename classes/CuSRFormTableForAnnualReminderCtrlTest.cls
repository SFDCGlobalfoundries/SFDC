/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormTableForAnnualReminderController class.
History:
SNair     11022015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormTableForAnnualReminderCtrlTest {
	
	@testSetup static void testdata() {
    	DataUtilTest.loadEnvironmentVariables();
    }

    static testMethod void myUnitTest() {
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
            
            
            CuSR_Form__c testCuSRForm1 = new CuSR_Form__c(
                OwnerId = testUser.Id,
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,3,26),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented'
            );
            insert testCuSRForm1;
            
            CuSR_Form__c testCuSRForm2 = new CuSR_Form__c(
                OwnerId = testUser.Id,
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,3,15),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'Implemented'
            );
            insert testCuSRForm2;
            
            test.startTest();
            CuSRFormTableForAnnualReminderController controller = new CuSRFormTableForAnnualReminderController();
            controller.originatorId = testUser.Id;
            List<CuSR_Form__c> cusrList = controller.getCuSRFormList();
            test.stopTest();
        }
    }
}