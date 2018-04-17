/*
    Author:         Cognizant Technology Solution
    Company:        Cognizant Technology Solution
    Description:    This is a test class for apex class ROS_BATCH_SCHEDULER_ActReticleDailyLoad
    History:        Created Date - 11/02/2014
*/

@isTest(seealldata=false)
private class ROS_TestScheduleActReticleDailyLoad {

    public static String CRON_EXP;

    static testMethod void testExecute() {
        String jobId;
        Datetime dt = Datetime.now().addDays(2);
        CRON_EXP = '0 0 0 ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        Environment_Variable__c env = new Environment_Variable__c(name = 'ROS_ACTIVE_RETICLE_BATCH_SIZE', value__c = '50');
        insert env;

        Test.startTest();

        // Schedule the test job
        jobId = System.schedule('TestSchedulerActReticleDailyLoad',
                                 CRON_EXP,
                                 new ROS_SCHEDULE_ActiveReticleDailyLoad());

        CronTrigger ct = [SELECT  Id, CronExpression, TimesTriggered, NextFireTime
                          FROM    CronTrigger
                          WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}