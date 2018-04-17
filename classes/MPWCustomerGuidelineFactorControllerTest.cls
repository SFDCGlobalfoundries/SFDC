/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWCustomerGuidelineFactorController
*/
@isTest
public class MPWCustomerGuidelineFactorControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myCustGlFMethod() {
        
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
        
        Test.setCurrentPageReference(new PageReference('Page.MPWCustomerGuidelineFactorVF'));
        
        MPWCustomerGuidelineFactorController appMatrixClass = new MPWCustomerGuidelineFactorController();
        appMatrixClass.addNew();
        appMatrixClass.viewRecord();
        appMatrixClass.optionRecords();
        appMatrixClass.sortField = 'TechNodes__c';
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