@isTest 
public class MPWReservationCloseReminderSchedulerTest {
    public static testMethod void MPWReservationCloseReminderSchedulerTest1(){
    
        String strCronExpTemp = '0 00 00 * * ?';
        SchedulableContext sc;
        
        MPWReservationCloseReminderScheduler obj = new MPWReservationCloseReminderScheduler();
        MPWReservationCloseReminderScheduler.startSchedule(strCronExpTemp);
        obj.execute(sc);
        
    }
}