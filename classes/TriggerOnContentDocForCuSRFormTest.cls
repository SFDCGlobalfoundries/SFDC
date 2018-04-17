/*
Author: Shyam Ravindra Nair
Description: Test Class for TriggerOnContentDocumentForCuSRForm trigger.
History:
SNair     24042015     - code creation
*/
@isTest(SeeAllData=false)
public class TriggerOnContentDocForCuSRFormTest {

	@testSetup static void testData(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod(){
        system.debug('Start Test Class');
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        //system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
        	system.debug('Account is '+testAccount);
        
        	/*Contact testContact = [select Id, Email from Contact where Id = '003N000000HTt79'];
        	system.debug('Contact is'+testContact);*/
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
        	system.debug('Contact is'+testContact);
            
            test.startTest();
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                FAB_1__c = true,
                Technology__c = 'ALL TECHNOLOGIES',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = date.today(),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Customer_Specification_Name__c = 'test name',
                Status__c = 'New',
                //Name = 'CUSR-15-00001',
                //Dresden_Ready_for_Approval__c = true,
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            system.debug('name of cusrform '+testCuSRForm.Name);
            
            CuSR_Form__c cusrForm = [select Name from CuSR_Form__c where Id =: testCuSRForm.Id];
        	system.debug('CUSR NAME IS'+cusrForm);
            
            ContentVersion testContentVersion = new ContentVersion(
            	versionData = Blob.valueOf('test data'),
            	title = cusrForm.Name+'_testFile.txt',
            	pathOnClient = cusrForm.Name+'_testFile.txt'
            );
            insert testContentVersion;
            
            ContentDocument testContentDocument = new ContentDocument();
            testContentDocument = [select LatestPublishedVersionId, Title from ContentDocument where Title =: testContentVersion.Title];
            system.debug('Content Title is '+testContentDocument.Title);
            
            //if(testContentDocument != null){
            	delete testContentDocument;
           // }
            test.stopTest();
        //}
    }

}