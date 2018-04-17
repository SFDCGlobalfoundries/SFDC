/*
 * @ Author :- Anil Kumar Reddy L
 * @ Description :- contains the test logic for FMSHierarchyCompController Class.
 * @ Date :- 04/10/2016
 * @ Change History :-  
 **/
@isTest(SeeAllData = false)
public class FMSHierarchyCompControllerTest {
    
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
    }
    
    static Id createAccount() { 
      
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
        testAcct.SAP_Account_ID__c = 'testId';
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
        testAcct.RecordTypeId = rt;      
        testAcct.Short_Name__c = 'TestAcct1';
        testAcct.Fab_9_10__c = 'Yes';
        Insert testAcct;   
        return testAcct.Id;
    } 

    
    static testMethod void testMethodDescController() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id accId = createAccount();
            
            Form_Management_System__c fmsRecMain = new Form_Management_System__c();
            fmsRecMain.Form_Name__c = 'testFormMain';
            fmsRecMain.UniqueWebRDTSId__c = '111111';
            insert fmsRecMain;
                    
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Selection__c = 'Reject Preliminary Step Plan';
            fmsRec.RejectionReason__c = 'Other';
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.Customer_Name__c = accId;
            fmsRec.Main_Form_Id__c = fmsRecMain.id;
            fmsRec.Parent_Form_Id__c = fmsRecMain.id;
            fmsRec.UniqueWebRDTSId__c = '111111';
            fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsRec.UniqueWebRDTSId__c = 'temp';
            INSERT fmsRec;
            
            
            Test.startTest();
             PageReference pageRef = Page.FMSIMCFormPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',fmsRec.id);
            
            FMSHierarchyCompController nameDesCont = new FMSHierarchyCompController();
            nameDesCont.getlstFMSHierarchy();
            
            
           
           Test.stopTest();
        }
    }
     static testMethod void testMethodDescController2() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id accId = createAccount();
            
            Form_Management_System__c fmsRecMain = new Form_Management_System__c();
            fmsRecMain.Form_Name__c = 'testFormMain';
            fmsRecMain.UniqueWebRDTSId__c = '111111';
            insert fmsRecMain;
                    
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Selection__c = 'Reject Preliminary Step Plan';
            fmsRec.RejectionReason__c = 'Other';
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.Customer_Name__c = accId;
            fmsRec.Main_Form_Id__c = fmsRecMain.id;
            fmsRec.Parent_Form_Id__c = fmsRecMain.id;
            fmsRec.UniqueWebRDTSId__c = '111111';
            fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsRec.UniqueWebRDTSId__c = 'temp';
            INSERT fmsRec;
            
            
            Test.startTest();
             PageReference pageRef = Page.FMSIMCFormPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',fmsRec.id);
            ApexPages.currentPage().getParameters().put('tranx','Copy');
            ApexPages.currentPage().getParameters().put('ParentId',fmsRecMain.id);
            ApexPages.currentPage().getParameters().put('Type','RIT');
            FMSHierarchyCompController nameDesCont = new FMSHierarchyCompController();
            nameDesCont.getlstFMSHierarchy();
            
            
           
           Test.stopTest();
        }
    }
    
    static testMethod void testMethodDescController3() {
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id accId = createAccount();
            
            Form_Management_System__c fmsRecMain = new Form_Management_System__c();
            fmsRecMain.Form_Name__c = 'testFormMain';
            fmsRecMain.UniqueWebRDTSId__c = '111111';
            insert fmsRecMain;
                    
            Form_Management_System__c fmsRec = new Form_Management_System__c();
            fmsRec.Selection__c = 'Reject Preliminary Step Plan';
            fmsRec.RejectionReason__c = 'Other';
            fmsRec.Form_Name__c = 'testForm';
            fmsRec.Customer_Name__c = accId;
            fmsRec.Main_Form_Id__c = fmsRecMain.id;
            fmsRec.Parent_Form_Id__c = fmsRecMain.id;
            fmsRec.UniqueWebRDTSId__c = '111111';
            fmsRec.RecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId();
            fmsRec.UniqueWebRDTSId__c = 'temp';
            INSERT fmsRec;
            
            
            Test.startTest();
             PageReference pageRef = Page.FMSIMCFormPage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',fmsRec.id);
            ApexPages.currentPage().getParameters().put('tranx','Create');
            ApexPages.currentPage().getParameters().put('ParentId',fmsRecMain.id);
            ApexPages.currentPage().getParameters().put('Type','RIT');
            FMSHierarchyCompController nameDesCont = new FMSHierarchyCompController();
            nameDesCont.getlstFMSHierarchy();
            
            
           
           Test.stopTest();
        }
    }
}