/*
 * @ Author :- Abhita Bansal
 * @ Description :- contains the test logic for FMS_HierarchyLogic Class.
 * @ Date :- 06/08/2017
 * @ Change History :-  
 **/
@isTest
public class FMS_HierarchyLogicTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();               
    }
    static testMethod void testMethodDescController() {

        test.startTest();
        
        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        insert fmsMainForm;

        FMS_Control_Table__c fmsControlTable = new FMS_Control_Table__c();
        fmsControlTable.Controlling_Field_1_API__c = 'Technology__c';
        fmsControlTable.Dependent_Field_1_API__c = 'Packaging_Services__c';
        fmsControlTable.Level__c = 1;
        fmsControlTable.Type__c = 'Field Hierarchy';
        fmsControlTable.Type_of_Form__c = 'Main';
        insert fmsControlTable;
        
        FMS_HierarchyLogic logicExt = new FMS_HierarchyLogic(new ApexPages.StandardController(fmsMainForm));
        FMS_HierarchyLogic.getDependentFieldsToReset('Technology__c', fmsMainForm, 'Main');
        
        Test.stopTest();
    }

    static testMethod void testMethodDescController1() {

        test.startTest();
        
        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        insert fmsMainForm;

        FMS_Control_Table__c fmsControlTable = new FMS_Control_Table__c();
        fmsControlTable.Controlling_Field_1_API__c = 'Technology__c';
        fmsControlTable.Dependent_Field_1_API__c = 'Packaging_Services__c';
        fmsControlTable.Level__c = 1;
        fmsControlTable.Type__c = 'Variable Mapping';
        fmsControlTable.Type_of_Form__c = 'Main';
        insert fmsControlTable;
        
        //FMS_HierarchyLogic logicExt = new FMS_HierarchyLogic(new ApexPages.StandardController(fmsMainForm));
        FMS_HierarchyLogic.getDependentFieldsToReset('Technology__c', fmsMainForm, 'Main');
        
        Test.stopTest();
    }

}