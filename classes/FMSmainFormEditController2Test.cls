/*
* @ Author :- Cognizant Technology Solutions
* @ Description :- Test class for FMSMainFormEditController
* @ Date :- 13-Mar-2017
* @ Change History : 
NJain -    13Mar17    - Test Class created
Devendra -dec-25-2017- splitting the class
**/
@isTest(SeeAllData = false) 
public class FMSmainFormEditController2Test{
    
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
    
    
    public static testMethod void getPassivationList_1() {
        Account acc = getAccount('TEST rec');
        Test.startTest();
        System.runAs(getUser()){
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);        
            Form_Management_System__c formObj = getForm(acc.id);            
            map<string,object> mpFieldVals = new map<string,object>{'Technology__c' => 'CMOS 6SF','QuoteOnly__c' => 'No','DesignSubmission__c' => 'Single Chip (one GDS)','InputMethod__c' => 'Advanced Process: Inputs via XML file attachment.','StepPlanRotationActive__c' => null,'Chip_Interconnect__c' => 'C4 flip chip','NumMetalLayers__c' => '7','IntConBumpSource__c' => 'No(21L2039)','LastMetalUsed__c' => 'AM, FQ (Analog Last Metal) (AM, FQ, MR) (84Y9601)'};
            for(String fld : mpFieldVals.keySet()) {
              formObj.put(fld,mpFieldVals.get(fld));
            }  
            Database.update(formObj);
        
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '5');
            ApexPages.currentPage().getParameters().put('tranx','InActiveStateChange');   
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.getNumMetalLayersList();
            obj.isTFACompany = true;
            obj.getPassivationList();
            obj.formObj.Technology__c = '32SOI';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 5PAe (SiGe 5PAe)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'BiCMOS 5HPE (SiGe 5HPE)'; 
            obj.formObj.TestServices__c = 'No';
            obj.formObj.Packaging_Services__c = 'No';
            obj.getNumMetalLayersList();
            obj.isTFACompany = true;
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.Wirebond;
            obj.formObj.Technology__c = 'BiCMOS 5PAe (1KW5PAe)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Copper Pillar';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 6WL (SiGe 6WL)'; 
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 7PA (SiGe 7PA)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.formObj.TestServices__c = 'Yes';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.TestServices__c ='Yes';
            obj.formObj.Packaging_Services__c ='No';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.formObj.TestServices__c ='No';
            obj.formObj.Packaging_Services__c ='Yes';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.TestServices__c ='No';
            obj.formObj.Packaging_Services__c ='No';
            obj.formObj.IntConBumpSource__c = 'Yes';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 7WL (SiGe 7WL)'; 
            obj.formObj.StepPlanRotationActive__c = null;
            obj.formObj.IntConBumpSource__c = UtilityCls.No_21L2039;
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.getDataCheckOptionsList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.LastMetalUsed__c = 'LD (Three Thick Wire)';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 8HP (SiGe 8HP)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Copper Pillar';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 8WL (SiGe 8WL)'; 
            obj.formObj.Chip_Interconnect__c = 'Wirebond';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'BiCMOS 8XP (SiGe 8XP)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.getPassivation1List();
            obj.formObj.Technology__c = 'BiCMOS 9HP (SiGe 9HP)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'CMHV7SF'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Copper Pillar';
            obj.getPassivationList();
            obj.formObj.LastMetalUsed__c='C3 (3um Cu Wire for MEMS) (MT, FT, E1, F1) (84Y8174)';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'CMOS 10LP'; 
            obj.formObj.Chip_Interconnect__c = 'Wirebond';
            obj.formObj.LastMetalUsed__c = 'LD (Three Thick Wire)';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 10LPe';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 10RFe';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 10SF';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'CMOS 6RF (CMRF6SF)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 6SF';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 7RF (CMRF7SF)';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Copper Pillar';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'CMOS 7TG (CMRF7TG)'; 
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.LastMetalUsed__c = 'MZ';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Copper Pillar';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 8RF (CMRF8SF)';
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.formObj.NumThickCuLevels__c ='1-AMFinalWirelevel(56Y9981)';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.NumThickCuLevels__c = '3-LMFinalWirelevel(45L8957)';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c = 'CMOS 9LP (CMOS 9RF)'; 
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 9RFe';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMOS 9SF';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Technology__c='CMS90WG (CMOS9WG)';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c = UtilityCls.CSOI_7RF; 
            obj.dispPassivation = true;
            obj.formObj.LastMetalUsed__c = 'MA (Dual Last Metal) (MA, ZF, E2, E1, FT, MT) (70P5487)';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = 'Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.WLCSP_BoP;
            obj.getPassivationList();
            obj.formObj.IntConBumpSource__c = 'Yes';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.getPassivationList();
            obj.formObj.LastMetalUsed__c = 'LD (LD, VV, EZ, E2, E1, FT, MT) (45Y0368)';
            obj.formObj.IntConBumpSource__c = UtilityCls.No_21L2039;
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.getPassivationList();
            obj.formObj.LastMetalUsed__c ='AM (Analog Last Metal) (AM, FT, MT) (70P5485)';
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.getPassivationList();
            obj.formObj.Technology__c='CSOI 7SW';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.formObj.Packaging_Services__c = 'No';
            obj.getPassivationList();
            obj.formObj.Technology__c='CSOI 7TF';
            obj.formObj.IntConBumpSource__c = UtilityCls.No_21L2039;
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='IPD5PAE';
            obj.getPassivationList();
            obj.formObj.IntConBumpSource__c = 'Yes';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.getPassivation1List();
            obj.formObj.Technology__c='SOI12S0';
            obj.getNumMetalLayersList();
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            obj.getPassivationList();
            obj.formObj.Technology__c='SOI7SWT';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c = UtilityCls.CopperPillar;
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivationList();
            obj.getNumMetalLayersList();
            obj.formObj.Technology__c='45RFSOI';
            obj.getPassivationList();
            obj.formObj.Chip_Interconnect__c ='C4 flip chip';
            System.assertNotEquals(0, obj.getPassivationList().size());
            obj.getDataCheckOptionsList();
            obj.formObj.Technology__c=UtilityCls.BiCMOS_5PAX_1K5PAXE;
            obj.formObj.Chip_Interconnect__c ='Wirebond';
            obj.getPassivation1List();
        }
        Test.stopTest();
    }   
    
    public static testMethod void FMSmainFormEditControllerTestMethodRR1() {
        Account acc = getAccount('TEST rec');
        Test.startTest();
        acc.SAP_Account_Number__c = '008809';
        Database.update(acc);

        System.runAs(getUser()){
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);        
            Form_Management_System__c formObj = getForm(acc.id);
            formObj.QuoteOnly__c = 'No';
            Database.update(formObj);     
            
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '1');   
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));         
            obj.requestToThawForm();
            obj.ThawForm();
            obj.pageN = 'page1';
            Form_Management_System__c fmsNew = new Form_Management_System__c();
            obj.validateSave();
            Boolean check = obj.validationCheck(fmsNew);            
            Boolean check1 = obj.validationCheckView(null);         
            system.assertEquals(check,true);
            obj.pageN = 'page2tfa';
            obj.validateSave();
            check = obj.validationCheck(fmsNew);            
            check1 = obj.validationCheckView(null);         
            system.assertEquals(check,false);
            obj.pageN = 'page2';
            obj.validateSave();
            check = obj.validationCheck(fmsNew);            
            check1 = obj.validationCheckView(null);         
            obj.pageN = 'page3';
            obj.validateSave();
            check = obj.validationCheck(fmsNew);            
            check1 = obj.validationCheckView(null);         
            obj.pageN = 'page4';
            obj.validateSave();
            check = obj.validationCheck(fmsNew);            
            check1 = obj.validationCheckView(null);         
            obj.pageN = 'page5';
            obj.validateSave();
            fmsNew.Packaging_Services__c = 'Yes';
            check = obj.validationCheck(fmsNew);            
            check1 = obj.validationCheckView(null);         
            system.assertEquals(formObj.Technology__c,'CSOI 7RF');
            Apexpages.currentPage().getParameters().put('inpVal','test00312');
            Apexpages.currentPage().getParameters().put('fieldName','test22432');
            obj.invInput();           
            obj.formObj.TestServices__c = 'No';
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            obj.formObj.IntConBumpSource__c = 'Yes';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Technology__c = 'SOI7SWT';
            obj.formObj.Chip_Interconnect__c = '';
            obj.formObj.QuoteOnly__c = 'No';
            obj.formObj.TestLevels__c = '';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Chip_Interconnect__c = 'C4 flip chip';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Chip_Interconnect__c = 'WLCSP-RDL';
            obj.formObj.Custom_Features__c = 'Yes';
            obj.formObj.NotMfgFeatures__c = 'Yes';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.PackageRequirement__c = 'Customer Existing Package';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Cooling__c = 'Other';
            obj.formObj.LifetimePOH__c = '';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.DiffPairRequired__c = 'Yes';
            obj.formObj.ModuleType__c = 'Multi-Chip Module';
            obj.formObj.ProductShipReq__c = 'Other';
            obj.formObj.ModuleDecouplingCapacitors__c = 'Yes';
            obj.formObj.CapacitanceValue__c = 'Other';
            obj.formObj.C4PadLayout__c  = 'Other';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.PackageType__c = '';
            obj.formObj.DesignSubmission__c = 'Single Chip (one GDS)';
            obj.formObj.IpIdentification__c = 'Yes';
            obj.formObj.DesignKitOthers__c = '';
            obj.formObj.Chip_Interconnect__c= 'C4 flip chip';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Technology__c = 'BiCMOS 8HP (SiGe 8HP)';
            obj.formObj.Chip_Interconnect__c = 'WLCSP-RDL';
            obj.formObj.PackageRequirement__c = 'Customer Existing Package';
            obj.formObj.Cooling__c = 'Cross Flow';
            obj.formObj.LifetimePOH__c = 'Other';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Technology__c = 'CNV8SFi';
            obj.formObj.QuoteOnly__c = '';
            obj.formObj.NeedAdditionalComments__c = 'Yes';
            obj.formObj.Chip_Interconnect__c= 'C4 flip chip';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.TestServices__c = '';
            obj.formObj.Packaging_Services__c = '';
            obj.formObj.Chip_Interconnect__c = 'WLCSP-RDL';
            obj.formObj.PackageRequirement__c = 'Customer Existing Package';
            obj.formObj.Chip_Interconnect__c= '';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.PackageType__c = 'Other';
            obj.formObj.PackageTypeOther__c = '';
            obj.formObj.DesignSubmission__c = '';
            obj.formObj.IpIdentification__c = 'Yes';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.PackageType__c = '';
            obj.formObj.DesignKitOthers__c = '';
            obj.formObj.NeedAdditionalComments__c = 'Yes';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
            obj.formObj.Technology__c = 'CSOI 7RF';
            obj.formObj.Packaging_Services__c = 'No';
            obj.formObj.TestServices__c = 'No';
            obj.formObj.Chip_Interconnect__c = 'WLCSP-RDL';
            obj.formObj.IntConBumpSource__c = 'Yes';
            obj.formObj.QuoteOnly__c = 'No';
            obj.formObj.ChipEdgeWLCSP__c = '';
            check = obj.validationCheck(obj.formObj);
            check1 = obj.validationCheckView(null);         
            obj.invInput();
        }
        Test.stopTest();
    }
    
    public static testMethod void RequestThawTest() {
        Test.startTest();
        Account acc = getAccount('TEST rec');
        acc.SAP_Account_Number__c = '016133';
        Database.update(acc);
        
        System.runAs(getUser()){
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);        
            Form_Management_System__c formObj = new Form_Management_System__c(Technology__c = 'SOI12S0',QuoteOnly__c = 'No', TestServices__c = 'No',Packaging_Services__c = 'No', Chip_Interconnect__c = 'WLCSP-RDL', InputMethod__c ='Advanced Process: Inputs via XML file attachment.', PackageRequirement__c = 'Customer Existing Package', IntConBumpSource__c = 'Yes', TestLevels__c = '', Custom_Features__c = 'NA', NotMfgFeatures__c = 'NA', Cooling__c = 'Cross Flow', LifetimePOH__c = 'Other', DiffPairRequired__c = 'Yes', ModuleType__c = 'Multi-Chip Module', ProductShipReq__c = 'Other', ModuleDecouplingCapacitors__c = 'Yes', CapacitanceValue__c = 'Other', C4PadLayout__c  = 'Other', PackageType__c = '', DesignSubmission__c = '', DesignKitOthers__c = '', NeedAdditionalComments__c = 'Yes', StepPlanRotationActive__c = null, NumMetalLayers__c = '7', HasReleaseGuidelines__c ='Yes', ProductName__c='Test Product', ProductRevision__c ='1', ItarData__c='No', HazardousUse__c='No', ProjectedTapeout__c =system.today(), Weapon__c='No', Waivers__c='No', Passivation__c ='NA', Deliverable__c='NA', Premerge__c='No', DeliverableSplit__c ='No', WireBondLayout__c='NA', WireBondPad__c=1.0000, IpIdentification__c='NA', ReleaseProcessFlow__c='ABCD', NumOfDesigns__c =2, NumOfFEOLDesigns__c=1.0000, NumOfBEOLDesigns__c=1.0000, StepPlanEducation__c='Yes', StepPlanCustomRequirement__c='Yes', MetallizationOpts__c='asds', StepPlanCustomRequirementInput__c='asd', Customer_Name__c = acc.Id, Name__c = 'test1;test2;test3', AppName__c = 'test1;test2;test3');
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('tranx','InActiveStateChange');

            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj.formObj = new Form_Management_System__c();
            obj.isTFACompany = true;
            obj.dispWeapon = true;
            obj.dispIntConBumpServ = true;
            obj.Page2 = 2;
            obj.Page3 = 3;
            obj.Page4 = 4;
            obj.Page5 = 5;
            obj.Page2TFA = 2;
            obj.formObj.Packaging_Services__c = 'Yes';
            obj.readOnlyCheck = false;
            obj.requestToThawForm();
            obj.ThawForm();
            obj.submitForQuote();
            obj.submitForm();
            obj.freezeForm();
            obj.uploadFileId = '';
            obj.uploadECCNFileId = '';
            obj.dispchipEdgeWLCSP = true;
            Database.insert(formObj);
   
            FMSmainFormEditController obj1 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
            obj1.isTFACompany = false;
            obj1.dispWeapon = false;
            obj1.dispIntConBumpServ = false;
            obj1.Page2 = 1;
            obj1.Page3 = 1;
            obj1.Page4 = 1;
            obj1.Page5 = 1;
            obj1.Page2TFA = 1;
            obj1.requestToThawForm();
            obj1.ThawForm();
            System.assertEquals('Thawed', formObj.State_of_the_Form__c);       
            obj1.freezeForm();
            obj1.submitForm();
            obj1.submitForQuote();
            obj1.createAddendumForm();
            System.assertEquals('SubmittedForQuote', formObj.State_of_the_Form__c);       
            obj1.formObj.minScribeXVal__c = '2';
            obj1.formObj.minScribeYVal__c = '2';
            obj1.formObj.Channel_Type__c = 'Standard channels; Minimum width allowed';
            obj1.assignValues();
            obj1.formObj.minSpdScribeXVal__c = '2';
            obj1.formObj.minSpdScribeYVal__c = '2';
            obj1.formObj.Channel_Type__c = 'SPD channels; Minimum width allowed';
            obj1.assignValues();
            obj1.formObj.minWlcspScribeXVal__c = '2';
            obj1.formObj.minWlcspScribeYVal__c = '2';
            obj1.formObj.Channel_Type__c = 'GLOBALFOUNDRIES-sourced WLCSP;';
            obj1.assignValues();
            obj1.formObj.minScribeXVal__c = '2';
            obj1.formObj.minScribeYVal__c = '2';
            obj1.formObj.minWlcspScribeYVal__c = '';
            obj1.formObj.ChannelStdOnly__c = 'Minimum width allowed';
            obj1.assignValues();
            obj1.formObj.Technology__c = '45RFSOI';
            obj1.servOptsSetPg3 = new Set<String>();
            obj1.renderDicingPref();
            obj1.formObj.Technology__c = '--None--';
            obj1.getformReleaseProcess();
            formObj.Name__c = '';
            formObj.AppName__c = '';
            Database.update(formObj);
  
            FMSmainFormEditController obj2 = new FMSmainFormEditController(new ApexPages.StandardController(formObj));
        }
        Test.stopTest();
    }
    
    public static testMethod void FMSmainFormEditControllerTestMethodNew1() {
        Test.startTest();
        Account acc = getAccount('TEST rec');
        Contact con = getContact(acc.id, 'Testcon1');
        System.runAs(getUser()){
            setUpObject();    
            PageReference pageRef = Page.FormManagementMainPage;            
            Test.setCurrentPage(pageRef);    
            Form_Management_System__c formObj = getForm(acc.id);
            formObj.Technology__c = 'CSOI 7RF';
            formObj.Chip_Interconnect__c = 'Copper Pillar';
            formObj.QuoteOnly__c = 'No';
            Database.update(formObj);
            
            ApexPages.currentPage().getParameters().put('id',formObj.Id);
            ApexPages.currentPage().getParameters().put('pageN', '1');
            ApexPages.currentPage().getParameters().put('selectedVal', 'test');
  
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj));         
            obj.getSelectedMetalOption();
            ApexPages.currentPage().getParameters().remove('selectedVal');
            ApexPages.currentPage().getParameters().put('selectedVal', 'Other');
            obj.getSelectedMetalOption();
            obj.formObj.Technology__c = '';
            obj.getC4SolderMaterialList();
            Map<String,String> testMap = new Map<String,String>{'active'=>'true','min_scribe_x'=>'10','min_scribe_y'=>'10','min_spd_scribe_x'=>'10','min_spd_scribe_y'=>'10','design_notch'=>'10','min_default_wlcsp_scribe_x'=>'10','min_default_wlcsp_scribe_y'=>'10','wlcsp_enabled'=>'10'};            
            obj.setIntegrationFields(testMap);
            obj.servOptsSetPg3 = new Set<String>{'None'};
            obj.formObj.Packaging_Services__c = 'No';
            obj.renderChannelType();
            System.assertEquals(formObj.MetallizationOpts__c , null);   
        }
        Test.stopTest();
    }
    
    public static testMethod void submitFormTest() {
        Test.startTest();
        Account acc = getAccount('TEST rec');
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            Database.insert(skipUser);
            
            Form_Management_System__c formObj5 = getForm(acc.Id);
            ApexPages.currentPage().getParameters().put('id',formObj5.Id);
            
            FMSmainFormEditController obj = new FMSmainFormEditController(new ApexPages.StandardController(formObj5));
            map<string,object> mpFieldVals = new map<string,object>{'Name__c' => 'Test Name','Form_Name__c' => 'Test Main Form','Form_Description__c' => 'Test Description','Technology__c'=>'SOI12S0','TestServices__c' => 'No','Packaging_Services__c' => 'No','Chip_Interconnect__c' => 'Wirebond','QuoteOnly__c' => 'No','ServiceOptions__c' => 'Dicing','ServiceOptions__c' => 'Dicing','AppName__c' => 'Test 1,Test 2','AppEmail__c' => 'test@gmail.com','InputMethod__c' =>'Advanced Process: Inputs via XML file attachment.','Phone__c' => '9999999999','Email__c' => 'test@gmail.com','FileAttachment__c' => 'Test Attachment','AdvancedProcessFileAttachment__c' => 'Test Attachment','StepPlanRotationActive__c' => null,'NumMetalLayers__c' => '7','IntConBumpSource__c' => 'No(21L2039)','IntConBumpSource__c' => 'No(21L2039)','LastMetalUsed__c' => 'asdsds','HasReleaseGuidelines__c' =>'Yes','ProductName__c'=>'Test Product','ProductRevision__c' =>'1','ItarData__c'=>'No','HazardousUse__c'=>'No','ProjectedTapeout__c' =>system.today(),'Weapon__c'=>'No','Waivers__c'=>'No','Passivation__c' =>'NA','Custom_Features__c'=>'NA','NotMfgFeatures__c'=>'ab','Deliverable__c'=>'NA','Premerge__c'=>'No','DeliverableSplit__c' =>'No','WireBondLayout__c'=>'NA','WireBondPad__c'=>1.0000,'IpIdentification__c'=>'NA','ReleaseProcessFlow__c'=>'ABCD','DesignSubmission__c' => 'Multi-Design Reticle (>1 Topcell)','NumOfDesigns__c' =>2,'NumOfFEOLDesigns__c'=>1.0000,'NumOfBEOLDesigns__c'=>1.0000,'StepPlanEducation__c'=>'Yes','StepPlanCustomRequirement__c'=>'Yes','MetallizationOpts__c'=>'asds','StepPlanCustomRequirementInput__c'=>'asd'}; 
            for(String fld : mpFieldVals.keySet()) {
              obj.formObj.put(fld,mpFieldVals.get(fld));
            }            
            obj.submitForQuote();
            obj.submitForm();
            obj.freezeForm();
            System.assertEquals(null, formObj5.State_of_the_Form__c);   
            acc = getAccount('TEST rec1');
            formObj5.Customer_Name__c = acc.Id;
            Database.update(formObj5);
             
            FMSmainFormEditController obj1 = new FMSmainFormEditController(new ApexPages.StandardController(formObj5));
            obj1.formObj.Technology__c = UtilityCls.CMOS_9RFe;
            obj1.renderCll();
            obj1.formObj.CLL__c = 'Non-standard CLL (requires pre-approval)';
            obj1.renderNonStandardCll();
            obj1.renderShippingLabelCll();
            //obj1.selContentDocId = formObj5.FileAttachment__c;
            //obj1.deleteAttachment();
            obj1.stateChangeComments = 'comments';
            obj1.continueCheck();
        }
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