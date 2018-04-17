/**
* Author: Yathish NS 
* Project: NPI Report  
* Description: Test class for NPIScheduleGenerateReports class
**/
@isTest
public class NPIScheduleGenerateReportsTest {
    public static testMethod void NPIScheduleGenerateReportsTest()
    {
        test.startTest();
        NPIScheduleGenerateReports npiSchedule = new NPIScheduleGenerateReports();
        String cronTime = '0 0 23 * * ?';
        system.schedule('Test Job', cronTime, npiSchedule);
        test.stopTest();
    }
}