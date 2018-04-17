/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRUpdateRemQuanClass
    Ashwini     04102015    - Refactoring test class.
*/
@isTest
public class eWSRUpdateRemQuanClassTest {
    @testSetup static void testdata() {
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
    static testMethod void myUpdateRemQuanMethod() {
       
        //DataUtilTest.loadEnvironmentVariables();
        /*Account account = eWSRUtilityTestDataClass.getAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;
            
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        User user2 = eWSRUtilityTestDataClass.getuser2(); */
        Account account = [select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        User user = [Select Id from User where Username = 'testeWSRuser@testorg.com.uat'];
        User user1 = [Select Id from User where Username = 'testeWSRuser1@testorg.com.uat'];
        User user2 = [Select Id from User where Username = 'testeWSRuser2@testorg.com.uat'];
        
        
        RecordType recordTypeFab7 = eWSRUtilityTestDataClass.getRecordType('FAB 7', 'eWSR_Form__c');
        eWSR_Devices__c device = eWSRUtilityTestDataClass.getDeviceId('FAB 7');
        
        RecordType recordTypeFab3E = eWSRUtilityTestDataClass.getRecordType('FAB 3E', 'eWSR_Form__c');
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        
        Wafer_Allocation__c wafer = new Wafer_Allocation__c();
        wafer.Fab__c = 'FAB 7';
        wafer.Year__c = '2014';
        wafer.Module1__c = 'F7';
        Wafer.Program1__c = 'PI 1';
        wafer.Month__c = 'Dec';
        wafer.Wafer_Quantity_Allocated__c = 100;
        wafer.Remaining_Quantity__c = 100;
        insert wafer;
        
        Wafer_Allocation__c wafer21 = new Wafer_Allocation__c();
        wafer21.Fab__c = 'FAB 7';
        wafer21.Year__c = '2015';
        wafer21.Module1__c = 'F7';
        Wafer21.Program1__c = 'PI 1';
        wafer21.Month__c = 'Jan';
        wafer21.Wafer_Quantity_Allocated__c = 100;
        wafer21.Remaining_Quantity__c = 100;
        insert wafer21;
        test.startTest();                 
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'F7';
        form.Program__c = 'PI 1';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Are_you_providing_start_material__c = 'Yes';
        form.Value_for_Wafer_Starting_Material__c = 'Recycle Material';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Equivalent_Quantity__c = 6;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Lot_Priority__c = '3';
        form.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.No_of_SPSRs__c = 6;
        form.Status__c = 'New';
        form.No_of_SOP_Holds__c = 5;
        form.No_of_Additional_days_required__c = 7;
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id; 
        
        form.Status__c = 'Approved';
        form.Lot_ID_Assigned__c = '768';
        form.Plan_Start_Date__c = date.newInstance(2015, 01, 11);
        
        insert form;
        
        form.UpdateRemQuanOnApproval__c = true;
        form.UpdateRemQuanOnRejection__c = true;
        form.Status__c = 'Rejected';
        update form;
        
        form.Full_loop_Short_loop__c = 'Full Loop';
        form.Status__c = 'Approved';
        form.Lot_ID_Assigned__c = '768';
        form.Plan_Start_Date__c = date.newInstance(2015, 01, 11);
        update form;
       
        form.Full_loop_Short_loop__c = 'Full Loop';
        form.UpdateRemQuanOnApproval__c = true;
        form.UpdateRemQuanOnRejection__c = true;
        form.Status__c = 'Rejected';
        update form;
             
        Wafer_Allocation__c wafer1 = new Wafer_Allocation__c();
        wafer1.Fab__c = 'FAB 2';
        wafer1.Year__c = '2014';
        wafer1.Module1__c = 'Clean Tech';
        wafer1.Month__c = 'Dec';
        wafer1.Wafer_Quantity_Allocated__c = 100;
        wafer1.Remaining_Quantity__c = 100;
        insert wafer1;
        
        Wafer_Allocation__c wafer22 = new Wafer_Allocation__c();
        wafer22.Fab__c = 'FAB 2';
        wafer22.Year__c = '2015';
        wafer22.Module1__c = 'Clean Tech';
        wafer22.Month__c = 'Jan';
        wafer22.Wafer_Quantity_Allocated__c = 100;
        wafer22.Remaining_Quantity__c = 100;
        insert wafer22;
        
        eWSR_Form__c form1 = new eWSR_Form__c();
        form1.RecordTypeId = recordTypeFab2.Id;
        form1.Module__c = 'Clean Tech';
        form1.Lot_Owner__c = user.Id;
        form1.Experiment_purpose__c = 'Mask';
        form1.Is_it_a_repeating_experiment__c = 'Yes';
        form1.Customer_Name__c = account.Id;
        form1.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form1.Lot_Quantity_No_of_Wafers__c = 24;
        form1.Status__c = 'New';
        form1.No_of_Mask_Layers_Processing__c = 11;
        form1.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form1.Additional_Cycle_Time_required__c = 'No';
        form1.Department_Director_1__c= user1.Id;  
        insert form1;
       
        form1.UpdateRemQuanOnApproval__c = true;
        form1.UpdateRemQuanOnRejection__c = true;
        form1.Status__c = 'Rejected';
        try{
             update form1;
        }
       catch(Exception e){
              System.assert( e.getMessage().contains('Equivalent_Quantity__c is Empty'), e.getMessage() );
         }
               
        Wafer_Allocation__c wafer2 = new Wafer_Allocation__c();
        wafer2.Fab__c = 'FAB 3E';
        wafer2.Year__c = '2014';
        wafer2.Module1__c = 'Etest/Backgrind';
        wafer2.Month__c = 'Dec';
        wafer2.Wafer_Quantity_Allocated__c = null;
        wafer2.Remaining_Quantity__c = null;
        insert wafer2;
        
        Wafer_Allocation__c wafer23 = new Wafer_Allocation__c();
        wafer23.Fab__c = 'FAB 3E';
        wafer23.Year__c = '2015';
        wafer23.Module1__c = 'Etest/Backgrind';
        wafer23.Month__c = 'Jan';
        wafer23.Wafer_Quantity_Allocated__c = null;
        wafer23.Remaining_Quantity__c = null;
        insert wafer23;
        
        eWSR_Form__c form2 = new eWSR_Form__c();
        form2.RecordTypeId = recordTypeFab3E.Id;
        form2.Module__c = 'Etest/Backgrind';
        form2.Lot_Owner__c = user.Id;
        form2.Experiment_purpose__c = 'Mask';
        form2.Is_it_a_repeating_experiment__c = 'Yes';
        form2.Customer_Name__c = account.Id;
        form2.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form2.Lot_Quantity_No_of_Wafers__c = 24;
        form2.Equivalent_Quantity__c = 6;
        form2.Status__c = 'New';
        form2.No_of_Mask_Layers_Processing__c = 11;
        form2.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form2.Additional_Cycle_Time_required__c = 'No';
        form2.Department_Director_1__c= user1.Id; 
             
        insert form2;
        
        form2.Status__c = 'Approved';
        form2.Lot_ID_Assigned__c = '768';
        form2.Plan_Start_Date__c = date.newInstance(2015, 01, 11);
        update form2;
        
        wafer2.Year__c = '2014';
        wafer2.Month__c = 'Dec';
        wafer2.Wafer_Quantity_Allocated__c = null;
        wafer2.Remaining_Quantity__c = null;
        update wafer2;
        
        form2.UpdateRemQuanOnRejection__c = true;
        form2.Status__c = 'Rejected';
        update form2;
        
        Wafer_Allocation__c wafer10 = new Wafer_Allocation__c();
        wafer10.Fab__c = 'FAB 3E';
        wafer10.Year__c = '2014';
        wafer10.Module1__c = 'Etest/Backgrind';
        wafer10.Month__c = 'Dec';
        wafer10.Wafer_Quantity_Allocated__c = null;
        wafer10.Remaining_Quantity__c = null;
        insert wafer10;
        
        eWSR_Form__c form10 = new eWSR_Form__c();
        form10.RecordTypeId = recordTypeFab3E.Id;
        form10.Module__c = 'Etest/Backgrind';
        form10.Lot_Owner__c = user.Id;
        form10.Experiment_purpose__c = 'Mask';
        form10.Is_it_a_repeating_experiment__c = 'Yes';
        form10.Customer_Name__c = account.Id;
        form10.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form10.Lot_Quantity_No_of_Wafers__c = 24;
        form10.Equivalent_Quantity__c = 6;
        form10.No_of_Mask_Layers_Processing__c = 11;
        form10.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form10.Additional_Cycle_Time_required__c = 'No';
        form10.Department_Director_1__c= user1.Id;
        insert form10;
        
        form10.UpdateRemQuanOnApproval__c = true;
        update form10;
        
        Wafer_Allocation__c wafer11 = new Wafer_Allocation__c();
        wafer11.Fab__c = 'FAB 3E';
        wafer11.Year__c = '2014';
        wafer11.Module1__c = 'Etest/Backgrind';
        wafer11.Month__c = 'Dec';
        wafer11.Wafer_Quantity_Allocated__c = null;
        wafer11.Remaining_Quantity__c = null;
        insert wafer11;
        
        Wafer_Allocation__c wafer12 = new Wafer_Allocation__c();
        wafer12.Fab__c = 'FAB 3E';
        wafer12.Year__c = '2015';
        wafer12.Module1__c = 'Etest/Backgrind';
        wafer12.Month__c = 'Dec';
        wafer12.Wafer_Quantity_Allocated__c = null;
        wafer12.Remaining_Quantity__c = null;
        insert wafer12;
        
        eWSR_Form__c form11 = new eWSR_Form__c();
        form11.RecordTypeId = recordTypeFab3E.Id;
        form11.Module__c = 'Etest/Backgrind';
        form11.Lot_Owner__c = user.Id;
        form11.Experiment_purpose__c = 'Mask';
        form11.Is_it_a_repeating_experiment__c = 'Yes';
        form11.Customer_Name__c = account.Id;
        form11.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form11.Lot_Quantity_No_of_Wafers__c = 24;
        form11.No_of_Mask_Layers_Processing__c = 11;
        form11.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form11.Additional_Cycle_Time_required__c = 'No';
        form11.Department_Director_1__c= user1.Id;
        insert form11;
        
        form11.Status__c = 'Approved';
        form11.Lot_ID_Assigned__c = '768';
        form11.Plan_Start_Date__c = date.newInstance(2015, 12, 11);
        try{
            update form11;}
        catch(Exception e){
              System.assert( e.getMessage().contains('Equivalent_Quantity__c is Empty'), e.getMessage() );
         }
         
         test.stopTest();      
    }
    
    static testMethod void myUpdateRemQuanMethodAfterSubmission() {
       
        //DataUtilTest.loadEnvironmentVariables();
        /*Account account = eWSRUtilityTestDataClass.getAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;
            
        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();
        User user2 = eWSRUtilityTestDataClass.getuser2(); */
        Account account = [select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        User user = [Select Id from User where Username = 'testeWSRuser@testorg.com.uat'];
        User user1 = [Select Id from User where Username = 'testeWSRuser1@testorg.com.uat'];
        User user2 = [Select Id from User where Username = 'testeWSRuser2@testorg.com.uat'];
                        
        RecordType recordTypeFab7 = eWSRUtilityTestDataClass.getRecordType('FAB 7', 'eWSR_Form__c');
        eWSR_Devices__c device = eWSRUtilityTestDataClass.getDeviceId('FAB 7');
        
        RecordType recordTypeFab3E = eWSRUtilityTestDataClass.getRecordType('FAB 3E', 'eWSR_Form__c');
        RecordType recordTypeFab2 = eWSRUtilityTestDataClass.getRecordType('FAB 2', 'eWSR_Form__c');
        
        
        Wafer_Allocation__c wafer = new Wafer_Allocation__c();
        wafer.Fab__c = 'FAB 7';
        wafer.Year__c = '2014';
        wafer.Module1__c = 'F7';
        Wafer.Program1__c = 'PI 1';
        wafer.Month__c = 'Dec';
        wafer.Wafer_Quantity_Allocated__c = 100;
        wafer.Remaining_Quantity__c = 100;
        insert wafer;
        
        Wafer_Allocation__c wafer21 = new Wafer_Allocation__c();
        wafer21.Fab__c = 'FAB 7';
        wafer21.Year__c = '2015';
        wafer21.Module1__c = 'F7';
        Wafer21.Program1__c = 'PI 1';
        wafer21.Month__c = 'Jan';
        wafer21.Wafer_Quantity_Allocated__c = 100;
        wafer21.Remaining_Quantity__c = 100;
        insert wafer21;
        test.startTest();                 
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'F7';
        form.Program__c = 'PI 1';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Are_you_providing_start_material__c = 'Yes';
        form.Value_for_Wafer_Starting_Material__c = 'Recycle Material';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Equivalent_Quantity__c = 6;
        form.No_of_Mask_Layers_Processing__c = 11;
        form.Lot_Priority__c = '3';
        form.Requested_Start_Date__c = date.newInstance(2014, 12, 11);
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.No_of_SPSRs__c = 106;
        form.Status__c = 'New';
        form.No_of_SOP_Holds__c = 5;
        form.No_of_Additional_days_required__c = 7;
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id; 
        
        insert form;
        
        form.Status__c = 'Pending with Program Manager';
        update form;
        
        
        form.Status__c = 'Rejected';
        update form;
        test.stopTest();      
    } 
}