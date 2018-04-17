/*
 @class: FMSFutureCallClassTest
 @CreatedBy: Inshu Misra
 @CreatedDate: 6 Oct, 2016
 @Description: to test the UtilityCls class...#IM
 @Modifications-
 *
 */
@isTest
public class FMSFutureCallClassTest{

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static Account createAccount() {

        Account accountObj = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill1', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', 
        Corporate_Country__c = 'Austria', Fab_9_10__c = 'Yes', SAP_Account_Number__c = '006104', Tech_Geo_Granted__c = '0.007UM',Sold_to_VAT_Registration_Number__c=123.1); 
        insert accountObj;

        return accountObj;
    }    
    
    public static Device__c createDevice(Id accId, Id oppId, Id oppProgId, Id processId){
        Device__c dev = deviceutiltest.createDevicePM(accId,oppId,oppProgId);
        dev.Confidence_Level_Tapeout__c = '100';
        dev.Expose_Device_to_Customer__c = false ; 
        dev.Fab__c = 'Fab 3';
        dev.Assigned_Process_ID__c = processId;
        dev.Enabled_via_previous_MPW_1__c='No';
        dev.CRMDID__c = '123456';
        insert dev;
        return dev; 
    }

    public static Form_Management_System__c  mainFromCreate(Id accId, Id devId, String RecordType){

        Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
        fmsMainForm.Form_Name__c = 'testMAinForm';
        fmsMainForm.Customer_Name__c = accId;
        fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        fmsMainForm.Technology__c = 'CSOI 7RF';
        fmsMainForm.Device__c = devId;
        insert fmsMainForm;

        return fmsMainForm;
    }

    static testmethod void testMethod1(){
        
        Account accountObj;
        Contact conobj;
        
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
        
            accountObj = createAccount();

            String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Test.startTest();
            Device__c dev = createDevice(accountObj.Id,oppId,oppProgId,p.Id);      
            
                 
            
            Form_Management_System__c formObj = mainFromCreate(accountObj.Id, dev.Id, 'Main Product Definition Form');
            
            Product2 prod = new Product2(Name = 'CSOI 7RF', 
            Family = 'Hardware', Product_External_ID__c = '1323233', PT_Number__c = '1111');
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id pricebookId = Test.getStandardPricebookId();
            
            // 1. Insert a price book entry for the standard price book.
            // Standard price book entries require the standard price book ID we got earlier.
            PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Process_Technology__c  pt = new Process_Technology__c(Name = 'Test', PT_Number__c='1111');
            insert pt;
            
            Apttus_Proposal__Proposal__c aptt = new Apttus_Proposal__Proposal__c(FMS_Proposal__c = formObj.Id);
            insert aptt;
            Test.stopTest();
            Apttus_Proposal__Proposal_Line_Item__c apttLine = new Apttus_Proposal__Proposal_Line_Item__c();
            apttLine.Apttus_Proposal__Proposal__c = aptt.Id;
            apttLine.Apttus_Proposal__Product__c = prod.Id;
            apttLine.Apttus_QPConfig__OptionId__c = prod.Id;
            insert apttLine;
            
            Apttus_Config2__ClassificationName__c classiName = new Apttus_Config2__ClassificationName__c();
            classiName.Name = 'Test Classification';
            classiName.Apttus_Config2__HierarchyLabel__c = 'Test';
            classiName.Category_External_ID__c = '1234';
            insert classiName;
            
            Apttus_Config2__ClassificationHierarchy__c classHier = new Apttus_Config2__ClassificationHierarchy__c();
            classHier.Name = 'Test Name';
            classHier.Apttus_Config2__HierarchyId__c = classiName.Id;
            classHier.Apttus_Config2__Label__c = 'test label';
            classHier.Category_Hierarchy_External_ID__c = '12334';
            insert classHier;
                       
            Apttus_Config2__ProductOptionGroup__c apttConfgrp = new Apttus_Config2__ProductOptionGroup__c ();
            apttConfgrp.Apttus_Config2__OptionGroupId__c = classHier.Id;
            apttConfgrp.Apttus_Config2__Sequence__c = 1;
            apttConfgrp.Apttus_Config2__ProductId__c = prod.Id;
            apttConfgrp.Apttus_Config2__IsHidden__c = false;
            insert apttConfgrp;
            
            Apttus_Config2__ProductOptionComponent__c apttConf = new Apttus_Config2__ProductOptionComponent__c();
            apttConf.Apttus_Config2__ComponentProductId__c = prod.Id;
            apttConf.Apttus_Config2__ProductOptionGroupId__c = apttConfgrp.Id;
            apttConf.Apttus_Config2__Sequence__c = 0;
            insert apttConf;

            FMSFutureCallClass.updateDeviceFMSID(new set<Id>{formObj.Id});
            FMSFutureCallClass.updatePTNumber(new List<Id>{formObj.Id});
            FMSFutureCallClass.updateStage(dev.Id);
            FMSFutureCallClass.updateFieldsInForm(new set<Id>{formObj.Id}, 'testURL/GlobalfoundryView');          

            
        }
    }
    
    static testmethod void testMethod2(){
        
        Account accountObj;
        Contact conobj;
        
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
        
            accountObj = createAccount();

            String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Test.startTest(); 
            Device__c dev = createDevice(accountObj.Id,oppId,oppProgId,p.Id);      
            
                
            
            Form_Management_System__c formObj = mainFromCreate(accountObj.Id, dev.Id, 'Incremental Mask Change (IMC)');
            
            Product2 prod = new Product2(Name = 'CSOI 7RF', 
            Family = 'Hardware', Product_External_ID__c = '1323233', PT_Number__c = '1111');
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id pricebookId = Test.getStandardPricebookId();
            
            // 1. Insert a price book entry for the standard price book.
            // Standard price book entries require the standard price book ID we got earlier.
            PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Process_Technology__c  pt = new Process_Technology__c(Name = 'Test', PT_Number__c='1111');
            insert pt;
                        
            FMSFutureCallClass.updateFieldsInForm(new set<Id>{formObj.Id}, 'testURL/GlobalfoundryView');          
            Test.stopTest();
            
        }
    }
    
    static testmethod void testMethod3(){
        
        Account accountObj;
        Contact conobj;
        
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
        
            accountObj = createAccount();

            String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Test.startTest();
            Device__c dev = createDevice(accountObj.Id,oppId,oppProgId,p.Id);      
            
                 
            
            Form_Management_System__c formObj = mainFromCreate(accountObj.Id, dev.Id, 'Design Data Submission (RIT)');

            Product2 prod = new Product2(Name = 'CSOI 7RF', 
            Family = 'Hardware', Product_External_ID__c = '1323233', PT_Number__c = '1111');
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id pricebookId = Test.getStandardPricebookId();
            
            // 1. Insert a price book entry for the standard price book.
            // Standard price book entries require the standard price book ID we got earlier.
            PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Process_Technology__c  pt = new Process_Technology__c(Name = 'Test', PT_Number__c='1111');
            insert pt;
                        
            FMSFutureCallClass.updateFieldsInForm(new set<Id>{formObj.Id}, 'testURL/GlobalfoundryView');          
            Test.stopTest();
           
        }
    }
    
    static testmethod void testMethod4(){
        
        Account accountObj;
        Contact conobj;
        
        PageReference pageRef = Page.FormManagementMainPage;            
        Test.setCurrentPage(pageRef);
        
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
        
            accountObj = createAccount();

            String oppId = DeviceChecklistTestDataUtils.createOpp(accountObj.Id);
            String oppProgId = DeviceChecklistTestDataUtils.createOppProg(accountObj.Id, oppId);
            Process__c p = DeviceChecklistTestDataUtils.createProcess();
            Test.startTest();
            Device__c dev = createDevice(accountObj.Id,oppId,oppProgId,p.Id);      
            
                 
            
            Form_Management_System__c formObj = mainFromCreate(accountObj.Id, dev.Id, 'Design Data Return (DDR)');
            
            Product2 prod = new Product2(Name = 'CSOI 7RF', 
            Family = 'Hardware', Product_External_ID__c = '1323233', PT_Number__c = '1111');
            insert prod;
            
            // Get standard price book ID.
            // This is available irrespective of the state of SeeAllData.
            Id pricebookId = Test.getStandardPricebookId();
            
            // 1. Insert a price book entry for the standard price book.
            // Standard price book entries require the standard price book ID we got earlier.
            PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
            insert standardPrice;
            
            Process_Technology__c  pt = new Process_Technology__c(Name = 'Test', PT_Number__c='1111');
            insert pt;
                        
            FMSFutureCallClass.updateFieldsInForm(new set<Id>{formObj.Id}, 'testURL/GlobalfoundryView');          
            Test.stopTest();
            
        }
    }
}