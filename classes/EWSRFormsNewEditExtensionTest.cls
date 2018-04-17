/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRFormsNewEditExtension 
*/
@isTest(seeAllData=false)
private class EWSRFormsNewEditExtensionTest {

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
    
    static testMethod void myFormCreationMethod() {
        
        /*DataUtilTest.loadEnvironmentVariables();
        Account account = eWSRUtilityTestDataClass.getAccount();
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
        eWSR_Devices__c device1 = eWSRUtilityTestDataClass.getDeviceId1('FAB 7');
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'ACT';
        form.Status__c = 'New';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Full Loop';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Requested_Start_Date__c = date.newInstance(2015, 01, 13);
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.Are_you_providing_start_material__c = 'No';
        form.Value_for_Wafer_Starting_Material__c = 'Recycle Material';
        form.Wafer_Starting_Material__c = 'Others';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        insert form;           
          
        eWSR_Notification_Group__c notiGp = new eWSR_Notification_Group__c();
        String Name = userinfo.getName();
        notiGp.User__c = Name;
        notiGp.eWSR_Form__c = form.Id;
        insert notiGp;      
        Test.startTest();
        Date dt = date.newInstance(2015, 12, 11);
        String dayString = dt.format();
        
        PageReference pRef = Page.eWSRFormsNewEditPage; 
        pRef.getParameters().put('site1', '5'); 
        pRef.getParameters().put('site3','7');
        pRef.getParameters().put('Module','ACT');
        pRef.getParameters().put('Program','28_LP_ACT');
        pRef.getParameters().put('site2','5');
        pRef.getParameters().put('lPro','3');
        pRef.getParameters().put('valstartMaterial','');
        pRef.getParameters().put('startMaterial','No');
        pRef.getParameters().put('mPro','11');
        pRef.getParameters().put('valwaStrMat','');
        pRef.getParameters().put('date',dayString);
        Test.setCurrentPage(pRef); 
                                  
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass = new eWSRFormsNewEditExtension(sc);
        
        formClass.Modvalues();
        formClass.Progvalues();
        formClass.custShort();
        formClass.lotOwnValue();
        formClass.proStartMat();
        formClass.valwaStrMaterial();
        formClass.required();
        formClass.valStartMat();
        formClass.maskPro();
        formClass.masklayers();
        formClass.lotPriority();
        formClass.SOPvalues();
        formClass.SPSRvalues();
        formClass.AddDaysValues();
        formClass.display();
        formClass.unselectclick();
        formClass.selectclick();
        formClass.getSelectedValues();
        formClass.getunSelectedValues();
        formClass.getwafStaMats();
        formClass.search();
        formClass.checkDate();
        formClass.yes();
        formClass.dateValue();
        formClass.filename1 = 'Sample';
        formClass.filebody1 = Blob.valueOf('Test Body');
        formClass.showError = false;
        formClass.showErrorWafer = false;
        formClass.showErrorReqDate = false;
        formClass.save();
        system.assertEquals(formClass.filename1,'Sample');
        Test.stopTest() ;  
    } 
    
    static testMethod void myFormCreationMethod1() {
       
       /* DataUtilTest.loadEnvironmentVariables();
        Account account = eWSRUtilityTestDataClass.getAccount();
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
        
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'TD';
        form.Status__c = 'New';
        form.Program__c = '60nm';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Requested_Start_Date__c = date.newInstance(2016, 04, 11);
        form.Additional_Cycle_Time_required__c = 'No';
        form.Are_you_providing_start_material__c = 'Yes';
        form.Others__c = 'Test';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        insert form;      
         
        Test.startTest() ;
        PageReference pRef = Page.eWSRFormsNewEditPage; 
        pRef.getParameters().put('lPro','2');
        pRef.getParameters().put('valstartMaterial','Recycle Material');
        pRef.getParameters().put('startMaterial','Yes');
        pRef.getParameters().put('mPro','11');
        pRef.getParameters().put('Module','TD');
        pRef.getParameters().put('Program','60nm');
        Test.setCurrentPage(pRef); 
              
          
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass = new eWSRFormsNewEditExtension(sc);
        
        formClass.valStartMat();
        formClass.maskPro();
        formClass.lotPriority();
        formClass.proStartMat();
        formClass.required();
        formClass.display();
        formClass.checkDate();
        formClass.Modvalues();
        formClass.Progvalues();
        formClass.valueEq();
        formClass.masklayers();
        
        Date dt10 = date.newInstance(2016, 10, 11);
        
        form.Requested_Start_Date__c = dt10;
        update form;
        
        ApexPages.StandardController sc10 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass10 = new eWSRFormsNewEditExtension(sc10);
        formClass10.checkDate();

        Date dt11 = date.newInstance(2016, 11, 11);
        
        form.Requested_Start_Date__c = dt11;
        update form;
        
        ApexPages.StandardController sc11 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass11 = new eWSRFormsNewEditExtension(sc11);
        formClass11.checkDate();
        
        Date dt7 = date.newInstance(2015, 08, 11);
        
        form.Requested_Start_Date__c = dt7;
        update form;
        
        ApexPages.StandardController sc8 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass8 = new eWSRFormsNewEditExtension(sc8);
        formClass8.checkDate();
        system.assertEquals(form.Requested_Start_Date__c,dt7);
        Test.stopTest() ;  
    }
    
    static testMethod void myFormCreationMethod2() {
       
        /*DataUtilTest.loadEnvironmentVariables();
        
        Account account = eWSRUtilityTestDataClass.getAccount();
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=account.Id;
        update env;

        User user = eWSRUtilityTestDataClass.getuser();
        User user1 = eWSRUtilityTestDataClass.getuser1();*/
        Account account = [select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        User user = [Select Id from User where Username = 'testeWSRuser@testorg.com.uat'];
        User user1 = [Select Id from User where Username = 'testeWSRuser1@testorg.com.uat'];
        //User user2 = [Select Id from User where Username = 'testeWSRuser2@testorg.com.uat'];
        
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
        form.Requested_Start_Date__c = date.newInstance(2016, 05, 11);
        form.Additional_Cycle_Time_required__c = 'No';
        form.Department_Director_1__c= user1.Id;
        form.Status__c = 'Pending with Planner Approval';
        insert form;
        
        PageReference pRef = Page.eWSRFormsNewEditPage; 
        pRef.getParameters().put('lPro','1');
        pRef.getParameters().put('valstartMaterial','');
        pRef.getParameters().put('mPro','11');
        Test.setCurrentPage(pRef); 
        
        
        Test.startTest() ;  
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass = new eWSRFormsNewEditExtension(sc);
             
        formClass.proStartMat();
        formClass.valStartMat();
        formClass.maskPro();
        formClass.masklayers();
        formClass.lotPriority();
        formClass.valueEq();
        
        Date dt5 = date.newInstance(2016, 06, 11);
        
        form.Requested_Start_Date__c = dt5;
        update form;
        
        ApexPages.StandardController sc5 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass5 = new eWSRFormsNewEditExtension(sc5);
        formClass5.checkDate();  
        
        Date dt6 = date.newInstance(2016, 07, 11);
        
        form.Requested_Start_Date__c = dt6;
        update form;
        
        ApexPages.StandardController sc7 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass7 = new eWSRFormsNewEditExtension(sc7);
        formClass7.checkDate();
        
        Date dt8 = date.newInstance(2016, 09, 11);
        
        form.Requested_Start_Date__c = dt8;
        update form;
        
        ApexPages.StandardController sc9 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass9 = new eWSRFormsNewEditExtension(sc9);
        formClass9.checkDate();
        system.assertEquals(form.Requested_Start_Date__c,dt8);
        Test.stopTest() ;  
    }
}