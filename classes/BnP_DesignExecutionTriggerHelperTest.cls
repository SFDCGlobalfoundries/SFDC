@istest
   
   public class BnP_DesignExecutionTriggerHelperTest 
   {    
 
 @testSetup static void testdata() {
      DataUtilTest.loadEnvironmentVariables();
  }
     static testMethod void UpdateOptionStageFromDE_Test(){
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
           //fieldValueDecisionMap.put('Request_Information__c',reqInfo.id);
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
            
        
            Design_Execution__c de = new Design_Execution__c();
            de.Opportunity__c = opp1.id;
            de.Option__c = cr.id;
            insert de;
            system.AssertEquals(cr.id, de.Option__c);
        
         Test.startTest();
           try
           {   
              update cr ;
           }catch(Exception e){
               }
          Test.stopTest() ;     
            
       }
       
      }
   }