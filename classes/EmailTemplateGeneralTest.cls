/*
 @class: EmailTemplateGeneralTest
 @CreatedBy: Inshu Misra
 @CreatedDate: 6 Oct, 2016
 @Description: Test Class created to test the EmailTemplateGeneral class...#IM
 @Modifications-
 *
 */
@isTest
public class EmailTemplateGeneralTest {
        
    /*static Id createAccount() { 
        // Create Account
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account testAcct = new Account();
        testAcct.Name = 'Test Account1';
        testAcct.SAP_Account_Number__c = 'testId'; //Changing to SAP_Account_Number__c - 17-Nov-2016  -- Ashwin Dash
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
        Insert testAcct;   
        return testAcct.Id;
    }
    static testmethod void FormNotificationTest(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Id accId = createAccount();
        Id mainFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Main Product Definition Form').getRecordTypeId();
        Id spFormRecordTypeId = Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get(Label.Form_Type_SP).getRecordTypeId();
        List<Form_Management_System__c> fms = new List<Form_Management_System__c>();
        fms.add(new Form_Management_System__c(Customer_Name__c = accId, recordTypeID = mainFormRecordTypeId, Form_Name__c = 'some name', State_of_the_Form__c = 'Draft'));
        fms.add(new Form_Management_System__c(Customer_Name__c = accId, recordTypeID = spFormRecordTypeId, Form_Name__c = 'some name', State_of_the_Form__c = 'WaitingForReview'));
        
        FMSEmailTemplates.SendEditEmail = true;
        insert fms;
        
        fms[0].State_of_the_Form__c = 'Modified';
        update fms;
        
        fms[0].Form_Description__c = 'modified description';
        update fms;
        
        List<FMS_Subscription__c> sub = new List<FMS_Subscription__c>([select Id, Form_Deleted__c from FMS_Subscription__c where Form_Id__c =:fms[0].Id]);
        for(FMS_Subscription__c s:sub){
            s.Form_Deleted__c = true;
        }
        update sub;
        
        FMSEmailTemplates.sendEmailOnCancel(fms[0]);
        FMSEmailTemplates.sendEmailOnSave(fms[0], true, true);
        FMSEmailTemplates.sendEmailOnSave(fms[0], false, true);
        FMSEmailTemplates.sendEmailOnSave(fms[0], true, false);
        FMSEmailTemplates.sendEmailOnSave(fms[0], false, false);
        
        delete fms;
    }*/

    static testMethod void emailTemTest() {

        test.startTest();

        EmailTemplateGeneral tempExt = new EmailTemplateGeneral();
        tempExt.getSubject();
        tempExt.setSubject('Test');
        tempExt.getBody();
        tempExt.setBody('Testing');

        Test.stopTest();
    }
      
}