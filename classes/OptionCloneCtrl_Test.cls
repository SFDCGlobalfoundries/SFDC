/**  
   @name <OptionCloneCtrl_Test>
   @CreateDate <05/10/2016>
   @Description <Apex Test Class For OptionCloneCtrl>
   @Version <>
   @reference <>
 */
@isTest
public Class OptionCloneCtrl_Test
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    Static TestMethod void OptionClone() 
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
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
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
                        
            Map<String,Object> fieldValueserviceMap = new Map<String,Object>();
            fieldValueserviceMap.put('Technical_Requirement__c',cr.id);
            Service__c   service = BNP_DataFactory.createService(fieldValueserviceMap); 
             
            Map<String,Object> fieldValuewaferMap = new Map<String,Object>();
            fieldValuewaferMap.put('Technical_Requirement__c',cr.Id);
            Wafer_Data__c WaferData  = BNP_DataFactory.createWaferData(fieldValuewaferMap);
        
            Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',cr.Id);
            fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
            
            Map<String,Object> fieldValueModuleMap = new Map<String,Object>();
            fieldValueModuleMap.put('Technical_Requirement__c',cr.Id);
            fieldValueModuleMap.put('Chip_1__c',ChipData.Id);
            Module_Data__c ModuleData  = BNP_DataFactory.createModuleData(fieldValueModuleMap);
            
            Map<String,Object> fieldValuePackageDataMap = new Map<String,Object>();
            fieldValuePackageDataMap.put('Technical_Requirement__c',cr.Id);
            fieldValuePackageDataMap.put('Module_Data__c',ModuleData.Id); 
            Package_Data__c  PackageData  = BNP_DataFactory.createPackageData(fieldValuePackageDataMap);
            
            Map<String,Object> fieldValueDesignMap = new Map<String,Object>();
            fieldValueDesignMap.put('Customer_Requirement__c',cr.Id);
            Design__c Designdata = BNP_DataFactory.createDesign(fieldValueDesignMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);   
            system.AssertEquals(cr.id, reqInfo.Customer_Requirement__c);  
                       
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c',reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.startTest();
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            OptionCloneCtrl ctrl = new OptionCloneCtrl(controller); 
            ctrl.serviceCheck =True;
            ctrl.waferCheck=True;
            ctrl.chipCheck=True;
            ctrl.moduleCheck=True;
            ctrl.packageCheck=True;
            ctrl.designCheck=True;                 
            ctrl.createClone();            
            Test.stopTest();
       }         
    }
    
    Static TestMethod void OptionCloneTestData()
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
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
            fieldValueOptionInfoMap.put('Device__c',Dev1.Id);
            fieldValueOptionInfoMap.put('RIT_Type__c','B');
            fieldValueOptionInfoMap.put('Deliverable_Type__c','Chip');
            fieldValueOptionInfoMap.put('Count__c',1);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            Map<String,Object> fieldValueserviceMap = new Map<String,Object>();
            fieldValueserviceMap.put('Technical_Requirement__c',cr.id);
            Service__c   service = BNP_DataFactory.createService(fieldValueserviceMap); 
             
            Map<String,Object> fieldValuewaferMap = new Map<String,Object>();
            fieldValuewaferMap.put('Technical_Requirement__c',cr.Id);
            Wafer_Data__c WaferData  = BNP_DataFactory.createWaferData(fieldValuewaferMap);
        
            Map<String,Object> fieldValueChipMap = new Map<String,Object>();
            fieldValueChipMap.put('Technical_Requirement__c',cr.Id);
            fieldValueChipMap.put('Wafer_Data__c',WaferData.Id);
            Chip_Data__c Chipdata  = BNP_DataFactory.createChipData(fieldValueChipMap);
            
            Map<String,Object> fieldValueModuleMap = new Map<String,Object>();
            fieldValueModuleMap.put('Technical_Requirement__c',cr.Id);
            fieldValueModuleMap.put('Chip_1__c',ChipData.Id);
            Module_Data__c ModuleData  = BNP_DataFactory.createModuleData(fieldValueModuleMap);
            
            Map<String,Object> fieldValuePackageDataMap = new Map<String,Object>();
            fieldValuePackageDataMap.put('Technical_Requirement__c',cr.Id);
            fieldValuePackageDataMap.put('Module_Data__c',ModuleData.Id); 
            Package_Data__c  PackageData  = BNP_DataFactory.createPackageData(fieldValuePackageDataMap);
            
            Map<String,Object> fieldValueDesignMap = new Map<String,Object>();
            fieldValueDesignMap.put('Customer_Requirement__c',cr.Id);
            Design__c Designdata = BNP_DataFactory.createDesign(fieldValueDesignMap);
            
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);    
            system.AssertEquals(cr.id, reqInfo.Customer_Requirement__c); 
                       
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c',reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
           
            Test.startTest();
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            OptionCloneCtrl ctrl = new OptionCloneCtrl(controller); 
            ctrl.serviceCheck =True;
            ctrl.waferCheck=True;
            ctrl.chipCheck=True;
            ctrl.moduleCheck=True;
            ctrl.packageCheck=True;
            ctrl.designCheck=True;                   
            ctrl.createClone();            
            Test.stopTest();
       }
    }
}