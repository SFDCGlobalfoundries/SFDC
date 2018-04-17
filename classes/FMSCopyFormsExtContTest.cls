/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSCopyFormsExtCont Class.
 * @ Date :- 04/10/2016
 * @ Change History :-  
 **/
@isTest
public class FMSCopyFormsExtContTest {

    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
    }

    static Map<String,Object> CreatefieldValueAccMap() {

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
        return fieldValueAccMap;
    }

    static Map<String,Object> CreatefieldValueFormMap(Id accObjId, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObjId);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        return fieldValueFormMap;
    }
    
    static testMethod void copyFormExtTest() {  

        Account accobj;
        Map<String,Object> fieldValueAccMap = CreatefieldValueAccMap();

        User thisUser = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
            ClsAccTriggerHandler.blnAccountShareRun = true;
            try{
                accobj = AccountDataFactory.createAccount(fieldValueAccMap);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSCopyFormsExtContTest.class.getName(), 'copyFormExtTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }
        //}

        //system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj.Id, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSCopyFormsExtContTest.class.getName(), 'copyFormExtTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj.Id, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSCopyFormsExtContTest.class.getName(), 'copyFormExtTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();

            PageReference pageRef = Page.FMSCopyForms;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);

            FMSCopyFormsExtCont copyExt = new FMSCopyFormsExtCont(new ApexPages.StandardController(fmsRec));
            copyExt.selParentFMSObject = fmsRec.id;
            copyExt.populateObj();
            copyExt.getParentList();
            copyExt.continueMethod();
            FMSHierarchyCompController.lstStringFormIds = copyExt.possibleParents;
            copyExt.getParentList();
            copyExt.selParentFMSObject = null;
            try {
              copyExt.continueMethod();  
            }catch(Exception e){}
            try {
              copyExt.populateObj();  
            }catch(Exception e){}
            PageReference pr = copyExt.cancelRecord();
            system.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+fmsRec.id));
            
            Test.stopTest();
        }
    }
}