/*
 * @ Author :- Abhita Bansal
 * @ Description :- contains the test logic for FMSDirectionClass Class.
 * @ Date :- 06/08/2017
 * @ Change History :-  
 **/
@isTest
public class FMSDirectionClassTest {
    
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

    static Map<String,Object> CreatefieldValueFormMap(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Parent_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        return fieldValueFormMap;
    }

    static Map<String,Object> CreatefieldValueFormMapSP(Account accObj, Id mainformId) {
        Map<String,Object> fieldValueFormMap = new Map<String,Object>();
        fieldValueFormMap.put('Customer_Name__c', accObj.Id);
        fieldValueFormMap.put('Main_Form_Id__c', mainformId);
        fieldValueFormMap.put('Customer__c', accObj.Name);
        return fieldValueFormMap;
    }

    static testMethod void redirectToTest() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();

            PageReference pageRef = Page.FMSDirectionEditPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectTo();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormNewEditPage1?id='+fmsRec.id+'&pageNo=1'));

            Test.stopTest();
        }
    }
      
    static testMethod void redirectToTest1() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.IMC, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest1()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionEditPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectTo();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormPage?id='+fmsRec.id+'&pageNo=1'));

            Test.stopTest();
        }
    }
      
    static testMethod void redirectToTest2() {

        Account accobj = getAccount('Test Account1');
        
        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsDDRRec;
            Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
                    
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueFormMap(accobj, fmsRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);     
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest2()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            PageReference pageRef = Page.FMSDirectionEditPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsDDRRec));
            PageReference pr = directExt.redirectTo();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormPage?id='+fmsDDRRec.id)); 

            Test.stopTest();
        }       
    }

    static testMethod void redirectToTest3() {

        Account accobj = getAccount('Test Account1');
        
        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsRec;
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsDDRRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
           
            Map<String,Object> fieldValueCFormMap1 = CreatefieldValueFormMap(accobj, fmsRec.Id);
            try {
                fmsDDRRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap1, FMSDataFactory.FormType.DDR, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest3()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            PageReference pageRef = Page.FMSDirectionViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsDDRRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsDDRRec));
            PageReference pr = directExt.redirectToView();

            System.assert(pr.getUrl().contains('/apex/FMSDDRFormViewPage?id='+fmsDDRRec.id)); 

            Test.stopTest();
        }    
        
    }

    static testMethod void redirectToTest4() {  

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest4()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.RIT, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest4()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectToView();

            System.assert(pr.getUrl().contains('/apex/FMSRITFormViewPage?id='+fmsRec.id+'&pageNo=1'));
            
            Test.stopTest();
        }
    }
      
    static testMethod void redirectToTest5() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest5()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMap(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.IMC, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest5()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectToView();

            System.assert(pr.getUrl().contains('/apex/FMSIMCFormViewPage?id='+fmsRec.id+'&pageNo=1'));
            
            Test.stopTest();
        }
    }

    static testMethod void redirectToTest6() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest6()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionEditPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsMainRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsMainRec));
            PageReference pr = directExt.redirectTo();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormCreationPg1?id='+fmsMainRec.id+'&pageNo=1'));
            
            Test.stopTest();
        }
    }

    static testMethod void redirectToTest7() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest7()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsMainRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsMainRec));
            PageReference pr = directExt.redirectToView();

            System.assert(pr.getUrl().contains('/apex/FMSmainFormViewPage?id='+fmsMainRec.id+'&pageNo=1'));
            
            Test.stopTest();
        }
    }

    static testMethod void redirectToTest8() {

        Account accobj = getAccount('Test Account1');
        
        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest8()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMapSP(accobj, fmsMainRec.Id);
            //try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.SP, true);
            /*} catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest8()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }*/

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionViewPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectToView();

            System.assert(pr.getUrl().contains('/apex/FMSStepPlanFormView?id='+fmsRec.id));
            
            Test.stopTest();
        }
    }

    static testMethod void redirectToTest9() {

        Account accobj = getAccount('Test Account1');

        system.runAs(FMSDataFactory.testUser){
            Form_Management_System__c fmsMainRec;
            Form_Management_System__c fmsRec;

            Map<String,Object> fieldValueMFormMap = CreatefieldValueFormMap(accobj, null);
            try {
                fmsMainRec = FMSDataFactory.createFMSRecord(fieldValueMFormMap, FMSDataFactory.FormType.Main, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest9()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Map<String,Object> fieldValueCFormMap = CreatefieldValueFormMapSP(accobj, fmsMainRec.Id);
            try {
                fmsRec = FMSDataFactory.createFMSRecord(fieldValueCFormMap, FMSDataFactory.FormType.SP, true);
            } catch(Exception e){
                UtilityCls.saveExceptionLog(FMSDirectionClassTest.class.getName(), 'redirectToTest9()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
            }

            Test.startTest();
            
            PageReference pageRef = Page.FMSDirectionEditPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', fmsRec.id);
            
            FMSDirectionClass directExt = new FMSDirectionClass(new ApexPages.StandardController(fmsRec));
            PageReference pr = directExt.redirectTo();

            System.assert(pr.getUrl().contains('/apex/FMSStepPlanEditForm?id='+fmsRec.id));

            Test.stopTest();
        }
    }

}