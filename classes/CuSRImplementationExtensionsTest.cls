/*
Author: Shyam Ravindra Nair
Description: Test class to calculate code coverage for CuSRImplementationExtensions class.
History:
SNair     09012015     - code creation
SNair     28042015     - code creation
*/
@isTest(SeeAllData=false)
public with sharing class CuSRImplementationExtensionsTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myTestMethod(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
        
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
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements'
            );
            insert testCuSRForm1;
            
            CuSR_Form__c testCuSRForm2 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_5__c = true,
                Technology__c = 'ANA 0.18UM',
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            insert testCuSRForm2;
            
            CuSR_Form__c testCuSRForm3 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_8__c = true,
                Technology__c = 'XM 0.010UM',
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            insert testCuSRForm3;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Implementation__c testImplementation1 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation1; 
            
            CuSR_Implementation__c testImplementation2 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm2.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 5',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation2; 
            
            CuSR_Implementation__c testImplementation3 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm3.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 8',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation3; 
            
            Test.startTest();
            CuSRImplementationExtensions controller1 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controller1.implementation = testImplementation1;
            controller1.implementation.Actual_End_Date__c = Date.newInstance(2015,1,26);
            controller1.updateImplementation();
            //controller1.cancelled();
            //controller1.completed();
            controller1.sourceFab = 'FAB 1';
            controller1.navigateToCuSRForm();
            controller1.cancelAction();
            
            CuSRImplementationExtensions controller2 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(testImplementation2));
            controller2.navigateToCuSRForm();
            controller2.cancelAction();
            
            CuSRImplementationExtensions controller3 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(testImplementation3));
            controller2.navigateToCuSRForm();
            controller3.cancelAction();
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            System.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm2.Id);
            System.currentPageReference().getParameters().put('selectedfab','FAB 5');
            CuSRImplementationExtensions controller4 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controller4.implementation.Assignee__c = assignee.Id;
            controller4.saveImplementation();
            controller4.implementation.Action__c = 'Sample';
            controller4.implementation.Planned_End_Date__c = Date.newInstance(2015,02,12);
            controller4.saveImplementation();
            controller4.implementation.Status__c = 'Completed';
            controller4.updateImplementation();
            controller4.implementation.Status__c = 'Completed';
            controller4.implementation.Comments__c = 'Sample';
            controller4.implementation.Actual_End_Date__c = Date.newInstance(2015,02,12);
            controller4.updateImplementation();
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            System.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm1.Id);
            System.currentPageReference().getParameters().put('selectedfab','FAB 1');
            CuSRImplementationExtensions controller5 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controller5.cancelAction();
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            System.currentPageReference().getParameters().put('CuSRFormId',testCuSRForm3.Id);
            System.currentPageReference().getParameters().put('selectedfab','FAB 8');
            CuSRImplementationExtensions controller6 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controller6.cancelAction();
            
            Test.stopTest();
        }
    } 
    
    public static testMethod void testRun2(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            List<CuSR_Form__c> cusrFormList = new List<CuSR_Form__c>();
            CuSR_Form__c cusrFormFab9 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_9__c = true,
                FAB_9_Void__c = TRUE,
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            cusrFormList.add(cusrFormFab9);
            
            CuSR_Form__c cusrFormFab10 = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_10__c = true,
                FAB_10_Void__c = TRUE,
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            cusrFormList.add(cusrFormFab10);
            
            CuSR_Form__c cusrFormASIC = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                ASIC__c = true,
                ASIC_Void__c = TRUE,
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            cusrFormList.add(cusrFormASIC);
            insert cusrFormList;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            List<CuSR_Implementation__c> cusrImplementationList = new List<CuSR_Implementation__c>();
            CuSR_Implementation__c cusrImplementationFab9 = new CuSR_Implementation__c(
                CuSR_Form__c = cusrFormFab9.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 9',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            cusrImplementationList.add(cusrImplementationFab9);
            
            CuSR_Implementation__c cusrImplementationFab10 = new CuSR_Implementation__c(
                CuSR_Form__c = cusrFormFab10.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 10',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            cusrImplementationList.add(cusrImplementationFab10);
            
            CuSR_Implementation__c cusrImplementationASIC = new CuSR_Implementation__c(
                CuSR_Form__c = cusrFormASIC.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'ASIC',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            cusrImplementationList.add(cusrImplementationASIC);
            insert cusrImplementationList;
            
            Test.startTest();
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            CuSRImplementationExtensions controllerFab9 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(cusrImplementationFab9));
            controllerFab9.disableEditWhenVoidedMethod();
            controllerFab9.navigateToCuSRForm();
            
            System.currentPageReference().getParameters().put('CuSRFormId',cusrFormFab9.Id);
            System.currentPageReference().getParameters().put('selectedfab', 'FAB 9');
            controllerFab9 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controllerFab9.cancelAction();
            System.assertEquals(controllerFab9.sourceFab, 'FAB 9');
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            CuSRImplementationExtensions controllerFab10 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(cusrImplementationFab10));
            controllerFab10.disableEditWhenVoidedMethod();
            controllerFab10.navigateToCuSRForm();
            
            System.currentPageReference().getParameters().put('CuSRFormId',cusrFormFab10.Id);
            System.currentPageReference().getParameters().put('selectedfab', 'FAB 10');
            controllerFab10 = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controllerFab10.cancelAction();
            System.assertEquals(controllerFab10.sourceFab, 'FAB 10');
            
            Test.setCurrentPageReference(new PageReference('Page.CuSRImplementationEditPage'));
            CuSRImplementationExtensions controllerASIC = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(cusrImplementationASIC));
            controllerASIC.disableEditWhenVoidedMethod();
            controllerASIC.navigateToCuSRForm();
            controllerASIC.deleteAttachment();
            
            System.currentPageReference().getParameters().put('CuSRFormId',cusrFormASIC.Id);
            System.currentPageReference().getParameters().put('selectedfab', 'ASIC');
            controllerASIC = new CuSRImplementationExtensions(new ApexPages.Standardcontroller(new CuSR_Implementation__c()));
            controllerASIC.cancelAction();
            System.assertEquals(controllerASIC.sourceFab, 'ASIC');
            
            Test.stopTest();
        }
    }
}