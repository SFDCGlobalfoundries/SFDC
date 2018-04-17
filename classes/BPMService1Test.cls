/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for BPMService1.
    History: 
        ZAmbat      11202014    - Code creation.
        Ashwini     05132015    - Updated code for refactoring of test class.
*/
@isTest(SeeAllData=false)
private class BPMService1Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void runTest() {
        //DataUtilTest.loadEnvironmentVariables();
        Test.startTest();
            BPMService1 bpm = new BPMService1();
            BPMService1.SFDCDeviceIntegration devInt = new BPMService1.SFDCDeviceIntegration();
            BPMService1.CDRS_PIYE_EMPLOYEE_LIST cdrs = new BPMService1.CDRS_PIYE_EMPLOYEE_LIST();
            BPMService1.SFDCDeviceIntegrationResponse res = new BPMService1.SFDCDeviceIntegrationResponse ();
            BPMService1.SFDC_Device dev = new BPMService1.SFDC_Device ();
            BPMService1.GF_Integration_SFDC_Service_SFDCDevice_Port servicePort = new BPMService1.GF_Integration_SFDC_Service_SFDCDevice_Port ();
        Test.stopTest();
    }
}