/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016 
    Description: Test class for BNPTaskAssigneeCreateCtrl
*/
@isTest
public class BNPTaskAssigneeCreateCtrlTest 
{
    @testSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpTaskAssigneeCreateTestMethod()
    {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];       
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
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
            //fieldValueReqInfoMap.put('Account__c',account1.id);
            //fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
			system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Test.startTest();
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
        
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            //fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', 'saha.poulami1987@gmail.com');
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
        
            //Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRouteTaskAssignee);
            /*BNPTaskAssigneeCreateCtrl bnpTskassigneeCreate = new BNPTaskAssigneeCreateCtrl(sc);
            bnpTskassigneeCreate.getCountriesOptions();
            bnpTskassigneeCreate.selectedCountry1 = 'User';
            bnpTskassigneeCreate.usrGrpName = thisUser.Name;
            bnpTskassigneeCreate.usrGrpId = thisUser.id;
            bnpTskassigneeCreate.Save();
            bnpTskassigneeCreate.refreshsection();
            bnpTskassigneeCreate.cancel();*/
            
            BNPTaskAssigneeCreateCtrl bnpTskassigneeCreate1 = new BNPTaskAssigneeCreateCtrl(sc);
            bnpTskassigneeCreate1.getCountriesOptions();
            bnpTskassigneeCreate1.selectedCountry1 = 'Group';
            bnpTskassigneeCreate1.usrGrpName = thisGrp.Name;
            bnpTskassigneeCreate1.usrGrpId = thisGrp.id;
            bnpTskassigneeCreate1.Save();
            bnpTskassigneeCreate1.refreshsection();
            bnpTskassigneeCreate1.cancel();
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void bnpTaskAssigneeCreateTestMethodforUser()
    {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];       
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        system.debug('<==> AM1 : '+ thisUser.Name);
        System.runAs(thisUser)
        {
            Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
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
            
            fieldValueOptionMap.put('Device__c',dev1.id);
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
			system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Test.startTest();
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
        
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
        
            //Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRouteTaskAssignee);
            BNPTaskAssigneeCreateCtrl bnpTskassigneeCreate = new BNPTaskAssigneeCreateCtrl(sc);
            bnpTskassigneeCreate.getCountriesOptions();
            bnpTskassigneeCreate.selectedCountry1 = 'User';
            system.debug('<==> AM : '+ thisUser.Name);
            bnpTskassigneeCreate.usrGrpName = 'Testing';
            bnpTskassigneeCreate.usrGrpId = thisUser.id;
            bnpTskassigneeCreate.Save();
            bnpTskassigneeCreate.refreshsection();
            bnpTskassigneeCreate.cancel();
                        
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void bnpTaskAssigneeTestMethodforUser1()
    {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];       
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(thisUser)
        {
            Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
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
            
            fieldValueOptionMap.put('Device__c',dev1.id);
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
			system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);			
            
            Test.startTest();
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
        
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
        
            //Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRouteTaskAssignee);
            BNPTaskAssigneeCreateCtrl bnpTskassigneeCreate = new BNPTaskAssigneeCreateCtrl(sc);
            bnpTskassigneeCreate.getCountriesOptions();
            bnpTskassigneeCreate.selectedCountry1 = 'User';
            bnpTskassigneeCreate.usrGrpName = 'Testing1111';
            bnpTskassigneeCreate.usrGrpId = thisUser.id;
            bnpTskassigneeCreate.Save();
            bnpTskassigneeCreate.refreshsection();
            bnpTskassigneeCreate.cancel();
                        
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void bnpTaskAssigneeTestMethodforGroup1()
    {
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];       
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            Group thisGrp = [Select Id, Name from Group where developerName = 'CE_Users' and Type = 'Regular'];
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
            
            fieldValueOptionMap.put('Device__c',dev1.id);
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
			system.AssertEquals(thisUser.id, reqInfo.Primary_Request_Catcher__c);
            
            Test.startTest();
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            fieldValueTskRouteMap.put('Start_date__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
        
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            fieldValueTskAssigneeMap.put('User__c', thisUser.id);
            
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
        
            //Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(rfqRouteTaskAssignee);
                     
            BNPTaskAssigneeCreateCtrl bnpTskassigneeCreate1 = new BNPTaskAssigneeCreateCtrl(sc);
            bnpTskassigneeCreate1.getCountriesOptions();
            bnpTskassigneeCreate1.selectedCountry1 = 'Group';
            bnpTskassigneeCreate1.usrGrpName = 'Testing1111';
            bnpTskassigneeCreate1.usrGrpId = thisGrp.id;
            bnpTskassigneeCreate1.Save();
            bnpTskassigneeCreate1.refreshsection();
            bnpTskassigneeCreate1.cancel();
            Test.stopTest() ; 
        }
    }
}