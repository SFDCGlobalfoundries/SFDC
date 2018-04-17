/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016 
    Description: Test class for BNPStartRoutingTaskCtrl
*/
@isTest
public class BNPStartRoutingTaskCtrlTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpStartRoutingTaskTestMethod(){
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
              
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        /*Map<String,Object> fieldValueMskSetTitleMap = new Map<String,Object>();
        fieldValueMskSetTitleMap.put('Name', 'MSTTRT');
        Mask_Set_Title__c  mst1 = MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMskSetTitleMap);
        

        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = account1.id;
        mstAcc.Mask_Set_Title__c = mst1.id;
        insert mstAcc;*/

        //TriggerHandler.clearAllBypasses();
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        
        //TriggerHandler.clearAllBypasses();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        //TriggerHandler.clearAllBypasses();
        Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
        fieldValueReqInfoMap.put('Customer_Requirement__c', opt1.id);
        fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
        fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
        Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
        
        Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
        fieldValueRouteMap.put('RFQ__c', reqInfo.id);
        RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
        
        Test.startTest();
        Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
        fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
        fieldValueTskRouteMap.put('Start_date__c', System.now());
        RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
        
        Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
        fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
        fieldValueTskAssigneeMap.put('User__c', thisUser.id);
        fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', 'saha.poulami1987@gmail.com');
        RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
        
        
        BNPStartRoutingTaskCtrl.BNPStartRoutingTask(rfqRoute.id);
        Test.stopTest() ; 
        }
    }
}