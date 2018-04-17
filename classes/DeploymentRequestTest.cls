/*
    Author: Nino Bustillos
    Description: Test Class for Deployment Request apex trigger after trigger.
    History:
        04272014    Nbustillos    - code creation
*/
@isTest(SeeAllData=false)
private class DeploymentRequestTest{

    static testMethod void runTest() {
    
        Test.startTest();
    
        // create deployment request record.
        Deployment_Request__c oDR = new Deployment_Request__c(Request_Type__c='Normal', 
                                                             Source_Environment__c='SIT', 
                                                             Target_Environment__c='UAT',
                                                             Short_Description__c='Test Deployment Request',
                                                             Description__c='This is a sample Deployment Request.',
                                                             CR_Number__c = 'CH101',
                                                             Deployment_Request_Date_Time__c=DateTime.now());
        insert oDR;
        
        // Submit record for approval
        Approval.ProcessSubmitRequest oAppReq = new Approval.ProcessSubmitRequest();
        oAppReq.setObjectId(oDR.id);
        Approval.ProcessResult oAppRes = Approval.process(oAppReq);
        
        // approve reject using approver
        
        // approve reject using creator.
        system.assertEquals(oDR.Request_Type__c,'Normal');
        Test.stopTest();
    }
    
    static testMethod void runTest1() {
    
        Test.startTest();
    
        // create deployment request record.
        Deployment_Request__c oDR = new Deployment_Request__c(Request_Type__c='Normal', 
                                                             Source_Environment__c='SIT', 
                                                             Target_Environment__c='UAT',
                                                             Short_Description__c='Test Deployment Request',
                                                             Description__c='This is a sample Deployment Request.',
                                                             CR_Number__c = 'CH101',
                                                             Deployment_Request_Date_Time__c=DateTime.now());
        insert oDR;
        DeploymentRequestHelper.processApprovalNew(oDR.Id);    
        //oDR.Deployment_Request_Date_Time__c = DateTime.now().addDays(-1);
        //update oDR;
        DeploymentRequestHelper.processApprovalNew(oDR.Id);        
        DeploymentRequestHelper.processApprovalNew(oDR.Id);     
        system.assertEquals(oDR.Request_Type__c,'Normal');   
        Test.stopTest();
    }

}