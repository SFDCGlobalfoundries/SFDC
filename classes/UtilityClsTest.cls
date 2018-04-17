/*
 @class: UtilityClsTest
 @CreatedBy: Inshu Misra
 @CreatedDate: 6 Oct, 2016
 @Description: to test the UtilityCls class...#IM
 @Modifications-
 *
 */
@isTest
public class UtilityClsTest {

    /*@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }*/
    
    public static List<FMS_Search_Filter__c> filtList = new List<FMS_Search_Filter__c>();  
    static User admin;
    
    @TestSetup
    static void setUpMethod(){
        DataUtilTest.loadEnvironmentVariables();
        TriggerHandler.bypass('Account_TriggerHandler');
        TriggerHandler.bypass('FMSTriggerHandler');
        TriggerHandler.bypass('Device_TriggerHandler');
        admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        IntegrationUsers__c intUser = new IntegrationUsers__c();
        intUser.Is_Integration_User__c = true;
        intUser.Name = 'Curr User';
        intUser.SetupOwnerId = UserInfo.getUserId();
        intUser.Skip_Trigger__c = true;
        intUser.Skip_Validation_Rule__c = true;
        insert intUser;
        
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('name', 'acc1');
        fieldValueAccMap.put('Site_Department__c', 'Site1');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Bill_To_Address_1__c', 'New Bill1');
        fieldValueAccMap.put('Bill_To_City__c', 'city1');
        fieldValueAccMap.put('Bill_To_Country__c', 'Austria');
        fieldValueAccMap.put('Corporate_Address_1__c', '');
        fieldValueAccMap.put('Corporate_City__c', 'city1');
        fieldValueAccMap.put('Corporate_Country__c', 'Austria');
        fieldValueAccMap.put('Fab_9_10__c', 'Yes');
        fieldValueAccMap.put('SAP_Account_Number__c', '006104');
        fieldValueAccMap.put('Tech_Geo_Granted__c', '0.007UM');
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        
        list<user> ulist = [select id from user where isactive = true and 
                            profile.UserType = 'Standard' and Fab_Assigned__c != NULL and id != :UserInfo.getUserId() limit 5];
        
        Contact conobj = createContact(account1.Id);
        
        String oppId = DeviceChecklistTestDataUtils.createOpp(account1.Id);
        String oppProgId = DeviceChecklistTestDataUtils.createOppProg(account1.Id, oppId);
        Process__c p = DeviceChecklistTestDataUtils.createProcess();
        Device__c dev = createDevice(account1.Id,oppId,oppProgId,p.Id);

        ContentVersion content=new ContentVersion(); 
            content.Title='Header_Picture1'; 
            content.PathOnClient='/' + content.Title + '.jpg'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData=bodyBlob; 
            content.origin = 'H';
        insert content;
        
        Map<String,Object> fieldValueFMSMap1 = new Map<String,Object>();
        fieldValueFMSMap1.put('Form_Name__c', 'Test Main Form');
        fieldValueFMSMap1.put('Customer_Name__c', account1.id);
        fieldValueFMSMap1.put('Customer__c', account1.Name);
        fieldValueFMSMap1.put('Technology__c', 'CSOI 7RF');
        fieldValueFMSMap1.put('Device__c', dev.Id);
        fieldValueFMSMap1.put('IsGeneratePublicURLForAttach__c', true);
        fieldValueFMSMap1.put('AdvancedProcessFileAttachment__c', content.Id);
        fieldValueFMSMap1.put('FileAttachment__c', content.Id);
        fieldValueFMSMap1.put('IsGeneratePublicURLForECCNAttach__c', true);
        fieldValueFMSMap1.put('ECCN_attachmentName__c', content.Id);
        Form_Management_System__c fObj = FMSDataFactory.createFMSRecord(fieldValueFMSMap1, FMSDataFactory.FormType.MAIN, true);
        
                   
        filtList.add(new FMS_Search_Filter__c(Name = 'Test Main Form', Created_Date_From__c = System.today()+1,             Created_Date_To__c = System.today()+3, Customer__c = fObj.Customer_Name__c,
                                               Form_State__c = 'Draft', Last_Modified_From__c = System.today()+1, Last_Modified_To__c = System.today()+2, Technology__c = 'CSOI 7RF',  Add_Filter_Value__c = 'value'));
        Database.insert(filtList,false);        
        
        FMS_Subscription__c subs = new FMS_Subscription__c();
        subs.Saved_Search_Id__c = filtList[0].Id;       
        Database.insert(subs,false);

        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='http://www.google.com/'; 
        testContentInsert.Title ='MPW Export Information'; 
        testContentInsert.file_group__c = 'User Training';
        testContentInsert.Index_number__c = 1;
        insert testContentInsert; 

        ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :testContentInsert.Id]; 
        ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name=:UtilityCls.FMSLibraries][0]; 
        System.debug(testWorkspace.Id);
        User u = [Select Id, Name from User where Id = :userinfo.getuserId()];
        //system.runas(u){
            ContentWorkspaceDoc newWorkspaceDoc =new ContentWorkspaceDoc(); 
            newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id; 
            newWorkspaceDoc.ContentDocumentId = testContent.ContentDocumentId; 
            insert newWorkspaceDoc;
        //}
    }
    
    public static Contact createContact(Id accountObjId){
        Contact conobj = new Contact(FirstName = 'Mr',
                                     LastName = 'Testcon1r11r',
                                     AccountId = accountObjId,
                                     Email = 'con12@gf.com',
                                     Department__c = 'Design;Engineering',
                                     is_portal_user_active__c = true,
                                     Is_Portal_User_Created__c = true);
        insert conObj;
        return conObj;
    }
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Generate_Standard_Frame__c = '';
        dev.Enabled_via_previous_MPW_1__c='';
        dev.CRMDID__c = '123456';
        dev.Stage__c = '';
        dev.Status__c = '';
        dev.Automotive_Device__c = '';
        dev.Original_Forecasted_Tapeout_Date__c = null;
        dev.Semiconductor_Device__c = '';
        dev.Reticle_Type__c = '';
        insert dev;
        return dev; 
    }

    static testmethod void utilityTest(){
        Device__c dev;
        PageReference pageRef = Page.FormManagementMainPage;
        Test.setCurrentPage(pageRef);
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        
            dev = [select Id,Name, Confidence_Level_Tapeout__c,Expose_Device_to_Customer__c,Fab__c,Assigned_Process_ID__c,
                   Enabled_via_previous_MPW_1__c,CRMDID__c, Generate_Standard_Frame__c, Stage__c, Status__c,
                   Automotive_Device__c, Original_Forecasted_Tapeout_Date__c, Semiconductor_Device__c,
                   Reticle_Type__c from Device__c limit 1];
            Test.startTest();

            System.assertNotEquals(null, UtilityCls.getAllFields('Form_Management_System__c'));
            System.assertEquals(null, UtilityCls.getAllFields('FM'));
            UtilityCls.createRetrofitDevice(dev, '');
            UtilityCls.createRetrofitDevice(dev, 'Test Device');
            System.DmlException e;
            Long l;
            UtilityCls.saveExceptionLog('source', 'sourceFunction', 'referenceId', 'referenceInfo', 'logMessage', 'payload', 'debugLevel', 'logCode', 'ApplicationName', e, l);
            
            List<Form_Management_System__c> formObjNewList = new List<Form_Management_System__c>([select Id, Name, IsGeneratePublicURLForAttach__c, AdvancedProcessFileAttachment__c, FileAttachment__c, Customer_Name__c, Customer_Name__r.SAP_Account_Number__c,Device__c, Device__r.Export_Control_Status__c,IsGeneratePublicURLForECCNAttach__c, ECCN_attachmentName__c, Device__r.ECCN_Wafer__c, Device__r.ECCN_Technology__c, Device__r.ITAR_Flag__c from Form_Management_System__c limit 1]);

            UtilityCls.isExportControlWaivedCustomer(formObjNewList[0]);
            UtilityCls.isRITAddendumAllowed(formObjNewList[0]);
            UtilityCls.changeHistory(formObjNewList[0]);
            List<ContentDistribution> distribution = new List<ContentDistribution>([select Id from ContentDistribution limit 1]);
            System.assert(distribution.isEmpty());
            UtilityCls.createContent(formObjNewList);
            List<ContentDistribution> distribution1 = new List<ContentDistribution>([select Id from ContentDistribution limit 1]);
            System.assert(!distribution1.isEmpty());
            UtilityCls.createContent(formObjNewList);
            new UtilityCls();
            UtilityCls.getContentList();
            UtilityCls.createExportControlJunction(dev.Id, dev.Id);
            UtilityCls.deleteSubscription(filtList);
            Test.stopTest();
        }
    }
    
    static testmethod void utilityTest1(){
        Account accobj = getAccount('acc1');
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsMainRec1;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueMFormMap(accobj, null);
            try {
                fmsMainRec1 = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.MAIN, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            fmsMainRec = [Select Id, Form_Type__c, DieXSize__c, DieYSize__c, NumOfDesigns__c, NumOfBEOLDesigns__c, NumC4Pads__c, WireBondPad__c, NumOfFEOLDesigns__c, WireBondPadPitch__c, VerticalX__c, HorizontalY__c, CrossFlowIFPM__c, NoOfDiffPairs__c, NoOfPowerSupplies__c, ModulePinsBallsTotal__c, ModulePinsBallsSignal__c, ModulePinsBallsPower__c, ModulePinsBallsGround__c, ModulePinsBallsUnused__c, NumberModuleDecouplingCapacitors__c from Form_Management_System__c where Id =: fmsMainRec1.Id];
            UtilityCls.validateFieldsCheck(fmsMainRec, 'page3');
            UtilityCls.validateFieldsCheck(fmsMainRec, 'page5');
            Test.stopTest();
        }
    }
    
    static testmethod void utilityTest2(){
        Account accobj = getAccount('acc1');
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec1;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueMFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.MAIN, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            Map<String,Object> fieldValueCFormMap = CreatefieldValueIFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.IMC, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            fmsRec1 = [Select Id, Form_Type__c, IMCNumOfDesigns__c, IMCNumOfBEOLDesigns__c, IMCNumOfFEOLDesigns__c from Form_Management_System__c where Id =: fmsRec.Id];
            UtilityCls.validateFieldsCheck(fmsRec1, 'page1');
            
            Test.stopTest();
        }
    }
    
    static testmethod void utilityTest3(){
        Account accobj = getAccount('acc1');
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec1;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueMFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.MAIN, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            Map<String,Object> fieldValueCFormMap = CreatefieldValueRFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            fmsRec1 = [Select Id, Form_Type__c, LeftXCoordinate__c, LeftYCoordinate__c, RightXCoordinate__c, RightYCoordinate__c from Form_Management_System__c where Id =: fmsRec.Id];
            UtilityCls.validateFieldsCheck(fmsRec1, 'page1');
            
            Test.stopTest();
        }
    }
    
    static testmethod void utilityTest4(){
        Account accobj = getAccount('acc1');
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec1;
            Form_Management_System__c fmsDDRRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueMFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.MAIN, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            Map<String,Object> fieldValueCFormMap = CreatefieldValueRFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            
            Map<String,Object> fieldValueCFormMap1  = CreatefieldValueDFormMap(accobj, fmsMainRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            fmsDDRRec1 = [Select Id, Form_Type__c, DDRLeftXCoordinate__c, DDRLeftYCoordinate__c, DDRRightXCoordinate__c, DDRRightYCoordinate__c from Form_Management_System__c where Id =: fmsDDRRec.Id];
            UtilityCls.validateFieldsCheck(fmsDDRRec1, 'page1');
            
            Test.stopTest();
        }
    }
    
    static Map<String,Object> CreatefieldValueMFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        fieldValueFormMap.put('DieXSize__c', 150);
        fieldValueFormMap.put('DieYSize__c', 150);
        fieldValueFormMap.put('NumOfDesigns__c', 0);
        fieldValueFormMap.put('NumOfBEOLDesigns__c', 0);
        fieldValueFormMap.put('NumC4Pads__c', 0);
        fieldValueFormMap.put('WireBondPad__c', 0);
        fieldValueFormMap.put('VerticalX__c', 0);
        fieldValueFormMap.put('HorizontalY__c', 0);
        fieldValueFormMap.put('NumOfDesigns__c', 0);
        fieldValueFormMap.put('NumOfBEOLDesigns__c', 0);
        return fieldValueFormMap;
    }
    
    static Map<String,Object> CreatefieldValueIFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        fieldValueFormMap.put('IMCNumOfDesigns__c', 0);
        fieldValueFormMap.put('IMCNumOfBEOLDesigns__c', 0);
        fieldValueFormMap.put('IMCNumOfFEOLDesigns__c', 0.9);
        return fieldValueFormMap;
    }
    
    static Map<String,Object> CreatefieldValueRFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        fieldValueFormMap.put('LeftXCoordinate__c', 0.9);
        fieldValueFormMap.put('RightXCoordinate__c', 0.9);
        fieldValueFormMap.put('RightYCoordinate__c', 0.9);
        fieldValueFormMap.put('LeftYCoordinate__c', 0.9);
        return fieldValueFormMap;
    }
    
    static Map<String,Object> CreatefieldValueDFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        fieldValueFormMap.put('DDRLeftYCoordinate__c', 0.9);
        fieldValueFormMap.put('DDRRightXCoordinate__c', 0.9);
        fieldValueFormMap.put('DDRRightYCoordinate__c', 0.9);
        fieldValueFormMap.put('DDRLeftXCoordinate__c', 0.9);
        return fieldValueFormMap;
    }
    
    static Account getAccount(String name){
        Account acc = [select id, Name from Account where name = :name];
        return acc;
    }
}