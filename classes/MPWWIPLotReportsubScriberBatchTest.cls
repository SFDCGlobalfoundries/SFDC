@isTest
private class MPWWIPLotReportsubScriberBatchTest {
    static testMethod void myUnitTestBatch() {
        MPW_WIP_Report_Schedule__c obj = new MPW_WIP_Report_Schedule__c(Name='Test',User_Name__c = UserInfo.getUserName(),
            Scheduled_Frequency1__c = 'MONTHLY',
            Start_Date__c = System.Today().addDays(-1),
            End_Date__c = System.Today().addDays(2));
        insert obj;

        Test.StartTest();
        String jobId = Database.executebatch(new MPWWIPLotReportsubScriberBatch(), 1);
        System.assertNotEquals(null, jobId);
        Test.StopTest();


    }

    static testMethod void myUnitTestBatchWeek() {
        MPW_WIP_Report_Schedule__c obj = new MPW_WIP_Report_Schedule__c(Name='Test',User_Name__c = UserInfo.getUserName(),
            Scheduled_Frequency1__c = 'WEEKLY',
            Start_Date__c = System.Today().addDays(-1),
            End_Date__c = System.Today().addDays(2));
        insert obj;

        Test.StartTest();
        String jobId = Database.executebatch(new MPWWIPLotReportsubScriberBatch(), 1);
        System.assertNotEquals(null, jobId);
        Test.StopTest();

    }
    static testMethod void myUnitTestBatchDAY() {
        MPW_WIP_Report_Schedule__c obj = new MPW_WIP_Report_Schedule__c(Name='Test',User_Name__c = UserInfo.getUserName(),
            Scheduled_Frequency1__c = 'DAILY',
            Start_Date__c = System.Today().addDays(-1),
            End_Date__c = System.Today().addDays(2));
        insert obj;

        Test.StartTest();
        String jobId = Database.executebatch(new MPWWIPLotReportsubScriberBatch(), 1);
        System.assertNotEquals(null, jobId);
        Test.StopTest();

    }

    static testMethod void myUnitTestBatchSchedule() {
        Test.startTest();
        String CRON_EXP = '0 0 9 * * ?';
        String jobId = System.schedule('MPWWIPLotReportsubScriberScheduler' + System.now().getTime(),
            CRON_EXP,
            new MPWWIPLotReportsubScriberScheduler());
        System.assertNotEquals(null, jobId);
        Test.StopTest();  
    }

}