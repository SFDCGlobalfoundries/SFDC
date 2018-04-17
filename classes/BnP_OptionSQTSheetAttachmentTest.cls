/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 10/01/2017 
    Description: Test class for BnP_OptionSQTSheetAttachment
*/
@isTest
public class BnP_OptionSQTSheetAttachmentTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpRFQSRTestMethod(){
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
            
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('Option__c',opt1.id);
            fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',false);
            fieldValueFinanceQuoteDocumentMap.put('Is_SQT_sheet__c',true);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(opt1);
            BnP_OptionSQTSheetAttachment bnpSQTSheetCtrl = new BnP_OptionSQTSheetAttachment(sc);
            bnpSQTSheetCtrl.displatAttachment();
            bnpSQTSheetCtrl.saveApplicant();
            Test.stopTest() ; 
        }
    }
}