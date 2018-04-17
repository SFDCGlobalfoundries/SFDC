/*
    Author: Zymark Ambat
    Description: This test class covers the AccountTeamProxyDeleteTrigger trigger.
    History: 
        ZAmbat      04222013    - Code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false
                                - Added startTest() and stopTest() methods. 
        Ashwini     05132015    - Updated code for refactoring of test class.
*/ 

@isTest(SeeAllData=false)
private class AccountTeamProxyDeleteTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 1 SFDC');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'TESTrec2');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');
        fieldValueMap.put('region__c', 'APJ');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Corporate_Address_1__c', 'Corporate Address 1');            
        fieldValueMap.put('Corporate_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
            
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void runTest() {
        
        Test.startTest();
        
        // Get Account
        Account a = getAccount('Test Account 1 SFDC');
        
        // Delete Account Team Proxy
        List<Account_Team_Proxy__c> listATP = [
            SELECT      Id
            FROM        Account_Team_Proxy__c
            WHERE       Account__c = :a.Id
        ];
        
        System.assertEquals(listATP.size(), 1);
        
        if (listATP.size() > 0) {
            Delete listATP;
        }
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
}