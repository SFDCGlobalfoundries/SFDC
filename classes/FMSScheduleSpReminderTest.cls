/*
 @class: FMSScheduleSpReminder
 @CreatedBy: Anirban Roy
 @CreatedDate: 20 July, 2017
 @Description: to test the FMSScheduleSpReminder Class
 @Modifications-
 *
 */

@isTest
public class FMSScheduleSpReminderTest{
    static testmethod void FormNotificationTest(){
        FMSScheduleSpReminder fmsSc = new FMSScheduleSpReminder();
        fmsSc.execute(null);
    }   
}