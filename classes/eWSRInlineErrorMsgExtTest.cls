/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRInlineErrorMessageExt 
*/
@isTest
public class eWSRInlineErrorMsgExtTest {

    @testsetup public static void setupData(){ 
        DataUtilTest.loadEnvironmentVariables();                
        User user = eWSRUtilityTestDataClass.getuser();
        Test.startTest();  
        User user1 = eWSRUtilityTestDataClass.getuser1();
        Account account = eWSRUtilityTestDataClass.getAccount();
        Test.stopTest();    
    }
    
    static testMethod void myInlineMsgMethod() {
        User user = [Select Id,Name from user where Email='testeWSRuser@testorg.com'];
        User user1 = [Select Id,Name from user where Email='testeWSRuser1@testorg.com'];
        Account account = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        
        Test.startTest();
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab2.Id;
        form.Module__c = 'Clean Tech';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Remaining_Quantity__c = 20;
        form.Requested_Start_Date__c = System.today();
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        form.Message__c = 'There is not enough wafer balance to cover this request.';
        insert form;
        
        PageReference pRef = Page.eWSRInlineErrorMessagePage; 
        pRef.getParameters().put('id', form.Id); 
        Test.setCurrentPage(pRef); 

        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRInlineErrorMessageExt formClass = new eWSRInlineErrorMessageExt(sc);
        Test.stopTest();
    }
    
    static testMethod void myInlineMsgMethod1() {
       
        User user = [Select Id,Name from user where Email='testeWSRuser@testorg.com'];
        User user1 = [Select Id,Name from user where Email='testeWSRuser1@testorg.com'];
        Account account = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 7', 'eWSR_Form__c');
        
        Test.startTest();        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab2.Id;
        form.Module__c = 'ACT';
        form.Program__c = '28_LP_ACT';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Equivalent_Quantity__c = 5;
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Remaining_Quantity__c = 20;
        form.Requested_Start_Date__c = System.today();
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        form.Message__c = 'There is not enough wafer balance to cover this request.';
        insert form;
        
        PageReference pRef = Page.eWSRInlineErrorMessagePage; 
        pRef.getParameters().put('id', form.Id); 
        Test.setCurrentPage(pRef); 

                
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRInlineErrorMessageExt formClass = new eWSRInlineErrorMessageExt(sc);
        Test.stopTest();
    }
}