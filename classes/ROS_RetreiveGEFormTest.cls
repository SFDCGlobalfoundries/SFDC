/**
*    Company       :   Cognizant Technologies PTE Ltd.
*    Description   :   Test Class for ROS_ReticleDatawarehousehelper
*    History       :   

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        
**/
@isTest(SEEALLDATA = false)
private class ROS_RetreiveGEFormTest{
    static Environment_Variable__c assignEnvironmentVar(String name,String value){
        Environment_Variable__c env = new Environment_Variable__c();
        env.name = name;
        env.value__c = value;
        return env;
    }
    
    static testMethod void testAllWebserviceClasses(){
        List<Environment_Variable__c> lstEnv = new List<Environment_Variable__c>();
        lstEnv.add(ROS_RetreiveGEFormTest.assignEnvironmentVar('ROS_GEForm_Endpoint_URL','https://test.foundryview.com'));
        insert lstEnv;
        
        Test.startTest();
            ROS_RetreiveGEForm.processResponse_element processResElement = new ROS_RetreiveGEForm.processResponse_element();
            ROS_RetreiveGEForm.GEReticleSyncService_pt geReticleSync = new ROS_RetreiveGEForm.GEReticleSyncService_pt();
            ROS_RetreiveGEForm.process_element processElement = new ROS_RetreiveGEForm.process_element();
            ROS_RetreiveGEForm.result_element resultElement = new ROS_RetreiveGEForm.result_element();
        Test.stopTest();
    }
}