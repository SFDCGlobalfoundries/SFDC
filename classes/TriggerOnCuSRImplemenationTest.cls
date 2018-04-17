/*
Author: Shyam Ravindra Nair
Description: Test class for TriggerOnCuSRImplementation trigger.
History:
SNair     10012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class TriggerOnCuSRImplemenationTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static testMethod void myTestMethod(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        
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
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation2; 
            
            testImplementation1.Actual_End_Date__c = Date.newInstance(2015,2,1);
            testImplementation1.Status__c = 'Completed';
            update testImplementation1;
            
            testImplementation2.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation2.Status__c = 'Completed';
            update testImplementation2;
            
        }
    }
    
    public static testMethod void myTestMethod2(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != '' and isActive = true limit 1];
        
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
                FAB_2__c = true,
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
                Special_Requirement__c = 'Test Special Requirements'
            );
            insert testCuSRForm1;
            
            User assignee = [select Id from User where Id != :UserInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Implementation__c testImplementation1 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation1; 
            
            CuSR_Implementation__c testImplementation2 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 1',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation2;
            
            CuSR_Implementation__c testImplementation3 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 2',
                Planned_End_Date__c = Date.newInstance(2015,1,31),
                Status__c = 'Pending'
            );
            insert testImplementation3; 
            
            CuSR_Implementation__c testImplementation4 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 8',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation4; 
            
            CuSR_Implementation__c testImplementation5 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 9',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation5; 
            
            CuSR_Implementation__c testImplementation6 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'FAB 10',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation6; 
            
            CuSR_Implementation__c testImplementation7 = new CuSR_Implementation__c(
                CuSR_Form__c = testCuSRForm1.Id,
                Assignee__c = assignee.Id,
                Action__c = 'sample',
                Comments__c = 'Sample',
                Fab__c = 'ASIC',
                Planned_End_Date__c = Date.newInstance(2015,1,25),
                Status__c = 'Pending'
            );
            insert testImplementation7; 
            
            testImplementation1.Actual_End_Date__c = Date.newInstance(2015,2,1);
            testImplementation1.Status__c = 'Cancelled';
            update testImplementation1;
            
            testImplementation2.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation2.Status__c = 'Completed';
            update testImplementation2;
            
            testImplementation3.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation3.Status__c = 'Completed';
            update testImplementation3;
            
            testImplementation4.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation4.Status__c = 'Completed';
            update testImplementation4;
            
            testImplementation5.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation5.Status__c = 'Completed';
            update testImplementation5;
            
            testImplementation6.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation6.Status__c = 'Completed';
            update testImplementation6;
            
            testImplementation7.Actual_End_Date__c = Date.newInstance(2015,1,31);
            testImplementation7.Status__c = 'Completed';
            update testImplementation7;
        }
    }

}