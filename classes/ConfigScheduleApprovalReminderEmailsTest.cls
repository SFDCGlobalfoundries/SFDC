/*
    Author: Ravi Teja
    Description: Test class for ConfigScheduleApprovalReminderEmailsTest.
    
*/

@isTest
public class ConfigScheduleApprovalReminderEmailsTest { 

    static testmethod void TestcheduleApprovalFAEReminderEmails() {
        Test.startTest();
        String CRON_EXP = '0 0 9 * * ?';
        
        String jobId = System.schedule('ConfigScheduleFAEApprovalReminderEmails' + System.now().getTime(),
            CRON_EXP,
            new ConfigScheduleFAEApprovalReminderEmails());

        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,
            NextFireTime
            FROM CronTrigger WHERE id = : jobId
        ];

        // Verify the expressions are the same  
        System.assertEquals(CRON_EXP,ct.CronExpression);

        // Verify the job has not run  
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();

    }
    
}