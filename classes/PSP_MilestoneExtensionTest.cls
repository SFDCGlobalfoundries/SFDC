/*
    Author: Deepti Narayan Biswal
    Description: Test class for PSP_MilestoneExtension
    History:
        DBiswal    02112016    Created.
		DBiswal	   07212017	   Modified for test class failure fix.
*/
@isTest
private class PSP_MilestoneExtensionTest{
    
    static Account testAcct1 = new Account();
    static String testOpptyId;
    static String testOpptyProgramId;
    static Device__c testDevice = new Device__c();
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
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
        try{
            insert testAcct;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createAccount','', 'Exception while inserting Account Record', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
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
        try{
            Insert testOppty;
            
            testOppty.Siebel_Opportunity_ID__c = '123123123123';        
            Update testOppty;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createOpportunity','', 'Exception in Opportunity DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }        
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOppId){
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;        
        try{
            Insert testOpptyProgram;        
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createOpportunityProgram','', 'Exception in Opportunity Program DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        return testOpptyProgram.Id;
    }
    
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'PSPMST0';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        try{
            insert mst;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createMaskSetTtitle','', 'Exception in Mask set title DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        return mst.Id;
    }
    
    static Id createMSTAccount(Id acctId, Id MSTId){
        MSTAccount__c mstAcc = new MSTAccount__c();
        mstAcc.Account__c = acctId;
        mstAcc.Mask_Set_Title__c = MSTId;
        try{
            insert mstAcc;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createMSTAccount','', 'Exception in Mask set title Account DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        return mstAcc.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOppProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEYesPSP3456';
        device.Opportunity_Program__c = testOppProgramId;
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
        //device.Device_Mask_Set_Title__c = 'DVMST12';
        device.CRMDID__c = 'CDID0000001.00';
        device.Device_Type__c = 'Base';
        device.Internal_Device_Geometry__c = '0.028UM';
        device.Internal_Device_Process_Family__c = 'MEMS';
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
        try{
            Insert device;        
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'createDevice','', 'Exception in Device DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        return device;
    }    
    
    static testMethod void test_noPSPDates1() {
        testAcct1 = PSP_MilestoneExtensionTest.createAccount();
        testOpptyId = PSP_MilestoneExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_MilestoneExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        //String mstId = PSP_MilestoneExtensionTest.createMaskSetTtitle();
        String mstId = DeviceUtilTest.createMaskSetTtitle();
        String mstaccId =  PSP_MilestoneExtensionTest.createMSTAccount(testAcct1.Id,mstId);
        //testDevice = PSP_MilestoneExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        String deviceId = DeviceUtilTest.createCustomerMPWDevice(testAcct1.Id, testOpptyProgramId);
        testDevice = new Device__c(Id = deviceId);
        
            PageReference pageRef = Page.PSP_Milestone;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_MilestoneExtension dlc = new PSP_MilestoneExtension(controller);
            PSP_MilestoneExtension.milestoneWrapper mw = new PSP_MilestoneExtension.milestoneWrapper(testDevice,'s','s','s',System.Today(),System.Today(),'s',true);
            dlc.userId = UserInfo.getUserId();
            dlc.lockdate = System.Today();
            dlc.cancel();            
            dlc.switchviewmethod();
            dlc.refreshforecastedDate();
            dlc.updateCEmethod();
            dlc.lockDates();
            dlc.unlockDates();
            dlc.reset();
            pageReference p1 = dlc.redirectPSPCreate();
			System.assert(p1 != null);
        test.stoptest();                            
    }
    
    static testMethod void test_noPSPDates2() {
        testAcct1 = PSP_MilestoneExtensionTest.createAccount();
        testOpptyId = PSP_MilestoneExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_MilestoneExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
                
        //String mstId = PSP_MilestoneExtensionTest.createMaskSetTtitle();
        String mstId = DeviceUtilTest.createMaskSetTtitle();
        String mstaccId =  PSP_MilestoneExtensionTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
        //testDevice = PSP_MilestoneExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        String deviceId = DeviceUtilTest.createCustomerMPWDevice(testAcct1.Id, testOpptyProgramId);
        testDevice = new Device__c(Id = deviceId);
        
        testDevice.PSP_Dates_Locked__c = true;
        testDevice.CE_assigned_for_PSP__c = Userinfo.getuserId();
        testDevice.Proto_Wafer_First_Lot_Start_Current__c = System.Today()+10;
        testDevice.Proto_Wafer_Fab_Shipped_Current__c = System.Today()+30;
        testDevice.Assembled_Tested_Part_Shipped_Current__c = System.Today()+50;
        testDevice.Production_Wafer_Start_Current__c = System.Today()+100;
        try{
            update testDevice;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'test_noPSPDates2','', 'Exception in Device DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        
            PageReference pageRef = Page.PSP_Milestone;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_MilestoneExtension dlc = new PSP_MilestoneExtension(controller);
            PSP_MilestoneExtension.milestoneWrapper mw = new PSP_MilestoneExtension.milestoneWrapper(testDevice,'s','s','s',System.Today(),System.Today(),'s',true);
            dlc.userId = UserInfo.getUserId();
            dlc.editStatus();
            dlc.updateStatus();
            dlc.lockDates();
            pageReference p1 = dlc.fetchArchieves();
			System.AssertEquals(p1, null);
        test.stoptest();                            
    }
    
    static testMethod void test_noPSPDates3() {
        testAcct1 = PSP_MilestoneExtensionTest.createAccount();
        testOpptyId = PSP_MilestoneExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_MilestoneExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
                
        //String mstId = PSP_MilestoneExtensionTest.createMaskSetTtitle();
        String mstId = DeviceUtilTest.createMaskSetTtitle();
        String mstaccId =  PSP_MilestoneExtensionTest.createMSTAccount(testAcct1.Id,mstId);
        test.startTest();
        //testDevice = PSP_MilestoneExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        String deviceId = DeviceUtilTest.createCustomerMPWDevice(testAcct1.Id, testOpptyProgramId);
        testDevice = new Device__c(Id = deviceId);
        testDevice.Product_Line__c = 'ASIC';
		testDevice.Device_Purpose__c = 'Customer Test Chip';
        testDevice.Project_Name__c = 'test';
        testDevice.PSP_Dates_Locked__c = true;
        testDevice.CE_assigned_for_PSP__c = Userinfo.getuserId();
        testDevice.Proto_Wafer_First_Lot_Start_Current__c = System.Today()+10;
        testDevice.Proto_Wafer_Fab_Shipped_Current__c = System.Today()+30;
        testDevice.Assembled_Tested_Part_Shipped_Current__c = System.Today()+50;
        testDevice.Production_Wafer_Start_Current__c = System.Today()+100;
        try{
            update testDevice;
        }catch(exception e){
			GlobalUtility.logMessage('Error', 'PSP_MilestoneExtensionTest', 'test_noPSPDates3','', 'Exception in Device DML', String.valueof(e.getMessage()),'','Device Management',e,0);
        }
        
            PageReference pageRef = Page.PSP_Milestone;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_MilestoneExtension dlc = new PSP_MilestoneExtension(controller);
            PSP_MilestoneExtension.milestoneWrapper mw = new PSP_MilestoneExtension.milestoneWrapper(testDevice,'s','s','s',System.Today(),System.Today(),'s',true);
            dlc.userId = UserInfo.getUserId();
			System.AssertEquals(dlc.userId, UserInfo.getUserId());
            dlc.fetchArchieves();
        test.stoptest();                            
    }
    
    static testMethod void test_noPSPDates4() {
        testAcct1 = PSP_MilestoneExtensionTest.createAccount();
        testOpptyId = PSP_MilestoneExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_MilestoneExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
                
        //String mstId = PSP_MilestoneExtensionTest.createMaskSetTtitle();
        String mstId = DeviceUtilTest.createMaskSetTtitle();
        String mstaccId =  PSP_MilestoneExtensionTest.createMSTAccount(testAcct1.Id,mstId);
        TriggerHandler.bypass('Device_TriggerHandler');
        //testDevice = PSP_MilestoneExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        testDevice = PSP_MilestoneExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        //testDevice = new Device__c(Id = deviceId);
        testDevice.Product_Line__c = 'ASIC';
        testDevice.Device_Purpose__c = 'Customer Test Chip';
        testDevice.Project_Name__c = 'test';
        testDevice.PSP_Dates_Locked__c = true;
        testDevice.CE_assigned_for_PSP__c = Userinfo.getuserId();
        testDevice.Proto_Wafer_First_Lot_Start_Current__c = System.Today()+10;
        testDevice.Proto_Wafer_Fab_Shipped_Current__c = System.Today()+30;
        testDevice.Assembled_Tested_Part_Shipped_Current__c = System.Today()+50;
        testDevice.Production_Wafer_Start_Current__c = System.Today()+100;
        //update testDevice;
        
        test.startTest();
        DeviceUtilTest.createRetrofitDevice1(testDevice.Id);
        
            PageReference pageRef = Page.PSP_Milestone;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_MilestoneExtension dlc = new PSP_MilestoneExtension(controller);
            PSP_MilestoneExtension.milestoneWrapper mw = new PSP_MilestoneExtension.milestoneWrapper(testDevice,'s','s','s',System.Today(),System.Today(),'s',true);
            dlc.userId = UserInfo.getUserId();
            dlc.refreshRevDates();
            dlc.refreshRevpanel();
            pageReference p1 = dlc.saveRevDates();
			System.AssertEquals(p1, null);
        test.stoptest();                            
    }    
}