/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWCustomerGuidelineFactTranxController
*/
@isTest
public class MPWCustomerGlFactTranxControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myCustGlFactorTranxMethod() {
    
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';
        
        insert mpwGeoMap;
        
        Customer_Guideline_Factor__c mpwCustGlF = new Customer_Guideline_Factor__c();
        mpwCustGlF.Adder3__c = 0;
        mpwCustGlF.Expedite__c = 1200;
        mpwCustGlF.ExtraDice_B__c = 1200;
        mpwCustGlF.Option2__c = 0;
        mpwCustGlF.RecticalSpace_A1__c = 1200;
        mpwCustGlF.ReticleSpace_Min__c = 1200;
        mpwCustGlF.ShortLoop_Wafer__c = 1300;
        mpwCustGlF.Sub_Devices_Extraction__c = 900;
        mpwCustGlF.TechNodes__c = '28nm';
        mpwCustGlF.Wafer_Form_Delivery__c = 7843;
       
        insert mpwCustGlF;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWCustomerGuidelineFactorTranxVF'));  
        System.currentPageReference().getParameters().put('id',mpwCustGlF.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWCustomerGuidelineFactTranxController appMatrixClass = new MPWCustomerGuidelineFactTranxController(new ApexPages.Standardcontroller(new Customer_Guideline_Factor__c()));
        appMatrixClass.save();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.getEditSubDevice();
        appMatrixClass.getEditOption();
        appMatrixClass.getEditTechNode();
        appMatrixClass.getEditWafer();
        appMatrixClass.getEditExpedite();
        appMatrixClass.getEditShort();
        appMatrixClass.getEditAdder3();
        appMatrixClass.getEditExtraDice();
        appMatrixClass.getEditReticleSpaceA1();
        appMatrixClass.getEditReticleSpaceMin();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.getTechIdList();
        
        Test.stopTest();
    }
}