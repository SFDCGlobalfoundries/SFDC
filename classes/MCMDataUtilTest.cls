@isTest(SeeAllData = false)
public class MCMDataUtilTest {

      @testSetup
    
   public  static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
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
        fieldValueMap.put('Fab_9_10__c','Yes');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

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
    
  public static Id createOpp(Id acctId) {       
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
    
    public static Id createOppProg(Id acctId,Id oppId) {
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','Test Opportunity Program');
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Opportunity__c',oppId);
       
        return OpportunityProgramDataFactory.createOpportunityProgram(fieldValueMap).id;      
    }
   
     public static Account getAccount(string AccountName)
    {
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
        
        return DeviceDataFactory.createDevice(fieldValueMap);                      
    }
    
    public static Device__c createGoodDevice2(Id acctId,Id opptyProgramId) {
        String MSTId = createMaskSetTtitle('MSTTRT2');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c', acctId);
        fieldValueMap.put('Name', 'MCMGoodDevice2');
        fieldValueMap.put('Opportunity_Program__c', opptyProgramId );
        fieldValueMap.put('Fab__c', 'FAB 9');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');
        fieldValueMap.put('Market_Segment__c', 'Automotive');
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');
        fieldValueMap.put('End_Customer__c', 'Test Customer');
        fieldValueMap.put('Device_Sourcing__c', '1st Source');
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');
        fieldValueMap.put('Siebel_Device_ID__c', '1234567890');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c', 'ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MSTTRT');
        fieldValueMap.put('Actual_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c', date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');
        fieldValueMap.put('Device_Type__c', 'Base');
        fieldValueMap.put('End_Application__c', 'Body');
        
        return DeviceDataFactory.createDevice(fieldValueMap);                      
    }

     public static Device__c createMissingFABDevice(Id acctId,Id opptyProgramId) {
        String MSTId = createMaskSetTtitle('MSTTRT3');
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c', acctId);
        fieldValueMap.put('Name', 'MCMMissingFABDevice');
        fieldValueMap.put('Opportunity_Program__c', opptyProgramId );
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c', 'No');
        fieldValueMap.put('Market_Segment__c', 'Automotive');
        fieldValueMap.put('Semiconductor_Device__c', 'Analog Amplifier');
        fieldValueMap.put('End_Customer__c', 'Test Customer');
        fieldValueMap.put('Device_Sourcing__c', '1st Source');
        fieldValueMap.put('Stage__c', 'Design In');
        fieldValueMap.put('Status__c', 'Active');
        fieldValueMap.put('Siebel_Device_ID__c', '1234567891');
        fieldValueMap.put('Tapeout_Type__c', 'Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c', 'ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c', 'MSTTRT');
        fieldValueMap.put('Actual_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c', date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c', date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c', '100');
        fieldValueMap.put('Device_Type__c', 'Base');
        fieldValueMap.put('End_Application__c', 'Body');
        
        return DeviceDataFactory.createDevice(fieldValueMap);                      
    }

    public static Apttus_Proposal__Proposal__c createConfiguration(Id deviceId,Id accId,Id opptyId){
        Apttus_Proposal__Proposal__c config = new Apttus_Proposal__Proposal__c();
        config.Device__c = deviceId;
        config.Apttus_Proposal__Account__c = accId;
        config.Apttus_Proposal__Opportunity__c= opptyId;
        
        config.Apttus_Proposal__Proposal_Name__c = 'MCMTestConfiguration';
        config.Actual_Tapeout_Date_FAB_9_and_FAB_10__c =date.newInstance(2017,1,1);
        config.APTPS_Primary__c=True;
        return config;
    }
    public static Apttus_Proposal__Proposal__c createConfiguration1(Id deviceId,Id accId,Id opptyId){
        Apttus_Proposal__Proposal__c config = new Apttus_Proposal__Proposal__c();
        config.Device__c = deviceId;
        config.Apttus_Proposal__Account__c = accId;
        config.Apttus_Proposal__Opportunity__c= opptyId;
        config.Apttus_Proposal__Proposal_Name__c = 'MCMTestConfiguration1';
        config.Actual_Tapeout_Date_FAB_9_and_FAB_10__c =date.newInstance(2017, 6, 04);
        config.APTPS_Primary__c=True;
        
        return config;
    }
     public static Apttus_Proposal__Proposal__c createConfiguration2(Id deviceId,Id accId,Id opptyId){
        Apttus_Proposal__Proposal__c config = new Apttus_Proposal__Proposal__c();
        config.Device__c = deviceId;
        config.Apttus_Proposal__Account__c = accId;
        config.Apttus_Proposal__Opportunity__c= opptyId;
        config.Apttus_Proposal__Proposal_Name__c = 'MCMTestConfiguration2';
         config.APTPS_Primary__c=True;
         
         
        return config;
    }
     public static Id createMaskSetTtitle(String name){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = name;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
  
    public static List<MCM_Yields__C> createYieldData(Id mcmId) {
        List<MCM_Yields__c> yields = new List<MCM_Yields__c>();
        MCM_Yields__c aYield =  new MCM_Yields__c(RecordTypeId = Schema.SObjectType.MCM_Yields__c.RecordTypeInfosByName.get('Assembly Yield').RecordTypeId,MCM__c=mcmId,Q1__c=.95,Q2__c=.90,Q3__c=.89,Q4__c=.99);
        MCM_Yields__c bYield =  new MCM_Yields__c(RecordTypeId = Schema.SObjectType.MCM_Yields__c.RecordTypeInfosByName.get('Burn-In User Defined').RecordTypeId,MCM__c=mcmId,Q1__c=.95,Q2__c=.90,Q3__c=.89,Q4__c=.99);
        MCM_Yields__c tYield =  new MCM_Yields__c(RecordTypeId = Schema.SObjectType.MCM_Yields__c.RecordTypeInfosByName.get('Test Yield').RecordTypeId,MCM__c=mcmId,Q1__c=.95,Q2__c=.90,Q3__c=.89,Q4__c=.99);
        yields.add(aYield);
        yields.add(bYield);
        yields.add(tYield);
        return yields;
    }
    public static List<MCM_Quarterly_Volume__C> createQtrVolData(Id mcmId) {
        List<MCM_Quarterly_Volume__C> qtrVol = new List<MCM_Quarterly_Volume__C>();
        MCM_Quarterly_Volume__C qtrVol1 =  new MCM_Quarterly_Volume__C(year__c=2017,PCM_MCM_Detail__c=mcmId,Q3_Volume__c=1000,  Q4_Volume__c=1000);
        MCM_Quarterly_Volume__C qtrVol2 =  new MCM_Quarterly_Volume__C(year__c=2018,PCM_MCM_Detail__c=mcmId,    Q1_Volume__c=1000,  Q2_Volume__c=1000);
        
        qtrVol.add(qtrVol1);
        qtrVol.add(qtrVol2);
       
        return qtrVol;
    }
    
    public static List<MCM_Reporting_Data__C> createQtrSbstCostData(Id mcmId) {
        List<MCM_Reporting_Data__C> qtrCost = new List<MCM_Reporting_Data__C>();
        MCM_Reporting_Data__C qtr1 =  new MCM_Reporting_Data__C(year__c='2017',Quarter__c ='Q3',Cost_Type__c ='Assembly & Substrate Cost (before Yield)' ,MCM__c=mcmId,Cost__c=100);
        MCM_Reporting_Data__C qtr2 =  new MCM_Reporting_Data__C(year__c='2017',Quarter__c ='Q4',Cost_Type__c ='Assembly & Substrate Cost (before Yield)' ,MCM__c=mcmId,Cost__c=100);
        MCM_Reporting_Data__C qtr3 =  new MCM_Reporting_Data__C(year__c='2018',Quarter__c ='Q1',Cost_Type__c ='Assembly & Substrate Cost (before Yield)' ,MCM__c=mcmId,Cost__c=100);
        MCM_Reporting_Data__C qtr4 =  new MCM_Reporting_Data__C(year__c='2019',Quarter__c ='Q2',Cost_Type__c ='Assembly & Substrate Cost (before Yield)' ,MCM__c=mcmId,Cost__c=100);
        
        qtrCost.add(qtr1);
        qtrCost.add(qtr2);
        qtrCost.add(qtr3);
        qtrCost.add(qtr4);
       
        return qtrCost;
    }
}