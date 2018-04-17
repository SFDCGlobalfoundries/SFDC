//Ashwini     05182015    - Updated code for making SeeAllData=false and refactoring of test class.
//Pradosh     06282016    - Updated code to reduce number of soql exception.

@isTest(seeAllData = false)
public class ManufacLotUpdateDeviceBatchSchedulerTest{
    @testSetup static void testdata() {
        Test.startTest();
        
        DataUtilTest.loadEnvironmentVariables();
        //string acctId = DeviceUtilTest.createAccount();
        //string opptyId = DeviceUtilTest.createOpp(acctId,'0.10UM');
        //string opptyProgramId = DeviceUtilTest.createOppProg(acctId,opptyId);
        //Device__c Device = DeviceUtilTest.createCMPWDevice(acctId,opptyProgramId);
        //Insert Device;
       // Device__c Device1 = DeviceUtilTest.createSPDevice3(acctId,opptyProgramId);
        //Insert Device1;
        Test.stopTest();
    }
    
    //@isTest public static void testBatch(){
        //DataUtilTest.loadEnvironmentVariables();
        ///*String testAcctId = createAccount();      
        //String testOpptyId = createOpportunity(testAcctId);
        //String testOpptyProgramId = createOpportunityProgram(testAcctId, testOpptyId);
        //Device__c testDevice = DeviceUtilTest.createDevice();
        //Device__c testDeviceSP = DeviceUtilTest.createSingleProductDevice();*/
        //Account testAcctId = [Select Id from Account where name = 'Test Account'];
        //Opportunity oppId =[Select Id from Opportunity where name = 'Test Opportunity'];
        //Opportunity_Program__c testOpptyProgramId = [Select Id from Opportunity_Program__c where name = 'Test Opportunity Program'];
        //Device__c testDevice = [Select Id from Device__c where name = 'TESTDEVICEZAIH12345677'];
        //Device__c testDeviceSP = [Select Id from Device__c where name = 'TESTDEVICESPPP'];
        //test.startTest();
        //createML(testAcctId.id);
        
        //String jobId = System.schedule('testMLScheduledApex','0 0 0 3 9 ? 2022', new ManufacLotUpdateDeviceBatchScheduler());
        
        ///*ManufacLotUpdateDeviceBatch b = new ManufacLotUpdateDeviceBatch(); 
        //Integer bSize = Integer.valueOf(Environment_Variable__c.getInstance('MANUFACTURE_LOT_BATCH_SIZE').value__c);
        //database.executebatch(b,bSize);*/
        //test.stopTest();
    //}
    
    static Id createAccount(/*id managerId*/) {
        // Create Account
        Account testAcct = new Account();
        testAcct.Name = 'Test Account' + String.valueOf(DateTime.now());
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        //testAcct.Account_Manager__c = managerId;
        Insert testAcct;
        return testAcct.Id;
    }
    
     static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram.Id;
    }
    
    
    
   /* static Device__c createDeviceSP(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        //device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Single Product';
        //device.Geometry_Filter__c = '0.09UM';
        //device.Process_Family_Filter__c = 'MEMS';
         device.PLM_Device_ID__c = '11261-SP01';
         device.End_Application__c = 'Body';
        Insert device;
        
        return device;
    }
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'Fab 3';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog - Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        //device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        //device.Geometry_Filter__c = '0.09UM';
        //device.Process_Family_Filter__c = 'MEMS';
        device.PLM_Device_ID__c = '11261-U04';
        device.End_Application__c = 'Body';
        Insert device;
        
        return device;
    }
    */
    static void createML(Id testAcctId) {
        
        Manufacturing_Lot__c m1 = new Manufacturing_Lot__c();
        m1.name = 'test';
        m1.Lot_Type__c = 'QD';
        m1.Account_Name__c = testAcctId;
        m1.Device_ID_R12__c = '11261-SP01';
        m1.Device_ID_MES__c = '11261-SP01';
        m1.Manufacturing_Lot_Id__c = 'test';
        m1.Lot_Start_Date__c = system.now();
        m1.Active_Flag__c = true;
        
        Manufacturing_Lot__c m2 = new Manufacturing_Lot__c();
        m2.name = 'test2';
        m2.Lot_Type__c = 'QX';
        m2.Account_Name__c = testAcctId;
        m2.Device_ID_R12__c = '11261-U04';
        m2.Device_ID_MES__c = '11261-U04';
        m2.Manufacturing_Lot_Id__c = 'test2';
        m2.Lot_Start_Date__c = system.now();
        m2.Active_Flag__c = true;
        
        list <Manufacturing_Lot__c> mllist = new Manufacturing_Lot__c[]{m1, m2};
        insert mllist;
    }
    
     @isTest public static void runTest1(){
        try{
            Account testAcct = new Account();
            testAcct.Name = 'Test Account' + String.valueOf(DateTime.now());
            testAcct.Stage__c = 'Unqualified';
            testAcct.Site_Department__c = 'Test Department';
            testAcct.Sub_Type__c = 'Direct';
            testAcct.Transaction_Type__c = 'Transactional';
            testAcct.Region__c = 'APJ';
            testAcct.Bill_To_Address_1__c = 'Test Address 1';
            testAcct.Corporate_Address_1__c = 'Corporate Address 1';
            testAcct.Bill_To_City__c = 'Test City';
            testAcct.Corporate_City__c = 'Test City';
            testAcct.Bill_To_Country__c = 'Singapore';
            testAcct.Corporate_Country__c = 'Singapore';
            Insert testAcct;
            
            String opptyId = DeviceUtilTest.createOpp(testAcct.Id,'0.10UM');
            String opptyProgramId = DeviceUtilTest.createOppProg(testAcct.Id,opptyId);
            
            String MSTId = DeviceUtilTest.createMaskSetTtitle();
            String MSTAccId = DeviceUtilTest.createMSTAccount(testAcct.Id, MSTId);
            
            Test.startTest();
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Account__c',testAcct.Id);
            fieldValueMap.put('Name','TestDevice' + String.valueOf(DateTime.now().getTime()));
            fieldValueMap.put('Opportunity_Program__c',opptyProgramId) ;
            fieldValueMap.put('Fab__c','FAB 2');
            fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap.put('Market_Segment__c','Automotive');
            fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
            fieldValueMap.put('End_Customer__c','Test Customer');
            fieldValueMap.put('Device_Sourcing__c','1st Source');
            fieldValueMap.put('Stage__c','Design In');
            fieldValueMap.put('Status__c','Active');
            fieldValueMap.put('Siebel_Device_ID__c','1234567890');
            fieldValueMap.put('Tapeout_Type__c','Customer MPW');
            //fieldValueMap.put('PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT');
            fieldValueMap.put('CRMDID__c','CDID0000001.00');
            fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
            fieldValueMap.put('Confidence_Level_Tapeout__c','100');
            fieldValueMap.put('Device_Type__c','Base');
            fieldValueMap.put('End_Application__c','Body');
            
            fieldValueMap.put('PLM_Device_ID__c','11261-SP01');
            fieldValueMap.put('Proto_Lot_Start_ID__c',null);
            fieldValueMap.put('Proto_Lot_Start_Date__c',null);
            Device__c device = DeviceDataFactory.createDevice(fieldValueMap);
            
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();
            fieldValueMap1.put('Account__c', testAcct.Id);
            fieldValueMap1.put('Name','TestDevice1' + String.valueOf(DateTime.now().getTime()));
            fieldValueMap1.put('Opportunity_Program__c',opptyProgramId) ;
            fieldValueMap1.put('Fab__c','FAB 2');
            fieldValueMap1.put('GSOP_Assignment_Tapeout_Plan__c','No');
            fieldValueMap1.put('Market_Segment__c','Automotive');
            fieldValueMap1.put('Semiconductor_Device__c','Analog Amplifier');
            fieldValueMap1.put('End_Customer__c','Test Customer');
            fieldValueMap1.put('Device_Sourcing__c','1st Source');
            fieldValueMap1.put('Stage__c','Design In');
            fieldValueMap1.put('Status__c','Active');
            fieldValueMap1.put('Siebel_Device_ID__c','1234567890');
            fieldValueMap1.put('Tapeout_Type__c','Full Layer Retrofit');
            
            fieldValueMap1.put('Device_Mask_Set_Title__c','MSTTRT');
            fieldValueMap1.put('CRMDID__c','CDID00000011.00');
            fieldValueMap1.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap1.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
            fieldValueMap1.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
            fieldValueMap1.put('Confidence_Level_Tapeout__c','100');
            fieldValueMap1.put('Device_Type__c','Base');
            fieldValueMap1.put('End_Application__c','Body');
            
            fieldValueMap1.put('PLM_Device_ID__c','11261-U04');
            fieldValueMap1.put('Proto_Lot_Start_ID__c',null);
            fieldValueMap1.put('Proto_Lot_Start_Date__c',null);
            Device__c device2 = DeviceDataFactory.createDevice(fieldValueMap1);
            
            Manufacturing_Lot__c m1 = new Manufacturing_Lot__c();
            m1.name = 'test';
            m1.Lot_Type__c = 'QD';
            m1.Account_Name__c = testAcct.Id;
            m1.Device_ID_R12__c = '11261-SP01';
            m1.Device_ID_MES__c = '11261-SP01';
            m1.Manufacturing_Lot_Id__c = 'test';
            m1.Lot_Start_Date__c = system.now();
            m1.Active_Flag__c = true;
            
            Manufacturing_Lot__c m2 = new Manufacturing_Lot__c();
            m2.name = 'test2';
            m2.Lot_Type__c = 'QX';
            m2.Account_Name__c = testAcct.Id;
            m2.Device_ID_R12__c = '11261-U04';
            m2.Device_ID_MES__c = '11261-U04';
            m2.Manufacturing_Lot_Id__c = 'test2';
            m2.Lot_Start_Date__c = system.now();
            m2.Active_Flag__c = true;
            
            list <Manufacturing_Lot__c> mlList = new Manufacturing_Lot__c[]{m1, m2};
            insert mlList;
            
            String jobId = System.schedule('testMLScheduledApex','0 0 0 3 9 ? 2022', new ManufacLotUpdateDeviceBatchScheduler());
            
            Test.stopTest();
        }
        catch(Exception e){
        }
    }
}