/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSIMCFormExt Class.
 * @ Date :- 04/10/2016
 * @ Change History :-  
 **/
@isTest
public class FMSIMCFormExtTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();

        FMS_Mapping_Table__c fmstable = new FMS_Mapping_Table__c();
        fmsTable.Field__c = 'Datacheck Options';
        fmsTable.Technology__c = 'IPD5PAE';TriggerHandler.bypass('Device_TriggerHandler');
        fmsTable.DB_Value__c = 'AM(AnalogLastMetal)(AM,FT,MT)(70P5485)';
        fmsTable.UI_Value__c = 'Test UI';

        insert fmsTable;
    }

    public static Account createAccount() {

        Account accountObj = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill1', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria', Fab_9_10__c = 'Yes', SAP_Account_Number__c = '006104', Tech_Geo_Granted__c = '0.007UM', Sold_to_VAT_Registration_Number__c = 7888); 
        insert accountObj;

        return accountObj;
    }
    
    public static Contact createContact(Id accountObjId){

        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1r11r', AccountId = accountObjId, Email = 'con12@gf.com', Department__c = 'Design;Engineering',is_portal_user_active__c = true, Is_Portal_User_Created__c = true);
        insert conObj;

        return conObj;
    }

    public static User createPortalUser(Id conObjId, Id profileId) {

        User portalUser = new User(Username = 'portaluser1@testorg13.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Bruce3', Lastname = 'Wayne4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conObjId, IsActive = true, ProfileId = profileId);
        insert portalUser;

        return portalUser;
    }

    public static Id getContentVer() {

        ContentVersion testContentInsert = new ContentVersion();
        testContentInsert.ContentURL = 'http://www.google.com/';
        testContentInsert.Title = 'Test FMS';
        insert testContentInsert;

        return testContentInsert.Id;
    }

    public static Id mainFromCreate(Id accId, Id conId){

        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.Customer_Name__c = accId;
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsMainForm.ServiceOptions__c = 'Backside Grind';
        fmsMainForm.TestServices__c = 'Yes';
        fmsMainForm.Packaging_Services__c = 'Yes';
        fmsMainForm.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
        fmsMainForm.InputMethod__c = 'Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment';
        fmsMainForm.DataCheckingOptions__c = 'Full';
        fmsMainForm.Technology__c = 'BiCMOS 7WL (SiGe 7WL)';
        fmsMainForm.UserIdPrimary__c = conId;
        fmsMainForm.NamePrimary__c = 'testUser';
        insert fmsMainForm;

        return fmsMainForm.id;
    }

    public static Id mainFromCreate1(Id accId, Id conId){

        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.Customer_Name__c = accId;
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsMainForm.TestServices__c = 'Yes';
        fmsMainForm.Packaging_Services__c = 'No';
        fmsMainForm.DataCheckingOptions__c = 'Full';
        fmsMainForm.Technology__c = 'BiCMOS 8XP (SiGe 8XP)';
        insert fmsMainForm;

        return fmsMainForm.id;
    }
        public static Id mainFromCreate2(Id accId, Id conId){

        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.Customer_Name__c = accId;
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        fmsMainForm.TestServices__c = 'No';
        fmsMainForm.Packaging_Services__c = 'No';
        fmsMainForm.DataCheckingOptions__c = 'Full';
        fmsMainForm.Technology__c = 'BiCMOS 8XP (SiGe 8XP)';
        insert fmsMainForm;

        return fmsMainForm.id;
    }

    public static Form_Management_System__c IMCFormCreate(Id mainFormId, Id testContentInsert, Id accId, Id conId, Id devId){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c(); 
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.Customer_Name__c = accId;
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.ProductName__c = 'test';
        fmsIMCForm.ProductRevision__c = 'Test';
        fmsIMCForm.ListOfMasksReusedFromOther__c = 'test';
        fmsIMCForm.IMCProjectedTapeout__c = Date.valueOf(Date.newInstance(2016, 10, 11));
        fmsIMCForm.Waivers__c = 'No';
        fmsIMCForm.IMCMaskLevelsImpacted__c = 'test'; 
        fmsIMCForm.ListOfMasksReused__c = 'test';
        fmsIMCForm.NewMarkingInfo__c = 'Yes';
        fmsIMCForm.PackageNetlistChange__c = 'Yes';
        fmsIMCForm.PadLocFuncChange__c = 'Yes';
        fmsIMCForm.NumOfUniqDesigns__c = 'No';
        fmsIMCForm.IMCNumOfDesigns__c = 3;
        fmsIMCForm.IMCNumOfFEOLDesigns__c = 4; 
        fmsIMCForm.IMCNumOfBEOLDesigns__c = 5;
        fmsIMCForm.BacksideGrindThickness__c = '180 um';
        fmsIMCForm.TechFeatureRemoval__c = 'No';
        fmsIMCForm.Name__c = 'test;';
        fmsIMCForm.Email__c = 'test@emil.com;';
        fmsIMCForm.Phone__c = '4533435435;';
        fmsIMCForm.NamePrimary__c = 'MrTestcon1r11r';
        fmsIMCForm.EmailPrimary__c = 'testsub@emil.com';
        fmsIMCForm.UserIdPrimary__c = conId;
        fmsIMCForm.CountryPrimary__c = 'India';
        fmsIMCForm.ServiceOptions__c = 'Backside Grind';
        fmsIMCForm.Selected_Contact_Ids__c = 'Test1;Test2';
        fmsIMCForm.IMCInputMethod__c = 'Standard Process: Inputs via Reticle Layout attachment';
        fmsIMCForm.FileAttachment__c = testContentInsert;
        fmsIMCForm.AdvancedProcessFileAttachment__c = testContentInsert;
        fmsIMCForm.TestServices__c = 'Yes';
        fmsIMCForm.Packaging_Services__c = 'Yes';
        fmsIMCForm.OverrideParentOptions__c = 'No';
        fmsIMCForm.ParentChangesIdentified__c = 'No';
        fmsIMCForm.Deliverable__c = 'Untested Wafer';
        fmsIMCForm.DataCheckingOptions__c = 'MFG-Only';
        fmsIMCForm.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
        fmsIMCForm.Device__c = devId;
        insert fmsIMCForm;

        return fmsIMCForm;
    }

    public static Form_Management_System__c IMCFormCreate1(Id mainFormId, Id accId, Id conId){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Customer_Name__c = accId;
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = 'Yes';
        fmsIMCForm.ParentChangesIdentified__c = 'Yes';
        fmsIMCForm.Name__c = 'test;';
        fmsIMCForm.UserIdPrimary__c = conId;
        fmsIMCForm.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }

    public static Form_Management_System__c IMCFormCreate2(Id mainFormId, Id accId, String OPValue, String ChIdValue){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Customer_Name__c = accId;
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = OPvalue;
        fmsIMCForm.ParentChangesIdentified__c = ChIdValue;
        fmsIMCForm.DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)';
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }

    public static Form_Management_System__c IMCFormCreate3(Id mainFormId, String OPValue, String InMValue, String cusValue, String mfgValue){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = OPvalue;
        fmsIMCForm.ServiceOptions__c = 'Backside Grind;Dicing;Other';
        fmsIMCForm.IMCInputMethod__c = InMValue;
        fmsIMCForm.StepPlanCustomRequirement1__c = 'No';
        fmsIMCForm.TechFeatureRemoval__c = 'Yes';
        fmsIMCForm.Custom_Features__c = cusValue;
        fmsIMCForm.NotMfgFeatures__c = mfgValue;
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }

    public static Form_Management_System__c IMCFormCreate4(Id mainFormId, String custReqValue){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = 'Yes';
        fmsIMCForm.StepPlanCustomRequirement1__c = custReqValue;
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }
    
    public static Form_Management_System__c IMCFormCreate5(Id mainFormId, String custReqValue){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = 'Yes';
        fmsIMCForm.Selected_Contact_Ids__c= '';
        fmsIMCForm.Name__c= 'test';
        fmsIMCForm.ParentChangesIdentified__c = '';
        
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }
    
    public static Form_Management_System__c IMCFormCreate6(Id mainFormId, String custReqValue){

        Form_Management_System__c fmsIMCForm = new Form_Management_System__c();
        fmsIMCForm.Form_Name__c = 'testIMCForm';
        fmsIMCForm.State_of_the_Form__c = 'Draft';
        fmsIMCForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
        fmsIMCForm.Main_Form_Id__c = mainFormId;
        fmsIMCForm.Parent_Form_Id__c = mainFormId;
        fmsIMCForm.OverrideParentOptions__c = 'Yes';
        fmsIMCForm.Selected_Contact_Ids__c= '';
        fmsIMCForm.Name__c= 'test';
        fmsIMCForm.DataCheckingOptions__c= 'Full';        
        fmsIMCForm.ParentChangesIdentified__c = '';
        
        try {
            Insert fmsIMCForm;
        }
        catch(Exception e) {
            system.debug('Exeception >>' + e);
        }
        return fmsIMCForm;
    }

    static testMethod void formCreationIMC() {
        
        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;
        Id testContentInsert;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);
            
            testContentInsert = getContentVer();
            Id mainFormId = mainFromCreate(accountObj.Id, null); 
            
            imcForm = IMCFormCreate(mainFormId, testContentInsert, accountObj.Id, conobj.Id, null);
        }

        test.StartTest(); 

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);
        ApexPages.currentPage().getParameters().put('tranx', 'InActiveStateChange');
        ApexPages.currentPage().getParameters().put('fieldName','IMCNumOfDesigns__c');
        ApexPages.currentPage().getParameters().put('inpVal','true003');
        Apexpages.currentPage().getParameters().put('uploadFileId', testContentInsert);
        Apexpages.currentPage().getParameters().put('uploadFileName', 'TestFile');

        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert LIMIT 1];

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        IMCext.renderingOfSelected();
        IMCext.changeInputMethod();
        IMCext.getprimaryContactsList();
        IMCext.getParentChangesIdentified();
        IMCext.selectclick();
        IMCext.unselectclick();
        IMCext.getunSelectedValues();
        IMCext.getSelectedValues();
        IMCext.getaddContTable();
        IMCext.getdataCheckingOptsIMC();
        IMCext.getdataCheckingOptsIMCOnly();
        IMCext.getIMCDataCheckingOption();
        IMCext.updateFiledetails();
        IMCext.invInput();
        IMCext.validateSave();

        PageReference pr = IMCext.saveandExit();
        system.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='));

        IMCext.saveForm();
        IMCext.chngHistory();
        IMCext.updateCountOfAddContacts();        
        IMCext.editForm();
        IMCext.updateFormDetails();
        IMCext.copyAsNewForm();
        IMCext.Subscribe();
        IMCext.UnSubscribe();
        IMCext.SubscribeUser();
        IMCext.deleteForm();
        IMCext.stateChangeComments = 'testing';
        IMCext.continueCheck();
        IMCext.showPopup();
        IMCext.closePopup();
        IMCext.cancelForm();
        IMCext.openPDF();
        IMCext.selContentDocId = contentVersion_2.ContentDocumentId;
        IMCext.DeleteAttachment();
        IMCext.prepopulateValues(); 

        FMSIMCFormExt.addcontWrapper testObj = new FMSIMCFormExt.addcontWrapper('name','email','9999999999','987654321');
        FMSIMCFormExt.attachementWrapper attWrap = new FMSIMCFormExt.attachementWrapper();
        FMSIMCFormExt.addContactWrapper contWrap = new FMSIMCFormExt.addContactWrapper('NA', 'NA', 'NA');

        test.stopTest();
    }

    static testMethod void formCreationIMC1() {

        Account accountObj;
        Contact conobj;
        Id testContentInsert;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);

            testContentInsert = getContentVer();
            Id mainFormId = mainFromCreate(accountObj.Id, null);
            imcForm = IMCFormCreate2(mainFormId, accountObj.Id, null, null);
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);
        ApexPages.currentPage().getParameters().put('tranx', 'Subscribe');

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        IMCext.isInvalidInp = true;
        IMCext.validationCheck(null);
        IMCext.freezeForm();
        IMCext.submitForm();
        IMCext.createAddendumForm();
        IMCext.makeFormInactive();
        IMCext.makeFormActive();
        IMCext.requestToThawForm();
        try {
            IMCext.thawForm();
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('Error: Can\' t complete action{Thaw Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
        }

        IMCext.prepopulateValues();

        test.stopTest();
    }

    static testMethod void formCreationIMC2() {

        Form_Management_System__c imcForm;
        Account accountObj;
        User portalUser;
        Contact conobj;
        Id mainFormId;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){

            test.StartTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
            System.runAs(us) {
                AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
                accountObj = createAccount();
                conobj = createContact(accountObj.Id);
            }

            Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Overage Customer Portal Admin' Limit 1];
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' and Name like '%Customer%' Limit 1];

            portalUser = createPortalUser(conobj.Id, portalProfile.Id);
            mainFormId = mainFromCreate(accountObj.Id, conobj.Id);
            Form_Management_System__Share fmsShare = new Form_Management_System__Share();
            fmsShare.AccessLevel = 'Edit';
            fmsShare.ParentId = mainFormId;
            fmsShare.UserOrGroupId = portalUser.Id;
            insert fmsShare;
            
            test.stopTest();
            
            System.runAs(portalUser) {
                imcForm = IMCFormCreate1(mainFormId, accountObj.Id, conobj.Id);              
                PageReference pageRef = Page.FMSIMCFormPage;
                Test.setCurrentPage(pageRef);

                ApexPages.currentPage().getParameters().put('id', imcForm.id);
                ApexPages.currentPage().getParameters().put('tranx', 'UnSubscribe');

                FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm)); 

                system.assert(pageRef.getUrl().contains('UnSubscribe'));
            }   
                        
        }
        
    }

    static testMethod void formCreationIMC3() {

        Account accountObj;
        Contact conobj;
        Id testContentInsert;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);        

            testContentInsert = getContentVer();
            Id mainFormId = mainFromCreate(accountObj.Id, conobj.Id);                
            imcForm = IMCFormCreate(mainFormId, testContentInsert, accountObj.Id, conobj.Id, null);
        }

        test.StartTest(); 

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);
        ApexPages.currentPage().getHeaders().put('Referer','GlobalfoundryView');

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        IMCext.submitForm();
        IMCext.createAddendumForm();
        IMCext.getSelectAddendumValues();
        IMCext.requestToThawForm();

        try {
            IMCext.thawForm();
        }
        catch(Exception e) {
            System.Assert(e.getMessage().contains('Error: Can\' t complete action{Thaw Form} as data integrity checks failed. Please edit the form and visit all pages to fix the issues.'));
        }

        IMCext.getDesignSubmission();
        IMCext.getDeliverablesList();
        IMCext.getServiceOptionsList();
        IMCext.getBacksideGrindThickness();
        IMCext.redirectToSearchPage();
        IMCext.getIMCInputList();
        IMCext.prepopulateValues();
        IMCext.getprimaryContactsList();

        test.stopTest();
    }

    static testMethod void formCreationIMC4() {

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;

        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);

            Id mainFormId = mainFromCreate(accountObj.Id, us.Id);
            imcForm = IMCFormCreate2(mainFormId, accountObj.Id, 'Yes', 'Yes');
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);

        IMCext.getprimaryContactsList();
        IMCext.renderDesignChangesSection();
       
        test.stopTest();
    }

    static testMethod void formCreationIMC5() {

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);
            
            Id mainFormId = mainFromCreate(accountObj.Id, null);
            imcForm = IMCFormCreate3(mainFormId, 'Yes', 'Standard Process: Inputs via Reticle Layout attachment', null, null);
        }
        
        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }

    static testMethod void formCreationIMC6() {

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm ;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);     
            Id mainFormId = mainFromCreate(accountObj.Id, null);
            imcForm = IMCFormCreate3(mainFormId, 'Yes', 'Advanced Process: Inputs via XML file attachment', 'Yes', 'Yes');       
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }

    static testMethod void formCreationIMC7() {

        Account accountObj;
        Contact conobj;
        Id testContentInsert;
        Id mainFormId;
        Device__c dev;
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            test.StartTest();

            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);

            String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            TriggerHandler.bypass('Device_TriggerHandler');
            dev = DeviceChecklistTestDataUtils.createDevice(accountObj.Id,oppId,oppProgId,p.Id);

            testContentInsert = getContentVer();
            mainFormId = mainFromCreate(accountObj.Id, null);      

            test.stopTest();
                    
            Form_Management_System__c imcForm = IMCFormCreate(mainFormId, testContentInsert, accountObj.Id, null, dev.Id);

            PageReference pageRef = Page.FMSIMCFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', imcForm.id);

            FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

            PageReference pr = IMCext.freezeForm();
            system.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='));         
        }
        
    }

    static testMethod void formCreationIMC8() {

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id); 

            Id mainFormId = mainFromCreate1(accountObj.Id, null);
            imcForm = IMCFormCreate4(mainFormId, null);           
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }

    static testMethod void formCreationIMC9() {

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);      

            Id mainFormId = mainFromCreate1(accountObj.Id, null);
            imcForm = IMCFormCreate4(mainFormId, 'No');      
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));

        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }
    
     static testMethod void formCreationIMC10(){

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);      

            Id mainFormId = mainFromCreate1(accountObj.Id, null);
            imcForm = IMCFormCreate5(mainFormId, 'No');      
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));
        IMCext.getParentChangesIdentified();
        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }
    
     static testMethod void formCreationIMC11(){

        Account accountObj;
        Contact conobj;
        Form_Management_System__c imcForm;
       
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;

            accountObj = createAccount();
            conobj = createContact(accountObj.Id);      

            Id mainFormId = mainFromCreate2(accountObj.Id, null);
            imcForm = IMCFormCreate6(mainFormId, 'No');      
        }

        test.StartTest();

        PageReference pageRef = Page.FMSIMCFormPage;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id', imcForm.id);

        FMSIMCFormExt IMCext = new FMSIMCFormExt(new ApexPages.StandardController(imcForm));
        IMCext.stateChangeComments = 'test';
        IMCext.getParentChangesIdentified();
        IMCext.continueCheck();        
        IMCext.getDesignSubmission();        
        Boolean valCheck = IMCext.validationCheck(null);
        System.assertEquals(valCheck ,true);
       
        test.stopTest();
    }
    
}