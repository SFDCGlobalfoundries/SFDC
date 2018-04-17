/*
* @ Author :- Abhita Bansal
* @ Description :- contains the logic for code coverage the FMSFormHistoryReportController
* @ Date :- 18/07/2017
* @ Change History :-  
**/
@isTest
public class FMSFormHistoryReportControllerTest {

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

    static Map<String,Object> CreatefieldValueFormMap(Id accObjId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        return fieldValueFormMap;
    }

    static testMethod void formHistoryReportCont() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formHistoryReportCont()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.StartTest();

            Form_System_History__c fmsHis = new Form_System_History__c  ();
            fmsHis.Field_Name__c = 'Test';
            fmsHis.Main_Form__c = fmsRec.id;
            fmsHis.New_Value__c = 'Test1';
            fmsHis.Old_Value__c = 'Test2';
            insert fmsHis;

            PageReference pageRef = Page.FMSFormHistoryReport;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsRec.id);

            FMSFormHistoryReportController historyExt = new FMSFormHistoryReportController(new ApexPages.StandardController(fmsRec));

            historyExt.first();
            historyExt.last();
            historyExt.previous();
            historyExt.next();
            historyExt.SortToggle();
            historyExt.getDetails();
            historyExt.backToFormPage();
            historyExt.exportCsvFile();
            boolean test1 = historyExt.hasNext;
            boolean test2 = historyExt.hasPrevious;
            Integer pageNo = historyExt.pageNumber;
            
            Test.StopTest();
        }
    }

    static testMethod void formHistoryReportCont1() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDDRFormPage_ExtTest.class.getName(), 'formHistoryReportCont()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.StartTest();

            PageReference pageRef = Page.FMSFormHistoryReport;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            ApexPages.currentPage().getParameters().put('mainFormId', fmsRec.id);

            FMSFormHistoryReportController historyExt = new FMSFormHistoryReportController(new ApexPages.StandardController(fmsRec));
            Test.StopTest();
        }
    }
}