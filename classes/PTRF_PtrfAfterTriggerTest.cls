/*
* @ Author          :- Navneet Rajput
* @ Organization    :- Cognizant Technology solutions
* @ Project         :- SwiftGen
* @ Description     :- Test Class handles Device validation,DeviceTapeout and partial calcelation of Device object on PTRF record inser/update operation.   
* @ Date            :- 5th May 2014
* @ Change History  :- Baij  16072014  Order_Date__c & Transaction_Type__C has been removed
        
        Vijay   08252014    updated and added testmethods to test the functionalities
        Vijay   04222015    refactored the test class
**/
 
@isTest(SeeAllData=false)
private class PTRF_PtrfAfterTriggerTest {

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    static ID createMaskSetTitle(){
           
        Mask_Set_Title__c maskSetTitle = new Mask_Set_Title__c();
        maskSetTitle.Name = 'MPW0010';
        maskSetTitle.Is_Available_For_Use__c=true;
        maskSetTitle.Status__c = 'Active';    
        
        insert maskSetTitle;
        return maskSetTitle.Id;
    }
    
    static void createChipDetails(Id pID,Id rTypeId){
        Chip_Detail__c chipDetails = new Chip_Detail__c();
        chipDetails.Tapeout__c=true;
        chipDetails.RecordTypeId=rTypeId;
        chipDetails.PTRF__c = pID;
        
        insert chipDetails;
    }
    
    // Create Mask Layer
    static Mask_Layer__c createMaskLayer(PTRF__c ptrf){
        
        Mask_Layer__c maskLayer = new Mask_Layer__c();
        maskLayer.Tapeout__c = true;
        maskLayer.Sort_Order__c =1;
        maskLayer.PTRF__c = ptrf.Id;
        
        insert maskLayer;
        return maskLayer;
    }
    
    // Create PTRF Record
    static PTRF__c createPTRF(String status,String custdeviceID,
                                      Integer totalPrimeDice,Device__c actualDeviceID,
                                      Boolean isPrimeTapeOut,Boolean isFrameTapeout){
        
        PTRF__c ptrf = new PTRF__c();
        
        //ptrf.CRMDID__c=actualDeviceID.CRMDID__c;
        //ptrf.Transaction_Type__c = 'LIFECYCLE';
        ptrf.Status__c = status;
        ptrf.Mask_Set_Title__c='M000001';
        ptrf.Device_Id__c=custdeviceID;
        ptrf.Transaction_Date__c = Date.today();
        //ptrf.Total_Number_of_Prime_Die__c = totalPrimeDice;
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = isPrimeTapeOut;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Order_Type__c ='Retrofit';
        //ptrf.Order_Date__c = Date.today().addDays(10);
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = false;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = isFrameTapeout;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = false;
        ptrf.Device__c = actualDeviceID.Id;
        ptrf.Recticle_Type__c = 'Single Layer Reticle (SLR)';
        
        return ptrf;
    }
    
    static Device__c createDevice(Id oppProgramId,String stage,String crmDID,String gfDeviceID, Id opportunityId){
        
        // Create Device
        Device__c device = new Device__c();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        
        fieldValueMap.put('Name','TESTDEVICE1234');
        fieldValueMap.put('Opportunity_Program__c',oppProgramId);
        fieldValueMap.put('Fab__c','Fab 3');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c',stage);
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Tapeout_Type__c','Single Product');
        fieldValueMap.put('Geometry_Filter__c','0.055UM');
        fieldValueMap.put('Process_Family_Filter__c','MEMS');
        fieldValueMap.put('Device_Id__c',gfDeviceID);
        fieldValueMap.put('CRMDID__c',crmDID);
        fieldValueMap.put('Device_Mask_Set_Title__c','M000001');
        fieldValueMap.put('PTRF_ID__c','ptrf1234');
        fieldValueMap.put('Actual_Tapeout_Date_GMT__c',Date.today().addDays(5));
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Application__c','Media');
        fieldValueMap.put('Opportunity2__c',opportunityId);
        
        return DeviceDataFactory.createDevice(fieldValueMap);
    }  
    
    static Id createAccount() {
        // Create Account
         Account testAcct = new Account();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT101');            
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
        testAcct = AccountDataFactory.createAccount(fieldValueMap);
        return testAcct.Id;
    }
    
    static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opp');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
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
    
    //@testSetup static void loadCustomSettings(){
        /*DataUtilTest.LoadATPEnvVariables();
        DataUtilTest.LoadDeviceEnvVariable();
        List<Environment_Variable__c> environmentVariableList = new List<Environment_Variable__c>();
        environmentVariableList.add(new Environment_Variable__c(Name='SwiftFETeamRoles',value__c='Primary Field Technical Support,Field Technical Support,Field Application Engineer'));
        environmentVariableList.add(new Environment_Variable__c(Name='PTRF_TRIGGER_ENABLED',value__c='TRUE'));
        environmentVariableList.add(new Environment_Variable__c(Name='DEVICE_STAGE_PROTOTYPE',value__c='Prototype'));
        environmentVariableList.add(new Environment_Variable__c(Name='DRTPTRFOrderStatus',value__c='Perform Tapeout Options,Jobview,Mask Making,Closed'));
        environmentVariableList.add(new Environment_Variable__c(Name='DRT_Alternate_Row_Styleclass',value__c='alt-row-bgcolor'));
        environmentVariableList.add(new Environment_Variable__c(Name='PTRF_TXN_TYPE_CANCEL',value__c='CANCEL'));
        environmentVariableList.add(new Environment_Variable__c(Name='PTRF_TXN_TYPE_LIFECYCLE',value__c='LIFECYCLE'));
        environmentVariableList.add(new Environment_Variable__c(Name='DEVICE_STAGE_DESIGNIN',value__c='Design In'));
        environmentVariableList.add(new Environment_Variable__c(Name='PTRF_MASK_SET_TITLE_PREFIX',value__c='MPW'));
        environmentVariableList.add(new Environment_Variable__c(Name='DEVICE_TAPEOUT_TYPE_RETROFIT',value__c='Retrofit'));
        environmentVariableList.add(new Environment_Variable__c(Name='DEVICE_TAPEOUT_TYPE_GLOBALSHUTTLE_MPW',value__c='GlobalShuttle MPW'));
        environmentVariableList.add(new Environment_Variable__c(Name='ACCT_RT_ID_CUSTOMER', value__c='012900000004Ba8'));
        environmentVariableList.add(new Environment_Variable__c(Name='DEVICE_TAPEOUT_TYPE_SINGLE_PRODUCT', value__c='Single Product'));
        environmentVariableList.add(new Environment_Variable__c(Name='SIEBEL_OPPTY_ID_SEQUENCE_NO', value__c='10000'));
        List<Error_Codes__c> errorCodeList = new List<Error_Codes__c>();
        errorCodeList.add(new Error_Codes__c(Name='DEVICE_VALIDATE_IP_DECLARATION', Message__c='IP Declaration submission is required before moving to Tapeout.<br/>'));
        Database.insert(environmentVariableList,false);
        Database.insert(errorCodeList,false);*/
       // DataUtilTest.loadEnvironmentVariables();
        
   // }
    
    static New_Part_Creation_Form__c createNPCForm(Device__c device, String tapeoutType, Id accountId, String newpartId){
        New_Part_Creation_Form__c npcForm = new New_Part_Creation_Form__c(BASE_Device__c = device.Id, Tapeout_Type__c = tapeoutType, Account__c = accountId,
                                                                          New_Part_ID__c = newpartId );
        return npcForm;
    }
    
    
    // Test method for PTRF Cancel scenario
    static testMethod void testPTRFCancel1() {
        //Load All custom settings data
        //loadCustomSettings();
        ID accId = createAccount();
        system.assert(accId!=null);
        ID opportunityId = createOpportunity(accId);
        system.assert(opportunityId!=null);
        ID oppProgramId = createOpportunityProgram(accId, opportunityId);
        system.assert(oppProgramId!=null);
        //Device__c deviceRecord1 = createDevice(oppProgramId,'Design In','D12345','g1111', opportunityId);
        Test.startTest();
        Device__c deviceRecord1 = DeviceUtilTest.createCMPWDevice(accId,oppProgramId);
        insert deviceRecord1;
        //Device__c deviceRecord2 = createDevice(oppProgramId,'Design In','D123456','g2222');
        PTRF__c ptrfRecord1 = createPTRF('Open', 'device1111', 3, deviceRecord1, false, false);
        PTRF__c ptrfRecord2 = createPTRF('Perform Tapeout Options', 'device1111', 3, deviceRecord1, true, false);
        insert ptrfRecord1;
        insert ptrfRecord2;
        
            // Test cover Perform Tapeout Scenario
            ptrfRecord1.Status__c = 'Cancel';
            update ptrfRecord1;
        Test.stopTest();
    }
    
    
    // Test method for PTRF Cancel scenario
    static testMethod void testPTRFCancel2() {
        //Load All custom settings data
        //loadCustomSettings();
        ID accId = createAccount();
        system.assert(accId!=null);
        ID opportunityId = createOpportunity(accId);
        system.assert(opportunityId!=null);
        ID oppProgramId = createOpportunityProgram(accId, opportunityId);
        system.assert(oppProgramId!=null);
       // Device__c deviceRecord1 = createDevice(oppProgramId,'Tapeout','D12345','g1111', opportunityId);
        Device__c deviceRecord1 = DeviceUtilTest.createCMPWDevice(accId,oppProgramId);
        Test.startTest();
        insert deviceRecord1;
        //Device__c deviceRecord2 = createDevice(oppProgramId,'Design In','D123456','g2222');
        PTRF__c ptrfRecord1 = createPTRF('Open', 'device1111', 3, deviceRecord1, true, false);
        insert ptrfRecord1;
        
            // Test cover Perform Tapeout Scenario
            ptrfRecord1.Prime_Tapeout__c = false;
            ptrfRecord1.Status__c = 'Perform Tapeout Options';
            update ptrfRecord1;
        Test.stopTest();
    }    
    
   
    
    // Test method for PTRF Perform Tapeout Options scenario where Device Stage equals to 'Design In' and
    // PTRF Prime Tapeout equals to 'TRUE' and Order Type equals to 'New ProtoType'
    static testMethod void testPTRFPerformTapeoutOptions1(){
        //Load All custom settings data
        //loadCustomSettings();        
        ID accId = createAccount();
        system.assert(accId!=null);
        ID opportunityId = createOpportunity(accId);
        system.assert(opportunityId!=null);
        ID oppProgramId = createOpportunityProgram(accId, opportunityId);
        system.assert(oppProgramId!=null);
        
        //Device__c deviceRecord1 = createDevice(oppProgramId,'Design In','D12345','g1111', opportunityId);
        Device__c deviceRecord1 = DeviceUtilTest.createCMPWDevice(accId,oppProgramId);
        deviceRecord1.Actual_Tapeout_Date_GMT__c = null;
        deviceRecord1.PLM_Device_ID__c = 'device1111';
        deviceRecord1.Prototype_Date__c = System.today();
        Test.startTest();
        insert deviceRecord1;
        //Device__c deviceRecord2 = createDevice(oppProgramId,'Design In','D123456','g2222');
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Chip_Detail__c' and Name = 'Prime Die'].Id;
        //Id maskSetTitleId = createMaskSetTitle();
        PTRF__c ptrfRecord1 = createPTRF('Open', 'device1111', 3, deviceRecord1,true,false);
        //ptrfRecord1.MaskSetTitle__c = 'MSTTRT';
        insert ptrfRecord1;
        createChipDetails(ptrfRecord1.Id,strRecordTypeId);
        Mask_Layer__c maskLayer = createMaskLayer(ptrfRecord1);
        
            // Test cover Perform Tapeout Scenario
            ptrfRecord1.Status__c = 'Perform Tapeout Options';
            ptrfRecord1.Prime_Tapeout__c=true;
            ptrfRecord1.Order_Type__c = 'New ProtoType';
            //ptrfRecord1.MaskSetTitle__c = maskLayerId;
            update ptrfRecord1;
        Test.stopTest();
    }
     
    
    // Test method for PTRF Perform Tapeout Options scenario where Device Stage equals to 'Design In' and Device Tapeout Type equals to 'Retrofit and
    // PTRF Prime Tapeout equals to 'FALSE' and Frame Tapeout equals 'TRUE'
    static testMethod void testPTRFPerformTapeoutOptions2(){
        //Load All custom settings data
        //loadCustomSettings();        
        ID accId = createAccount();
        system.assert(accId!=null);
        ID opportunityId = createOpportunity(accId);
        system.assert(opportunityId!=null);
        ID oppProgramId = createOpportunityProgram(accId, opportunityId);
        system.assert(oppProgramId!=null);
        
        //Device__c deviceRecord1 = createDevice(oppProgramId,'Design In','D12345.00','g1111', opportunityId);
        Device__c deviceRecord1 = DeviceUtilTest.createCMPWDevice(accId,oppProgramId);
        deviceRecord1.Actual_Tapeout_Date_GMT__c = null;
        deviceRecord1.PLM_Device_ID__c = 'device1111';
        deviceRecord1.Prototype_Date__c = System.today();
        Test.startTest();
        insert deviceRecord1;
        //Device__c deviceRecord2 = createDevice(oppProgramId,'Design In','D123456','g2222');
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Chip_Detail__c' and Name = 'Prime Die'].Id;
        //Id maskSetTitleId = createMaskSetTitle();
        PTRF__c ptrfRecord1 = createPTRF('Open', 'device1111', 3, deviceRecord1,false,true);
        //ptrfRecord1.MaskSetTitle__c = maskSetTitleId;
        insert ptrfRecord1;
        createChipDetails(ptrfRecord1.Id,strRecordTypeId);
        Mask_Layer__c maskLayer = createMaskLayer(ptrfRecord1);
        
            // Test cover Perform Tapeout Scenario
            PTRF_AfterTriggerService ptrfAfterTriggerService = new PTRF_AfterTriggerService();
            deviceRecord1.Tapeout_Type__c = 'Retrofit';
            ptrfAfterTriggerService.updateDevicePTRF(ptrfRecord1, deviceRecord1);
        Test.stopTest();
    }
}