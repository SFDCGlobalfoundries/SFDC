/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSSPFormViewExtension Class.
 * @ Date :- 04/10/2016
 * @ Change History :-  
 **/
@isTest
public class FMSNameDescControllerTest {
    @Testsetup
    static void createAccount() { 
        // Create Account
        DataUtilTest.loadEnvironmentVariables();
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
        testAcct.SAP_Account_Number__c = '001234';   //Changing SAP_Account_ID__c to SAP_Account_Number__c - 17-Nov-2016  -- Ashwin Dash
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
        FMSDataFactory.intUserCreation();
        TriggerHandler.bypass('Account_TriggerHandler');
        TriggerHandler.bypass('FMSTriggerHandler');
        Insert testAcct; 
    }

    static Account getAccount(){
        return [select Name,SAP_Account_Number__c,Stage__c,Site_Department__c,Sub_Type__c,Transaction_Type__c,Region__c,Bill_To_Address_1__c,Corporate_Address_1__c,Bill_To_City__c,
                          Corporate_City__c,Bill_To_Country__c,Corporate_Country__c,RecordTypeId,Short_Name__c, Fab_9_10__c from Account limit 1];
    }
    static testMethod void testMethodDescController() {
    
        test.startTest();
        
        System.runAs(FMSDataFactory.testUser){
            Account accobj = getAccount();
            
            Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
            fmsMainForm.Form_Name__c = 'testMAinForm';
            fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            insert fmsMainForm;
            
            ApexPages.currentPage().getParameters().put('id', fmsMainForm.id);
            
            FMSNameDescController FMSDesc = new FMSNameDescController ();
            System.assertEquals(false, FMSDesc.lastModDate);
            System.assertEquals(null, FMSDesc.formTypeNew);
            
        }
        Test.stopTest();
    }

    static testMethod void testMethodDescController1() {
    
        test.startTest();
        
        System.runAs(FMSDataFactory.testUser){
            Account accobj = getAccount();
            
            Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
            fmsMainForm.Form_Name__c = 'testMAinForm';
            fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            fmsMainForm.Customer__c = accobj.Name;
            insert fmsMainForm;
            
            Form_Management_System__c fmsSPForm = new Form_Management_System__c(); 
            fmsSPForm.Form_Name__c = 'testSPForm';
            fmsSPForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsSPForm.Customer__c = accobj.Name;
            fmsSPForm.Main_Form_Id__c = fmsMainForm.Id;
            insert fmsSPForm ;
            
            Form_Management_System__c fmsSPForm1 = new Form_Management_System__c(); 
            fmsSPForm1.Form_Name__c = 'testSPForm';
            fmsSPForm1.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsSPForm1.Customer__c = accobj.Name;
            fmsSPForm1.Main_Form_Id__c = fmsMainForm.Id;
            insert fmsSPForm1 ;

            ApexPages.currentPage().getParameters().put('id', fmsSPForm.id);
            
            FMSNameDescController FMSDesc = new FMSNameDescController ();
            System.assertEquals(true, FMSDesc.lastModDate);
            System.assertEquals(null, FMSDesc.formTypeNew);
        }
        Test.stopTest();
    }

    static testMethod void testMethodDescController3() {
    
        test.startTest();
        
        System.runAs(FMSDataFactory.testUser){
            Account accobj = getAccount();
            
            Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
            fmsMainForm.Form_Name__c = 'testMAinForm';
            fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            insert fmsMainForm;
            
            ApexPages.currentPage().getParameters().put('Type', 'Main');
            ApexPages.currentPage().getParameters().put('AccountId', accobj.Id);
            
            FMSNameDescController FMSDesc = new FMSNameDescController ();
            System.assertEquals(false, FMSDesc.lastModDate);
            System.assertEquals(EnvironmentVariable.get('FMS_MAIN_FORM'), FMSDesc.formTypeNew);
        }
        Test.stopTest();
    }

    static testMethod void testMethodDescController4() {
    
        test.startTest();
        
        System.runAs(FMSDataFactory.testUser){
            Account accobj = getAccount();
            
            Form_Management_System__c fmsMainForm = new Form_Management_System__c();    
            fmsMainForm.Form_Name__c = 'testMAinForm';
            fmsMainForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
            fmsMainForm.Customer__c = accobj.Name;
            insert fmsMainForm;
            
            Form_Management_System__c fmsSPForm = new Form_Management_System__c(); 
            fmsSPForm.Form_Name__c = 'testSPForm';
            fmsSPForm.RecordTypeId = Schema.getGlobalDescribe().get('Form_Management_System__c').getDescribe().getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsSPForm.Customer__c = accobj.Name;
            fmsSPForm.Main_Form_Id__c = fmsMainForm.Id;
            insert fmsSPForm ;
            
            ApexPages.currentPage().getParameters().put('Type', 'Other');
            ApexPages.currentPage().getParameters().put('ParentId', fmsMainForm.Id);
            
            FMSNameDescController FMSDesc = new FMSNameDescController ();
            System.assertEquals(false, FMSDesc.lastModDate);
            System.assertEquals(EnvironmentVariable.get('FMS_MAIN_FORM'), FMSDesc.formTypeNew);
        }
        Test.stopTest();
    }

}