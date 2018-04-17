/*
    Author: Abhita Bansal
    Created Date: 14/09/2015 
    Description: Test class for InternalChargeOutReportController
*/
@isTest
public class MPWInternalChargeOutTest {

    /*@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }*/
    
    private static MPW_Keyword_Config__c utilDataKCMethod() {
    
        MPW_Keyword_Config__c mpwKeywordConfig =  new MPW_Keyword_Config__c();
        mpwKeywordConfig.Active__c = true;
        mpwKeywordConfig.Sequence_No__c = 1;
        mpwKeywordConfig.Type__c = 'CategoryUsage';
        mpwKeywordConfig.Value__c = 'Required';
        insert mpwKeywordConfig;
        
        return mpwKeywordConfig;
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
    
    private static MPW_Reservation__c utilDataRFMethod(MPW_Train_Maintenance__c mpwTrainMaintenance) {
    
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrainMaintenance.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'IP';
        mpwReservation1.Usage__c = 'Required';
        mpwReservation1.Prime_Die_Name__c = 'TestComapre1';
        insert mpwReservation1;
        
        return mpwReservation1;  
    } 
    
    private static MPW_Prime_Die__c utilDataPDMethod(MPW_Reservation__c mpwReservation1) {
		List<MPW_Prime_Die__c> lstPD = new List<MPW_Prime_Die__c>();
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
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        lstPD.add(mpwPrimeDie1);
        
		MPW_Prime_Die__c mpwPrimeDie2 = new MPW_Prime_Die__c();
        mpwPrimeDie2.Prime_Die_Name__c = 'TestComapre2';
        mpwPrimeDie2.MPW_Form__c = mpwReservation1.Id;
        mpwPrimeDie2.Drawn_Die_Size_X_um__c = '1234';
        mpwPrimeDie2.Drawn_Die_Size_Y_um__c = '2344';
        mpwPrimeDie2.Device_Type__c = 'Product';
        mpwPrimeDie2.Delivery_Qty_Die_Form__c = '100';
        mpwPrimeDie2.Delivery_Qty_Wafer_Form__c = '2';
        mpwPrimeDie2.Drawn_Orientation_Restricted_Structures__c= 'Test';
        mpwPrimeDie2.Metal_Stack__c = 'Test';
        mpwPrimeDie2.Corner_Split__c = 'Yes';
        mpwPrimeDie2.FF__c = '50';
        mpwPrimeDie2.FS__c = '0';
        mpwPrimeDie2.POR__c = '50';
        mpwPrimeDie2.SF__c = '0';
        mpwPrimeDie2.SS__c = '0';
        mpwPrimeDie2.GMPL_Purpose__c = 'Test';
        mpwPrimeDie2.ShortLoop_Wafer__c = '4';
        mpwPrimeDie2.Backgrind__c = '10';
        mpwPrimeDie2.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie2.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie2.Turnkey_Service__c = 'No';
        lstPD.add(mpwPrimeDie2);
        
		insert lstPD;
		
        return mpwPrimeDie1;
    } 
    
    private static MPW_Change_Request__c utilDataCRMethod(MPW_Reservation__c mpwReservation1, MPW_Prime_Die__c mpwPrimeDie1) {
		List<MPW_Change_Request__c> lstCR = new List<MPW_Change_Request__c>();
        MPW_Change_Request__c mpwChangeReq1 = new MPW_Change_Request__c();
        mpwChangeReq1.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq1.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq1.Request_Type__c = 'Drawn Die Size Change';
        mpwChangeReq1.Status__c = 'Draft';
        mpwChangeReq1.Drawn_Die_Size_X_um__c = '600';
        mpwChangeReq1.Drawn_Die_Size_Y_um__c = '4';
		mpwChangeReq1.Corner_Split__c = 'No';
        lstCR.add(mpwChangeReq1);
        
		MPW_Change_Request__c mpwChangeReq2 = new MPW_Change_Request__c();
        mpwChangeReq2.MPW_Form__c = mpwReservation1.Id;
        mpwChangeReq2.MPW_Prime_Die__c = mpwPrimeDie1.Id;
        mpwChangeReq2.Request_Type__c = 'Drawn Die Size Change';
        mpwChangeReq2.Status__c = 'Draft';
        mpwChangeReq2.Drawn_Die_Size_X_um__c = '600';
        mpwChangeReq2.Drawn_Die_Size_Y_um__c = '4';
		mpwChangeReq2.Corner_Split__c = 'Yes';
        lstCR.add(mpwChangeReq2);
		
		insert lstCR;
		
        return mpwChangeReq1;
    }
	
	private static MPW_Internal_Guideline_Factor__c utilDataCSMethos() {
		MPW_Internal_Guideline_Factor__c cs = new MPW_Internal_Guideline_Factor__c();
		cs.Name = 'Test';
		cs.Category__c = 'IP';
		cs.Geometry__c = '28nm';
		cs.NON_SPLIT_Corner_Factor__c = 1;
		cs.SPLIT_Corner_Factor__c = 1;
		insert cs;
		
		return cs;		
	}
    
    public static testMethod void myInternalChargeOutMethod() {
        
        MPW_Keyword_Config__c mpwKeywordConfig = utilDataKCMethod();
        MPW_Train_Maintenance__c mpwTrainMaintenance = utilDataTMMethod();  
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrainMaintenance); 
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1); 
        MPW_Change_Request__c mpwChangeReq = utilDataCRMethod(mpwReservation1, mpwPrimeDie1);
		MPW_Internal_Guideline_Factor__c cs = utilDataCSMethos();
        
        Internal_Guideline_Factor__c mpwInternalGlF = new Internal_Guideline_Factor__c();
        mpwInternalGlF.DieToWaferConv__c = '(?)/50';
        mpwInternalGlF.ID__c = 34;
        mpwInternalGlF.Reticle__c = 1200;
        mpwInternalGlF.Tech_Node__c = '28nm';
        mpwInternalGlF.TechID__c = '0.028UM';
        mpwInternalGlF.Wafer__c = 7843;
       
        insert mpwInternalGlF;  
        
		List<MPW_Internal_Chargeout_Report__c> lstMPWCRCS = new List<MPW_Internal_Chargeout_Report__c>();
		
		MPW_Internal_Chargeout_Report__c mpwCRCS1 = new MPW_Internal_Chargeout_Report__c();
        mpwCRCS1.Name = 'Drawn Die Size Change';
        mpwCRCS1.Change_Request__c = 'Drawn Die Size Change';
		lstMPWCRCS.add(mpwCRCS1);
		
		MPW_Internal_Chargeout_Report__c mpwCRCS2 = new MPW_Internal_Chargeout_Report__c();
        mpwCRCS2.Name = 'Extra Dies/Wafer Re-start';
        mpwCRCS2.Change_Request__c = 'Extra Dies/Wafer Re-start';
		lstMPWCRCS.add(mpwCRCS2);
		
		insert lstMPWCRCS;
		
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.InternalChargeOutReportVF'));
        System.currentPageReference().getParameters().put('MPWFormNo', mpwReservation1.Name);
        
        InternalChargeOutReportController appMatrixClass = new InternalChargeOutReportController();
        appMatrixClass.getCategoryOptions();
        appMatrixClass.getFormStatusOptions();
        appMatrixClass.getUsageOptions();
        appMatrixClass.reset();
        appMatrixClass.getpageList();
        appMatrixClass.getPrimeDieRecords();
        appMatrixClass.searchMethod();
        appMatrixClass.retrieveRecords();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        appMatrixClass.exportCsvFile();
        
        Test.stopTest() ;   
    }
}