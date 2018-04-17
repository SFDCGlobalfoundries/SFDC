/*
Author: Bhavana Mohan
Company: Cognizant
Description: sfdc - .net Integration Webservice Test class
History:
created     10-Jun-2014     
*/

@isTest(SeeAllData = true)
private class MRSdotNETResponseCalloutServiceTest {
    @isTest static void testDotNetResponse() {              
        Test.setMock(WebServiceMock.class, new WebServiceMockImplemetaion());
        MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt mrsDotNetSwiftResp = new MRSdotNETResponseCalloutService.SwiftMRSPTRFSyncResponseService_pt();
        string actResponse= mrsDotNetSwiftResp.SwiftMRSPTRFSyncResponse('1234','ptrf1','SUCCESS','No Error');
        
        system.assertEquals('Mock response', actResponse); 
    }
}