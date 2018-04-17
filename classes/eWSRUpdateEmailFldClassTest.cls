/*
    Author: Abhita Bansal
    Created Date: 12/10/2014 
    Description: Test class for eWSRUpdateEmailFieldClass  
*/
@isTest(SeeAllData = false)
public class eWSRUpdateEmailFldClassTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();        
        Account account = eWSRUtilityTestDataClass.getAccount();    
        User user3 = eWSRUtilityTestDataClass.getuser3();        
        Test.startTest();
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();        
        Test.stopTest();
    }    
  
    static testMethod void myUpdateEmailMethod() {
        User user3 = [Select Id, Name from User where username = 'testeWSRuser3@testorg.com.uat']; 
        User user = [Select Id, Name from User where username = 'testeWSRuser@testorg.com.uat']; 
        User user1 = [Select Id, Name from User where username = 'testeWSRuser1@testorg.com.uat']; 
        Account account = [Select Id, Name from Account where Name = 'MYTEST ACCOUNT1']; 
        Test.startTest();
          
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
        insert form;
           
        eWSR_Notification_Group__c notiGp = new eWSR_Notification_Group__c();
        notiGp.User__c = user3.Name;
        notiGp.eWSR_Form__c = form.Id;
        insert notiGp;  
        Test.stopTest();
    }
}