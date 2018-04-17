/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWProcessGroupTabController
*/
@isTest
public class MPWProcessGroupTabControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myProcessGpTabMethod() {
        
        MPW_Process_Group__c mpwProcessGp = new MPW_Process_Group__c();
        mpwProcessGp.Active__c = true;
        mpwProcessGp.Fab__c = 'Fab1';
        mpwProcessGp.Geometry__c = '28nm';
        mpwProcessGp.Process__c = '28nmGpName';
        
        insert mpwProcessGp;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWProcessGroupTabVF'));
        System.currentPageReference().getParameters().put('sortField','Geometry__c');
        
        MPWProcessGroupTabController appMatrixClass = new MPWProcessGroupTabController(new ApexPages.Standardcontroller(new MPW_Process_Group__c()));
        appMatrixClass.addNew();
        appMatrixClass.viewRecord();
        appMatrixClass.optionRecords();
        appMatrixClass.sortRecords();
        appMatrixClass.getMPWProcessGroupRecords();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        
        Test.stopTest() ; 
    }   
}