/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionHeaderComponentUtility>
   @CreateDate <28/03/2017>
   @Description <Apex Test Class For TechReview_ChargeOrderDetailUtility>
   @Version <>
   @reference <>
 */
@isTest
Public Class TechReview_ChargeOrderDetailUtilityTest
{
    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
    
    static testMethod void CreateChargeInfo()
    {
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
            fieldValueTechReviewMap.put('Device__c', Dev1.id);
            fieldValueTechReviewMap.put('Opportunity__c', opp1.id);
            fieldValueTechReviewMap.put('Request_Information__c', reqInfo.id);
            fieldValueTechReviewMap.put('Decision__c', dec.id);
            fieldValueTechReviewMap.put('Option__c', cr.Id);
            Tech_Review_Summary__c tr = BNP_DecisionDataFactory.createTechReview(fieldValueTechReviewMap);
            system.AssertEquals(reqInfo.id, tr.Request_Information__c);
            
            Charge_Info__c objChargeInfo = new Charge_Info__c();
            objChargeInfo.Charge_Number__c = '111';
            objChargeInfo.Option__c = cr.Id;
            Insert objChargeInfo;
            
            SAP_Order_Detail__c objSapdetails = new SAP_Order_Detail__c();
            objSapdetails.Charge_Info__c = objChargeInfo.Id;
            objSapdetails.SAP_Order_Number__c = '1111';
            Insert objSapdetails;
            
            Test.startTest();
            TechReview_ChargeOrderDetailUtility ctrl = new TechReview_ChargeOrderDetailUtility();
            ctrl.OptionId =tr.id;
            TechReview_ChargeOrderDetailUtility.WrapperCls  Oppwrapper = new TechReview_ChargeOrderDetailUtility.WrapperCls();
            ctrl.getDetailInformation();
            Test.stopTest();
        }
    }
}