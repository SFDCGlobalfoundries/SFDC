/*
    Author: Deepti Narayan Biswal
    Description: Test class for PSP_createExtensionQuarterly
    History:
        DBiswal     01222015    - Created Test class.                         
*/
@isTest
private class PSP_createExtensionQuarterlyTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
    }
    
    static Fab__c createFab(String fabName){
        Fab__c fabRec = new Fab__c();
        fabRec.name = fabName;
        fabRec.isActive__c = true;
        try{
            insert fabRec;
        }catch(exception e){
        }
        return fabRec;
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
        testAcct.Name = 'Test Account15';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department5';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 5';
        testAcct.Corporate_Address_1__c = 'Corporate Address 5';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct5N';
        try{
            insert testAcct;
        }catch(exception e){
        }
        return testAcct;
    }
        
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity5';
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
            
            testOppty.Siebel_Opportunity_ID__c = '123123123155';        
            Update testOppty;
        }catch(exception e){
        }
        return testOppty.Id;
    }
    
    static Id createOpportunityProgram(Id testAcctId, Id testOpptyId){
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program5';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId; 
        try{       
            Insert testOpptyProgram;        
        }catch(exception e){
        }
        return testOpptyProgram.Id;
    }
    
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSPSPT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        try{
            insert mst;
        }catch(exception e){
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
        }
        return mstAcc.Id;
    }
    
    static Device__c createDevice(Id testAcctId, Id testOpptyProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVICEZAIH123454545';
        device.Opportunity_Program__c = testOpptyProgramId;
        device.Fab__c = 'FAB 2';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234567895';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        //device.Device_Mask_Set_Title__c = 'DVMST12355';
        device.CRMDID__c = 'CDID0000001.05';
        device.Device_Type__c = 'Base';
        device.Internal_Device_Geometry__c = '0.028UM';
        device.Internal_Device_Process_Family__c = 'MEMS';
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
        device.Proto_Wafer_First_Lot_Start_Current__c = System.today() + 5;
        device.Proto_Wafer_Fab_Shipped_Current__c = System.today() + 10;
        device.Assembled_Tested_Part_Shipped_Current__c = System.today() + 15;
        device.Production_Wafer_Start_Current__c = System.today() + 25;
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        try{
            Insert device;        
        }catch(exception e){
        }
        return device;
    }    
    
    static Device__c createDevice1(Id testAcctId, Id testOppProgramId) {
        // Create Device
        Device__c device = new Device__c();
        device.Name = 'TESTDEVTR452RE345677';
        device.Opportunity_Program__c = testOppProgramId;
        device.Fab__c = 'FAB 9';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234247890';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60AC45CH-U01';
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
        device.Proto_Wafer_First_Lot_Start_Current__c = System.today() + 5;
        device.Proto_Wafer_Fab_Shipped_Current__c = System.today() + 10;
        device.Assembled_Tested_Part_Shipped_Current__c = System.today() + 15;
        device.Production_Wafer_Start_Current__c = System.today() + 25;
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        device.Product_Line__c = 'ASIC';
        device.Device_Purpose__c = 'Customer Test Chip';
        device.Project_Name__c = 'test';
        device.Deliverable_Type__c = 'Chip';
        device.Internal_Device_Geometry__c = '0.055UM';
        device.Internal_Device_Process_Family__c = 'Generic / Nominal';
        try{
            Insert device;
        }catch(exception e){
        }
        return device;
    } 
    
    static testMethod void test_noPSPDate() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId    = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        //String mstId = PSP_createExtensionQuarterlyTest.createMaskSetTtitle();
        //String mstaccId =  PSP_createExtensionQuarterlyTest.createMSTAccount(testAcct1.Id,mstId);
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice1(testAcct1.Id, testOpptyProgramId);
        testDevice.Forecasted_Proto_Date__c = NULL;
        testDevice.Forecasted_RTP_Date__c = NULL;
        testDevice.Forecasted_Production_Start_Date__c = NULL;
        try{
            update testDevice;
        }catch(exception e){
        }
        //createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.lstPSPwaferQTRTTLCost = new List<PSP_createExtensionQuarterly.QuarterlyTotal>();
            dlc.lstPSPturnkeyQTRTTLCost = new List<PSP_createExtensionQuarterly.QuarterlyTotal>();
            dlc.lstPSPTurnkeyRev = new List<PSP_createExtensionQuarterly.QuarterlyTotal>();
        test.stopTest();    
                        
    }
    
    static testMethod void test_newPSPs() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        //String mstId = PSP_createExtensionQuarterlyTest.createMaskSetTtitle();
        //String mstaccId =  PSP_createExtensionQuarterlyTest.createMSTAccount(testAcct1.Id,mstId);
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice  );
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
        test.stopTest();    
                        
    }
        
    static testMethod void test_updatingwPSPs() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
            dlc.callRecords();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-07-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        
        upsert testDevice;
        
        testDevice = [SELECT id,Name,Opportunity_ID__c,Opportunity_Program__c,Fab__c,GSOP_Assignment_Tapeout_Plan__c,Market_Segment__c,Semiconductor_Device__c,
                      End_Customer__c,Device_Sourcing__c,Stage__c,Status__c,Siebel_Device_ID__c,Tapeout_Type__c,PLM_Device_ID__c,Device_Mask_Set_Title__c,
                      CRMDID__c,Device_Type__c,Forecasted_Lot_Start_Date__c,Product_TO_Date__c,Sample_Delivery_Date__c,Forecasted_Proto_Date__c,
                      Forecasted_RTP_Date__c,Forecasted_Production_Start_Date__c,Proto_DPML__c,PreProd_Prod_DPML__c,Production_DPML__c,No_of_Mask_Layers__c,
                      Display_in_PSP__c,End_Application__c,Original_Forecasted_Tapeout_Date__c,Enabled_via_previous_MPW_1__c,Confidence_Level_Tapeout__c,
                      Duration_before_Proto_Start__c ,Duration_of_Proto_Phase__c,Duration_of_PreProd_Phase__c,Assembled_Tested_Part_Shipped_Current__c,
                      End_Customer_Qual_Complete_Current__c,Production_Wafer_Start_Current__c,Proto_Wafer_Fab_Shipped_Current__c,Proto_Wafer_First_Lot_Start_Current__c,
                      Respin_Impact_to_Schedule_Current__c,Risk_Wafer_Shipped_Current__c,Risk_Wafer_Start_Current__c FROM Device__c where id=:testDevice.Id];
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate2() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-06-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate3() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-08-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.overrideWaferOut = false;
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate4() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-09-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate5() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-10-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate6() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-11-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate7() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-12-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate8() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2016-04-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate9() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2017-01-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate10() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2017-02-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    static testMethod void test_newPSPwithNextYearDate11() {
        TriggerHandler.bypass('Device_TriggerHandler');
        TriggerHandler.bypass('Opportunity_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        
        Quarterly_Revenue_Object__c qro1 = new Quarterly_Revenue_Object__c(Opportunity__c= testOpptyId ,Date__c=date.newinstance(2014, 1, 17),Fiscal_Quarter__c='2014-Q1',ASP__c=500,Volume__c=600, count__c = true);
        Quarterly_Revenue_Object__c qro2 = new Quarterly_Revenue_Object__c(Opportunity__c= testOpptyId ,Date__c=date.newinstance(2014, 4, 17),Fiscal_Quarter__c='2014-Q2',ASP__c=500,Volume__c=600, count__c = true);
        Quarterly_Revenue_Object__c qro3 = new Quarterly_Revenue_Object__c(Opportunity__c= testOpptyId ,Date__c=date.newinstance(2014, 7, 17),Fiscal_Quarter__c='2014-Q3',ASP__c=500,Volume__c=600, count__c = true);
        Quarterly_Revenue_Object__c qro4 = new Quarterly_Revenue_Object__c(Opportunity__c= testOpptyId ,Date__c=date.newinstance(2014, 10, 17),Fiscal_Quarter__c='2014-Q4',ASP__c=500,Volume__c=600, count__c = true);
        List<Quarterly_Revenue_Object__c> qtrRevlist = new List<Quarterly_Revenue_Object__c>{qro1,qro2,qro3,qro4};
        try{
            insert qtrRevlist;
        }catch(exception e){
        }
        test.startTest();
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Product_TO_Date__c = date.valueof('2014-04-21');
        testDevice.Sample_Delivery_Date__c = date.valueof('2014-08-16');
        testDevice.Forecasted_Proto_Date__c = date.valueof('2015-01-21');
        testDevice.Forecasted_RTP_Date__c = date.valueof('2016-03-16');
        testDevice.Forecasted_Production_Start_Date__c = date.valueof('2017-03-01');
        testDevice.Proto_DPML__c = 0.8;
        testDevice.PreProd_Prod_DPML__c = 1.9;
        testDevice.Production_DPML__c = 2.8;        
        testDevice.No_of_Mask_Layers__c = 60;
        try{
            update testDevice;
        }catch(exception e){
        }
        
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
            dlc.calculateoppWaferOut();
            PageReference pageRef1 = dlc.MonthlyView();
        test.stopTest();    
    }
    
    static testMethod void test_addNewYear1() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice  );
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
            dlc.addNewYear();
            dlc.ExportDevicePSP();
            dlc.removeYear();
        test.stopTest();    
    }
    
    static testMethod void test_Exceptions1() {
        TriggerHandler.bypass('Device_TriggerHandler');
        Account testAcct1         = PSP_createExtensionQuarterlyTest.createAccount();
        String testOpptyId        = PSP_createExtensionQuarterlyTest.createOpportunity(testAcct1.Id);
        String testOpptyProgramId = PSP_createExtensionQuarterlyTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        
        Device__c testDevice      = PSP_createExtensionQuarterlyTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
        testDevice.Production_DPML__c = 0.6;
        testDevice.PreProd_Prod_DPML__c = 0.8;
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_createQuarterly;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtensionQuarterly dlc = new PSP_createExtensionQuarterly(controller);
            dlc.SaveCustom();
            dlc.addNewYear();
            dlc.ExportDevicePSP();
        test.stopTest();
    }
    
    public static void createPSPdata(Device__c dev){
        List<DevicePSPData__c> lstPSPRecords = new List<DevicePSPData__c>();
        integer startYear;
        integer endYear;
        List<String> lstPickvals = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('DevicePSPData__c');
        sObject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getsObjectType();
        Schema.DescribeSObjectResult sobject_describe = sObject_type.getDescribe();
        Map<String, Schema.sObjectField> field_map = sObject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Phase__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values){ 
            lstPickvals.add(a.getValue());
        }
        
        startYear = dev.Product_TO_Date__c.Year();
        endYear   = dev.Forecasted_Production_Start_Date__c.Year();
        for(integer i=startYear;i<=endYear;i++){
            for(String phaseVal: lstPickvals){
                DevicePSPData__c pspRecord = new DevicePSPData__c();
                pspRecord.Device__c = dev.Id;
                pspRecord.Phase__c  = phaseVal;
                pspRecord.Year__c   = i;
                if(phaseVal == 'Prototype Wafer Start'){
                    pspRecord.Phase_Number__c = 1;
                }else if(phaseVal == 'Prototype Wafer Out'){
                    pspRecord.Phase_Number__c = 2;
                }else if(phaseVal == 'Prototype Wafer ASP'){
                    pspRecord.Phase_Number__c = 3;
                }else if(phaseVal == 'Production Wafer Start'){
                    pspRecord.Phase_Number__c = 4;
                }else if(phaseVal == 'Production Wafer Out'){
                    pspRecord.Phase_Number__c = 5;
                }else if(phaseVal == 'Production Wafer ASP'){
                    pspRecord.Phase_Number__c = 6;
                }
                    pspRecord.Month_1__c = 0;
                    pspRecord.Month_2__c = 0;
                    pspRecord.Month_3__c = 0;
                    pspRecord.Month_4__c = 0;
                    pspRecord.Month_5__c = 0;
                    pspRecord.Month_6__c = 0;
                    pspRecord.Month_7__c = 0;
                    pspRecord.Month_8__c = 0;
                    pspRecord.Month_9__c = 0;
                    pspRecord.Month_10__c = 0;
                    pspRecord.Month_11__c = 0;
                    pspRecord.Month_12__c = 0;
                    
                    lstPSPRecords.add(pspRecord);                                                
            }
        }
        try{
            database.insert(lstPSPRecords);
        }catch(exception e){
        }
    }
}