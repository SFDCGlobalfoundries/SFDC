@isTest
public class BillToAddressTest{

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
        fieldValueMap.put('Corporate_Postal_Zip_Code__c','560034');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
     static testMethod void testRun(){
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         
         ApexPages.StandardController sc = new ApexPages.StandardController(accntObj);        
         DisplayAccountAddressController display = new DisplayAccountAddressController(sc);
         
         Account_Address__c accAddress = new Account_Address__c();
         accAddress.location__c = 'loc1';
         accAddress.Address_1__c = 'address1';
         accAddress.Country__c = 'India';
         accAddress.Postal_Zip_Code__c = '560034';
         accAddress.account__c = accntObj.id;
         accAddress.type__c = 'Bill To Address';
         
         Account_Address__c accAddress2 = new Account_Address__c();
         accAddress2.location__c = 'loc1';
         accAddress2.Address_1__c = 'address1';
         accAddress2.Country__c = 'India';
         accAddress2.Postal_Zip_Code__c = '560034';         
         accAddress2.type__c = 'Bill To Address';
         
         Test.setCurrentPageReference(new PageReference('Page.MultipleBillToAddress'));
         System.currentPageReference().getParameters().put('accId', accntObj.id);
         ApexPages.StandardController sc1 = new ApexPages.StandardController(accAddress);        
         MultipleBillToAddressController multipleAdd = new MultipleBillToAddressController(sc1);         
         multipleAdd.saveBillTo();
                  
         ApexPages.StandardController sc3 = new ApexPages.StandardController(accAddress2);        
         MultipleBillToAddressController multipleAdd2 = new MultipleBillToAddressController(sc3);         
         multipleAdd2.saveBillTo();
         
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}