@isTest
public class CustomerSetupFormSAPTest{
    
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
         Test.startTest();
         List<Contact> conList = new List<Contact>();
         
         Contact conObj = new Contact();
         conObj.firstname = 'test';
         conObj.lastname = 'contact';
         conObj.email = 'testemail@gmail.com';
         conObj.Is_Primary_Sold_to_Customer__c = true;
         conObj.role__c = 'Sold To Customer';
         conObj.accountId = accntObj.id;
         conObj.Is_Portal_User_Active__c = true;
         conList.add(conObj);
         
         Contact conObj1 = new Contact();
         conObj1.firstname = 'test1';
         conObj1.lastname = 'contact1';
         conObj1.email = 'testemail1@gmail.com';
         conObj1.Is_Primary_Sold_to_Customer__c = true;
         conObj1.role__c = 'Primary Account Admin';
         conObj1.accountId = accntObj.id;
         conObj1.Is_Portal_User_Active__c = true;
         conList.add(conObj1);
         
         Contact conObj2 = new Contact();
         conObj2.firstname = 'test2';
         conObj2.lastname = 'contact2';
         conObj2.email = 'testemail2@gmail.com';
         conObj2.Is_Primary_Sold_to_Customer__c = true;
         conObj2.role__c = 'Customers My Device Admin';
         conObj2.accountId = accntObj.id;
         conObj2.Is_Portal_User_Active__c = true;
         conList.add(conObj2);
         
         Contact conObj3 = new Contact();
         conObj3.firstname = 'Namandeep';
         conObj3.lastname = 'Singh';
         conObj3.email = userinfo.getuseremail();         
         conObj3.accountId = accntObj.id;         
         conList.add(conObj3);
         
         insert conList;
         
         Account_Address__c addObj = new Account_Address__c();
         addObj.Account__c = accntObj.id;
         addObj.Nuclear_Fuel_Related_Activity__c = 'Yes';
         addObj.Country__c = 'Singapore';
         addObj.Type__c = 'Ship To Address';
         addObj.Is_Primary_Address__c = true;
         insert addObj;
         
         system.assertEquals(addObj.Account__c,accntObj.id);
         PageReference pg = Page.CustomerSetupFormSAP;
         pg.getParameters().put('id', accntObj.Id);
         Test.setCurrentPage(pg); 
         
         CustomerSetupFormSAP custForm = new CustomerSetupFormSAP();  
         custForm.savePDF(); 
         String keyContact = custForm.keyContact;
         String keyContactPhone = custForm.keyContactPhone;
         Boolean billAddressSame = custForm.billAddressSame;
         Boolean shipAddressSame = custForm.shipAddressSame;                     
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}