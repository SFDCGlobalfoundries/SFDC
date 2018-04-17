/*
Author: Shyam Ravindra Nair
Description: Test class for CuSRFormAnnualReminderScheduler.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRFormAnnualReminderSchedulerTest {
	
	@testSetup static void testdata() {
    	DataUtilTest.loadEnvironmentVariables();
    }
    
    public static String CRON_EXP = '0 0 0 31 1 ? 2025';

    public static testMethod void myTestMethod(){
        Account testAccount = eWSRUtilityTestDataClass.getAccount();
        User testUser = [select Id from User where Profile.Name = 'GF CE' and Fab_Assigned__c != null and isActive = true and ManagerId != null limit 1];
        
        Date currentDate = date.today();
        Integer nextMonth = currentDate.month()+1;
        Integer currentMonth = currentDate.year();
            
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id,
            Email = 'shyamravindra.nair@cognizant.com'
        );
        insert testContact;
        
        CuSR_Form__c testCuSRForm = new CuSR_Form__c(
            OwnerId = testUser.Id,
            Request_Received_Date__c = Date.today(),
            FAB_1__c = true,
            Technology__c = 'CA 0.045UM',
            Customer_Name__c = testAccount.Id,
            System__c = 'CPK',
            Customer_Requestor__c = testContact.Id,
            Customer_Requestor_Email__c = testContact.Email,
            Notify_Customer_after_Implementation__c = 'No',
            //Requested_Effective_Date__c = Date.today(),
            Requested_Effective_Date__c = Date.newInstance(currentMonth, nextMonth , 15),
            Validity_Period_of_this_Request__c = 'EOL',
            Actual_Requirement__c = 'Test Requirement',
            Justification_for_Request__c = 'Test Justification',
            Scope_of_the_CuSR__c = 'RTP Parts',
            Is_this_a_one_time_requirement__c = 'Yes',
            Special_Requirement__c = 'Test Special Requirements',
            Status__c = 'Implemented'
        );
        insert testCuSRForm;
        
        Test.startTest();
        String jobId = System.schedule('testScheduleApex', CRON_EXP, new CuSRFormAnnualReminderScheduler());   
        
        CronTrigger ct = [select Id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where Id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-31 00:00:00', String.valueOf(ct.NextFireTime)); 
        Test.stopTest();    
    }

}