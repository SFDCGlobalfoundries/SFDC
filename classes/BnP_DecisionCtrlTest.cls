/*
Type Name: BnP_DecisionCtrlTest
Author: Meghna Ganguly
Created Date: 30-November-2016
Reason: This is the Test class for class BnP_DecisionCtrl. 
Change History:
Author: 
Modified by: Arijit - 17/04/2017
Reason: Modified in Test Method CustomerDecisionCtrle_Test()
*/

@istest
   
   public class BnP_DecisionCtrlTest 
   {    
 
 @testSetup static void testdata() {
      DataUtilTest.loadEnvironmentVariables();
  }
     //test method for edit record 
     static testMethod void CustomerDecisionCtrle_Test(){
    
     List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            fieldValueOppMap.put('Contract_Pricing__c','Yes');
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
        
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
             
           Map<String,Object> fieldValueDecisionMap = new Map<String,Object>();
           fieldValueDecisionMap.put('Account__c',account1.id);  
           fieldValueDecisionMap.put('Opportunity__c',opp1.id);
           fieldValueDecisionMap.put('Technical_Requirement__c',cr.id);
           fieldValueDecisionMap.put('Functionality_Date__c',Date.Today().addDays(10));
           Decision__c dec = BNP_DecisionDataFactory.createDecision(fieldValueDecisionMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
           
            Map<String,Object> fieldValueTechReviewMap = new Map<String,Object>();
            fieldValueTechReviewMap.put('Opportunity__c', opp1.id);
            fieldValueTechReviewMap.put('Device__c', Dev1.id);
            fieldValueTechReviewMap.put('Option__c', cr.id);
            fieldValueTechReviewMap.put('Request_Information__c', reqInfo.id);
            fieldValueTechReviewMap.put('Option_RTM_Ready__c', system.today());
            Tech_Review_Summary__c techReview = BNP_DecisionDataFactory.createTechReview(fieldValueTechReviewMap);
            
           Map<String,Object> fieldValueChargeMap = new Map<String,Object>();
           fieldValueChargeMap.put('Option__c',cr.id);
           fieldValueChargeMap.put('Charge_Number__c','12345');    
           fieldValueChargeMap.put('Charge_Type__c','Customer PO Number');
           Charge_Info__c chargeInfo = BNP_DecisionDataFactory.createChargeInfo(fieldValueChargeMap);
           
           Map<String,Object> fieldValueSAPorderdetailsMap = new Map<String,Object>();
           fieldValueSAPorderdetailsMap.put('Charge_Info__c',chargeInfo.id);
           fieldValueSAPorderdetailsMap.put('SAP_Order_Number__c','test order');    
           fieldValueSAPorderdetailsMap.put('SAP_SoldTo__c','test');    
           fieldValueSAPorderdetailsMap.put('Yield_Mngmnt_Data_Deliveryto__c','test');    
           fieldValueSAPorderdetailsMap.put('Order_Type__c','Services');
           SAP_Order_Detail__c  SAPOrder = BNP_DecisionDataFactory.createSapOrder(fieldValueSAPorderdetailsMap);
        
            test.startTest();
            Decision__c  dsc1 = new Decision__c ();
            
            dsc1 = [select id,name,Opportunity__c,Opportunity__r.Product_Line__c,Opportunity__r.Date_Design_Win_Approved__c,Account__c,Technical_Requirement__c,Request_Information__c from Decision__c where Opportunity__c!=null limit 1  ];
            dsc1.Status__c = 'Completed';
            dsc1.Opportunity__r.Product_Line__c = 'ASIC' ;
            dsc1.Opportunity__r.Date_Design_Win_Approved__c = system.today();
            update dsc1;
            system.AssertEquals('Completed', dsc1.Status__c);
            
            ApexPages.currentPage().getParameters().put('optionId', cr.id);
            ApexPages.currentPage().getParameters().put('retURL', '/');
            BNP_TechReviewMessageCtrl ctrl = new BNP_TechReviewMessageCtrl();
            ctrl.goToRFQ();
            ctrl.goBack();
            
            cr.Option_Stage__c = 'Prototype Fulfillment';
            update cr;
            
            Id foundryRecTypeId = Schema.SObjectType.Tech_Review_Summary__c.getRecordTypeInfosByName().get('Foundry').getRecordTypeId();
        
            
            Tech_Review_Summary__c tr = new Tech_Review_Summary__c(Decision__c = dsc1.id, RecordTypeId = foundryRecTypeId, Option__c = cr.Id, Device__c=Dev1.id);
            insert tr;
            pagereference pag = page.BNP_PromoteToCustomerDecision;
            pag.getParameters().put('trId', tr.id);
            Test.SetCurrentPage(pag);
            
            BNP_PromoteToCustomerDecisionCtrl ctrl1 = new BNP_PromoteToCustomerDecisionCtrl();
            ctrl1.goToDecision();
            ctrl1.goToTR();
            tr.Approval_to_proceed_to_RTM__c = true;
            update tr;
            tr.RIT_outlook__c = System.today();
            tr.RTM_outlook__c = System.today();
            update tr;
            ctrl1.goToDecision();
             Attachment attach1 = new Attachment();
            attach1.Name='Test_Functionality';
            Blob bodyBlob1=Blob.valueOf('Unit Test Functionality Attachment Body');
            attach1.body=bodyBlob1;
            attach1.parentId=dec.Id;
            attach1.OwnerId = UserInfo.getUserId();
            insert attach1;
            System.debug('@@@attach1.Id: ' + attach1.Id);
            Attachment attach2 = new Attachment();
            attach2.Name='Test_PO';
            Blob bodyBlob2=Blob.valueOf('Unit Test PO Attachment Body');
            attach2.body=bodyBlob2;
            attach2.parentId=dec.Id;
            attach2.OwnerId = UserInfo.getUserId();
            insert attach2;
            System.debug('@@@attach2.Id: ' + attach2.Id);
            //test.startTest();
         
            Pagereference pf = Page.BnP_DecisionNew; 
            pf.getParameters().put('reqInfoId', reqInfo.id);
            pf.getParameters().put('trId', cr.id);
            pf.getParameters().put('accId', account1.id);
            pf.getParameters().put('oppId', opp1.id); 
            pf.getParameters().put('deviceId', Dev1.id); 
            Test.setCurrentPage(pf);
            
            BnP_DecisionCtrl cdc = new BnP_DecisionCtrl();
            cdc.getExistingDecisionId();
            cdc.decisionRecord = dec;
            cdc.funcattachmentname = 'Test_Functionality';
            cdc.funcattachmentbody = Blob.valueOf('Unit Test Functionality Attachment Body');
            cdc.doSave();
            cdc.doEdit();
            cdc.doCancel();
            cdc.getTypesOfFile();
            cdc.selectedFileType = 'Functionality Statement';
            cdc.uploadAttachments();         
            cdc.goToTechReview();
            cdc.getAttachmentList();
            try{
         
            cdc.validateQuote();
            }catch(exception e){}
            cdc.getTRList();           
            cdc.addSapOrder();
            system.currentpagereference().getparameters().put('index', '1');
            cdc.removeSapOrder();
            cdc.doSave();
            techReview.Option_RTM_Ready__c = system.today().addDays(1);
            update techReview;
            reqInfo.Primary_Request_Catcher__c = userinfo.getuserid();
            update reqInfo;
        
        test.stopTest();
       
     }
   }
   
   //test method for new record
   static testMethod void CustomerDecisionCtrle_Test2(){
    
     List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            fieldValueOppMap.put('Contract_Pricing__c','Yes');
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
        
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
             
           
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
        
          
            
            test.startTest();
            
            Map<String,Object> fieldValueDecisionMap = new Map<String,Object>();
           fieldValueDecisionMap.put('Account__c',account1.id);  
           fieldValueDecisionMap.put('Opportunity__c',opp1.id);
           fieldValueDecisionMap.put('Technical_Requirement__c',cr.id);
           fieldValueDecisionMap.put('Functionality_Date__c',Date.Today().addDays(10));
           Decision__c dec = BNP_DecisionDataFactory.createDecision(fieldValueDecisionMap);
           system.AssertEquals(cr.id, dec.Technical_Requirement__c);
           
            Map<String,Object> fieldValueChargeMap = new Map<String,Object>();
           fieldValueChargeMap.put('Option__c',cr.id);
           Charge_Info__c chargeInfo = BNP_DecisionDataFactory.createChargeInfo(fieldValueChargeMap);
           
           Map<String,Object> fieldValueSAPorderdetailsMap = new Map<String,Object>();
           fieldValueSAPorderdetailsMap.put('Charge_Info__c',chargeInfo.id);
           SAP_Order_Detail__c  SAPOrder = BNP_DecisionDataFactory.createSapOrder(fieldValueSAPorderdetailsMap);
            
            
            Pagereference pf1 = Page.BnP_DecisionNew; 
            pf1.getParameters().put('reqInfoId', reqInfo.id);
            pf1.getParameters().put('trId', cr.id);
            pf1.getParameters().put('accId', account1.id);
            pf1.getParameters().put('oppId', opp1.id); 
            pf1.getParameters().put('deviceId', Dev1.id); 
            Test.setCurrentPage(pf1);
            
            BnP_DecisionCtrl cdc = new BnP_DecisionCtrl();
            cdc.getExistingDecisionId();
            cdc.doSave();
            cdc.doEdit();
            cdc.doCancel();
                      
            cdc.goToTechReview();
           
            try{
         
            cdc.validateQuote();
            }catch(exception e){}
            cdc.getTRList();           
            cdc.addSapOrder();
            system.currentpagereference().getparameters().put('index', '1');
            cdc.removeSapOrder();
            cdc.doSave();

        
        test.stopTest();
       
     }
   }
   //test method for view record
   static testMethod void CustomerDecisionCtrle_Test1(){
     
      List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
               
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            fieldValueOppMap.put('Contract_Pricing__c','Yes');
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
        
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
             
           
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
           
           
            
            Map<String,Object> fieldValueDecisionMap = new Map<String,Object>();
           fieldValueDecisionMap.put('Account__c',account1.id);  
           fieldValueDecisionMap.put('Opportunity__c',opp1.id);
           fieldValueDecisionMap.put('Technical_Requirement__c',cr.id);
           Decision__c dec = BNP_DecisionDataFactory.createDecision(fieldValueDecisionMap);
           system.AssertEquals(cr.id, dec.Technical_Requirement__c);
            
           Map<String,Object> fieldValueChargeMap = new Map<String,Object>();
           fieldValueChargeMap.put('Option__c',cr.id);
           Charge_Info__c chargeInfo = BNP_DecisionDataFactory.createChargeInfo(fieldValueChargeMap);
            
           Map<String,Object> fieldValueSAPorderdetailsMap = new Map<String,Object>();
           fieldValueSAPorderdetailsMap.put('Charge_Info__c',chargeInfo.id);
           SAP_Order_Detail__c  SAPOrder = BNP_DecisionDataFactory.createSapOrder(fieldValueSAPorderdetailsMap);
            
            
            //Decision__c  dsc1 = new Decision__c ();
            
            //dsc1 = [select id,name,Opportunity__c,Account__c,Technical_Requirement__c,Request_Information__c from Decision__c  limit 1  ];
            
            test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(dec);
            BnP_DecisionCtrl cdc = new BnP_DecisionCtrl(sc);
            
            PageReference pageRef = Page.BnP_DecisionView;
            pageRef.getParameters().put('reqInfoId', reqInfo.id);
            pageRef.getParameters().put('trId', cr.id);
            pageRef.getParameters().put('accId', account1.id);
            pageRef.getParameters().put('oppId', opp1.id); 
            pageRef.getParameters().put('deviceId', Dev1.id);
            pageRef.getParameters().put('decisionId', 'dsc1.id'); 
            Test.setCurrentPage(pageRef);
            
            cdc.doEdit();
            cdc.chargeInfoOnLoad();
        
            test.stopTest();
         }
    }
       
}