/*
@class: FMSSubscribeOtherUserCtrl_Test
@CreatedBy: Inshu Misra
@CreatedDate: 28 Sep, 2016
@Description: to test Subscribe other user functionality...#IM
@Modifications-
*
*/

@isTest(seealldata = false)
public class FMSSubscribeOtherUserCtrlTest {
    @testSetup
    static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();  
    }
    
    static testmethod void FormSubscribeOnBehalfTest1(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        PageReference pageRef = Page.FMSSubscribeOtherUserPage;            
        Test.setCurrentPage(pageRef);
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Test.StartTest();
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
            
            Id accId =  account1.id;
            
            Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
            fieldValueAccMap2.put('Customer_Name__c', accId);
            fieldValueAccMap2.put('Form_Name__c', 'test');
            FMSDataFactory obk = new FMSDataFactory();
            TriggerHandler.bypass('FMSTriggerHandler');
            Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);         
            
            ApexPages.currentPage().getParameters().put('id',fmObj.Id);
            
            FMSSubscribeOtherUserCtrl ctrl = new FMSSubscribeOtherUserCtrl();
            ctrl.subscribe.User_Name__c = UserInfo.getUserId();
            ctrl.formId = fmObj.Id;
            ctrl.baseUrl = '/'+fmObj .Id;
            
            ctrl.subscribeOnSubmit();
            ctrl.subscribeCancel();        
            
            System.assertNotEquals(account1,null);  
            Test.StopTest();
        }
    }
    static testmethod void FormSubscribeOnBehalfTest2(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            PageReference pageRef = Page.FMSSubscribeOtherUserPage;            
            Test.setCurrentPage(pageRef);
            
            Account accntObj1 = new Account(Sold_to_VAT_Registration_Number__c = 7944, name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill1', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria', Fab_9_10__c = 'Yes');
            insert accntObj1;
            
            
            Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1r11r', AccountId = accntObj1.Id, Email = 'con12@gf.com', Department__c = 'Design;Engineering', //5779
                                         is_portal_user_active__c = false);
            insert conObj;
            
            user us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
            Contact conobj1;
            Account accntObj;
            
            System.runAs(us) {
                
                accntObj = new Account(Sold_to_VAT_Registration_Number__c = 7944, name = 'acc', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria');
                insert accntObj;
                conobj1 = new Contact(FirstName = 'Mr', LastName = 'Testcon1rr', AccountId = accntObj.Id, Email = 'con1@gf.com', Department__c = 'Design;Engineering', is_portal_user_active__c = false);
                insert conObj1;
            }
            Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Customer Portal Profile'
                                     Limit 1];
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None'
                                   and Name like '%Customer%'
                                   Limit 1];
            User portalUser1 = new User(Username = 'portaluser1@testorg13.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Bruce3', Lastname = 'Wayne4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conobj1.Id, IsActive = true, ProfileId = portalProfile.Id);
            insert portalUser1;
            
            system.runAs(us) {
                
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
                fieldValueAccMap.put('Sold_to_VAT_Registration_Number__c', 7944);
                fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
                Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
                
                Id accId =  account1.id;
                Test.StartTest();
                
                Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
                fieldValueAccMap2.put('Customer_Name__c', accId);
                fieldValueAccMap2.put('Form_Name__c', 'test');       
                FMSDataFactory obk = new FMSDataFactory();
                TriggerHandler.bypass('FMSTriggerHandler');
                Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);         
                
                ApexPages.currentPage().getParameters().put('id',fmObj.Id);
                
                FMSSubscribeOtherUserCtrl ctrl = new FMSSubscribeOtherUserCtrl();
                ctrl.subscribe.User_Name__c = portalUser1.Id;
                ctrl.formId = fmObj.Id;
                ctrl.baseUrl = '/'+fmObj.Id;
                
                ctrl.subscribeOnSubmit();
                
                 String s1 = ctrl.myString;
                 String s2 = ctrl.internalUsername;
                
                System.assertNotEquals(account1,null);
                Test.StopTest();  
            }
            
        }
    }
    
    static testmethod void FormSubscribeOnBehalfTest3(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        PageReference pageRef = Page.FMSSubscribeOtherUserPage;            
        Test.setCurrentPage(pageRef);
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Test.StartTest(); 
            Account accntObj1 = new Account(Sold_to_VAT_Registration_Number__c = 7944, name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill1', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria', Fab_9_10__c = 'Yes');
            insert accntObj1;
            
            Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1r11r', AccountId = accntObj1.Id, Email = 'con12@gf.com', Department__c = 'Design;Engineering', //5779
                                         is_portal_user_active__c = false);
            insert conObj;
            
            user us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
            Contact conobj1;
            Account accntObj;
            
            System.runAs(us) {
                
                accntObj = new Account(Sold_to_VAT_Registration_Number__c = 7944, name = 'acc', Site_Department__c = 'Site1', Sub_Type__c = 'Direct', Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill', Bill_To_City__c = 'city1', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '', Corporate_City__c = 'city1', Corporate_Country__c = 'Austria');
                insert accntObj;
                conobj1 = new Contact(FirstName = 'Mr', LastName = 'Testcon1rr', AccountId = accntObj.Id, Email = 'con1@gf.com', Department__c = 'Design;Engineering', is_portal_user_active__c = false);
                insert conObj1;
            }
            Profile portalProfile = [SELECT Id, Name FROM Profile where Name = 'Customer Portal Profile'
                                     Limit 1];
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None'
                                   and Name like '%Customer%'
                                   Limit 1];
            User portalUser1 = new User(Username = 'portaluser1@testorg13.com', Alias = 'auser', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Bruce3', Lastname = 'Wayne4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = conobj1.Id, IsActive = true, ProfileId = portalProfile.Id);
            insert portalUser1;
            
            system.runAs(portalUser1) {
                
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
                fieldValueAccMap.put('Sold_to_VAT_Registration_Number__c', 7944);
                fieldValueAccMap.put('tech_geo_granted__c', '0.032UM;0.040UM;0.045UM;0.065UM;0.09UM;0.11UM;0.13UM;0.14UM;0.152UM;0.153UM;0.15UM;0.16UM;0.18UM;0.25UM;0.35UM;0.60UM;0.17UM');
                Account account1 = AccountDataFactory.createAccount(fieldValueAccMap);  
                
                Id accId =  account1.id;
                
                Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
                fieldValueAccMap2.put('Customer_Name__c', accId);
                fieldValueAccMap2.put('Form_Name__c', 'test');
                fieldValueAccMap2.put('Customer__c', account1.name);
                FMSDataFactory obk = new FMSDataFactory();
                TriggerHandler.bypass('FMSTriggerHandler');
                
                Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);         

                ApexPages.currentPage().getParameters().put('id',fmObj.Id);
                
                FMSSubscribeOtherUserCtrl ctrl = new FMSSubscribeOtherUserCtrl();
                ctrl.internalUserId = portalUser1.Id;
                ctrl.formId = fmObj.Id;
                ctrl.baseUrl = '/'+fmObj.Id;
                
                ctrl.subscribeOnSubmit();
                System.assertNotEquals(account1,null);  
                Test.StopTest(); 
            }
        }
    }
    
    static testmethod void FormSubscribeOnBehalfTest4(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        PageReference pageRef = Page.FMSSubscribeOtherUserPage;            
        Test.setCurrentPage(pageRef);
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Test.StartTest();
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
            
            Id accId =  account1.id;
            
            Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
            fieldValueAccMap2.put('Customer_Name__c', accId);
            fieldValueAccMap2.put('Form_Name__c', 'test');
            FMSDataFactory obk = new FMSDataFactory();
            TriggerHandler.bypass('FMSTriggerHandler');
            Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);         
            
            ApexPages.currentPage().getParameters().put('id',fmObj.Id);
            
            FMSSubscribeOtherUserCtrl ctrl = new FMSSubscribeOtherUserCtrl();
            ctrl.internalUserId = userinfo.getuserId();
            ctrl.subscribe.User_Name__c = UserInfo.getUserId();
            ctrl.formId = fmObj.Id;
            ctrl.baseUrl = '/'+fmObj .Id;            
            ctrl.subscribeOnSubmit();
            ctrl.subscribeCancel();        
            
            System.assertNotEquals(account1,null);  
            Test.StopTest();
        }
    }
    
    static testmethod void FormSubscribeOnBehalfTest5(){
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        
        PageReference pageRef = Page.FMSSubscribeOtherUserPage;            
        Test.setCurrentPage(pageRef);
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');
        System.runAs(thisUser){
            IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
            insert skipUser;
            Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Test.StartTest();
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
            
            Id accId =  account1.id;
            
            Map<String,Object> fieldValueAccMap2 = new Map<String,Object>();
            fieldValueAccMap2.put('Customer_Name__c', accId);
            fieldValueAccMap2.put('Form_Name__c', 'test');
            fieldValueAccMap2.put('Customer__c', account1.name);
            FMSDataFactory obk = new FMSDataFactory();
            TriggerHandler.bypass('FMSTriggerHandler');
            Form_Management_System__c  fmObj = FMSDataFactory.createFMSRecord(fieldValueAccMap2,FMSDataFactory.FormType.MAIN , true);         

            ApexPages.currentPage().getParameters().put('id',fmObj.Id);
            list<user> lstusers = [select id from user where profile.name='System Administrator' and id != :userinfo.getuserid() limit 1];
            FMSSubscribeOtherUserCtrl ctrl = new FMSSubscribeOtherUserCtrl();
            ctrl.internalUserId = userinfo.getuserId();
            if(!lstusers.isEmpty()) {
              ctrl.subscribe.User_Name__c = lstusers[0].Id;
            }
            //ctrl.subscribe.User_Name__c = UserInfo.getUserId();
            ctrl.formId = fmObj.Id;
            ctrl.baseUrl = '/'+fmObj .Id;            
            ctrl.subscribeOnSubmit();
            ctrl.subscribeCancel();        
            
            System.assertNotEquals(account1,null);  
            Test.StopTest();
        }
    }
}