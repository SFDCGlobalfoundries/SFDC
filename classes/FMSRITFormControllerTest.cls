@isTest(SeeAllData = false)
public class FMSRITFormControllerTest {
    
    static List<Form_Management_System__c> formObjList = new List<Form_Management_System__c>();
    static User admin;
    
    @TestSetup
    static void setUpMethod(){
        DataUtilTest.loadEnvironmentVariables();
        TriggerHandler.bypass('Account_TriggerHandler');
        TriggerHandler.bypass('FMSTriggerHandler');
        PageReference pageRef = Page.FMSRITFormNewEditPage1;            
        Test.setCurrentPage(pageRef);
        admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        
        System.runAs(admin){
            EnvironmentVariable.put('FMS_Admin_Group', 'FMS_Admin_Group');
            List<Group> grpList = new List<Group>([select Id, Name, DeveloperName from Group where DeveloperName =: 'FMS_Admin_Group' limit 1]);
            Group grp;
            if(grpList.isEmpty()){
                grp = new Group(Name = 'FMS Admin Group', DeveloperName = 'FMS_Admin_Group');
            }else{
                grp = grpList[0];
            }
            upsert grp;
            GroupMember grpMember = new GroupMember(GroupId = grp.Id, userOrGroupId= userInfo.getUserId());
            insert grpMember;
        }
        
        IntegrationUsers__c intUser = new IntegrationUsers__c();
        intUser.Is_Integration_User__c = true;
        intUser.Name = 'Curr User';
        intUser.SetupOwnerId = UserInfo.getUserId();
        intUser.Skip_Trigger__c = true;
        intUser.Skip_Validation_Rule__c = true;
        insert intUser;
        
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('Fab_9_10__c', 'Yes');
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        list<user> ulist = [select id from user where isactive = true and 
                            profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
        
        Map<String,Object> fieldValueFMSMap1 = new Map<String,Object>();
        fieldValueFMSMap1.put('Form_Name__c', 'Test Main Form');
        fieldValueFMSMap1.put('Customer_Name__c', account1.id);
        fieldValueFMSMap1.put('Customer__c', account1.Name);
        fieldValueFMSMap1.put('Form_Description__c', 'Test Description');
        fieldValueFMSMap1.put('TestServices__c', 'Yes');
        fieldValueFMSMap1.put('Packaging_Services__c', 'No');
        fieldValueFMSMap1.put('QuoteOnly__c', 'Yes');
        Form_Management_System__c fObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap1, FMSDataFactory.FormType.MAIN, true);

        Map<String,Object> fieldValueFMSMap2 = new Map<String,Object>();
        fieldValueFMSMap2.put('Form_Name__c', 'Test RIT Form');
        fieldValueFMSMap2.put('Customer_Name__c', account1.id);
        fieldValueFMSMap2.put('Customer__c', account1.Name);
        fieldValueFMSMap2.put('Parent_Form_Id__c', fObj.Id);
        fieldValueFMSMap2.put('Main_Form_Id__c', fObj.Id);
        fieldValueFMSMap2.put('SubmissionType__c', 'Final Submission');
        fieldValueFMSMap2.put('RITHold__c', 'Yes');
        fieldValueFMSMap2.put('PostDesignServices__c', 'Yes');
        fieldValueFMSMap2.put('HoldReason__c', 'Other');
        fieldValueFMSMap2.put('GdsSubset__c', 'Yes');
        
        Form_Management_System__c fritObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap2, FMSDataFactory.FormType.RIT, true);
        
        Map<String,Object> fieldValueFMSRITMap1 = new Map<String,Object>();
        fieldValueFMSRITMap1.put('Drop_Box_File_Name__c', 'Test1');
        fieldValueFMSRITMap1.put('File_Id__c', '101');
        fieldValueFMSRITMap1.put('File_Type__c', 'Design File');
        fieldValueFMSRITMap1.put('Form_Id__c', fritObj.Id);
        fieldValueFMSRITMap1.put('Package_Id__c', '201');
        fieldValueFMSRITMap1.put('Package_Name__c', 'TestPkg');
        fieldValueFMSRITMap1.put('SentDate__c', System.now() -20);
        fieldValueFMSRITMap1.put('senderEmail__c', 'fdryrel@globalfoundries.com');
        
        Map<String,Object> fieldValueFMSRITMap2 = new Map<String,Object>(fieldValueFMSRITMap1);
        fieldValueFMSRITMap2.put('Drop_Box_File_Name__c', 'Test2');
        fieldValueFMSRITMap2.put('File_Id__c', '102');
        fieldValueFMSRITMap2.put('File_Type__c', 'TAR / TGZ / ZIP / Other Archive');

        Map<String,Object> fieldValueFMSRITMap3 = new Map<String,Object>(fieldValueFMSRITMap1);
        fieldValueFMSRITMap3.put('Drop_Box_File_Name__c', 'Test3');
        fieldValueFMSRITMap3.put('File_Id__c', '103');
        fieldValueFMSRITMap3.put('File_Type__c', 'TAR / TGZ / ZIP / Other Archive');
        fieldValueFMSRITMap3.put('Package_Id__c', '202');
        
        List<Map<String,Object>> fvMapList = new List<Map<String,Object>>();
        fvMapList.add(fieldValueFMSRITMap1);
        fvMapList.add(fieldValueFMSRITMap2);
        fvMapList.add(fieldValueFMSRITMap3);
        
        List<FMS_RIT_Drop_Box__c> mainFile = FMSDataFactory.createFMSRITDropboxRecords(fvMapList, FMSDataFactory.FileType.Dropbox);

        Map<String,Object> fieldValueFMSRITDesMap1 = new Map<String,Object>();
        fieldValueFMSRITDesMap1.put('FMS_RIT_Drop_Box__c', mainFile[1].Id);
        fieldValueFMSRITDesMap1.put('Design_File_Name__c', 'TestD1');
        fieldValueFMSRITDesMap1.put('Form_Id__c', fritObj.Id);
        
        Map<String,Object> fieldValueFMSRITDesMap2 = new Map<String,Object>(fieldValueFMSRITDesMap1);
        fieldValueFMSRITDesMap2.put('FMS_RIT_Drop_Box__c', mainFile[2].Id);
        fieldValueFMSRITDesMap2.put('Design_File_Name__c', 'TestD2');
        
        List<Map<String,Object>> fvDesMapList = new List<Map<String,Object>>();
        fvDesMapList.add(fieldValueFMSRITDesMap1);
        fvDesMapList.add(fieldValueFMSRITDesMap2);
        
        List<FMS_RIT_Drop_Box__c> desFile = FMSDataFactory.createFMSRITDropboxRecords(fvDesMapList, FMSDataFactory.FileType.Design);

        Map<String,Object> fieldValueFMSRITTopMap1 = new Map<String,Object>();
        fieldValueFMSRITTopMap1.put('FMS_RIT_Drop_Box__c', mainFile[0].Id);
        fieldValueFMSRITTopMap1.put('TopCellName__c', 'TestD1');
        fieldValueFMSRITTopMap1.put('Form_Id__c', fritObj.Id);
        
        Map<String,Object> fieldValueFMSRITTopMap2 = new Map<String,Object>(fieldValueFMSRITTopMap1);
        fieldValueFMSRITTopMap2.put('FMS_RIT_Drop_Box__c', desFile[0].Id);
        fieldValueFMSRITTopMap2.put('TopCellName__c', 'TestD2');

        Map<String,Object> fieldValueFMSRITTopMap3 = new Map<String,Object>(fieldValueFMSRITTopMap1);
        fieldValueFMSRITTopMap3.put('FMS_RIT_Drop_Box__c', desFile[1].Id);
        fieldValueFMSRITTopMap3.put('TopCellName__c', 'TestD3');

        List<Map<String,Object>> fvTopMapList = new List<Map<String,Object>>();
        fvTopMapList.add(fieldValueFMSRITTopMap1);
        fvTopMapList.add(fieldValueFMSRITTopMap2);
        fvTopMapList.add(fieldValueFMSRITTopMap3);
        
        List<FMS_RIT_Drop_Box__c> topFile = FMSDataFactory.createFMSRITDropboxRecords(fvTopMapList, FMSDataFactory.FileType.TopCell);
        
    }
    
    public static testMethod void FMSRITFormControllerTestMethod() {
        formObjList = new List<Form_Management_System__c>([select Id from Form_Management_System__c where RecordTypeId =:Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId()]);
        Test.setCurrentPage(Page.FMSRITFormNewEditPage1);
        ApexPages.currentPage().getParameters().put('pageNo','2');
        ApexPages.currentPage().getParameters().put('id',formObjList[0].Id);
        ApexPages.currentPage().getParameters().put('inpVal','valCheck007');
        ApexPages.currentPage().getParameters().put('addenType','main');
        ApexPages.currentPage().getParameters().put('fileRecordId','main');
        ApexPages.currentPage().getHeaders().put('referer', 'GlobalfoundryView');
        ApexPages.currentPage().getParameters().put('index','101');
        ApexPages.currentPage().getParameters().put('stateChangeVal','newStatus');
        ApexPages.StandardController extCont = new ApexPages.StandardController(formObjList[0]); 
        FMSRITFormController obj = new FMSRITFormController(extCont);
        
        obj.setExtMessage();
        obj.setExtReportDisabled();
        obj.next();
        obj.previous();
        obj.last();
        obj.first();
        obj.pageCall();
        obj.readOnlyPackage();
        obj.showExistingSel();
        obj.editPackage();
        obj.getTypeSubList();
        obj.getPackages();
        obj.gettotalPageNums();
        obj.saveForm();
        obj.cancelForm();
        obj.saveandExit();
        obj.getHoldReasonsList();
        obj.invInput();
        obj.getOtherReason();
        obj.resetDependentFields();
        obj.continueCheck();
        obj.editForm();
        obj.copyAsNewForm();
        obj.updateFormDetails();
        obj.statusChange();
        obj.stateCommentChange();
        obj.getSelectAddendumValues();
        obj.showPopup();
        obj.closePopup();
        obj.validationCheck();
        obj.validationBeforeAddendum();
        obj.Subscribe();
        obj.UnSubscribe();
        obj.SubscribeUser();
        obj.openPDF();
        obj.redirectToSearchPage();
        obj.createAddendumForm();
        System.assertEquals(null, obj.nextPage());
        obj.prevPage();
        obj.pageN = 'page1';
        System.assertEquals(null, obj.nextPage());
        System.assertEquals(String.valueOf(Page.FMSRITFormViewPage).toLowerCase(), String.valueOf(obj.validateSave()).toLowerCase());
        
        obj.pageN = 'page2';
        System.assertEquals(String.valueOf(Page.FMSRITFormNewEditPage3).toLowerCase(), String.valueOf(obj.nextPage()).toLowerCase());
        System.assertEquals(String.valueOf(Page.FMSRITFormNewEditPage1).toLowerCase(), String.valueOf(obj.prevPage()).toLowerCase());
        obj.validateSave();
        
        obj.pageN = 'page3';
        obj.validateSave();
        System.assertEquals(String.valueOf(Page.FMSRITFormNewEditPage2).toLowerCase(), String.valueOf(obj.prevPage()).toLowerCase());
        
        obj.navPackWrapper[0].packDropBoxdata.get('101').isSelected = false;
        obj.navPackWrapper[0].packageToUser = false;
        obj.navPackWrapper[0].getPackageText();
        obj.navPackWrapper[0].packageToUser = true;
        obj.navPackWrapper[0].getPackageText();
        obj.validateSave();
        obj.navPackWrapper[0].delRowFromDropBoxFile();
        System.assertEquals(1, obj.navPackWrapper[0].packdropboxdata.size());
        
        obj.navPackWrapper[0].packDropBoxdata.get('102').isSelected = false;
        obj.page2Methods();
        
        obj.deleteForm();
        obj.deleteForm();
    }
    
    public static testMethod void RITDropboxEditPackageTestPositive(){
        formObjList = new List<Form_Management_System__c>([select Id from Form_Management_System__c where RecordTypeId =:Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Design Data Submission (RIT)').getRecordTypeId()]);
        Test.setCurrentPage(Page.FMSRITFormNewEditPage1);
        ApexPages.currentPage().getParameters().put('pageNo','2');
        ApexPages.currentPage().getParameters().put('id',formObjList[0].Id);
        ApexPages.currentPage().getParameters().put('inpVal','valCheck007');
        ApexPages.currentPage().getHeaders().put('referer', 'test');
        ApexPages.StandardController extCont = new ApexPages.StandardController(formObjList[0]); 
        ApexPages.currentPage().getParameters().put('fileRecordId','main');
        ApexPages.currentPage().getParameters().put('index','0');
        FMSRITFormController obj = new FMSRITFormController(extCont);
        
        System.assert(obj.hasNext);
        System.assert(!obj.hasPrevious);
        Boolean num1 = obj.num1Sel;
        Boolean num2 = obj.num2Sel;
        Boolean num3 = obj.num3Sel;
        Integer numPage = obj.numberOfPages;
        List<FMSRITFormController.packageWrapper> nav = obj.navPackWrapperMap;
        Integer row = obj.rowNum;
        Boolean next = obj.next;
        String file2Id = obj.comFileToIdList;
        
        obj.navPackWrapper[0].packDropBoxdata.get('101').addRowToDesignFile();
        obj.navPackWrapper[0].packDropBoxdata.get('101').addRowToTopCellFile();
        obj.navPackWrapper[0].packDropBoxdata.get('101').delRowToDesignFile();
        obj.navPackWrapper[0].packDropBoxdata.get('101').delRowToTopCellFile();
        obj.navPackWrapper[0].packDropBoxdata.get('101').getSize();
        obj.chngHistory();
        obj.redirectToSearchPage();
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new FMSMockHttpResponseGeneratorDropBox());
        obj.editPackage();
        obj.continueCheck();
        Test.stopTest();
        EnvironmentVariable.put('DropBox_Is_Active','false');
        obj.stateChangeComments = 'some comments';
        obj.editPackage();
        obj.continueCheck();
        Form_Management_System__c fms = [Select Id,State_of_the_Form__c from Form_Management_System__c where Id =:formObjList[0].Id];
        System.assertEquals(null, fms.State_of_the_Form__c );
    }
}