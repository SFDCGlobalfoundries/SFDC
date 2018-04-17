/*
    Author: Zymark Ambat
    Description: This is the test class for the DeviceTrigger.  
    History:
        ZAmbat    02242014    - code creation.
        Vijay     12052014  - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 'Design In' directly and added mandatory field End Application.        
        Ashwini   03302015    - Refactoring test class.
        Vijay     04222015    - added the test methods for Internal Device
*/
@isTest(SeeAllData=false)
private class DeviceTriggerTest {
    @testSetup static void testdata() {
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        AccountDataFactory.createAccount(fieldValueMap);
    }    
    
    static Id createOpp(Id acctId, string processGeometry) {
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
    
    static Id createOppProg(Id acctId,Id oppId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = acctId;
        testOpptyProgram.Opportunity__c = oppId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
    
    static Id createMPWTrainMnt(){
        MPW_Train_Maintenance__c mtm = new MPW_Train_Maintenance__c();
        mtm.Name = 'MPWTest1999';
        mtm.MPW_Train_No__c = 'MPWTest1999';
        mtm.Delay__c = 5;
        mtm.Status__c = 'Test';
        insert mtm;
        return mtm.Id;
    }
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    static Id createMaskSetTtitle1(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT1';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        insert mstAcc;
        return mstAcc.Id;
    }
    
    static id createProcess(string processGeometry){
        Process__c pros = new Process__c();
        pros.Process_Family__c = 'Super Low Power';
        pros.Tech_Geometry__c = processGeometry;
        pros.Available_to_Sell__c = 'Available';
        pros.Process_Technology__c = 'test123';
        insert pros;      
        return pros.id;
    }
    
    static id createProcessTechnology() {
        Process_Technology__c pt = new Process_Technology__c();
        pt.Name = 'test';
        pt.IP_Geometry_Technology__c = 'test';
        pt.PT_Number__c = 'test123';
        insert pt;      
        return pt.id;
    }
    
    /*static id createDevice(id testAcctId, id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
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
        device.Device_Mask_Set_Title__c = 'MSTTRT';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.End_Application__c = 'Body';
        
        Insert device;
        
        return device.Id;
    }*/
    
    static testMethod void DeviceTriggerTest1() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        String MSTId = DeviceTriggerTest.createMaskSetTtitle();
        String MSTId1 = DeviceTriggerTest.createMaskSetTtitle1();
        string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);
        string MSTAccId1 = DeviceTriggerTest.createMSTAccount(acctId,MSTId1);
        
        test.startTest();
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
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Customer MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT';
            device.CRMDID__c = 'CDID0000001.00';
            device.Device_Type__c = 'Base';
            device.End_Application__c = 'Body';
            //test.startTest();
            insert device;
            
        test.stopTest();
    }
    
    static testMethod void DeviceTriggerTest2() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceTriggerTest.createMPWTrainMnt();
        string processId = DeviceTriggerTest.createProcess('0.60UM');
        string processTechnologyId = DeviceTriggerTest.createProcessTechnology();
        String MSTId = DeviceTriggerTest.createMaskSetTtitle();
        string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);
        
        test.startTest();
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
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Customer MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT';
            //device.CRMDID__c = 'CDID0000001.00';
            //device.Device_Type__c = 'Base';
            device.Previous_Enabling_Devices_MPW__c = mpwId;
            device.Actual_Tapeout_Date__c = datetime.now();
            device.Process_Family_Filter__c = 'Super Low Power';
            device.Assigned_Process_ID__c = processId;
            device.Geometry_Filter__c = '0.60UM';
            device.Confidence_Level_Tapeout__c = '100';
            device.End_Application__c = 'Powertrain';
            device.Original_Forecasted_Tapeout_Date__c = date.today();
            device.PTRF_ID__c = 'test';
            device.Process_Technology_2__c = processTechnologyId;
            device.End_Application__c = 'Body';
            //test.startTest();
            insert device;
        test.stopTest();
    }
    static testMethod void DeviceTriggerTestRetrofit() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        /*string acctId = DeviceTriggerTest.createAccount();
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceTriggerTest.createMPWTrainMnt();
        string processId = DeviceTriggerTest.createProcess('0.10UM');
        string processTechnologyId = DeviceTriggerTest.createProcessTechnology();
        String MSTId = DeviceTriggerTest.createMaskSetTtitle();
        string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);*/
        
        //String MST = DeviceUtilTest.createMaskSetTtitle();
        //string baseDeviceId = DeviceTriggerTest.createDevice(acctId, opptyProgramId);
        Device__c Device = DeviceUtilTest.createRetrofitDevice();
        
        
           test.startTest();
            insert device;
        test.stopTest();
    }
     static testMethod void DeviceMSTPrimeDie() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.60UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        
        //string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);
        //String MSTId1 = DeviceTriggerTest.createMaskSetTtitle1();
        //string MSTAccId1 = DeviceTriggerTest.createMSTAccount(acctId,MSTId1);

        test.startTest();
            // Create Device
            //String MSTId = DeviceTriggerTest.createMaskSetTtitle();
          try{
            Device__c device = DeviceUtilTest.CreateCMPWDevice(acctId,opptyProgramId);
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
            device.Stage__c = 'Design In';
            device.Status__c = 'Active';
            device.Siebel_Device_ID__c = '1234567890';
            device.Tapeout_Type__c = 'Customer MPW';
            device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT';
            device.CRMDID__c = 'CDID0000001.00';
            device.Device_Type__c = 'Base';
            device.Expected_no_of_Prime_Die__c = 10;
            device.End_Application__c = 'Body';
            insert device;            
            device.Device_Mask_Set_Title__c = 'MSTTRT1';
            Update device;
            }catch(Exception ex){}
        test.stopTest();
    }
    static testMethod void DeviceTriggerTestGSMPW() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        /*string acctId = DeviceTriggerTest.createAccount();
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceTriggerTest.createMPWTrainMnt();
        string processId = DeviceTriggerTest.createProcess('0.10UM');
        string processTechnologyId = DeviceTriggerTest.createProcessTechnology();*/
        //String MSTId = DeviceTriggerTest.createMaskSetTtitle();
        //string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);
        //string baseDeviceId = DeviceTriggerTest.createDevice(acctId, opptyProgramId);
        
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        test.startTest();
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
        
        //Device__c Device = DeviceUtilTest.createGlobalShuttleMPWDevice();
        
        insert device;
        test.stopTest();
    }
    static testMethod void DeviceTriggerTestFullLayerRetro() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        /*string acctId = DeviceTriggerTest.createAccount();
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceTriggerTest.createMPWTrainMnt();
        string processId = DeviceTriggerTest.createProcess('0.10UM');
        string processTechnologyId = DeviceTriggerTest.createProcessTechnology();
        String MSTId = DeviceTriggerTest.createMaskSetTtitle();
        string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);*/
        //string baseDeviceId = DeviceTriggerTest.createDevice(acctId, opptyProgramId);
        
        //Device__c Device = DeviceUtilTest.createFullLayerRetrofitDevice();
        
        string acctId = DeviceUtilTest.createAccount();
        string opptyId = DeviceUtilTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        string processId = DeviceUtilTest.createProcess('0.10UM');
        string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        test.startTest();
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
        
        //test.startTest();
            insert device;
        test.stopTest();
    }
    
    static testMethod void DeviceTriggerTest3() {
        // Load Environment Variables  
        //DataUtilTest.loadEnvironmentVariables();
        
        string acctId = getAccount('MYTEST ACCOUNT1').id;
        string opptyId = DeviceTriggerTest.createOpp(acctId, '0.10UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceTriggerTest.createMPWTrainMnt();
        string processId = DeviceTriggerTest.createProcess('0.10UM');
        string processTechnologyId = DeviceTriggerTest.createProcessTechnology();
        //String MSTId1 = DeviceTriggerTest.createMaskSetTtitle1();
        String MSTId = DeviceTriggerTest.createMaskSetTtitle1();
        string MSTAccId = DeviceTriggerTest.createMSTAccount(acctId,MSTId);
        test.startTest();
        //string baseDeviceId = DeviceTriggerTest.createDevice(acctId, opptyProgramId);
        string baseDeviceId = DeviceUtilTest.createCustomerMPWDevice(acctId, opptyProgramId);
        
        
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
            device.Base_Device__c = baseDeviceId;
            device.End_Application__c = 'Body';
        //  test.startTest();  
            insert device;
        test.stopTest();
    }
    
    //test Method for Internal Device
    static testMethod void testCreateInternalDevice(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        
        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        //insert account;
        System.debug('account====='+account);
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        Test.startTest();
        Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(),'1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
        device.Reticle_Type__c ='Single Layer Reticle (SLR)';
        device.Device_Mask_Set_Title__c ='TESTMST123';
        device.Enabled_via_previous_MPW_1__c ='No'; 
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        string opptyId = DeviceTriggerTest.createOpp(account.Id, '0.10UM');
        string opptyProgramId = DeviceTriggerTest.createOppProg(account.Id, opptyId);
        device.Opportunity2__c = opptyId;
        device.Opportunity_Program__c = opptyProgramId;
        //Test.startTest();
        insert device;
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}