/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormAttachmentPageExtensions apex class.
History:
SNair     24042015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormAttachmentPageExtensionsTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myUnitTest1(){
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        //system.runAs(testUser){
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
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormAttachmentPage'));
            system.currentPageReference().getParameters().put('RecordId',testCuSRForm.Id);
            system.currentPageReference().getParameters().put('ObjectName','CuSR_Form__c');
            CuSRFormAttachmentPageExtensions controller = new CuSRFormAttachmentPageExtensions();
            controller.fileBody = Blob.valueOf('Test Body.');
            controller.fileName = 'Test_Name.txt';
            controller.attachFile();
            controller.fileBody = null;
            controller.fileName = 'Test_Name.txt';
            controller.attachFile();
            controller.doneMethod();
            test.stopTest();
       // }
    }
    
    public static testMethod void myUnitTest2(){
       User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        //system.runAs(testUser){
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
                Status__c = 'Pending Implementation',
                Dresden_Ready_for_Approval__c = true,
                Stakeholder_Approval_Completed__c = true,
                PM_Approved__c = true,
                AM_Approved__c = true,
                OwnerId = testUser.Id
            );
            insert testCuSRForm;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Implementation__c testImplementation = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation; 
            
            test.startTest();
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormAttachmentPage'));
            system.currentPageReference().getParameters().put('RecordId',testImplementation.Id);
            system.currentPageReference().getParameters().put('ObjectName','CuSR_Implementation__c');
            system.currentPageReference().getParameters().put('PageType','View');
            CuSRFormAttachmentPageExtensions controller1 = new CuSRFormAttachmentPageExtensions();
            controller1.fileBody = Blob.valueOf('Test Body 1.');
            controller1.fileName = 'Test_Name1.txt';
            controller1.attachFile();
            controller1.doneMethod();
        
            Test.setCurrentPageReference(new pageReference('Page.CuSRFormAttachmentPage'));
            system.currentPageReference().getParameters().put('RecordId',testImplementation.Id);
            system.currentPageReference().getParameters().put('ObjectName','CuSR_Implementation__c');
            system.currentPageReference().getParameters().put('PageType','Edit');
            CuSRFormAttachmentPageExtensions controller2 = new CuSRFormAttachmentPageExtensions();
            controller2.fileBody = Blob.valueOf('Test Body 2.');
            controller2.fileName = 'Test_Name2.txt';
            controller2.attachFile();
            controller2.doneMethod();
            test.stopTest();
        //}
    }
}