/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 03102017 
    Description: Test class for BNPCreateRouteFromTemplateCtrl
*/
@isTest
public class BNPCreateRouteFromTemplateCtrlTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void cloneTestMethod(){
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
            //fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', System.now());
            fieldValueReqInfoMap.put('Negotiation_Date__c', System.now());
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Route_Template__c routeTemp = new Route_Template__c();
            routeTemp.Auto_Stop_on_Rejection__c = 'Deferred';
            routeTemp.Calculate_due_date_based_on__c = 'Negotiation date';
            routeTemp.Description__c = 'Test';
            routeTemp.Route_Base_Purpose__c = 'Standard';
            routeTemp.Route_Name__c = 'Test';
            routeTemp.Status__c = 'InProgress';
            insert routeTemp;
        
            Task_Template__c tskTemp = new Task_Template__c();
            tskTemp.Route_Template__c = routeTemp.id;
            tskTemp.Action_Type__c = 'Comment';
            tskTemp.Allow_Delegation__c = true;
            tskTemp.Due_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp.Due_Date_Diff_Negotiation_Date__c = 10;
            tskTemp.Duration__c = 1;
            tskTemp.Order__c = 1;
            tskTemp.Start_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp.Start_Date_Diff_Negotiation_Date__c = 10;
            tskTemp.Task_Name__c = 'ISC';
            tskTemp.Task_Type__c = 'Test';
            tskTemp.Task_Status__c = 'InProgress';
            insert tskTemp;
            
            Task_Assignee_Template__c tskAssTemp = new Task_Assignee_Template__c();
            tskAssTemp.Assignee_Type__c = 'User';
            tskAssTemp.Subscribe_Notification__c = true;
            tskAssTemp.Task_Assignee__c = 'Poulami Saha';
            tskAssTemp.Task_Assignee_Email__c = 'saha.poulami1987@gmail.com';
            tskAssTemp.Task_Template__c = tskTemp.id;
            insert tskAssTemp;
            
            Task_Template__c tskTemp1 = new Task_Template__c();
            tskTemp1.Route_Template__c = routeTemp.id;
            tskTemp1.Action_Type__c = 'Comment';
            tskTemp1.Allow_Delegation__c = true;
            tskTemp1.Due_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp1.Due_Date_Diff_Negotiation_Date__c = 10;
            tskTemp1.Duration__c = 1;
            tskTemp1.Order__c = 2;
            tskTemp1.Predecessor_Task_Order__c = 1;
            tskTemp1.Start_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp1.Start_Date_Diff_Negotiation_Date__c = 10;
            tskTemp1.Task_Name__c = 'ISC';
            tskTemp1.Task_Type__c = 'Test';
            tskTemp1.Task_Status__c = 'InProgress';
            insert tskTemp1;
            
            Test.startTest();
                 BNPCreateRouteFromTemplateCtrl.BNPCreateRouteFromTemplate(routeTemp.id, reqInfo.id);
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void cloneTestMethod1(){
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
            //fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', System.now());
            fieldValueReqInfoMap.put('Negotiation_Date__c', System.now());
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Route_Template__c routeTemp = new Route_Template__c();
            routeTemp.Auto_Stop_on_Rejection__c = 'Deferred';
            routeTemp.Calculate_due_date_based_on__c = 'Customer response date';
            routeTemp.Description__c = 'Test';
            routeTemp.Route_Base_Purpose__c = 'Standard';
            routeTemp.Route_Name__c = 'Test';
            routeTemp.Status__c = 'InProgress';
            insert routeTemp;
        
            Task_Template__c tskTemp = new Task_Template__c();
            tskTemp.Route_Template__c = routeTemp.id;
            tskTemp.Action_Type__c = 'Comment';
            tskTemp.Allow_Delegation__c = true;
            tskTemp.Due_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp.Due_Date_Diff_Negotiation_Date__c = 10;
            tskTemp.Duration__c = 1;
            tskTemp.Order__c = 1;
            tskTemp.Start_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp.Start_Date_Diff_Negotiation_Date__c = 10;
            tskTemp.Task_Name__c = 'ISC';
            tskTemp.Task_Type__c = 'Test';
            tskTemp.Task_Status__c = 'InProgress';
            insert tskTemp;
            
            Task_Template__c tskTemp1 = new Task_Template__c();
            tskTemp1.Route_Template__c = routeTemp.id;
            tskTemp1.Action_Type__c = 'Comment';
            tskTemp1.Allow_Delegation__c = true;
            tskTemp1.Due_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp1.Due_Date_Diff_Negotiation_Date__c = 10;
            tskTemp1.Duration__c = 1;
            tskTemp1.Order__c = 2;
            tskTemp1.Predecessor_Task_Order__c = 1;
            tskTemp1.Start_Date_Diff_Customer_Response_Date__c = 10;
            tskTemp1.Start_Date_Diff_Negotiation_Date__c = 10;
            tskTemp1.Task_Name__c = 'ISC';
            tskTemp1.Task_Type__c = 'Test';
            tskTemp1.Task_Status__c = 'InProgress';
            insert tskTemp1;
            
            Test.startTest();
                 BNPCreateRouteFromTemplateCtrl.BNPCreateRouteFromTemplate(routeTemp.id, reqInfo.id);
            Test.stopTest() ; 
        }
    }
}