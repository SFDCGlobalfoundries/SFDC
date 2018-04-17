/*
    Author: Poulami Saha
    Project Name: DIW Step Down Track 2 (BnP)
    Created Date: 18/08/2016 
    Description: Test class for BNPRequestInfoTrigger
*/
@isTest
public class BnPRequestInfo_RevenueSnapShotTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    public static testMethod void BnPRequestInfo_RevenueSnapShotTestMethod(){
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
            fieldValueOptionMap.put('Opportunity__c',opp1.id);
            Customer_Requirement__c  options = BNP_DataFactory.createOption(fieldValueOptionMap);
            
            List<Quarterly_Revenue_Object__c> qrevList = new list<Quarterly_Revenue_Object__c>();
              
             //Creating a new DG record and assigning the newoppid
             
             Quarterly_Revenue_Object__c   qrev =  new Quarterly_Revenue_Object__c();
                qrev.Fiscal_Quarter__c  = '2011-Q1';
                //qrev.NRE__c         =   10000;
                qrev.ASP__c         =   10000;
                qrev.Volume__c      =   10000;
                qrev.date__c        =   system.today();
                qrev.Opportunity__c =   opp1.id;
                qrev.ASP_Module_Chip__c = 100;
                qrev.Volume_Module_Chip__c = 100;
                //qrev.Revenue__c = 1000;
            qrevList.add(qrev);
            
            Quarterly_Revenue_Object__c   qrev11 =  new Quarterly_Revenue_Object__c();
                qrev11.Fiscal_Quarter__c  = '2011-Q2';
                //qrev11.NRE__c         =   10000;
                qrev11.ASP__c         =   10000;
                qrev11.Volume__c      =   10000;
                qrev11.date__c        =   system.today();
                qrev11.Opportunity__c =   opp1.id;
                qrev11.ASP_Module_Chip__c = 100;
                qrev11.Volume_Module_Chip__c = 100;
                //qrev11.Revenue__c = 1000;
            qrevList.add(qrev11);
                  
            Quarterly_Revenue_Object__c   qrev1 =  new Quarterly_Revenue_Object__c();
                qrev1.Fiscal_Quarter__c         = '2012-2013';
                qrev1.date__c                   =   system.today();
                //qrev1.NRE__c                    =   10000;
                qrev1.ASP__c                    =   10000;
                qrev1.Volume__c                 =   10000;
                qrev1.Opportunity__c            =   opp1.id;
                qrev1.ASP_Module_Chip__c = 100;
                qrev1.Volume_Module_Chip__c = 100;
                //qrev1.Revenue__c = 1000;
            qrevList.add(qrev1);
                 
            Quarterly_Revenue_Object__c   qrev2 =  new Quarterly_Revenue_Object__c();
                qrev2.Fiscal_Quarter__c = '2013-2014';
                //qrev2.NRE__c            =   10000;
                qrev2.ASP__c            =   10000;
                qrev2.Volume__c         =   10000;
                qrev2.date__c           =   system.today();
                qrev2.Opportunity__c    =   opp1.id;
                qrev2.ASP_Module_Chip__c = 100;
                qrev2.Volume_Module_Chip__c = 100;
                //qrev2.Revenue__c = 1000;
            qrevList.add(qrev2);
            insert qrevList;   
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Account__c',account1.id);
            fieldValueReqInfoMap.put('Opportunity__c',opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c',options.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordType.id);
            fieldValueReqInfoMap.put('Date_quote_letter_1st_sent_to_sales__c', system.now());
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
            system.AssertEquals(System.now(), reqInfo.Date_quote_letter_1st_sent_to_sales__c);
            test.startTest();
            
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',false);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            reqInfo.quote_status__c = 'Reject';
            update reqInfo;  
            
             
            Request_Information_Revenue_Snap__c    reqRev =  new Request_Information_Revenue_Snap__c ();
            reqRev.Request_Information__c = reqInfo.id;
            reqRev.ASP__c = 10000;
            reqRev.Volume__c = 10000;
            insert reqRev;
            test.stoptest();  
        
   }
  }     
 }