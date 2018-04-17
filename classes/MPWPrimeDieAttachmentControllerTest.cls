/*
    Author: Abhita Bansal
    Created Date: 28/08/2015 
    Description: Test class for MPWPrimeDieAttachmentController
*/
@isTest
public class MPWPrimeDieAttachmentControllerTest {

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
    
    private static MPW_Config_Settings__c utilDataCSMethod() { 
    
        MPW_Config_Settings__c mpwConfig = new MPW_Config_Settings__c();
        mpwConfig.Active__c = true;
        mpwConfig.Geometry__c = '28nm';
        mpwConfig.Name = '28nmLP';
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
        mpwTechModule.Question__c = 'Do you need Triple well?:';
        insert mpwTechModule;
        
        return mpwTechModule;
    }
    
    private static MPW_Train_Maintenance__c utilDataTMMethod() { 
    
        MPW_Train_Maintenance__c mpwTrain = new MPW_Train_Maintenance__c();
        mpwTrain.Active__c = true;
        mpwTrain.Publish__c = true;
        mpwTrain.Train_Type__c = 'GlobalShuttle';
        mpwTrain.Geometry__c = '28nm';
        mpwTrain.Train_Number__c = 'MPW03312';
        mpwTrain.Reservation_Close_Date__c = System.today();
        mpwTrain.Tapeout_Date_Customer__c = System.today() + 6;
        mpwTrain.Fab__c = 'Fab1';
        mpwTrain.Status__c = '28LPSe, 28LPS, 28LPS-RF';
        insert mpwTrain;
        
        return mpwTrain;
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
    
    private static MPW_Reservation__c utilDataRFMethod(MPW_Train_Maintenance__c mpwTrain) { 
    
        MPW_Reservation__c mpwReservation1 = new MPW_Reservation__c();        
        mpwReservation1.MPW_Train_Name__c = mpwTrain.Id;
        mpwReservation1.Name = '2015-03-05600';
        mpwReservation1.Form_Status__c = 'Draft';
        mpwReservation1.Category__c = 'FAB';
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
        mpwPrimeDie1.GMPL_Purpose__c = 'Test';
        mpwPrimeDie1.ShortLoop_Wafer__c = '4';
        mpwPrimeDie1.Backgrind__c = '10';
        mpwPrimeDie1.Expedite_In_DIE_Form__c = '100';
        mpwPrimeDie1.Expedite_In_WAFER_Form__c = '5';
        mpwPrimeDie1.Turnkey_Service__c = 'No';
        insert mpwPrimeDie1;
        
        return mpwPrimeDie1;
    }
    
    public static testMethod void myPrimeDieAttachmentMethod() {  
   
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig);   
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrain);                
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWPrimeDieAttachmentVF'));
        System.currentPageReference().getParameters().put('MPWPrimeDieID', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('AttachmentType','TurnkeyPreAlertForm');
             
        MPWPrimeDieAttachmentController appMatrixClass = new MPWPrimeDieAttachmentController();
        appMatrixClass.fileName = 'Sample';
        appMatrixClass.fileBody = Blob.valueOf('Test Body'); 
        appMatrixClass.attachFile();   
                 
        Test.stopTest() ;  
    }
    
    public static testMethod void myPrimeDieAttachmentMethod1() {  
   
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig );   
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrain);                
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWPrimeDieAttachmentVF'));
        System.currentPageReference().getParameters().put('MPWPrimeDieID', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('AttachmentType','CornerSplit');
             
        MPWPrimeDieAttachmentController appMatrixClass = new MPWPrimeDieAttachmentController();
        appMatrixClass.fileName = 'Sample';
        appMatrixClass.fileBody = Blob.valueOf('Test Body'); 
        appMatrixClass.attachFile();   
                 
        Test.stopTest() ;  
    }
    
    public static testMethod void myPrimeDieAttachmentMethod2() {  
   
        MPW_Approval_Matrix__c mpwApproval = utilDataAMMethod();
        MPW_Config_Settings__c mpwConfig = utilDataCSMethod();
        MPW_Tech_Module__c mpwTechModule = utilDataTeMMethod();
        MPW_Train_Maintenance__c mpwTrain = utilDataTMMethod();
        MPW_Train_Maintenance_Details__c mpwTrainDetails = utilDataTMDMethod(mpwTechModule, mpwTrain, mpwConfig);   
        MPW_Reservation__c mpwReservation1 = utilDataRFMethod(mpwTrain);                
        MPW_Prime_Die__c mpwPrimeDie1 = utilDataPDMethod(mpwReservation1);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWPrimeDieAttachmentVF'));
        System.currentPageReference().getParameters().put('MPWPrimeDieID', mpwPrimeDie1.Id);
        System.currentPageReference().getParameters().put('AttachmentType','SubDevicesExtraction');
             
        MPWPrimeDieAttachmentController appMatrixClass = new MPWPrimeDieAttachmentController();
        appMatrixClass.fileName = 'Sample';
        appMatrixClass.fileBody = Blob.valueOf('Test Body'); 
        appMatrixClass.attachFile();   
                 
        Test.stopTest() ;  
    }
}