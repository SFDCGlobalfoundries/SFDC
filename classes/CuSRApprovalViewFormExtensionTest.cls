/*
Author: Shyam Ravindra Nair
Description: Test class for  CuSRApprovalViewFormExtension class.
History:
SNair     11012015     - code creation
SNair     28042015     - modified
*/
@isTest(SeeAllData=false)
public class CuSRApprovalViewFormExtensionTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }

    public static testMethod void myTestClass1(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                FAB_2__c = true,
                FAB_8__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            User approver = [select Id from User where Id != :userInfo.getUserId() and Profile.Name = 'GF CE' and isActive = true limit 1];
            
            CuSR_Approval_Process__c dresdenApprover = new CuSR_Approval_Process__c(
                Type_of_Approver__c = 'FAB 1 Owner',
                Site__c= 'Dresden',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 1',
                Status__c = 'Pending Approval'
            );
            insert dresdenApprover;
            
            CuSR_Approval_Process__c singaporeApprover = new CuSR_Approval_Process__c(
                Type_of_Approver__c = 'FAB 2 Owner',
                Site__c= 'Singapore',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 2',
                Status__c = 'Pending Approval'
            );
            insert singaporeApprover;
            
            CuSR_Approval_Process__c maltaApprover = new CuSR_Approval_Process__c(
                Type_of_Approver__c = 'FAB 8 Owner',
                Site__c= 'Malta',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Fab__c = 'FAB 8',
                Status__c = 'Pending Approval'
            );
            insert maltaApprover;
            
            CuSR_Approval_Process__c amApprver = new CuSR_Approval_Process__c(
                Type_of_Approver__c = 'AM',
                No_of_Approvers__c = '1',
                Approver1__c = approver.Id,
                CuSR_Form__c = testCuSRForm.Id,
                Status__c = 'Pending Approval'
            );
            insert amApprver;
            
            
            test.startTest();
            CuSRApprovalViewFormExtension controller1 = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(dresdenApprover));
            controller1.back();
            controller1.actionOnPageLoad();
            
            CuSRApprovalViewFormExtension controller2 = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(singaporeApprover));
            controller2.back();
            controller2.actionOnPageLoad();
            
            CuSRApprovalViewFormExtension controller3 = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(maltaApprover));
            controller3.back();
            controller3.actionOnPageLoad();
            
            CuSRApprovalViewFormExtension controller4 = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(amApprver));
            controller4.back();
            test.stopTest();
            
        }
    }
    
    static testMethod void myTestClass2(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            testCuSRForm.Stakeholder_Approval_Completed__c = true;
            testCuSRForm.Any_Cost_Impact__c = 'Yes';
            testCuSRForm.PM_Comments__c = 'sample';
            testCuSRForm.Status__c = 'Pending PM Review';
            testCuSRForm.PM_Approved__c = true;
            update testCuSRForm;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String queryFields = util.getAllFields('CuSR_Approval_Process__c');
            String query = 'select '+queryFields+' from CuSR_Approval_Process__c where CuSR_Form__c = \''+testCuSRForm.Id+'\' and Type_of_Approver__c = \'AM\'';
            CuSR_Approval_Process__c amApprover = Database.query(query);
            
            test.startTest();
            CuSRApprovalViewFormExtension controller = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(amApprover));
            controller.cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c = 'Yes';
            controller.cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c = 'Yes';
            controller.saveAMData();
            controller.cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c = 'No';
            controller.cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c = 'No';
            controller.saveAMData();         
            controller.cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification__c = 'sample';
            controller.cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification_2__c = 'sample';
            controller.saveAMData();
            controller.amApproved();
            test.stopTest();
        }
    }
    
    static testMethod void myTestClass3(){
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            testCuSRForm.Stakeholder_Approval_Completed__c = true;
            testCuSRForm.Any_Cost_Impact__c = 'Yes';
            testCuSRForm.PM_Comments__c = 'sample';
            testCuSRForm.Status__c = 'Pending PM Review';
            testCuSRForm.PM_Approved__c = true;
            testCuSRForm.PM_Approved_By__c = testUser.Id;
            testCuSRFOrm.PM_Approved_On__c = date.today();
            update testCuSRForm;
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String queryFields = util.getAllFields('CuSR_Approval_Process__c');
            String query = 'select '+queryFields+' from CuSR_Approval_Process__c where CuSR_Form__c = \''+testCuSRForm.Id+'\' and Type_of_Approver__c = \'AM\'';
            CuSR_Approval_Process__c amApprover = Database.query(query);
            
            test.startTest();
            CuSRApprovalViewFormExtension controller = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(amApprover));
            controller.amRejected();
            controller.cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification__c = 'sample';
            controller.cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification_2__c = 'sample';
            controller.amRejected();
            test.stopTest();
        }
    }
    
    static testMethod void myTestClass4(){
        try{
        User testUser = [select Id from User where Profile.Name = 'GF CE' and isActive = true limit 1];
        
        system.runAs(testUser){
            Account testAccount = eWSRUtilityTestDataClass.getAccount();
            
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                AccountId = testAccount.Id,
                Email = 'shyamravindra.nair@cognizant.com'
            );
            insert testContact;
            
            
            CuSR_Form__c testCuSRForm = new CuSR_Form__c(
                Request_Received_Date__c = Date.today(),
                FAB_1__c = true,
                Technology__c = 'CA 0.045UM',
                Customer_Name__c = testAccount.Id,
                System__c = 'CPK',
                Customer_Requestor__c = testContact.Id,
                Customer_Requestor_Email__c = testContact.Email,
                Notify_Customer_after_Implementation__c = 'No',
                Requested_Effective_Date__c = Date.newInstance(2015,1,31),
                Validity_Period_of_this_Request__c = 'EOL',
                Actual_Requirement__c = 'Test Requirement',
                Justification_for_Request__c = 'Test Justification',
                Scope_of_the_CuSR__c = 'RTP Parts',
                Is_this_a_one_time_requirement__c = 'Yes',
                Special_Requirement__c = 'Test Special Requirements',
                Status__c = 'New'
            );
            insert testCuSRForm;
            
            testCuSRForm.Stakeholder_Approval_Completed__c = true;
            testCuSRForm.Any_Cost_Impact__c = 'No';
            //testCuSRForm.PM_Comments__c = 'sample';
            testCuSRForm.Status__c = 'Pending PM Review';
            testCuSRForm.PM_Approved__c = true;
            testCuSRForm.PM_Approved_By__c = testUser.Id;
            testCuSRFOrm.PM_Approved_On__c = date.today();            
            update testCuSRForm;
            
            
            UtilClassToGetAllFields util = new UtilClassToGetAllFields();
            String queryFields = util.getAllFields('CuSR_Approval_Process__c');
            String query = 'select '+queryFields+' from CuSR_Approval_Process__c where CuSR_Form__c = \''+testCuSRForm.Id+'\' and Type_of_Approver__c = \'AM\'';
            CuSR_Approval_Process__c amApprover = Database.query(query);
            
            test.startTest();
            CuSRApprovalViewFormExtension controller = new CuSRApprovalViewFormExtension(new ApexPages.Standardcontroller(amApprover));
            controller.amRejected();
            controller.cusrApproval.Does_the_customer_agree_to_pay_for_CUSR__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification__c = 'sample';
            controller.cusrApproval.Will_GLOBALFOUNDRIES_charge_the_customer__c = 'No';
            controller.cusrApproval.If_No_Please_provide_justification_2__c = 'sample';
            controller.amRejected();
            test.stopTest();
        }
    }catch (Exception e) {
         Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.CUSR_Approval_Error) ? true : false;
        System.AssertEquals(expectedExceptionThrown, true);
       
    }
    }

}