/*
    Author: Abhita Bansal
    Created Date: 16/09/2015 
    Description: Test class for MPWReservationFormController
*/
@isTest
public class MPWReservationFormControllerTest2 {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();    
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
        mpwTrainMaintenance.Name = 'MPW0311';
        mpwTrainMaintenance.Geometry__c = '28nm';
        mpwTrainMaintenance.Publish__c = true;
        mpwTrainMaintenance.Active__c = true;
        mpwTrainMaintenance.Reservation_Close_Date__c = System.today()+10;
        mpwTrainMaintenance.Train_Type__c = 'GlobalShuttle';
        mpwTrainMaintenance.Geometry_ID__c = '0.028UM';
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today()+10;
        mpwTrainMaintenance.Lot_Start_Date__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_Start__c = System.today()+10;
        mpwTrainMaintenance.Projected_1st_Batch_Bare_Die_Ship_End__c = System.today()+16;
        mpwTrainMaintenance.Fab__c = 'Fab1';
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
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '5';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Wafer_FF__c = '3';
        mpwPrimeDie1.Wafer_FS__c = '0';
        mpwPrimeDie1.Wafer_POR__c = '0';
        mpwPrimeDie1.Wafer_SF__c = '0';
        mpwPrimeDie1.Wafer_SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    } 
    
    private static MPW_Prime_Die__c utilDataPDMethod1(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod2(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '5';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '5';
        mpwPrimeDie1.Wafer_SF__c = '1';
        mpwPrimeDie1.Wafer_SS__c = '1';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '0';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod3(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '0';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '12';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod4(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '0';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod5(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '0';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '0';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod6(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod7(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '1';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod8(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '12';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '12';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '';
        mpwPrimeDie1.POR__c = '100';
        mpwPrimeDie1.SF__c = '';
        mpwPrimeDie1.SS__c = '';
        mpwPrimeDie1.Wafer_FF__c = '';
        mpwPrimeDie1.Wafer_FS__c = '';
        mpwPrimeDie1.Wafer_POR__c = '1';
        mpwPrimeDie1.Wafer_SF__c = '';
        mpwPrimeDie1.Wafer_SS__c = '';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod9(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '7';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '50';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '50';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Wafer_FF__c = '3';
        mpwPrimeDie1.Wafer_FS__c = '0';
        mpwPrimeDie1.Wafer_POR__c = '2';
        mpwPrimeDie1.Wafer_SF__c = '0';
        mpwPrimeDie1.Wafer_SS__c = '0';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Prime_Die__c utilDataPDMethod10(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '7';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_DIE_Form__c = '50';
        mpwPrimeDie1.Address1_Quantity_Delivery_In_WAFER_Form__c = '7';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_DIE_Form__c = '50';
        mpwPrimeDie1.Address2_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_DIE_Form__c = '0';
        mpwPrimeDie1.Address3_Quantity_Delivery_In_WAFER_Form__c = '0';
        mpwPrimeDie1.Address2_ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'Yes';
        mpwPrimeDie1.FF__c = '50';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '50';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Wafer_FF__c = '3';
        mpwPrimeDie1.Wafer_FS__c = '0';
        mpwPrimeDie1.Wafer_POR__c = '2';
        mpwPrimeDie1.Wafer_SF__c = '0';
        mpwPrimeDie1.Wafer_SS__c = '2';
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'Yes';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    public static testMethod void myReservationFormContMethod10() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod10(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '50';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '0';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod11() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Turnkey Services Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.filename3 = 'Sample';
        appMatrixClass.filebody3 = Blob.valueOf('Test Body'); 
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod12() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Wafer Form Delivery';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Wafer_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Delivery_Qty_Die_Form__c = '0';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod13() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Expedite Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c = '0';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod14() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.selectedChangeOption = 'Backgrind Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Backgrind__c = 'None';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod15() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.selectedChangeOption = 'Extra Dies/Wafer Re-start';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '0';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod16() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.selectedChangeOption = 'Short Loop Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_ShortLoop_Wafer__c = 'None';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }  
    
    public static testMethod void myReservationFormContMethod17() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Drawn Die Size Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c = null;
        appMatrixClass.submitReq();
        
        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod18() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Sub Devices Extraction';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.filename2 = 'Sample';
        appMatrixClass.filebody2 = Blob.valueOf('Test Body'); 
        appMatrixClass.submitReq();
        
        Test.stopTest();
    } 
    
    public static testMethod void myReservationFormContMethod19() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Wafer Form Delivery';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '3';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c = '200';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c = '300';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c = '6';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }      
    
    public static testMethod void myReservationFormContMethod20() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Extra Dies/Wafer Re-start';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '3';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c = '200';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c = '300';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c = '6';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod21() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Expedite Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_DIE_Form__c = '200';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Expedite_In_WAFER_Form__c = '10';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }   
    
    public static testMethod void myReservationFormContMethod22() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Extra Dies/Wafer Re-start';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '3';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }  

    public static testMethod void myReservationFormContMethod23() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod10(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod24() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod2(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';   
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '0';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod25() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod3(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';   
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '0';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = null;
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod26() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod3(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';   
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod27() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod4(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';     
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod28() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod5(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';      
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod29() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod30() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.filename1 = 'Sample';
        appMatrixClass.filebody1 = Blob.valueOf('Test Body');
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'No';   
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod31() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.cancelReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod32() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod5(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.filename1 = 'Sample';
        appMatrixClass.filebody1 = Blob.valueOf('Test Body');
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '0';        
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '11';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '1';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod33() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod4(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.filename1 = 'Sample';
        appMatrixClass.filebody1 = Blob.valueOf('Test Body');
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '0';      
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
        
    public static testMethod void myReservationFormContMethod34() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod9(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Wafer Form Delivery';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '3';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_DIE_Form__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address2_Quantity_Delivery_In_WAFER_Form__c = '4';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_DIE_Form__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Address3_Quantity_Delivery_In_WAFER_Form__c = '6';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    
    public static testMethod void myReservationFormContMethod35() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod36() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = null;
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod37() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '2';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod38() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '2';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = null;
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = null;
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod39() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '100';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '0';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '100';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '50';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
    public static testMethod void myReservationFormContMethod40() {
    
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        MPW_ERP_PA_Code__c mpwPACode = utilDataPAMethod();
        List<MPW_Keyword_Config__c> mpwKeywordList = utilDataKCMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_SRAM_Configuration__c mpwSRAMConfig = utilDataSRMCMethod(mpwConfig); 
        MPW_Metal_Stack_Configuration__c mpwMetalStack = utilDataMSMethod(mpwConfig);    
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrainMaintenance, mpwConfig);  
        
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod6(mpwReservation1);
        MPW_Process_Information_Question__c mpwprocessInfo = utilDataPIQMethod(mpwTrainDetails, mpwReservation1);
        MPW_SRAM_Question__c mpwSRAMQuestion = utilDataSRMQMethod(mpwReservation1, mpwSRAMConfig);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWReservationFormVF'));
        System.currentPageReference().getParameters().put('primeIdfield', mpwPrimeDie1.Id);
        
        MPWReservationFormController appMatrixClass = new MPWReservationFormController(new ApexPages.Standardcontroller(mpwReservation1));
        appMatrixClass.showChangeRequest();
        appMatrixClass.selectedChangeOption = 'Corner Split Change';
        appMatrixClass.showSelectedChangeReq();
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Corner_Split__c = 'Yes';  
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Die_Form__c = '0';
        appMatrixClass.mpwPrimeDieCh.Delivery_Qty_Wafer_Form__c = '5';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.POR__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.SS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FF__c = '3';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_FS__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_POR__c = '3';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SF__c = '';
        appMatrixClass.mpwChangeReqWrapp.mpwChangeReq.Wafer_SS__c = '';
        appMatrixClass.submitReq();
        
        Test.stopTest();
    }
}