/*
Author: Shyam Ravindra Nair
Description: Test Class for TriggerOnFeedItemForCUSRFormHandler
History:
SNair     23042015     - code creation
SNair     24042015     - modified
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class TriggerOnFeedItemForCUSRFormHandlerTest {
	
	@testSetup static void testdata() {
    	DataUtilTest.loadEnvironmentVariables();
    }

	public static testMethod void myTestMethod(){
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
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New',
                //Dresden_Ready_for_Approval__c = true,
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            test.startTest();
            FeedItem post = new FeedItem(
            	ParentId = testCuSRForm.Id,
            	Body = 'New Attachment Added',
            	ContentData = Blob.valueOf('Test File'),
            	ContentFileName = 'Test.txt',
            	Title = 'Test.txt'
            );
            insert post;
            delete post;
            test.stopTest();
        }
	}

}