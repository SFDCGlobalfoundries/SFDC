/*
 @class: FMSTriggerHandlerTest
 @CreatedBy: Inshu Misra
 @CreatedDate: 29 Sep, 2016
 @Description: to test the FMSTriggerHandler Class...#IM
 @Modifications-
 *
 */

@isTest
public class FMSTriggerHandlerTest {

    @testSetup
    static void setUpMethod(){
        DataUtilTest.loadEnvironmentVariables();
    }
        
    static Account createAccount() {
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('Name', 'TEST rec');            
        fieldValueAccMap.put('stage__c', 'Unqualified');        
        fieldValueAccMap.put('sub_type__c', 'Direct');
        fieldValueAccMap.put('site_department__c', 'test dept1');          
        fieldValueAccMap.put('transaction_type__c', 'transactional');                          
        fieldValueAccMap.put('region__c', 'APJ');        
        fieldValueAccMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Corporate_City__c', 'Lee');                
        fieldValueAccMap.put('Corporate_Country__c', 'Japan');
        fieldValueAccMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Bill_To_City__c', 'Test City');            
        fieldValueAccMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueAccMap.put('recordtypeid', rt); 
        fieldValueAccMap.put('short_name__c', 'TESTrec');
        fieldValueAccMap.put('Customer_Number__c', '10101');
        fieldValueAccMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueAccMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueAccMap.put('financial_territory__c', 'Japan Korea');
        fieldValueAccMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueAccMap.put('bill_to_location__c', 'YES');
        fieldValueAccMap.put('total_employee__c', 100);
        fieldValueAccMap.put('end_customer__c', 'people');
        fieldValueAccMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueAccMap.put('Target_Account__c', 'Yes');
        fieldValueAccMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        fieldValueAccMap.put('Fab_9_10__c', 'Yes'); 
        fieldValueAccMap.put('SAP_Account_Number__c', '006104');
        fieldValueAccMap.put('Customer_Category__c', 'TFA');
        fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        return account1;
    }
    
    static Contact createContact(Id accountObjId){

        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1r11r', AccountId = accountObjId, Email = 'con12@gf.com', Department__c = 'Design;Engineering');
        insert conObj;

        return conObj;
    }

    static User createPortalUser(Id conObjId, Id profileId) {

        User portalUser = new User(Username = 'con12@gf.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Mr', Lastname = 'Testcon1r11r', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conObjId, IsActive = true, ProfileId = profileId);
        insert portalUser;

        return portalUser;
    }

    static FMS_Search_Filter__c createSearchFl(Account accObj) {

        FMS_Search_Filter__c srchFilter = new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today(), Created_Date_To__c = System.today()+3, Customer__c = accObj.Name, Design_Submission_Type__c = 'Single Chip (one GDS)', Form_State__c = 'Draft', Last_Modified_From__c = System.today(), Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'IBM Custom Design', Package_Type__c = 'BCC', Packaging_Services__c = 'Yes', PO_Submission__c = 'Yes', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'Final Submission', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', Tapeout_Date_Projection__c =system.today(),Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'Main Product Definition Form');
        insert srchFilter;

        return srchFilter;
    }
    
    static FMS_Search_Filter__c createSearchF2(Account accObj,string dateOpt) {

        FMS_Search_Filter__c srchFilter = new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', CreationDateOptions__c = dateOpt, ModifiedDateOptions__c = dateOpt, Customer__c = accObj.Name, Design_Submission_Type__c = 'Single Chip (one GDS)', Form_State__c = 'Draft',   Package_Requirement__c = 'IBM Custom Design', Package_Type__c = 'BCC', Packaging_Services__c = 'Yes', PO_Submission__c = 'Yes', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'Final Submission', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', Tapeout_Date_Projection__c =system.today(),Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'Main Product Definition Form');
        insert srchFilter;

        return srchFilter;
    }

    static Form_Management_System__c mainFromCreate(Account accObj, Id conobjId){
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Chip_Interconnect__c' => 'Wirebond', 'DesignSubmission__c' => 'Single Chip (one GDS)','PackageRequirement__c' =>'IBM Custom Design', 'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'Draft','SelAppId__c' => conobjId, 'PackageType__c' => 'BCC', 'Packaging_Services__c' => 'Yes', 'PurchaseOrder__c' => 'Yes', 'ProductName__c' => 'test product', 'ProductRevision__c' => 'rev1', 'ReleaseProcessFlow__c' => 'process 1', 'InputMethod__c' => 'method 1', 'SubmissionType__c' => 'Final Submission', 'ProjectedTapeout__c' => system.today(), 'Technology__c' => 'tech 1', 'TestLevels__c' => 'level 1', 'Customer__c' => accObj.Name};
        
        Form_Management_System__c  fmsMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.MAIN , true);

        return fmsMainForm;
    }

    static Form_Management_System__c spFormCreate(Account accObj, Id mainformId){

        Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'WaitingForReview','Customer__c' => accObj.Name, 'Main_Form_Id__c' => mainFormId};
        Form_Management_System__c  spMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.SP , true);

        return spMainForm;
    }
    
        static Form_Management_System__c spFormCreate1(Account accObj, Id mainformId, Id parentid){

            Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'WaitingForReview','Customer__c' => accObj.Name, 'Main_Form_Id__c' => mainFormId,'Parent_Form_Id__c' => parentid};
        Form_Management_System__c  spMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.SP , true);

        return spMainForm;
    }

    static FMS_Subscription__c createSubscription(Id srchFilter){

        FMS_Subscription__c sub = new FMS_Subscription__c(Form_Inserted__c = true, Form_Status_Change__c = true, Form_Updated__c = true, Form_Deleted__c = true, Subscribed_Date__c = System.Today(), Saved_Search_Id__c = srchFilter);

        insert sub;
        return sub;
    }

    static testmethod void FormNotificationTest(){
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchFl(accObj);
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
			FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        }
        srchFilter = createSearchFl(accObj);
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);        

        mainForm.State_of_the_Form__c = 'Submitted';
        update mainForm;
        System.assertEquals('Submitted',mainForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(mainForm);

        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        delete mainForm;
        
        Test.StopTest();
    }

    static testmethod void FormNotificationTest2(){  
          Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchFl(accObj);
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        
        
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
     
    
     static testmethod void FormNotificationTest3(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchFl(accObj);
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    
    static testmethod void FormNotificationTest4(){  
         Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchFl(accObj);
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
      //  Form_Management_System__c spForm2 = spFormCreate(accObj, mainForm.Id);
      
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm1.SelAppId__c = userinfo.getuserId();
        spForm1.State_of_the_Form__c = 'Approved';
        System.assertEquals('Approved',spForm1.State_of_the_Form__c);
         Form_Management_System__c mainForm2 = mainFromCreate(accObj, conobj.Id);
        spForm1.Main_Form_Id__c= mainForm2.id;
        update spForm1;

        Test.stopTest();  
    }
    
    
 static testmethod void FormNotificationTest5(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchFl(accObj);
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
       // Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        
       // spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
      //  update spForm;
        
         Form_Management_System__c spForm1 = spFormCreate2(accObj, mainForm.Id,spForm.Id,usrObj.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        
        
        Map< id,Form_Management_System__c> fms = new Map<id,Form_Management_System__c>();
        fms.put(spForm.id,spForm);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
    
      
       //fms.clear();
       fms.put(spForm1.id,spForm1);
        System.assertEquals('some name',mainForm.Form_Name__c);  
        Test.stopTest();
    }
    
    static testmethod void FormNotificationTest6(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchF2(accObj,'1week');
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    static testmethod void FormNotificationTest7(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchF2(accObj,'2weeks');
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    static testmethod void FormNotificationTest8(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchF2(accObj,'1month');
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    static testmethod void FormNotificationTest9(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchF2(accObj,'6months');
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    static testmethod void FormNotificationTest10(){  
        Account accObj;
        Contact conobj;
        FMS_Search_Filter__c srchFilter;
        User usrObj;
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            TriggerHandler.bypass('Account_TriggerHandler');
            TriggerHandler.bypass('Contact_TriggerHandler');
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            usrObj = createExtUser(conobj);
            
            srchFilter = createSearchF2(accObj,'1year');
            FMSFieldNotRequiredTracking__c frt = new FMSFieldNotRequiredTracking__c(Name='LastModifiedDate');
            insert frt;
        }
        Test.StartTest();
        Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
        Form_Management_System__c spForm = spFormCreate(accObj, mainForm.Id);
        Form_Management_System__c spForm1 = spFormCreate1(accObj, mainForm.Id,spForm.Id);
        FMS_Subscription__c fmsSubscription = createSubscription(srchFilter.Id);
        FMSTriggerHandler.isRunOnce = false;
        spForm.SelAppId__c = conobj.Id;
        spForm.State_of_the_Form__c = 'Approved';
        update spForm;
        System.assertEquals('Approved',spForm.State_of_the_Form__c);
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(spForm1);
        
        FMSTriggerHandler obj = new FMSTriggerHandler();
        obj.fmsBeforeInsert(fms);
        Test.stopTest();
    }
    
    static Form_Management_System__c spFormCreate2(Account accObj, Id mainformId, Id parentid, Id conId){

            Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'WaitingForReview','Customer__c' => accObj.Name, 'Main_Form_Id__c' => mainFormId,'Parent_Form_Id__c' => parentid};
        Form_Management_System__c  spMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.SP , true);

        return spMainForm;
    }
    
    static user createExtUser(Contact cObj){
        Profile portalProfile=[SELECT Id,name FROM Profile where name ='Overage Customer Portal Profile' limit 1];
        User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = cObj.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = cObj.Email,
                EmailEncodingKey = 'UTF-8',
                LastName = cObj.LastName,
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);
        return user1;
}
    

}