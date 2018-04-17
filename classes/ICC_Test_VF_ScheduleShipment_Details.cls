@isTest
public class ICC_Test_VF_ScheduleShipment_Details
{
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testmethod void test_VF_report()
    {
        ICC_VF_ScheduleShipment_Details test = new ICC_VF_ScheduleShipment_Details();
    }
}