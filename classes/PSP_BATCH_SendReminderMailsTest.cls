/*
    Author: Deepti Narayan Biswal
    Description: Test class for PSP_BATCH_SendReminderMails
    History:
        DBiswal    05192016    Created.
*/
@isTest
private class PSP_BATCH_SendReminderMailsTest{
    
    static Account testAcct1 = new Account();
    static String testOpptyId = '';
    static String testOpptyProgramId = '';
    static Device__c testDevice = new Device__c();
    static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    static Account createAccount() {
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
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
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct1N';
        
        insert testAcct;
        
        return testAcct;
    }
        
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = testAcctId;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';        
        testOppty.X1st_Product_Production_Date__c = System.Today();
        testOppty.Years_of_Production__c = 3;
        Insert testOppty;
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';        
        Update testOppty;
        
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOppId){
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        Insert testOpptyProgram;        
        return testOpptyProgram.Id;
    }
    
    static Id createMaskSetTtitle(){
        Map<String, String> mstMap = new Map<String, String>();
        mstMap.put('Name', 'MSTRYP0');
        mstMap.put('Reticle_Type__c', 'Multi Layer Reticle (MLR)');
        
        Mask_Set_Title__c mst = MaskSetTitleDataFactory.createMaskSetTitle(mstMap);
        
        return mst.Id;
    }
    
    static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId; 
        insert mstAcc;
        return mstAcc.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOppProgramId) {
       
        Device__c device = new Device__c();
        device.Account__c = testAcctId;
        device.Name = 'TESTDEVICEZAIH12345677';
        device.Opportunity_Program__c = testOppProgramId ;
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
        device.Device_Mask_Set_Title__c = 'MSTRYP0';
        device.Confidence_Level_Tapeout__c = '100';
        device.Original_Forecasted_Tapeout_Date__c = date.today().addDays(7);
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        device.End_Application__c = 'Body';
        
        /*
        // Create Device
        Device__c device = new Device__c();
        device.Account__c = testAcctId;
        device.Name = 'TESTDEVICEYesPSP3456';
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
        device.Device_Mask_Set_Title__c = 'DVMST12345';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        
        device.Product_TO_Date__c = System.Today()+1;
        device.Proto_Lot_Start_Date__c = System.Today()+10;
        device.Proto_Wafer_Fab_Shipped_Date__c = System.Today()+20;
        device.Forecasted_Proto_Date__c = System.Today()+30;
        device.Respin_Date__c = System.Today()+40;
        device.Forecasted_RTP_Date__c = System.Today()+50;
        device.Risk_Wafer_Shipped_Date__c = System.Today()+60;
        device.End_Customer_Qual_Complete_Date__c = System.Today()+70;
        device.Forecasted_Production_Start_Date__c = System.Today()+100;
        device.Proto_DPML__c = 0.8;
        device.PreProd_Prod_DPML__c = 1.9;
        device.Production_DPML__c = 2.8;        
        device.No_of_Mask_Layers__c = 60;
        device.Display_in_PSP__c = true; 
        device.End_Application__c = 'Body';
        device.Original_Forecasted_Tapeout_Date__c = System.today();
        device.Enabled_via_previous_MPW_1__c = 'No';
        device.Confidence_Level_Tapeout__c = '100';
        device.PSP_to_be_Locked_by_Date__c = Date.today();
        device.Device_Mask_Set_Title__c = 'MSTRYP0';
        device.Proto_Wafer_First_Lot_Start_Current__c = Date.today().addDays(-45);
        device.Product_TO_Current__c = Date.today().addDays(-50);
        device.Proto_Wafer_Fab_Shipped_Current__c = Date.today().addDays(-40);
        device.Assembled_Tested_Part_Shipped_Current__c = Date.today().addDays(-35);
        device.Respin_Impact_to_Schedule_Current__c = Date.today().addDays(-30);
        device.Risk_Wafer_Start_Current__c = Date.today().addDays(-25);
        device.Risk_Wafer_Shipped_Current__c = Date.today().addDays(-20);
        device.End_Customer_Qual_Complete_Current__c = Date.today().addDays(-15);
        device.Production_Wafer_Start_Current__c = Date.today().addDays(-10);
        device.PSP_Dates_Locked__c = false;
        device.reticle_type__c = 'Small Field Reticle (SFR)';
        */
        Insert device;        
        return device;
    }    
    
    static testMethod void test_noPSPDates1() {
        DataUtilTest.loadEnvironmentVariables();
        testAcct1 = PSP_BATCH_SendReminderMailsTest.createAccount();
        testOpptyId = PSP_BATCH_SendReminderMailsTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_BATCH_SendReminderMailsTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        String mstId = PSP_BATCH_SendReminderMailsTest.createMaskSetTtitle();
        String mstaccId =  PSP_BATCH_SendReminderMailsTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
            testDevice = PSP_BATCH_SendReminderMailsTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
            PSP_BATCH_SendReminderMails pspremindertest = new PSP_BATCH_SendReminderMails();
            System.schedule('pspreminder test', CRON_EXP, pspremindertest); 
        test.stoptest();                            
    }
    
}