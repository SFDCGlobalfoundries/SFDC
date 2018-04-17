@isTest
private class ConfigQuaterlyVolumeExtTest {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        //DataUtilTest.LoadDeviceEnvVariable();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
     }
   
    
    //static method to create product configuration
    static Apttus_Config2__ProductConfiguration__c  createProductConfig(String propID){
        Apttus_Config2__ProductConfiguration__c tempconfig = new Apttus_Config2__ProductConfiguration__c();
            tempconfig.name = 'testconfig';
            tempconfig.Apttus_QPConfig__Proposald__c = propID;
            tempconfig.Apttus_Config2__Status__c = 'Finalized';
        insert tempconfig ;
        return tempconfig;
    }
    
    static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','CSOI7RF');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c',processGeometry);
        fieldValueMap.put('Process_Family__c','Super Low Power');
        //fieldValueMap.put('deliverable_part_type__c','Module');
        fieldValueMap.put('business_unit__c','ASIC');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 9');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id; 
    }

    static Id createOppWithoutProductType(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','Test Opportunity1');
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','CSOI7RF');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c',processGeometry);
        fieldValueMap.put('Process_Family__c','Super Low Power');
     //   fieldValueMap.put('deliverable_part_type__c','Module');
        fieldValueMap.put('business_unit__c','ASIC');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 9');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id; 
    }
     static Id createWaferOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','CSOI7RF');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c',processGeometry);
        fieldValueMap.put('Process_Family__c','Super Low Power');
        //fieldValueMap.put('deliverable_part_type__c','Wafer');
        fieldValueMap.put('business_unit__c','ASIC');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 9');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id; 
    }
    static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','Test Opportunity Program');
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Opportunity__c',oppId);
       
        return OpportunityProgramDataFactory.createOpportunityProgram(fieldValueMap).id; 
    }
    
    static Id createDevice(String acctId, String opptyId, String opptyProgramId){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        Device__c device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        fieldValueMap.put('Actual_Tapeout_Date__c',system.today());
        fieldValueMap.put('Fab__c','FAB 9');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Device_Sourcing__c','First Source');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId); 
        
        return DeviceDataFactory.createDevice(fieldValueMap).id;                      
    }
    
    static testMethod void DeviceTriggerTest1() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = ConfigQuaterlyVolumeExtTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
            String deviceId = createDevice(acctId,opptyId,opptyProgramId);
            
            Apttus_Proposal__Proposal__c prop = createProposal(acctId, opptyId, deviceId, Null, Null); 
            /*prop.Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today();
            prop.Free_Devices__c = 'abcd<:>efgh';
            prop.SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345';
            update prop;*/
           
           list<Config_Quarterly_Volume__c> lstQ = new list<Config_Quarterly_Volume__c>(); 
           Config_Quarterly_Volume__c conQ1 = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=2013,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           lstQ.add(conQ1);
           Config_Quarterly_Volume__c conQ2 = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year(),Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           lstQ.add(conQ2);
         //  Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year()+1,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           insert lstQ;
           
        
           list<Quarterly_Revenue_Object__c> lstQR = new List<Quarterly_Revenue_Object__c>();
           Quarterly_Revenue_Object__c qR1 = new Quarterly_Revenue_Object__c(volume__c =100, year__C='2017',Opportunity__c=opptyId,     Fiscal_Quarter__c='2017-Q1',asp__c=0);
        
        lstQR.add(qR1);
        insert lstQR;
        system.debug('opptyId========================>' + opptyId);
        system.debug('opptyProgramId========================>' + opptyProgramId);
           PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 2,FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('retId',prop.Id);
           ApexPages.CurrentPage().getHeaders().put('Referer','GlobalfoundryView');
           ConfigQuaterlyVolumeExt controll = new ConfigQuaterlyVolumeExt();
           controll.gotoPostFabPage();
           controll.addRow();
           controll.deleteRows();
           controll.saveAndNext();
           controll.redirectToCatalog();
           controll.goToNextPage();   
           controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = NULL;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           }
           controll.goToNextPage();
            controll.thisQuarter = 2;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = NULL;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 3;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = NULL;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 4;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = NULL;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = NULL;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = NULL;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = NULL;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = NULL;
           } 
           controll.goToNextPage();
           Schema.DescribeSObjectResult r = Config_Quarterly_Volume__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
             vol.quaterlyVolume.Id = keyPrefix+'N00000008ONx';
           } 
           controll.goToNextPage();
        test.stopTest();
        
    }
    
    
     static testMethod void DeviceTriggerTest2() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = ConfigQuaterlyVolumeExtTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
            String deviceId = createDevice(acctId,opptyId,opptyProgramId);
            
            Apttus_Proposal__Proposal__c prop = createProposal(acctId, opptyId, deviceId, Null, Null); 
            /*prop.Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today();
            prop.Free_Devices__c = 'abcd<:>efgh';
            prop.SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345';
            update prop;*/
           
           Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year(),Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           insert conQ;
         //  Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year()+1,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
          // insert conQ;
           
           PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('retId',prop.Id);
           ApexPages.CurrentPage().getHeaders().put('Referer','GlobalfoundryView');
           ConfigQuaterlyVolumeExt controll = new ConfigQuaterlyVolumeExt();
           controll.gotoPostFabPage();
           controll.addRow();
           controll.deleteRows();
           controll.saveAndNext();
           controll.redirectToCatalog();
           controll.goToNextPage();   
           controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = NULL;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           }
           controll.goToNextPage();
            controll.thisQuarter = 2;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = NULL;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 3;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = NULL;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 4;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = NULL;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
            controll.thisQuarter = 1;
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = NULL;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = NULL;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = NULL;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
           for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = NULL;
           } 
           controll.goToNextPage();
            for(ConfigQuaterlyVolumeExt.WrapperQuaterly vol : controll.lstWrapperQuaterly) {
             vol.quaterlyVolume.Year__c = date.today().year()+1;
             vol.quaterlyVolume.Q1_Volume__c = 100;
             vol.quaterlyVolume.Q2_Volume__c = 100;
             vol.quaterlyVolume.Q3_Volume__c = 100;
             vol.quaterlyVolume.Q4_Volume__c = 100;
           } 
           controll.goToNextPage();
        test.stopTest();
        
    }
        
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device 
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,                                                     
                                                     Mask_Set__c = szMaskSet, //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     //Mask_Set_Long__c = szMaskSet,                                                      
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true,
                                                     Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today(),
                                                     Free_Devices__c = 'abcd<:>efgh',
                                                     SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345',
                                                     Deliverable_Part_Type__c='Module');
        
        insert proposal;
        return proposal;
    }
        
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposalWithoutProductType(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device 
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,                                                     
                                                     Mask_Set__c = szMaskSet, //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     //Mask_Set_Long__c = szMaskSet,                                                      
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true,
                                                     Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today(),
                                                     Free_Devices__c = 'abcd<:>efgh',
                                                     SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345');
        
        insert proposal;
        return proposal;
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposalWithWafer(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device 
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,                                                     
                                                     Mask_Set__c = szMaskSet, //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     //Mask_Set_Long__c = szMaskSet,                                                      
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true,
                                                     Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today(),
                                                     Free_Devices__c = 'abcd<:>efgh',
                                                     SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345',
                                                     Deliverable_Part_Type__c='Wafer');
        
        insert proposal;
        return proposal;
    }
     
       //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposalWithoutFAB(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device 
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
       //                                              Device__c = devId,                                                     
                                                     Mask_Set__c = szMaskSet, //changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463
                                                     //Mask_Set_Long__c = szMaskSet,                                                      
                                                   //  Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id,
                                                     APTPS_Primary__c = true,
                                                  //   Actual_Tapeout_Date_FAB_9_and_FAB_10__c=system.today(),
                                                     Free_Devices__c = 'abcd<:>efgh',
                                                     SRAM_Sizes__c = 'abcd>:<123<:>efgh>:<345',
                                                     Deliverable_Part_Type__c='Module');
        
        insert proposal;
        return proposal;
    } 
 static testMethod void DeviceTriggerTest3  () {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = ConfigQuaterlyVolumeExtTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
            String deviceId = createDevice(acctId,opptyId,opptyProgramId);
            
     Apttus_Proposal__Proposal__c prop = createProposalWithoutFAB(acctId, opptyId, deviceId, Null, Null); 
        Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year(),Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           insert conQ;
         //  Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year()+1,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
          // insert conQ;
           
        
           PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('retId',prop.Id);
           ApexPages.CurrentPage().getHeaders().put('Referer','GlobalfoundryView');
           ConfigQuaterlyVolumeExt controll = new ConfigQuaterlyVolumeExt();
           controll.gotoPostFabPage();
     test.stopTest();
 
 }    
 static testMethod void DeviceTriggerTest4() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = ConfigQuaterlyVolumeExtTest.createOppWithoutProductType(acctId, '0.60UM');
       string opptyIdWafer = ConfigQuaterlyVolumeExtTest.createWaferOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyId);
        
        test.startTest();
            // Create Device
            String deviceId = createDevice(acctId,opptyId,opptyProgramId);
            
     Apttus_Proposal__Proposal__c prop = createProposalWithoutProductType(acctId, opptyId, deviceId, Null, Null); 
        Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year(),Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           insert conQ;
         //  Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop.Id,Year__c=date.today().year()+1,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
          // insert conQ;
           
        
           PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
           
           PageReference pg = Page.CPQ_Proposal_Pdf;
           ApexPages.CurrentPage().getParameters().put('retId',prop.Id);
           ApexPages.CurrentPage().getHeaders().put('Referer','GlobalfoundryView');
           ConfigQuaterlyVolumeExt controll = new ConfigQuaterlyVolumeExt();
           controll.gotoPostFabPage();
        controll.goToNextPage();
     
     test.stopTest();
 
 }    
 
 static testMethod void DeviceTriggerTest5() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
       string opptyIdWafer = ConfigQuaterlyVolumeExtTest.createWaferOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyIdWafer);
        
        test.startTest();
            // Create Device
         
       PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
         
     String deviceId = createDevice(acctId,opptyIdWafer,opptyProgramId);
  Apttus_Proposal__Proposal__c prop1 = createProposalWithWafer(acctId, opptyIdWafer, deviceId, Null, Null); 
   PageReference     pg = Page.CPQ_Proposal_Pdf;
      ApexPages.CurrentPage().getParameters().put('retId',prop1.Id);
      Config_Quarterly_Volume__c conQ1 = new Config_Quarterly_Volume__c(Quote_Proposal__c=prop1.Id,Year__c=date.today().year(),Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
          insert conQ1;
       ConfigQuaterlyVolumeExt controll1 = new ConfigQuaterlyVolumeExt();
           controll1.goToNextPage();
      controll1.gotoPostFabPage();
     test.stopTest();
 
 }
 static testMethod void DeviceTriggerTest6() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
       string opptyIdWafer = ConfigQuaterlyVolumeExtTest.createWaferOpp(acctId, '0.60UM');
        string opptyProgramId = ConfigQuaterlyVolumeExtTest.createOppProg(acctId, opptyIdWafer);
        
        test.startTest();
            // Create Device
         
       PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
         
     String deviceId = createDevice(acctId,opptyIdWafer,opptyProgramId);
  Apttus_Proposal__Proposal__c prop1 = createProposalWithWafer(acctId, opptyIdWafer, deviceId, Null, Null); 
   PageReference     pg = Page.ConfigQuarterlyVolume;
      ApexPages.CurrentPage().getParameters().put('retId',prop1.Id);
      ConfigQuaterlyVolumeExt controll1 = new ConfigQuaterlyVolumeExt();
	  controll1.proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = NULL;
	  controll1.gotoPostFabPage();
      test.stopTest();
 
 }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}