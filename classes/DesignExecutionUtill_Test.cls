/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This TestDesignExecutionUtill class will be used to Design Execution Track data in different Test classes
**/
@isTest
public class DesignExecutionUtill_Test{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
      
    public static String accountId = createSingleAccount().Id;
    public static String opportunityId = createSingleOpportunity(accountId).Id;
    public static String optionId = CreateSingleOption().Id;
    public static String cdsId = createSingleCDS().Id;
    
    public static User createUser(){
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = uniqueName.substring(18, 23), Email= uniqueName + '@test' + orgId + '.org', 
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', 
                      UserName=uniqueName + '@test' + orgId + '.org');
        insert u;
        return u;
    }
    
    public static Account createSingleAccount() {
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Map<String,Object> mapOfAccount = new Map<String,Object>();
        Account acc = AccountDataFactory.createAccount(mapOfAccount);
        return acc;
    }
 
    public static Opportunity createSingleOpportunity(Id testAcctId) {
        AcctRegHeadMappingTgrHandler.bypassOppTrigger = true;
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        TriggerHandler.clearAllBypasses();
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', accountId);
        fieldValueOppMap.put('Process_Geometry__c','0.028UM');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        return opp1;
    }   
    
    public static Customer_Requirement__c CreateSingleOption()
    {   
        List < RecordType > rt = [SELECT Description, DeveloperName, Id, IsActive, Name, SobjectType 
                                  FROM RecordType where SobjectType = 'Customer_Requirement__c'];
        RecordType recordType = [Select Id from RecordType where Name = 'Customer' 
                                  AND SObjectType = 'Account'];
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        
        fieldValueOptionInfoMap.put('Opportunity__c',opportunityId);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        fieldValueOptionInfoMap.put('Deliverable_Type__c','Wafer');
        fieldValueOptionInfoMap.put('Deliverable_Part_Number_DPN__c','0000001LN190' );
        fieldValueOptionInfoMap.put('Design_execution_required__c','Yes');
        fieldValueOptionInfoMap.put('Design_ECCN__c','3E002.<');
        fieldValueOptionInfoMap.put('ITAR__c','No');
        fieldValueOptionInfoMap.put('RIT_Type__c','A/B');
        fieldValueOptionInfoMap.put('Option_Stage__c', 'Prototype Fulfillment');
        Customer_Requirement__c option = BNP_DataFactory.createOption(fieldValueOptionInfoMap);                
        return option;
    } 
    
    public static Custom_Design__c createSingleCDS(){
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',optionId);
        return CDS_DataFactory.createCDS(fieldValueCDSMap);
    }
        
    public static Design_Execution__c createsingleDERecord(){
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId);
        fieldValueDEMap.put('Option__c', optionId);
        fieldValueDEMap.put('Opportunity__c', opportunityId);
        return  DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
    }
   
    public static Sign_off_Module__c createsingleSignOFFRecord(){
        Map<String,Object> fieldSignOffMap = new Map<String,Object>();
        String did = createsingleDERecord().Id;
        fieldSignOffMap.put('Design_Execution__c', did);
        fieldSignOffMap.put('SignOffExternalId__c', did +':RTP');
        fieldSignOffMap.put('Application_Engineer__c', true);
        fieldSignOffMap.put('Field_Design_Center_Engineer__c', true);
        fieldSignOffMap.put('Physical_Design_Engineer__c', true);
        fieldSignOffMap.put('Product_Engineer__c', true);
        fieldSignOffMap.put('DCE_RTL_Checkpoin__c', true);
        fieldSignOffMap.put('DCE_Review_Approved__c', true);
        return  DesignExecutionSignOff_DataFactory.createDesignExectionSignOffModule(fieldSignOffMap);
    }
    
    public static Waivers__c createsingleWaiverRecord(){
        String did = createsingleDERecord().Id;
        Map<String,Object> fieldWaiverMap = new Map<String,Object>();
        fieldWaiverMap.put('Design_Execution__c', did);
        fieldWaiverMap.put('WaiversExternalId__c', did +':RTP');
 
        return  DesignExecutionWaiver_DataFactory.createDesignExectionWaiver(fieldWaiverMap);
    }
    
    public static Waiver_SMEs__c createsingleWaiverSMERecord(){
        Map<String,Object> fieldWaiverSMEMap = new Map<String,Object>();
        String uid = createUser().Id;
        fieldWaiverSMEMap.put('SME1__c', uid);
        fieldWaiverSMEMap.put('SME2__c', uid);
        fieldWaiverSMEMap.put('SME3__c', uid);
        fieldWaiverSMEMap.put('SME4__c', uid);
        fieldWaiverSMEMap.put('SME5__c', uid);
        fieldWaiverSMEMap.put('SME6__c', uid);
        fieldWaiverSMEMap.put('SME7__c', uid);
        fieldWaiverSMEMap.put('SME8__c', uid);
        fieldWaiverSMEMap.put('SME9__c', uid);
        fieldWaiverSMEMap.put('SME10__c', uid);
        return  DesignExecutionWaiverSME_DataFactory.createDesignExectionWaiver(fieldWaiverSMEMap);
    }
    
    public static Design_Deliverable_Questions__c createDesignDeliverableQuestions(){
        Map<String,Object> fieldddQMap = new Map<String,Object>();
        fieldddQMap.put('Milestone__c', 'RTA');
        return DesignExecutionDeliverable_DataFactory.createDesignExectionDDQ(fieldddQMap);
    }
}