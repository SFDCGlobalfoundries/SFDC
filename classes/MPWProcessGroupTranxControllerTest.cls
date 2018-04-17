/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWProcessGroupTranxController
*/
@isTest
public class MPWProcessGroupTranxControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myProcessGpTranxMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';
        
        insert mpwGeoMap;
                
        MPW_Config_Settings__c mpwConfigSet = new MPW_Config_Settings__c();
        mpwConfigSet.Name = '28LP';
        mpwConfigSet.Geometry__c = '28nm';
        mpwConfigSet.Active__c = true;
        
        insert mpwConfigSet;
        
        MPW_Keyword_Config__c mpwKeywordConfig =  new MPW_Keyword_Config__c();
        mpwKeywordConfig.Active__c = true;
        mpwKeywordConfig.Sequence_No__c = 1;
        mpwKeywordConfig.Type__c = 'FabListing';
        mpwKeywordConfig.Value__c = 'Fab1';
        
        insert mpwKeywordConfig;
        
        MPW_Process_Group__c mpwProcessGp = new MPW_Process_Group__c();
        mpwProcessGp.Active__c = true;
        mpwProcessGp.Fab__c = 'Fab1';
        mpwProcessGp.Geometry__c = '28nm';
        mpwProcessGp.Process__c = '28nmGpName';
        
        insert mpwProcessGp;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWProcessGroupTranxVF'));
        System.currentPageReference().getParameters().put('id',mpwProcessGp.Id);
        System.currentPageReference().getParameters().put('returnURL', '/apex/MPWProcessGroupTabVF');
        System.currentPageReference().getParameters().put('tranx', 'Edit');
        
        MPWProcessGroupTranxController appMatrixClass = new MPWProcessGroupTranxController(new ApexPages.Standardcontroller(new MPW_Process_Group__c()));
        appMatrixClass.getFab();
        appMatrixClass.getProcess();
        appMatrixClass.getGeometryList();
        appMatrixClass.save();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.getEditName();
        appMatrixClass.getEditActive();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditProcess();
        appMatrixClass.getEditFab();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        
        Test.stopTest();       
    }
}