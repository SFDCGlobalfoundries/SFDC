/*
 @class: RPFMSRecordShareClassTest 
 @CreatedBy: Inshu Misra
 @CreatedDate: 6 Oct, 2016
 @Description: to test the FormManagementMainClass class...#IM
 @Modifications-
 *
 */
@isTest
public class FMSRcdShareClassTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();               
    }
    
    static Account createAccount() { 
        // Create Account
         RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
        testAcct.SAP_Account_ID__c = '000017924';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct1';
        testAcct.Fab_9_10__c = 'Yes';
        //Insert testAcct;   
        return testAcct;
    }
    
    static testmethod void formManagementTest1(){
        User portalUser;
        List<Contact> contList;
        List<FMS_Search_Filter__c> filtList;
        Form_Management_System__c fms;
        List<FMS_Subscription__c> sub;
        Id mainFormRecordTypeId;
        Id spFormRecordTypeId;
        Id ddrFormRecordTypeId;
        Id ritFormRecordTypeId;
        Id imcFormRecordTypeId;
        Id accId;
        Profile profileId;
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        account acc = createAccount();
        insert acc;        
        accId = acc.Id;
       } 
        mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        spFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(Label.Form_Type_SP).getRecordTypeId();
        ddrFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Return (DDR)').getRecordTypeId();
        ritFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId();
        imcFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Incremental Mask Change (IMC)').getRecordTypeId();
    
        fms = new Form_Management_System__c();
        fms.Customer_Name__c = accId;
        fms.recordTypeID = mainFormRecordTypeId;
        fms.Form_Name__c = 'some name'; 
        fms.State_of_the_Form__c = 'Draft';
        //fms.add(new Form_Management_System__c(Customer_Name__c = accId, recordTypeID = spFormRecordTypeId, Form_Name__c = 'some name', State_of_the_Form__c = 'WaitingForReview'));
        
        FMSEmailTemplates.SendEditEmail = true;
        insert fms;
        

        filtList = new List<FMS_Search_Filter__c>();
        filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = accId,
            Design_Submission_Type__c = 'Single Chip (one GDS)', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                     PO_Submission__c = 'submission', Product_Name__c = 'test product', Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                     Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'type 1', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                     Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'Main Product Definition Form;Design Data Return (DDR);Design Data Submission (RIT);Incremental Mask Change (IMC);'+Label.Form_Type_SP
                     ));
        insert filtList;        
        sub = new List<FMS_Subscription__c>([select Id, Form_Deleted__c from FMS_Subscription__c where Form_Id__c =:fms.Id]);
        for(FMS_Subscription__c s:sub){
            s.Form_Deleted__c = true;
            s.Saved_Search_Id__c = filtList[0].Id;
        }
        update sub; 
      
         System.runAs(thisUser){
        contList = new List<Contact>();
        contList.add(new Contact(FirstName = 'Test', LastName = 'Cont1', AccountId = accId, Email = 'con12@gf.com', Department__c = 'Design;Engineering', 
        is_portal_user_active__c = false));
        insert contList;
        
        
        
        
        
         profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        User usr = new User(LastName = 'LIVESTON12',
                                FirstName='JASON234',
                                Alias = 'jliv12',
                                Email = 'jason.liveston122df.com',
                                Username = 'jason.liveston11@df.com',
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                LocaleSidKey = 'en_US',
                                contactId = contList[0].id
                               );
            Profile portalProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Portal Profile' LIMIT 1];
            Contact con = [select Id from Contact limit 1];
                     
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('viewSearchId',filtList[0].Id);
        System.currentPageReference().getParameters().put('searchId',filtList[0].Id);
        system.currentPageReference().getHeaders().put('Referer','GlobalfoundryView');
        FormManagementMainClass cls = new FormManagementMainClass();
        FormManagementMainClass cls1;
        List<Contact> conList;
     
            System.currentPageReference().getParameters().put('id',filtList[0].Id);
        FMS_Additional_Filters__c a = new FMS_Additional_Filters__c();
        
        
         List<FMS_Additional_Filters__c> addFilters = new List<FMS_Additional_Filters__c>();
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test1', Field_API_Name__c = 'Form_State__c', Field_Name__c = 'Form_State__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test2', Field_API_Name__c = 'Chip_Interconnect__c', Field_Name__c = 'Chip_Interconnect__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test3', Field_API_Name__c = 'Package_Requirement__c', Field_Name__c = 'Package_Requirement__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test4', Field_API_Name__c = 'Design_Submission_Type__c', Field_Name__c = 'Design_Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test5', Field_API_Name__c = 'Package_Type__c', Field_Name__c = 'Package_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test6', Field_API_Name__c = 'Packaging_Services__c', Field_Name__c = 'Packaging_Services__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test7', Field_API_Name__c = 'Product_Name__c', Field_Name__c = 'Product_Name__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test8', Field_API_Name__c = 'Product_Revision__c', Field_Name__c = 'Product_Revision__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test9', Field_API_Name__c = 'Release_Process__c', Field_Name__c = 'Release_Process__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test10', Field_API_Name__c = 'PO_Submission__c', Field_Name__c = 'PO_Submission__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test11', Field_API_Name__c = 'Submission_Type__c', Field_Name__c = 'Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test12', Field_API_Name__c = 'Step_Plan_Input_Method__c', Field_Name__c = 'Step_Plan_Input_Method__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test13', Field_API_Name__c = 'Tapeout_Date_Projection__c', Field_Name__c = 'Tapeout_Date_Projection__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test14', Field_API_Name__c = 'Technology__c', Field_Name__c = 'Technology__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test15', Field_API_Name__c = 'Test_Levels_Desired__c', Field_Name__c = 'Test_Levels_Desired__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test16', Field_API_Name__c = 'Test_Services__c', Field_Name__c = 'Test_Services__c'));        
        insert addFilters;    
        cls.searchUnsubscibeId = filtList[0].Id;
        FormManagementMainClass.fmsSearchResultWrapper wrap = new FormManagementMainClass.fmsSearchResultWrapper(fms);
        cls.unsubscribeId = sub[0].Id;
        cls.subResultError = true;
        Test.StartTest();
        cls.showResultsMethod();
        cls.pageNumbersaveSrch = 1;
        Integer numSearch = cls.pageNumbersaveSrch;
        cls.hasPrevioussaveSrch = true;
        Boolean hasPSrch = cls.hasPrevioussaveSrch;        
        cls.hasNextsaveSrch = true;
        Boolean hasNSrch = cls.hasNextsaveSrch;
        Boolean b = cls.subResultError;
        cls.subscriptionPageNumber = 1;
        Integer num = cls.subscriptionPageNumber;
        cls.hasPreviousSubscription = true;
        Boolean pSub = cls.hasPreviousSubscription;
        cls.hasNextSubscription = true;
        Boolean nSub = cls.hasNextSubscription;
        cls.hasNext = true;
        Boolean hNext = cls.hasNext;
        cls.hasPrevious = true;
        Boolean hPrev = cls.hasPrevious;
        cls.pageNumber = 1;
        Integer pNum = cls.pageNumber;
     
        
        cls.customerRightSelected = new List<String>();
        cls.customerRightSelected.add('Design Data Submission (RIT)');
        cls.customerLeftSelected = new List<String>();
        cls.formTypeLeftSelected = new List<String>();
        cls.formTypeRightSelected = new List<String>();
        
        cls.formTypeRightValues = new Set<String>();
        cls.formTypeRightValues.add('Main Product Definition Form');
        cls.formTypeRightValues.add('Design Data Submission (RIT)');
         cls.formTypeRightValues.add('Incremental Mask Change (IMC)');
 cls.getAddFilterList();
            cls.getFormStateList();
        cls.formTypeLeftSelected.add('All');
        
        cls.customerLeftSelected.add('test');
        cls.customerRightSelected.add('test');

        cls.showPopup();
        cls.addFilterField();
        cls.alertAddFilter();
        cls.checkDate();
        cls.closePopup();
                cls.queryString = 'select id, name,Form_Name__c,Customer__c,State_of_the_Form__c,Form_Type__c,Form_description__c,createdby.name ,PurchaseOrder__c,createdDate,lastModifiedDate,SubmissionType__c,PackageRequirement__c,Chip_Interconnect__c,DesignSubmission__c,TestLevels__c,TestServices__c,Technology__c,Packaging_Services__c,ProductRevision__c,ProjectedTapeout__c,ProductName__c,InputMethod__c   from Form_Management_System__c';
        cls.createCsvFile();
        cls.createMainForm();
        cls.custSelectclick();
         cls.customerRightSelected.add('test');
        cls.custUnselectclick();
        
        cls.exportCsvFile();
        cls.first();
        cls.firstsaveSrch();
        cls.firstSubList();
        cls.FMSSubsciptions();
          cls.formTypeRightValues.clear();
        cls.formTypeUnselectclick();
        cls.formTypeRightValues.add('All');
        cls.formTypeLeftSelected.add('All');
          cls.formTypeLeftSelected.add('test');
        cls.formTypeSelectclick();
      
        cls.getAddFilterList();
        cls.getcustSelectedValues();
        cls.customerLeftValues.add('test');
           cls.customerLeftValues.add('All');
        cls.getcustUnSelectedValues();
        cls.getFMSRecords();
        cls.getFMSSubscriptionVal();
    
        cls.getformTypeUnSelectedValues();
        cls.getformTypeSelectedValues();
       // cls.getTechnologyList();
        cls.last();
        cls.lastsaveSrch();
        cls.lastSubList();
        cls.next();
        cls.nextsaveSrch();
        cls.nextSubList();
        cls.previous();
        cls.previoussaveSrch();
        cls.previousSubList();
        cls.refresh();
        cls.refreshSubsciption();
        cls.resetSearch();
        cls.saveNewSearch();
        cls.searchMethod();
        cls.accessSearch();
        //cls.searchStringMethod(queryString1, techSel, formStateSel, filterObj, custSet, fTypeSet);
        cls.unsubForm();
        cls.autoSubscibeChkBox =true;
        cls.unsubscribeAll();
        cls.autoSubscibeChkBox =false;
        cls.unsubscribeAll();
        cls.unSubscribeSearch();
        cls.deleteSavedSearch();
        cls.formrecordtypeId = mainFormRecordTypeId;
        cls.viewFMSPage();
        cls.formrecordtypeId = spFormRecordTypeId;
        cls.viewFMSPage();
        cls.formrecordtypeId = ddrFormRecordTypeId;
        cls.viewFMSPage();
        cls.formrecordtypeId = ritFormRecordTypeId;
        cls.viewFMSPage();
        cls.formrecordtypeId = imcFormRecordTypeId;
        cls.viewFMSPage();
        cls.FMSSubsciptions();
        
        
        cls.tesemehtod();
        Test.StopTest();
        
        cls.getdateOptions();
        cls.getdateTypeOption();
        Set<string> newset = new set<string>();
            newset.add('testAll');
        cls.formTypeRightValues = newset;
        cls.getAddFilterList();
        system.assert(cls != NULL);
       } 
    }
    
    @isTest
    static void FMStestcontrol1(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        account acc = createAccount();
        insert acc;        
        Id accId = acc.Id;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
      User usr = new User(LastName = 'LIVESTON12',
                                FirstName='JASON234',
                                Alias = 'jliv12',
                                Email = 'jason.liveston122@df.com',
                                Username = 'jason.liveston11@df.com',
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                LocaleSidKey = 'en_US'
                               );
    insert usr;
        
        List<FMS_Additional_Filters__c> addFilters = new List<FMS_Additional_Filters__c>();
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test1', Field_API_Name__c = 'Form_State__c', Field_Name__c = 'Form_State__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test2', Field_API_Name__c = 'Chip_Interconnect__c', Field_Name__c = 'Chip_Interconnect__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test3', Field_API_Name__c = 'Package_Requirement__c', Field_Name__c = 'Package_Requirement__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test4', Field_API_Name__c = 'Design_Submission_Type__c', Field_Name__c = 'Design_Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test5', Field_API_Name__c = 'Package_Type__c', Field_Name__c = 'Package_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test6', Field_API_Name__c = 'Packaging_Services__c', Field_Name__c = 'Packaging_Services__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test7', Field_API_Name__c = 'Product_Name__c', Field_Name__c = 'Product_Name__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test8', Field_API_Name__c = 'Product_Revision__c', Field_Name__c = 'Product_Revision__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test9', Field_API_Name__c = 'Release_Process__c', Field_Name__c = 'Release_Process__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test10', Field_API_Name__c = 'PO_Submission__c', Field_Name__c = 'PO_Submission__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test11', Field_API_Name__c = 'Submission_Type__c', Field_Name__c = 'Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test12', Field_API_Name__c = 'Step_Plan_Input_Method__c', Field_Name__c = 'Step_Plan_Input_Method__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test13', Field_API_Name__c = 'Tapeout_Date_Projection__c', Field_Name__c = 'Tapeout_Date_Projection__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test14', Field_API_Name__c = 'Technology__c', Field_Name__c = 'Technology__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test15', Field_API_Name__c = 'Test_Levels_Desired__c', Field_Name__c = 'Test_Levels_Desired__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test16', Field_API_Name__c = 'Test_Services__c', Field_Name__c = 'Test_Services__c'));        
        insert addFilters;
        
        List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
        filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = accId,
            Design_Submission_Type__c = 'Multi-Design Reticle', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Package_Requirement__c = 'req', Package_Type__c = 'IBM Custom Design', Packaging_Services__c = 'bla', 
                     PO_Submission__c = 'submission', Product_Name__c = 'test product', ownerId=usr.id, Product_Revision__c = 'rev1', Release_Process__c = 'process 1', 
                     Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'Prelim - Checking Only', CreationDateOptions__c = 'daterange', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                     Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'Main Product Definition Form;Design Data Return (DDR);Design Data Submission (RIT);Incremental Mask Change (IMC);'+Label.Form_Type_SP
                     )); 
        insert filtList;
        //List<FMS_Additional_Filters__c> cs = [Select Id from FMS_Additional_Filters__c Where Name = 'FMS_Additional_Filters']; 
        /*FMS_Additional_Filters__c mycs = FMS_Additional_Filters__c.getValues('FMS_Additional_Filters'); 
        List<FMS_Additional_Filters__c> cs = new List<FMS_Additional_Filters__c>();
        cs.add(mycs);
        System.assert(cs.size() == 1);*/
         Id mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        Form_Management_System__c fms = new Form_Management_System__c();
        fms.Customer_Name__c = accId;
        fms.recordTypeID = mainFormRecordTypeId;
        fms.Form_Name__c = 'some name'; 
        fms.State_of_the_Form__c = 'Draft';
        insert fms;
        
        Test.startTest();
        
        System.currentPageReference().getParameters().put('Id',filtList[0].Id);
        system.currentPageReference().getHeaders().put('Referer','GlobalfoundryView');
        system.currentPageReference().getParameters().put('fieldName','test');
        system.currentPageReference().getParameters().put('viewSearchId',filtList[0].Id);
        FormManagementMainClass clsobj = new FormManagementMainClass();
        clsobj.checkFormCompany('test-Test','Test');
        clsobj.checkChild(accId);
        
        Set<string> newset = new set<string>();
        //newset.add('test');
        newset.add('ALL');
        clsobj.selAddSearchFilter = new List<String>{'test','All'};
        clsobj.formTypeRightValues = newset;
        clsobj.getAddFilterList();
        clsobj.prodNameRightSelected = new List<String>{'test','All'};
            clsobj.prodNameLeftSelected = new List<String>{'test','All'};
        clsobj.prodNameRightValues = newset;
        clsobj.prodNameSelectclick();
        newset.clear();
        Set<string> notALL = new Set<String>{'test','test2'};
            clsobj.customerLeftSelected = new List<String>{'test','All'};
                clsobj.customerRightSelected = new List<String>{'test','All'};
        clsobj.customerRightValues = new set<String>();
        clsobj.customerRightValues.add('test');
        clsobj.dateOptionTypeOpted = 'daterange';
        clsobj.modifyDateOptTypeOpted = 'daterange';
        clsobj.custSelectclick();
        clsobj.prodNameUnselectclick();
        clsobj.prodNameLeftValues = new set<String>{'All'};
        //clsobj.getProdNameUnSelectedValues();
        clsobj.getProdNameSelectedValues();
        clsobj.prodRevRightSelected = new List<String>();
        clsobj.prodRevLeftSelected = new List<String>{'test'};
            clsobj.prodRevRightValues = new Set<String>{'All'};
                clsobj.prodNameLeftValues = new set<String>{'All'};
                clsobj.prodRevSelectclick();
        clsobj.prodRevRightValues = new Set<String>{'test'};
            clsobj.prodRevSelectclick();
        clsobj.prodRevLeftSelected = new List<String>{'All'};
            clsobj.prodRevSelectclick();
        clsobj.prodRevUnselectclick();
        clsobj.prodRevLeftValues = new Set<string>{'All'};
        //clsobj.getProdRevUnSelectedValues();
        clsobj.getProdRevSelectedValues();
        clsobj.removeFilter();
        Sobject obj = new Account();
        FormManagementMainClass.getPicklistValue(obj,'Form_Name__c');
        clsobj.SortFieldSave = 'None';
        clsobj.SortField = 'LastModifiedDate';
        //clsobj.SortToggle();
        clsobj.saveNewRecordCheck = true;
        
        clsobj.escapedNameString = 'test';
       
        system.runAs(usr){
        clsobj.saveNewSearch();
        }
        clsobj.searchMethod();
         clsobj.selAddSearchFilter = new List<String>{'Form_State__c','Technology__c','Design_Submission_Type__c','Chip_Interconnect__c','Design_Submission_Type__c','Package_Requirement__c','Package_Type__c','Packaging_Services__c','Product_Name__c','Product_Revision__c','Release_Process__c','PO_Submission__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Form_State__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        String str = 'SELECT id, Name,createdbyid,createdby.Name,Form_Name__c, Technology__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,PurchaseOrder__c,SubmissionType__c,PackageType__c,Packaging_Services__c,ProductName__c,ProductRevision__c,InputMethod__c,ProjectedTapeout__c,TestLevels__c,TestServices__c,DesignSubmission__c,CreatedDate, LastModifiedDate, Chip_Interconnect__c, OwnerId, Parent_Form_Id__c FROM Form_Management_System__c WHERE ';
        set<string> fset = new Set<String>{'Test'};
        set<string> tyfset = new Set<String>{'Technology__c'};
             

       
        clsobj.selAddSearchFilter = new List<String>{'Chip_Interconnect__c','Technology__c'};
              //      clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Chip_Interconnect__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Design_Submission_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Design_Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Package_Requirement__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Requirement__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Package_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Packaging_Services__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Packaging_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Product_Name__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Name__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Product_Revision__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Revision__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Release_Process__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Release_Process__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'PO_Submission__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('PO_Submission__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Submission_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Step_Plan_Input_Method__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Step_Plan_Input_Method__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Tapeout_Date_Projection__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Tapeout_Date_Projection__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Test_Levels_Desired__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Levels_Desired__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Test_Services__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,true);
        clsobj.formTypeRightValues = new Set<string>();
        clsobj.getIntermediateSearch();
        clsobj.selAddSearchFilter = new List<String>{'Form_State__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Form_State__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Chip_Interconnect__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Chip_Interconnect__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Design_Submission_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Design_Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Package_Requirement__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Requirement__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Package_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Packaging_Services__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Packaging_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Product_Name__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Name__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Product_Revision__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Revision__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Release_Process__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Release_Process__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'PO_Submission__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('PO_Submission__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Submission_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Step_Plan_Input_Method__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Step_Plan_Input_Method__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Tapeout_Date_Projection__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Tapeout_Date_Projection__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Test_Levels_Desired__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Levels_Desired__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Test_Services__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.queryString = 'select id, name from Form_Management_System__c';
        system.assert(clsobj != NULL);
        //clsobj.createCsvFile();
        
        //clsobj.showResultsMethod();
        Test.StopTest();
        
    }
    
    static Account createAccountDMEA() { 
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'DMEA Account1';
        testAcct.SAP_Account_ID__c = '017924';
        testAcct.SAP_Account_Number__c = '017924';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
        testAcct.RecordTypeId = rt.Id;      
        testAcct.Short_Name__c = 'TestAcct1';
        testAcct.Fab_9_10__c = 'Yes';
        testAcct.Customer_Category__c = 'TFA';
        
        //Insert testAcct;   
        return testAcct;
    }
    
      @isTest
    static void FMStestcontrol2(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        account acc = createAccountDMEA();
        insert acc;        
        Id accId = acc.Id;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Overage Customer Portal Profile' LIMIT 1];
      //  UserRole roleId =[SELECT Id,PortalAccountId  FROM userrole where name='THE DEFENSE MICROELECTRONICS ACTIVITY (DMEA) Customer Executive' limit 1]; //00Ep0000000K13rEAC 
        
         Contact con = new Contact(LastName = 'LIVESTON12',
                                FirstName='JASON234',
                                                               Email = 'jason.liveston122@df.com',
                                   Department__c='Design;Engineering;Quality',
                                   Role__c='Customer My Device Admin'  ,  
                                   accountid=accId
                               );   
        insert con;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
       User usr ;
System.runAs ( thisUser ) {
 

           usr = new User(LastName = 'LIVESTON12',
                                FirstName='JASON234',
                                Alias = 'jliv12',
                                Email = 'jason.liveston122@df.com',
                                Username = 'jason.liveston11@df.com',
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                LocaleSidKey = 'en_US',
                                ContactId  =con.id,
                                PortalRole ='Manager'
                               );
        insert usr;
       

}
  System.runAs ( usr ) {      
     List<FMS_Additional_Filters__c> addFilters = new List<FMS_Additional_Filters__c>();
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test1', Field_API_Name__c = 'Form_State__c', Field_Name__c = 'Form_State__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test2', Field_API_Name__c = 'Chip_Interconnect__c', Field_Name__c = 'Chip_Interconnect__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test3', Field_API_Name__c = 'Package_Requirement__c', Field_Name__c = 'Package_Requirement__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test4', Field_API_Name__c = 'Design_Submission_Type__c', Field_Name__c = 'Design_Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test5', Field_API_Name__c = 'Package_Type__c', Field_Name__c = 'Package_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test6', Field_API_Name__c = 'Packaging_Services__c', Field_Name__c = 'Packaging_Services__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test7', Field_API_Name__c = 'Product_Name__c', Field_Name__c = 'Product_Name__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test8', Field_API_Name__c = 'Product_Revision__c', Field_Name__c = 'Product_Revision__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test9', Field_API_Name__c = 'Release_Process__c', Field_Name__c = 'Release_Process__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test10', Field_API_Name__c = 'PO_Submission__c', Field_Name__c = 'PO_Submission__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test11', Field_API_Name__c = 'Submission_Type__c', Field_Name__c = 'Submission_Type__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test12', Field_API_Name__c = 'Step_Plan_Input_Method__c', Field_Name__c = 'Step_Plan_Input_Method__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test13', Field_API_Name__c = 'Tapeout_Date_Projection__c', Field_Name__c = 'Tapeout_Date_Projection__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test14', Field_API_Name__c = 'Technology__c', Field_Name__c = 'Technology__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test15', Field_API_Name__c = 'Test_Levels_Desired__c', Field_Name__c = 'Test_Levels_Desired__c'));
        addFilters.add(new FMS_Additional_Filters__c(Name = 'Test16', Field_API_Name__c = 'Test_Services__c', Field_Name__c = 'Test_Services__c'));        
        insert addFilters;
        
        List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();
        filtList.add(new FMS_Search_Filter__c(Name = 'test', Chip_Interconnect__c = 'Wirebond', Created_Date_From__c = System.today()+1, Created_Date_To__c = System.today()+3, Customer__c = accId,
            Design_Submission_Type__c = 'Multi-Chiplet Design', Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, 
                     PO_Submission__c = 'submission', Product_Name__c = 'test product', ownerId=usr.id, Product_Revision__c = 'rev1', Release_Process__c = 'All', 
                     Step_Plan_Input_Method__c = 'method 1', Submission_Type__c = 'Final Submission', CreationDateOptions__c = 'daterange', Technology__c = 'tech 1', Test_Levels_Desired__c = 'level 1', 
                     Test_Services__c = 'yes', Add_Filter_Value__c = 'value', Form_Type__c = 'Main Product Definition Form;Design Data Return (DDR);Design Data Submission (RIT);Incremental Mask Change (IMC);'+Label.Form_Type_SP
                     )); 
        insert filtList;
        //List<FMS_Additional_Filters__c> cs = [Select Id from FMS_Additional_Filters__c Where Name = 'FMS_Additional_Filters']; 
        /*FMS_Additional_Filters__c mycs = FMS_Additional_Filters__c.getValues('FMS_Additional_Filters'); 
        List<FMS_Additional_Filters__c> cs = new List<FMS_Additional_Filters__c>();
        cs.add(mycs);
        System.assert(cs.size() == 1);*/
         Id mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        Form_Management_System__c fms = new Form_Management_System__c();
        fms.Customer_Name__c = accId;
        fms.recordTypeID = mainFormRecordTypeId;
        fms.Form_Name__c = 'some name'; 
        fms.State_of_the_Form__c = 'Draft';
        insert fms;
        
        Test.startTest();
     
        System.currentPageReference().getParameters().put('Id',filtList[0].Id);
        system.currentPageReference().getHeaders().put('Referer','GlobalfoundryView');
        system.currentPageReference().getParameters().put('fieldName','test');
        system.currentPageReference().getParameters().put('viewSearchId',filtList[0].Id);
   Apexpages.currentPage().getParameters().put('searchQuick','2001079');
        FormManagementMainClass clsobj = new FormManagementMainClass();
        clsobj.checkFormCompany('test-Test','Test');
        clsobj.checkChild(accId);

        Set<string> newset = new set<string>();
        //newset.add('test');
        clsobj.isDMEA = True;
    clsobj.isExternalUser = True;
        newset.add('ALL');
          User loggedInUser= usr;
        clsobj.selAddSearchFilter = new List<String>{'test','All'};
      
      clsobj.formTypeRightValues = new Set<String>();
        clsobj.formTypeRightValues.add('Main Product Definition Form');
        clsobj.formTypeRightValues.add('Design Data Submission (RIT)');
         clsobj.formTypeRightValues.add('Incremental Mask Change (IMC)');
       
        clsobj.getAddFilterList();
    
        clsobj.prodNameRightSelected = new List<String>{'test','All'};
            clsobj.prodNameLeftSelected = new List<String>{'test','All'};
                clsobj.prodNameRightValues = new Set<String>{'All','Test'};
        clsobj.prodNameSelectclick();
        newset.clear();
        Set<string> notALL = new Set<String>{'test','test2'};
            clsobj.customerLeftSelected = new List<String>{'test','All'};
                clsobj.customerRightSelected = new List<String>{'test','All'};
        clsobj.customerRightValues = new set<String>();
        clsobj.customerRightValues.add('test');
        clsobj.dateOptionTypeOpted = 'daterange';
        clsobj.modifyDateOptTypeOpted = 'daterange';
        clsobj.custSelectclick();
        clsobj.prodNameRightSelected.add('test');
        clsobj.prodNameUnselectclick();
        clsobj.prodNameLeftValues = new set<String>{'All'};
        //clsobj.getProdNameUnSelectedValues();
        clsobj.getProdNameSelectedValues();
        clsobj.prodRevRightSelected = new List<String>();
        clsobj.prodRevLeftSelected = new List<String>{'test'};
            clsobj.prodRevRightValues = new Set<String>{'All'};
                clsobj.prodNameLeftValues = new set<String>{'All'};
                clsobj.prodRevSelectclick();
        clsobj.prodRevRightValues = new Set<String>{'test'};
            clsobj.prodRevSelectclick();
        clsobj.prodRevLeftSelected = new List<String>{'All'};
            clsobj.prodRevSelectclick();
        clsobj.prodRevUnselectclick();
        clsobj.prodRevLeftValues = new Set<string>{'All'};
        //clsobj.getProdRevUnSelectedValues();
        clsobj.getProdRevSelectedValues();
        clsobj.removeFilter();
        Sobject obj = new Account();
        FormManagementMainClass.getPicklistValue(obj,'Form_Name__c');
        clsobj.SortFieldSave = 'None';
        clsobj.SortField = 'LastModifiedDate';
        //clsobj.SortToggle();
        clsobj.saveNewRecordCheck = true;
        
        clsobj.escapedNameString = 'test';
       
        system.runAs(usr){
         List<FMS_Search_Filter__c> setConSavedSearch1 = new List<FMS_Search_Filter__c>();
        clsobj.saveNewSearch();
             clsobj.dateOptionTypeOpted = 'alldates';
            clsobj.fmsSearchFilterObj.name='one';
            clsobj.modifyDateOptTypeOpted = 'alldates';
            clsobj.saveNewRecordCheck=true;
              clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
            clsobj.fmsSearchFilterObj.name='two';
            clsobj.dateOptionTypeOpted ='';
              clsobj.modifyDateOptTypeOpted = '';
                clsobj.dateOptionOpted = '1day';
             clsobj.modifydateOptionOpted = '1day';
            clsobj.saveNewRecordCheck=true;
              clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
            clsobj.fmsSearchFilterObj.name='two';
            clsobj.dateOptionTypeOpted ='';
              clsobj.modifyDateOptTypeOpted = '';
                clsobj.dateOptionOpted = '1day';
             clsobj.modifydateOptionOpted = '1day';
            clsobj.saveNewRecordCheck=true;
              clsobj.saveNewSearch();
            
            clsobj.fmsSearchFilterObj.name='3';
                clsobj.dateOptionOpted = '1week';
             clsobj.modifydateOptionOpted = '1week';
            clsobj.saveNewRecordCheck=true;
               clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
            clsobj.fmsSearchFilterObj.name='4';
                clsobj.dateOptionOpted = '2weeks';
             clsobj.modifydateOptionOpted = '2weeks';
            clsobj.saveNewRecordCheck=true;
                clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
            clsobj.fmsSearchFilterObj.name='5';
                clsobj.dateOptionOpted = '1month';
             clsobj.modifydateOptionOpted = '1month';
            clsobj.saveNewRecordCheck=true;
            clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
             clsobj.fmsSearchFilterObj.name='6';
                clsobj.dateOptionOpted = '6months';
             clsobj.modifydateOptionOpted = '6months';
            clsobj.saveNewRecordCheck=true;
            clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
     clsobj.fmsSearchFilterObj.name='7';
                clsobj.dateOptionOpted = '1year';
             clsobj.modifydateOptionOpted = '1year';
            clsobj.saveNewRecordCheck=false;
              clsobj.saveNewSearch();
            clsobj.fmsSearchFilterObj.name='8';
                    clsobj.dateOptionOpted = '1year';
             clsobj.modifydateOptionOpted = '1year';
            clsobj.saveNewRecordCheck=true;
              clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
                   clsobj.fmsSearchFilterObj.name ='';
                    clsobj.saveNewRecordCheck=true;
            clsobj.dateOptionTypeOpted ='test';
                clsobj.dateOptionOpted = '6months';
             clsobj.modifydateOptionOpted = '6months';
            clsobj.saveNewSearch();
            clsobj.getIntermediateSearch();
           clsobj.showPopup();
          

        }
      
         clsobj.selAddSearchFilter = new List<String>{'Form_State__c','Technology__c','Chip_Interconnect__c','Design_Submission_Type__c','Package_Requirement__c','Package_Type__c','Packaging_Services__c','Product_Name__c','Product_Revision__c','Release_Process__c','PO_Submission__c','Submission_Type__c','Step_Plan_Input_Method__c','Tapeout_Date_Projection__c','Test_Levels_Desired__c','Test_Services__c'};
      clsobj.alertAddFilter();
    clsobj.formTypeRightValues.add('All');
      clsobj.alertAddFilter();
     
      clsobj.searchMethod();
        
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Form_State__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        String str = 'SELECT id, Name,createdbyid,createdby.Name,Form_Name__c, Technology__c, State_of_the_Form__c, Form_Type__c, Customer__c, Form_Description__c,PurchaseOrder__c,SubmissionType__c,PackageType__c,Packaging_Services__c,ProductName__c,ProductRevision__c,InputMethod__c,ProjectedTapeout__c,TestLevels__c,TestServices__c,DesignSubmission__c,CreatedDate, LastModifiedDate, Chip_Interconnect__c, OwnerId, Parent_Form_Id__c FROM Form_Management_System__c WHERE ';
        set<string> fset = new Set<String>{'Test'};
        set<string> tyfset = new Set<String>{'Technology__c'};
      //  clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Chip_Interconnect__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Chip_Interconnect__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Design_Submission_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Design_Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Package_Requirement__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Requirement__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Package_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Packaging_Services__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Packaging_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,true);
        clsobj.selAddSearchFilter = new List<String>{'Product_Name__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Name__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,true);
        clsobj.selAddSearchFilter = new List<String>{'Product_Revision__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Revision__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Release_Process__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Release_Process__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'PO_Submission__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('PO_Submission__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Submission_Type__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Step_Plan_Input_Method__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Step_Plan_Input_Method__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Tapeout_Date_Projection__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Tapeout_Date_Projection__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Test_Levels_Desired__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Levels_Desired__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.selAddSearchFilter = new List<String>{'Test_Services__c','Technology__c'};
            clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,false);
        clsobj.searchStringMethod(str,filtList[0].Technology__c,filtList[0].Form_State__c,filtList[0],fset,tyfset,true);
        clsobj.formTypeRightValues = new Set<string>();
        clsobj.getIntermediateSearch();
        clsobj.selAddSearchFilter = new List<String>{'Form_State__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Form_State__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Chip_Interconnect__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Chip_Interconnect__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Design_Submission_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Design_Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Package_Requirement__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Requirement__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Package_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Package_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Packaging_Services__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Packaging_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Product_Name__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Name__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Product_Revision__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Product_Revision__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Release_Process__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Release_Process__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'PO_Submission__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('PO_Submission__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Submission_Type__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Submission_Type__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        clsobj.selAddSearchFilter = new List<String>{'Step_Plan_Input_Method__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Step_Plan_Input_Method__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Tapeout_Date_Projection__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Tapeout_Date_Projection__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Test_Levels_Desired__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Levels_Desired__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
          clsobj.selAddSearchFilter = new List<String>{'Test_Services__c','Technology__c'};
        clsobj.renderingMap = new Map<string,boolean>();
        clsobj.renderingMap.put('Test_Services__c',true);
        clsobj.renderingMap.put('Technology__c',true);
        clsobj.saveNewSearch();
        system.assert(clsobj != NULL);
     //  clsobj.refreshSearch();
        //    clsobj.accessSearch();
        //clsobj.showResultsMethod();
  
Test.StopTest();
  }     
    }
   
}