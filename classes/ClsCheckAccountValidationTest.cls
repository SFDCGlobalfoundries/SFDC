/*
    Author: Yash Kumar
    Description: Test class for ClsCheckAccountValidation
    Created Date:15022013 
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        ZAmbat      04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.
        Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData = false)
public class ClsCheckAccountValidationTest{
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Copy_Address__c', false);          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Is_Lead_Source__c', true);          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }   
   
   static testMethod void doTestClsCheckAccountValidation(){
    
    test.startTest();           
        
    Account acc121 = getAccount('MYTEST ACCOUNT1'); 
   acc121.Bill_To_Location__c='abc1';
   acc121.Is_Lead_Source__c=false;
   ClsCheckAccountValidation.Flag=false;
   Map<Id,Account> accMap = new Map<Id,Account>();
   accMap.put(acc121.Id,acc121);
   ClsCheckAccountValidation.checkUpdateAccountValidation(accMap,false,true);
   ClsCheckAccountValidation.checkUpdateAccountValidation(accMap,true,false);
   try{
       update acc121;
   }catch(Exception exp){
       //system.assert(exp.getMessage().contains(Error_Codes__c.getInstance('Bill_To_Address_Required').message__c));
   }
   test.stopTest();
       

    } 
   
   private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}