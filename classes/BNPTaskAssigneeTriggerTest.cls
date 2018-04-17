/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 25/08/2016 
    Description: Test class for BNPTaskAssigneeTrigger
*/
@isTest
public class BNPTaskAssigneeTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpTaskAssigneeTriggerTestMethod(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Test.startTest();
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
            fieldValueOppProgMap.put('Account__c', account1.id);
            fieldValueOppProgMap.put('Opportunity__c', opp1.id);
            Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
            
            Map<String,Object> fieldValueDevMap = new Map<String,Object>();
            fieldValueDevMap.put('Account__c', account1.id);
            fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
            fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
            Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            //fieldValueOptionMap.put('Opportunity__c',opp1.id);
            fieldValueOptionMap.put('Device__c',dev1.id);
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Template__c', true);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);

            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            //fieldValueTskAssigneeMap.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', thisUser.Email);
            fieldValueTskAssigneeMap.put('Task_Assignee_Id__c', thisUser.id);
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
            
            Map<String,Object> fieldValueTskAssigneeMap1 = new Map<String,Object>();
            fieldValueTskAssigneeMap1.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap1.put('User__c', thisUser.id);
            //fieldValueTskAssigneeMap1.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap1.put('Task_Assignee_Email__c', thisUser.Email);
            fieldValueTskAssigneeMap1.put('Task_Assignee_Id__c', thisUser.id);
            
            try{
                RFQ_Task_Assignee__c rfqRouteTaskAssignee1 = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap1);
            }catch(Exception e){}
            
            Map<String,Object> fieldValueTskAssigneeMap2 = new Map<String,Object>();
            fieldValueTskAssigneeMap2.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap2.put('User__c', thisUser.id);
            //fieldValueTskAssigneeMap2.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap2.put('Task_Assignee_Email__c', thisUser.Email);
            fieldValueTskAssigneeMap2.put('Task_Assignee_Id__c', 'xxxxxxxxxxxxxxx');
            RFQ_Task_Assignee__c rfqRouteTaskAssignee2 = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap2);
            
            try{
                rfqRouteTaskAssignee2.Task_Assignee_Id__c = thisUser.id;
                update rfqRouteTaskAssignee2;
            }catch(Exception e){}
        }
        Test.stopTest();
 
    }
}