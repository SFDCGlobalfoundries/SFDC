/*
    Author: Zymark Ambat
    Description: This serves as the test class for the DeviceService webservice.
    History: 
        ZAmbat      02252013    - Code creation.
        Vijay       08262014    - Added test method for PLMUpdate and upsertPTRFForDevice API method of DeviceService class.
        Vijay       16012015    - Updated the Device Stage 'Solutioning' to 'Design In' as Device will be created in 
                                  'Design In' directly and added mandatory fields.
        Vijay       04242015    - Refactored the test class and updated the test methods
*/
@isTest(SeeAllData=false)
public class DeviceService_Test {
    @testSetup static void loadCustomSettings(){
        DataUtilTest.loadEnvironmentVariables();
        Error_Codes__c erroCode = new Error_Codes__c(Name='PTRF_NUMBER_NOT_FOUND',Message__c='Test');
        Database.insert(erroCode ,false);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
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
        fieldValueMap.put('Siebel_Account_ID__c','123123123123');
        Test.startTest();
        Account acc = AccountDataFactory.createAccount(fieldValueMap);
    
        String opptyId = createOpportunity(acc.id);
        String oppProgramId = createOpportunityProgram(acc.id, opptyId);
        Test.stopTest();
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
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
         
        Opportunity testOppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        testOppty.Siebel_Opportunity_ID__c = '123123123123';
        
        Update testOppty;
        
        return testOppty.Id;
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
    
    
    /*static Mask_Set_Title__c createMaskSetTitle(String name, Boolean isAvailableForUse, String status){
       return new Mask_Set_Title__c(Name = name, Is_Available_For_Use__c = isAvailableForUse, Status__c = status);
    }
    */
    // Create Mask Layer
    static Mask_Layer__c createMaskLayer(PTRF__c ptrf, Integer sortOrder, Boolean isTapeout, Mask_Set_Title__c maskSetTitle, String mrsLayerRev, String romCode,
                                            String maskLayerNumber){ 
       return new Mask_Layer__c(PTRF__c = ptrf.Id, Sort_Order__c = sortOrder, Tapeout__c = isTapeout,   Mask_Set_Title__c = maskSetTitle.Id,
                                Mask_Layer_Rev__c = mrsLayerRev, ROM_Code__c = romCode, Mask_Layer_Number__c = maskLayerNumber);
    }
    
    // Create PTRF Record
    static PTRF__c createPTRF(String status, Mask_Set_Title__c maskSetTitle, String custdeviceID, Date transactionDate, String processId, Boolean isPrimeTapeOut,
                                        String primeStatus, String primeDRT, String orderType, String frameStatus, Boolean frameMockup, Boolean frameGDOUTReview,
                                        String frameDRT,Boolean isFrameTapeout, Boolean isDRTOnly, Boolean isPrimeGDSOUTReview,  Device__c actualDeviceID,
                                        String reticleType){
       return  new PTRF__c(Status__c = status, Mask_Set_Title__c = maskSetTitle.Id, Device_Id__c = custdeviceID, Transaction_Date__c = transactionDate, 
                            Process_ID__c = processId,Prime_Tapeout__c = isPrimeTapeOut, Prime_Status__c = primeStatus, Prime_DRT__c = primeDRT,
                            Order_Type__c = orderType, Frame_Status__c = frameStatus, Frame_Mockup__c = frameMockup, Frame_GDSOUT_Review__c = frameGDOUTReview,
                            Frame_DRT__c = frameDRT, Frame_Tapeout__c = isFrameTapeout, DRC_Only__c = isDRTOnly, Prime_GDSOUT_Review__c = isPrimeGDSOUTReview,
                            Device__c = actualDeviceID.Id, Recticle_Type__c = reticleType);
        
    }
    
   /* static Device__c createDevice(String name, Id oppProgramId, String fab, String gsopAssignmentTPlan, String marketSegment, String semiconductorDevice,
                                            String endCustomer, String deviceSourcing, String stage, String status, String tapeoutType, String geometryFilter, 
                                            String processFamilyFilter, String gfDeviceID, String crmDID, String maskSetTitle, String ptrfId, Date actualTapeOutDateGMT,
                                            String confidencrLevelTapeout, String endApplication, Id opportunityId){
        
        // Create Device
        return new Device__c(Name = name, Opportunity_Program__c = oppProgramId, Fab__c = fab, GSOP_Assignment_Tapeout_Plan__c = gsopAssignmentTPlan,
                                         Market_Segment__c = marketSegment, Semiconductor_Device__c = semiconductorDevice, End_Customer__c = endCustomer, 
                                         Device_Sourcing__c = deviceSourcing, Stage__c = stage, Status__c = status, Tapeout_Type__c = tapeoutType, 
                                         Geometry_Filter__c = geometryFilter, Process_Family_Filter__c = processFamilyFilter, Device_Id__c = gfDeviceID,CRMDID__c =crmDID,
                                         Device_Mask_Set_Title__c = maskSetTitle, PTRF_ID__c = ptrfId, Actual_Tapeout_Date_GMT__c = actualTapeOutDateGMT,
                                         Confidence_Level_Tapeout__c = confidencrLevelTapeout, End_Application__c = endApplication, Opportunity2__c = opportunityId);
        
    }
    */
    static MRS__c createMRS(Mask_Set_Title__c maskSetTitle){
        return new MRS__c(Mask_Set_Title__c = maskSetTitle.Id);
    }
    
    static MRS_Layer_Association__c createMRSLayerAssociation(String name, MRS__c mrs,String mrsLayerRev, String romCode, String status){
        return new MRS_Layer_Association__c(Name = name, MRS__c = mrs.Id, Mask_Layer_Rev__c = mrsLayerRev, ROM_Code__c = romCode, Layer_Status__c = status);
    }  
     
       
    
    
    //test method for upsertPTRFForDevice functionality
    /*Commented by Baij on 20/06/2015
    static testMethod void testUpsertPTRFForDevice(){
        Test.startTest();
        DeviceService.PTRFtStruct ptrfStruct = new DeviceService.PTRFtStruct();
        DeviceService.PTRFReturnMessage ptrfReturnMsg = DeviceService.upsertPTRFForDevice(ptrfStruct);
        Test.stopTest();
        
    }*/
    
    //test method for PLMUpdate funcationality.
    static testMethod void testPLMUpdate1(){
        Account acct = getAccount('MYTEST ACCOUNT1');
        Opportunity_Program__c oppProgram = [SELECT Id From Opportunity_Program__c WHERE Name = 'Test Opportunity Program'];
        Opportunity oppty =[SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
       /* Device__c device = createDevice('TESTDEVICE1', oppProgram.Id, 'FAB 2', 'NO', 'Mobility', 'Analog Amplifier', 'Test Customer', '1st Source', 'Design In',
                                                 'Active', 'Customer MPW', '0.028UM', 'MEMS', 'g1111','CDID123456', 'MASKST1', 'ptrf1234', System.today() + 5, 
                                                 '100', 'Media', oppty.Id);
        device.Enabled_via_previous_MPW_1__c = 'No'; 
        insert device;*/
        
        
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acct.Id ,MSTId);
        Device__c device =  DeviceUtilTest.createCustomerMPWDevice2(acct.Id  ,oppProgram.Id);
        Device__c createdDevice = [SELECT CRMDID__c FROM Device__c WHERE Id =:device.Id LIMIT 1];
        System.debug('---------createdDevice --------'+createdDevice);
        Mask_Set_Title__c maskSetTitle = DeviceUtilTest.createMaskSetTitle1('MASKST1', true, 'Active');
        //insert maskSetTitle;
        PTRF__c ptrfObject = createPTRF('Perform Tapeout Options', maskSetTitle, 'Device1234', System.today(), '', true, '', '', 'Retrofit', '', false, false, '', 
                                            false, false, false, device, 'Single Layer Reticle (SLR)');
        insert ptrfObject;
        Mask_Layer__c maskLayer = createMaskLayer(ptrfObject, 3, true, maskSetTitle, '10', '10', 'TestML10');
        insert maskLayer;
        Test.startTest();        
        MRS__c mrsObject = createMRS(maskSetTitle);
        insert mrsObject;
        MRS_Layer_Association__c mrsLayerAssociation = createMRSLayerAssociation('TestML10', mrsObject, '10', '10', 'Shipped');
        insert mrsLayerAssociation;
        DeviceService.DevicePLMUpdateStruct devicePLMUpdateStruct = new DeviceService.DevicePLMUpdateStruct();
        devicePLMUpdateStruct.sCRMDID = createdDevice.CRMDID__c;
        devicePLMUpdateStruct.sFab = 'FAB 2';
        devicePLMUpdateStruct.sDeviceStage = 'Prototype';
        devicePLMUpdateStruct.sMaskSetTitle = 'MASKST1';
        devicePLMUpdateStruct.sSTFProcessID = 'TestSTFProcessId1' ;
        devicePLMUpdateStruct.sPLMDeviceID = 'TestPLMDeviceId1';
        devicePLMUpdateStruct.dLifeCycleChangeDate = System.today() + 1;
        DeviceService.PLMUpdate(devicePLMUpdateStruct);
        device.stage__c = 'Prototype';
        update device; 
        DeviceService.PLMUpdate(devicePLMUpdateStruct); 
        Test.stopTest();
    }
    
    
     //test method for PLMUpdate funcationality.
     static testMethod void testPLMUpdate2(){
        Account acct = getAccount('MYTEST ACCOUNT1');
        Opportunity_Program__c oppProgram = [SELECT Id From Opportunity_Program__c WHERE Name = 'Test Opportunity Program'];
        Opportunity oppty =[SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
        /*Device__c device = createDevice('TESTDEVICE2', oppProgram.Id, 'Fab 2', 'NO', 'Mobility', 'Analog Amplifier', 'Test Customer', '1st Source', 'Tapeout',
                                                 'Active', 'Customer MPW', '0.028UM', 'MEMS', 'g1111','CDID222222', 'MASKST2', 'ptrf1234', System.today() + 5, 
                                                 '100', 'Media',oppty.Id);
        insert device;*/
        
        //System.debug('---------createdDevice --------'+device);
        
        //insert maskSetTitle;
        Test.startTest();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acct.Id,MSTId);
        Device__c device =  DeviceUtilTest.createCustomerMPWDevice2(acct.Id ,oppProgram.Id);
        //device.stage__c = 'EOL';
        //update device;
        Mask_Set_Title__c maskSetTitle = DeviceUtilTest.createMaskSetTitle1('MASKST2', true, 'Active');
        DeviceService.DevicePLMUpdateStruct devicePLMUpdateStruct = new DeviceService.DevicePLMUpdateStruct();
        devicePLMUpdateStruct.sCRMDID = '';
        devicePLMUpdateStruct.sFab = 'FAB 2';
        devicePLMUpdateStruct.sDeviceStage = 'Production';
        devicePLMUpdateStruct.sMaskSetTitle = 'MASKST2';
        devicePLMUpdateStruct.sSTFProcessID = 'TestSTFProcessId2' ;
        devicePLMUpdateStruct.sPLMDeviceID = 'TestPLMDeviceId2';
        devicePLMUpdateStruct.dLifeCycleChangeDate = System.today() + 1;
        DeviceService.PLMUpdate(devicePLMUpdateStruct);
        
        try{
            devicePLMUpdateStruct.sDeviceStage = '';
            DeviceService.PLMUpdate(devicePLMUpdateStruct);
        }
        catch(exception e){}
        Test.stopTest();
    }
     /*
     //test method for PLMUpdate funcationality.
    static testMethod void testPLMUpdate3(){
        DeviceService.DevicePLMUpdateStruct devicePLMUpdateStruct = new DeviceService.DevicePLMUpdateStruct();
        devicePLMUpdateStruct.sCRMDID = 'CDID333333';
        devicePLMUpdateStruct.sFab = 'FAB 2';
        devicePLMUpdateStruct.sMaskSetTitle = 'MASKST1';
        devicePLMUpdateStruct.sSTFProcessID = 'TestSTFProcessId3' ;
        devicePLMUpdateStruct.sPLMDeviceID = 'TestPLMDeviceId3';
        devicePLMUpdateStruct.dLifeCycleChangeDate = System.today() + 1;
        Test.startTest();
        DeviceService.PLMUpdate(devicePLMUpdateStruct);
        Test.stopTest();
    }*/
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    } 
       
     
}