/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRCustPartIDLookupController  
    --
    Ashwini     05152015    - Updated code for refactoring of test class.
*/
@isTest(SeeAllData = false)
public class EWSRCustPartIDLookupContTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void myCustPartLookMethod() {
        
        eWSRCustPartIDLookupController partLook = new eWSRCustPartIDLookupController();
        partLook.search();
        partLook.getFormTag();
        partLook.getTextBox();
    }
    
    static testMethod void myCustPartLookMethod1(){
        
        //DataUtilTest.loadEnvironmentVariables();
        Account account = eWSRUtilityTestDataClass.getAccount();
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;
        Test.startTest();        
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        RecordType recordTypeFab5JV = eWSRUtilityTestDataClass.getRecordType('FAB 5JV', 'eWSR_Form__c');
        //Account account = eWSRUtilityTestDataClass.getAccount();
        eWSR_Devices__c device = eWSRUtilityTestDataClass.getDeviceId('FAB 5');
        
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab5JV.Id;
        form.Module__c = 'Clean Tech';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Part_ID__c = device.Id;
        form.Requested_Start_Date__c = System.today()+4;
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        insert form;
        
        PageReference pRef = Page.eWSRCustPartIDLookupPage; 
        pRef.getParameters().put('recNameForm', 'FAB 5JV'); 
        Test.setCurrentPage(pRef); 
        
        eWSRCustPartIDLookupController partLook = new eWSRCustPartIDLookupController();
        partLook.search();
        system.assertEquals(form.Module__c,'Clean Tech');
        Test.stopTest();
    }
}