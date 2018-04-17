/*
    Author: Win
    Created Date: Feb/22/2013 
    Description: Test class for DateUtil
    Test cases: 
    1. 
*/

@isTest
public class DateUtilTest{

    static testMethod void doTest1(){
        test.startTest();
        DateUtil.getCurrentTimeLocal();
        DateUtil.getCurrentTimeSGP();
        DateUtil.getCurrentWeekFridayLocal();
        DateUtil.getCurrentWeekFridayLocalDate();
        DateUtil.getCurrentWeekMondaySGP();
        DateUtil.getWeekMondaySGP(DateUtil.getCurrentWeekFridayLocalDate());
        DateUtil.dayOfWeek('friday');
        DateUtil.dayOfWeek('foobar');
        test.stopTest();

    }
}