/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRCheckReqFieldsforFabExec
*/
@isTest(SeeAllData = false)
public class EWSRChkReqFldsFabExeClassTest {

     static testMethod void myCheckReqFldsMethod() {
        DataUtilTest.loadEnvironmentVariables();
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();
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
        insert form;
         
        form.Status__c = 'Approved';
        try{
            update form;}
         catch(Exception e){
              System.assert( e.getMessage().contains('Please enter the values for the following fields before approving: Lot ID Assigned and Plan Start Date'), e.getMessage() );
             
         }
         
         eWSR_Form__c form1 = new eWSR_Form__c();
        form1.RecordTypeId = recordTypeFab2.Id;
        form1.Module__c = 'Clean Tech';
        form1.Lot_Owner__c = user.Id;
        form1.Experiment_purpose__c = 'Mask';
        form1.Is_it_a_repeating_experiment__c = 'Yes';
        form1.Customer_Name__c = account.Id;
        form1.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form1.Lot_Quantity_No_of_Wafers__c = 24;
        form1.Status__c = 'Pending with Planner Approval';
        form1.No_of_Mask_Layers_Processing__c = 11;
        form1.Requested_Start_Date__c = System.today();
        form1.Additional_Cycle_Time_required__c = 'No';
        form1.Department_Director_1__c= user1.Id;
        insert form1;
        System.assertEquals(form1.Module__c, 'Clean Tech' );
         
        form1.Status__c = 'New';
        try{
            update form1;}
        catch(Exception e){
            System.assert( e.getMessage().contains('Cannot recall the Approval Process as the Record Status is Pending with Planner Approval'), e.getMessage() );
        }
        Test.stopTest();
     }
    
    static testMethod void testRun1() {
        Test.startTest();
        eWSRUtilityTestDataClass.getHCMEmployee2();
        eWSRUtilityTestDataClass.getHCMEmployee3();
        eWSRUtilityTestDataClass.getHCMEmployee4();
        HCM_Employee__c hcm5 = eWSRUtilityTestDataClass.getHCMEmployee5();
        system.assertEquals(hcm5.First_Name__c,'Test5');
        Test.stopTest();
    }
    
    static testMethod void testRun2() {
        
        eWSRUtilityTestDataClass.getuser2();
        eWSRUtilityTestDataClass.getuser3();
        Test.startTest();
        eWSRUtilityTestDataClass.getuser4();
        User usr = eWSRUtilityTestDataClass.getuser5();
        system.assertEquals(usr.Email, 'testeWSRuser5@testorg.com');
        Test.stopTest();
    }
}