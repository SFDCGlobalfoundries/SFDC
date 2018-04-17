/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionHeaderComponentUtility>
   @CreateDate <13/10/2016>
   @Description <Apex Test Class For BnP_OptionHeaderComponentUtility>
   @Version <>
   @reference <>
 */
@isTest
Public Class BnP_OptionHeaderComponentUtilityTest{
    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
 Static TestMethod void OptionComponent() 
   {
        List < RecordType > rt = [SELECT Description, DeveloperName, Id, IsActive, Name, SobjectType FROM RecordType where SobjectType = 'Customer_Requirement__c'];
        RecordType recordType = [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser) {}
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
        
        Test.startTest();
        BnP_OptionHeaderComponentUtility ctrl = new BnP_OptionHeaderComponentUtility();
        ctrl.RecId=opp1.id;
        BnP_OptionHeaderComponentUtility.WrapperCls  Oppwrapper = new BnP_OptionHeaderComponentUtility.WrapperCls();
        ctrl.getDetails();
        Test.stopTest();
        
   } 
   Static TestMethod void OpportunityComponent1() 
   {
         List < RecordType > rt = [SELECT Description, DeveloperName, Id, IsActive, Name, SobjectType FROM RecordType where SobjectType = 'Customer_Requirement__c'];
        RecordType recordType = [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser) {}
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
       
        Test.startTest();
        BnP_OptionHeaderComponentUtility ctrl = new BnP_OptionHeaderComponentUtility();
        ctrl.RecId=cr.id;
        BnP_OptionHeaderComponentUtility.WrapperCls  Oppwrapper = new BnP_OptionHeaderComponentUtility.WrapperCls();
        ctrl.getDetails();
        Test.stopTest();
     
   } 
   Static TestMethod void OpportunityComponent2() 
   {
        List < RecordType > rt = [SELECT Description, DeveloperName, Id, IsActive, Name, SobjectType FROM RecordType where SobjectType = 'Customer_Requirement__c'];
        RecordType recordType = [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        System.RunAs(thisUser) {}
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
        
        Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
        fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
        fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
        fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
        fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
        Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);
       
        Test.startTest();
        BnP_OptionHeaderComponentUtility ctrl = new BnP_OptionHeaderComponentUtility();
        ctrl.RecId=reqInfo.id;
        BnP_OptionHeaderComponentUtility.WrapperCls  Oppwrapper = new BnP_OptionHeaderComponentUtility.WrapperCls();
        ctrl.getDetails();
        Test.stopTest();
        
   } 
 }