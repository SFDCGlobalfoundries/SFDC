/*
    Author: Zymark Ambat
    Description: This test class covers the DeletedRecordsManager class.
    History: 
        ZAmbat      04222013    - Code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false
                                - Added startTest() and stopTest() methods. 
         Ashwini     05142015    - Updated code for refactoring of test class.                       
*/ 

@isTest(SeeAllData=false)
private class DeletedRecordsManagerTest {
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
    static testMethod void runTest() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        
        // Create Account
        Account a = getAccount('MYTEST ACCOUNT1');
        
        // Create Lot Prefix
        Lot_Prefix__c lp = new Lot_Prefix__c();
        lp.Account__c = a.Id;
        lp.Name = 'LPRA1';
        lp.Fab__c = 'FAB 3';
        
        Insert lp;
        
        List<Lot_Prefix__c> listLotPrefix = new List<Lot_Prefix__c>(); 
        listLotPrefix.add(lp);
        
        // Call DeleteRecordsManager
        DeletedRecordsManager.insertRecords(listLotPrefix, 'Lot Prefix');
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}