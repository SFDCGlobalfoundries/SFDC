@isTest
public class AccountAdditionalInfoControllerTest{
    
    @testSetup static void setupData(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static testMethod void testRun1(){
        
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         List<Contact> conList = new List<Contact>();
         List<Account_Address__c> addList = new List<Account_Address__c>();
         
         Contact conObj = new Contact();
         conObj.firstname = 'test';
         conObj.lastname = 'contact';
         conObj.email = 'testemail@gmail.com';
         conObj.Is_Primary_Sold_to_Customer__c = true;
         conObj.role__c = 'Sold To Customer,Primary Accounts Payable';
         conObj.accountId = accntObj.id;
         conList.add(conObj);
         
         Contact conObj1 = new Contact();
         conObj1.firstname = 'test1';
         conObj1.lastname = 'contact1';
         conObj1.email = 'testemail1@gmail.com';         
         conObj1.role__c = 'Sold To Customer,Primary Accounts Payable';
         conObj1.accountId = accntObj.id;
         conList.add(conObj1);
         
         insert conList;
         
         Account_Address__c addObj = new Account_Address__c();
         addObj.Account__c = accntObj.id;
         addObj.Nuclear_Fuel_Related_Activity__c = 'Yes';
         addObj.Country__c = 'Singapore';
         addObj.Type__c = 'Ship To Address';
         addObj.Is_Primary_Address__c = true;
         addList.add(addObj);
         
         Account_Address__c addObj1 = new Account_Address__c();
         addObj1.Account__c = accntObj.id;
         addObj1.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj1.Country__c = 'Singapore';
         addObj1.Type__c = 'Ship To Address';
         addObj1.Is_Primary_Address__c = true;
         addList.add(addObj1);
         
         Account_Address__c addObj2 = new Account_Address__c();
         addObj2.Account__c = accntObj.id;
         addObj2.Nuclear_Fuel_Related_Activity__c = 'No';
         addObj2.Country__c = 'Austria';
         addObj2.Type__c = 'Ship To Address';
         addObj2.Shipments_exported_from_USA__c = 'Yes';
         addObj2.Who_will_be_Exporter_of_Record__c = 'Customer';
         addObj2.Ship_to_VAT_Registration_Number__c = 1232;
         addObj2.Airport_IATA_code__c = 'sgtTest';         
         addList.add(addObj2);
         
         insert addList;
         
         PageReference pg = Page.AccountAdditionalInfo;
         pg.getParameters().put('id', accntObj.Id);
         Test.setCurrentPage(pg);
         
         test.startTest();
         AccountAdditionalInfoController addInfo = new AccountAdditionalInfoController();
         addInfo.createNewContact();
         
         addInfo.newCon = new Contact();
         addInfo.newCon.firstname = 'test11';
         addInfo.newCon.lastname = 'contact11';
         addInfo.newCon.email = 'testemail11@gmail.com';         
         addInfo.newCon.role__c = 'Sold To Customer,Primary Accounts Payable';
         addInfo.newCon.accountId = accntObj.id;
         addInfo.newCon.Is_Primary_Sold_to_Customer__c = true;
         
         addInfo.saveContact();
         addInfo.cancelContact();
         addInfo.save();        
         addInfo.cancel();
         addInfo.showAllNonSoldToContacts();
         addInfo.selectedConForSoldTo = String.valueOf(conList[0].id);
         addInfo.cancelSoldToAccSelectCreate();
         addInfo.updateExisConToSoldToCust();
         addInfo.createNewShipToAdd();
         addInfo.saveNewShipToAdd();
         addInfo.existingShipToId = String.valueOf(addList[0].id);
         addInfo.retrieveExistingShipToAdd();
         addInfo.updateExistingShipTo();
         addInfo.cancelExistingShipTo();
         addInfo.primaryAddress = String.valueOf(addList[0].id);
         addInfo.makePrimaryAddress();
         addInfo.primaryContact = String.valueOf(conList[1].id);
         addInfo.makePrimaryContact();
         addInfo.showAllContacts();
         addInfo.updateExisConToAccPayable();
         addInfo.newPrimaryAccPayForm();
         addInfo.cancelPrimaryAccPayCreation();
         addInfo.cancelPrimaryAccSelectCreate();
         addInfo.newPrimaryAccPayCreation();
         addInfo.cancelNewShipToAdd();
         addInfo.selectedContact = conObj.id;
         addInfo.editSoldToQuestionaire();
         addInfo.cancelSoldToQuestionaire();
         addInfo.saveSoldToQuestionaire();
         addInfo.existingShipToId = String.valueOf(addList[2].id);
         addInfo.setTaxExemptForNonUS();
         addInfo.newShipAdd = new Account_Address__c();
         addInfo.newShipAdd.Account__c = accntObj.id;
         addInfo.newShipAdd.Nuclear_Fuel_Related_Activity__c = 'No';
         addInfo.newShipAdd.Country__c = 'Austria';
         addInfo.newShipAdd.Type__c = 'Ship To Address';
         addInfo.newShipAdd.Shipments_exported_from_USA__c = 'Yes';
         addInfo.newShipAdd.Who_will_be_Exporter_of_Record__c = 'Customer';
         addInfo.setTaxExemptForNonUS();
         
         addInfo.renderCountryTaxDetails();
         addInfo.validateToDisplayAdditionalInfo();
                  
         AccountAdditionalInfoController addInfo1 = new AccountAdditionalInfoController();
         addInfo1.renderCountryTaxDetails();
         test.stopTest();         

    }
    
    static testMethod void testRun2(){
        
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         
         accntObj.Bill_To_Address_1_Change_Request__c = 'bill Address change';
         accntObj.Bill_To_Address_4_Change_Request__c = 'bill Address4 change';
         accntObj.Bill_To_Postal_Code_Change_Request__c = '23454';
         accntObj.Corporate_Address_1_Change_Request__c = 'corporate address change';
         accntObj.Corporate_Address_4_Change_Request__c = 'corporate address4 change';
         accntObj.Corporate_Postal_Zip_Code_Request_Change__c = '5434';
         accntObj.Fab_9_10__c = 'Yes';         
         accntObj.Approval_Request__c = 'Account Details Change'; 
         accntObj.Bill_To_Country__c = 'USA';
         accntObj.Bill_To_State__c = 'AK';
         update accntObj;
        
         List<Contact> conList = new List<Contact>();
         Contact conObj = new Contact();
         conObj.firstname = 'test';
         conObj.lastname = 'contact';
         conObj.email = 'testemail12345634353a@gmail.com';
         conObj.Is_Primary_Sold_to_Customer__c = true;
         conObj.role__c = 'Primary Accounts Payable';
         conObj.accountId = accntObj.id;
         conList.add(conObj);
         
         Contact conObj1 = new Contact();
         conObj1.firstname = 'test';
         conObj1.lastname = 'contact';
         conObj1.email = 'testemail12345634353abc@gmail.com';
         conObj1.Is_Primary_Sold_to_Customer__c = true;
         conObj1.role__c = 'Accounts Payable';
         conObj1.accountId = accntObj.id;
         conList.add(conObj1);
         
         insert conList;
         
         PageReference pg = Page.AccountAdditionalInfo;
         pg.getParameters().put('id', accntObj.Id);
         Test.setCurrentPage(pg);
         
         test.startTest();
         AccountAdditionalInfoController addInfo = new AccountAdditionalInfoController();
         addInfo.validateToDisplayAdditionalInfo(); 
         addInfo.renderCountryTaxDetails(); 
         addInfo.selectedConForAccPayable = String.valueOf(conList[1].id);
         addInfo.updateExisConToAccPayable();
         addInfo.newConAccPayable = new Contact();
         addInfo.newConAccPayable.firstname = 'test'; 
         addInfo.newConAccPayable.lastname = 'lastname';
         addInfo.newConAccPayable.email = 'testemailforclass@gmail.com';
         addInfo.newConAccPayable.phone = '090990';
         addInfo.newConAccPayable.accountId = accntObj.id;
         addInfo.newPrimaryAccPayCreation();
               
         Boolean changeShipToAddressOnly = addInfo.changeShipToAddressOnly;
         Boolean taxExcempt = addInfo.taxExcempt;
         Boolean accPayableContactExist = addInfo.accPayableContactExist;
         test.stopTest();
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}