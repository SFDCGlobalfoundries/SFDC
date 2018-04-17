/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionDeliverableTypeCtrlTest>
   @CreateDate <12/09/2016>
   @Description <Apex Test Class For ContractPricingCtrl>
   @Version <>
   @reference <>
 */
@isTest
Public Class BnP_OptionDeliverableTypeCtrlTest{
    @TestSetup static void testdata() 
    {
      DataUtilTest.loadEnvironmentVariables();
    }
 Static TestMethod void ContractPricingyes() 
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
        fieldValueOppMap.put('Design_Win_Region_Override__c', 'US-West');
        fieldValueOppMap.put('Design_Win_Territory_Override__c', 'US-East');
        //fieldValueOppMap.put('StageName', '2. Assessment');
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
        
        Opportunity opp2 = new Opportunity();
        opp2.StageName = '2. Assessment';
        opp2.Id = opp1.Id;
        update opp2;
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        fieldValueOptionInfoMap.put('Deliverable_Type__c','Wafer');
        Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
        
        system.debug('<==>Test Method: ' + opp1.StageName + ' : ' + opp2.StageName);
        
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
        
        Test.startTest(); 
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('DT','Wafer');
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
        PageReference objPageRef =  ctrl.DeliverableTypeMessage();
        PageReference objPageRef2 =  ctrl.doClick();                        
        ctrl.DeliverableTypedisable  = true;
        ctrl.displayTabPanel = true;
        ctrl.ShowExport = true;
        ///ctrl.ButtonText ='Save';
        ///ctrl.ButtonTextWafer ='Save';
        ctrl.LoadServiceData();
        ctrl.LoadWaferData();
        ctrl.LoadChipData();
        ctrl.LoadModuleData();
        ctrl.LoadPackageData();
        ctrl.LoadDesignData();
        ctrl.ButtonText ='Save';
        ctrl.SaveServicedata();    
        //ctrl.EdittheSection();
        ctrl.ButtonTextWafer ='Save';
        ctrl.SaveWaferdata();
        ctrl.EditWaferSection();
        ctrl.ButtonTextChip = 'Save';
        ctrl.SaveChipdata();
        ctrl.EditChipSection();
        ctrl.ButtonTextModule = 'Save';
        ctrl.SaveModuledata();
        ctrl.EditModuleSection();
        ctrl.ButtonTextPackage = 'Save';
        ctrl.SavePackagedata();
        ctrl.EditPackageSection();
        ctrl.ButtonTextDesign = 'Save';
        ctrl.SaveDesigndata();
        ctrl.EditDesignSection();
        ctrl.IsServiceEdit();
        ctrl.getserviceinfo(); 
        ctrl.currentOpportunityStage(); 
        ctrl.IsDesignEdit();
        ctrl.DeliverableTypeVisible(); 
        ctrl.ButtonText ='Save';
        ctrl.prapareValidationmsg();
        ////ctrl.getOptionValueforTFF();
       //calling the Design object FieldSet methods 
        ctrl.getAddCompilable();
        ctrl.getAddCores();
        ctrl.getAddImage();
        ctrl.getAddImagePackage();
        ctrl.getAddInterfaceCircuits();
        ctrl.getAddPackage();
        ctrl.getCircuitDetails();
        ctrl.getCreateUser();
        ctrl.getCreateUserDefined ();
        ctrl.getCreateUserDefinedcustomImg();
        ctrl.getDesignServicesDetails();
        ctrl.getDesignforTestDetails();
        ctrl.getEditFeatures();
        ctrl.getInterfaceCircuits();
        ctrl.getPowerSupply();
        ctrl.getImageDetails();
        ctrl.getActiveSideC4Details();
        ctrl.getActiveSideCapturePadDetails();
        ctrl.getFileCheckIn();
        ctrl.getMemorySummary();
        ctrl.getSRAMDetails();
        ctrl.getEmbeddedDRAMDetails();
        ctrl.getDesignMethodology();
        ctrl.getDesignDetails();
        ctrl.getGroundruleWaivers();
        ctrl.getSelecteDRAMs();
        //calling the Wafer object FieldSet methods 
        ctrl.getAdditionalactivesidewaferprocessing();
        ctrl.getActiveSideInterconnectDetails();
        ctrl.getActiveSideC4Detailswf();
        ctrl.getInterconnectDetails();
        ctrl.getAdditionalbacksidewaferprocessing();
        ctrl.getBackSideInterconnectDetails();
        ctrl.getWaferDetails();
        ctrl.getTestDetails();
        ctrl.getAdditionalwaferprocessing();
        ctrl.DeliverableTypeMessage();
        ctrl.doClick();
        //calling the chip object FieldSet methods 
        ctrl.getParametersPartNumberIdentification();
        ctrl.getPhysicalDimensions();
        ctrl.getChipInterconnect();
        ctrl.getGeneral();
        ctrl.getDocumentation();
        ctrl.getInformation();        
        //calling the Module object FieldSet methods 
        ctrl.getCapLid();
        ctrl.getDiscreteComponents();
        ctrl.getModuleDetails();
        ctrl.getMCM();   
        //calling the Package  object FieldSet methods 
        ctrl.getBottomSurfaceDetails();
        ctrl.getBuildupLayerDetails();
        ctrl.getCoreLayerDetails();
        ctrl.getGeneralPackage();
        ctrl.getGeneralPackageDetails();
        ctrl.getMLCLayerDetails();
        ctrl.getOtherInformation();
        ctrl.getPackageChipSiteDetails();
        ctrl.getPackagePNDetails();
        ctrl.getPackageServices();
        ctrl.getTopSurfaceDetails();                                
        ctrl.LoadDeliverableTypeOptions();
        ctrl.doClick(); 
        
        Test.stopTest(); 
       }  
      }
      Static TestMethod void DeliverabletypeChip() {

        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        fieldValueOptionInfoMap.put('Deliverable_Type__c','Chip');
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
          
        Test.startTest();
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('DT','Chip');
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
        ctrl.DeliverableTypedisable  = true;
        ctrl.displayTabPanel = true;
        // Calling the methods
        ctrl.ButtonText = 'Save';
        ctrl.LoadWaferData();
        ctrl.LoadChipData();
        ctrl.LoadDeliverableTypeOptions();
        ctrl.SaveWaferdata();
        ctrl.prapareValidationmsg();
        //End Hear 
        Test.stopTest();
      }   
     }
   Static TestMethod void DeliverabletypeChipModule() {

        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
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
        
        Test.startTest();
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('DT','Module');
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
        ctrl.DeliverableTypedisable  = true;
        ctrl.displayTabPanel = true;
        // Calling the methods
        ctrl.ButtonText = 'Save';
        ctrl.LoadWaferData();
        ctrl.LoadChipData();
        ctrl.LoadModuleData();
        ctrl.LoadPackageData();
        ctrl.LoadDeliverableTypeOptions();
            ////ctrl.getOptionValueforTFF();
            ctrl.DeliverableTypeMessage();
        //End Hear  
        Test.stopTest(); 
       }  
      }
  Static testMethod void DeliverableType() {

        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
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
        
        Test.startTest();
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('DT','');
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
       // Calling the methods
        ctrl.ButtonText = 'Save';
        ctrl.LoadServiceData();
        ctrl.LoadWaferData();
        ctrl.LoadChipData();
        ctrl.LoadModuleData();
        ctrl.LoadPackageData();
        ctrl.LoadDesignData();
        ctrl.SaveServicedata();
        //ctrl.ButtonText ='Save';
        ctrl.EdittheSection();
        ctrl.SaveWaferdata();
        ctrl.EditWaferSection();
        ctrl.SaveChipdata();
        ctrl.EditChipSection();
        ctrl.SaveModuledata();
        ctrl.EditModuleSection();
        ctrl.SavePackagedata();
        ctrl.EditPackageSection();
        ctrl.SaveDesigndata();
        ctrl.EditDesignSection();
        ctrl.prapareValidationmsg();
        //End Hear  
       //Calling the field set methods 
       //calling the service object FieldSet method
       ctrl.getserviceinfo(); 
       ctrl.currentOpportunityStage(); 
       ctrl.IsDesignEdit();
       ctrl.DeliverableTypeVisible();
       ////ctrl.getOptionValueforTFF();
            ctrl.doClick();
       //calling the Design object FieldSet methods 
       ctrl.getAddCompilable();
       ctrl.getAddCores();
       ctrl.getAddImage();
       ctrl.getAddImagePackage();
       ctrl.getAddInterfaceCircuits();
       ctrl.getAddPackage();
       ctrl.getCircuitDetails();
       ctrl.getCreateUser();
       ctrl.getCreateUserDefined ();
       ctrl.getCreateUserDefinedcustomImg();
       ctrl.getDesignServicesDetails();
       ctrl.getDesignforTestDetails();
       ctrl.getEditFeatures();
       ctrl.getInterfaceCircuits();
       ctrl.getPowerSupply();
       ctrl.getImageDetails();
       ctrl.getActiveSideC4Details();
       ctrl.getActiveSideCapturePadDetails();
       ctrl.getFileCheckIn();
       ctrl.getMemorySummary();
       ctrl.getSRAMDetails();
       ctrl.getEmbeddedDRAMDetails();
       ctrl.getDesignMethodology();
       ctrl.getDesignDetails();
       ctrl.getGroundruleWaivers();
       ctrl.getSelecteDRAMs();
       ctrl.DeliverableTypeMessage();     
        //calling the Wafer object FieldSet methods 
        ctrl.getAdditionalactivesidewaferprocessing();
        ctrl.getActiveSideInterconnectDetails();
        ctrl.getActiveSideC4Detailswf();
        ctrl.getInterconnectDetails();
        ctrl.getAdditionalbacksidewaferprocessing();
        ctrl.getBackSideInterconnectDetails();
        ctrl.getWaferDetails();
        ctrl.getTestDetails();
        ctrl.getAdditionalwaferprocessing();
        //calling the chip object FieldSet methods 
        ctrl.getParametersPartNumberIdentification();
        ctrl.getPhysicalDimensions();
        ctrl.getChipInterconnect();
        ctrl.getGeneral();
        ctrl.getDocumentation();
        ctrl.getInformation();        
        //calling the Module object FieldSet methods 
        ctrl.getCapLid();
        ctrl.getDiscreteComponents();
        ctrl.getModuleDetails();
        ctrl.getMCM();   
        //calling the Package  object FieldSet methods 
        ctrl.getBottomSurfaceDetails();
        ctrl.getBuildupLayerDetails();
        ctrl.getCoreLayerDetails();
        ctrl.getGeneralPackage();
        ctrl.getGeneralPackageDetails();
        ctrl.getMLCLayerDetails();
        ctrl.getOtherInformation();
        ctrl.getPackageChipSiteDetails();
        ctrl.getPackagePNDetails();
        ctrl.getPackageServices();
        ctrl.getTopSurfaceDetails();
        ctrl.LoadDeliverableTypeOptions();
        Test.stopTest();  
       } 
     }
   Static TestMethod void Cancel() 
   {
        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
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
        
        Test.startTest(); 
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
        ctrl.canceldata();
        ctrl.LoadServiceData();
        ctrl.cancelWaferdata();
        ctrl.LoadWaferData();
        ctrl.CancelChipdata();
        ctrl.LoadChipData();
        ctrl.CancelModuledata();
        ctrl.LoadModuleData();
        ctrl.CancelPackagedata();
        ctrl.LoadPackageData();
        ctrl.CancelDesigndata();
        ctrl.LoadDesignData();
        ctrl.getChipOptionInfo('MCM');
        ////ctrl.getOptionValueforTFF();
        ctrl.DeliverableTypeMessage();
            ctrl.doClick();
        Test.stopTest(); 
       
       }
   }
   
   Static TestMethod void CheckforTryForFit() 
   {

        List<RecordType> rt  = [SELECT Description,DeveloperName,Id,IsActive,Name,SobjectType FROM RecordType where SobjectType ='Customer_Requirement__c']; 
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
        Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
        fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
        fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
        fieldValueOptionInfoMap.put('RecordTypeId',rt.get(1).Id);
        fieldValueOptionInfoMap.put('Customer_part_name__c','');
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
        
        Test.startTest();
        pagereference pag = page.BnP_OptionDeliverableType;
        pag.getParameters().put('DT','Module');
        pag.getParameters().put('Id',cr.id);
        Test.SetCurrentPage(pag);
        ApexPages.StandardController controller = new ApexPages.StandardController(cr);
        BnP_OptionDeliverableTypeCtrl ctrl = new BnP_OptionDeliverableTypeCtrl(controller);
        ctrl.DeliverableTypedisable  = true;
        ctrl.displayTabPanel = true;
        // Calling the methods
        ctrl.ButtonText = 'Save';
        ctrl.LoadWaferData();
        ctrl.LoadChipData();
        ctrl.LoadModuleData();
        ctrl.LoadPackageData();
        ctrl.LoadDeliverableTypeOptions();
        ////ctrl.getOptionValueforTFF();
            ctrl.doClick();
        ////ctrl.getOptionValueforTFF();
        //End Hear  
        Test.stopTest(); 
       }  
      }
}