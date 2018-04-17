/**
@Author <Cognizant Technology Solutions>
@name <BnP_OptionUtilityTest>
@CreateDate <14/10/2016>
@Description <Apex Test Class For BnP_OptionUtility>
@Version <>
@reference <>
*/
@isTest
public Class BnP_OptionUtilityTest 
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    Static TestMethod void GenericTr() 
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
        
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('Id', cr.id);
        Test.SetCurrentPage(pag);
        BnP_OptionUtility Generictr = new BnP_OptionUtility();
        List<Id> lstRecordId = new List<Id>();
        lstRecordId.add(cr.id);
        Generictr.updateOptionStages(lstRecordId, cr.Option_Stage__c);
        
        Test.stopTest();
    }
    Static TestMethod void GenericTrinvaliddata() 
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
            pagereference pag = page.BnP_OptionDeliverableType;
            pag.getParameters().put('Id', cr.id);
            Test.SetCurrentPage(pag);
            BnP_OptionUtility Generictr = new BnP_OptionUtility();
            List<Id> lstRecordId = new List<Id>();
            lstRecordId.add(cr.id);
            Generictr.updateOptionStages(lstRecordId, 'abcd');
        Test.stopTest();
    }
    Static TestMethod void CDSStatus() 
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
        
        Map<String,Object> fieldValueCustomDesignMap = new Map<String,Object>();
        fieldValueCustomDesignMap.put('Customer__c',account1.id);
        fieldValueCustomDesignMap.put('DIW_Opp_Control_Number__c',opp1.id);
        fieldValueCustomDesignMap.put('DIW_Option_Control_Number__c',cr.id);
        Custom_Design__c cd = CDS_DataFactory.createCDS(fieldValueCustomDesignMap);
        
        Test.startTest();
            pagereference pag = page.CDSViewPageFrame;
            pag.getParameters().put('Id',cd.id);
            Test.SetCurrentPage(pag);
            BnP_OptionUtility Generictr = new BnP_OptionUtility();
            List<Id> lstRecordId = new List<Id>();
            lstRecordId.add(cd.id);
            Generictr.updateCDSStatus(lstRecordId,cd.CDS_Status__c);
            Test.stopTest();
      }
      
       Static TestMethod void CDSStatusinvaliddata() 
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
        
        Map<String,Object> fieldValueCustomDesignMap = new Map<String,Object>();
        fieldValueCustomDesignMap.put('Customer__c',account1.id);
        fieldValueCustomDesignMap.put('DIW_Opp_Control_Number__c',opp1.id);
        fieldValueCustomDesignMap.put('DIW_Option_Control_Number__c',cr.id);
        Custom_Design__c cd = CDS_DataFactory.createCDS(fieldValueCustomDesignMap);
        
        Test.startTest();
            pagereference pag = page.CDSViewPageFrame;
            pag.getParameters().put('Id',cd.id);
            Test.SetCurrentPage(pag);
            BnP_OptionUtility Generictr = new BnP_OptionUtility();
            List<Id> lstRecordId = new List<Id>();
            lstRecordId.add(cd.id);
            Generictr.updateCDSStatus(lstRecordId,'abcd');
        Test.stopTest();
    }
    
}