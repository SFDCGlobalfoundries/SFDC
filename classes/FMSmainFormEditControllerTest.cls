/*
* @ Author :- Cognizant Technology Solutions
* @ Description :- Test class for FMSMainFormEditController
* @ Date :- 13-Mar-2017
* @ Change History : 
NJain -    13Mar17    - Test Class created
**/
@isTest(SeeAllData = false) 
public class FMSmainFormEditControllerTest{
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        List<SObject> lstFMSMapTab = Test.loadData(FMS_Mapping_Table__c.sObjectType,'TestFMSMappingTableData');
        Map<String,Object> fieldValueMap = new Map<String,Object>{'Name'=>'TEST rec', 'stage__c'=>'Unqualified', 'sub_type__c'=>'Direct', 'site_department__c'=>'test dept1', 'transaction_type__c'=>'transactional', 'region__c'=>'APJ', 'Corporate_Address_1__c'=>'Test Address 1', 'Corporate_City__c'=>'Lee', 'Corporate_Country__c'=>'Japan', 'Bill_To_Address_1__c'=>'Test Address 1', 'Bill_To_City__c'=>'Test City', 'Bill_To_Country__c'=>'Singapore', 'recordtypeid'=>EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'), 'short_name__c'=>'TESTrec','Customer_Number__c'=>'10101' , 'account_profile__c'=>'Fabless - Emerging', 'Process_Tech_Interested__c'=>'Mature (> 0.11um)', 'Sales_Territory__c'=>'Japan Korea', 'financial_territory__c'=>'Japan Korea', 'Organization_Unit__c'=>'GF Investment LLC OU', 'bill_to_location__c'=>'YES', 'total_employee__c'=>100, 'end_customer__c'=>'people', 'Revenue_Potential__c'=>'High Potential', 'Target_Account__c'=>'Yes', 'Preferred_Invoice_Delivery_Option__c'=>'Electronic', 'Fab_9_10__c'=>'Yes', 'SAP_Account_Number__c'=>'006104','Customer_Category__c'=>'TFA','tech_geo_granted__c'=>'0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM;0.007UM;0.010UM'};

        Map<String,Object> fieldValueMap1 = new Map<String,Object>{'Name'=>'TEST rec1', 'stage__c'=>'Unqualified', 'sub_type__c'=>'Direct', 'site_department__c'=>'test dept1', 'transaction_type__c'=>'transactional', 'region__c'=>'APJ', 'Corporate_Address_1__c'=>'Test Address 1', 'Corporate_City__c'=>'Lee', 'Corporate_Country__c'=>'Japan','Bill_To_Address_1__c'=>'Test Address 1', 'Bill_To_City__c'=>'Test City', 'Bill_To_Country__c'=>'Singapore', 'recordtypeid'=>EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'), 'short_name__c'=>'TESTrec1', 'Customer_Number__c'=> '10102', 'account_profile__c'=>'Fabless - Emerging', 'Process_Tech_Interested__c'=>'Mature (> 0.11um)', 'Sales_Territory__c'=>'Japan Korea', 'financial_territory__c'=>'Japan Korea', 'Organization_Unit__c'=>'GF Investment LLC OU', 'bill_to_location__c'=>'YES', 'total_employee__c'=>100, 'end_customer__c'=>'people', 'Revenue_Potential__c'=>'High Potential', 'Target_Account__c'=>'Yes', 'Preferred_Invoice_Delivery_Option__c'=>'Electronic', 'Fab_9_10__c'=>'Yes', 'SAP_Account_Number__c'=>'016464', 'Customer_Category__c'=>'TFA', 'tech_geo_granted__c'=>'0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM'};
        
        Test.startTest(); 
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');  
        User portalUser;
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true,Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            Database.insert(skipUser);
            
            List<Map<String,Object>> fieldValueMapList = new List<Map<String, Object>>();
            fieldValueMapList.add(fieldValueMap);
            fieldValueMapList.add(fieldValueMap1);          
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            List<Account> accobjList = AccountDataFactory.createAccounts(fieldValueMapList, 2);
            
            List<Contact> conList = new List<Contact>();
            Contact conobj = new Contact(FirstName='Mr', LastName='Testcon1', AccountId=accobjList[0].Id, Email='con1@gf.com',Is_Portal_User_Active__c = false, Is_Portal_User_Created__c = false, Department__c='Design;Procurement');
            
            Contact conobj1 = new Contact(FirstName='Mr', LastName='Testcon2', AccountId=accobjList[0].Id, Email='con1@gf.com', Is_Portal_User_Active__c = true, Is_Portal_User_Created__c = true, Department__c='Design;Procurement');
            
            conList.add(conobj);
            conList.add(conobj1);           
            Database.insert(conList, false);
            
            list<user> ulist = [select id from user where isactive = true and profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
            
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = ulist[0].id, Account__c=accobjList[0].id, Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write', Team_Role__c='Primary Customer Service Rep', Sequence_No__c='1', Account_Role_ID__c='test1');                 
            List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp};             
            Database.insert(atps, false);
            
            ContentVersion testContentInsert =new ContentVersion(ContentURL='http://www.google.com/', Title ='Google.com'); 
            Database.insert(testContentInsert, false);

            String oppId = DeviceChecklistTestDataUtils.createOpp(accobjList[0].Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accobjList[0].Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Device__c dev = DeviceChecklistTestDataUtils.createDevice(accobjList[0].Id,oppId,oppProgId,p.Id);
            
            Form_Management_System__c formObj = new Form_Management_System__c(Device__c = dev.Id, Customer_Name__c = accobjList[0].Id, Selected_Contact_Ids__c = conobj.id+';'+conobj.id, SelAppId__c = conobj.id+';'+conobj.id, Name__c = 'Test Name', Form_Name__c = 'Test Main Form', Form_Description__c = 'Test Description', Technology__c = 'CSOI 7RF', TestServices__c = 'Yes', Packaging_Services__c = 'No', RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId(), Chip_Interconnect__c = 'Wirebond', QuoteOnly__c = 'Yes', ServiceOptions__c = 'Dicing', AppName__c = 'Test 1'+','+'Test 2', AppEmail__c = 'test@gmail.com', InputMethod__c ='Standard Process: Inputs via Step Plan Design FMS questions and Reticle Layout attachment', Phone__c = '9999999999', Email__c = 'test@gmail.com', AdvancedProcessFileAttachment__c = testContentInsert.Id, FileAttachment__c = testContentInsert.Id, StepPlanRotationActive__c = 'Yes', DesignSubmission__c = 'Multi-Design Reticle (>1 Topcell)',ECCN_attachmentName__c = testContentInsert.Id, NumMetalLayers__c = '5', Passivation__c = 'LV (01L6998)',Channel_Type__c = 'Standard channels; Minimum width allowed', LastMetalUsed__c = 'AM (Analog Metal) (MT, FT, AM) (70P5485)');
            Database.insert(formObj);
            
            FMS_Subscription__c fmsSub = new FMS_Subscription__c(Form_Id__c = formObj.Id, Form_Inserted__c = true, Form_Status_Change__c = true, Form_Updated__c = true);
            Database.insert(fmsSub);
            
            Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware', Product_External_ID__c = '1323233');
            Database.insert(prod);
            
            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
            Database.insert(standardPrice);
            
            Test.stopTest();
            Apttus_Proposal__Proposal__c aptt = new Apttus_Proposal__Proposal__c(FMS_Proposal__c = formObj.Id);
            Database.insert(aptt);
            
            Apttus_Proposal__Proposal_Line_Item__c apttLine = new Apttus_Proposal__Proposal_Line_Item__c(Apttus_Proposal__Proposal__c = aptt.Id, Apttus_Proposal__Product__c = prod.Id, Apttus_QPConfig__OptionId__c = prod.Id);   
            Database.insert(apttLine);
            
            Apttus_Config2__ClassificationName__c classiName = new Apttus_Config2__ClassificationName__c(Name = 'Test Classification', Apttus_Config2__HierarchyLabel__c = 'Test', Category_External_ID__c = '1234');
            Database.insert(classiName);
            
            Apttus_Config2__ClassificationHierarchy__c classHier = new Apttus_Config2__ClassificationHierarchy__c(Name = 'Test Name', Apttus_Config2__HierarchyId__c = classiName.Id, Apttus_Config2__Label__c = 'test label', Category_Hierarchy_External_ID__c = '12334');
            Database.insert(classHier);
            
            Apttus_Config2__ProductOptionGroup__c apttConfgrp = new Apttus_Config2__ProductOptionGroup__c (Apttus_Config2__OptionGroupId__c = classHier.Id, Apttus_Config2__Sequence__c = 1, Apttus_Config2__ProductId__c = prod.Id, Apttus_Config2__IsHidden__c = false);
            Database.insert(apttConfgrp);
            
            Apttus_Config2__ProductOptionComponent__c apttConf = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__ComponentProductId__c = prod.Id, Apttus_Config2__ProductOptionGroupId__c = apttConfgrp.Id, Apttus_Config2__Sequence__c = 0);
            List<Apttus_Config2__PriceList__c> ListPricelist = new List<Apttus_Config2__PriceList__c>();
            Database.insert(apttConf);               
        }
    }    
    
    @future
    private static void setUpObject(){
        List<Group> gList = new List<Group>();
        gList.add(new Group(Name = 'FMS Admin Group'));
        gList.add(new Group(Name='CPQ team', type='Queue'));
        Database.insert(gList, false);
        
        QueuesObject q1 = new QueueSObject(QueueID = gList[1].id, SobjectType = 'Case');
        Database.insert(q1);
        
        GroupMember grpMember = new GroupMember(GroupId = gList[0].Id, userOrGroupId= userInfo.getUserId());
        GroupMember gmMember1 = new GroupMember(GroupId = gList[1].id,UserOrGroupId = userInfo.getUserId());
        Database.insert(new List<GroupMember>{grpMember,gmMember1}, false);
    }
    
    static Account getAccount(String name){
        Account acc = [select id, Name from Account where name = :name];
        return acc;
    }
    
    static Contact getContact(Id accId, String name){
        Contact con = [select id, Name, AccountId from Contact where AccountId = :accId and LastName =: name];
        return con;
    }
    
    static User getUser(){
        IntegrationUsers__c intUsr = [select id,SetupOwnerId from IntegrationUsers__c where Is_Integration_User__c= true and Skip_Trigger__c = true and Skip_Validation_Rule__c = true limit 1];  
        User usr = [select id from User where id = :intUsr.SetupOwnerId limit 1];
        return usr ;
    }  
    
    static User getPortalUser(){
        List<User> usr = new List<User>([select id from User where LastName = 'portalUserTest' limit 1]);
        return usr[0];
    }
    
    static Form_Management_System__c getForm(Id accId) {
        String fmsFields = '';
        fmsFields = UtilityCls.getAllFields('Form_Management_System__c'); 
        fmsFields += ', Customer_Name__r.SAP_Account_Number__c, Customer_Name__r.Customer_Category__c,'; 
        fmsFields += ' Customer_Name__r.Id,Customer_Name__r.Name,Device__r.Name,Device__r.id, Opportunity__r.id,';
        fmsFields += ' Opportunity__r.Name, Parent_Form_Id__r.recordtype.Name, Customer_Name__r.SAP_Account_Id__c';     
        string soql = 'select ' + fmsFields + ' from Form_Management_System__c WHERE Customer_Name__c = \''+ accId +'\'';
        Form_Management_System__c fms = database.query(soql); 
        return fms;
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethodMain() {
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.id, 'Testcon1');
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Test.startTest();
        System.runAs(admin){
            setUpObject();    
            PageReference pageRef = Page.FMSmainFormCreationPg1;            
            Test.setCurrentPage(pageRef);
            Form_Management_System__c fms1 = getForm(acc.id);
            ApexPages.currentPage().getParameters().put('pageNo','2');
            ApexPages.currentPage().getHeaders().put('Referer', 'GlobalfoundryView');
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(fms1));
            obj.rightValues.put(UserInfo.getUserId(),'test1');
            obj.rightValues.put(getUser().Id,'test2');
            obj.rightValues.put(con.Id,'test3');
            obj.prevLogUser = getUser().Id;
            obj.formObj.Packaging_Services__c = 'No';
            obj.readOnlyCheck = true;
            obj.getlastMetalUsedList();
            obj.getNumMetalLayersList();
            obj.getformTechnology();
            obj.getchipEdgeWLCSPList();
            obj.getformReleaseProcess();
            obj.gettestServicesList();
            obj.getpackagingServList();
            obj.getchipInterconnectList();
            obj.gettestLevelList();
            obj.getIntConBumpSourceList();
            obj.renderingOfTestLevel();
            try{obj.getprimaryContactsList();}catch(Exception e){}
            obj.getreleGuideList();
            obj.gettotalPageNums();
            obj.prepopulateValues();
            obj.updateCountOfAddContacts();
            obj.selectclick();
            obj.unselectclick();
            obj.getunSelectedValues();
            obj.getSelectedValues();
            obj.getaddContTable();
            obj.getPassivation1List();
            obj.getCrackstopOptList();
            obj.getSourcingLocList();
            obj.chngHistory();
            obj.getNumThickLevelsList();
            obj.renderNumThickLevel();
            obj.getPassivationList();
            obj.renderPassivation();
            obj.getWiringOptionsList();
            obj.getFinalPassivationList();
            obj.renderFinalPassivation();
            obj.renderLineFront();
            obj.renderTechFeatures();
            obj.renderNotMfgFeaturesDesc();
            obj.renderStepPlanCustomReq();
            obj.getDataCheckOptionsList();
            obj.renderDataCheckingOpts();
            obj.getServiceOptionsList();
            obj.renderotherServiceFeatures();
            obj.renderChipEdgeDesign();
            obj.getDeliverablesList();
            obj.getDesignSubmissionList();
            obj.getBacksideGrindThicknessList();
            obj.renderBacksideGrindThickness();
            obj.renderDeliverableSplit();
            obj.getPreMergeList();
            obj.renderMetalizationOption();
            obj.readOnlyCheckMethod();
            obj.renderWireBondSplit();
            obj.renderWireBondSplitTAT();
            obj.renderC4SplitTAT();
            obj.renderOtherSplitDets();
            obj.renderITARCat();
            obj.renderClientResponseDt();
            obj.renderNeedBizComment();
            obj.getNeedBizCommentList();
            obj.renderNumOfDesigns();
            obj.renderMaxChipPower();
            obj.getChamferedCornersList();
            obj.renderChamferedCorner();
            obj.getC4PadLayoutList();
            obj.renderCircuitType();
            obj.renderC4PadLayout();
            obj.renderOtherC4PadLayout();
            obj.getC4PadLayoutForDRCList();
            obj.renderC4PadLayoutForDRC();
            obj.renderNumC4Pads();
            obj.getC4SolderMaterialList();
            obj.renderC4SolderMaterial();
            obj.renderC4LaminatePackage();
            obj.renderWirebondLayout();
            obj.renderWireBondPad();
            obj.renderWirebondPadPitch();
            obj.renderPinOneID();
            obj.renderdesignKitOthers();
            obj.renderPickMap();
            obj.renderNeedAdditionalComments();
            obj.renderadditionalComments();
            obj.renderStepPlanSection();
            obj.renderInputMethod();
            obj.getinputMethodList();
            obj.updateFiledetails();
            obj.updateECCNFiledetails();
            obj.deleteAttachment();
            obj.getspunSelectedValues();
            obj.getspSelectedValues();
            obj.spselectclick();
            obj.spunselectclick();
            obj.getspaddContTable();
            obj.renderCrackOptions();
            obj.renderChannelType();
            obj.getchannelTypeList();
            obj.assignValues();
            obj.renderDicingPref();
            obj.getdicingPrefList();
            obj.renderDicingMarks();
            obj.displayRenderLabel();
            obj.getPacTypeList();
            obj.saveandExit();
            obj.saveForm();
            obj.validateSave();
            obj.next();
            obj.prev();
            obj.redirectToSearchPage();
            obj.resetDependentFields();
            obj.submitForQuote();
            Boolean checkpoint = obj.validationCheckView(null);
            System.assertEquals(true, checkpoint);
            obj.submitForm();
            obj.freezeForm();
            obj.makeFormInactive();
            obj.requestToThawForm();
            obj.thawForm();
            obj.deleteForm();
            obj.editForm();
            obj.updateFormDetails();
            obj.makeFormActive();
            obj.copyAsNewForm();
            obj.getSelectAddendumValues();
            obj.continueCheck();
            obj.showPopup();
            obj.closePopup();
            obj.renderFinalPassivationView();
            obj.renderotherServiceFeaturesView();
            obj.Subscribe();
            obj.UnSubscribe();
            obj.SubscribeUser();
            obj.getMetalizationOption();
            obj.getDataCheckingOptsList();
            obj.openPDF();
            obj.getconfigData();
            obj.createAddendumForm();
            obj.changeInputMethod();
            obj.getchipRotationList();
            obj.cancelForm();
            obj.holdPage1Fields();
            obj.holdPage2Fields();
            obj.holdPage2tfaFields();
            obj.holdPage3Fields();
            obj.holdPage5Fields();
            obj.getlastMetalUsedList();
			FMSmainFormEditController.AddStepPlanContWrapper wrp = new FMSmainFormEditController.AddStepPlanContWrapper('test','test','test');
        }
        Test.stopTest();
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethod1() {
        Account acc = getAccount('TEST rec');
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Test.startTest();
        System.runAs(admin){
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);   
            Form_Management_System__c formObj = getForm(acc.id); 
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '1');
            ApexPages.currentPage().getParameters().put('tranx','Subscribe');  
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));         
            obj.pageN = 'page1';
            obj.formObj.QuoteOnly__c = 'No';
            Form_Management_System__c fmsNew = new Form_Management_System__c();
            Boolean check = obj.validationCheck(fmsNew);            
            obj.pageN = 'page2';
            check = obj.validationCheck(fmsNew);            
            obj.pageN = 'page3';
            check = obj.validationCheck(fmsNew);            
            obj.pageN = 'page4';
            check = obj.validationCheck(fmsNew);            
            obj.pageN = 'page5';
            fmsNew.Packaging_Services__c = 'Yes';
            check = obj.validationCheck(fmsNew);            
            Apexpages.currentPage().getParameters().put('inpVal','test00312');
            Apexpages.currentPage().getParameters().put('fieldName','test22432');
            obj.invInput();     
            obj.formObj.DesignSubmission__c = 'Single Chip (one GDS)';
            obj.formObj.InputMethod__c ='Advanced Process: Inputs via XML file attachment.';
            obj.formObj.NumMetalLayers__c = '8';
            obj.formObj.StepPlanRotationActive__c = null;
            obj.formObj.Passivation__c = 'FV - Polyimide only (LV drawn) (84Y8379)';
            obj.pageN = 'page2';
            obj.getlastMetalUsedList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.Page2TFA = 2;
            obj.isTFACompany = true;
            obj.readOnlyCheck = false;
            obj.getWiringOptionsList();
            check = obj.validationCheckView(null);
            obj.getstepPlanEdgeList();
            obj.getFinalPassivationList();
            obj.formObj.Technology__c = 'X32SOI';
            obj.formObj.DesignSubmission__c = 'Single Chip (one GDS)';
            obj.pageN = 'page3';
            obj.getlastMetalUsedList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.isTFACompany = true;
            check = obj.validationCheckView(null);
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.pageN = 'page5';
            obj.getlastMetalUsedList();
            obj.formObj.Packaging_Services__c = 'No';
            check = obj.validationCheckView(null);
            obj.formObj.Technology__c = 'SOI7SWT';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getlastMetalUsedList();
            obj.formObj.Packaging_Services__c = 'No';
            check = obj.validationCheckView(null);
            obj.getlastMetalUsedList();
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '5');
            ApexPages.currentPage().getParameters().put('tranx','UnSubscribe');            
            FMSmainFormEditController obj1 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.formObj.Technology__c = 'IPD5PAE';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            check = obj.validationCheckView(null);
            System.assert(true,check);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '5');
            ApexPages.currentPage().getParameters().put('tranx','InActiveStateChange');
            FMSmainFormEditController obj2 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.formObj.Technology__c = 'CMOS 7TG (CMRF7TG)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getlastMetalUsedList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.validationCheckView(null);
            obj.getlastMetalUsedList();
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '5');
            ApexPages.currentPage().getParameters().put('tranx','UnSubscribe');            
            FMSmainFormEditController obj3 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.formObj.Technology__c = 'BiCMOS 5PAe (SiGe 5PAe)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '5');
            ApexPages.currentPage().getParameters().put('tranx','InActiveStateChange');
            FMSmainFormEditController obj4 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.LastMetalUsed__c = 'AM';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'BiCMOS 6WL (SiGe 6WL)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'BiCMOS 7WL (SiGe 7WL)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getlastMetalUsedList();
            obj.formObj.Technology__c = 'CMHV7SF';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getlastMetalUsedList();
            obj.formObj.Technology__c = 'CMOS 6RF (CMRF6SF)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'CMOS 7RF (CMRF7SF)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'BiCMOS 8HP (SiGe 8HP)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'CMOS 6SF';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.LastMetalUsed__c = 'AM (Analog Metal) (06K3730)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'CSOI 7SW';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.LastMetalUsed__c = 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getlastMetalUsedList();
            obj.formObj.Technology__c = 'CSOI 7TF';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.LastMetalUsed__c = 'AM (Analog Last Metal)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'SOI7SWT';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.LastMetalUsed__c = 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.formObj.Technology__c = 'BiCMOS 5PAe (SiGe 5PAe)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'BiCMOS 5PAX (1K5PAXE)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'BiCMOS 8HP (SiGe 8HP)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'IPD5PAE';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'CMOS 8RF (CMRF8SF)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.formObj.Technology__c = 'CMOS 6SF';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.formObj.NumMetalLayers__c = '7';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.isTFACompany = true;
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = '32SOI';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 5HPE (SiGe 5HPE)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();           
            obj.formObj.Technology__c = 'BiCMOS 5HPE (SiGe 5HPE)';  
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.formObj.IntConBumpSource__c = 'No(21L2039)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 5PAe (1KW5PAe)'; 
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();           
            obj.formObj.Technology__c = 'BiCMOS 6WL (SiGe 6WL)'; 
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 7PA (SiGe 7PA)';
            obj.formObj.Packaging_Services__c = 'Yes';  
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 7WL (SiGe 7WL)';  
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 8HP (SiGe 8HP)';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 8WL (SiGe 8WL)';
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.getNumMetalLayersList();
            obj.formObj.Packaging_Services__c = 'No';
            obj.validationCheckView(null);
            obj.getNumMetalLayersList();
            obj.changeTechOptForOriginal();
            obj.getNumThickLevelsList();
            obj.getPassivationList();  
            obj.formObj.TestServices__c = 'Yes';
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.gettestLevelList();
            obj.formObj.ServiceOptions__c = '';
            obj.renderPage2Methods();
            obj.formObj.ServiceOptions__c = 'opt1;opt2';
            obj.renderPage2Methods();
            obj.getFormReleaseProcess();
            obj.formObj.Technology__c = UtilityCls.CSOI_7RF;
            obj.getlastMetalUsedList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.Wirebond;
            obj.getlastMetalUsedList();
            obj.getchipInterconnectList();
            obj.renderingOfTestLevel();
            obj.chipRotationValues();
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.getlastMetalUsedList();
            obj.formObj.TestServices__c = 'No';
            obj.formObj.Packaging_Services__c = 'No';
            obj.getlastMetalUsedList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.Wirebond;
            obj.getlastMetalUsedList();
            obj.formObj.IntConBumpSource__c = 'Yes';
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.dispLastMetalUsed = true;
            obj.getlastMetalUsedList();
            FMSmainFormEditController.AddContWrapper wrap = new FMSmainFormEditController.AddContWrapper('','','','');
        }
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethodNonPrimUsr() {
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.Id, 'Testcon2');
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        IntegrationUsers__c intUsr = [select SetupOwnerId from IntegrationUsers__c limit 1];
        User u = [select id from User where id = :intUsr.SetupOwnerId];
        Test.startTest();
        system.runAs(u){
            ContentVersion testContentInsert = [select id from ContentVersion limit 1];
            Form_Management_System__c formObj = getForm(acc.id);
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '1');
            ApexPages.currentPage().getParameters().put('uploadFileId', testContentInsert.Id); 
            ApexPages.currentPage().getParameters().put('uploadFileName', 'Test Name'); 
            ApexPages.currentPage().getParameters().put('uploadECCNFileId', testContentInsert.Id); 
            ApexPages.currentPage().getParameters().put('uploadECCNFileName', 'Test Name');   
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.updateECCNFiledetails();
            obj.updateFiledetails();  
            system.assertEquals(formObj.Chip_Interconnect__c,'Wirebond');
            User primUsr = [select Id from User where Id !=: u.Id limit 1];
            obj.formObj.UserIdPrimary__c = primUsr.Id;
            obj.getPrimaryContactsList();
            obj.prepopulateValues();
            obj.formObj.UserIdPrimary__c = con.Id;
            obj.getPrimaryContactsList();
            obj.prepopulateValues();
            obj.contactInfo.add(con);
            obj.getPrimaryContactsList();
            obj.prepopulateValues();
            obj.leftValues.put('test', 'test');
            obj.originalValues.put('test','test');
            obj.rightValues.put('test', 'test');
            obj.rightSelected.add('test');
            obj.leftSelected.add('test');
            obj.selectClick();
            obj.unselectclick();
        } 
        Test.stopTest();
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethodContactUsr() {
        Account acc = getAccount('TEST rec');
        Form_Management_System__c formObj = getForm(acc.id);
        Test.startTest();
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',formObj.Id);
        ApexPages.currentPage().getParameters().put('pageN', '1');
        FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
        system.assertEquals(formObj.StepPlanRotationActive__c,'Yes');
        obj.init();
        obj.getSourcingLocList();
        obj.getneedAddCommentsList(); 
        obj.configPage();
        obj.pageN = 'page1';
        obj.isTFACompany = true;
        obj.prev();
        obj.saveForm();
        obj.saveandExit();
        obj.pageN = 'page2';
        obj.prev();
        obj.isTFACompany = false;
        obj.prev();
        obj.saveForm();
        obj.saveandExit();
        obj.pageN = 'page2tfa';
        obj.prev();
        obj.saveForm();
        obj.saveandExit();
        obj.pageN = 'page3';
        obj.prev();
        obj.isTFACompany = true;
        obj.prev();
        obj.saveForm();
        obj.saveandExit();
        obj.pageN = 'page4';
        obj.prev();
        obj.isTFACompany = false;
        obj.prev();
        obj.pageN = 'page5';
        obj.prev();
        obj.isTFACompany = true;
        obj.prev();
        obj.saveForm();
        obj.saveandExit();
        obj.formObj.QuoteOnly__c = 'No';
        obj.formObj.State_of_the_Form__c = 'Draft';
        obj.formObj.TestServices__c = 'No';
        obj.formObj.Packaging_Services__c = 'No';
        obj.gettotalPageNums();
        obj.formObj.Packaging_Services__c = 'Yes';
        obj.gettotalPageNums();
        obj.formObj.TestServices__c = 'Yes';
        obj.gettotalPageNums();
        obj.isTFACompany = false;
        obj.gettotalPageNums();
        obj.formObj.Packaging_Services__c = 'No';
        obj.gettotalPageNums();
        obj.formObj.TestServices__c = 'No';
        obj.gettotalPageNums();
        obj.invalidInputCheckMap = new map<string,string>{'CrossFlowIFPM__c'=> 'true','NoOfPowerSupplies__c'=> 'true','ModulePinsBallsTotal__c'=> 'true','ModulePinsBallsSignal__c'=>'true','ModulePinsBallsPower__c'=>'true','ModulePinsBallsUnused__c'=> 'true','NumberModuleDecouplingCapacitors__c'=>'true','NoOfDiffPairs__c'=>'true'};
        obj.invalidInpToFieldsMap = new map<string,string>{'CrossFlowIFPM__c'=> 'CrossFlowIFPM__c','NoOfPowerSupplies__c'=> 'NoOfPowerSupplies__c','ModulePinsBallsTotal__c'=> 'ModulePinsBallsTotal__c','ModulePinsBallsSignal__c'=> 'ModulePinsBallsSignal__c','ModulePinsBallsPower__c'=> 'ModulePinsBallsPower__c','ModulePinsBallsGround__c'=> 'ModulePinsBallsGround__c','ModulePinsBallsUnused__c'=> 'ModulePinsBallsUnused__c','NumberModuleDecouplingCapacitors__c'=>'NumberModuleDecouplingCapacitors__c','NoOfDiffPairs__c'=>'NoOfDiffPairs__c'};        
        obj.holdPage5Fields();
        Test.stopTest();
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethodNew() {
        Account acc = getAccount('TEST rec');
        Test.startTest();
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            setUpObject();
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);        
            Form_Management_System__c formObj = getForm(acc.id);
            formObj.Technology__c = 'SOI7SWT';
            formObj.TestServices__c = 'Yes';  
            formObj.QuoteOnly__c = 'No';
            formObj.Chip_Interconnect__c = 'Copper Pillar';
            Database.update(formObj);
            
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '1');    
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));         
            obj.getC4PadLayoutForDRCList(); 
            
            C4PadLayForDRCListMethod(true, formObj, 'C4 flip chip', null, obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, '32SOI', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CMOS 8RF (CMRF8SF)', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CSOI 7RF', obj, false);
            C4PadLayForDRCListMethod(true, formObj, 'Copper Pillar', null, obj, false);
            C4PadLayForDRCListMethod(true, formObj, 'Wirebond', null, obj, false);
            C4PadLayForDRCListMethod(true, formObj, 'WLCSP-RDL', null, obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CMOS 10LP', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CNV8SFi', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CMOS 6SF', obj, false);
            C4PadLayForDRCListMethod(true, formObj, 'Copper Pillar', 'CMOS 7RF (CMRF7SF)', obj, false);
            C4PadLayForDRCListMethod(true, formObj, 'C4 flip chip', null, obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'CMOS 9LP (CMOS 9RF)', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, 'SOI12S0', obj, false);
            C4PadLayForDRCListMethod(true, formObj, null, '45RFSOI', obj, false);

            C4PadLayForDRCListMethod(false, formObj, null, 'SOI7SWT', obj, true);
            C4PadLayForDRCListMethod(false, formObj, 'Copper Pillar', null, obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, '32SOI', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 8RF (CMRF8SF)', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CSOI 7RF', obj, true);
            C4PadLayForDRCListMethod(false, formObj, 'C4 flip chip', null, obj, true);
            C4PadLayForDRCListMethod(false, formObj, 'WLCSP-RDL', null, obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 10RFe', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CNV8SFi', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 6RF (CMRF6SF)', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 6SF', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 7RF (CMRF7SF)', obj, true);
            C4PadLayForDRCListMethod(false, formObj, 'Copper Pillar', null, obj, true);
            C4PadLayForDRCListMethod(false, formObj, 'C4 flip chip', null, obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'CMOS 9SF', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, 'SOI12S0', obj, true);
            C4PadLayForDRCListMethod(false, formObj, null, '45RFSOI', obj, true);
            
            obj.formObj.Technology__c = '32SOI';
            obj.formObj.MetallizationOpts__c = '5-3-1-0-2 (5-1x Low-k; 3-2x Low-k; 1-4x Low-k; 0-8x TEOS/FTEOS; 2-16x TEOS/FTEOS; LB) _ 12 _ LB _ (84Y8166)';
            obj.getMetalizationOption();
            system.assertEquals(formObj.ServiceOptions__c,'Dicing');
        }
        FMSmainFormEditController.checkLicense();          
        Test.stopTest();
    }
    
    private static void C4PadLayForDRCListMethod (Boolean DRCList, Form_Management_System__c formObj , String ChipInterCon, String Tech, FMSmainFormEditController obj, Boolean padList) {
        if(ChipInterCon != null && ChipInterCon != '') {
            obj.formObj.Chip_Interconnect__c = ChipInterCon; 
        }
        if(Tech != null && Tech != '') {
            obj.formObj.Technology__c = Tech;
        }
        if(DRCList){        
            obj.getC4PadLayoutForDRCList();
        } else if(padList) {
            obj.getC4PadLayoutList();
        }
    }
    
}