/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_SelectAndCreateDeliveryPartNumberTest>
   @CreateDate <30/10/2016>
   @Description <This is a Test Class for Controller BnP_SelectAndCreateDeliveryPartNumber>
   @Version <>
   @reference <>
 */
@isTest
public Class BnPSelectAndCreateDeliveryPartNumberTest
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    Static TestMethod void CreateNewDPN()
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
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
            fieldValueMap1.put('Account__c', account1.id);
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('RecordTypeId',rt.get(0).Id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueDPNumerMap = new Map<String,Object>();
            Delivery_Part_Number__c objDPN = BNP_DataFactory.createDPNumber(fieldValueDPNumerMap);
            
            Test.startTest(); 
            pagereference pag = page.BnP_SelectDeliveryPartNumber;
            pag.getParameters().put('TRID',cr.Id);
            pag.getParameters().put('oppId',opp1.id);
            Test.SetCurrentPage(pag);
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BnP_SelectAndCreateDeliveryPartNumber ctrl = new BnP_SelectAndCreateDeliveryPartNumber(controller);
            
            ctrl.SelectValue = 'DPN';
            ctrl.IsDPNType = true;
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN wrapmethod = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN();
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN psec = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN(objDPN, cr.Name);
            // Calling the methods        
            ctrl.CreateandAddDPNtoOption();
            ctrl.getAllDPN();
            ctrl.SelectDPNType();
            ctrl.AddDPNtoOption();        
            ctrl.refreshPageSize();
            ctrl.getSelected();
        }
    }
    
    Static TestMethod void CreateNewDAPN()
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {      
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
            
            /*Map<String,Object> fieldValuepoppProgramMap1 = new Map<String,Object>();
            fieldValuepoppProgramMap1.put('Account__c',account1.id);
            fieldValuepoppProgramMap1.put('Opportunity__c',opp1.id);
            Opportunity_Program__c oppprogram = new Opportunity_Program__c();    
            oppprogram = OpportunityProgramDataFactory.createOpportunityProgram(fieldValuepoppProgramMap1);
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Account__c', account1.id);
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);*/
            
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
            //fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueDPNumerMap = new Map<String,Object>();
            Delivery_Part_Number__c objDPN = BNP_DataFactory.createDPNumber(fieldValueDPNumerMap);
            
            Test.startTest(); 
            pagereference pag = page.BnP_SelectDeliveryPartNumber;
            pag.getParameters().put('TRID',cr.Id);
            pag.getParameters().put('oppId',opp1.id);
            Test.SetCurrentPage(pag);
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BnP_SelectAndCreateDeliveryPartNumber ctrl = new BnP_SelectAndCreateDeliveryPartNumber(controller);
            
            ctrl.SelectValue = 'DAPN';
            ctrl.IsDPNType = true;
            
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN wrapmethod = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN();
            wrapmethod.selected = true;
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN psec = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN(objDPN, cr.Name);
            psec.selected = true;
            // Calling the methods
            ctrl.CreateandAddDPNtoOption();
            ctrl.getAllDPN();
            ctrl.SelectDPNType();
            ctrl.AddDPNtoOption(); 
            ctrl.refreshPageSize(); 
        }
    }
    
    Static TestMethod void CreateNewDAPNInvalidData()
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
        
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
                        
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueDPNumerMap = new Map<String,Object>();
            Delivery_Part_Number__c objDPN = BNP_DataFactory.createDPNumber(fieldValueDPNumerMap);
           
            Test.startTest(); 
            pagereference pag = page.BnP_SelectDeliveryPartNumber;
            //pag.getParameters().put('TRID',cr.Id);
            pag.getParameters().put('oppId',opp1.id);
            Test.SetCurrentPage(pag);
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BnP_SelectAndCreateDeliveryPartNumber ctrl = new BnP_SelectAndCreateDeliveryPartNumber(controller);
                                    
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN wrapmethod = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN();
            wrapmethod.selected = true;
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN psec = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN(objDPN, cr.Name);
            // Calling the methods
            ctrl.CreateandAddDPNtoOption();
            ctrl.getAllDPN();
            ctrl.SelectDPNType();
            ctrl.AddDPNtoOption(); 
            ctrl.refreshPageSize();
        }
    }
    
    Static TestMethod void CreateNewDAPNInvalidDataInfo()
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
        
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();
            Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
            
            Map<String,Object> fieldValueOppMap = new Map<String,Object>();
            fieldValueOppMap.put('AccountId', account1.id);
            Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
                                
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueDPNumerMap = new Map<String,Object>();
            Delivery_Part_Number__c objDPN = BNP_DataFactory.createDPNumber(fieldValueDPNumerMap);
            
            Test.startTest(); 
            pagereference pag = page.BnP_SelectDeliveryPartNumber;
            //pag.getParameters().put('TRID',cr.Id);
            pag.getParameters().put('oppId',opp1.id);
            Test.SetCurrentPage(pag);
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BnP_SelectAndCreateDeliveryPartNumber ctrl = new BnP_SelectAndCreateDeliveryPartNumber(controller);
            ctrl.SelectValue = 'DPN';
                                    
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN wrapmethod = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN();
            wrapmethod.selected = true;
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN psec = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN(objDPN, cr.Name);
            psec.selected = true;
            // Calling the methods
            ctrl.getAllDPN();
            ctrl.AddDPNtoOption(); 
        }      
    }

    Static TestMethod void CreateNewDPNSeries()
    {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
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
            fieldValueMap1.put('Account__c', account1.id);
            fieldValueMap1.put('Device_Sourcing__c','Sole Source');
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('RecordTypeId',rt.get(0).Id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueDPNumerMap = new Map<String,Object>();
            Delivery_Part_Number__c objDPN = BNP_DataFactory.createDPNumber(fieldValueDPNumerMap);
            
            Delivery_Part_Number__c objDPNnew = new Delivery_Part_Number__c();
            objDPNnew.Name = '0000001LN999';
            objDPNnew.Count__c= 999;
            objDPNnew.DPN_Type__c = 'DPN';
            Insert objDPNnew;
            
            Test.startTest(); 
            pagereference pag = page.BnP_SelectDeliveryPartNumber;
            pag.getParameters().put('TRID',cr.Id);
            pag.getParameters().put('oppId',opp1.id);
            Test.SetCurrentPage(pag);
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BnP_SelectAndCreateDeliveryPartNumber ctrl = new BnP_SelectAndCreateDeliveryPartNumber(controller);
            
            ctrl.SelectValue = 'DPN';
            ctrl.IsDPNType = true;
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN wrapmethod = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN();
            BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN psec = new BnP_SelectAndCreateDeliveryPartNumber.WrapperAllDPN(objDPN, cr.Name);
            // Calling the methods        
            ctrl.CreateandAddDPNtoOption();
            ctrl.getAllDPN();
            ctrl.SelectDPNType();
            ctrl.AddDPNtoOption();        
            ctrl.refreshPageSize();
            ctrl.getSelected();
        }
    }
}