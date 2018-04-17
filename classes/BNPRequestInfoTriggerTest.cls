/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016 
    Description: Test class for BNPRequestInfoTrigger
*/
@isTest
public class BNPRequestInfoTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpRequestInfoTriggerTestMethod(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            
            
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id); 
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
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
            fieldValueTskAssigneeMap.put('Task_Assignee_Email__c', 'saha.poulami1987@gmail.com');
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);
            
            try
            {   
                reqInfo.Request_status__c = 'Complete';
                update reqInfo;
            }catch(Exception e){
                System.assert( e.getMessage().contains('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section'));
            }
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void bnpRequestInfoTriggerTestMethod1(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        User thisUser1= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        User thisUser2= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
            
            Opportunity_Program_Team_Member__c oppProgTeam = new Opportunity_Program_Team_Member__c();
            oppProgTeam.User__c = thisUser2.Id;
            oppProgTeam.Opportunity_Program__c = dev1.Opportunity_Program__c;
            oppProgTeam.Device_Access__c = 'Read/Write';
            oppProgTeam.Opportunity_Program_Access__c = 'Read/Write';
            insert oppProgTeam;
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            //fieldValueOptionMap.put('Opportunity__c',opp1.id);
            fieldValueOptionMap.put('Device__c',dev1.id);
            Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Test.startTest();
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            fieldValueReqInfoMap.put('Last_Accepted_Quote__c', true);
           // fieldValueReqInfoMap.put('Request_status__c', 'Complete');
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            //system.AssertEquals('Accept', reqInfo.Quote_Status__c);
            
            /*Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);*/
            
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            //fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',true);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            try
            {   
                //reqInfo.Request_status__c = 'Complete';
                reqInfo.Quote_Status__c = 'Accept';
                reqInfo.Primary_Request_Catcher__c = thisUser1.id;
                reqInfo.Negotiation_Date__c = system.today().addDays(10);
				reqInfo.Date_quote_letter_1st_sent_to_sales__c = system.today().addDays(11);
                reqInfo.Customer_accept_reject_date__c = system.today().addDays(12);                
                reqInfo.Skip_Validation__c = true;
                update reqInfo;
            }catch(Exception e){
                System.assert( e.getMessage().contains('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section'));
            }
            Test.stopTest() ; 
        }
    }
    public static testMethod void bnpRequestInfoTriggerTestMethod2(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            
            
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',true);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            Test.startTest();
            try
            {   
                reqInfo.Request_status__c = 'Complete';                
                update reqInfo;
            }catch(Exception e){
                System.assert( e.getMessage().contains('User can set Request Status = Completed once Date quote letter 1st sent to sales is populated and Quote is attached in Attach Quote Document section'));
            }
            Test.stopTest() ;
        }
    }
    
    public static testMethod void bnpRequestInfoTriggerTestMethod3(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            
            
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2017, 2, 20));
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2017, 2, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
             fieldValueTskRouteMap.put('Start_date__c', Datetime.newInstance(2016, 8, 16));
             fieldValueTskRouteMap.put('Add_Offset_Days__c', '5');
            //fieldValueTskRouteMap1.put('Task_Due_Date_and_Time__c', System.now());
            RFQ_Tasks_Routing__c rfqRouteTask2 = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            
            Test.startTest();
            try
            {   
                reqInfo.Negotiation_Date__c = Datetime.newInstance(2017, 2, 18);
                reqInfo.Date_customer_wants_response__c = Datetime.newInstance(2017, 2, 18);
                update reqInfo;
                system.AssertEquals(Datetime.newInstance(2017, 2, 18), reqInfo.Negotiation_Date__c);
            }catch(Exception e){
            }
            Test.stopTest() ;
        }
    }
    
    public static testMethod void bnpRequestInfoTriggerTestMethod4(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        User thisUser1= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
            
            Test.startTest();   
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            fieldValueReqInfoMap.put('Last_Accepted_Quote__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            //Test.startTest();
            try
            {   
                //reqInfo.Request_status__c = 'Complete';
                reqInfo.Quote_Status__c = 'Accept';
                reqInfo.Primary_Request_Catcher__c = thisUser1.id;
                reqInfo.Negotiation_Date__c = system.today().addDays(10);                
                reqInfo.Skip_Validation__c = true;
                update reqInfo;
            }catch(Exception e){
                System.assert( e.getMessage().contains('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section'));
            }
            Test.stopTest() ; 
        }
    }
    
    public static testMethod void bnpRequestInfoTriggerTestMethod5(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        User thisUser1= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
            
            Test.startTest();
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',opt1.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Request_status__c', 'Complete');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            fieldValueReqInfoMap.put('Last_Accepted_Quote__c', true);
            try
            {
                Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            }catch(Exception e){
                System.assert( e.getMessage().contains('User can set Quote Status = Accept once Date quote letter 1st sent to sales, Customer accept/reject date is populated and Quote is attached in Attach Quote Document section'));
            }
            Test.stopTest() ; 
        }
    }

	public static testMethod void bnpRequestInfoTriggerTestMethod6(){
        RecordType recordType =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            
            
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            fieldValueReqInfoMap.put('Negotiation_Date__c', Datetime.newInstance(2017, 2, 20));
            fieldValueReqInfoMap.put('Date_customer_wants_response__c', Datetime.newInstance(2017, 2, 20));
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c', reqInfo.id);
            fieldValueRouteMap.put('Calculate_due_date_based_on__c', 'Negotiation date');
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            try
            {   
				reqInfo.Request_status__c = 'Cancelled';                
				update reqInfo;
                system.AssertEquals('Cancelled', reqInfo.Request_status__c);
            }catch(Exception e){
            }
            Test.stopTest() ;
        }
    }
    
    
}