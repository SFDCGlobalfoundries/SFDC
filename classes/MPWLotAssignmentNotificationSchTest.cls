/**
* Author: Anil Kumar
* Company: JK Technosoft
* Project: MPW
* Description: Test Class for MPWLotAssignmentNotificationBatch
* History:
*    Anil Kumar 13/07/2016 - Created
**/
@isTest
public class MPWLotAssignmentNotificationSchTest {
    
    static testMethod void MPWLotAssignmentNotificationSchedulerTest1 () {
        Test.StartTest();
        MPWLotAssignmentNotificationScheduler cntrl = new MPWLotAssignmentNotificationScheduler();
        String sch = '0 0 23 * * ?';
        MPWLotAssignmentNotificationScheduler.startSchedule(sch);
        system.schedule('MPW Lot Assignment Notification Test', sch, cntrl); 
        Test.stopTest(); 
    }

}