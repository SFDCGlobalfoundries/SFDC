/*********************************************************************************************************************************************************
**********************************************************************************************************************************************************
    Class Name:    BPMServiceTest 
    Author:        Prosenjit Saha(PS)
    Description:   Test class for BPMService.
    Created Date: 
      PS           11192013    - Code creation.
    Change History:
      Author: 
      Modified Date: 
      Reason:
      --
      Ashwini     05132015    - Updated code for refactoring of test class.
********************************************************************************************************************************************************** 
**********************************************************************************************************************************************************/
@isTest(SeeAllData=false)
private class BPMServiceTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void runTest() {
        //DataUtilTest.loadEnvironmentVariables();
        Test.startTest();
            BPMService bpm = new BPMService ();
            BPMService.SFDC_Device dev = new BPMService.SFDC_Device ();
            BPMService.GF_Integration_SFDC_Service_SFDCDevice_Port servicePort = new BPMService.GF_Integration_SFDC_Service_SFDCDevice_Port ();
            BPMService.SFDCDeviceIntegration devInt = new BPMService.SFDCDeviceIntegration();
            BPMService.SFDCDeviceIntegrationResponse res = new BPMService.SFDCDeviceIntegrationResponse ();            
        Test.stopTest();
    }
}