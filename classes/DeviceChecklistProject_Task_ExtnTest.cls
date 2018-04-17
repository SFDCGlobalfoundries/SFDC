/***************************************************************************************************************************
Class:         DeviceChecklistProject_Task_ExtnTest
----------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  11/07/2014
Reason:        Test class that covers apex class "DeviceChecklistProject_Task_Extn"

Change Log:     Created     -     JOYDEV     -     23/07/2014   
                Updated     -     Sreedhar   -     10/02/2014
                [Reason]   Removed TASKRAY Application Objects Dependency                           
***************************************************************************************************************************/

@isTest(SeeAllData=false)
public class DeviceChecklistProject_Task_ExtnTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
    }

    /** 
    *  test method:    DCTaskTest1
    *  purpose:        covers test cases for class apex class "DeviceChecklistProject_Task_Extn"
    *                  scenario: covers all methods
    **/
    public static testMethod void DCTaskTest1() {
        //test data
        Checklist_Task__c tsk = createTask('Opportunity', 'competitor_price__c', 'Currency', '500');
        insert tsk;
        
        /*unit tests*/
        test.startTest();
            //set current page
            PageReference pageRef = Page.DeviceChecklistTaskDependency;
            //add parameters to page URL (for current Pagereference 'pageRef')
            pageRef.getParameters().put('id', tsk.Id);
            Test.setCurrentPage(pageRef);
            
            //standard controller instance for Checklist_Task__c 
            ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
            //load controller (extension) class
            DeviceChecklistProject_Task_Extn extn = new DeviceChecklistProject_Task_Extn(sc);
            
            //run all the methods and getter methods
            List<SelectOption> DependentObjects = extn.DependentObjectValues;
            List<SelectOption> DependentFields = extn.DependentFieldValues;
            
            String szObjectLabel = extn.DependentObjectLabel;
            String szFieldLabel = extn.DependentFieldLabel;
                
            extn.CurrentTask.Dependent_Field__c = 'ForecastCategoryName';
            extn.CurrentTask.Dependent_Field_Type__c = 'Picklist';
            List<SelectOption> DependentPicklistFieldOptions = extn.DependentPicklistFieldOptions;
            
            extn.save_Extn();
            
            extn.CurrentTask.Dependent_Field__c = 'AccountId';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Amount';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'CloseDate';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Description';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'ExpectedRevenue';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'ForecastCategoryName';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'NextStep';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'RecordTypeId';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'IsPrivate';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Probability';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'TotalOpportunityQuantity';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'X1st_Product_Production_Date_Score__c';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Add_l_Process_Features__c';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Date_Design_Win_Recommended__c';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Design_Win_Revenue__c';
            extn.PopulateDependentFieldType();
            extn.CurrentTask.Dependent_Field__c = 'Siebel_Opportunity_ID__c';
            extn.PopulateDependentFieldType();
            
            extn.ResetOnObjectChange(); 
            
            extn.NOTNULLValue = True;
            extn.PopulateCompletedValueAndTooltip();
            
            extn.NOTNULLValue = False;
            extn.CurrentTask.Dependent_Field_Type__c = 'Date';
            extn.CurrentTask.Date_Place_Holder__c = Date.today();
            extn.PopulateCompletedValueAndTooltip();
            
            extn.CurrentTask.Dependent_Field_Type__c = 'DateTime';
            extn.CurrentTask.DateTime_Place_Holder__c = DateTime.now();
            extn.PopulateCompletedValueAndTooltip();
            
            extn.CurrentTask.Dependent_Field_Type__c = 'String';
            extn.CurrentTask.Text_Place_Holder__c = 'xxx';
            extn.PopulateCompletedValueAndTooltip();
            
            extn.CurrentTask.Dependent_Field_Type__c = 'TextArea';
            extn.CurrentTask.TextArea_Place_Holder__c = 'xxx xxx';
            extn.PopulateCompletedValueAndTooltip();
            
            extn.CurrentTask.Dependent_Field_Type__c = 'Picklist';
            extn.PopulateCompletedValueAndTooltip();
            
            extn.CurrentTask.Dependent_Object__c = Null;
            extn.CurrentTask.Dependent_Field__c = Null;
            extn.PopulateCompletedValueAndTooltip();
            
            extn.save_Extn();
            extn.cancel_Extn();
        test.stopTest();
    }
    
    /** 
    *  method:         createTask
    *  args:           szObj (object api name), szFld (object's field api name), 
    *                  szTyp (object's field's type), szComVal (value of object's field)
    *  returns:        Checklist_Task__c
    *  purpose:        creates test task
    **/
    public static Checklist_Task__c createTask(String szObj, String szFld, String szTyp, String szComVal) {
        /*create and return the task test data*/
        return new Checklist_Task__c(Name = 'TSKX' + Math.Random(),
                                            Status__c = 'holding',
                                            Dependent_Object__c = szObj,
                                            Dependent_Field__c = szFld,
                                            Dependent_Field_Type__c = szTyp,
                                            Dependent_Field_Completed_Value__c = szComVal);
    }
}