/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWPrimeDieBatchScheduler
* History:
*    Anil Kumar 10/2/2017 - Created
**/
@isTest
public class MPWPrimeDieBatchSchedulerTest {
    
    static testMethod void MPWPrimeDieBatchSchedulerTest1 () {
        Test.StartTest();
        MPWPrimeDieBatchScheduler cntrl = new MPWPrimeDieBatchScheduler();
        String sch = '0 0 23 * * ?';
        MPWPrimeDieBatchScheduler.startSchedule(sch, 1, 'LAST_N_DAYS:30', 'NEXT_N_DAYS:30');
        system.schedule('MPW Prime Die Batch Test', sch, cntrl); 
        Test.stopTest(); 
    }
}