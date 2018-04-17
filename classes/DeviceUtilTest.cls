/*
    Author: Mallika Seth
    Description: This is the util class is for the Device Creation.  
    History:
        MSETH    10062015    - code creation.
        
*/

@isTest(SeeAllData=false)
public class DeviceUtilTest {
    @testSetup static void testdata() {
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
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        AccountDataFactory.createAccount(fieldValueMap);
    }        
    
    public static Id createAccount() {
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1-Test');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept1');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        //fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        return AccountDataFactory.createAccount(fieldValueMap).id;
        
    }
   
    public static Id createOpp(Id acctId, string processGeometry) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = processGeometry; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
    }
    public static Id createOpp2(Id acctId, string processGeometry) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = acctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM'; //'0.60UM'
        testOppty.Process_Family__c = 'Super Low Power';
        
        insert testOppty;
        return testOppty.Id;
    }
    
    public static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
    
    public static Id createMPWTrainMnt(){
        MPW_Train_Maintenance__c mtm = new MPW_Train_Maintenance__c();
        mtm.Name = 'MPWTEST';
        mtm.MPW_Train_No__c = 'MPWTEST';
        mtm.Delay__c = 5;
        mtm.Status__c = 'Test';
        insert mtm;
        return mtm.Id;
    }
    
    public static Id createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'TestMPW';
        m.Customer_Tapeout_Date__c = date.newInstance(2013,5,20);
        m.Other_Tapeout_Date__c = date.newInstance(2013,5,20);
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        
        insert m;
        return m.Id;
    }
    public static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT1';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    public static Id createMaskSetTtitleMPW(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MPW1345';
        mst.Manual_Creation__c =False;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    public static Mask_Set_Title__c createMaskSetTtitleObj(String mstname){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = mstname;
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst;
    }
    Public static Mask_Set_Title__c createMaskSetTitle1(String name, Boolean isAvailableForUse, String status){
       Mask_Set_Title__c Maskst = new Mask_Set_Title__c(Name = name, Is_Available_For_Use__c = isAvailableForUse, Status__c = status,Reticle_Type__c = 'Multi Layer Reticle (MLR)');
       insert Maskst ;
       return Maskst ;
    }
    public static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        insert mstAcc;
        return mstAcc.Id;
    }
    
    public static id createProcess(string processGeometry){
        Process__c pros = new Process__c();
        pros.Process_Family__c = 'Super Low Power';
        pros.Tech_Geometry__c = processGeometry;
        pros.Available_to_Sell__c = 'Available';
        pros.Process_Technology__c = 'test123';
        insert pros;      
        return pros.id;
    }
    
    public static id createProcessTechnology() {
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'test';
        pt.IP_Geometry_Technology__c = 'test';
        pt.PT_Number__c = 'test123';
        insert pt;      
        return pt.id;
    }
    
    public static Id createCustomerMPWDevice(Id acctId,Id opptyProgramId) {
       
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.today().addDays(7);
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        Insert device;
        
        return device.id;
    }
    public static Id createCustomerMPWDevice10(Id acctId,Id opptyProgramId) {
       
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        Insert device;
        
        return device.id;
    }
    
    public static Device__c createCustomerMPWDeviceNew(Id testAcctId, Id testOpptyProgramId) {
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        
        device.Forecasted_Lot_Start_Date__c = System.Today();
        device.Product_TO_Date__c = System.Today();
        device.Sample_Delivery_Date__c = System.Today()+160;
        device.Forecasted_Proto_Date__c = System.Today()+220;
        device.Forecasted_RTP_Date__c = System.Today()+380;
        device.Forecasted_Production_Start_Date__c = System.Today()+580;
        device.Proto_DPML__c = 0.8;
        device.PreProd_Prod_DPML__c = 1.9;
        device.Production_DPML__c = 2.8;        
        device.No_of_Mask_Layers__c = 60;
        device.Display_in_PSP__c = true; 
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
       
        Insert device;        
        return device;
    }
    
    public static Device__c createCustomerMPWDeviceNew1(Id accId, Id oppId, Id oppProgId) {
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MSTId);
        Device__c dev = new Device__c();
        dev.Name = '34E21SA-75AZZZ';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Configuration_Status__c= 'PROCESS FLOW ACCEPTED';//sunita
        insert dev;
        return dev; 
    }
    
    public static Device__c createCustomerMPWDeviceNew2(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        
        //Added in UAT
        device.Account__c = testAcctId;
        
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        //device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        Insert device;
        
        return device;
    }
    
    public static Device__c createCustomerMPWDeviceNew3(Id testAcctId, Id testOpptyId, Id testOpptyProgramId) {
        // Create Device
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = testAcctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Market_Segment__c = 'Automotive';
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.End_Application__c = 'Body';
        device.Opportunity2__c = testOpptyId;
        device.IP_Gap__c = false;
        device.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        device.Confidence_Level_Tapeout__c = '100';
        device.Siebel_Sync_id__c = String.valueOf(System.now());
        device.Siebel_Status__c = 'SENT';
        //Insert device;
        
        return device;
    }
    
    public static Device__c createCustomerMPWDeviceNew4(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        //device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        //Insert device;
        
        return device;
    }
    
     public static Device__c createCustomerMPWDevice2(Id acctId,Id opptyProgramId) {
       
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Device_Type__c = 'Base';
        device.Confidence_Level_Tapeout__c ='100';
        device.End_Application__c = 'Body';
        
        Insert device;
        
        return device;
    }
    
    Public static Device__c createCustomerMPWDevice3(Id accId, Id oppId, Id oppProgId){
   Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1313';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
    public static Device__c createCustomerMPWDevice4(Id acctId,Id opptyProgramId) {
       
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Device_Type__c = 'Base';
        device.Confidence_Level_Tapeout__c ='100';
        device.End_Application__c = 'Body';
        device.Internal_Device_Geometry__c = '0.028UM';
        device.Internal_Device_Process_Family__c = 'Super Low Power';
        return device;
    }
    public static Device__c createCustomerMPWDevice5(Id testAcctId, Id testOpptyProgramId) {
         // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12';
        //device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        Insert device;
        
        return device;
    }
    
    
    Public static Device__c createCustomerMPWDevice6(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE131313';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
    
    Public static Device__c createCustomerMPWDevice7(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TQAFVD5980';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.IP_Gap__c = false;
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
   Public static Device__c createCustomerMPWDevice8(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE008';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        insert dev;
        return dev; 
    }
    Public static Device__c createDeviceOnHold(Id accId, Id oppId, Id oppProgId){
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1313';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'On Hold';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.Device_Mask_Set_Title__c = 'MSTTRT1';
        dev.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        dev.IP_Gap__c = false;
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Forecasted_Lot_Start_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Reason_For_Status_On_Hold__c = 'test';
        insert dev;
        return dev; 
    }
    
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        device.Confidence_Level_Tapeout__c = '100';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        
        
        return device;
    }
     public static Device__c createSPDevice(Id acctId,Id opptyProgramId) {
        
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Confidence_Level_Tapeout__c = '50';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        
        return device;
    }
    
     public static Device__c createSPDevice1(Id acctId,Id opptyProgramId) {
        
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = acctId;
        device.Name = 'TESTDEVICEZAIEFR';
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Confidence_Level_Tapeout__c = '50';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        
        return device;
    }
    public static Device__c createSPDevice3(Id acctId,Id opptyProgramId) {
        
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICESPPP';
        device.Opportunity_Program__c = opptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // Testing only for 'design in'
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Device_Mask_Set_Title__c = 'MSTSPP1';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.Enabled_via_previous_MPW_1__c = 'No';//Added as class was failing by Ashwini on 5/19/2015
        
        
        return device;
    }
     public static Device__c createSPDevice2(Id acctId,Id opptyProgramId) {
        
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = opptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In'; // Testing only for 'design in'
        device.Confidence_Level_Tapeout__c = '50';
        device.End_Application__c = 'Server';
        device.Original_Forecasted_Tapeout_Date__c  = system.today();
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.Semiconductor_Device__c = 'MEMS - Inertial';
        device.PTRF_ID__c = 'test';
        device.Geometry_Filter__c = '0.055UM';
        device.Process_Family_Filter__c = 'MEMS';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.Enabled_via_previous_MPW_1__c = 'No';//Added as class was failing by Ashwini on 5/19/2015
        
        
        return device;
    }
        public static Device__c createDevice() {
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        //string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICE';
        
        //Added in UAT
        device.Account__c = acctId;
        
        device.Opportunity_Program__c = opptyProgramId ;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Automotive';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.Process_Technology_2__c = processTechnologyId;
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        
       // Insert device;
        
        return device;
    }
    
    public static Device__c createDeviceNew(Id testAcctId, Id testOpptyProgramId, string tapeoutType) {
       
        string mpwId = DeviceUtilTest.createMPW();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(testAcctId,MSTId);
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = tapeoutType;
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        //device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.CRMDID__c = 'CDID0000001.00';
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        
        if (tapeoutType != 'Single Product') {
            device.MPW_Train_Number__c = mpwId;
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
        }
        if (tapeoutType == 'Single Product') {
            device.Device_Mask_Set_Title__c = 'MSTXXX1';
        }
        
        if (tapeoutType != 'Retrofit') {
            device.Device_Type__c = 'Base';
        } else {
            device.Device_Type__c = 'Retrofit';
            device.PTRF_ID__c = 'test';
        }
        
        //Insert device;
       
        return device;    
        
    }

    public static testMethod Device__c createRetrofitDevice() {
       
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
       
      
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICEZAIH12345677';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Tapeout';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Retrofit';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
            device.Device_Type__c = 'Retrofit';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            
            //insert device;
            return device;
    }
    
    public static Device__c  createRetrofitDevice1(ID baseDeviceId ) {
       
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        
      
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICEZAIH12345677';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Tapeout';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Retrofit';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
            device.Device_Type__c = 'Retrofit';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Base_Device__c = baseDeviceId;
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            
            insert device;
            return device;
    }
    public static testMethod Device__c createSingleProductDevice() {
       
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
       // string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice(acctId,opptyProgramId);
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTSP01';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
           // device.Base_Device__c = baseDeviceId;
            device.End_Application__c = 'Body';
            
           // insert device;
            return device;
    }
    
     public static Device__c createDevicePM(Id accId, Id oppId, Id oppProgId) {
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICESP';
            device.Account__c = accId;
            device.Opportunity2__c = oppId;
            device.Opportunity_Program__c = oppProgId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Single Product';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.End_Application__c = 'Body';
            
           // insert device;
            return device;
    }
    public static testMethod Device__c createFullLayerRetrofitDevice() {
       
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
       // string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice(acctId,opptyProgramId);
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'TESTDEVICEFLR';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Full Layer Retrofit';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
           // device.Base_Device__c = baseDeviceId;
            device.End_Application__c = 'Body';
            
            //insert device;
            return device;
    }
    public static testMethod Device__c createGlobalShuttleMPWDevice() {
       
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = DeviceUtilTest.createMaskSetTtitleMPW();
       // string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice(acctId,opptyProgramId);
        
            // Create Device
            Device__c device = new Device__c();
            device.Name = 'MPWTEST_1';
            device.Account__c = acctId;
            device.Opportunity2__c = opptyId;
            device.Opportunity_Program__c = opptyProgramId;
            device.Fab__c = 'FAB 2';
            device.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device.Market_Segment__c = 'Automotive';
            device.Semiconductor_Device__c = 'Analog Amplifier';
            device.End_Customer__c = 'Test Customer';
            device.Device_Sourcing__c = '1st Source';
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Tapeout_Type__c = 'Global Shuttle MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Device_Mask_Set_Title__c = 'MPWTEST';
            device.Assigned_Process_ID__c = processId;
            device.reticle_type__c = 'Small Field Reticle (SFR)';
            device.Geometry_Filter__c = '0.10UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            //device.Base_Device__c = baseDeviceId;
            device.End_Application__c = 'Body';
            
           // insert device;
            return device;
    }
    Public static Device__c createGlobalShuttleMPWDevice2(Id accId, Id oppId, Id oppProgId, Id processId){
        
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        
        
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1948';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = 'First Source';
        dev.Tapeout_Type__c = 'GlobalShuttle MPW';
        dev.Export_Control_Waiver_Flag__c = 'Yes';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Closed';
        dev.Device_Type__c = 'Base';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Geometry_Filter__c = '0.010UM';
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Mask_Set_Title_Lookup__c='a94O0000000Cbyl';
        dev.Device_Mask_Set_Title__c='MSTTRT1';
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        insert dev;
        return dev; 
    }
    
    Public static Device__c createGlobalShuttleMPWDevice3(Id accId, Id oppId, Id oppProgId, Id processId, Id newPartId){
        //string mpwId = DeviceUtilTest.createMPWTrainMnt();
        //string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        //String MSTId = DeviceUtilTest.createMaskSetTtitle();
        
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1949';
        dev.Stage__c = 'Design In';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Device_Type__c = 'Revision';
        dev.Tapeout_Type__c = 'GlobalShuttle MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Assigned_Process_ID__c = processId;
        dev.BX041_Status__c = 'Pending Submission';
        dev.Secure_Device__c = 'Y';
        dev.Automotive_Device__c = 'Yes';
        dev.Automotive_Grade__c = 'Grade 0';
        dev.Confidence_Level_Tapeout__c = '10';
        dev.Fab__c = 'FAB 1';
        //dev.NPC_Form__c = newPartId;
        dev.PTRF_ID__c = 'test';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        dev.Fab__c = 'FAB 2';
        dev.Confidence_Level_Tapeout__c = '100';
        //dev.Mask_Set_Title_Lookup__c='a94O0000000Cbyl';
        dev.Device_Mask_Set_Title__c='MSTTRT1';
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        insert dev;
        return dev; 
    }
     Public static Device__c createCMPWDevice1(Id accId, Id oppId, Id oppProgId){
      String MSTId = DeviceUtilTest.createMaskSetTtitle();
      string MSTAccId = DeviceUtilTest.createMSTAccount(accId,MSTId);
        Device__c dev = new Device__c();
        dev.Name = 'TESTDEVICE1947';
        dev.Stage__c = 'Solutioning';
        dev.Status__c = 'Active';
        dev.Account__c = accId;
        dev.Opportunity2__c = oppId;
        dev.Opportunity_Program__c = oppProgId;
        dev.Market_Segment__c = 'Automotive';
        dev.Semiconductor_Device__c = 'Analog Regulator';
        dev.End_Application__c = 'Body';
        dev.Device_Sourcing__c = '3rd Source';
        dev.Tapeout_Type__c = 'Customer MPW';
        dev.Siebel_Device_ID__c = '0987654321';
        dev.IP_Gap__c = false;
        dev.Device_Mask_Set_Title__c='MSTTRT1';
        dev.Reticle_Type__c='Single Layer Reticle (SLR)';
        dev.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
        dev.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
        insert dev;
        return dev; 
    }

    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}