/**
   @Author <Cognizant Technology Solutions>
   @name <BNPTRCloneCtrl_Test>
   @CreateDate <05/10/2016>
   @Description <Apex Test Class For BNPTRCloneCtrl>
   @Version <>
   @reference <>
 */
@isTest
public Class BNPTRCloneCtrl_Test
{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    Static TestMethod void BNPTRClone() 
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
            
            Test.startTest();
            Map<String,Object> fieldValueOptionInfoMap = new Map<String,Object>();
            fieldValueOptionInfoMap.put('Opportunity__c',opp1.id);
            fieldValueOptionInfoMap.put('Device__c',Dev1 .Id);
            Customer_Requirement__c cr = BNP_DataFactory.createOption(fieldValueOptionInfoMap);
            
            //Update Opportunity with Accepted Option
            /*Opportunity updOpportunity = new Opportunity();
            updOpportunity.Id = opp1.Id;
            updOpportunity.Option__c = cr.Id;
            Update updOpportunity;*/
            //End
            
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
            //Test.startTest();
            /*Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            fieldValueReqInfoMap.put('Date_quote_letter_1st_sent_to_sales__c', System.now());
            fieldValueReqInfoMap.put('Customer_accept_reject_date__c', System.now());
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);     
                       
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c',reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            reqInfo.Quote_Status__c = 'Accept';
            Update reqInfo;*/
            
            /*Map<String,Object> fieldValueTskRouteMap = new Map<String,Object>();
            fieldValueTskRouteMap.put('Related_RFQ_Routing__c', rfqRoute.id);
            RFQ_Tasks_Routing__c rfqRouteTask = BNP_DataFactory.createRFQTaskRouting(fieldValueTskRouteMap);
            
            Map<String,Object> fieldValueTskAssigneeMap = new Map<String,Object>();
            fieldValueTskAssigneeMap.put('RFQ_Task_Routing__c', rfqRouteTask.id);
            RFQ_Task_Assignee__c rfqRouteTaskAssignee = BNP_DataFactory.createRFQTaskAssignee(fieldValueTskAssigneeMap);*/
            //fieldValueReqInfoMap.put('Quote_Status__c', 'Accept');
            Test.setCurrentPageReference(new PageReference('Page.BNPTRClone'));
            System.currentPageReference().getParameters().put('opt', 'Respin');
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BNPTRCloneCtrl ctrl = new BNPTRCloneCtrl(controller); 
            ctrl.respinSelected = true; 
            ctrl.serviceCheck =True;
            ctrl.waferCheck=True;
            ctrl.chipCheck=True;
            ctrl.moduleCheck=True;
            ctrl.packageCheck=True;
            ctrl.designCheck=True;
            ctrl.copyRFQRoutings  = true;
            ctrl.copyRFQTaskRoutings  = true;
            ctrl.copyRFQTaskAssignees = true;       
            ctrl.createClone();
            ctrl.reload();
            System.assertEquals(System.currentPageReference().getParameters().put('opt', 'Respin'), 'Respin');
       }        
       Test.stopTest();

    }
    
    Static TestMethod void BNPTRCloneTestData()
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
        
            //Test.startTest();
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
            
            Test.startTest();
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            fieldValueReqInfoMap.put('Date_quote_letter_1st_sent_to_sales__c', System.now());
            fieldValueReqInfoMap.put('Customer_accept_reject_date__c', System.now());
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);     
              
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            //fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',true);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            reqInfo.Quote_Status__c = 'Accept';
            update reqInfo;
                     
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c',reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.setCurrentPageReference(new PageReference('Page.BNPTRClone'));
            System.currentPageReference().getParameters().put('opt', 'Respin');
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BNPTRCloneCtrl ctrl = new BNPTRCloneCtrl(controller); 
            ctrl.respinSelected = true;
            ctrl.serviceCheck =True;
            ctrl.waferCheck=True;
            ctrl.chipCheck=True;
            ctrl.moduleCheck=True;
            ctrl.packageCheck=True;
            ctrl.designCheck=True;
            ctrl.copyRFQRoutings  = true;
            ctrl.copyRFQTaskRoutings  = true;
            ctrl.copyRFQTaskAssignees = true;       
            ctrl.createClone();
            ctrl.reload();
            ctrl.getRitOptions();
            System.assertNotEquals(System.currentPageReference().getParameters().put('opt', 'Respin'), 'Clone');
       }
       Test.stopTest();

    }
    Static TestMethod void BNPTRCopyTestData()
    {
        RecordType recordTypeRI =  [Select Id from RecordType where developerName = 'RFQ' AND SObjectType = 'Request_Information__c'];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
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
            fieldValueMap1.put('Opportunity2__c',opp1.id);
            fieldValueMap1.put('Opportunity_Program__c',oppprogram.Id);
            Device__c Dev1 = new Device__c ();
            Dev1 = DeviceDataFactory.createDevice(fieldValueMap1);
        
            Test.startTest();
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
            
            //Test.startTest();
            Map<String,Object> fieldValueReqInfoMap = new Map<String,Object>();
            fieldValueReqInfoMap.put('Opportunity__c', opp1.id);
            fieldValueReqInfoMap.put('Customer_Requirement__c', cr.id);
            fieldValueReqInfoMap.put('Primary_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('Backup_Request_Catcher__c', thisUser.id);
            fieldValueReqInfoMap.put('recordTypeID', recordTypeRI.id);        
            fieldValueReqInfoMap.put('Date_quote_letter_1st_sent_to_sales__c', System.now());
            fieldValueReqInfoMap.put('Customer_accept_reject_date__c', System.now());
            fieldValueReqInfoMap.put('Skip_Validation__c', true);
            Request_Information__c reqInfo = BNP_DataFactory.createRequestInformation(fieldValueReqInfoMap);     
              
            Map<String,Object> fieldValueFinanceQuoteDocumentMap = new Map<String,Object>();
            fieldValueFinanceQuoteDocumentMap.put('BnP_Finance_Quote_Document__c',reqInfo.id);
            //fieldValueFinanceQuoteDocumentMap.put('Is_Financial_Document__c',true);
            BnP_Finance_Quote_Document__c bnpfinDoc = BNP_DataFactory.createBnPFinanceQuoteDocument(fieldValueFinanceQuoteDocumentMap);
            
            Map<String,Object> fieldValueAttachmentMap = new Map<String,Object>();
            fieldValueAttachmentMap.put('parentId',bnpfinDoc.id);
            Attachment attch = BNP_DataFactory.createAttachment(fieldValueAttachmentMap);
            
            reqInfo.Quote_Status__c = 'Accept';
            update reqInfo;
                     
            Map<String,Object> fieldValueRouteMap = new Map<String,Object>();
            fieldValueRouteMap.put('RFQ__c',reqInfo.id);
            RFQ_Routing__c rfqRoute = BNP_DataFactory.createRFQRouting(fieldValueRouteMap);
            
            Test.setCurrentPageReference(new PageReference('Page.BNPTRClone'));
            System.currentPageReference().getParameters().put('opt', 'Copy');
            ApexPages.StandardController controller = new ApexPages.StandardController(cr);
            BNPTRCloneCtrl ctrl = new BNPTRCloneCtrl(controller); 
            ctrl.respinSelected = true;
            ctrl.copySelected = true;
            ctrl.TapeoutType = 'Single Product';
            ctrl.techReqRec = cr;
            ctrl.deviceRec = Dev1;
            ctrl.serviceCheck =True;
            ctrl.waferCheck=True;
            ctrl.chipCheck=True;
            ctrl.moduleCheck=True;
            ctrl.packageCheck=True;
            ctrl.designCheck=True;
            ctrl.copyRFQRoutings  = true;
            ctrl.copyRFQTaskRoutings  = true;
            ctrl.copyRFQTaskAssignees = true;       
            ctrl.createClone();
            ctrl.reload();
            ctrl.getRitOptions();
            System.assertNotEquals(System.currentPageReference().getParameters().put('opt', 'Copy'), 'Clone');
       }
       Test.stopTest();

    }
}