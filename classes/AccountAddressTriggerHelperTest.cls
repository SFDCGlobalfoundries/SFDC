@isTest
public class AccountAddressTriggerHelperTest{
    
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
    
     static testMethod void testRun(){
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         List<Account_Address__c> addList = new List<Account_Address__c>();
         
         Account_Address__c accAddress = new Account_Address__c();
         accAddress.location__c = 'loc1';
         accAddress.Address_1__c = 'address1';
         accAddress.Country__c = 'India';
         accAddress.Postal_Zip_Code__c = '560034';
         accAddress.account__c = accntObj.id;
         accAddress.type__c = 'Bill To Address';
         addList.add(accAddress);
         
         Account_Address__c accAddress2 = new Account_Address__c();
         accAddress2.location__c = 'loc12';
         accAddress2.Address_1__c = 'address12';
         accAddress2.Country__c = 'Singapore';
         accAddress2.Postal_Zip_Code__c = '560035'; 
         accAddress2.account__c = accntObj.id;        
         accAddress2.type__c = 'Bill To Address';
         addList.add(accAddress2);
         
         insert addList;
         
         try{
              accAddress2.location__c = 'loc1';
              accAddress2.Address_1__c = 'address1';
              accAddress2.Country__c = 'India';
              accAddress2.Postal_Zip_Code__c = '560034';
              update accAddress2;
         }
         catch(Exception e){
         }
         
     }
     
     static testMethod void testRun2(){
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         List<Account_Address__c> addList = new List<Account_Address__c>();
         
         Account_Address__c accAddress = new Account_Address__c();
         accAddress.location__c = 'loc1';
         accAddress.Address_1__c = 'address1';
         accAddress.Country__c = 'India';
         accAddress.Postal_Zip_Code__c = '560034';
         accAddress.account__c = accntObj.id;
         accAddress.type__c = 'Bill To Address';
         addList.add(accAddress);
         
         Account_Address__c accAddress2 = new Account_Address__c();
         accAddress2.location__c = 'loc12';
         accAddress2.Address_1__c = 'address12';
         accAddress2.Country__c = 'Singapore';
         accAddress2.Postal_Zip_Code__c = '560035'; 
         accAddress2.account__c = accntObj.id;        
         accAddress2.type__c = 'Bill To Address';
         addList.add(accAddress2);
         
         insert addList;
         List<Account_Address__c> accList = [Select id,Postal_Zip_Code__c,Bill_To_Attention__c,status__c ,New_Status__c from Account_Address__c where account__c =: accntObj.id];
         
         //accList[0].Bill_To_Attention__c = 'new attntn';
         accList[0].status__c = 'Approved';
         accList[0].New_Status__c= 'Approved';
        
         update accList[0];
         
         
     }
     static testMethod void testRun3(){
         Account accntObj = getAccount('MYTEST ACCOUNT1');
         List<Account_Address__c> addList = new List<Account_Address__c>();
         
         Account_Address__c accAddress = new Account_Address__c();
         accAddress.location__c = 'loc1';
         accAddress.Address_1__c = 'address1';
         accAddress.Country__c = 'India';
         accAddress.Postal_Zip_Code__c = '560034';
         accAddress.account__c = accntObj.id;
         accAddress.type__c = 'Bill To Address';
         addList.add(accAddress);
         
         Account_Address__c accAddress2 = new Account_Address__c();
         accAddress2.location__c = 'loc12';
         accAddress2.Address_1__c = 'address12';
         accAddress2.Country__c = 'Singapore';
         accAddress2.Postal_Zip_Code__c = '560035'; 
         accAddress2.account__c = accntObj.id;        
         accAddress2.type__c = 'Bill To Address';
         addList.add(accAddress2);
         
         insert addList;
         List<Account_Address__c> accList1 = [Select id,Postal_Zip_Code__c,New_Bill_To_Attention__c,Status__c,New_Status__c,New_State__c,New_Country__c,New_Postal_Zip_Code__c ,New_Location__c,New_City__c,New_Address_Line_4__c,New_Address_Line_1__c,New_Address_Line_2__c,New_Address_Line_3__c,Account_Address_Change_request__c,Bill_To_Attention__c from Account_Address__c where account__c =: accntObj.id];
        
         accList1[0].Status__c= 'Approved';
         Update accList1[0];
         accList1[0].Account_Address_Change_request__c = True;
         accList1[0].New_Address_Line_1__c='Bill1111'; 
         accList1[0].New_Address_Line_2__c='Bill1111'; 
         accList1[0].New_Address_Line_3__c='Bill1111'; 
         accList1[0].New_Address_Line_4__c='Bill1111'; 
         accList1[0].New_Bill_To_Attention__c='Bill1111'; 
         accList1[0].New_City__c='Bill1111'; 
         accList1[0].New_Location__c='Bill1111'; 
         accList1[0].New_Postal_Zip_Code__c ='Bill1111'; 
         accList1[0].New_Country__c='Pakistan'; 
         accList1[0].New_State__c='Punjab'; 
         accList1[0].name = 'new name';         
         accList1[0].New_Status__c= 'Approved';
         try{
         Update accList1[0];
         }
         catch(Exception e){}
         
     }
     
     private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}