/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016 
    Description: Test class for RfqTaskRoutingTrigger
*/
@isTest
public class BNPTaskRoutingTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Complete__c', true);
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Adjusted_Start_Date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Actual_End_Date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 7, 16));
            
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            
            Map<String,Object> fieldValueTskRouteMap2 = new Map<String,Object>();
            fieldValueTskRouteMap2.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap2.put('Sequence__c', 'All');
            fieldValueTskRouteMap2.put('Order__c', 2);
            //fieldValueTskRouteMap1.put('Task_Due_Date_and_Time__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask2 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap2);
            system.AssertEquals('All', rfqRouteTask2.Sequence__c);
            
            Map<String,Object> fieldValueTskRouteMap3 = new Map<String,Object>();
            fieldValueTskRouteMap3.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap3.put('Sequence__c', 'All');
            fieldValueTskRouteMap3.put('Order__c', 2);
            fieldValueTskRouteMap3.put('Start_date__c', Datetime.newInstance(2016, 8, 16));
            fieldValueTskRouteMap3.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 8, 17));
            fieldValueTskRouteMap3.put('Parent_task__c', rfqRouteTask1.id);
            fieldValueTskRouteMap3.put('Select_Task_Name__c', 'Cost');
            //RFQ_Tasks_Routing__c rfqRouteTask3 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap3);
        
       
            
            try{
                RFQ_Tasks_Routing__c rfqRouteTask3 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap3);
            }catch(Exception e){}
            Test.stopTest() ;
        }
       
    }
    
    public static testMethod void rfqTaskRoutingTriggerTestMethod1(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', System.now());
            //fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 17));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Select_Task_Name__c', 'ISC');
            fieldValueTskRouteMap.put('Task_Name__c', '');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap.put('order_New__c', 1);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('ISC', rfqRouteTask.Select_Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Select_Task_Name__c', 'ISC');
            fieldValueTskRouteMap1.put('Task_Name__c', '');
            fieldValueTskRouteMap1.put('Predecessor_Task__c', rfqRouteTask.id);
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap.put('order_New__c', 2);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask1.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            fieldValueTskAssigneeMap.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', thisUser.Email);
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);            
                    
            
            
            rfqRouteTask.Complete__c = true;
            rfqRouteTask.Task_Due_Date_and_Time__c = Datetime.newInstance(2017, 1, 17);
            rfqRouteTask.Adjusted_Start_Date__c = Datetime.newInstance(2017, 1, 17);
            rfqRouteTask.Actual_End_Date__c = Datetime.newInstance(2017, 1, 17);
            update rfqRouteTask;
            Test.stopTest() ;
        }
        
    }

    public static testMethod void rfqTaskRoutingTriggerTestMethod2(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 17));
            //fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 17));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Customer response date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            system.AssertEquals(reqInfo.id, rfqRoute.RFQ__c);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            //fieldValueTskRouteMap.put('Select_Task_Name__c', 'ISC');
            fieldValueTskRouteMap.put('Task_Name__c', '');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            
            //RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            try{
                RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            }catch(Exception e){}
            Test.stopTest();
        }
  
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod3(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            //fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Customer response date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap.put('Task_Status__c', 'Pause');
            fieldValueTskRouteMap.put('Pause_Reason__c', 'CEST Optimization Assessment');
            //fieldValueTskRouteMap.put('Complete__c',true);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            //fieldValueTskRouteMap1.put('Complete__c',true);
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            try{
                RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            }catch(Exception e){}
           Test.stopTest();
        }
    }
     public static testMethod void rfqTaskRoutingTriggerTestMethod4(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            //fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap.put('Complete__c',true);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '2');
            //fieldValueTskRouteMap1.put('Complete__c',true);
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            try{
                RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            }catch(Exception e){}
            Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod5(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            //Test.startTest();
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
            //fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Customer response date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
			Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap.put('Complete__c',true);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 19));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap1.put('Complete__c',true);
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            try{
                RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            }catch(Exception e){}
            Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod6(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            //Test.startTest();
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            //fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
			Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap.put('Complete__c',true);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 19));
            //fieldValueTskRouteMap.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap1.put('Complete__c',true);
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            try{
                RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            }catch(Exception e){}
           Test.stopTest();
        }
    }
     
    
     
    public static testMethod void rfqTaskRoutingTriggerTestMethod7(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Customer response date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            try{
                rfqRouteTask1.Add_Offset_Days__c = '2';
                update rfqRouteTask1;
            }catch(Exception e){}
            Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod8(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            //Test.startTest();
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            try{
                rfqRouteTask1.Add_Offset_Days__c = '2';
                update rfqRouteTask1;
            }catch(Exception e){}
             Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod9(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            //Test.startTest();
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
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Customer response date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            try{
                rfqRouteTask1.Start_date__c = Datetime.newInstance(2016, 9, 19);
                rfqRouteTask1.Predecessor_Task__c = rfqRouteTask.id;
                update rfqRouteTask1;
            }catch(Exception e){}
           Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod10(){
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 18));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            //fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            try{
                rfqRouteTask1.Start_date__c = Datetime.newInstance(2016, 9, 19);
                rfqRouteTask1.Predecessor_Task__c = rfqRouteTask.id;
                update rfqRouteTask1;
            }catch(Exception e){}
          Test.stopTest();
        }
    }
    public static testMethod void rfqTaskRoutingTriggerTestMethod11()
    {
      
      //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
           
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
            
            Test.startTest();
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2016, 9, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
                                
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
                       
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Task_Name__c', 'Test');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 15));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.debug('rfqRouteTask id :' +rfqRouteTask.id);
            system.AssertEquals('Test', rfqRouteTask.Task_Name__c);         
                                   
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Name__c', 'Testdata');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 16));
            fieldValueTskRouteMap1.put('Add_Offset_Days__c', '1');
            fieldValueTskRouteMap1.put('Predecessor_Task__c',rfqRouteTask.id);
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            system.debug('rfqRouteTask1 id :' +rfqRouteTask1.id);
            RFQ_Tasks_Routing__c rfqRouteTaskNew = [Select Id, Name, Predecessor_Task__c, Predecessor_Task__r.Name, Start_Date__c, Add_Offset_Days__c, End_Date__c, Task_Due_Date_and_Time__c, order__c, Negotiation_Date1__c, Complete__c, Calculate_due_date_based_on_new__c, Action__c from RFQ_Tasks_Routing__c WHERE Predecessor_Task__c =: rfqRouteTask.id];
            system.debug('rfqRouteTask1 id :' +rfqRouteTask1.id);
            system.debug('rfqRouteTaskNew :' +rfqRouteTaskNew);
            
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask1.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            fieldValueTskAssigneeMap.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', thisUser.Email);
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);    
                                  
            try
            {
                rfqRouteTask.Complete__c = true;
                update rfqRouteTask;
                               
            }
            catch(Exception e){system.debug('Error Message :' +e.getMessage());}
            Test.stopTest();
        }
    }
    
    public static testMethod void rfqTaskRoutingTriggerTestMethod12(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            
            Map<String,Object> fieldValueTskRouteMap1 = new Map<String,Object>();
            fieldValueTskRouteMap1.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap1.put('Task_Status__c', 'Cancel');
            fieldValueTskRouteMap1.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap1.put('Task_Due_Date_and_Time__c', Datetime.newInstance(2016, 7, 16));
            
            RFQ_Tasks_Routing__c rfqRouteTask1 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap1);
            
            Map<String,Object> fieldValueTskRouteMap2 = new Map<String,Object>();
            fieldValueTskRouteMap2.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap2.put('Sequence__c', 'All');
            fieldValueTskRouteMap2.put('Order__c', 2);
            //fieldValueTskRouteMap1.put('Task_Due_Date_and_Time__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask2 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap2);
            system.AssertEquals('All', rfqRouteTask2.Sequence__c);
            
            Test.stopTest() ;
        }
       
    }
    
    public static testMethod void rfqTaskRoutingTriggerTestMethod13(){
        //RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            //Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
            
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
            fieldValueReqInfoMap.put('Negotiation_Date__c', System.now());
            //fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2016, 9, 17));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Select_Task_Name__c', 'ISC');
            fieldValueTskRouteMap.put('Task_Name__c', '');
            fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 9, 17));
            fieldValueTskRouteMap.put('Add_Offset_Days__c', '1');
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            system.AssertEquals('ISC', rfqRouteTask.Select_Task_Name__c);
            
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            fieldValueTskAssigneeMap.put('All_Task_Assignee_Id__c', thisUser.id);
            fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', thisUser.Email);
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);            
                    
            
            
            rfqRouteTask.Task_Status__c = 'Cancel';
           
            update rfqRouteTask;
            Test.stopTest() ;
        }
        
    }
}