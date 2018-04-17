/*
    Author: Abhita Bansal
    Created Date: 12/10/2014 
    Description: Test class for eWSRSendEmailtoNotiGroupClass  
*/
@isTest(SeeAllData = false)
public class eWSRSendEmailNotiGpClassTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        User user = eWSRUtilityTestDataClass.getuser();
        Test.startTest();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        Account account = eWSRUtilityTestDataClass.getAccount();
        Test.stopTest();
    }
    
    static testMethod void mysendEmailNotiGpMethod() {
        Test.startTest();   
        User user = [Select Id, Name from User where Email ='testeWSRuser@testorg.com' limit 1];        
        User user1 = [Select Id, Name from User where Email ='testeWSRuser1@testorg.com' limit 1];   
        Account account = [Select Id, Name from Account where Name='MYTEST ACCOUNT1'];      
        //User user3 = eWSRUtilityTestDataClass.getuser3();
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        
         Wafer_Allocation__c wafer1 = new Wafer_Allocation__c();
         wafer1.Fab__c = 'FAB 2';
         wafer1.Year__c = '2017';
         wafer1.Month__c = 'Oct';
         wafer1.Wafer_Quantity_Allocated__c = 100;
         wafer1.Remaining_Quantity__c = 100;
         insert wafer1;
        
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
        form.Requested_Start_Date__c = Date.newInstance(2017,10,11);//System.today();
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        insert form;
        
        eWSR_Notification_Group__c notiGp = new eWSR_Notification_Group__c();
        String Name = userinfo.getName();
        notiGp.User__c = Name;
        notiGp.eWSR_Form__c = form.Id;
        insert notiGp;  
        
        form.Status__c = 'Approved';
        form.Lot_ID_Assigned__c = '1907';
        form.Plan_Start_Date__c =  Date.newInstance(2017,10,11);//System.today()+1;
        update form;
        Test.stopTest();
    }
}