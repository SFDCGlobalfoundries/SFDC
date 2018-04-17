/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSR_Form_ShareForApproval 
*/
@isTest(SeeAllData = false)
public class eWSRFormShareAppTest {
    @testSetup static void dataSetup() {
        DataUtilTest.loadEnvironmentVariables();
        Account account = eWSRUtilityTestDataClass.getAccount();   
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;         
        User user = eWSRUtilityTestDataClass.getuser();
        Test.startTest();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        User user2 = eWSRUtilityTestDataClass.getuser2();
        
        Test.stopTest();
    }
    
    static testMethod void myeWSRAppMethod() {
        User user = [Select Id, Name from User where username = 'testeWSRuser@testorg.com.uat'];
        User user1 = [Select Id, Name from User where username = 'testeWSRuser1@testorg.com.uat'];
        User user2 = [Select Id, Name from User where username = 'testeWSRuser2@testorg.com.uat'];  
        Account account = [Select id, Name from Account where Name = 'MYTEST ACCOUNT1'];                      
                   
        RecordType recordTypeFab7 = eWSRUtilityTestDataClass.getRecordType('FAB 7', 'eWSR_Form__c');
        eWSR_Devices__c device = eWSRUtilityTestDataClass.getDeviceId('FAB 7');
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'ACT';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Requested_Start_Date__c = System.today()+4;
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        insert form;       
        
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        Test.startTest();
        eWSR_Form__c form1 = new eWSR_Form__c();
        form1.RecordTypeId = recordTypeFab2.Id;
        form1.Module__c = 'ACT';
        form1.Lot_Owner__c = user.Id;
        form1.Experiment_purpose__c = 'Mask';
        form1.Is_it_a_repeating_experiment__c = 'Yes';
        form1.Customer_Name__c = account.Id;
        form1.Part_ID__c = device.Id;
        form1.Full_loop_Short_loop__c = 'Short Loop';
        form1.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form1.Lot_Quantity_No_of_Wafers__c = 24;
        form1.Requested_Start_Date__c = System.today()+4;
        form1.Additional_Cycle_Time_required__c = 'Yes';
        form1.Program_Manager__c = user1.Id;
        form1.HOD__c = user2.Id;
        form1.Lot_ID_Assigned__c = '780';
        insert form1;       
        
        RecordType recordTypeFab3 = eWSRUtilityTestDataClass.getRecordType('FAB 3', 'eWSR_Form__c');
        
        eWSR_Form__c form2 = new eWSR_Form__c();
        form2.RecordTypeId = recordTypeFab3.Id;
        form2.Module__c = 'ACT';
        form2.Lot_Owner__c = user.Id;
        form2.Experiment_purpose__c = 'Mask';
        form2.Is_it_a_repeating_experiment__c = 'Yes';
        form2.Customer_Name__c = account.Id;
        form2.Part_ID__c = device.Id;
        form2.Full_loop_Short_loop__c = 'Short Loop';
        form2.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form2.Lot_Quantity_No_of_Wafers__c = 24;
        form2.Requested_Start_Date__c = System.today()+4;
        form2.Additional_Cycle_Time_required__c = 'Yes';
        form2.Program_Manager__c = user1.Id;
        form2.HOD__c = user2.Id;
        form2.Lot_ID_Assigned__c = '780';
        insert form2;    
        Test.stopTest(); 
    } 
    
    static testMethod void myeWSRAppMethod1() {
        User user = [Select Id, Name from User where username = 'testeWSRuser@testorg.com.uat'];
        User user1 = [Select Id, Name from User where username = 'testeWSRuser1@testorg.com.uat'];
        User user2 = [Select Id, Name from User where username = 'testeWSRuser2@testorg.com.uat'];  
        Account account = [Select id, Name from Account where Name = 'MYTEST ACCOUNT1'];                      
        
        eWSR_Devices__c device = eWSRUtilityTestDataClass.getDeviceId('FAB 7');
        RecordType recordTypeFab3E = eWSRUtilityTestDataClass.getRecordType('FAB 3E', 'eWSR_Form__c');
        
        eWSR_Form__c form1 = new eWSR_Form__c();
        form1.RecordTypeId = recordTypeFab3E.Id;
        form1.Module__c = 'ACT';
        form1.Lot_Owner__c = user.Id;
        form1.Experiment_purpose__c = 'Mask';
        form1.Is_it_a_repeating_experiment__c = 'Yes';
        form1.Customer_Name__c = account.Id;
        form1.Part_ID__c = device.Id;
        form1.Full_loop_Short_loop__c = 'Short Loop';
        form1.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form1.Lot_Quantity_No_of_Wafers__c = 24;
        form1.Requested_Start_Date__c = System.today()+4;
        form1.Additional_Cycle_Time_required__c = 'Yes';
        form1.Program_Manager__c = user1.Id;
        form1.HOD__c = user2.Id;
        form1.Lot_ID_Assigned__c = '780';
        insert form1;      
    }
}