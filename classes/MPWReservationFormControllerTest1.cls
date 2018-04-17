/*
    Author: Abhita Bansal
    Created Date: 16/09/2015 
    Description: Test class for MPWReservationFormController
*/
@isTest
public class MPWReservationFormControllerTest1 {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();    
        Account a = utilDataAccMethod();  
        Test.startTest();  
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig); 
        Test.stopTest();       
    }
    
    private static MPW_Approval_Matrix__c utilDataAMMethod() { 
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];  
        
        MPW_Approval_Matrix__c mpwApproval = new MPW_Approval_Matrix__c();
        mpwApproval.Category__c = 'FAB';
        mpwApproval.Fab__c = 'Fab1';
        mpwApproval.Geometry__c = '28nm';
        mpwApproval.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwApproval.Step_1_Approver_2__c = userAppMatrix[1].Id;
        insert mpwApproval;
        
        return mpwApproval;
    }
    
    private static Account utilDataAccMethod() {
    
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        
        Account account = new Account();
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
        fieldValueMap.put('recordtypeid', recordType.id );   
        account= AccountDataFactory.createAccount(fieldValueMap);
        
        return account;
    }  
    
    private static List<Account_Team_Proxy__c> utilDataAccPMethod(Account a) {
        
        List<Account_Team_Proxy__c> accountProxyList =  new List<Account_Team_Proxy__c>();
        
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 3];
        
        Account_Team_Proxy__c accProxy = new Account_Team_Proxy__c();
        accProxy.Account__c = a.Id;
        accProxy.Team_Role__c = 'Primary Account Manager';
        accProxy.User__c = userAppMatrix[0].Id;
        accProxy.Account_Access__c = 'Read/Write';
        insert accProxy;
        accountProxyList.add(accProxy);
        
        Account_Team_Proxy__c accProxy1 = new Account_Team_Proxy__c();
        accProxy1.Account__c = a.Id;
        accProxy1.Team_Role__c = 'Primary Customer Service Rep';
        accProxy1.User__c = userAppMatrix[1].Id;
        accProxy1.Account_Access__c = 'Read/Write';
        insert accProxy1;
        accountProxyList.add(accProxy1);
        
        Account_Team_Proxy__c accProxy2 = new Account_Team_Proxy__c();
        accProxy2.Account__c = a.Id;
        accProxy2.Team_Role__c = 'Primary Field Application Engineer';
        accProxy2.User__c = userAppMatrix[2].Id;
        accProxy2.Account_Access__c = 'Read/Write';
        insert accProxy2;
        accountProxyList.add(accProxy2);
               
        return accountProxyList;
    }  
    
    private static MPW_Form_No_Generator__c utilDataFNGMethod() { 
        
        MPW_Form_No_Generator__c mpwFormNoGen = new MPW_Form_No_Generator__c();
        mpwFormNoGen.Geometry__c = '03';
        mpwFormNoGen.Year__c = '2015';
        mpwFormNoGen.Last_Sequence_No__c = 232;
        insert mpwFormNoGen;
        
        return mpwFormNoGen;
    }
    
    private static MPW_Geometry_Mapping__c utilDataGMMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM'; 
        mpwGeoMap.TechNo__c = '03'; 
        mpwGeoMap.Active__c = true;
        mpwGeoMap.Use_Process_Type__c  = true;
        insert mpwGeoMap;
        
        return mpwGeoMap;
    }    
    
    private static MPW_ERP_PA_Code__c utilDataPAMethod() {
        
        MPW_ERP_PA_Code__c mpwPACode = new MPW_ERP_PA_Code__c();
        mpwPACode.Name = 'RDY67219';
        mpwPACode.PA_Description__c = 'Testing';
        insert mpwPACode;
        
        return mpwPACode;
    } 
    
    static Account createAccount(Id recordTypeId) {
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
        testAcct.Short_Name__c = 'TestAcct1Z';
        testAcct.RecordTypeId = recordTypeId;
        
        insert testAcct;
        
        return testAcct;
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
     static Device__c createDevice(Id testAcctId, Id testOpptyProgramId, Id testMpwId) {
        // Create Device
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name','TESTDEVICEZAIH12345677');
        fieldValueMap.put('Account__c',testAcctId);
        fieldValueMap.put('Opportunity_Program__c',testOpptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Mobility');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c','Active');
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','GlobalShuttle MPW');
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Device_Type__c','Revise');
        fieldValueMap.put('MPW_Train_Number__c',testMpwId);
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',System.today());
        fieldValueMap.put('Enabled_via_previous_MPW_1__c','No');
        fieldValueMap.put('Confidence_Level_Tapeout__c','100');
        fieldValueMap.put('End_Application__c','Body');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
    
    static MPW_Train_Maintenance__c createMPW() {
        MPW_Train_Maintenance__c m = new MPW_Train_Maintenance__c();
        m.Name = 'MPW04T';
        m.Customer_Tapeout_Date__c = date.today();
        m.Other_Tapeout_Date__c = date.today();
        m.MPW_Train_No__c = 'testMpwTrainNo123';
        return m;
    }
    static Mask_Set_Title__c createMST() {
        Mask_Set_Title__c m = new Mask_Set_Title__c();
        m.Name = 'MPW04T0';
        m.Reticle_Type__c ='Multi Layer Reticle (MLR)';
        m.Manual_Creation__c = False;
        return m;
    }
    public static MSTAccount__c createMSTAccount(){
        MSTAccount__c mstAcc = new MSTAccount__c();
        return mstAcc;
    }
    
    
    private static MPW_Metal_Stack_Configuration__c utilDataMSMethod(MPW_Config_Settings__c mpwConfig) {
        
        MPW_Metal_Stack_Configuration__c mpwMetalStack = new MPW_Metal_Stack_Configuration__c();
        mpwMetalStack.Active__c = true;
        mpwMetalStack.Category__c = 'Customer';
        mpwMetalStack.Process_Type__c = mpwConfig.Id;
        insert mpwMetalStack;
        
        return mpwMetalStack;
    }
    
    private static List<MPW_Keyword_Config__c> utilDataKCMethod() {
        
        List<MPW_Keyword_Config__c> mpwKeywordList = new List<MPW_Keyword_Config__c>();
        
        MPW_Keyword_Config__c mpwKeyword = new MPW_Keyword_Config__c();
        mpwKeyword.Active__c = true;
        mpwKeyword.Sequence_No__c = 1;
        mpwKeyword.Type__c = 'ForwarderAccountType';
        mpwKeyword.Value__c = 'Third Party';
        mpwKeywordList.add(mpwKeyword);
        
        MPW_Keyword_Config__c mpwKeyword1 = new MPW_Keyword_Config__c();
        mpwKeyword1.Active__c = true;
        mpwKeyword1.Sequence_No__c = 1;
        mpwKeyword1.Type__c = 'DieQuantity';
        mpwKeyword1.Value__c = '200';
        mpwKeywordList.add(mpwKeyword1);
        
        MPW_Keyword_Config__c mpwKeyword2 = new MPW_Keyword_Config__c();
        mpwKeyword2.Active__c = true;
        mpwKeyword2.Sequence_No__c = 1;
        mpwKeyword2.Type__c = 'QuantityWaferForm';
        mpwKeyword2.Value__c = '10';
        mpwKeywordList.add(mpwKeyword2);
        
        MPW_Keyword_Config__c mpwKeyword3 = new MPW_Keyword_Config__c();
        mpwKeyword3.Active__c = true;
        mpwKeyword3.Sequence_No__c = 1;
        mpwKeyword3.Type__c = 'Backgrind';
        mpwKeyword3.Value__c = '7miles';
        mpwKeywordList.add(mpwKeyword3);
        
        MPW_Keyword_Config__c mpwKeyword4 = new MPW_Keyword_Config__c();
        mpwKeyword4.Active__c = true;
        mpwKeyword4.Sequence_No__c = 1;
        mpwKeyword4.Type__c = 'ShortLoopWafers';
        mpwKeyword4.Value__c = '7';
        mpwKeywordList.add(mpwKeyword4);
        
        MPW_Keyword_Config__c mpwKeyword5 = new MPW_Keyword_Config__c();
        mpwKeyword5.Active__c = true;
        mpwKeyword5.Sequence_No__c = 1;
        mpwKeyword5.Type__c = 'Expedite';
        mpwKeyword5.Value__c = '200';
        mpwKeywordList.add(mpwKeyword5);
        
        MPW_Keyword_Config__c mpwKeyword6 = new MPW_Keyword_Config__c();
        mpwKeyword6.Active__c = true;
        mpwKeyword6.Sequence_No__c = 1;
        mpwKeyword6.Type__c = 'ExpediteQuantityWaferForm';
        mpwKeyword6.Value__c = '7';
        mpwKeywordList.add(mpwKeyword6);
        
        MPW_Keyword_Config__c mpwKeyword7 = new MPW_Keyword_Config__c();
        mpwKeyword7.Active__c = true;
        mpwKeyword7.Sequence_No__c = 1;
        mpwKeyword7.Type__c = 'DeviceType';
        mpwKeyword7.Value__c = 'Product';
        mpwKeywordList.add(mpwKeyword7);
        
        MPW_Keyword_Config__c mpwKeyword8 = new MPW_Keyword_Config__c();
        mpwKeyword8.Active__c = true;
        mpwKeyword8.Sequence_No__c = 1;
        mpwKeyword8.Type__c = 'DrawnOrientation';
        mpwKeyword8.Value__c = 'Vertical';
        mpwKeywordList.add(mpwKeyword8);
        
        MPW_Keyword_Config__c mpwKeyword9 = new MPW_Keyword_Config__c();
        mpwKeyword9.Active__c = true;
        mpwKeyword9.Sequence_No__c = 1;
        mpwKeyword9.Type__c = 'CornerSplit';
        mpwKeyword9.Value__c = 'yes';
        mpwKeywordList.add(mpwKeyword9);
        
        MPW_Keyword_Config__c mpwKeyword10 = new MPW_Keyword_Config__c();
        mpwKeyword10.Active__c = true;
        mpwKeyword10.Sequence_No__c = 1;
        mpwKeyword10.Type__c = 'TurnkeyServices';
        mpwKeyword10.Value__c = 'yes';
        mpwKeywordList.add(mpwKeyword10);
        
        MPW_Keyword_Config__c mpwKeyword11 = new MPW_Keyword_Config__c();
        mpwKeyword11.Active__c = true;
        mpwKeyword11.Sequence_No__c = 1;
        mpwKeyword11.Type__c = 'SubDeviceExtraction';
        mpwKeyword11.Value__c = '7';
        mpwKeywordList.add(mpwKeyword11);
        
        MPW_Keyword_Config__c mpwKeyword12 = new MPW_Keyword_Config__c();
        mpwKeyword12.Active__c = true;
        mpwKeyword12.Sequence_No__c = 1;
        mpwKeyword12.Type__c = 'IPSubCategory';
        mpwKeyword12.Value__c = 'Sponsored';
        mpwKeywordList.add(mpwKeyword12);
        
        MPW_Keyword_Config__c mpwKeyword13 = new MPW_Keyword_Config__c();
        mpwKeyword13.Active__c = true;
        mpwKeyword13.Sequence_No__c = 1;
        mpwKeyword13.Type__c = 'CategoryUsage';
        mpwKeyword13.Value__c = 'Required';
        mpwKeywordList.add(mpwKeyword13);
        
        MPW_Keyword_Config__c mpwKeyword14 = new MPW_Keyword_Config__c();
        mpwKeyword14.Active__c = true;
        mpwKeyword14.Sequence_No__c = 1;
        mpwKeyword14.Type__c = 'DESubCategory';
        mpwKeyword14.Value__c = 'DFM';
        mpwKeywordList.add(mpwKeyword14);
        
        if(!mpwKeywordList.isEmpty()) {
            insert mpwKeywordList;
        }
        
        return mpwKeywordList;
    }
    
    private static MPW_Config_Settings__c utilDataCSMethod() {
        
        RecordType recordType =  [Select Id from RecordType where Name = 'Process' AND SObjectType = 'MPW_Config_Settings__c'];
    
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmGpName';
        mpwConfig.RecordTypeId = recordType.Id;
        insert mpwConfig; 
        
        return mpwConfig;
    }
    
    private static MPW_Tech_Module__c utilDataTeMMethod() {
    
        MPW_Tech_Module__c mpwTechModule = new MPW_Tech_Module__c();
        mpwTechModule.Active__c = true;
        mpwTechModule.Answers__c = 'Yes;No';
        mpwTechModule.Geometry__c = '28nm';
        mpwTechModule.Module_Description__c = 'N3';
        mpwTechModule.Module_Name__c = 'Triple well';
        mpwTechModule.Question__c = 'Do you need SRAM';
        insert mpwTechModule;
        
        return mpwTechModule;
    }
    
    private static MPW_SRAM_Configuration__c utilDataSRMCMethod(MPW_Config_Settings__c mpwConfig) {
        
        MPW_SRAM_Configuration__c mpwSRAMConfig = new MPW_SRAM_Configuration__c();
        mpwSRAMConfig.Active__c = true;
        mpwSRAMConfig.Process_Type__c = mpwConfig.id;
        insert mpwSRAMConfig;
        
        return mpwSRAMConfig;
    }    
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() {
    
        MPW_Train_Maintenance__c mpwTrainMaintenance = new MPW_Train_Maintenance__c();
        mpwTrainMaintenance.Name = 'MPW031';       
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Fab__c = 'Fab1';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Lot_Start_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+16;
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Train_Maintenance_Details__c utilDataTMDMethod(MPW_Tech_Module__c mpwTechModule, MPW_Train_Maintenance__c mpwTrain, MPW_Config_Settings__c mpwConfig) {
      
        MPW_Train_Maintenance_Details__c mpwTrainDetails = new MPW_Train_Maintenance_Details__c();
        mpwTrainDetails.Answers__c = 'Yes;No';
        mpwTrainDetails.MPW_Tech_Module__c = mpwTechModule.Id;
        mpwTrainDetails.MPW_Train_Maintenance__c = mpwTrain.Id;
        mpwTrainDetails.Process_Type__c = mpwConfig.Id;
        insert mpwTrainDetails;
        
        return mpwTrainDetails;
    }
    
    private static MPW_SRAM_Question__c utilDataSRMQMethod(MPW_Reservation__c mpwReservation1, MPW_SRAM_Configuration__c mpwSRAMConfig) {
        
        MPW_SRAM_Question__c mpwSRAMQuestion = new MPW_SRAM_Question__c();
        mpwSRAMQuestion.Answer__c = 'Yes;No';
        mpwSRAMQuestion.Array_Total_Block_Size__c = '280';
        mpwSRAMQuestion.MPW_Process_Information_Question__c = mpwReservation1.Id;
        mpwSRAMQuestion.MPW_SRAM_Configuration__c = mpwSRAMConfig.Id;
        insert mpwSRAMQuestion;
        
        return mpwSRAMQuestion;
    }
    
    private static MPW_Process_Information_Question__c utilDataPIQMethod(MPW_Train_Maintenance_Details__c mpwTrainDetails, MPW_Reservation__c mpwReservation1) {
        
        MPW_Process_Information_Question__c mpwprocessInfo = new MPW_Process_Information_Question__c();
        mpwprocessInfo.Answer__c = 'Yes;No';
        mpwprocessInfo.MPW_Maintenance_Details__c = mpwTrainDetails.Id;
        mpwprocessInfo.MPW_Reservation_Form__c = mpwReservation1.Id;
        insert mpwprocessInfo;
        
        return mpwprocessInfo;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '7';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '4';
        mpwPrimeDie1.SubDevicesExtractionAttached__c = true;
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        mpwPrimeDie1.TurnkeyAttached__c = true;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }  
    
    /*private static MPW_Prime_Die__c utilDataPDMethod1(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Device_Type__c = 'None';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Sub_Devices_Extraction__c = '4';
        mpwPrimeDie1.SubDevicesExtractionAttached__c = true;
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        mpwPrimeDie1.TurnkeyAttached__c = true;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    } */ 
    
    private static MPW_Turnkey__c utilDataTurnkeyMethod(MPW_Reservation__c mpwReservation1, MPW_Prime_Die__c mpwPrimeDie1) {
    
        MPW_Turnkey__c mpwTurnkey = new MPW_Turnkey__c();
        mpwTurnkey.MPW_Reservation__c = mpwReservation1.Id;
        mpwTurnkey.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwTurnkey.Ship_Date__c = System.today() + 5;
        mpwTurnkey.Wafer_Ship_Date__c = System.today() + 7;
        mpwTurnkey.AWB__c = 'Testing';
        mpwTurnkey.Actual_Wafer_Skeleton_Return_Date__c = System.today() + 3;
        mpwTurnkey.Expected_Wafer_Skeleton_Return_Date__c = System.today() + 2;
        insert mpwTurnkey;
        
        return mpwTurnkey;
    }
    
    private static Customer_Guideline_Factor__c utilDataCGFMethod() {
    
        Customer_Guideline_Factor__c customerGF = new Customer_Guideline_Factor__c();
        customerGF.Adder3__c = 0;
        customerGF.Expedite__c = 12000;
        customerGF.ExtraDice_B__c = 12000;
        customerGF.Option2__c = 0;
        customerGF.RecticalSpace_A1__c = 10000;
        customerGF.ReticleSpace_Min__c = 90800;
        customerGF.ShortLoop_Wafer__c = 1500;
        customerGF.Sub_Devices_Extraction__c = 109;
        customerGF.Tech_ID__c = '0.028UM';
        customerGF.TechNodes__c = '28nm';
        customerGF.Wafer_Form_Delivery__c = 12788;
        insert customerGF;
        
        return customerGF;
    } 
    
    private static Internal_Guideline_Factor__c utilDataIGFMethod() {
    
        Internal_Guideline_Factor__c mpwInternalGlF = new Internal_Guideline_Factor__c();
        mpwInternalGlF.DieToWaferConv__c = '(?)/50';
        mpwInternalGlF.ID__c = 34;
        mpwInternalGlF.Reticle__c = 1200;
        mpwInternalGlF.Tech_Node__c = '28nm';
        mpwInternalGlF.Wafer__c = 7843;
       
        insert mpwInternalGlF;
        
        return mpwInternalGlF;
    }
  
  private static void utilDataIAttachment(Id idParent) {
    
        Attachment att = new Attachment();
    att.ParentId = idParent;
    att.Name = 'Test';
    att.ContentType = 'text';
    att.Body = Blob.valueOf('Test');
    insert att;
    
    Note oNote = new Note();
    oNote.ParentId = idParent;
    oNote.Title = 'Test';
    oNote.Body = 'Test';
    insert oNote;
    }
  
    public static testMethod void myReservationFormContMethod6() {
        
       /* Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);   */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true];
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Company_Name__c = 'Test';
        mpwReservation1.Company_Name2__c = 'Test1';
        mpwReservation1.Company_Name3__c = 'Test2';
        mpwReservation1.Address2__c = 'Test';
        mpwReservation1.Contact_Person2__c = 'Test';
        mpwReservation1.Phone2__c = '78342832';
        mpwReservation1.Postal_Code2__c = '78342';
        mpwReservation1.Address__c = 'Test1';
        mpwReservation1.Contact_Person__c = 'Test1';
        mpwReservation1.Phone__c = '783428321';
        mpwReservation1.Postal_Code__c = '783421';
        mpwReservation1.Address3__c = 'Test2';
        mpwReservation1.Contact_Person3__c = 'Test2';
        mpwReservation1.Phone3__c = '783428322';
        mpwReservation1.Postal_Code3__c = '783422';
        mpwReservation1.Customer_Name__c = 'test2';
        mpwReservation1.Customer_Email__c = 'abc@abc.com';
        mpwReservation1.Customer_Phone__c = '56778855';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        Test.startTest();
		MPWGeometry__c MPWGeo=new MPWGeometry__c();
		MPWGeo.Geometry__c='14nm LPE,14nm LPP,14nm LPP 1407,22nm eMRAM,22nm FDSOI,22nm FDX,28nm SLP';
		Insert MPWGeo;
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('voidtheform','true');
        System.currentPageReference().getParameters().put('mode', 'Edit');
        System.currentPageReference().getParameters().put('mpwId', mpwTrainMaintenance.Id);
        System.currentPageReference().getParameters().put('Search', '1');
        System.currentPageReference().getParameters().put('ChangeRequest', '1');
        System.currentPageReference().getParameters().put('index', '2');
        System.currentPageReference().getParameters().put('geometry', '0.028UM');
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.getSubCategories();
        appMatrixClass.getUsages();
        appMatrixClass.getPACodes();
        appMatrixClass.gotoPreview();
        appMatrixClass.turnkeyWrap.selectedmpwpd = mpwPrimeDie1.Id;
        appMatrixClass.saveAsDraft();
        appMatrixClass.compare();
        appMatrixClass.editPage();
        appMatrixClass.mpwResf.Category__c = 'FAB';
        appMatrixClass.onCategoryChange();
        // appMatrixClass.submitForApproval();
        appMatrixClass.voidForm();
        Test.stopTest();   
        
        appMatrixClass.showAddress1 = false;
        appMatrixClass.showAddress2 = false;
        appMatrixClass.showAddress3 = false;
        appMatrixClass.addRowToAddress();
        appMatrixClass.deleteAddress1();
        appMatrixClass.deleteAddress2();
        appMatrixClass.deleteAddress3();
        appMatrixClass.gettrainOptions();
        appMatrixClass.gettrainOptions1();
        appMatrixClass.addRowToChipInformation();
        appMatrixClass.getPrimeDieWrapperList();
        appMatrixClass.retreiveFormName();
       
    } 
    
    public static testMethod void myReservationFormContMethod7() {
        
        /* Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true];
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Company_Name__c = 'Test';
        mpwReservation1.Company_Name2__c = 'Test1';
        mpwReservation1.Company_Name3__c = 'Test2';
        mpwReservation1.Address2__c = 'Test';
        mpwReservation1.Contact_Person2__c = 'Test';
        mpwReservation1.Phone2__c = '78342832';
        mpwReservation1.Postal_Code2__c = '78342';
        mpwReservation1.Address__c = 'Test1';
        mpwReservation1.Contact_Person__c = 'Test1';
        mpwReservation1.Phone__c = '783428321';
        mpwReservation1.Postal_Code__c = '783421';
        mpwReservation1.Address3__c = 'Test2';
        mpwReservation1.Contact_Person3__c = 'Test2';
        mpwReservation1.Phone3__c = '783428322';
        mpwReservation1.Postal_Code3__c = '783422';
        mpwReservation1.Customer_Name__c = 'test2';
        mpwReservation1.Customer_Email__c = 'abc@abc.com';
        mpwReservation1.Customer_Phone__c = '56778855';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
    
        
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
        
        //Test.startTest();
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        //appMatrixClass.back();
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c = '2672';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c = '2772';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.submitReq();
        
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            MPW_Change_Request__c cr = [Select Id, MPW_Prime_Die__c from MPW_Change_Request__c where MPW_Prime_Die__c = :mpwPrimeDie1.Id];
      utilDataIAttachment(cr.Id);
            Test.setCurrentPageReference(new PageReference('Page.MPWChangeRequestViewVF'));
            System.currentPageReference().getParameters().put('Id',cr.Id);
            System.currentPageReference().getParameters().put('RequestType', 'Drawn Die Size Change');
            MPWChangeRequestViewController appMatrixClass1 = new MPWChangeRequestViewController(new ApexPages.Standardcontroller(cr)); 
            appMatrixClass1.rejectedRec();
        }
        
        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod8() {
    
        List<User> userAppMatrix = [select Id from User where Profile.Name = 'GF PIYE Platform' and isActive = true limit 4];
        
        /*Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true];
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Company_Name__c = 'Test';
        mpwReservation1.Company_Name2__c = 'Test1';
        mpwReservation1.Company_Name3__c = 'Test2';
        mpwReservation1.Address2__c = 'Test';
        mpwReservation1.Contact_Person2__c = 'Test';
        mpwReservation1.Phone2__c = '78342832';
        mpwReservation1.Postal_Code2__c = '78342';
        mpwReservation1.Address__c = 'Test1';
        mpwReservation1.Contact_Person__c = 'Test1';
        mpwReservation1.Phone__c = '783428321';
        mpwReservation1.Postal_Code__c = '783421';
        mpwReservation1.Address3__c = 'Test2';
        mpwReservation1.Contact_Person3__c = 'Test2';
        mpwReservation1.Phone3__c = '783428322';
        mpwReservation1.Postal_Code3__c = '783422';
        mpwReservation1.Customer_Name__c = 'test2';
        mpwReservation1.Customer_Email__c = 'abc@abc.com';
        mpwReservation1.Customer_Phone__c = '56778855';
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        mpwReservation1.Step_1_Approver_1__c = userAppMatrix[0].Id;
        mpwReservation1.Step_1_Approver_2__c = userAppMatrix[1].Id;
        mpwReservation1.Step_1_Approver_3__c = userAppMatrix[2].Id;
        mpwReservation1.Step_1_Approver_4__c = userAppMatrix[3].Id;
        //Test.startTest();
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        Test.startTest();
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
                
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c = '2672';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c = '2772';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.submitReq();
        
        MPW_Change_Request__c cr = [Select Id, MPW_Prime_Die__c from MPW_Change_Request__c where MPW_Prime_Die__c = :mpwPrimeDie1.Id];
        Test.setCurrentPageReference(new PageReference('Page.MPWChangeRequestViewVF'));
        System.currentPageReference().getParameters().put('Id',cr.Id);
        System.currentPageReference().getParameters().put('RequestType', 'Extra Dies/Wafer Re-start');
        MPWChangeRequestViewController appMatrixClass1 = new MPWChangeRequestViewController(new ApexPages.Standardcontroller(cr)); 
        appMatrixClass1.recallRec();
        
        Test.stopTest();
    }  
    
    
    public static testMethod void myReservationFormContMethod9() {
    
    //DataUtilTest.loadEnvironmentVariables();
        
        /*Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c mpwInternalGlF = utilDataIGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig); */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true]; 
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
        
        //Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        Test.startTest();
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c = '2672';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c = '2772';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.getdiesOption();
        appMatrixClass.submitReq();
        //appMatrixClass.cancelReq();
        appMatrixClass.getChangeRequestsRecords();
        
        MPW_Change_Request__c cr = [Select Id, MPW_Prime_Die__c from MPW_Change_Request__c where MPW_Prime_Die__c = :mpwPrimeDie1.Id];
        
        User testUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true limit 1];
        
        system.runAs(testUser){
            Test.setCurrentPageReference(new PageReference('Page.MPWChangeRequestViewVF'));
            System.currentPageReference().getParameters().put('Id',cr.Id);
            System.currentPageReference().getParameters().put('RequestType', 'Extra Dies/Wafer Re-start');
            System.currentPageReference().getParameters().put('Approve', '1');
            MPWChangeRequestViewController appMatrixClass1 = new MPWChangeRequestViewController(new ApexPages.Standardcontroller(cr));
            appMatrixClass1.approvedRec();
            //appMatrixClass1.appRejRec();
            //appMatrixClass1.cancelRec();
            appMatrixClass1.getradioOptions();
            appMatrixClass1.validateCheckBox();
        }

        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod10() {
    
    //DataUtilTest.loadEnvironmentVariables();
        
        /*Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c mpwInternalGlF = utilDataIGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true];
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
        
        //Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        Test.startTest();
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c = '2672';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c = '2772';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.getdiesOption();
        appMatrixClass.submitReq();
        //appMatrixClass.cancelReq();
        appMatrixClass.getChangeRequestsRecords();
        
        MPW_Change_Request__c cr = [Select Id, MPW_Prime_Die__c from MPW_Change_Request__c where MPW_Prime_Die__c = :mpwPrimeDie1.Id];
        Test.setCurrentPageReference(new PageReference('Page.MPWChangeRequestViewVF'));
        System.currentPageReference().getParameters().put('Id',cr.Id);
        System.currentPageReference().getParameters().put('RequestType', 'Extra Dies/Wafer Re-start');
        System.currentPageReference().getParameters().put('Approve', '1');
        MPWChangeRequestViewController appMatrixClass1 = new MPWChangeRequestViewController(new ApexPages.Standardcontroller(cr));
        //appMatrixClass1.approvedRec();
        appMatrixClass1.appRejRec();
        //appMatrixClass1.cancelRec();
        //appMatrixClass1.getradioOptions();
        //appMatrixClass1.validateCheckBox();

        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod11() {
    
    //DataUtilTest.loadEnvironmentVariables();
        
        /*Account a = utilDataAccMethod();    
        List<Account_Team_Proxy__c> accountProxyList = utilDataAccPMethod(a);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        Internal_Guideline_Factor__c mpwInternalGlF = utilDataIGFMethod();
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_Form_No_Generator__c mpwFormNoGen = utilDataFNGMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig); */
        Account a = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        MPW_Train_Maintenance__c mpwTrainMaintenance = [Select Id, Name from MPW_Train_Maintenance__c where Name='MPW031'];
        MPW_Config_Settings__c mpwConfig = [Select Id, Name from MPW_Config_Settings__c where Name='28nmGpName'];
        MPW_Train_Maintenance_Details__c mpwTrainDetails = [Select Id, Name from MPW_Train_Maintenance_Details__c where Answers__c='Yes;No'];
        MPW_SRAM_Configuration__c mpwSRAMConfig = [Select Id, Name from MPW_SRAM_Configuration__c where Active__c=true]; 
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = a.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        Test.startTest();
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        MPW_Turnkey__c mpwTurnkey = utilDataTurnkeyMethod(mpwReservation1, mpwPrimeDie1);
        
        //Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('primeNamefield', 'TestComapre1');
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_X_um__c = '2672';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Drawn_Die_Size_Y_um__c = '2772';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.getdiesOption();
        appMatrixClass.submitReq();
        //appMatrixClass.cancelReq();
        appMatrixClass.getChangeRequestsRecords();
        
        MPW_Change_Request__c cr = [Select Id, MPW_Prime_Die__c from MPW_Change_Request__c where MPW_Prime_Die__c = :mpwPrimeDie1.Id];
        Test.setCurrentPageReference(new PageReference('Page.MPWChangeRequestViewVF'));
        System.currentPageReference().getParameters().put('Id',cr.Id);
        System.currentPageReference().getParameters().put('RequestType', 'Extra Dies/Wafer Re-start');
        System.currentPageReference().getParameters().put('Approve', '1');
        MPWChangeRequestViewController appMatrixClass1 = new MPWChangeRequestViewController(new ApexPages.Standardcontroller(cr));
        //appMatrixClass1.approvedRec();
        //appMatrixClass1.appRejRec();
        appMatrixClass1.cancelRec();
        //appMatrixClass1.getradioOptions();
        //appMatrixClass1.validateCheckBox();

        Test.stopTest();
    }
     public static testMethod void myReservationFormContMethod12() {
    
    //DataUtilTest.loadEnvironmentVariables();
         RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        Account testAcct = MPWReservationFormControllerTest1.createAccount(rt.Id);
        string testOpptyId = MPWReservationFormControllerTest1.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWReservationFormControllerTest1.createOpportunityProgram(testAcct.Id, testOpptyId);  
        MPW_Train_Maintenance__c mpwTrainMaintenance = MPWReservationFormControllerTest1.createMPW();
        Mask_Set_Title__c MST = MPWReservationFormControllerTest1.createMST();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        Test.startTest();
            Insert MST;
            mpwTrainMaintenance.Name = 'MPW04T';
            mpwTrainMaintenance.Customer_Tapeout_Date__c = date.today().addDays(5);
            mpwTrainMaintenance.Geometry__c = '40nm';
            mpwTrainMaintenance.Publish__c = True;
            mpwTrainMaintenance.Active__c = True;
        Insert mpwTrainMaintenance;
        Device__c testDevice = MPWReservationFormControllerTest1.createDevice(testAcct.Id, testOpptyProgramId, mpwTrainMaintenance.Id);
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = testAcct.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        
        insert mpwReservation1;
        
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');

        Test.stopTest();
    }
     public static testMethod void myReservationFormContMethod13() {
    
    //DataUtilTest.loadEnvironmentVariables();
         RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        Account testAcct = MPWReservationFormControllerTest1.createAccount(rt.Id);
        string testOpptyId = MPWReservationFormControllerTest1.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWReservationFormControllerTest1.createOpportunityProgram(testAcct.Id, testOpptyId);  
        MPW_Train_Maintenance__c mpwTrainMaintenance = MPWReservationFormControllerTest1.createMPW();
        Mask_Set_Title__c MST = MPWReservationFormControllerTest1.createMST();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        Test.startTest();
            Insert MST;
            mpwTrainMaintenance.Name = 'MPW04T';
            mpwTrainMaintenance.Customer_Tapeout_Date__c = date.today().addDays(5);
            mpwTrainMaintenance.Geometry__c = '40nm';
            mpwTrainMaintenance.Publish__c = True;
            mpwTrainMaintenance.Active__c = True;
        Insert mpwTrainMaintenance;
        Device__c testDevice = MPWReservationFormControllerTest1.createDevice(testAcct.Id, testOpptyProgramId, mpwTrainMaintenance.Id);
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = testAcct.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        
        insert mpwReservation1;
        
		system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod14() {
    
    //DataUtilTest.loadEnvironmentVariables();
         RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        Account testAcct = MPWReservationFormControllerTest1.createAccount(rt.Id);
        string testOpptyId = MPWReservationFormControllerTest1.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWReservationFormControllerTest1.createOpportunityProgram(testAcct.Id, testOpptyId);  
        MPW_Train_Maintenance__c mpwTrainMaintenance = MPWReservationFormControllerTest1.createMPW();
        Mask_Set_Title__c MST = MPWReservationFormControllerTest1.createMST();
        MSTAccount__c MSTAcc = MPWReservationFormControllerTest1.createMSTAccount();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        Test.startTest();
            Insert MST;
            
            MSTAcc.Account__c = testAcct.Id;
            MSTAcc.Mask_Set_Title__c = MST.Id;
            Insert MSTAcc;
            
            mpwTrainMaintenance.Name = 'MPW04T';
            mpwTrainMaintenance.Customer_Tapeout_Date__c = date.today().addDays(5);
            mpwTrainMaintenance.Geometry__c = '65/55nm';
            mpwTrainMaintenance.Publish__c = True;
            mpwTrainMaintenance.Active__c = True;
        Insert mpwTrainMaintenance;
        Device__c testDevice = MPWReservationFormControllerTest1.createDevice(testAcct.Id, testOpptyProgramId, mpwTrainMaintenance.Id);
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = testAcct.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        update mpwReservation1;
        mpwReservation1.Form_Status__c = 'Void';
        update mpwReservation1;
        Test.stopTest();
    }
   public static testMethod void myReservationFormContMethod15() {
    
    //DataUtilTest.loadEnvironmentVariables();
         RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        Account testAcct = MPWReservationFormControllerTest1.createAccount(rt.Id);
        string testOpptyId = MPWReservationFormControllerTest1.createOpportunity(testAcct.Id);
        string testOpptyProgramId = MPWReservationFormControllerTest1.createOpportunityProgram(testAcct.Id, testOpptyId);  
        MPW_Train_Maintenance__c mpwTrainMaintenance = MPWReservationFormControllerTest1.createMPW();
        Mask_Set_Title__c MST = MPWReservationFormControllerTest1.createMST();
        MSTAccount__c MSTAcc = MPWReservationFormControllerTest1.createMSTAccount();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        Test.startTest();
            Insert MST;
            
            MSTAcc.Account__c = testAcct.Id;
            MSTAcc.Mask_Set_Title__c = MST.Id;
            Insert MSTAcc;
            
            mpwTrainMaintenance.Name = 'MPW04T';
            mpwTrainMaintenance.Customer_Tapeout_Date__c = date.today().addDays(5);
            mpwTrainMaintenance.Geometry__c = '65/55nm';
            mpwTrainMaintenance.Publish__c = True;
            mpwTrainMaintenance.Active__c = True;
        Insert mpwTrainMaintenance;
        Device__c testDevice = MPWReservationFormControllerTest1.createDevice(testAcct.Id, testOpptyProgramId, mpwTrainMaintenance.Id);
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        mpwReservation1.Reason_to_Void__c = 'Not Required';
        mpwReservation1.PA_Code__c = 'RDY67219';
        mpwReservation1.Customer_Company_Name__c = testAcct.Id;
        mpwReservation1.Process_Type__c = mpwConfig.Id;
        
        
        insert mpwReservation1;
        system.assertEquals(mpwReservation1.Name,'2015-03-05600');
        mpwReservation1.Form_Status__c = 'Accepted by MPW Tapeout';
        update mpwReservation1;

        Test.stopTest();
    }
}