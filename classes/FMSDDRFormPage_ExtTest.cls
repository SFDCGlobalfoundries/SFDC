/*
* @ Author :- Anil Kumar Reddy L
* @ Description :- contains the logic for code coverage the DDR Controller
* @ Date :- 28/09/2016
* @ Change History :-  
**/
@isTest
public class FMSDDRFormPage_ExtTest {

    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  

         Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('Name', 'Test Account1');            
        fieldValueAccMap.put('stage__c', 'Unqualified');        
        fieldValueAccMap.put('sub_type__c', 'Direct');
        fieldValueAccMap.put('site_department__c', 'Test Department');          
        fieldValueAccMap.put('transaction_type__c', 'transactional');                          
        fieldValueAccMap.put('region__c', 'APJ');        
        fieldValueAccMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Corporate_City__c', 'Lee');                
        fieldValueAccMap.put('Corporate_Country__c', 'Japan');
        fieldValueAccMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Bill_To_City__c', 'Test City');            
        fieldValueAccMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueAccMap.put('recordtypeid', rt); 
        fieldValueAccMap.put('short_name__c', 'TestAcct1');
        fieldValueAccMap.put('SAP_Account_Number__c', '001234');
        fieldValueAccMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueAccMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueAccMap.put('financial_territory__c', 'Japan Korea');
        fieldValueAccMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueAccMap.put('Fab_9_10__c', 'Yes');

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');  
        System.runAs(thisUser){
            try{
                Account accobj = AccountDataFactory.createAccount(fieldValueAccMap);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        }
    }

    static Account getAccount(String name){
        Account acc = [select id, Name from Account where name = :name];
        return acc;
    }

    static Map<String,Object> CreatefieldValueFormMap(Id accObjId, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        return fieldValueFormMap;
    }

    static Map<String,Object> CreatefieldValueRITMap(Id accObjId, Id mainFormId){

        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('RitHold__c', 'Yes');
        fieldValueFormMap.put('HoldReason__c', 'Review Post Design Service (Cheese and Fill) data');
        return fieldValueFormMap;
    }

    static Map<String,Object> CreatefieldValueDDRMap(Id accObjId, Id mainFormId, Id ritFormId) {

        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', ritFormId);
        fieldValueFormMap.put('TypeOfData__c', 'Post Design Service (Cheese and Fill)');
        fieldValueFormMap.put('IsPostDesign__c', 'Yes');
        return fieldValueFormMap;
    }

    static Map<String,Object> CreatefieldValueDDRMap1(Id accObjId, Id mainFormId, Id ritFormId) {

        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', ritFormId);
        fieldValueFormMap.put('TypeOfData__c', 'Post Design Service (Cheese and Fill)');
        fieldValueFormMap.put('IsPostDesign__c', 'Yes');
        fieldValueFormMap.put('ReturnReason__c', 'test');
        fieldValueFormMap.put('DDRLeftXCoordinate__c', 4);
        fieldValueFormMap.put('DDRLeftYCoordinate__c', 7);
        fieldValueFormMap.put('DDRRightXCoordinate__c', 8);
        fieldValueFormMap.put('DDRRightYCoordinate__c', 8);
        return fieldValueFormMap;
    }

    static Form_Management_System__c getForm(Id formObjId) {

        Form_Management_System__c fmsObj = [Select Id, State_of_the_Form__c from Form_Management_System__c where Id =:formObjId];
        return fmsObj;
    }

    static testMethod void formCreationDDR() {
        
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Account accobj = getAccount('Test Account1');
         User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
          Form_Management_System__c fmsRec;
           Form_Management_System__c fmsMainRec;
           Form_Management_System__c fmsDDRRec;
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        system.runAs(FMSDataFactory.testUser){
             Test.StartTest();
            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueRITMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
           

            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueDDRMap(accobj.Id, fmsMainRec.Id, fmsRec.Id);
            fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);

            PageReference pageRef = Page.FMSDDRFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            ApexPages.currentPage().getParameters().put('stateChangeVal', 'Cancelled');
            ApexPages.currentPage().getParameters().put('tranx', 'Subscribe');
            ApexPages.currentPage().getHeaders().put('Referer','GlobalfoundryView');
            ApexPages.currentPage().getParameters().put('fieldName','DDRRightXCoordinate__c');
            ApexPages.currentPage().getParameters().put('inpVal','true003');

            FMSDDRFormPage_Ext ddrExt = new FMSDDRFormPage_Ext(new ApexPages.StandardController(fmsDDRRec));

            ddrExt.TypeOfData();       
            ddrExt.copyAsNewForm();
            ddrExt.getpostDesignList();
            ddrExt.RequestAccepted();
            ddrExt.FormReturned();
            ddrExt.Cancelled();
            ddrExt.SubmitForDesign();
            ddrExt.EditForm();
            ddrExt.isInvalidInp = true;
            ddrExt.invInput();
            ddrExt.validations();
            ddrExt.saveandExit();
            ddrExt.saveForm();
            
            PageReference pr = ddrExt.validateSave();
            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+fmsDDRRec.id)); 
            
            ddrExt.Subscribe();
            ddrExt.UnSubscribe();
            ddrExt.SubscribeUser();
            ddrExt.cancelForm();
            ddrExt.openPDF();
            ddrExt.redirectToSearchPage();
            ddrExt.chngHistory();
            ddrExt.deleteForm();
            
            Test.StopTest();
        }
    
}
    static testMethod void formCreationDDR1() {

        Account accobj = getAccount('Test Account1');
        Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec;
            User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
            System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser; 
        system.runAs(FMSDataFactory.testUser){
            Test.StartTest();

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueRITMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
            
        
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueDDRMap1(accobj.Id, fmsMainRec.Id, fmsMainRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        
            PageReference pageRef = Page.FMSDDRFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            ApexPages.currentPage().getParameters().put('stateChangeVal', 'Cancelled');
            ApexPages.currentPage().getParameters().put('tranx', 'UnSubscribe');

            FMSDDRFormPage_Ext ddrExt = new FMSDDRFormPage_Ext(new ApexPages.StandardController(fmsDDRRec));
            ddrExt.SubmitForDesign();

            Form_Management_System__c fmsObj = getForm(fmsDDRRec.id);
            System.assertEquals(fmsObj.State_of_the_Form__c,'SubmitToProcess'); 

            Test.StopTest();
        }
        
    }

    static testMethod void formCreationDDR2() {

        Account accobj = getAccount('Test Account1');
        Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec;
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        system.runAs(FMSDataFactory.testUser){
            Test.StartTest();
            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueRITMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
            
        
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueDDRMap1(accobj.Id, fmsMainRec.Id, fmsMainRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        
            PageReference pageRef = Page.FMSDDRFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            ApexPages.currentPage().getParameters().put('stateChangeVal', 'Cancelled');
            ApexPages.currentPage().getParameters().put('tranx', 'UnSubscribe');

            FMSDDRFormPage_Ext ddrExt = new FMSDDRFormPage_Ext(new ApexPages.StandardController(fmsDDRRec));
            ddrExt.RequestAccepted();

            Form_Management_System__c fmsObj = getForm(fmsDDRRec.id);
            System.assertEquals(fmsObj.State_of_the_Form__c,'RequestAccepted'); 

            Test.StopTest();
        }
    }

    static testMethod void formCreationDDR3() {

        Account accobj = getAccount('Test Account1');
        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
         Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec;
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        system.runAs(FMSDataFactory.testUser){
           
            Test.StartTest();
            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueRITMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
           
        
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueDDRMap1(accobj.Id, fmsMainRec.Id, fmsMainRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        
            PageReference pageRef = Page.FMSDDRFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            ApexPages.currentPage().getParameters().put('stateChangeVal', 'Cancelled');
            ApexPages.currentPage().getParameters().put('tranx', 'UnSubscribe');

            FMSDDRFormPage_Ext ddrExt = new FMSDDRFormPage_Ext(new ApexPages.StandardController(fmsDDRRec));
            ddrExt.FormReturned();

            Form_Management_System__c fmsObj = getForm(fmsDDRRec.id);
            System.assertEquals(fmsObj.State_of_the_Form__c,'FormReturned'); 

            Test.StopTest();
        }
    }

    static testMethod void formCreationDDR4() {

        Account accobj = getAccount('Test Account1');
                    Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec;
            User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
        system.runAs(FMSDataFactory.testUser){

            Test.StartTest();
            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR4()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueRITMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR4()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
            }
           
        
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueDDRMap1(accobj.Id, fmsMainRec.Id, fmsMainRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formCreationDDR4()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        
            PageReference pageRef = Page.FMSDDRFormPage;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            ApexPages.currentPage().getParameters().put('stateChangeVal', 'Cancelled');
            ApexPages.currentPage().getParameters().put('tranx', 'UnSubscribe');

            FMSDDRFormPage_Ext ddrExt = new FMSDDRFormPage_Ext(new ApexPages.StandardController(fmsDDRRec));
            PageReference pr = ddrExt.Cancelled();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+fmsDDRRec.id)); 

            Test.StopTest();
        }
    }
}