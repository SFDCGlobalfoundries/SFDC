/*
    Author: Abhita Bansal
    Created Date: 12/09/2014 
    Description: Test class for eWSRFormsNewEditExtension 
*/
@isTest
private class eWSRFormsNewEditExtensionTest1 {
    
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
    
    static testMethod void myFormCreationMethod3() {
        
        /*DataUtilTest.loadEnvironmentVariables();
        
        Account account = new Account(Name = 'GlobalFoundaries' , Short_Name__c = 'gf');
        insert account; */
        
        Account account = [select Id, Name from Account where Name='MYTEST ACCOUNT1'];
        
        RecordType recordTypeFab5 = eWSRUtilityTestDataClass.getRecordType('FAB 5', 'eWSR_Form__c');
        insert new eWSR_Account_Name__c(Name = account.Id);
        
        eWSR_Form__c form = new eWSR_Form__c();
        
        PageReference pRef = Page.eWSRFormsNewEditPage; 
        pRef.getParameters().put('RecordType',recordTypeFab5.Id);
        Test.setCurrentPage(pRef);
        
        Test.startTest() ;  
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass = new eWSRFormsNewEditExtension(sc);
        formClass.save();
        formClass.getwafStaMats();
        
        Test.stopTest();
    }
    
    static testMethod void myFormCreationMethod4() {
       
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
        
        eWSR_Form__c form = new eWSR_Form__c();
        form.RecordTypeId = recordTypeFab7.Id;
        form.Module__c = 'TD';
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
        form.Status__c = 'New';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        insert form;       
        Test.startTest() ;
        PageReference pRef = Page.eWSRFormsNewEditPage; 
        pRef.getParameters().put('lPro','2');
        pRef.getParameters().put('valstartMaterial','Recycle Material');
        pRef.getParameters().put('startMaterial','Yes');
        pRef.getParameters().put('mPro','18');
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
        
        Date dt1 = date.newInstance(2016, 01, 11);
        
        form.Requested_Start_Date__c = dt1;
        update form;
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass1 = new eWSRFormsNewEditExtension(sc1);
        formClass1.checkDate();
        
        Date dt5 = date.newInstance(2016, 05, 11);
        
        form.Requested_Start_Date__c = dt5;
        update form;
        
        ApexPages.StandardController sc5 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass5 = new eWSRFormsNewEditExtension(sc5);
        formClass5.checkDate();
        
        Date dt12 = date.newInstance(2016, 12, 11);
        
        form.Requested_Start_Date__c = dt12;
        update form;
        
        ApexPages.StandardController sc12 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass12 = new eWSRFormsNewEditExtension(sc12);
        formClass12.checkDate();
        
        Test.stopTest();
    }
    
    static testMethod void myFormCreationMethod5() {
        
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
        form.Module__c = 'TD';
        form.Program__c = '40nm';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Requested_Start_Date__c = date.newInstance(2016, 02, 11);
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.Are_you_providing_start_material__c = 'Yes (This is unknown source unscrap.Lot owner to provide substrate)';
        form.Wafer_Starting_Material__c = 'Others';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        form.Status__c = 'New'; 
        insert form;   
        Test.startTest() ;                 
        PageReference pRef1 = Page.eWSRFormsNewEditPage; 
        pRef1.getParameters().put('Module','TD');
        pRef1.getParameters().put('Program','40nm');
        pRef1.getParameters().put('mPro','16');
        Test.setCurrentPage(pRef1); 
        
        
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass1 = new eWSRFormsNewEditExtension(sc1);
        formClass1.devStartMat='ABW123';
        formClass1.Modvalues();
        formClass1.Progvalues();
        formClass1.proStartMat();
        formClass1.getwafStaMats();
        formClass1.checkDate();
        formClass1.valueEq();
        
        form.Part_ID__c = device1.Id;
        form.Requested_Start_Date__c = date.newInstance(2016, 03, 11);
        update form;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass2 = new eWSRFormsNewEditExtension(sc2);
        formClass2.devStartMat='ABW123';
        formClass2.devStartMat2='ABCW235;KLM345';
        formClass2.devStartMat3='ABCW678';
        formClass2.proStartMat();
        formClass2.getwafStaMats();
        formClass2.checkDate();
        ApexPages.CurrentPage().getParameters().put('site1','sample');
        ApexPages.CurrentPage().getParameters().put('site2','sampleTest');
        formClass2.SPSRvalues();
        formClass2.SOPvalues();
        Test.stopTest() ;  
    }
    //added By jabee to increase the code coverage
    static testMethod void myFormCreationMethod6() {
        
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
        form.Module__c = 'TD';
        form.Program__c = '40nm';
        form.Lot_Owner__c = user.Id;
        form.Experiment_purpose__c = 'Mask';
        form.Is_it_a_repeating_experiment__c = 'Yes';
        form.Customer_Name__c = account.Id;
        form.Part_ID__c = device.Id;
        form.Full_loop_Short_loop__c = 'Short Loop';
        form.Customer_Lot_Prefix_or_Full_lot_ID__c = 'TestLotId';
        form.Lot_Quantity_No_of_Wafers__c = 24;
        form.Requested_Start_Date__c = date.newInstance(2016, 02, 11);
        form.Additional_Cycle_Time_required__c = 'Yes';
        form.Are_you_providing_start_material__c = 'Yes (This is unknown source unscrap.Lot owner to provide substrate)';
        form.Wafer_Starting_Material__c = 'Others';
        form.Program_Manager__c = user1.Id;
        form.HOD__c = user2.Id;
        form.Lot_ID_Assigned__c = '780';
        form.Status__c = 'New'; 
        insert form;   
        Test.startTest() ;                 
        PageReference pRef1 = Page.eWSRFormsNewEditPage; 
        pRef1.getParameters().put('Module','TD');
        pRef1.getParameters().put('Program','40nm');
        pRef1.getParameters().put('mPro','16');
        Test.setCurrentPage(pRef1); 
        
        
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass1 = new eWSRFormsNewEditExtension(sc1);
        formClass1.devStartMat='ABW123';
        formClass1.Modvalues();
        formClass1.Progvalues();
        formClass1.proStartMat();
        formClass1.getwafStaMats();
        formClass1.checkDate();
        formClass1.valueEq();
        
        form.Part_ID__c = device1.Id;
        form.Requested_Start_Date__c = Date.today()+1;
        update form;
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(form);
        eWSRFormsNewEditExtension formClass2 = new eWSRFormsNewEditExtension(sc2);
        formClass2.eWSRForm=form;
        list<String> leftselectedlist=new list<string>();
        leftselectedlist.add('sample');
        leftselectedlist.add('Test');
        leftselectedlist.add('Demo');
        formClass2.leftselected=leftselectedlist;
        list<String> rightselectedlist=new list<string>();
        rightselectedlist.add('sample');
        rightselectedlist.add('Test');
        rightselectedlist.add('Demo');
        formClass2.rightselected=rightselectedlist;
        formClass2.devStartMat='ABW123';
        formClass2.devStartMat2='ABCW235;KLM345';
        formClass2.devStartMat3='ABCW678';
        formClass2.proStartMat();
        list<SelectOption> mysamplelist3= formClass2.getwafStaMats();
       mysamplelist3.add(new SelectOption('Others','Others'));
       formClass2.waferStartMaterial();
        formClass2.checkDate();
        ApexPages.CurrentPage().getParameters().put('site1','sample');
        ApexPages.CurrentPage().getParameters().put('site2','sampleTest');
        formClass2.SPSRvalues();
        formClass2.SOPvalues();
        formClass2.yes();
        formClass2.selectclick();
        formClass2.unselectclick();
        list<SelectOption> mysamplelist=formClass2.getunSelectedValues();
         mysamplelist.add(new SelectOption('sample','sample'));
         list<SelectOption> mysamplelist2=formClass2.getSelectedValues();
         mysamplelist.add(new SelectOption('sample1','sample1'));
         formClass2.search();
         formClass2.validateUser();
        Test.stopTest() ;  
    }
}