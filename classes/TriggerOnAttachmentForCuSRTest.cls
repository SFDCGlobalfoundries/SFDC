/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnAttachmentForCuSR trigger.
History:
SNair     28042015     - code creation
*/
@isTest(SeeAllData=false)
private class TriggerOnAttachmentForCuSRTest {
	
	@testSetup static void testdata() {
    	DataUtilTest.loadEnvironmentVariables();
    }
	
	public static testMethod void myUnitTest() {
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            insert testCuSRForm1;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Implementation__c testImplementation = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation; 
            
            Attachment attach = new Attachment(
            	ParentId = testImplementation.Id,
            	Body = Blob.valueOf('test body'),
            	Name = 'Test.txt'
            );
            insert attach;
            
            test.startTest();
            delete attach;
            test.stopTest();
        }
    }
}