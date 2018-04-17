/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWInternalGuidelineFactTranxController
*/
@isTest
public class MPWInternalGlFactTranxControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myInternalGlFactTranxMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';
        
        insert mpwGeoMap;
        
        Internal_Guideline_Factor__c mpwInternalGlF = new Internal_Guideline_Factor__c();
        mpwInternalGlF.DieToWaferConv__c = '(?)/50';
        mpwInternalGlF.ID__c = 34;
        mpwInternalGlF.Reticle__c = 1200;
        mpwInternalGlF.Tech_Node__c = '28nm';
        mpwInternalGlF.Wafer__c = 7843;
       
        insert mpwInternalGlF;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWInternalGuidelineFactTranxVF'));  
        System.currentPageReference().getParameters().put('id',mpwInternalGlF.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        
        MPWInternalGuidelineFactTranxController appMatrixClass = new MPWInternalGuidelineFactTranxController(new ApexPages.Standardcontroller(new Customer_Guideline_Factor__c()));
        appMatrixClass.save();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.getEditId();
        appMatrixClass.getEditReticle();
        appMatrixClass.getEditTechNode();
        appMatrixClass.getEditWafer();
        appMatrixClass.getEditDieToWafer();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.getTechNodesList();
        
        Test.stopTest();
    }
}