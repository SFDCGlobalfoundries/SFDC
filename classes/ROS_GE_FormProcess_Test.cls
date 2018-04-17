/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_GE_FormProcess
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Nikhil Jain    04/25/2014           Test class created.
**/

@isTest(SEEALLDATA = false)
private class ROS_GE_FormProcess_Test {
    
    static testMethod void methodForROS_TRIGGER_HELPER_ReticleDatawarehouse() {
        Test.startTest();
            ROS_GEFormModel wrapper = new ROS_GEFormModel();
            wrapper.GEStatus = '123';
            ROS_GE_FormProcess.GefornProcess(wrapper);
        Test.stopTest(); 
    } 
    
    static testMethod void methodForGEService() {
        test.SetMock(WebServiceMock.class, new WebServiceMockImpl());
        ROS_RetreiveGEForm_1.GEReticleSyncService_pt objWeb = new ROS_RetreiveGEForm_1.GEReticleSyncService_pt();
        System.debug(objWeb.process('','','','','','',''));
    }
}