/*
    Author: Abhita Bansal
    Created Date: 27/08/2015 
    Description: Test class for MPWGMPLProjectNameCustomLookupController
*/
@isTest
public class MPWGMPLProNameCustLookControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    private static MPW_Geometry_Mapping__c utilDataGMMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = new MPW_Geometry_Mapping__c();
        mpwGeoMap.Name = '28nm';
        mpwGeoMap.Geometry_ID__c = '0.028UM';   
        mpwGeoMap.Use_Process_Type__c = true; 
        mpwGeoMap.Active__c = true;
        insert mpwGeoMap;
        
        return mpwGeoMap;
    }
    
    private static GMPL_BX009__c utilDataGMPLMethod() {
        
        GMPL_BX009__c gmplBX = new GMPL_BX009__c();
        gmplBX.Geometry__c = '28nm';
        insert gmplBX;
        
        return gmplBX;
    }
    
    public static testMethod void myGMPLProjectNameMethod() {
        
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        GMPL_BX009__c gmplBX = utilDataGMPLMethod();
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWGMPLProjectNameCustomLookupVF'));  
        System.currentPageReference().getParameters().put('geo','28nm');
        System.currentPageReference().getParameters().put('sear','GMPL');
        
        MPWGMPLProjectNameCustomLookupController appMatrixClass = new MPWGMPLProjectNameCustomLookupController();
        appMatrixClass.searchGMPL();
        
        Test.stopTest();
    } 
    
    public static testMethod void myGMPLProjectNameMethod1() {
    
        MPW_Geometry_Mapping__c mpwGeoMap = utilDataGMMethod();
        GMPL_BX009__c gmplBX = utilDataGMPLMethod();
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWGMPLProjectNameCustomLookupVF'));  
        System.currentPageReference().getParameters().put('geo','28nm');
        
        MPWGMPLProjectNameCustomLookupController appMatrixClass = new MPWGMPLProjectNameCustomLookupController();
        appMatrixClass.searchGMPL();
        
        Test.stopTest();
    }    
}