/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 19/04/2017 
    Description: Test class for BnP_AttachCostingFile
*/
@isTest
public class BnP_AttachCostingFileTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void bnpAttachCostingFileTestMethod(){
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        //User thisUser = [select Id from User where Profile.Name ='System Administrator' and isActive = true limit 1];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        /*HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='Testing';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        hcmemp.Login_ID__c ='abc';        
        
        insert hcmemp;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='GF Consultants']; 
        String uEmail='standarduser'+ DateTime.now().getTime()+'@testorg.com';
        User thisUser = new User(Alias = 'standt', Email=uEmail, 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id,isActive = true,
          TimeZoneSidKey='America/Los_Angeles', UserName=uEmail, HCM_Record_ID__c=hcmemp.id,FederationIdentifier='177314' );
        insert thisUser;*/
        
        System.assert(thisUser.id != null);
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;

        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
        fieldValuepoppProgramMap1.put('Account__c',account1.id);
        fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
        Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
        oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Device_Sourcing__c','Sole Source');
        fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
        Device__c Dev1 = new Device__c ();
        Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',Dev1.Id);
        Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
        fieldValueReqInfoMap.put('Account__c',account1.id);
        fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
        fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
        fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
        fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
        Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        
        Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
        fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
        fieldValueFinanceQuoteDocumentMap.put('Is_Costing_Document__c',true);
        BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
        
        Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
        fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
        Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(reqInfo);
        BnP_AttachCostingFile bnpCostingFileList = new BnP_AttachCostingFile(sc);
        bnpCostingFileList.displatAttachment();
        bnpCostingFileList.saveApplicant();
        Test.stopTest() ; 
      }  
    }
}