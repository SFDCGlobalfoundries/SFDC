/*
Type Name: EndCustomerDuplicatePreventerTriggerTest TestClass
Author: IBM  
Created Date: 16th-DEC-2013
Reason: This Test Class is for the trigger EndCustomerDuplicatePreventerTrigger 
Change History:
Author: 
Modified Date: 
Reason: 
--
Ashwini     05142015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@istest(SeeAllData=false)

public with sharing class EndCustomerDuplicatePreventerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('name','TestClassAccount1');
        fieldValueMap.put('account_type__c','Customer');
        //recordtypeid = AccountRecordTypeInfo .get('Customer').getRecordTypeId(),
        fieldValueMap.put('stage__c','Unqualified');
        fieldValueMap.put('short_name__c','testrec1');
        fieldValueMap.put('sub_type__c','Direct');
        fieldValueMap.put('site_department__c','test dept');
        fieldValueMap.put('transaction_type__c','transactional');
        fieldValueMap.put('account_profile__c','Fabless - Emerging');
        fieldValueMap.put('Process_Tech_Interested__c','Mature (> 0.11um)');
        fieldValueMap.put('region__c','APJ');
        fieldValueMap.put('Sales_Territory__c','APJ-Japan');
        fieldValueMap.put('FE_Territory__c','APJ-FE-JAPAN');
        fieldValueMap.put('financial_territory__c','APJ-Japan');
        fieldValueMap.put('Copy_Address__c',true);
        fieldValueMap.put('Corporate_Address_1__c','50 water st');
        fieldValueMap.put('Corporate_City__c','Lee');
        fieldValueMap.put('Corporate_Country__c','Japan');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c','YES');
        fieldValueMap.put('total_employee__c',100);
        fieldValueMap.put('end_customer__c','people');
        fieldValueMap.put('Revenue_Potential__c','High Potential');
        fieldValueMap.put('Target_Account__c','Yes');
        
        AccountDataFactory.createAccount(fieldValueMap);
        Id resellerRecordTypeId = [Select Id from RecordType where Name='Reseller' and SObjectType='Account'].Id;
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('name','TestClassAccount2');
        fieldValueMap1.put('account_type__c','Reseller');
        fieldValueMap1.put('RecordTypeId',resellerRecordTypeId );
        //recordtypeid = AccountRecordTypeInfo .get('Customer').getRecordTypeId(),
        fieldValueMap1.put('stage__c','Unqualified');
        fieldValueMap1.put('short_name__c','testrec2');
        fieldValueMap1.put('sub_type__c','Direct');
        fieldValueMap1.put('site_department__c','test dept');
        fieldValueMap1.put('transaction_type__c','transactional');
        fieldValueMap1.put('account_profile__c','Fabless - Emerging');
        fieldValueMap1.put('Process_Tech_Interested__c','Mature (> 0.11um)');
        fieldValueMap1.put('region__c','APJ');
        fieldValueMap1.put('Sales_Territory__c','APJ-Japan');
        fieldValueMap1.put('FE_Territory__c','APJ-FE-JAPAN');
        fieldValueMap1.put('financial_territory__c','APJ-Japan');
        fieldValueMap1.put('Copy_Address__c',true);
        fieldValueMap1.put('Corporate_Address_1__c','50 water st');
        fieldValueMap1.put('Corporate_City__c','Lee');
        fieldValueMap1.put('Corporate_Country__c','Japan');
        fieldValueMap1.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap1.put('bill_to_location__c','YES');
        fieldValueMap1.put('total_employee__c',100);
        fieldValueMap1.put('end_customer__c','people');
        fieldValueMap1.put('Revenue_Potential__c','High Potential');
        fieldValueMap1.put('Target_Account__c','Yes');
        
        AccountDataFactory.createAccount(fieldValueMap1);
        
        Map<String,Object> fieldValueMap2 = new Map<String,Object>();
        fieldValueMap2.put('RecordTypeId',resellerRecordTypeId );
        fieldValueMap2.put('name','TestClassAccount3');
        fieldValueMap2.put('account_type__c','Reseller');
        //recordtypeid = AccountRecordTypeInfo .get('Customer').getRecordTypeId(),
        fieldValueMap2.put('stage__c','Unqualified');
        fieldValueMap2.put('short_name__c','testrec3');
        fieldValueMap2.put('sub_type__c','Direct');
        fieldValueMap2.put('site_department__c','test dept');
        fieldValueMap2.put('transaction_type__c','transactional');
        fieldValueMap2.put('account_profile__c','Fabless - Emerging');
        fieldValueMap2.put('Process_Tech_Interested__c','Mature (> 0.11um)');
        fieldValueMap2.put('region__c','APJ');
        fieldValueMap2.put('Sales_Territory__c','APJ-Japan');
        fieldValueMap2.put('FE_Territory__c','APJ-FE-JAPAN');
        fieldValueMap2.put('financial_territory__c','APJ-Japan');
        fieldValueMap2.put('Copy_Address__c',true);
        fieldValueMap2.put('Corporate_Address_1__c','50 water st');
        fieldValueMap2.put('Corporate_City__c','Lee');
        fieldValueMap2.put('Corporate_Country__c','Japan');
        fieldValueMap2.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap2.put('bill_to_location__c','YES');
        fieldValueMap2.put('total_employee__c',100);
        fieldValueMap2.put('end_customer__c','people');
        fieldValueMap2.put('Revenue_Potential__c','High Potential');
        fieldValueMap2.put('Target_Account__c','Yes');
        
        AccountDataFactory.createAccount(fieldValueMap2);        
        
    }
    static testMethod void testClass(){
    //DataUtilTest.loadEnvironmentVariables();
     List<Account> updateAcc = new List<Account>();
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    Account acc1 = getAccount('TestClassAccount1');     
    Account acc2 = getAccount('TestClassAccount2');    
    Account acc3 = getAccount('TestClassAccount3');                
    
    acc2.account_type__c = 'Reseller';
    update acc2; 
     system.debug('>>>>>>>>>>>>>acc2:'+acc2);
        End_Customer__c ec1=new End_Customer__c(Account__c=acc1.Id, Assigned_Reseller__c=acc2.Id, Is_Primary__c=false);
        insert ec1;
//        Integer count = 0;
//        Map<String,Integer> accountResellerIdMap = new Map<String,Integer>();
//        accountResellerIdMap.put(acc1.Id+'|'+acc2.Id,count+1);
        
     system.debug('>>>>>>>>>>>>>acc3:'+acc3);
        
        End_Customer__c ec2=new End_Customer__c(Account__c=acc1.Id, Assigned_Reseller__c=acc3.Id, Is_Primary__c=false);
        insert ec2;
        
        //ec1=new End_Customer__c(Account__c=acc1.Id, Assigned_Reseller__c=acc2.Id, Is_Primary__c=true);
        
        update ec1; 
        
        List<End_Customer__c> ecLst=new List<End_Customer__c>();
        ecLst.add(ec1);
        ecLst.add(ec2);
        
        update ecLst;
// Condition Starts Now

        List<Account> accExistingObj = [Select Id, name From Account where name=:acc1.name or name=:acc2.name or name=:acc3.name];
        System.assertEquals(3, accExistingObj.size());



        
        
        
     }
     
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}