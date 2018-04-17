/*
    Author:
    Description: This is a test class for DelCPQMLGErrorLogScheduler class. 
    History:
        ARoy        05252015    - code created.
*/
        
@isTest(SeeAllData=false)                               
public class CPQSchedulableClassTest {

   public static String CRON_EXP = '0 0 1 * * ?';

   static testmethod void testCPQSchedule() {
      Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new DelCPQMLGErrorLogScheduler());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);
   }
   
}