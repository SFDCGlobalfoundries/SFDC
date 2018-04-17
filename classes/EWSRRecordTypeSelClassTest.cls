/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRRecordTypeSelectionClass  
*/
@isTest(SeeAllData = false)
public class EWSRRecordTypeSelClassTest {
    
    @testsetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        Test.startTest();
        User user4 = eWSRUtilityTestDataClass.getuser4();
        User user2 = eWSRUtilityTestDataClass.getuser2();
        Test.stopTest();
    }
        
    static testMethod void myRecordSelMethod() {
        User user = [Select id,Name from User where Email='testeWSRuser@testorg.com'];//eWSRUtilityTestDataClass.getuser();
        User user1 = [Select id,Name from User where Email='testeWSRuser1@testorg.com'];//eWSRUtilityTestDataClass.getuser1();
        User user4 = [Select id,Name from User where Email='testeWSRuser4@testorg.com'];//eWSRUtilityTestDataClass.getuser4();
        User user2 = [Select id,Name from User where Email='testeWSRuser2@testorg.com'];//eWSRUtilityTestDataClass.getuser2();
        Test.startTest();        
        Account account = eWSRUtilityTestDataClass.getAccount();
        RecordType recordTypeFab5 = eWSRUtilityTestDataClass.getRecordType('FAB 5', 'eWSR_Form__c');
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab5.Id;
        form.Module__c = 'Clean Tech';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Requested_Start_Date__c = System.today();
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        
        System.runas(user4){
            insert form;
        }
        List<Id> user4Id = new List<Id>();
        user4Id.add(user4.Id);
            
        PageReference pRef = Page.eWSRInlineErrorMessagePage; 
        pRef.getParameters().put('id', form.Id); 
        pRef.getParameters().put('retURL','');
        Test.setCurrentPage(pRef); 
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRRecordTypeSelectionClass formClass = new eWSRRecordTypeSelectionClass(sc);
        
        formClass.str_eWSRRecordType = 'FAB 5';
        
        formClass.userId = user4Id;
        System.runas(user4){
            formClass.redirectTo();
            
        }
        formClass.m_Cancel();
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 3E';
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 2';
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 5JV';
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 3';
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 6';
        formClass.m_Continue();
        
        formClass.str_eWSRRecordType = 'FAB 7';
        formClass.m_Continue();
        
        System.runAs(user2){
            formClass.redirectTo();
        }
        system.assertEquals(formClass.str_eWSRRecordType,'FAB 7');
        Test.stopTest();
    }
    
    static testMethod void myRecordSelMethod1() {
        User user = [Select id,Name from User where Email='testeWSRuser@testorg.com'];//eWSRUtilityTestDataClass.getuser();
        User user1 = [Select id,Name from User where Email='testeWSRuser1@testorg.com'];//eWSRUtilityTestDataClass.getuser1();
        User user3 = [Select id,Name from User where Email='testeWSRuser4@testorg.com'];//eWSRUtilityTestDataClass.getuser4();
        User user2 = [Select id,Name from User where Email='testeWSRuser2@testorg.com'];//eWSRUtilityTestDataClass.getuser2();
        Test.startTest();    
        Account account = eWSRUtilityTestDataClass.getAccount();
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        
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
        form.Requested_Start_Date__c = System.today();
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        
        
        System.runas(user3){
            insert form;
        }
        
        PageReference pRef = Page.eWSRInlineErrorMessagePage; 
        pRef.getParameters().put('id', form.Id); 
        pRef.getParameters().put('retURL','');
        Test.setCurrentPage(pRef); 
                
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRRecordTypeSelectionClass formClass = new eWSRRecordTypeSelectionClass(sc);
        
        formClass.str_eWSRRecordType = 'FAB 2';
        System.runas(user3){
            formClass.redirectTo();}
        formClass.m_Cancel();
        formClass.m_Continue();
        
        System.runAs(user1){
            formClass.redirectTo();
        }
        
        system.assertEquals(formClass.str_eWSRRecordType,'FAB 2');        
        Test.stopTest();
    }
}