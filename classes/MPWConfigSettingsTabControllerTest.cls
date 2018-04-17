/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWConfigSettingsTabController 
*/
@isTest
public class MPWConfigSettingsTabControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myConfigSettingsTabMethod() {
        
        MPW_Config_Settings__c mpwConfigSet = new MPW_Config_Settings__c();
        mpwConfigSet.Name = '28LP';
        mpwConfigSet.Geometry__c = '28nm';
        mpwConfigSet.Active__c = true;
        
        insert mpwConfigSet;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWConfigSettingsTabVF'));
        system.debug('System.Label.MPW_Process_Tab_Id'+System.Label.MPW_Process_Tab_Id);
        //System.currentPageReference().getParameters().put('sfdc.tabName', System.Label.MPW_Process_Tab_Id);
        
        MPWConfigSettingsTabController appMatrixClass = new MPWConfigSettingsTabController();
        appMatrixClass.addNew();
        appMatrixClass.viewRecord();
        appMatrixClass.optionRecords();
        appMatrixClass.sortField = 'Geometry__c';
        appMatrixClass.sort();
        appMatrixClass.getHasPrevious();
        appMatrixClass.getHasNext();
        appMatrixClass.previous();
        appMatrixClass.next();
        appMatrixClass.first();
        appMatrixClass.last();
        
        
        Test.stopTest();
    }
}