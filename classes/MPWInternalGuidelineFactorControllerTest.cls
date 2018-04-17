/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWInternalGuidelineFactorController
*/
@isTest
public class MPWInternalGuidelineFactorControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myInternalGlFMethod() {
        
        Internal_Guideline_Factor__c mpwInternalGlF = new Internal_Guideline_Factor__c();
        mpwInternalGlF.DieToWaferConv__c = '(?)/50';
        mpwInternalGlF.ID__c = 34;
        mpwInternalGlF.Reticle__c = 1200;
        mpwInternalGlF.Tech_Node__c = '28nm';
        mpwInternalGlF.Wafer__c = 7843;
       
        insert mpwInternalGlF;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWInternalGuidelineFactorVF'));
        
        MPWInternalGuidelineFactorController appMatrixClass = new MPWInternalGuidelineFactorController();
        appMatrixClass.addNew();
        appMatrixClass.viewRecord();
        appMatrixClass.optionRecords();
        appMatrixClass.sortField = 'Tech_Node__c';
        appMatrixClass.sort();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        
        Test.stopTest() ;  
    }
}