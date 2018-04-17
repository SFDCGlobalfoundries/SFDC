@isTest(SeeAllData=false)
private class MCMControllerTest {
      
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
        fieldValueMap.put('deliverable_part_type__c','Module');
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
        fieldValueMap.put('Fab__c','FAB 9');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Device_Sourcing__c','First Source');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId); 
        
        return DeviceDataFactory.createDevice(fieldValueMap).id;                      
    }
    
    static testMethod void MCMControllerTest() {
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = MCMControllerTest.createOpp(acctId);
        string opptyProgramId = MCMControllerTest.createOppProg(acctId, opptyId);
        // Create Device
            String deviceId;
      User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
       
        test.startTest();
             deviceId = MCMControllerTest.createDevice(acctId,opptyId,opptyProgramId);           

        List<MCM_Yields__c> m = new List<MCM_Yields__c>();
        PCM_MCM_DEtail__c a = new PCM_MCM_DEtail__c();
        a.Device__c = deviceId;
         a.Fab__c ='FAB 9';
         a.Test_Platform__c = '66XX512_M';
      a.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = date.newInstance(2017,1,1);
        a.Burn_In_Platform__c='ABES_IV';
        a.Number_of_Sockets_Per_Boards__c=3;
        a.No_of_DUTS__c='16';
        a.User_Defined_Time__c =10;
        insert a;
        ApexPages.CurrentPage().getParameters().put('Id',a.Id);
      
        
 
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
        Apttus_Proposal__Proposal__c prop = MCMDataUtilTest.createConfiguration(deviceId,acctId,opptyId);
        lstConfObj.add(prop);
        insert lstConfObj; 
     
        device__c d =[select id, Opportunity_Program__c from Device__c where id =: deviceId];                
        
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
        
         PCM_Administration__c pcmadmin = new PCM_Administration__c(Name = 'CURRENT_SETTING',Version_ID__c='1',PCM_Fabs__c='FAB 2,FAB 8,FAB 9,FAB 10',Catalog_ID__c='PCM215');
           insert pcmadmin;
          GenerateMCMYieldAndCost.generate(a.id);
         ApexPages.currentPage().getParameters().put('mcmId',a.id);
        ApexPages.currentPage().getParameters().put('Id',deviceId);//Parent Device Id
        MCMController mCostCont = new MCMController();
        
    
     
        ApexPages.currentPage().getHeaders().put('referer', 'https://globalfoundries--ibmint.cs6.my.salesforce.com');
        integer qtrCount =4;
        mCostCont.loadMCMConfiguration();
        mCostCont.getBIDurationPageBlockTable();
        mCostCont.getSubstrateCostPageBlockTable();
        mCostCont.getYieldsPageBlockTable();
        mCostCont.gotoConfSelectionPage();
        mCostCont.redirectToMCMDetail();
        mCostCont.redirectToMCMDevice();
        mCostCont.ValidateDataReport();
        mCostCont.SaveMCMData();
        mCostCont.SaveDetail();
        mCostCont.GenerateCostReport();
        mcostCont.DisplayCostReport();
             test.stopTest();
        
            delete a;
            system.debug('deviceId============>'+deviceId);
           }
            PCM_MCM_Detail__c a1 = new PCM_MCM_Detail__c();
        //String deviceId = MCMControllerTest.createDevice(acctId,opptyId,opptyProgramId);   
        a1.Device__c = deviceId;
        
        //a1.Device__c=MCMControllerTest.createDevice(acctId,opptyId,opptyProgramId);           
        a1.Actual_Tapeout_Date_FAB_9_and_FAB_10__c = date.newInstance(2017,5,1);
        a1.Fab__c ='FAB 9';
        insert a1;
            
         ApexPages.currentPage().getParameters().put('Id',deviceId);//Parent Device Id
         MCMController mcmCont = new MCMController();
        mcmCont.loadMCMConfiguration();
        mcmCont.getBIDurationPageBlockTable();
        mcmCont.getSubstrateCostPageBlockTable();
        mcmCont.getYieldsPageBlockTable();
        mcmCont.gotoConfSelectionPage();
        mcmCont.redirectToMCMDetail();
        mcmCont.redirectToMCMDevice();
        mcmCont.ValidateDataReport();
        mcmCont.SaveMCMData();
        mcmCont.SaveDetail();
        mcmCont.GenerateCostReport();
        mcmCont.DisplayCostReport();
         
    }
    
 

 private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}