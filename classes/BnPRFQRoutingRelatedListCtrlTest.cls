/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016
    Description: Test class for BnPRFQRoutingRelatedListCtrl
*/
@isTest
public class BnPRFQRoutingRelatedListCtrlTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = 'RT';
            bnpRFQRouteRelatedList.noOfTask = 0;
            bnpRFQRouteRelatedList.createdByUser = '';
            bnpRFQRouteRelatedList.routeBasePurpose = 'None';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod1(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = '';
            bnpRFQRouteRelatedList.noOfTask = 2;
            bnpRFQRouteRelatedList.createdByUser = '';
            bnpRFQRouteRelatedList.routeBasePurpose = 'None';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod2(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = '';
            bnpRFQRouteRelatedList.noOfTask = 0;
            bnpRFQRouteRelatedList.createdByUser = 'test';
            bnpRFQRouteRelatedList.routeBasePurpose = 'None';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod3(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = '';
            bnpRFQRouteRelatedList.noOfTask = 0;
            bnpRFQRouteRelatedList.createdByUser = '';
            bnpRFQRouteRelatedList.routeBasePurpose = 'Standard';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod4(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = 'RT';
            bnpRFQRouteRelatedList.noOfTask = 2;
            bnpRFQRouteRelatedList.createdByUser = '';
            bnpRFQRouteRelatedList.routeBasePurpose = 'Standard';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRFQRoutingRelatedListMethod5(){
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
            system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '2');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            /*Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Start_date__c', datetime.newInstance(2016, 10, 13, 12, 30, 0));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);*/
            
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
            
            /*Task_Template__c tskTemp1 = new Task_Template__c();
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
            insert tskTemp1;*/
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRoute);
            BnPRFQRoutingRelatedListCtrl bnpRFQRouteRelatedList = new BnPRFQRoutingRelatedListCtrl(sc);
            bnpRFQRouteRelatedList.templateName = 'RT';
            bnpRFQRouteRelatedList.noOfTask = 0;
            bnpRFQRouteRelatedList.createdByUser = '';
            bnpRFQRouteRelatedList.routeBasePurpose = 'Standard';
            bnpRFQRouteRelatedList.find();
            bnpRFQRouteRelatedList.refresh();
            bnpRFQRouteRelatedList.first();
            bnpRFQRouteRelatedList.last();
            bnpRFQRouteRelatedList.hasNext = true;
            bnpRFQRouteRelatedList.hasPrevious = true;
            bnpRFQRouteRelatedList.pageNumber  = 1;
            bnpRFQRouteRelatedList.previous();
            bnpRFQRouteRelatedList.next();
            
            Test.stopTest() ; 
        }
    }
}