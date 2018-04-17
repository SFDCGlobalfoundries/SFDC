/*
    Author: Abhita Bansal
    Created Date: 24/08/2015 
    Description: Test class for MPWConfigSettingsTranxController
*/
@isTest
public class MPWConfigSettingsTranxControllerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    public static testMethod void myConfigSettingsTranxMethod() {
        
        MPW_Config_Settings__c mpwConfigSet = new MPW_Config_Settings__c();
        mpwConfigSet.Name = '28LP';
        mpwConfigSet.Geometry__c = '28nm';
        mpwConfigSet.Active__c = true;
        
        insert mpwConfigSet;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWConfigSettingsTabVF'));        
        System.currentPageReference().getParameters().put('id',mpwConfigSet.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        System.currentPageReference().getParameters().put('returnURL','/apex/MPWConfigSettingsTabVF?sfdc.tabName='+System.Label.MPW_Process_Tab_Id);
        
        MPWConfigSettingsTranxController appMatrixClass = new MPWConfigSettingsTranxController(new ApexPages.Standardcontroller(new MPW_Config_Settings__c()));
        appMatrixClass.save();
        appMatrixClass.edit();
        appMatrixClass.cancel();
        appMatrixClass.backToList();
        appMatrixClass.getProcessTypes();
        appMatrixClass.getEditGeometry();
        appMatrixClass.getEditProcess();
        appMatrixClass.getEditRule();
        appMatrixClass.getShowEdit();
        appMatrixClass.getShowSave();
        appMatrixClass.getShowCancel();
        appMatrixClass.getEditActive();
        
        Test.stopTest();
    }
    
    public static testMethod void myConfigSettingsTranxMethod1() {
        
        MPW_Config_Settings__c mpwConfigSet = new MPW_Config_Settings__c();
        mpwConfigSet.Name = '28LP';
        mpwConfigSet.Geometry__c = '28nm';
        mpwConfigSet.Active__c = true;        
        mpwConfigSet.Rule__c = '109a';
        
        insert mpwConfigSet;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWConfigSettingsTabVF'));
        System.currentPageReference().getParameters().put('from', 'MPWProcessDM');
        System.currentPageReference().getParameters().put('id',mpwConfigSet.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        System.currentPageReference().getParameters().put('link','true');
        System.currentPageReference().getParameters().put('returnURL','/apex/MPWConfigSettingsTabVF?sfdc.tabName='+System.Label.MPW_Process_DM_Tab_Id);
        
        MPWConfigSettingsTranxController appMatrixClass = new MPWConfigSettingsTranxController(new ApexPages.Standardcontroller(new MPW_Config_Settings__c()));
        appMatrixClass.save();
        appMatrixClass.cancel();
        
        Test.stopTest();
    }
    
    public static testMethod void myConfigSettingsTranxMethod2() {
        
        MPW_Config_Settings__c mpwConfigSet = new MPW_Config_Settings__c();
        mpwConfigSet.Name = '28LP';
        mpwConfigSet.Geometry__c = '28nm';
        mpwConfigSet.Active__c = false;
        
        insert mpwConfigSet;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.MPWConfigSettingsTabVF'));        
        System.currentPageReference().getParameters().put('id',mpwConfigSet.Id);
        System.currentPageReference().getParameters().put('tranx','Edit');
        System.currentPageReference().getParameters().put('returnURL','/apex/MPWConfigSettingsTabVF?sfdc.tabName='+System.Label.MPW_Process_Tab_Id);
        
        MPWConfigSettingsTranxController appMatrixClass = new MPWConfigSettingsTranxController(new ApexPages.Standardcontroller(new MPW_Config_Settings__c()));
        appMatrixClass.save();
        
        Test.stopTest();
    }
}