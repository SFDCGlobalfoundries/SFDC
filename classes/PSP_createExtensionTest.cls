/*
    Author: Nikhil Jain
    Description: Test class for PSP_createExtension
    History:
        NJain 01/15/2014    - New Test class.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Ashwini     04012015    - Refactoring test class.                          
*/
@isTest
private class PSP_createExtensionTest{
    
    static Account testAcct1 = new Account();
    static String testOpptyId = '';
    static String testOpptyProgramId = '';
    static Device__c testDevice = new Device__c();
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
        fieldValueMap.put('Short_Name__c','TAC1');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Account createAccount() {
       
        Account testAcct = getAccount('MYTEST ACCOUNT1');
        
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
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        try{
            Insert testOppty;
        }catch(exception e){
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
        }
        return testOpptyProgram.Id;
    }
    
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTPSPT';
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
    
    static Device__c createDevice(Id testAcctId, Id testOppProgramId) {
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
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        //device.Device_Mask_Set_Title__c = 'DVMST12345';
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
        device.Internal_Device_Geometry__c = '0.055UM';
        device.Internal_Device_Process_Family__c = 'Generic / Nominal';
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
        device.Name = 'TESTDEVICEZ4RE345677';
        device.Opportunity_Program__c = testOppProgramId;
        device.Fab__c = 'FAB 9';
        device.GSOP_Assignment_Tapeout_Plan__c = 'No';
        device.Market_Segment__c = 'Mobility';
        device.Semiconductor_Device__c = 'Analog Amplifier';
        device.End_Customer__c = 'Test Customer';
        device.Device_Sourcing__c = '1st Source';
        device.Stage__c = 'Design In';
        device.Status__c = 'Active';
        device.Siebel_Device_ID__c = '1234547890';
        device.Tapeout_Type__c = 'Single Product';
        device.PLM_Device_ID__c = 'ANBQP60ACO8CH-U01';
        //device.Device_Mask_Set_Title__c = 'DVMST12345';
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
    
    static testMethod void test_noPSPDates() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
            testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
            
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.QuarterlyView();
            dlc.previewPower();
            dlc.resetPreview();
        test.stopTest();    
                        
    }
    
    static testMethod void test_newPSP() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
        test.stopTest();    
                        
    }
        
    static testMethod void test_updatingwPSP() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);     
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    
    static testMethod void test_newPSPwithNextYearDates11() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        
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
        
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.SaveCustom();
            PageReference pageRef1 = dlc.QuarterlyView();
            dlc.setQuarterlyvalue();
        test.stopTest();    
    }
    
    static testMethod void test_addNewYear() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.SaveCustom();
            dlc.addNewYear();
            dlc.ExportDevicePSP();
            dlc.removeYear();
        test.stopTest();    
    }
    
    static testMethod void test_Exceptions() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        testDevice.Production_DPML__c = 3;
        testDevice.PreProd_Prod_DPML__c = 5;
        testDevice.No_of_Mask_Layers__c = 20;        
        
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.SaveCustom();
            dlc.addNewYear();
            dlc.ExportDevicePSP();
            dlc.previewPower();
            dlc.copyOppWaferOuts();
            dlc.addNewYearwithoutInsert(dlc.lstproductionWaferOuts);
        test.stopTest();
    }
    
    static testMethod void test_asicPSP() {
        TriggerHandler.bypass('Device_TriggerHandler');
        testAcct1 = PSP_createExtensionTest.createAccount();
        testOpptyId = PSP_createExtensionTest.createOpportunity(testAcct1.Id);
        testOpptyProgramId = PSP_createExtensionTest.createOpportunityProgram(testAcct1.Id, testOpptyId);
        test.startTest();
        testDevice = PSP_createExtensionTest.createDevice1(testAcct1.Id, testOpptyProgramId);
        createPSPdata(testDevice);
        
            PageReference pageRef = Page.PSP_create;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(testDevice);
            PSP_createExtension dlc = new PSP_createExtension(controller);
            dlc.SaveCustom();
        test.stopTest();    
    }
    
    public static void createPSPdata(Device__c dev){
        try{
            database.delete([select id from DevicePSPData__c where Device__c =: dev.Id]);
        }catch(exception e){
        }
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
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}