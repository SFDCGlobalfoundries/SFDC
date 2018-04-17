/*
*   Author: Pradosh Samal
*   Description:  This class is used as Test class for ManufacLotUpdateDeviceBatchTest
*   History: 
*   Pradosh      28/06/2016    - Apex code created
*                
*/

@isTest(seeAllData = false)
public class ManufacLotUpdateDeviceBatchTest{
    @testSetup static void testdata() {
        Test.startTest();
        
        DataUtilTest.loadEnvironmentVariables();
        
        Test.stopTest();
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
            Device__c device = new Device__c();
            device.Account__c = testAcct.Id;
            device.Name = 'TestDevice' + String.valueOf(DateTime.now().getTime());
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
            //device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device.Device_Mask_Set_Title__c = 'MSTTRT';
            device.CRMDID__c = 'CDID0000001.00';
            device.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            device.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            device.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            device.Confidence_Level_Tapeout__c = '100';
            device.Device_Type__c = 'Base';
            device.End_Application__c = 'Body';
            
            device.PLM_Device_ID__c = '11261-SP01';
            device.Proto_Lot_Start_ID__c = null;
            device.Proto_Lot_Start_Date__c = null;
            insert device;
            
            Device__c device2 = new Device__c();
            device2.Account__c = testAcct.Id;
            device2.Name = 'TestDevice1' + String.valueOf(DateTime.now().getTime());
            device2.Opportunity_Program__c = opptyProgramId ;
            device2.Fab__c = 'FAB 2';
            device2.GSOP_Assignment_Tapeout_Plan__c = 'No';
            device2.Market_Segment__c = 'Automotive';
            device2.Semiconductor_Device__c = 'Analog Amplifier';
            device2.End_Customer__c = 'Test Customer';
            device2.Device_Sourcing__c = '1st Source';
            device2.Stage__c = 'Design In';
            device2.Status__c = 'Active';
            device2.Siebel_Device_ID__c = '1234567890';
            device2.Tapeout_Type__c = 'Full Layer Retrofit';
            //device2.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
            device2.Device_Mask_Set_Title__c = 'MSTTRT';
            device2.CRMDID__c = 'CDID00000011.00';
            device2.Actual_Tapeout_Date__c = date.newInstance(2013,5,20);
            device2.Original_Forecasted_Tapeout_Date__c = date.newInstance(2013,5,20);
            device2.Current_Forecast_Tapeout_Date__c = date.newInstance(2013,3,4);
            device2.Confidence_Level_Tapeout__c = '100';
            device2.Device_Type__c = 'Base';
            device2.End_Application__c = 'Body';
            
            device2.PLM_Device_ID__c = '11261-U04';
            device2.Proto_Lot_Start_ID__c = null;
            device2.Proto_Lot_Start_Date__c = null;
            insert device2;
            
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
            
            ManufacLotUpdateDeviceBatch obj = new ManufacLotUpdateDeviceBatch();
            DataBase.executebatch(obj, 200);
            
            Test.stopTest();
        }
        catch(Exception e){
        }
     }
}