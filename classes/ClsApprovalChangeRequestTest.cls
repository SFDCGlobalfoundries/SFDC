/*
Type Name: ClsApprovalChangeRequestTest
Author: Cognizant
Created Date: 6-may-2013
Reason: This is the Test class for class ClsApprovalChangeRequest. 
Change History:
Author: 
Modified Date: 
Reason: 
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
    Ashwini     05132015    - Updated code for refactoring of test class.
*/
@isTest
public class ClsApprovalChangeRequestTest
{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTest ACCOUNT1'); 
        fieldValueMap.put('Short_Name__c', 'testAcco');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void checkIschangeRequestUpdate()
    {
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        test.startTest();

        accntObj.Is_change_request_update__c=True;
        
        accntObj.Publicly_Listed_Change_Request__c='Yes';
        accntObj.Stock_Ticker_Change_Request__c='stock';
        accntObj.Corporate_Address_1_Change_Request__c='corp'  ; 
        accntObj.Bill_To_Address_1_Change_Request__c='New Bill1';  
        update accntObj ;
        
        accntObj.Publicly_Listed__c =accntObj.Publicly_Listed_Change_Request__c;
        accntObj.Stock_Ticker__c=accntObj.Stock_Ticker_Change_Request__c;
        accntObj.Corporate_Address_1__c=accntObj.Corporate_Address_1_Change_Request__c;
        
        accntObj.Bill_To_Address_1__c=accntObj.Bill_To_Address_1_Change_Request__c;
        update accntObj ;
        System.assertEquals( accntObj.Publicly_Listed__c,accntObj.Publicly_Listed_Change_Request__c);
        System.assertEquals( accntObj.Stock_Ticker__c,accntObj.Stock_Ticker_Change_Request__c);
        System.assertEquals( accntObj.Corporate_Address_1__c,accntObj.Corporate_Address_1_Change_Request__c);
        System.assertEquals( accntObj.Bill_To_Address_1__c,accntObj.Bill_To_Address_1_Change_Request__c);
        test.stopTest();
    }    
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
 }