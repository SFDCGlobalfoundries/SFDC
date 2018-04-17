/*
    Author: Ariz Solito
    Description: This is the test class for GenerateCost class
    History: 
        ASolito     01092017    - Code creation.                                   
*/

@isTest
private class GenerateCostTest {

    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
        
        PCM_Administration__c pcm = new PCM_Administration__c(Name='CURRENT_SETTING',Catalog_ID__c='PCM215',Version_ID__c='1');
        insert pcm; 
                
        createPCMCosts();
        createPCMYield();
        createPCMTestYield();
        createPCMTime();                                                                              
    }
    
    static Id createAccount(){
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

        return AccountDataFactory.createAccount(fieldValueMap).id;
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
        fieldValueMap.put('Actual_Tapeout_Date__c',Date.newInstance(2017,1,2));
        fieldValueMap.put('Fab__c','FAB 9');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Device_Sourcing__c','First Source');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId); 
        
        return DeviceDataFactory.createDevice(fieldValueMap).id;                      
    }
            
    static Apttus_Proposal__Proposal__c createConfig(String acctId,String oppId, String devId) {
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Description__c = 'Test Proposal Description ...',
            Device__c = devId,                                                     
            Mask_Set_Long__c = 'SZ NW RX BF MT V1 M1 CA FT AM PC BP DE BN DF OP',
            Apttus_Proposal__Opportunity__c = oppId,
            Apttus_Proposal__Account__c = acctId,
            process_technology__c = 'PT003612',
            Actual_Tapeout_Date_FAB_9_and_FAB_10__c = Date.newInstance(2017,1,2),                                                     
            RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.RecordTypeInfosByName.get('Proposal from Device').recordTypeId,
            APTPS_Primary__c = true,
            relgrade__c='5',
            deliverable_part_type__c='Module',
            APTPS_Metal_Options__c = '5LM/DM (MA Dual Metal Last Metal)'
        );
        
        insert proposal;
        System.assertNotEquals(proposal.id, null,'Insertion of Proposal Failed.');
        return proposal;
    }
    
    static void createQuarterlyVolumes(String configId){
        Config_Quarterly_Volume__c conQ = new Config_Quarterly_Volume__c(
            Quote_Proposal__c=configId,
            Year__c=2017,
            Q1_Volume__c=1000           
        );
        insert conQ;    
    }
           
    static Id createPostFabService(String configId){
        Config_Post_Fab_Services__c configPfs = new Config_Post_Fab_Services__c(
            Bonding__c='C4',
            Solder_Type__c='By Customer',
            Solder__c='By Customer',
            BLM_Size_Type__c='By Customer',
            Minimum_C4_Pitch__c='By Customer',
            Fab__c='FAB 9',
            Kerf_X__c=.108,
            Kerf_Y__c=.088,
            Minimum_Kerf__c='Yes',
            Number_of_DUTS__c='1',
            Test_Location__c='FAB 9',
            Test_Platform__c='66XX_W',
            Test_Time_Method__c='GF Forecast',
            Circuit_Limited_Yield_CLY__c=1,
            Design_for_Profit_DFP__c=1,Method__c='Circuit',
            Reliability_Location__c='Fab 9',
            Reliability_Platform__c='HPB5',
            Number_of_Socket_Per_Boards__c=8,
            Burn_in_Stress_Yield_Method__c='GF',
            Module_Test_Time_Method__c='GF Forecast',
            Module_Number_of_DUTS__c='1',
            Module_Test_Location__c='FAB 9',
            module_test_platform__c='66XX_W',
            Module_User_Defined_Time__c=1,
            Module_Test_Yield_Method__c='Custom',
            Package_Technology__c='FCPBGA',
            Package_Tech_Method__c='GF',
            Subst_Material__c='TBD',
            Wire_Material_for_WB__c='TBD',
            Capacitor_Type__c='402-0.68 nF',
            Capacitor_Qty__c=0,MCM_Number_of_DUTS__c='1',
            Encapsulation__c='OPL Free 17*17',
            Line_Width__c='0',Package_IO__c='255',
            Body_Length__c='17',
            Body_Width__c='17',
            Subst_Layer__c='323R',
            Subst_IO_Pitch__c='3',
            Package_IO_Pitch__c='3',
            Configuration__c=configId
        );   
        
        insert configPfs;
        return configPfs.id;                                                       
    }    
        
    static void createPostFabServiceDetails(String postFabServiceId){
        Config_Post_Fab_Service_Detail__c postFabDetail = new Config_Post_Fab_Service_Detail__c(
            RecordTypeId = Schema.SObjectType.Config_Post_Fab_Service_Detail__c.RecordTypeInfosByName.get('Wafer Test Pass').RecordTypeId,
            Config_Post_Fab_Service__c = postFabServiceId,
            Circuit_Group__c = 'IO',
            Circuit_Type__c = 'IOS',
            Count__c = .25,                                                                            
            CKT_Unit__c = 'Kcount'
        );
        insert postFabDetail;   
    }  
    
    static void createPCMCosts(){                
        PCM_Cost__c c1 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module Test Hour').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            test_platform__c = '66XX_W'
        );
        
        PCM_Cost__c c1b = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module BI Hour').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            test_platform__c = 'HPB5'
        );
        
        PCM_Cost__c c2 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module Test SBT').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            package_technology__c = 'FCPBGA'
        );
        
        PCM_Cost__c c3 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Cost Sub REF').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            Package_Technology__c='FCPBGA',
            Body_Length__c='17',
            Body_Width__c='17',
            Subst_Layers__c='323R',
            Subst_IO_Pitch__c='3',
            Line_Width__c='0',
            Subst_Material__c='TBD',
            pn__c = '12'
        );
        
        PCM_Cost__c c4 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Cost Module BA REF').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            Package_Technology__c='FCPBGA',
            Body_Length__c='17',
            Body_Width__c='17',
            Package_IO_Pitch__c='3',
            package_IO_count__c ='255',
            layer_count__c ='323R',
            wire_bond_material__c ='TBD',
            pn__c = '13'
        );
        
        PCM_Cost__c c5 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('SUB FIN CC').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = '12'
        );
        
        PCM_Cost__c c6 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module BA ASM').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = '13'
        );
        
        PCM_Cost__c c7 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Cost LID REF').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            Encapsulation__c='OPL Free 17*17',
            pn__c = '14'
        );
        
        PCM_Cost__c c8 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Cost DECAP REF').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            Capacitor_Type__c='402-0.68 nF',
            pn__c = '15'
        );
        
        PCM_Cost__c c9 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module BA DCAPS ASM').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = '15'
        );
        
        PCM_Cost__c c10 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module BA LID ASM').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = '14'
        );
        
        PCM_Cost__c c11 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('SUB FIN CCVOL').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',            
            fab__c = 'FAB 9',
            Package_Technology__c='FCPBGA',
            pn__c = 'NA',
            volume_mult__c = .9,
            volume_lower__c = 0,
            volume_upper__c = 20000            
        );
        
        PCM_Cost__c c12 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Module BA CCVOL').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',            
            fab__c = 'FAB 9',
            pn__c = 'NA', 
            Package_Technology__c='FCPBGA',
            volume_mult__c = .9,
            volume_lower__c = 0,
            volume_upper__c = 20000            
        );
        
        PCM_Cost__c c13 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Wafer Test Hour').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c14 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Wafer Test GEN').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c15 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('DSP Dicing').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c16 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('DSP GroupB').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c17 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('DSP Picking').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA', 
            wafer_size__c = 200
        );
        
        PCM_Cost__c c18 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('DSP Factor').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA', 
            wafer_size__c = 200,
            pt_number__c = 'PT003612',
            pfactor__c = 0.18
        );
        
        PCM_Cost__c c19 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 2,
            pn__c = 'NA',
            constant_name__c = 'DICING_K',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c20 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 230,
            pn__c = 'NA', 
            constant_name__c = 'DICING_VAR',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c21 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 0.026,
            pn__c = 'NA', 
            constant_name__c = 'SORT_PCK_VAR',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c22 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 4.1,
            pn__c = 'NA',
            constant_name__c = 'SORT_PCK_K',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c23 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 0.00224,
            pn__c = 'NA', 
            constant_name__c = 'GROUP_B_VAR',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c24 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Rate Constants').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            constant_value__c = 0.171,
            pn__c = 'NA', 
            constant_name__c = 'GROUP_B_K',
            fab__c = 'FAB 9',
            wafer_size__c = 200
        );
        
        PCM_Cost__c c25 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Bonding').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            wafer_size__c = 200,
            pn__c = 'NA', 
            Bonding__c='C4',
            Solder_Type__c='By Customer',
            Solder__c='By Customer',
            BLM_Size_Type__c='By Customer',
            Minimum_C4_Pitch__c='By Customer'
        );
        
        PCM_Cost__c c26 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Allocation').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            wafer_size__c = 200,
            pn__c = 'NA', 
            business_unit__c = 'Module',
            product_type__c = 'ASIC',
            allocation__c = .9,
            allocation_name__c = 'AA'
        );
        
        PCM_Cost__c c27 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Raw Wafer').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA', 
            wafer_size__c = 200,
            pt_number__c = 'PT003612'
        );
        
        PCM_Cost__c c28 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Wafer Processing').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            wafer_size__c = 200,
            pn__c = 'NA', 
            pt_number__c = 'PT003612',
            layer_of_metal__c = 5
        );
        
        PCM_Cost__c c29 = new PCM_Cost__c(
            recordTypeId = Schema.SObjectType.PCM_Cost__c.RecordTypeInfosByName.get('Mask Layer').recordTypeId,
            Catalog_ID__c = 'PCM215',
            version__c = '1',
            quarter__c = 'Q1',
            year__c = '2017',
            cost__c = 100,
            fab__c = 'FAB 9',
            pn__c = 'NA', 
            wafer_size__c = 200,
            pt_number__c = 'PT003612',
            mask_layer__c = 'OP'
        );
        
        List<PCM_Cost__c> costs = new List<PCM_Cost__c>{c1,c1b,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,
                                                        c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29};
        
        insert costs;        
    } 
    
     static void createPCMYield(){
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
    }
    
    static void createPCMTestYield(){
        list<PCM_Test_Yield__c> lstPCMTestYield = new list<PCM_Test_Yield__c>();
        PCM_Test_Yield__c pty1 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('Foundry DD Curve').RecordTypeId,
                                                     PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',DD_Curve__c='SOI18F98');
        lstPCMTestYield.add(pty1);
        PCM_Test_Yield__c pty2 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('GRS').RecordTypeId,
                                                     Q6__c=.479, Q7__c=.479, Q8__c=.479, Q9__c=.479, Q10__c=.479, Q11__c=.479, Q12__c=.479, Q13__c=.479, Q14__c=.479, Q15__c=.479
                                                     , Q16__c=.479, Q17__c=.479, Q18__c=.479, Q19__c=.479, Q20__c=.479, Q21__c=.479, Q22__c=.479, Q23__c=.479, Q24__c=.479, Q25__c=.479
                                                     ,Q26__c=.479,Catalog_ID__c='PCM215',Version__c='1',Tech_DD__c='SOI18F98');
        lstPCMTestYield.add(pty2);
        PCM_Test_Yield__c pty3 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('Alpha').RecordTypeId,
                                                     Q1__c=.479, Q2__c=.479, Q3__c=.479, Q4__c=.479, Q5__c=.479,Q6__c=.479, Q7__c=.479, Q8__c=.479, Q9__c=.479, Q10__c=.479, Q11__c=.479, Q12__c=.479, Q13__c=.479, Q14__c=.479, Q15__c=.479
                                                     , Q16__c=.479, Q17__c=.479, Q18__c=.479, Q19__c=.479, Q20__c=.479, Q21__c=.479, Q22__c=.479, Q23__c=.479, Q24__c=.479,Start_Quarter__c='Q1', Start_Year__c='2016'
                                                     ,Catalog_ID__c='PCM215',Version__c='1',Tech_DD__c='SOI18F98');
        lstPCMTestYield.add(pty3);
        PCM_Test_Yield__c pty4 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('DD Curve').RecordTypeId,
                                                     Q1__c=.479, Q2__c=.479, Q3__c=.479, Q4__c=.479, Q5__c=.479,Q6__c=.479, Q7__c=.479, Q8__c=.479, Q9__c=.479, Q10__c=.479, Q11__c=.479, Q12__c=.479
                                                     , Q13__c=.479, Q14__c=.479, Q15__c=.479, Q16__c=.479, Q17__c=.479, Q18__c=.479, Q19__c=.479, Q20__c=.479,Start_Quarter__c='Q1', Start_Year__c='2016'
                                                     , Q21__c=.479, Q22__c=.479, Q23__c=.479, Q24__c=.479
                                                     ,Catalog_ID__c='PCM215',Version__c='1',Tech_DD__c='SOI18F98');
        lstPCMTestYield.add(pty4);
        PCM_Test_Yield__c pty5 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('Red').RecordTypeId,
                                                     Catalog_ID__c='PCM215',Version__c='1',red_fact__c=0.2, CKT_red__c='SRAM_W+BBK');
        lstPCMTestYield.add(pty5);
        PCM_Test_Yield__c pty6 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('CKT Fact').RecordTypeId,
                                                     Catalog_ID__c='PCM215',Version__c='1', Ckt_Group__c='CORES'
                                                     , Ckt_Type__c='PLL', Ckt_Faults__c=0.0, Avail_Red__c='NONE');
        lstPCMTestYield.add(pty6);
        PCM_Test_Yield__c pty7 = new PCM_Test_Yield__c(RecordTypeId = Schema.SObjectType.PCM_Test_Yield__c.RecordTypeInfosByName.get('LYH').RecordTypeId,
                                                     PT_Number__c='PT003612',Catalog_ID__c='PCM215',Version__c='1',Q1__c=.95, Q2__c=.95, Q3__c=.95, Q4__c=.95, 
                                                     Q5__c=.95, Q6__c=.95, Q7__c=.95, Q8__c=.95, Q9__c=.95, Q10__c=.95,Q11__c=.95, Q12__c=.95, Q13__c=.95, 
                                                     Q14__c=.95, Q15__c=.95, Q16__c=.95, Q17__c=.95, Q18__c=.95, Q19__c=.95,Q20__c=.95, Q21__c=.95, Q22__c=.95,
                                                     Q23__c=.95, Q24__c=.95,Q25__c=.95,Q26__c=.95, Start_Quarter__c='Q1', Start_Year__c='2016');
        lstPCMTestYield.add(pty7);
        
        insert lstPCMTestYield;
    }
    
    static void createPCMTime(){
        list<PCM_Time__c> ptList = new list<PCM_Time__c>();
        PCM_Time__c pt1 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='WAF_TST',Test_Section__c='io_shorts',
                                        Test_Pass__c='WFT',Driver__c='QTY_IO',Calc__c='EXPONENT');
        ptList.add(pt1);
        PCM_Time__c pt2 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='MOD_TST',Test_Section__c='io_shorts',
                                        Test_Pass__c='FMT_POS_25C',Driver__c='QTY_IO',Calc__c='EXPONENT');
        ptList.add(pt2);
        PCM_Time__c pt3 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='MOD_TST',Test_Section__c='io_relax',
                                        Test_Pass__c='FMT_POS_25C',Driver__c='QTY_IO',Calc__c='LINEAR');
        ptList.add(pt3);
        PCM_Time__c pt4 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('Time Data').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',PT_Number__c='PT003612',Relgrade__c='5',
                                        Test_Section__c='io_relax',Workcenter__c='DEFAULT',
                                        Test_Pass__c='WFT',Time_Comp__c='io_shorts_var',Data__c=.123);
        ptList.add(pt4);
        PCM_Time__c pt5 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('Time Data').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',PT_Number__c='PT003612',Relgrade__c='5',
                                        Test_Section__c='io_relax',Workcenter__c='DEFAULT',
                                        Test_Pass__c='FMT_POS_25C',Time_Comp__c='io_shorts_var',Data__c=.123);
        ptList.add(pt5);
        PCM_Time__c pt6 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='WAF_TST',Test_Section__c='io_relax',
                                        Test_Pass__c='WFT',Driver__c='QTY_IO',Calc__c='LINEAR');
        ptList.add(pt6);
        PCM_Time__c pt7 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='WAF_TST',Test_Section__c='io_shorts',
                                        Test_Pass__c='WFT',Driver__c='QTY_IO',Calc__c='AUTO');
        ptList.add(pt7);
        PCM_Time__c pt8 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('ATT Constants').RecordTypeId,
                                        Catalog_ID__c='PCM215',Version__c='1',Stage__c='MOD_TST',Test_Section__c='io_relax',
                                        Test_Pass__c='FMT_POS_25C',Driver__c='QTY_IO',Calc__c='AUTO');
        ptList.add(pt8);
        PCM_Time__c pt9 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='LOAD_FACTOR',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt9);
        PCM_Time__c pt10 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='RON_RETEST_PERCENT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt10);
        PCM_Time__c pt11 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='MACH_STOP_DELAY',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt11);
        PCM_Time__c pt12 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='RON_TOUCHDOWN_CONSTANT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt12);
        PCM_Time__c pt13 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='CLEAN_TIME',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt13);
        PCM_Time__c pt14 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='SETUP_TIME_PER_LOT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt14);
        PCM_Time__c pt15 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='CLEAN_TIME_FREQ',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt15);
        PCM_Time__c pt16 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('Lot Size').RecordTypeId,
                                         Stage__c='WAF_TST',Wafer_Size__c=200,Year__c=String.valueOf(date.today().year()),Package_Tech__c='NA',Lot_Size__c='350');
        ptList.add(pt16);
        PCM_Time__c pt17 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('WorkCenter').RecordTypeId,
                                         Stage__c='WAF_TST',Workcenter__c='66XX_W',Location__c='FAB 9',Catalog_ID__c='PCM215',Version__c='1',
                                         Contingency_Percent__c=.1,Handlers_WS__c=.05,Overhead_Time__c=.1,Characterization_Percent__c=.1,
                                         Planned_Maint__c=.1,Unplanned_Maint__c=.1,MFG_Planned_Maint__c=.1,MFG_Unplanned_Maint__c=.1,
                                         Calibration__c=.1,TAE_ME__c=.1,IS_DP__c=.1);
        ptList.add(pt17);
        PCM_Time__c pt18 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('Handler FEH').RecordTypeId,
                                         Stage__c='WAF_TST',Workcenter__c='66XX_W',Location__c='FAB 9',Catalog_ID__c='PCM215',Version__c='1',
                                         Planned_Maint__c=.1,Unplanned_Maint__c=.1,MFG_Planned_Maint__c=.1,MFG_Unplanned_Maint__c=.1,Index_Time__c=.01);
        ptList.add(pt18);
        PCM_Time__c pt19 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('StepTime').RecordTypeId,
                                         Stage__c='WAF_TST',Workcenter__c='66XX_W',Location__c='FAB 9',Catalog_ID__c='PCM215',Version__c='1',
                                         Prober_Steptime__c=.01);
        ptList.add(pt19);
        PCM_Time__c pt20 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('WorkCenter').RecordTypeId,
                                         Stage__c='MOD_TST',Workcenter__c='66XX_W',Location__c='FAB 9',Catalog_ID__c='PCM215',Version__c='1',
                                         Contingency_Percent__c=.1,Handlers_WS__c=.05,Overhead_Time__c=.1,Characterization_Percent__c=.1,
                                         Planned_Maint__c=.1,Unplanned_Maint__c=.1,MFG_Planned_Maint__c=.1,MFG_Unplanned_Maint__c=.1,
                                         Calibration__c=.1,TAE_ME__c=.1,IS_DP__c=.1);
        ptList.add(pt20);
        PCM_Time__c pt21 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('Handler FEH').RecordTypeId,
                                         Stage__c='MOD_TST',Workcenter__c='66XX_W',Location__c='FAB 9',Catalog_ID__c='PCM215',Version__c='1',
                                         Planned_Maint__c=.1,Unplanned_Maint__c=.1,MFG_Planned_Maint__c=.1,MFG_Unplanned_Maint__c=.1,Index_Time__c=.01);
        ptList.add(pt21);
        PCM_Time__c pt22 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='GROUP_A_PERCENT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt22);
        PCM_Time__c pt23 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='RETEST_PER_CENT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt23);
        PCM_Time__c pt24 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='OVEN_UNLOAD_TIME',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt24);
        PCM_Time__c pt25 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='BIB_PRELOAD',Catalog_ID__c='PCM215',Version__c='1',Value__c='Y');
        ptList.add(pt25);
        PCM_Time__c pt26 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='OVEN_SETUP',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt26);
        PCM_Time__c pt27 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='BIB_LOAD_UNLOAD_TM',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt27);
        PCM_Time__c pt28 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('APS Constants').RecordTypeId,
                                         Constant_Name__c='REBURN_PERCENT',Catalog_ID__c='PCM215',Version__c='1',Value__c='0.01');
        ptList.add(pt28);
        PCM_Time__c pt29 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('BI Usage').RecordTypeId,
                                         Usage_Fact__c='SOCKET_BIB',Catalog_ID__c='PCM215',Version__c='1',BI_OVEN__c='HPB5',
                                         Avail__c=16,PCT__c=1);
        ptList.add(pt29);
        PCM_Time__c pt30 = new PCM_Time__c(RecordTypeId = Schema.SObjectType.PCM_Time__c.RecordTypeInfosByName.get('BI Usage').RecordTypeId,
                                         Usage_Fact__c='SLOT_PER_OVEN',Catalog_ID__c='PCM215',Version__c='1',BI_OVEN__c='HPB5',
                                         Avail__c=16,PCT__c=1);
        ptList.add(pt30);
        insert ptList;        
    }
    
    static testMethod void testCostCalculations(){ 
                           
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            String acctId = createAccount();
            String opptyId = createOpp(acctId);
            String opptyProgId = createOppProg(acctId,opptyId);
            String devId = createDevice(acctId,opptyId,opptyProgId);        
            
            test.startTest();        
            Apttus_Proposal__Proposal__c prop = createConfig(acctId,opptyId,devId);        
            createQuarterlyVolumes(prop.id);        
            String postFabServiceId = createPostFabService(prop.id);
            createPostFabServiceDetails(postFabServiceId);  
            
            //test the report generation
            GenerateYieldAndCost.generate(prop.id);                               
            test.stopTest();
        }
    }                      
}