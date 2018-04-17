/*
    Author: Abhita Bansal
    Description: serves as test class for MPWChangeRequestTriggerHandler class.
    Created Date: 15/09/2015  
*/
@isTest(SeeAllData=false)
public class MPWChangeRequestTriggerHandlerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
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
    
        Internal_Guideline_Factor__c internalGF = new Internal_Guideline_Factor__c();
        internalGF.DieToWaferConv__c = '(?)/50';
        internalGF.Reticle__c = 12000;
        internalGF.Wafer__c= 12000;
        internalGF.TechID__c = '0.028UM';
        internalGF.Tech_Node__c = '28nm';
        insert internalGF;
        
        return internalGF;
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
        mpwTrainMaintenance.Tapeout_Date_Customer__c = System.today();
        insert mpwTrainMaintenance;
        
        return mpwTrainMaintenance;
    }
    
    private static MPW_Reservation__c utilDataRFMethod(MPW_Train_Maintenance__c mpwTrain) {
    
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted By GlobalShuttle';
        mpwReservation1.Category__c = 'FAB';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        return mpwReservation1;
    }
    
    private static MPW_Reservation__c utilDataRFMethod1(MPW_Train_Maintenance__c mpwTrain) {
    
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Accepted By GlobalShuttle';
        mpwReservation1.Category__c = 'Customer';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        return mpwReservation1;
    }
        
    private static MPW_Prime_Die__c utilDataPDMethod(MPW_Reservation__c mpwReservation1) {
    
        MPW_Prime_Die__c mpwPrimeDie1 = new MPW_Prime_Die__c();
        mpwPrimeDie1.Prime_Die_Name__c = 'TestComapre1';
        mpwPrimeDie1.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie1.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie1.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie1.Device_Type__c = 'Product';
        mpwPrimeDie1.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie1.Delivery_Qty_Wafer_Form__c = '2';
        mpwPrimeDie1.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie1.Metal_Stack__c = 'Test';
        mpwPrimeDie1.Corner_Split__c = 'No';
        mpwPrimeDie1.FF__c = '0';
        mpwPrimeDie1.FS__c = '0';
        mpwPrimeDie1.POR__c = '0';
        mpwPrimeDie1.SF__c = '0';
        mpwPrimeDie1.SS__c = '0';
        mpwPrimeDie1.Extra_Die_Qty__c = 1;
        mpwPrimeDie1.Extra_Wafer_Qty__c = 2;
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        mpwPrimeDie1.Extra_Die_Qty_Cumulative__c = 0;
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    private static MPW_Extra_Die__c utilDataEDMethod(MPW_Prime_Die__c mpwPrimeDie1) {
        
        MPW_Extra_Die__c mpwExtraDie = new MPW_Extra_Die__c();
        mpwExtraDie.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwExtraDie.Extra_Die_Id__c = '2015-03-05600-01';
        mpwExtraDie.Extra_Wafer_Id__c = '2015-03-05600-01';
        insert mpwExtraDie;
        
        return mpwExtraDie;
    }
    
    public static testMethod void myChangeReqTriggerMethod() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        MPW_Extra_Die__c mpwExtraDie = utilDataEDMethod(mpwPrimeDie1);
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Extra Dies/Wafer Re-start';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '600';
        mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '4';
        mpwChangeReq.Extra_Die_Quantity__c = 200;
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod1() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Drawn Die Size Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Drawn_Die_Size_X_um__c = '1233';
        mpwChangeReq.Drawn_Die_Size_Y_um__c = '1899';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod2() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Wafer Form Delivery';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Delivery_Qty_Die_Form__c = '500';
        mpwChangeReq.Delivery_Qty_Wafer_Form__c = '9';
        mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '500';
        mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '9';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod3() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Corner Split Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Corner_Split__c = 'Yes';
        mpwChangeReq.POR__c = '50';
        mpwChangeReq.SF__c = '50';
        mpwChangeReq.SS__c = '100';
        mpwChangeReq.FF__c = '100';
        mpwChangeReq.FS__c = '100';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod4() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Expedite Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Expedite_In_DIE_Form__c = '300';
        mpwChangeReq.Expedite_In_WAFER_Form__c = '4';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod5() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Turnkey Services Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Turnkey_Service__c = 'Yes';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod6() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Short Loop Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Address1_ShortLoop_Wafer__c = '10';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod7() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Backgrind Change';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Backgrind__c = '7miles';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod8() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Sub Devices Extraction';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Sub_Devices_Extraction__c = '5';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
    
    public static testMethod void myChangeReqTriggerMethod9() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod1(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Wafer Form Delivery';
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Delivery_Qty_Die_Form__c = '500';
        mpwChangeReq.Delivery_Qty_Wafer_Form__c = '9';
        mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '500';
        mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '9';
        insert mpwChangeReq;
        
        Test.startTest();  
        
            mpwChangeReq.Status__c = 'Accepted by MPW Tapeout';
            update mpwChangeReq;
        
        Test.stopTest() ;  
    }
	
	public static testMethod void myChangeReqTriggerMethod10() {
    
        Internal_Guideline_Factor__c internalGF = utilDataIGFMethod(); 
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod1(mpwTrainMaintenance);
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);
        Customer_Guideline_Factor__c customerGF = utilDataCGFMethod();
        
        MPW_Change_Request__c mpwChangeReq = new MPW_Change_Request__c();
        mpwChangeReq.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq.Request_Type__c = 'Wafer Form Delivery';
		mpwChangeReq.Requested_On__c = system.now();
        mpwChangeReq.Status__c = 'Draft';
        mpwChangeReq.Delivery_Qty_Die_Form__c = '500';
        mpwChangeReq.Delivery_Qty_Wafer_Form__c = '9';
        mpwChangeReq.Address1_Quantity_Delivery_In_DIE_Form__c = '500';
        mpwChangeReq.Address1_Quantity_Delivery_In_WAFER_Form__c = '9';
        insert mpwChangeReq;
        
        Test.startTest();  
			
			mpwChangeReq.Request_Type__c = 'Drawn Die Size Change';
            update mpwChangeReq;
			delete mpwChangeReq;
        
        Test.stopTest() ;  
    }
}