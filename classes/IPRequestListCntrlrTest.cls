/*
    Author: Ariz Solito
    Description: Test class for IPRequestListCntrlr
    History: 
        Asolito     07042014    - Code creation.
        Ashwini     05152015    - Updated code for refactoring of test class.
*/
@isTest(SeeAllData=false)
public with sharing class IPRequestListCntrlrTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
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
    
    static testMethod void testClass(){
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables(); 
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        IP_Request__c req = new IP_Request__c(
            customer_account_name__c = acc.id,
            status__c = 'New'
        );
        insert req;
        
                         
        test.startTest();
        
        PageReference pageRef = Page.IPRequestList;       
        Test.setCurrentPageReference(pageRef);
        
        IPRequestListCntrlr ctrl = new IPRequestListCntrlr();                                  
        
        test.stopTest();                
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}