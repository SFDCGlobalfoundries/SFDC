/*
Test class for ICC_VF_ScheduleShipment_Details class
Author: Rahul Majumder
*/
@isTest
public class ICC_VF_ScheduleShipment_DetailsTest
{
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testmethod void test_VF_report()
    {
        ICC_VF_ScheduleShipment_Details test = new ICC_VF_ScheduleShipment_Details();
    }
}