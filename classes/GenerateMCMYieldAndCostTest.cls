@isTest(SeeAllData=false)
private class GenerateMCMYieldAndCostTest {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();

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
        fieldValueMap.put('deliverable_part_type__c','Module');
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
    
    static testMethod void MCMTriggerTest1() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = GenerateMCMYieldAndCostTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = GenerateMCMYieldAndCostTest.createOppProg(acctId, opptyId);
         User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
      
       
            // Create Device
             Device__c device = MCMDataUtilTest.createGoodDevice(acctId,opptyProgramId);           

        List<MCM_Yields__c> m = new List<MCM_Yields__c>();
        PCM_MCM_DEtail__c a = new PCM_MCM_DEtail__c();
        a.Device__c = device.id;
         a.Fab__c ='FAB 9';
         a.Test_Platform__c = '66XX512_M';
      a.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = date.newInstance(2017,1,1);
        a.Burn_In_Platform__c='ABES_IV';
        a.Number_of_Sockets_Per_Boards__c=3;
        a.No_of_DUTS__c='16';
        
        insert a;
        test.startTest();
            ApexPages.CurrentPage().getParameters().put('Id',a.Id);
        MCMController mcmCont = new MCMController();
        
        list<mcm_yields__c>  mYld = new list<mcm_yields__c>();
        for (mcm_yields__c c :[select id,q1__c,q2__c,q3__c,q4__c,q5__c,q6__c,q7__c,q8__c,q9__c,q10__c,q11__c,q12__c,q13__c,q14__c,q15__c,q16__c,q17__c,q18__c,q19__c,q20__c,q21__c,q22__c,q23__c,q24__c from mcm_yields__c where mcm__c =:a.id ]){
            c.q1__c = 1;
            c.q2__c = 1;
            c.q3__c = 1;
            c.q4__c = 1;
             c.q5__c=c.q6__c=c.q7__c=c.q8__c=c.q9__c=c.q10__c=c.q11__c=c.q12__c=c.q13__c=c.q14__c=c.q15__c=c.q16__c=c.q17__c=c.q18__c=c.q19__c=c.q20__c=c.q21__c=c.q22__c=c.q23__c=c.q24__c=1;
            mYld.add(c);
        }
        upsert mYld;
        list<MCM_BurnIn_Duration__c>  mBID = new   list<MCM_BurnIn_Duration__c>();
        
         for (MCM_BurnIn_Duration__c c :[select id,q1__c,q2__c,q3__c,q4__c,q5__c,q6__c,q7__c,q8__c,q9__c,q10__c,q11__c,q12__c,q13__c,q14__c,q15__c,q16__c,q17__c,q18__c,q19__c,q20__c,q21__c,q22__c,q23__c,q24__c from MCM_BurnIn_Duration__c where mcm__c =:a.id ]){
            c.q1__c = 1;
            c.q2__c = 1;
            c.q3__c = 1;
            c.q4__c = 1;
            c.q5__c=c.q6__c=c.q7__c=c.q8__c=c.q9__c=c.q10__c=c.q11__c=c.q12__c=c.q13__c=c.q14__c=c.q15__c=c.q16__c=c.q17__c=c.q18__c=c.q19__c=c.q20__c=c.q21__c=c.q22__c=c.q23__c=c.q24__c=0;
            mBID.add(c);
        }
        upsert mBID;
        
        
          list<MCM_Quarterly_Volume__c> lstQ = new list<MCM_Quarterly_Volume__c>(); 
           MCM_Quarterly_Volume__c conQ1 = new MCM_Quarterly_Volume__c(PCM_MCM_Detail__c=a.Id,Year__c=2017,Q1_Volume__c=10,Q2_Volume__c=20,Q3_Volume__c=30,Q4_Volume__c=40);
           lstQ.add(conQ1);
           insert lstQ;
        
          List<MCM_Reporting_Data__c> lstSbstCost = new  List<MCM_Reporting_Data__c>();
         MCM_Reporting_Data__c sbstCost1 = new MCM_Reporting_Data__c(mcm__c=a.id,year__c='2017',quarter__c='Q1',cost__c=59,cost_type__c='Assembly & Substrate Cost (before Yield)');
        MCM_Reporting_Data__c sbstCost2 = new MCM_Reporting_Data__c(mcm__c=a.id,year__c='2017',quarter__c='Q2',cost__c=59,cost_type__c='Assembly & Substrate Cost (before Yield)');
        MCM_Reporting_Data__c sbstCost3 = new MCM_Reporting_Data__c(mcm__c=a.id,year__c='2017',quarter__c='Q3',cost__c=59,cost_type__c='Assembly & Substrate Cost (before Yield)');
        MCM_Reporting_Data__c sbstCost4 = new MCM_Reporting_Data__c(mcm__c=a.id,year__c='2017',quarter__c='Q4',cost__c=59,cost_type__c='Assembly & Substrate Cost (before Yield)');
        lstSbstCost.add(sbstCost1);
        lstSbstCost.add(sbstCost2);
        lstSbstCost.add(sbstCost3);
        lstSbstCost.add(sbstCost4);
        insert lstSbstCost;
        
        List<Apttus_Proposal__Proposal__c> lstConfObj = new List<Apttus_Proposal__Proposal__c>();        
        Apttus_Proposal__Proposal__c prop = MCMDataUtilTest.createConfiguration(device.id,acctId,opptyId);
        lstConfObj.add(prop);
        insert lstConfObj; 
        List<Configurator_Cost__c> cst = new list<Configurator_Cost__c>();
        Configurator_cost__c c = new Configurator_cost__c(Year__c='2017',Quarter__c='Q1',Finish_goods_unit_cost__c =11.0,Quote_Proposal__c =lstConfObj[0].id);
            Configurator_cost__c c2 = new Configurator_cost__c(Year__c='2017',Quarter__c='Q2',Finish_goods_unit_cost__c =11.0,Quote_Proposal__c =lstConfObj[0].id);
            Configurator_cost__c c3= new Configurator_cost__c(Year__c='2017',Quarter__c='Q3',Finish_goods_unit_cost__c =11.0,Quote_Proposal__c =lstConfObj[0].id);
            Configurator_cost__c c4 = new Configurator_cost__c(Year__c='2017',Quarter__c='Q4',Finish_goods_unit_cost__c =11.0,Quote_Proposal__c =lstConfObj[0].id);
        
            cst.add(c);cst.add(c2);cst.add(c3);cst.add(c4);
        insert cst;
            
        List<MCM_Configuration_Detail__c> lstMcmConfDetail = new List<MCM_Configuration_Detail__c>();
        lstMcmConfDetail.add(new MCM_Configuration_Detail__c(Configuration__c=lstConfObj[0].id,PCM_MCM_MCM__c=a.id,Chip_per_Technology__c=2) );
        insert lstMcmConfDetail;
        
        list<MCM_Reporting_Data__c> lstDvsCost = new List<MCM_Reporting_Data__c>();
         MCM_Reporting_Data__c deviceCost1 = new MCM_Reporting_Data__c (year__c='2017',quarter__c='Q1',Cost_Type__c ='Configuration-Unit Cost',MCM__c = a.id,cost__c=10.455);
        MCM_Reporting_Data__c deviceCost2 = new MCM_Reporting_Data__c (year__c='2017',quarter__c='Q2',Cost_Type__c ='Configuration-Unit Cost',MCM__c = a.id,cost__c=9.678);
        MCM_Reporting_Data__c deviceCost3 = new MCM_Reporting_Data__c (year__c='2017',quarter__c='Q3',Cost_Type__c ='Configuration-Unit Cost',MCM__c = a.id,cost__c=8.841);
        MCM_Reporting_Data__c deviceCost4 = new MCM_Reporting_Data__c (year__c='2017',quarter__c='Q4',Cost_Type__c ='Configuration-Unit Cost',MCM__c = a.id,cost__c=7.911);
        lstDvsCost.add(deviceCost1);
        lstDvsCost.add(deviceCost2);
        lstDvsCost.add(deviceCost3);
        lstDvsCost.add(deviceCost4);
        
        insert lstDvsCost;
       createPCMTimesData();    
   
        
        
         PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 2,FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
          GenerateMCMYieldAndCost.generate(a.id);
         ApexPages.currentPage().getParameters().put('mcmId',a.id);
        ApexPages.currentPage().getParameters().put('Id',device.id);//Parent Device Id
        MCMCostReportController mCostCont = new MCMCostReportController();
            test.stopTest();
        }
    }
    
     static void createPCMTimesData() {
         
     
                     Id rectype = Schema.SObjectType.PCM_Time__c.getRecordTypeInfosByName().get('APS Constants').getRecordTypeId(); 
                                
        list<pcm_time__c> pcmtime =new list<pcm_time__c>();                 
       PCM_Time__c data1 = new PCM_Time__c(Constant_Name__c='GROUP_A_PERCENT', recordtypeId=rectype,value__c='0', Catalog_ID__c='PCM215',version__c='1', location__c='FAB 9');
       PCM_Time__c data2 = new PCM_Time__c(Constant_Name__c='LOAD_FACTOR', recordtypeId=rectype,value__c='1', Catalog_ID__c='PCM215',version__c='1', location__c='FAB 9');
       PCM_Time__c data3 = new PCM_Time__c(Constant_Name__c='RETEST_PER_CENT', recordtypeId=rectype,value__c='0', Catalog_ID__c='PCM215',version__c='1', location__c='FAB 9');
       PCM_Time__c data4 = new PCM_Time__c(Constant_Name__c='MACH_STOP_DELAY', recordtypeId=rectype,value__c='0.03', Catalog_ID__c='PCM215',version__c='1', location__c='FAB 9');
       PCM_Time__c data5 = new PCM_Time__c(Constant_Name__c='SETUP_TIME_PER_LOT', recordtypeId=rectype,value__c='0.4', Catalog_ID__c='PCM215',version__c='1', location__c='FAB 9');
        
       rectype = Schema.SObjectType.PCM_Time__c.getRecordTypeInfosByName().get('WorkCenter').getRecordTypeId();   
       PCM_Time__c data6 = new PCM_Time__c(recordtypeId=rectype,Catalog_ID__c='PCM215',version__c='1',Handlers_WS__c =1
                             , Contingency_Percent__c = 1
                             , Overhead_Time__c = 1
                            
                             , Characterization_Percent__c = 0.05
                             , Initial_Mod_Setup__c =0
                             , Planned_Maint__c = 0.36
                             , Unplanned_Maint__c = 0.15
                             , MFG_Planned_Maint__c  = 0
                             , MFG_Unplanned_Maint__c = 0
                             , Calibration__c = 0
                             , TAE_ME__c = 0.48
                             , IS_DP__c = 0.12,Stage__c = 'MOD_TST' , location__c='FAB 9', Workcenter__c = '66XX512_M');
         
       rectype = Schema.SObjectType.PCM_Time__c.getRecordTypeInfosByName().get('Handler FEH').getRecordTypeId();   
       PCM_Time__c data7 = new PCM_Time__c( Index_Time__c = 2, recordtypeId=rectype, Catalog_ID__c='PCM215',version__c='1',Stage__c = 'MOD_TST' , location__c='FAB 9', Workcenter__c = '66XX512_M'
                                          ,Planned_Maint__c =0.5, Unplanned_Maint__c= 1 , MFG_Planned_Maint__c =0,MFG_Unplanned_Maint__c=1);  
         
       pcmtime.add(data1);
                         pcmtime.add(data5);
                         pcmtime.add(data4);
                         pcmtime.add(data3);
                         pcmtime.add(data2);pcmtime.add(data6);pcmtime.add(data7);
        insert pcmtime;
      
    }

 private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}