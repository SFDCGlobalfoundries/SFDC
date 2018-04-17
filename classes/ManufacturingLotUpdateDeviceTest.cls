/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for ManufacturingLotUpdateDevice.
    History: 
        ZAmbat      12292014    - Code creation.
*/

@isTest(SeeAllData = false)
public class ManufacturingLotUpdateDeviceTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER')); 
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Id createAccount() {
        Account testAcct = getAccount('Test Account 007'); 
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.055UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
       
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        insert testOpptyProgram;
        return testOpptyProgram.Id;
    }
    
   /* static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Solutioning';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567890';
        device.Tapeout_Type__c = 'Customer MPW';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        device.Device_Mask_Set_Title__c = 'DVMST12345';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.PTRF_ID__c = 'PTRF123';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.today();
        device.End_Application__c = 'Body';
        //device.Process_Technology_2__c = testPTId;
        insert device;
        return device;
    }
    */
    static List<Manufacturing_Lot__c> createManufacturingLot(Id accountId) {
        List<Manufacturing_Lot__c> listML = new List<Manufacturing_Lot__c>();
        for (integer i=1; i<=21; i++) {    
            Manufacturing_Lot__c m = new Manufacturing_Lot__c();
            m.Account_Name__c = accountId;
            m.Name = 'testManufacturingLotZ.' + i;
            if (i <= 5) {
                m.Lot_Type__c = 'QD' + i;
                m.Last_Ship_Date__c = date.today().addDays(-3);
            } else if (i > 5 && i <= 10) {
                m.Lot_Type__c = 'QF1D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 10 && i <= 15) {
                m.Lot_Type__c = 'QF15D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 15 && i <= 20) {
                m.Lot_Type__c = 'QF30D' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            } else if (i > 20) {
                m.Lot_Type__c = 'ABC' + i;
                m.Last_Ship_Date__c = date.today().addDays(50);
            }
            m.Lot_Start_Date__c = datetime.now();
            m.Device_ID_MES__c = 'TESTMLDEVICE123Z';
            listML.add(m);
        }
        
        insert listML;
        return listML;
    }
    
    static List<Yield_Feedback__c> createYieldFeedback(Id accountId, Id deviceId, List<Manufacturing_Lot__c> listML) {
        List<Yield_Feedback__c> listYF = new List<Yield_Feedback__c>();
        for (Manufacturing_Lot__c l : listML) {
            if (l.Lot_Type__c.startsWith('QD') || l.Lot_Type__c.startsWith('QF')) {
                Yield_Feedback__c y = new Yield_Feedback__c();
                y.Account__c = accountId;
                y.Device__c = deviceId;
                y.Manufacturing_Lot__c = l.Id;
                y.Fab__c = 'FAB 2';
                y.First_Time_Not_Right__c = 'Fab issue';
                y.Functional__c = 'Yes';
                y.Lot_Purpose__c = 'Proto Lot';
                y.Sort_Yield__c = 1;
                if (l.Lot_Type__c.startsWith('QD')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today();
                } else if (l.Lot_Type__c.startsWith('QF1D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(1);
                } else if (l.Lot_Type__c.startsWith('QF15D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(15);
                } else if (l.Lot_Type__c.startsWith('QF30D')) {
                    y.Yield_Feedback_Due_Date_Modified__c = date.today().addDays(30);
                }
                listYF.add(y);
            }
        }
        
        insert listYF;
        return listYF;
    }
    
    static Id createMaskSetTitle(){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','MSTTRT1');
        fieldValueMap.put('Reticle_Type__c','Multi Layer Reticle (MLR)');
        return MaskSetTitleDataFactory.createMaskSetTitle(fieldValueMap).Id;
    }
    public static Device__c createCMPWDevice(Id acctId,Id opptyProgramId) {
        String MSTId = CreateMaskSetTitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId);
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Actual_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Current_Forecast_Tapeout_Date__c',date.newInstance(2013,3,4));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('PTRF_ID__c','PTRF123');
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        return DeviceDataFactory.createDevice(fieldValueMap);
    }
    
    static testMethod void testManufacturingLotUpdateDevice1() {
        string accountId = ManufacturingLotUpdateDeviceTest.createAccount();
        string opportunityId = ManufacturingLotUpdateDeviceTest.createOpportunity(accountId);
        string opptyProgramId = ManufacturingLotUpdateDeviceTest.createOpportunityProgram(accountId, opportunityId);
        
        
        test.startTest();
        
        Device__c device = createCMPWDevice(accountId,opptyProgramId);

        List<Manufacturing_Lot__c> listML = ManufacturingLotUpdateDeviceTest.createManufacturingLot(accountId);
        List<Yield_Feedback__c> listYF = ManufacturingLotUpdateDeviceTest.createYieldFeedback(accountId, device.Id, listML);
        
            set<string> setLotNames = new set<string>();
            for (Manufacturing_Lot__c m : listML) {
                setLotNames.add(m.Name);
            }
            
            ManufacturingLotUpdateDevice.updateDevices(setLotNames);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}