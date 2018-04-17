@istest(SeeAllData=false)
public class CPQConfigPostFabServices_test {


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

    static testmethod void CPQConfigPostFabServices_test_methodnull(){
      test.starttest();
        CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
        obj.cMonth = System.today().month()+3;
        obj = new CPQConfigPostFabServices();
        obj.cMonth = System.today().month()+6;
        obj = new CPQConfigPostFabServices(); 
        
        //CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
        obj.pfyields = [Select Circuit_Group__c,Circuit_Type__c,Redundancy__c,Circuit_Unit__c,Count__c,PFile__c,QTR1__c,QTR2__c,QTR3__c,QTR4__c,QTR5__c,QTR6__c,QTR7__c,QTR8__c,QTR9__c,QTR10__c,
                                                 QTR11__c,QTR12__c,QTR13__c,QTR14__c,QTR15__c,QTR16__c,QTR17__c,QTR18__c,QTR19__c,QTR20__c,QTR21__c,QTR22__c,QTR23__c,QTR24__c,Yield_Type__c From PFile_Yield__c] ;
        obj.fileData ='test';
        obj.isBIBCDetails = true;
        obj.items ='test'; 
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'CORES';
        Pagereference p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'IO';
        p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'MIXED';
        p = obj.CreateWTY();
        
        Pagereference p1 = obj.pageActionInitialization();
        Config_Post_Fab_Service_Detail__c det = new Config_Post_Fab_Service_Detail__c();
        det.RecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
        det.Config_Post_Fab_Service__c = obj.ConfigPSTFabServ.Id;
        det.Circuit_Group__c = 'CORES';
        det.Circuit_Type__c = 'CORES';
        det.CKT_Unit__c = '1';
        det.Count__c = 1;
        det.Available_Redundancy__c = null;
        //insert det;
        try {
        Pagereference p2 = obj.reviewSelection();
        }catch(exception e){}
        obj.ConfigPSTFabServ.Package_Tech_Method__c = 'Custom';
        try {
        Pagereference p2 = obj.reviewSelection();
        }catch(exception e){}
        PCM_Cost__c cst = new PCM_Cost__c();
        cst.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        cst.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        cst.solder__c = obj.ConfigPSTFabServ.solder__c;
        cst.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        cst.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        cst.wafer_size__c = 200;
        cst.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert cst;
        
        PCM_Yield__c yld = new PCM_Yield__c();
        yld.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        yld.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        yld.solder__c = obj.ConfigPSTFabServ.solder__c;
        yld.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        yld.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        yld.wafer_size__c = 200;
        yld.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert yld; 
        
        CPQConfigPostFabServices.wrapperlist wr = new CPQConfigPostFabServices.wrapperlist();
        wr.volume= 100;
        obj.listwrapperSCCost.clear();
        obj.listwrapperSCCost.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild.clear();
        obj.listwrapperModuleBuild.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperModuleBuild2.clear();
        obj.listwrapperModuleBuild2.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild3.clear();
        obj.listwrapperModuleBuild3.add(wr);
     //   p2 = obj.reviewSelection();
        
        obj.listwrapperModule.clear();
        obj.listwrapperModule.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnInUser.clear();
        obj.listwrapperBurnInUser.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperMCMUser.clear();
        obj.listwrapperMCMUser.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnIn.clear();
        obj.listwrapperBurnIn.add(wr);
        try {
        Pagereference p2 = obj.reviewSelection();
        }catch(exception e){}
        
        try {
        obj.modifiedModBuildVal = 'Package Tech';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Package IO';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Body Length';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst IO Pitch';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Layer';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Material';
        Pagereference p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {        
        List<SelectOption> options = obj.getCapacitorType();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getEncapsulation();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getPackageTech();
        }catch(exception e){}
        
         try {        
        List<SelectOption> options = obj.getBondingFab();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getMinC4Pitch();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getBLMSizeType();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getSolder();
        }catch(exception e){}
        
         try {        
        List<SelectOption> options = obj.getSolderType();
        }catch(exception e){}
        
         try {        
        List<SelectOption> options = obj.getBonding();
        }catch(exception e){}
         try {
        obj.modifiedModBuildVal = 'Subst Layer';
        Pagereference p2 = obj.refreshBonding();
        }catch(exception e){}
     
        Pagereference p3 = obj.UserModuleDisplay();
        Pagereference p4 = obj.WTTDisplay();
        Pagereference p5 = obj.renderWTY();
        Pagereference p6 = obj.UserWaferDisplay();
        Pagereference p7 = obj.UserDefinedYieldDisplay();
        Pagereference p8 = obj.UserModuleDefinedDisplay();
        Pagereference p9 = obj.UserModuleTimeDisplay();
        Pagereference p10 = obj.populatekerf();
        Pagereference p11 = obj.UserDefinedDisplay();
           obj.createQuarterlyVolumeList();
        obj.getPFStatvalues();
        obj.getPfvalues();
        obj.getPfdescrs();
        obj.getPfrevisions();
        obj.generateList(4);
     
        Pagereference p13 = obj.createPFdata();
        Pagereference p12 = obj.getpfchilds();

        obj.md();
        test.stoptest();
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
    
    static Id createOpp(Id acctId) {       
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','Test Opportunity');
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));
        fieldValueMap.put('Target_Process_Node__c','CSOI7RF');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);
        fieldValueMap.put('Process_Geometry__c','0.180UM');
        fieldValueMap.put('Process_Family__c','Super Low Power');
        //fieldValueMap.put('deliverable_part_type__c','Module');
        fieldValueMap.put('business_unit__c','ASIC');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 9');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;       
    }
    
    static Id createOppProg(Id acctId,Id oppId) {
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
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Device_Sourcing__c','First Source');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId); 
        fieldValueMap.put('Fab__c','FAB 8');
        return DeviceDataFactory.createDevice(fieldValueMap).id;                      
    }

    static testmethod void CPQConfigPostFabServices_test_method(){
        
      User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
           System.runAs(admin){
           IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
         string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = CPQConfigPostFabServices_test.createOpp(acctId);
        string opptyProgramId = CPQConfigPostFabServices_test.createOppProg(acctId,opptyId);
        String deviceId = createDevice(acctId,opptyId,opptyProgramId);  
           
       // Device__c device1 = [select id,Fab__c from Device__c limit 1];
      //  device1.Fab__c = 'FAB 8';
       // database.update(device1);
       
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
           
            

             test.startTest();
            
             NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
            
            Apttus_Proposal__Proposal__c quoteobj = new Apttus_Proposal__Proposal__c();
            quoteobj.Approved_by_Packaging_Team__c = true;
            quoteobj.Apttus_Proposal__Opportunity__c = opptyId ;
            quoteobj.Device__c = deviceId;
            quoteobj.Apttus_Proposal__Account__c = acctId;        
            quoteobj.Relgrade__c = '6.00';
            quoteobj.deliverable_part_type__c='Module';        
            insert quoteobj;
            
            
            Apttus_Config2__ProductConfiguration__c   prodconfig = new Apttus_Config2__ProductConfiguration__c();
            prodconfig.Apttus_QPConfig__Proposald__c = quoteobj.id;
            insert prodconfig;
        
            Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
            lineitem.Apttus_Config2__ConfigurationId__c = prodconfig.id;
            lineitem.Apttus_Config2__LineType__c ='Product/Service';
            lineitem.Apttus_Config2__ItemSequence__c =1 ; 
            lineitem.Apttus_Config2__LineNumber__c = 12345;
           // insert lineitem;  
        
            Apttus_Config2__ProductAttributeValue__c attributevalue = new Apttus_Config2__ProductAttributeValue__c();
            attributevalue.Die_Size_X_mm__c = 10;
            attributevalue.Die_Size_X_mm__c = 20;
            attributevalue.APTPS_ProcessTechnology__c = 'CSOI7RF';
          
            Config_Post_Fab_Services__c configservobj = new Config_Post_Fab_Services__c();
            configservobj.Configuration__c = quoteobj.id;
            configservobj.Method__c = 'Circuit';
            insert configservobj;
            system.debug('configservobj'+configservobj);
            system.debug('quoteobj.id'+quoteobj.id);
            Config_Quarterly_Volume__c qvol =  new Config_Quarterly_Volume__c();
            qvol.Quote_Proposal__c = quoteobj.id;
            qvol.Q1_Volume__c =100;
            qvol.Q2_Volume__c=100;
            qvol.Q3_Volume__c=200;
            qvol.Q4_Volume__c=500;
            qvol.Year__c = 2016;
            insert qvol;
            
            
            
            ApexPages.currentPage().getParameters().put('id',prodconfig.id);    
            Config_Post_Fab_Services__c configservobj1 = new Config_Post_Fab_Services__c();
            configservobj1.Configuration__c = quoteobj.id;
            configservobj1.Method__c = 'Circuit';
            configservobj1.Capacitor_Qty__c = 1000;
            configservobj1.Number_of_Socket_Per_Boards__c = 1000;
            configservobj1.Test_Time_Method__c = 'Custom';
            configservobj1.Module_User_Defined_Time__c = 10;
            configservobj1.MCM_User_Defined_Time__c    = 10;
            configservobj1.Bonding__c = 'C4';
            configservobj1.Solder_Type__c = 'By Customer';
            configservobj1.Solder__c = 'By Customer';
            configservobj1.BLM_Size_Type__c = 'By Customer';
            configservobj1.Minimum_C4_Pitch__c = 'By Customer';
            configservobj1.Fab__c ='Fab 1';
            configservobj1.Minimum_Kerf__c ='No';
            configservobj1.Kerf_X__c =10;
            configservobj1.Kerf_Y__c =10;
            
            configservobj1.Circuit_Limited_Yield_CLY__c = 1;
            configservobj1.Design_for_Profit_DFP__c = 1;
            configservobj1.Test_Location__c = 'Fab 8';   
            configservobj1.Test_Time_Method__c = 'User Defined GTT/Chip';
            configservobj1.User_Defined_Time__c = 10;
            configservobj1.Number_of_DUTS__c = '8';
            
            configservobj1.Package_Tech_Method__c = 'GF';
            configservobj1.Package_Technology__c = 'FCPBGA';
            configservobj1.Package_IO__c = '120';
            configservobj1.Body_Length__c = '15';
            configservobj1.Body_Width__c = '15';
            configservobj1.Subst_Layer__c = '121R';
            configservobj1.Subst_IO_Pitch__c = '15';
            configservobj1.Subst_Material__c = 'TBD';
            configservobj1.Wire_Material_for_WB__c = 'TBD';
           configservobj1.Capacitor_Type__c = 'DLA 50*50';
            configservobj1.Capacitor_Qty__c= 15;
            configservobj1.Package_IO_Pitch__c = '15';
            configservobj1.Encapsulation__c = 'Vendor';
            configservobj1.Line_Width__c = '0';
            
            configservobj1.Module_Test_Location__c = 'Fab 8';
            configservobj1.Module_Test_Platform__c = 'TOB';
            configservobj1.Module_Test_Time_Method__c = 'User Defined GTT/Chip';
            configservobj1.Module_User_Defined_Time__c = 10;
            configservobj1.Module_Number_of_DUTS__c = '8';
            configservobj1.Module_Test_Yield_Method__c = 'Custom';
            
            
            
            
            configservobj1.Method__c = 'Custom';
            insert configservobj1;
            Config_Post_Fab_Service_Detail__c cfdetail = new Config_Post_Fab_Service_Detail__c();
            cfdetail.Method__c = 'Circuit';       
            cfdetail.Circuit_Type__c ='CORES';
            cfdetail.Count__c = 10 ; 
            cfdetail.Circuit_Group__c = 'CORES';
            cfdetail.Config_Post_Fab_Service__c =configservobj1.id ;
              cfdetail.Bond_Assembly_Cost_by_Time_Period__c = 100;
            cfdetail.Bond_Assembly_Yield_by_Time_Period__c = 100;
            cfdetail.Burn_in_Board_Cost__c = 100;
            cfdetail.Burn_in_duration__c = 100;
            cfdetail.Circuit_Group__c = 'CORES';
            cfdetail.Circuit_Type__c = 'CORES';
            cfdetail.CKT_Unit__c = 'DRA';
            cfdetail.Count__c = 100;
            cfdetail.Method__c = 'Circuit';
            cfdetail.Quarter__c = 'Q1';
            cfdetail.Subst_Cost_by_Time_Period__c = 100;
            cfdetail.User_Defined_Time_MCM__c = 100;
            cfdetail.User_Defined_Yield_BI__c = 100;
            cfdetail.User_Defined_Yield_MCM__c = 100;
            cfdetail.User_Defined_Yield_Module__c = 100;
            System.debug('configservobj1' + configservobj1.id);
            
            Map <String,Schema.RecordTypeInfo> recordTypeMap = Config_Post_Fab_Service_Detail__c.sObjectType.getDescribe().getRecordTypeInfosByName();
            if(recordTypeMap.containsKey('MCM user defined yield')) {
             cfdetail.RecordTypeId= recordTypeMap.get('MCM user defined yield').getRecordTypeId();
            }
            insert cfdetail;
            
            list<PCM_Yield__c> lstPCMYield = new list<PCM_Yield__c>();
            PCM_Yield__c yield = new PCM_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('FEOL').RecordTypeId,year__c = String.valueOf(date.today().year()),Catalog_ID__c='PCM215',Version__c='1',PT_Number__c= 'PT003612',Fab__c='FAB 2',bonding__c='C4',Solder_Type__c='By Customer',Solder__c='By Customer',
                                                   BLM_Size_Type__c='By Customer',Minimum_C4_Pitch__c='By Customer');
            lstPCMYield.add(yield);
            PCM_Yield__c yield1 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('BEOL PRE').RecordTypeId,year__c = String.valueOf(date.today().year()),Catalog_ID__c='PCM215',Version__c='1',PT_Number__c= 'PT003612',Fab__c='FAB 2',
                                                   bonding__c='C4',Solder_Type__c='By Customer',Solder__c='By Customer',
                                                   BLM_Size_Type__c='By Customer',Minimum_C4_Pitch__c='By Customer');
            lstPCMYield.add(yield1);
            PCM_Yield__c yield2 = new PCM_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('KERF X').RecordTypeId,PROD_INT__c=0.01,PROD_KERF__c=0.01,
                                                  Chip_LO__c=0,Chip_HI__c=999,PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                                  Relgrade__c=5);
            lstPCMYield.add(yield2);
            PCM_Yield__c yield3 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('KERF Y').RecordTypeId,PROD_INT__c=0.01,PROD_KERF__c=0.01,
                                                  Chip_LO__c=0,Chip_HI__c=999,PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                                  Relgrade__c=5);
            lstPCMYield.add(yield3);
            PCM_Yield__c yield4 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('Tech Info').RecordTypeId,
                                                  Exclusion_Zone__c=3,PT_Number__c='PT003612',Wafer_Size__c=200,Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                                  Relgrade__c=5);
            lstPCMYield.add(yield4);
            insert lstPCMYield;
                  
         ApexPages.currentPage().getParameters().put('retId',quoteobj.id);
            
             NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
            CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
            obj.ConfigPSTFabServ = configservobj1;
            obj.PCMYieldObj = lstPCMYield;
            obj.PCMYieldObj1= lstPCMYield;
            obj.ConfigPostFabServiceDetail = cfdetail;
            
            Pagereference p1 = obj.pageActionInitialization();
            Pagereference p2 = obj.reviewSelection();
            
            Pagereference p3 = obj.UserModuleDisplay();
            Pagereference p4 = obj.WTTDisplay();
            Pagereference p5 = obj.renderWTY();
            Pagereference p6 = obj.UserWaferDisplay();
            Pagereference p7 = obj.UserDefinedYieldDisplay();
            Pagereference p8 = obj.UserModuleDefinedDisplay();
            Pagereference p9 = obj.UserModuleTimeDisplay();
            Pagereference p10 = obj.populatekerf();
            Pagereference p11 = obj.UserDefinedDisplay();
            Pagereference p12 = obj.getpfchilds();
            Pagereference p13 = obj.createPFdata();
            obj.createQuarterlyVolumeList();
            obj.getPFStatvalues();
            obj.getPfvalues();
            obj.getPfdescrs();
            obj.getPfrevisions();
            obj.generateList(4);
            obj.md();
           try{ 
           Pagereference p = obj.CreateWTY();
            obj.backtoQuaterlyPage();
           obj.backtoOption();   
           
        }catch(Exception e){
            
        }
         test.stopTest();
        }
    }
    
    
        static testmethod void CPQConfigPostFabServices_test_method2(){
        
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
           System.runAs(admin){
           IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
         string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = CPQConfigPostFabServices_test.createOpp(acctId);
        string opptyProgramId = CPQConfigPostFabServices_test.createOppProg(acctId,opptyId);
        String deviceId = createDevice(acctId,opptyId,opptyProgramId);  
           
             
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
           
            
        
         /*Opportunity op = [Select id, Deliverable_Part_Type__c from Opportunity where id = : opptyId];
        op.Deliverable_Part_Type__c = 'MCM';
        update op;*/
       
        
        NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        test.startTest();
        
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
            
        
            Apttus_Proposal__Proposal__c quoteobj = new Apttus_Proposal__Proposal__c();
            quoteobj.Approved_by_Packaging_Team__c = true;
            quoteobj.Apttus_Proposal__Opportunity__c = opptyId;
            quoteobj.Device__c = deviceId ;
            quoteobj.Apttus_Proposal__Account__c = acctId;     
            quoteobj.Relgrade__c = '6.00';
            quoteobj.deliverable_part_type__c = 'Module';       
            insert quoteobj;
            
            
            Apttus_Config2__ProductConfiguration__c   prodconfig = new Apttus_Config2__ProductConfiguration__c();
            prodconfig.Apttus_QPConfig__Proposald__c = quoteobj.id;
            insert prodconfig;
        
            Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
            lineitem.Apttus_Config2__ConfigurationId__c = prodconfig.id;
            lineitem.Apttus_Config2__LineType__c ='Product/Service';
            lineitem.Apttus_Config2__ItemSequence__c =1 ; 
            lineitem.Apttus_Config2__LineNumber__c = 12345;
            //insert lineitem;  
        
            Apttus_Config2__ProductAttributeValue__c attributevalue = new Apttus_Config2__ProductAttributeValue__c();
            attributevalue.Die_Size_X_mm__c = 10;
            attributevalue.Die_Size_X_mm__c = 20;
            attributevalue.APTPS_ProcessTechnology__c = 'CSOI7RF';       
            //insert attributevalue;
        
            Config_Post_Fab_Services__c configservobj = new Config_Post_Fab_Services__c();
            configservobj.Configuration__c = quoteobj.id;
            configservobj.Method__c = 'Circuit';
            insert configservobj;
                   
            Config_Quarterly_Volume__c qvol =  new Config_Quarterly_Volume__c();
            qvol.Quote_Proposal__c = quoteobj.id;
            qvol.Q1_Volume__c =100;
            qvol.Q2_Volume__c=100;
            qvol.Q3_Volume__c=200;
            qvol.Q4_Volume__c=500;
            qvol.Year__c = 2016;
            insert qvol;
            
            PFile_Data__c pfiledata = new PFile_Data__c();
            pfiledata.PF_Stat__c = '100';
            pfiledata.PF_Desc__c = '100';
            pfiledata.Revision__c = 10 ;
            pfiledata.PF_Number__c =100 ;
            pfiledata.Configuration__c = quoteobj.id;
            insert pfiledata;
            
            PFile_Yield__c  py = new PFile_Yield__c();
            py.PFile__c = pfiledata.id;
            py.Circuit_Group__c ='IO' ;
            py.Circuit_Type__c ='IOS' ;
            py.Circuit_Unit__c ='Kcount' ;
            py.Count__c = 10 ;
            insert py;
            
            Id devRecordTypeId3 = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
         
            
            Config_Post_Fab_Service_Detail__c cfdetail = new Config_Post_Fab_Service_Detail__c();
            cfdetail.Method__c = 'Circuit';    
            cfdetail.Circuit_Type__c ='CORES';
            cfdetail.Count__c = 10 ; 
            cfdetail.Circuit_Group__c = 'CORES';
            cfdetail.recordtypeid = devRecordTypeId3;
            
            ApexPages.currentPage().getParameters().put('id',prodconfig.id);   
            Config_Post_Fab_Services__c configservobj1 = new Config_Post_Fab_Services__c();
            configservobj1.Configuration__c = quoteobj.id;
            configservobj1.Method__c = 'Circuit';
            configservobj1.Capacitor_Qty__c = 1000;
            configservobj1.Number_of_Socket_Per_Boards__c = 1000;
            configservobj1.Test_Time_Method__c = 'Custom';
            configservobj1.PF_Stat__c= '100';
            configservobj1.PF_Number__c = '100';
            configservobj1.Revision__c = '10';
            configservobj1.PF_Desc__c = '100';
                       
            configservobj1.Module_User_Defined_Time__c = 10;
            configservobj1.MCM_User_Defined_Time__c    = 10;
            configservobj1.Bonding__c = 'C4';
            configservobj1.Solder_Type__c = 'By Customer';
            configservobj1.Solder__c = 'By Customer';
            configservobj1.BLM_Size_Type__c = 'By Customer';
            configservobj1.Minimum_C4_Pitch__c = 'By Customer';
            configservobj1.Fab__c ='Fab 1';
            configservobj1.Minimum_Kerf__c ='No';
            configservobj1.Kerf_X__c =10;
            configservobj1.Kerf_Y__c =10;
            
            configservobj1.Circuit_Limited_Yield_CLY__c = 1;
            configservobj1.Design_for_Profit_DFP__c = 1;
            configservobj1.Test_Location__c = 'Fab 8';    
            configservobj1.Test_Time_Method__c = 'User Defined GTT/Chip';
            configservobj1.User_Defined_Time__c = 10;
            configservobj1.Number_of_DUTS__c = '8';
            
            configservobj1.Package_Tech_Method__c = 'GF';
            configservobj1.Package_Technology__c = 'FCPBGA';
            configservobj1.Package_IO__c = '120';
            configservobj1.Body_Length__c = '15';
            configservobj1.Body_Width__c = '15';
            configservobj1.Subst_Layer__c = '121R';
            configservobj1.Subst_IO_Pitch__c = '15';
            configservobj1.Subst_Material__c = 'TBD';
            configservobj1.Wire_Material_for_WB__c = 'TBD';
            configservobj1.Capacitor_Type__c = 'DLA 50*50';
            configservobj1.Capacitor_Qty__c= 15;
            configservobj1.Package_IO_Pitch__c = '15';
            configservobj1.Encapsulation__c = 'Vendor';
            configservobj1.Line_Width__c = '0';
            
            configservobj1.Module_Test_Location__c = 'Fab 8';
            configservobj1.Module_Test_Platform__c = 'TOB';
            configservobj1.Module_Test_Time_Method__c = 'User Defined GTT/Chip';
            configservobj1.Module_User_Defined_Time__c = 10;
            configservobj1.Module_Number_of_DUTS__c = '8';
            configservobj1.Module_Test_Yield_Method__c = 'Custom';
                                           
            insert configservobj1;
            cfdetail.Config_Post_Fab_Service__c =configservobj1.id ;
            cfdetail.Bond_Assembly_Cost_by_Time_Period__c = 100;
            cfdetail.Bond_Assembly_Yield_by_Time_Period__c = 100;
            cfdetail.Burn_in_Board_Cost__c = 100;
            cfdetail.Burn_in_duration__c = 100;
            cfdetail.Circuit_Group__c = 'CORES';
            cfdetail.Circuit_Type__c = 'CORES';
            cfdetail.CKT_Unit__c = 'DRA';
            cfdetail.Count__c = 100;
            cfdetail.Method__c = 'Circuit';
            cfdetail.Quarter__c = 'Q1';
            cfdetail.Subst_Cost_by_Time_Period__c = 100;
            cfdetail.User_Defined_Time_MCM__c = 100;
            cfdetail.User_Defined_Yield_BI__c = 100;
            cfdetail.User_Defined_Yield_MCM__c = 100;
            cfdetail.User_Defined_Yield_Module__c = 100;
            
            
                    Map <String,Schema.RecordTypeInfo> recordTypeMap = Config_Post_Fab_Service_Detail__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    if(recordTypeMap.containsKey('MCM user defined yield')) {
     cfdetail.RecordTypeId= recordTypeMap.get('MCM user defined yield').getRecordTypeId();
    }
            
    
            
            
            insert cfdetail;
                   
         ApexPages.currentPage().getParameters().put('retId',quoteobj.id);
           
            CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
            obj.pfyields = [Select Circuit_Group__c,Circuit_Type__c,Redundancy__c,Circuit_Unit__c,Count__c,PFile__c,QTR1__c,QTR2__c,QTR3__c,QTR4__c,QTR5__c,QTR6__c,QTR7__c,QTR8__c,QTR9__c,QTR10__c,
                                                     QTR11__c,QTR12__c,QTR13__c,QTR14__c,QTR15__c,QTR16__c,QTR17__c,QTR18__c,QTR19__c,QTR20__c,QTR21__c,QTR22__c,QTR23__c,QTR24__c,Yield_Type__c From PFile_Yield__c] ;
            obj.fileData ='test';
            obj.isBIBCDetails = true;
            obj.items ='test'; 
            Pagereference p = obj.CreateWTY();
            Pagereference p1 = obj.pageActionInitialization();
            Pagereference p2 = obj.reviewSelection();
            
            Pagereference p3 = obj.UserModuleDisplay();
            Pagereference p4 = obj.WTTDisplay();
            Pagereference p5 = obj.renderWTY();
            Pagereference p6 = obj.UserWaferDisplay();
            Pagereference p7 = obj.UserDefinedYieldDisplay();
            Pagereference p8 = obj.UserModuleDefinedDisplay();
            Pagereference p9 = obj.UserModuleTimeDisplay();
            Pagereference p10 = obj.populatekerf();
            Pagereference p11 = obj.UserDefinedDisplay();
               obj.createQuarterlyVolumeList();
            obj.getPFStatvalues();
            obj.getPfvalues();
            obj.getPfdescrs();
            obj.getPfrevisions();
            obj.generateList(4);
         
            Pagereference p13 = obj.createPFdata();
            Pagereference p12 = obj.getpfchilds();
    
            obj.md();
                 
            test.stopTest(); 
        }
        }
    
    static testmethod void CPQConfigPostFabServices_test_method3(){
    
    User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
           System.runAs(admin){
           IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
         string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = CPQConfigPostFabServices_test.createOpp(acctId);
        string opptyProgramId = CPQConfigPostFabServices_test.createOppProg(acctId,opptyId);
        String deviceId = createDevice(acctId,opptyId,opptyProgramId);  
           
             
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
            
            
      
        
         /*Opportunity op = [Select id, Deliverable_Part_Type__c from Opportunity where id = : opptyId];
        op.Deliverable_Part_Type__c = 'MCM';
        update op;*/
        NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        test.startTest();
        
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
    
        Apttus_Proposal__Proposal__c quoteobj = new Apttus_Proposal__Proposal__c();
        quoteobj.Approved_by_Packaging_Team__c = true;
        quoteobj.Apttus_Proposal__Opportunity__c = opptyId ;
        quoteobj.Device__c = deviceId ;
        quoteobj.Apttus_Proposal__Account__c = acctId;       
        quoteobj.Relgrade__c = '6.00';
        quoteobj.deliverable_part_type__c='Module';       
        insert quoteobj;
        
        
        Apttus_Config2__ProductConfiguration__c   prodconfig = new Apttus_Config2__ProductConfiguration__c();
        prodconfig.Apttus_QPConfig__Proposald__c = quoteobj.id;
        insert prodconfig;
    
        Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
        lineitem.Apttus_Config2__ConfigurationId__c = prodconfig.id;
        lineitem.Apttus_Config2__LineType__c ='Product/Service';
        lineitem.Apttus_Config2__ItemSequence__c =1 ; 
        lineitem.Apttus_Config2__LineNumber__c = 12345;
       // insert lineitem;  
    
        Apttus_Config2__ProductAttributeValue__c attributevalue = new Apttus_Config2__ProductAttributeValue__c();
        attributevalue.Die_Size_X_mm__c = 10;
        attributevalue.Die_Size_X_mm__c = 20;
        attributevalue.APTPS_ProcessTechnology__c = 'CSOI7RF';       
    
        Config_Post_Fab_Services__c configservobj = new Config_Post_Fab_Services__c();
        configservobj.Configuration__c = quoteobj.id;
        configservobj.Method__c = 'Circuit';
        insert configservobj;
       
        Config_Quarterly_Volume__c qvol =  new Config_Quarterly_Volume__c();
        qvol.Quote_Proposal__c = quoteobj.id;
        qvol.Q1_Volume__c =100;
        qvol.Q2_Volume__c=100;
        qvol.Q3_Volume__c=200;
        qvol.Q4_Volume__c=500;
        qvol.Year__c = 2016;
        insert qvol;
        
        
        
        ApexPages.currentPage().getParameters().put('id',prodconfig.id);
   
        Config_Post_Fab_Services__c configservobj1 = new Config_Post_Fab_Services__c();
        configservobj1.Configuration__c = quoteobj.id;
        configservobj1.Method__c = 'Circuit';
        configservobj1.Capacitor_Qty__c = 1000;
        configservobj1.Number_of_Socket_Per_Boards__c = 1000;
        configservobj1.Test_Time_Method__c = 'Custom';
        configservobj1.Module_User_Defined_Time__c = 10;
        configservobj1.MCM_User_Defined_Time__c    = 10;
        configservobj1.Bonding__c = 'C4';
        configservobj1.Solder_Type__c = 'By Customer';
        configservobj1.Solder__c = 'By Customer';
        configservobj1.BLM_Size_Type__c = 'By Customer';
        configservobj1.Minimum_C4_Pitch__c = 'By Customer';
        configservobj1.Fab__c ='Fab 1';
        configservobj1.Minimum_Kerf__c ='No';
        configservobj1.Kerf_X__c =10;
        configservobj1.Kerf_Y__c =10;
        
        configservobj1.Circuit_Limited_Yield_CLY__c = 1;
        configservobj1.Design_for_Profit_DFP__c = 1;
        configservobj1.Test_Location__c = 'Fab 8';   
        configservobj1.Test_Time_Method__c = 'User Defined GTT/Chip';
        configservobj1.User_Defined_Time__c = 10;
        configservobj1.Number_of_DUTS__c = '8';
        
        configservobj1.Package_Tech_Method__c = 'Custom';
        configservobj1.Burn_in_Stress_Yield_Method__c = 'Custom'; 
        configservobj1.Package_Technology__c = 'FCPBGA';
        configservobj1.Package_IO__c = '120';
        configservobj1.Body_Length__c = '15';
        configservobj1.Body_Width__c = '15';
        configservobj1.Subst_Layer__c = '121R';
        configservobj1.Subst_IO_Pitch__c = '15';
        configservobj1.Subst_Material__c = 'TBD';
        configservobj1.Wire_Material_for_WB__c = 'TBD';
        configservobj1.Capacitor_Type__c = 'DLA 50*50';
        configservobj1.Capacitor_Qty__c= 15;
        configservobj1.Package_IO_Pitch__c = '15';
        configservobj1.Encapsulation__c = 'Vendor';
        configservobj1.Line_Width__c = '0';
        
        configservobj1.Module_Test_Location__c = 'Fab 8';
        configservobj1.Module_Test_Platform__c = 'TOB';
        configservobj1.Module_Test_Time_Method__c = 'User Defined GTT/Chip';
        configservobj1.Module_User_Defined_Time__c = 10;
        configservobj1.Module_Number_of_DUTS__c = '8';
        configservobj1.Module_Test_Yield_Method__c = 'Custom';
        
        
        
        
        configservobj1.Method__c = 'Custom';
        insert configservobj1;
        Config_Post_Fab_Service_Detail__c cfdetail = new Config_Post_Fab_Service_Detail__c();
        cfdetail.Method__c = 'Circuit';      
        cfdetail.Circuit_Type__c ='CORES';
        cfdetail.Count__c = 10 ; 
        cfdetail.Circuit_Group__c = 'CORES';
        cfdetail.Config_Post_Fab_Service__c =configservobj1.id ;
          cfdetail.Bond_Assembly_Cost_by_Time_Period__c = 100;
        cfdetail.Bond_Assembly_Yield_by_Time_Period__c = 100;
        cfdetail.Burn_in_Board_Cost__c = 100;
        cfdetail.Burn_in_duration__c = 100;
        cfdetail.Circuit_Group__c = 'CORES';
        cfdetail.Circuit_Type__c = 'CORES';
        cfdetail.CKT_Unit__c = 'DRA';
        cfdetail.Count__c = 100;
        cfdetail.Method__c = 'Circuit';
        cfdetail.Quarter__c = 'Q1';
        cfdetail.Subst_Cost_by_Time_Period__c = 100;
        cfdetail.User_Defined_Time_MCM__c = 100;
        cfdetail.User_Defined_Yield_BI__c = 100;
        cfdetail.User_Defined_Yield_MCM__c = 100;
        cfdetail.User_Defined_Yield_Module__c = 100;
        
        
        Map <String,Schema.RecordTypeInfo> recordTypeMap = Config_Post_Fab_Service_Detail__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        if(recordTypeMap.containsKey('MCM user defined yield')) {
         cfdetail.RecordTypeId= recordTypeMap.get('MCM user defined yield').getRecordTypeId();
        }
        insert cfdetail;
        
        list<PCM_Yield__c> lstPCMYield = new list<PCM_Yield__c>();
        PCM_Yield__c yield = new PCM_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('FEOL').RecordTypeId,year__c = String.valueOf(date.today().year()),Catalog_ID__c='PCM215',Version__c='1',PT_Number__c= 'PT003612',Fab__c='FAB 2',bonding__c='C4',Solder_Type__c='By Customer',Solder__c='By Customer',
                                               BLM_Size_Type__c='By Customer',Minimum_C4_Pitch__c='By Customer');
        lstPCMYield.add(yield);
        PCM_Yield__c yield1 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('BEOL PRE').RecordTypeId,year__c = String.valueOf(date.today().year()),Catalog_ID__c='PCM215',Version__c='1',PT_Number__c= 'PT003612',Fab__c='FAB 2',
                                               bonding__c='C4',Solder_Type__c='By Customer',Solder__c='By Customer',
                                               BLM_Size_Type__c='By Customer',Minimum_C4_Pitch__c='By Customer');
        lstPCMYield.add(yield1);
        PCM_Yield__c yield2 = new PCM_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('KERF X').RecordTypeId,PROD_INT__c=0.01,PROD_KERF__c=0.01,
                                              Chip_LO__c=0,Chip_HI__c=999,PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                              Relgrade__c=5);
        lstPCMYield.add(yield2);
        PCM_Yield__c yield3 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('KERF Y').RecordTypeId,PROD_INT__c=0.01,PROD_KERF__c=0.01,
                                              Chip_LO__c=0,Chip_HI__c=999,PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                              Relgrade__c=5);
        lstPCMYield.add(yield3);
        PCM_Yield__c yield4 = new PCM_Yield__c(RecordTypeId =Schema.SObjectType.PCM_Yield__c.RecordTypeInfosByName.get('Tech Info').RecordTypeId,
                                              Exclusion_Zone__c=3,PT_Number__c='PT003612',Wafer_Size__c=200,Catalog_ID__c='PCM215',Version__c='1',Fab__c='Fab 9',
                                              Relgrade__c=5);
        lstPCMYield.add(yield4);
        insert lstPCMYield;
               
     ApexPages.currentPage().getParameters().put('retId',quoteobj.id);
       
        CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
        obj.ConfigPSTFabServ = configservobj1;
        obj.PCMYieldObj = lstPCMYield;
        obj.PCMYieldObj1= lstPCMYield;
        obj.ConfigPostFabServiceDetail = cfdetail;
        list<CPQConfigPostFabServices.wrapperlist> lstwrap = new list<CPQConfigPostFabServices.wrapperlist>();
        CPQConfigPostFabServices.wrapperlist wl = new CPQConfigPostFabServices.wrapperlist();
        wl.volume=5.5;
        wl.qrt = 'test';
        lstwrap.add(wl);
        obj.listwrapperSCCost = lstwrap;
        obj.listwrapperModuleBuild2 =lstwrap;
        obj.listwrapperSCCost = lstwrap;
        obj.listwrapperModuleBuild = lstwrap;
        obj.listwrapperModuleBuild3 =lstwrap;
        obj.listwrapperSCCost = lstwrap;
        obj.listwrapperModule = lstwrap;
        obj.listwrapperBurnInUser = lstwrap;
        obj.listwrapperMCMUser = lstwrap;
        obj.listwrapperBurnIn = lstwrap;
        try{
        obj.savedDetails();
        }catch(exception ex){}
        //--
       
        
        
        test.stopTest();
    }  
    }
    
    /*
    static testmethod void CPQConfigPostFabServices_test_method4(){
         
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        
    Id oppid = MCMDataUtilTest.createOpp(acctId);
    
     Opportunity op = [Select id, Deliverable_Part_Type__c from Opportunity where id = : oppid];
    op.Deliverable_Part_Type__c = 'MCM';
    update op;
   
    
    
    
    Id OppyProg = MCMDataUtilTest.createOppProg(acctId,oppid);
    Device__c device = MCMDataUtilTest.createGoodDevice(acctId,OppyProg); 
    Device__c device1 = [select id,Fab__c from Device__c limit 1];
    device1.Fab__c = 'FAB 8';
    database.update(device1);
    
    User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
         test.startTest();  
        NPCCopyConfigurationController.InsideNPCCopyConfig = true;
        NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
        NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
        NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
    
        Apttus_Proposal__Proposal__c quoteobj = new Apttus_Proposal__Proposal__c();
        quoteobj.Approved_by_Packaging_Team__c = true;
        quoteobj.Apttus_Proposal__Opportunity__c = oppid;
        quoteobj.Device__c = device1.id;
        quoteobj.Apttus_Proposal__Account__c = acctId;     
        quoteobj.Relgrade__c = '6.00';       
        insert quoteobj;
        test.stopTest(); 
        
        Apttus_Config2__ProductConfiguration__c   prodconfig = new Apttus_Config2__ProductConfiguration__c();
        prodconfig.Apttus_QPConfig__Proposald__c = quoteobj.id;
      //  insert prodconfig;
    
        Apttus_Config2__LineItem__c lineitem = new Apttus_Config2__LineItem__c();
        lineitem.Apttus_Config2__ConfigurationId__c = prodconfig.id;
        lineitem.Apttus_Config2__LineType__c ='Product/Service';
        lineitem.Apttus_Config2__ItemSequence__c =1 ; 
        lineitem.Apttus_Config2__LineNumber__c = 12345;
        //insert lineitem;  
    
        Apttus_Config2__ProductAttributeValue__c attributevalue = new Apttus_Config2__ProductAttributeValue__c();
        attributevalue.Die_Size_X_mm__c = 10;
        attributevalue.Die_Size_X_mm__c = 20;
        attributevalue.APTPS_ProcessTechnology__c = 'CSOI7RF';       
        //insert attributevalue;
    
        Config_Post_Fab_Services__c configservobj = new Config_Post_Fab_Services__c();
        configservobj.Configuration__c = quoteobj.id;
        configservobj.Method__c = 'Circuit';
        //insert configservobj;
               
        Config_Quarterly_Volume__c qvol =  new Config_Quarterly_Volume__c();
        qvol.Quote_Proposal__c = quoteobj.id;
        qvol.Q1_Volume__c =100;
        qvol.Q2_Volume__c=100;
        qvol.Q3_Volume__c=200;
        qvol.Q4_Volume__c=500;
        qvol.Year__c = 2016;
        insert qvol;
        
        PFile_Data__c pfiledata = new PFile_Data__c();
        pfiledata.PF_Stat__c = '100';
        pfiledata.PF_Desc__c = '100';
        pfiledata.Revision__c = 10 ;
        pfiledata.PF_Number__c =100 ;
        pfiledata.Configuration__c = quoteobj.id;
        insert pfiledata;
        
        PFile_Yield__c  py = new PFile_Yield__c();
        py.PFile__c = pfiledata.id;
        py.Circuit_Group__c ='IO' ;
        py.Circuit_Type__c ='IOS' ;
        py.Circuit_Unit__c ='Kcount' ;
        py.Count__c = 10 ;
        insert py;
       
        Id devRecordTypeId3 = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
     
         
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
            
        Config_Post_Fab_Service_Detail__c cfdetail = new Config_Post_Fab_Service_Detail__c();
        cfdetail.Method__c = 'Circuit';    
        cfdetail.Circuit_Type__c ='CORES';
        cfdetail.Count__c = 10 ; 
        cfdetail.Circuit_Group__c = 'CORES';
        cfdetail.recordtypeid = devRecordTypeId3;
        
//        ApexPages.currentPage().getParameters().put('id',prodconfig.id);   
        Config_Post_Fab_Services__c configservobj1 = new Config_Post_Fab_Services__c();
        configservobj1.Configuration__c = quoteobj.id;
        configservobj1.Method__c = 'Circuit';
        configservobj1.Capacitor_Qty__c = 1000;
        configservobj1.Number_of_Socket_Per_Boards__c = 1000;
        configservobj1.Test_Time_Method__c = 'Custom';
        configservobj1.PF_Stat__c= '100';
        configservobj1.PF_Number__c = '100';
        configservobj1.Revision__c = '10';
        configservobj1.PF_Desc__c = '100';
                   
        configservobj1.Module_User_Defined_Time__c = 10;
        configservobj1.MCM_User_Defined_Time__c    = 10;
        configservobj1.Bonding__c = 'C4';
        configservobj1.Solder_Type__c = 'By Customer';
        configservobj1.Solder__c = 'By Customer';
        configservobj1.BLM_Size_Type__c = 'By Customer';
        configservobj1.Minimum_C4_Pitch__c = 'By Customer';
        configservobj1.Fab__c ='Fab 1';
        configservobj1.Minimum_Kerf__c ='No';
        configservobj1.Kerf_X__c =10;
        configservobj1.Kerf_Y__c =10;
        
        configservobj1.Circuit_Limited_Yield_CLY__c = 1;
        configservobj1.Design_for_Profit_DFP__c = 1;
        configservobj1.Test_Location__c = 'Fab 8';    
        configservobj1.Test_Time_Method__c = 'User Defined GTT/Chip';
        configservobj1.User_Defined_Time__c = 10;
        configservobj1.Number_of_DUTS__c = '8';
        
        configservobj1.Package_Tech_Method__c = 'GF';
        configservobj1.Package_Technology__c = 'FCPBGA';
        configservobj1.Package_IO__c = '120';
        configservobj1.Body_Length__c = '15';
        configservobj1.Body_Width__c = '15';
        configservobj1.Subst_Layer__c = '121R';
        configservobj1.Subst_IO_Pitch__c = '15';
        configservobj1.Subst_Material__c = 'TBD';
        configservobj1.Wire_Material_for_WB__c = 'TBD';
        configservobj1.Capacitor_Type__c = 'DLA 50*50';
        configservobj1.Capacitor_Qty__c= 15;
        configservobj1.Package_IO_Pitch__c = '15';
        configservobj1.Encapsulation__c = 'Vendor';
        configservobj1.Line_Width__c = '0';
        
        configservobj1.Module_Test_Location__c = 'Fab 8';
        configservobj1.Module_Test_Platform__c = 'TOB';
        configservobj1.Module_Test_Time_Method__c = 'User Defined GTT/Chip';
        configservobj1.Module_User_Defined_Time__c = 10;
        configservobj1.Module_Number_of_DUTS__c = '8';
        configservobj1.Module_Test_Yield_Method__c = 'Custom';
                                       
        insert configservobj1;
        cfdetail.Config_Post_Fab_Service__c =configservobj1.id ;
        cfdetail.Bond_Assembly_Cost_by_Time_Period__c = 100;
        cfdetail.Bond_Assembly_Yield_by_Time_Period__c = 100;
        cfdetail.Burn_in_Board_Cost__c = 100;
        cfdetail.Burn_in_duration__c = 100;
        cfdetail.Circuit_Group__c = 'CORES';
        cfdetail.Circuit_Type__c = 'CORES';
        cfdetail.CKT_Unit__c = 'DRA';
        cfdetail.Count__c = 100;
        cfdetail.Method__c = 'Circuit';
        cfdetail.Quarter__c = 'Q1';
        cfdetail.Subst_Cost_by_Time_Period__c = 100;
        cfdetail.User_Defined_Time_MCM__c = 100;
        cfdetail.User_Defined_Yield_BI__c = 100;
        cfdetail.User_Defined_Yield_MCM__c = 100;
        cfdetail.User_Defined_Yield_Module__c = 100;
        
        
        Map <String,Schema.RecordTypeInfo> recordTypeMap = Config_Post_Fab_Service_Detail__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        if(recordTypeMap.containsKey('MCM user defined yield')) {
         cfdetail.RecordTypeId= recordTypeMap.get('MCM user defined yield').getRecordTypeId();
        }
        
        insert cfdetail;
               
           NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        ApexPages.currentPage().getParameters().put('retId',quoteobj.id);
        
        CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
        obj.pfyields = [Select Circuit_Group__c,Circuit_Type__c,Redundancy__c,Circuit_Unit__c,Count__c,PFile__c,QTR1__c,QTR2__c,QTR3__c,QTR4__c,QTR5__c,QTR6__c,QTR7__c,QTR8__c,QTR9__c,QTR10__c,
                                                 QTR11__c,QTR12__c,QTR13__c,QTR14__c,QTR15__c,QTR16__c,QTR17__c,QTR18__c,QTR19__c,QTR20__c,QTR21__c,QTR22__c,QTR23__c,QTR24__c,Yield_Type__c From PFile_Yield__c] ;
        obj.fileData ='test';
        obj.isBIBCDetails = true;
        obj.items ='test'; 
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'CORES';
        Pagereference p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'IO';
        p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'MIXED';
        p = obj.CreateWTY();
        
        Pagereference p1 = obj.pageActionInitialization();
        Config_Post_Fab_Service_Detail__c det = new Config_Post_Fab_Service_Detail__c();
        det.RecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
        det.Config_Post_Fab_Service__c = obj.ConfigPSTFabServ.Id;
        det.Circuit_Group__c = 'CORES';
        det.Circuit_Type__c = 'CORES';
        det.CKT_Unit__c = '1';
        det.Count__c = 1;
        det.Available_Redundancy__c = null;
        insert det;
        Pagereference p2 = obj.reviewSelection();
        
        obj.ConfigPSTFabServ.Package_Tech_Method__c = 'Custom';
        p2 = obj.reviewSelection();
        
        PCM_Cost__c cst = new PCM_Cost__c();
        cst.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        cst.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        cst.solder__c = obj.ConfigPSTFabServ.solder__c;
        cst.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        cst.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        cst.wafer_size__c = 200;
        cst.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert cst;
        
        PCM_Yield__c yld = new PCM_Yield__c();
        yld.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        yld.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        yld.solder__c = obj.ConfigPSTFabServ.solder__c;
        yld.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        yld.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        yld.wafer_size__c = 200;
        yld.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert yld; 
        
        CPQConfigPostFabServices.wrapperlist wr = new CPQConfigPostFabServices.wrapperlist();
        wr.volume= 100;
        obj.listwrapperSCCost.clear();
        obj.listwrapperSCCost.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild.clear();
        obj.listwrapperModuleBuild.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperModuleBuild2.clear();
        obj.listwrapperModuleBuild2.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild3.clear();
        obj.listwrapperModuleBuild3.add(wr);
     //   p2 = obj.reviewSelection();
        
        obj.listwrapperModule.clear();
        obj.listwrapperModule.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnInUser.clear();
        obj.listwrapperBurnInUser.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperMCMUser.clear();
        obj.listwrapperMCMUser.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnIn.clear();
        obj.listwrapperBurnIn.add(wr);
        try {
        p2 = obj.reviewSelection();
        }catch(exception e){}
        
        try {
        obj.modifiedModBuildVal = 'Package Tech';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Package IO';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Body Length';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst IO Pitch';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Layer';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Material';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {        
        List<SelectOption> options = obj.getCapacitorType();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getEncapsulation();
        }catch(exception e){}
        
        
        Pagereference p3 = obj.UserModuleDisplay();
        Pagereference p4 = obj.WTTDisplay();
        Pagereference p5 = obj.renderWTY();
        Pagereference p6 = obj.UserWaferDisplay();
        Pagereference p7 = obj.UserDefinedYieldDisplay();
        Pagereference p8 = obj.UserModuleDefinedDisplay();
        Pagereference p9 = obj.UserModuleTimeDisplay();
        Pagereference p10 = obj.populatekerf();
        Pagereference p11 = obj.UserDefinedDisplay();
           obj.createQuarterlyVolumeList();
        obj.getPFStatvalues();
        obj.getPfvalues();
        obj.getPfdescrs();
        obj.getPfrevisions();
        obj.generateList(4);
     
        Pagereference p13 = obj.createPFdata();
        Pagereference p12 = obj.getpfchilds();

        obj.md();
             
        
    }
    }
    */
    
    
   /*   
    static testmethod void CPQConfigPostFabServices_test_method5(){
         
              NPCCopyConfigurationController.InsideNPCCopyConfig = true;
            NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
            NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
            NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        
    Id oppid = MCMDataUtilTest.createOpp(acctId);
    
     Opportunity op = [Select id, Deliverable_Part_Type__c from Opportunity where id = : oppid];
    op.Deliverable_Part_Type__c = 'MCM';
    update op;
   
    
    
    
    Id OppyProg = MCMDataUtilTest.createOppProg(acctId,oppid);
    Device__c device = MCMDataUtilTest.createGoodDevice(acctId,OppyProg); 
    Device__c device1 = [select id,Fab__c from Device__c limit 1];
    device1.Fab__c = 'FAB 8';
    database.update(device1);
    
    User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
         test.startTest();  
        NPCCopyConfigurationController.InsideNPCCopyConfig = true;
        NPCCopyConfigurationController.PopulateFieldBeforeUpdate = true;
        NPCCopyConfigurationController.PopulateFieldAfterUpdate = true;
        NPCCopyConfigurationController.ShareProposalAfterUpdate = true; 
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
    
        CPQConfigPostFabServices obj = new CPQConfigPostFabServices();
        obj.pfyields = [Select Circuit_Group__c,Circuit_Type__c,Redundancy__c,Circuit_Unit__c,Count__c,PFile__c,QTR1__c,QTR2__c,QTR3__c,QTR4__c,QTR5__c,QTR6__c,QTR7__c,QTR8__c,QTR9__c,QTR10__c,
                                                 QTR11__c,QTR12__c,QTR13__c,QTR14__c,QTR15__c,QTR16__c,QTR17__c,QTR18__c,QTR19__c,QTR20__c,QTR21__c,QTR22__c,QTR23__c,QTR24__c,Yield_Type__c From PFile_Yield__c] ;
        obj.fileData ='test';
        obj.isBIBCDetails = true;
        obj.items ='test'; 
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'CORES';
        Pagereference p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'IO';
        p = obj.CreateWTY();
        
        obj.ConfigPSTFabServ.Circuit_Limited_Yield_CLY__c = 1;   
        obj.ConfigPSTFabServ.Design_for_Profit_DFP__c = 1;
        obj.ConfigPostFabServiceDetail.Count__c = 1;
        obj.ConfigPostFabServiceDetail.Circuit_Type__c = '1';
        obj.ConfigPostFabServiceDetail.Circuit_Group__c = 'MIXED';
        p = obj.CreateWTY();
        
        Pagereference p1 = obj.pageActionInitialization();
        Config_Post_Fab_Service_Detail__c det = new Config_Post_Fab_Service_Detail__c();
        det.RecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.getRecordTypeInfosByName().get('Wafer Test Pass').getRecordTypeId();
        det.Config_Post_Fab_Service__c = obj.ConfigPSTFabServ.Id;
        det.Circuit_Group__c = 'CORES';
        det.Circuit_Type__c = 'CORES';
        det.CKT_Unit__c = '1';
        det.Count__c = 1;
        det.Available_Redundancy__c = null;
        insert det;
        Pagereference p2 = obj.reviewSelection();
        
        obj.ConfigPSTFabServ.Package_Tech_Method__c = 'Custom';
        p2 = obj.reviewSelection();
        
        PCM_Cost__c cst = new PCM_Cost__c();
        cst.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        cst.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        cst.solder__c = obj.ConfigPSTFabServ.solder__c;
        cst.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        cst.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        cst.wafer_size__c = 200;
        cst.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert cst;
        
        PCM_Yield__c yld = new PCM_Yield__c();
        yld.bonding__c = obj.ConfigPSTFabServ.bonding__c;
        yld.solder_type__c = obj.ConfigPSTFabServ.solder_type__c;
        yld.solder__c = obj.ConfigPSTFabServ.solder__c;
        yld.BLM_size_type__c = obj.ConfigPSTFabServ.BLM_size_type__c;
        yld.minimum_C4_pitch__c = obj.ConfigPSTFabServ.minimum_C4_pitch__c;
        yld.wafer_size__c = 200;
        yld.fab__c = obj.ConfigPSTFabServ.fab__c;
        insert yld; 
        
        CPQConfigPostFabServices.wrapperlist wr = new CPQConfigPostFabServices.wrapperlist();
        wr.volume= 100;
        obj.listwrapperSCCost.clear();
        obj.listwrapperSCCost.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild.clear();
        obj.listwrapperModuleBuild.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperModuleBuild2.clear();
        obj.listwrapperModuleBuild2.add(wr);
      //  p2 = obj.reviewSelection();
        
        obj.listwrapperModuleBuild3.clear();
        obj.listwrapperModuleBuild3.add(wr);
     //   p2 = obj.reviewSelection();
        
        obj.listwrapperModule.clear();
        obj.listwrapperModule.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnInUser.clear();
        obj.listwrapperBurnInUser.add(wr);
      //  p2 = obj.reviewSelection();
        
         obj.listwrapperMCMUser.clear();
        obj.listwrapperMCMUser.add(wr);
       // p2 = obj.reviewSelection();
        
         obj.listwrapperBurnIn.clear();
        obj.listwrapperBurnIn.add(wr);
        try {
        p2 = obj.reviewSelection();
        }catch(exception e){}
        
        try {
        obj.modifiedModBuildVal = 'Package Tech';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Package IO';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Body Length';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst IO Pitch';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Layer';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {
        obj.modifiedModBuildVal = 'Subst Material';
        p2 = obj.refreshModuleBuild();
        }catch(exception e){}
        try {        
        List<SelectOption> options = obj.getCapacitorType();
        }catch(exception e){}
         try {        
        List<SelectOption> options = obj.getEncapsulation();
        }catch(exception e){}
        
        
        Pagereference p3 = obj.UserModuleDisplay();
        Pagereference p4 = obj.WTTDisplay();
        Pagereference p5 = obj.renderWTY();
        Pagereference p6 = obj.UserWaferDisplay();
        Pagereference p7 = obj.UserDefinedYieldDisplay();
        Pagereference p8 = obj.UserModuleDefinedDisplay();
        Pagereference p9 = obj.UserModuleTimeDisplay();
        Pagereference p10 = obj.populatekerf();
        Pagereference p11 = obj.UserDefinedDisplay();
           obj.createQuarterlyVolumeList();
        obj.getPFStatvalues();
        obj.getPfvalues();
        obj.getPfdescrs();
        obj.getPfrevisions();
        obj.generateList(4);
     
        Pagereference p13 = obj.createPFdata();
        Pagereference p12 = obj.getpfchilds();

        obj.md();
             
        test.stopTest(); 
    }
    }
    */
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
    
     public static Device__c createGoodDevice(Id acctId,Id opptyProgramId) {
        String MSTId = createMaskSetTtitle('MSTTRT1');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c', acctId);
        fieldValueMap.put('Name', 'MCMGoodDevice1');
        fieldValueMap.put('Opportunity_Program__c', opptyProgramId );
        fieldValueMap.put('Fab__c', 'FAB 9');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');
        fieldValueMap.put('Market_Segment__c', 'Automotive');
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');
        fieldValueMap.put('End_Customer__c', 'Test Customer');
        fieldValueMap.put('Device_Sourcing__c', '1st Source');
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');
        fieldValueMap.put('Siebel_Device_ID__c', '1234567889');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c', 'ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MSTTRT');
        fieldValueMap.put('CRMDID__c', 'CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c', date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');
        fieldValueMap.put('Device_Type__c', 'Base');
        fieldValueMap.put('End_Application__c', 'Body');
        fieldValueMap.put('Fab__c','FAB 8');
        return DeviceDataFactory.createDevice(fieldValueMap);                      
    }
    
   
    public static Id createMaskSetTtitle(String name){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = name;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
}