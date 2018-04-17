/*
 @class: FMSSPReminderTest
 @CreatedBy: Anirban Roy
 @CreatedDate: 20 July, 2017
 @Description: to test the FMSSPReminderTest Class
 @Modifications-
 *
 */

@isTest
public class FMSSPReminderTest{
    @testSetup
    static void setUpMethod(){
        DataUtilTest.loadEnvironmentVariables();
    }
        
    static Account createAccount() {
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();
        fieldValueAccMap.put('Name', 'TEST rec');            
        fieldValueAccMap.put('stage__c', 'Unqualified');        
        fieldValueAccMap.put('sub_type__c', 'Direct');
        fieldValueAccMap.put('site_department__c', 'test dept1');          
        fieldValueAccMap.put('transaction_type__c', 'transactional');                          
        fieldValueAccMap.put('region__c', 'APJ');        
        fieldValueAccMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Corporate_City__c', 'Lee');                
        fieldValueAccMap.put('Corporate_Country__c', 'Japan');
        fieldValueAccMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueAccMap.put('Bill_To_City__c', 'Test City');            
        fieldValueAccMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueAccMap.put('recordtypeid', rt); 
        fieldValueAccMap.put('short_name__c', 'TESTrec');
        fieldValueAccMap.put('Customer_Number__c', '10101');
        fieldValueAccMap.put('account_profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueAccMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueAccMap.put('financial_territory__c', 'Japan Korea');
        fieldValueAccMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueAccMap.put('bill_to_location__c', 'YES');
        fieldValueAccMap.put('total_employee__c', 100);
        fieldValueAccMap.put('end_customer__c', 'people');
        fieldValueAccMap.put('Revenue_Potential__c', 'High Potential');
        fieldValueAccMap.put('Target_Account__c', 'Yes');
        fieldValueAccMap.put('Preferred_Invoice_Delivery_Option__c', 'Electronic');
        fieldValueAccMap.put('Fab_9_10__c', 'Yes'); 
        fieldValueAccMap.put('SAP_Account_Number__c', '006104');
        fieldValueAccMap.put('Customer_Category__c', 'TFA');
        fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
        Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);
        return account1;
    }
    
    static User createPortalUser(Id conObjId, Id profileId) {

        User portalUser = new User(Username = 'con12@gf.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Mr', Lastname = 'Testcon1r11r', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conObjId, IsActive = true, ProfileId = profileId);
        insert portalUser;

        return portalUser;
    }
    
    static Contact createContact(Id accountObjId){

        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1r11r', AccountId = accountObjId, Email = 'con12@gf.com', Department__c = 'Design;Engineering');      
        insert conobj;
        return conObj;
    }
    
    static Form_Management_System__c mainFromCreate(Account accObj, Id conobjId){
        
        Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Chip_Interconnect__c' => 'Wirebond', 'DesignSubmission__c' => 'Single Chip (one GDS)','PackageRequirement__c' =>'IBM Custom Design', 'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'Draft','SelAppId__c' => conobjId+';', 'PackageType__c' => 'BCC', 'Packaging_Services__c' => 'Yes', 'PurchaseOrder__c' => 'Yes', 'ProductName__c' => 'test product', 'ProductRevision__c' => 'rev1', 'ReleaseProcessFlow__c' => 'process 1', 'InputMethod__c' => 'method 1', 'SubmissionType__c' => 'Final Submission', 'ProjectedTapeout__c' => system.today(), 'Technology__c' => 'tech 1', 'TestLevels__c' => 'level 1', 'Customer__c' => accObj.Name};
        
        Form_Management_System__c  fmsMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.MAIN , true);

        return fmsMainForm;
    }

    static Form_Management_System__c spFormCreate(Account accObj, Id mainformId,Id conobjId){

        Map<String,Object> fieldValueAccMap = new Map<String,Object>{'Customer_Name__c' => accObj.Id, 'Form_Name__c' => 'some name', 'State_of_the_Form__c' => 'WaitingForReview','SelAppId__c' => conobjId+';','Customer__c' => accObj.Name, 'Main_Form_Id__c' => mainFormId};
        Form_Management_System__c  spMainForm = FMSDataFactory.createFMSRecord(fieldValueAccMap,FMSDataFactory.FormType.SP , true);
        //Form_Management_System__c spMainForm1 = new Form_Management_System__c(Customer_Name__c = accObj.Id, Form_Name__c = 'some name', State_of_the_Form__c = 'WaitingForReview',Customer__c = accObj.Name, Main_Form_Id__c = mainFormId, recordtypeid=Schema.SObjectType.Form_Management_System__c.getRecordTypeInfosByName().get('Step Plan Approval (SP)').getRecordTypeId()); 
        //insert spMainForm1;
        return spMainForm;
    }
    
    static testmethod void FormNotificationTest(){
        User us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        User admin = DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        Account accObj;
        Contact conobj;
        Form_Management_System__c spFormCreate1;
        System.runAs(admin){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = admin.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            System.runAs(us) {
                accObj = createAccount();
                conobj = createContact(accObj.Id);
            }
            Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Overage Customer Portal Admin' Limit 1];

            User portalUser = createPortalUser(conobj.Id, portalProfile.Id);
        } 
        Test.StartTest();
        System.runAs(admin){
            Form_Management_System__c mainForm = mainFromCreate(accObj, conobj.Id);
            spFormCreate1 = spFormCreate(accObj, mainForm.Id,admin.Id);
        }                  
            FMSSPReminder spRem= new FMSSPReminder();
            database.executebatch(spRem);
            Form_Management_System__c fms = [Select Id, Form_Name__c,State_of_the_Form__c from Form_Management_System__c where id =: spFormCreate1.id];
            System.assertEquals('WaitingForReview',fms.State_of_the_Form__c);
        Test.stopTest(); 
    }
}