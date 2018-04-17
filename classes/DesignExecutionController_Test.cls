@isTest(seeAllData =false)
Private class DesignExecutionController_Test{
    @TestSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    Public static void CreateDeviceRecords(){
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
    }
    }
    
    Private static testMethod void myUnitTest1() 
    {
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
          
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            //CreateDeviceRecords();
            Test.StartTest();    
            Customer_Requirement__c opt = DesignExecutionUtill_Test.CreateSingleOption();
            Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
            Custom_Design__c cd = DesignExecutionUtill_Test.createSingleCDS(); 
            
            Custom_Design__c cds = new Custom_Design__c();
            cds.id = cd.id;
            cds.DIW_Option_Control_Number__c = DesignExecutionUtill_Test.optionId ;
            update cds;
             
            Design_Execution__c dex = new Design_Execution__c();
            dex.Customer_Design_Specification__c = cds.Id ;
            dex.Option__c = cds.DIW_Option_Control_Number__c; 
            insert dex;
            PageReference pageRef = Page.DesignExecutionRead;
            pageRef.getParameters().put('cdsid', String.valueOf(dex.Customer_Design_Specification__c ));
            Test.setCurrentPage(pageRef);
            DesignExecutionController dc = new DesignExecutionController();
            system.assert(dc !=null);
            dc.createDesignExecutionRecord();
            dc.goToDesignExecution();
            dc.getSignOffMilestoneDetails();
            dc.cancelExecutionDetail();
            dc.editExecutionDetail();
            dc.viewSignOffRT();
            String nextPage = dc.viewSignOffRT().getUrl();
            System.assert(nextPage !=null);
            dc.RequoteExecutionDetail();
            dc.redirectToWaiverCapability();
            dc.exportMilestones();
            
            Test.StopTest();
            
        }
    }
        
    Private static testMethod void myUnitTest2() 
    {
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            //CreateDeviceRecords();
            Custom_Design__c cd = DesignExecutionUtill_Test.createSingleCDS();         
            Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
            
            Test.StartTest();
            
            PageReference pageRef = Page.DesignExecutionRead;
            pageRef.getParameters().put('cdsid', String.valueOf(cd.id));
            Test.setCurrentPage(pageRef);
            DesignExecutionController dc = new DesignExecutionController(); 
            system.assert(dc !=null);
            dc.createDesignExecutionRecord();
            dc.goToDesignExecution();
            system.assert(dc.cdsid !=null);
            Test.StopTest(); 
        }
    }
    
    Private static testMethod void myUnitTest3() 
    {   
        //CreateDeviceRecords();
        User u;
        Custom_Design__c cd = DesignExecutionUtill_Test.createSingleCDS(); 
        Test.StartTest();  
        DesignExecutionPermission__c dep = new DesignExecutionPermission__c();
        dep.Create_DE__c = true;
        dep.Edit_DE__c = true;
        dep.Name = 'DIW Sales Ops';        
        insert dep; 
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        //System.runAs ( thisUser ) 
        //{      
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            //u = DesignExecutionUtill_Test.createUser();
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: 'DIW_Sales_Ops'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            //psa.AssigneeId = u.id;
            psa.AssigneeId = thisUser.id;
            psa.PermissionSetId = ps.Id ;
            insert psa;
        }
        //}
        
        PageReference pageRef = Page.DesignExecutionRead;
        pageRef.getParameters().put('cdsid', String.valueOf(cd.id));
        Test.setCurrentPage(pageRef);
        DesignExecutionController dc = new DesignExecutionController();
        system.assert(dc !=null);
        Test.StopTest(); 
       
    }
    
    Private static testMethod void myUnitTest4() {
        //CreateDeviceRecords();
        User u;
        Custom_Design__c cd = DesignExecutionUtill_Test.createSingleCDS(); 
        DesignExecutionPermission__c dep = new DesignExecutionPermission__c();
        dep.Create_DE__c = true;
        dep.Edit_DE__c = true;
        dep.Export_DE__c = true;
        dep.Promote_SignOff__c = true;
        dep.Promote_Waiver__c = true;
        dep.Name = 'DIW Design Execution Admin';        
        insert dep; 
        
        DesignExecutionStaticValue__c deStatic = new DesignExecutionStaticValue__c();
        deStatic.Name = 'DeviceGeometry';
        deStatic.Value__c ='23.123';
        insert deStatic;
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        Test.startTest();
        //System.runAs ( thisUser ) {
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser)
        {
            //u = DesignExecutionUtill_Test.createUser();
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: 'DIW_Design_Execution_Admin'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            //psa.AssigneeId = u.id;
            psa.AssigneeId = thisUser.id;
            psa.PermissionSetId = ps.Id ;
            insert psa;
        
        
            //system.runAs(u){        
            PageReference pageRef = Page.DesignExecutionRead;
            pageRef.getParameters().put('cdsid', String.valueOf(cd.id));
            Test.setCurrentPage(pageRef);
            DesignExecutionController dc = new DesignExecutionController();
            system.assert(dc !=null);
            system.assert(deStatic !=null);
            dc.avoidCallInConst = false;
            dc.enableDisableRITDTButton();
        } 
        Test.stopTest();
    }
    
    Private static testMethod void myUnitTest5() {
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord();
        DesignExecutionStaticValue__c deStatic = new DesignExecutionStaticValue__c();
        deStatic.Name = 'DeviceGeometry';
        deStatic.Value__c ='23.123';
        insert deStatic;
        Test.StartTest();       
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        ApexPAges.StandardController sc = new ApexPages.StandardController(de);           
        DesignExecutionController dc = new DesignExecutionController(sc);
        system.assert(dc !=null);
        system.assert(deStatic !=null);
        dc.getItems();
        dc.nextbtn();
        dc.prvbtn();
        dc.fstbtn();
        dc.endbtn();
        dc.getprv();
        Test.StopTest(); 
        
    }
    
    Private static testMethod void TestsaveExecutionDetailsMethod() {
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        Test.StartTest();   
        Design_Execution__c dex = new Design_Execution__c();
        dex.id = de.id;
        update dex;
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc);
        
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        PageReference pageRef = Page.DesignExecutionRead;
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        Test.setCurrentPage(pageRef);
        
        //Test.setCurrentPageReference(new PageReference('Page.DesignExecutionRead'));
        //System.currentPageReference().getParameters().put('deid', dex.id);

        DesignExecutionController dc = new DesignExecutionController();
        system.assert(dc !=null);
        dc1.saveExecutionDetail();
        dc.returnGeometryFromOpp('2.340');
        system.assert(dc.returnGeometryFromOpp('2.340') !=null);
        Test.StopTest();
    }
    
    Private static testMethod void TestredirectToDecision() {
    
       // CreateDeviceRecords();
        Test.StartTest();      
        Customer_Requirement__c opt1 = DesignExecutionUtill_Test.CreateSingleOption();
        Customer_Requirement__c opt2 = new Customer_Requirement__c();
        opt2.id = opt1.id; 
        opt2.Option_Stage__c = 'Prototype Fulfillment';
        update opt2;
         
        Custom_Design__c cd = DesignExecutionUtill_Test.createSingleCDS();        
        Custom_Design__c cds = new Custom_Design__c();
        cds.id = cd.id;
        cds.DIW_Option_Control_Number__c = opt2.id ;
        update cds;
        
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        Design_Execution__c dex = new Design_Execution__c();
        dex.Customer_Design_Specification__c = cds.Id ;
        dex.Option__c = cds.DIW_Option_Control_Number__c; 
        insert dex;
                   
        PageReference pageRef = Page.DesignExecutionRead;
        pageRef.getParameters().put('cdsid', String.valueOf(dex.Customer_Design_Specification__c ));
        Test.setCurrentPage(pageRef);
        DesignExecutionController dc = new DesignExecutionController();
        system.assert(dc !=null);
        dc.createDesignExecutionRecord();
        dc.goToDesignExecution();
        system.assert(dc.cdsid !=null);
        Test.StopTest();
    }
    
    Private static testMethod void TestgoToTechReviewMethod() {
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
       // CreateDeviceRecords();
        DesignExecutionController deex = new DesignExecutionController(); 
        system.assert(deex !=null);
        Test.startTest();   
        Customer_Requirement__c opt1 = DesignExecutionUtill_Test.CreateSingleOption();
        Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        Design_Execution__c dex = new Design_Execution__c();
        deex.designExecution = de;

        Decision__c dsc = new Decision__c();
        dsc.Technical_Requirement__c = de.Option__c;
        insert dsc;
        
        Charge_Info__c crg  = new Charge_Info__c();
        crg.Charge_Number__c = '123';
        crg.Option__c = de.Option__c;
        crg.Charge_Type__c = 'Marketing Area Number';
        insert crg;
        
        PageReference pageRef = Page.DesignExecutionRead;
        pageRef.getParameters().put('optionid', String.valueOf(dsc.Technical_Requirement__c));
        pageRef.getParameters().put('deid', de.id);
        Test.setCurrentPage(pageRef);
        DesignExecutionController dexc = new DesignExecutionController();
        deex.goToTechReview(); 
        deex.populateRelatedLists();
        deex.populateRelatedLists();
        deex.getnxt();
        deex.recordTypeName = 'test';
        deex.oppProgId = 'test';
        system.assert(deex !=null);
        system.assert(crg !=null);
        Test.StopTest();
    } 
    }
    
    Private static testMethod void unitTest8() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    }
    Private static testMethod void unitTest8ASICPPTRF() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_IDR__c = system.today();
        de.PTRF_RIT_A_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    }
     Private static testMethod void unitTest9() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();       
        update de;
    
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
    Private static testMethod void unitTest9RTCB() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
       
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();       
        update de;
    
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest9RTCAB() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
       
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();       
        update de;
    
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest9Outlook() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Outlook_Date__c = system.today();       
        update de;
      
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
    Private static testMethod void unitTest9RITOff() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Outlook_Date__c = system.today();  
        de.Rit_A_Off_set__c = '1';  
        de.Rit_B_Off_set__c = '1';  
        update de;
      
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
    Private static testMethod void unitTest9RITOffcommitoutlook() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Outlook_Date__c = system.today();  
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Commit_Date__c = system.today();  
        de.Rit_A_Off_set__c = '1'; 
        de.Rit_B_Off_set__c = '1';  
        update de;
      
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest9OutlookCommit() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '14LPP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Outlook_Date__c = system.today();  
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_B_ready_Commit_Date__c = system.today();  
            
        update de;
      
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
    Private static testMethod void unitTest10() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        update de;
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
     Private static testMethod void unitTest7lpCommit() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest7lpOutlook() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest7lpOutlookCommit() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest7lpOutlookCommit111() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        de.Rit_B_Off_set_7LP__c = '1';
        de.Rit_A_Off_set_7LP__c = '1';
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    } 
    Private static testMethod void unitTest10Outlook() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
    Private static testMethod void unitTest10CommitOutlook() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);                
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Outlook_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    } 
     Private static testMethod void unitTest11() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        fieldValueOptionMap.put('Option_Stage__c','Prototype Fulfillment');
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        de.Production_netlist_delivery_IDR__c = system.today();
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.PTRF_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_IDR__c = system.today();
        de.RTM_e_Release_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_RIT_B_IDR__c = system.today();
        de.PTRF_RIT_A_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    }       
    
    Private static testMethod void unitTest11ASIC() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        fieldValueOptionMap.put('Option_Stage__c','Prototype Fulfillment');
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.PTRF_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_IDR__c = system.today();
        de.RTM_e_Release_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_RIT_B_IDR__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    }   
     Private static testMethod void unitTest11ASICIDR() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        fieldValueOptionMap.put('Option_Stage__c','Prototype Fulfillment');
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.PTRF_RIT_A_Actual_Date__c = system.today();
        de.RTM_e_Release_Actual_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Actual_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Actual_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
       
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        Test.StopTest();
    }      
        
    Private static testMethod void unitTest12() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        fieldValueDevMap.put('Product_Line__c','ASIC');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        fieldValueOptionMap.put('Option_Stage__c','Prototype Fulfillment');
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        de.Production_netlist_delivery_IDR__c = system.today();
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.PTRF_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_IDR__c = system.today();
        de.RTM_e_Release_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_RIT_B_IDR__c = system.today();
        de.PTRF_RIT_A_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        de.Production_netlist_delivery_Actual_Date__c = system.today();
        de.PTRF_RIT_A_Actual_Date__c = system.today();
        de.RTM_e_Release_Actual_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Actual_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Actual_Date__c = system.today();
        update de;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
         
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    }          
        
     Private static testMethod void unitTest13() {
        //test.startTest();
        //IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        //insert skipUser;
    
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        Map<String,Object> fieldValueOppMap = new Map<String,Object>();
        fieldValueOppMap.put('AccountId', account1.id);
        fieldValueOppMap.put('Target_Process_Node__c', '7LP');
        Opportunity opp1 = OpportunityDataFactory.createOpportunity(fieldValueOppMap);
        
        Map<String,Object> fieldValueOppProgMap = new Map<String,Object>();
        fieldValueOppProgMap.put('Account__c', account1.id);
        fieldValueOppProgMap.put('Opportunity__c', opp1.id);
        Opportunity_Program__c oppProg = OpportunityProgramDataFactory.createOpportunityProgram(fieldValueOppProgMap);
        
        Map<String,Object> fieldValueDevMap = new Map<String,Object>();
        fieldValueDevMap.put('Account__c', account1.id);
        fieldValueDevMap.put('Opportunity_Program__c', oppProg.id);
        fieldValueDevMap.put('Device_Sourcing__c', '1st Source');
        fieldValueDevMap.put('Product_Line__c','ASIC');        
        fieldValueDevMap.put('Semiconductor_Device__c', 'Analog - Amplifier');
        fieldValueDevMap.put('Device_Purpose__c', 'Customer Test Chip');
        fieldValueDevMap.put('Project_Name__c','Test Project Name');
        fieldValueDevMap.put('Product_Line__c','ASIC');
        //fieldValueDevMap.put('Reticle_Type__c','ASIC');
        Device__c dev1 = DeviceDataFactory.createDevice(fieldValueDevMap);
        
        test.startTest();
        Map<String,Object> fieldValueOptionMap = new Map<String,Object>();
        //fieldValueOptionMap.put('Opportunity__c',opp1.id);
        fieldValueOptionMap.put('Device__c',dev1.id);
        fieldValueOptionMap.put('Option_Stage__c','Prototype Fulfillment');
        Customer_Requirement__c  opt1 = BNP_DataFactory.createOption(fieldValueOptionMap);
        
        Map<String,Object> fieldValueCDSMap = new Map<String,Object>();
        fieldValueCDSMap.put('DIW_Option_Control_Number__c',opt1.id);
        Custom_Design__c cdsId = CDS_DataFactory.createCDS(fieldValueCDSMap);
        
        Map<String,Object> fieldValueDEMap = new Map<String,Object>();
        fieldValueDEMap.put('Customer_Design_Specification__c', cdsId.id);
        fieldValueDEMap.put('Option__c', opt1.id);
        fieldValueDEMap.put('Opportunity__c', opp1.id);
        Design_Execution__c de = DesignExecution_DataFactory.createDesignExection(fieldValueDEMap);
        //Design_Execution__c de = DesignExecutionUtill_Test.createsingleDERecord(); 
        //Test.StopTest();   
        
        DesignExecutionStaticValue__c des = new DesignExecutionStaticValue__c(name='DeviceGeometry',value__c='0.022');
        insert des;
               
        PageReference pageRef = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('deid', String.valueOf(de.Id));
        pageRef.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(de);
        DesignExecutionController dc = new DesignExecutionController(sc);
         
        dc.deid = de.id;
        dc.saveExecutionDetail();
        
        de.Production_netlist_delivery_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.RTM_e_Release_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Commit_Date__c = system.today();
        de.RTC_RIT_A_ready_Outlook_Date__c = system.today();
        de.RTC_RIT_B_ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Commit_Date__c = system.today();
        de.RTC_Rit_A_B_Ready_Outlook_Date__c = system.today();
        de.Production_netlist_delivery_IDR__c = system.today();
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.PTRF_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_IDR__c = system.today();
        de.RTM_e_Release_RIT_A_IDR__c = system.today();
        de.RTM_e_Release_RIT_B_IDR__c = system.today();
        de.PTRF_RIT_A_Commit_Date__c = system.today();
        update de;
        
        PageReference pageRef1 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('deid', String.valueOf(de.Id));
        pageRef1.getParameters().put('id', String.valueOf(de.Id));
        
                
        ApexPages.StandardController sc1 = new ApexPages.StandardController(de);
        DesignExecutionController dc1 = new DesignExecutionController(sc1);
         
        dc1.deid = de.id;
        dc1.saveExecutionDetail();
        
        
        de.Production_ntlst_delivery_Outlook_Date__c = system.today();
        de.RTM_e_Release_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Outlook_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Outlook_Date__c = system.today();
        de.Production_netlist_delivery_Actual_Date__c = system.today();
        de.RTM_e_Release_RIT_A_Commit_Date__c = system.today();
        de.RTM_e_Release_RIT_B_Commit_Date__c = system.today();
        de.PTRF_RIT_A_Commit_Date__c = system.today();
        
        update de;
        
        DesignExecutionStaticValue__c DESV = new DesignExecutionStaticValue__c();
        DESV.Off_Set_A_7LP__c =9;
        DESV.Off_Set_B_7LP__c = 10;
        DESV.Off_Set_A_14LPP__c =15;
        DESV.Off_Set_B_14LPP__c = 16;
        DESV.Name = 'Off Sets';
        Insert DESV;
        
        PageReference pageRef2 = Page.DesignExecutionRead;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('deid', String.valueOf(de.Id));
        pageRef2.getParameters().put('id', String.valueOf(de.Id));                        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(de);
        DesignExecutionController dc2 = new DesignExecutionController(sc2);
        dc2.ritVar3 = '1';
        dc2.ritVar1 = '1';
        dc2.ritVar2 = '1';
        dc2.ritVar4 = '1';
        dc2.deid = de.id;
        dc2.saveExecutionDetail();
        
        system.assertequals(de.Production_ntlst_delivery_Outlook_Date__c,system.today());   
        Test.StopTest();
    }          
        
    
}