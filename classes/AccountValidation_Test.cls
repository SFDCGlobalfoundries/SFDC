/*
    Author: Zymark Ambat
    Description: This serves as the test class for the AccountValidation Class.
    History: 
        ZAmbat      05222013    - Code creation.
*/

@isTest(SeeAllData=false)
private class AccountValidation_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'TEST rec');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'TESTrec2');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'APJ');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void runTest() {
        // Account Record Type
        RecordType rt = [
            SELECT      Id
            FROM        RecordType
            WHERE       SObjectType = 'Account'
                        AND Name = 'Customer'
        ];
        
        Account a = getAccount('TEST rec');
        
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(a.Id);
        
        // Validate
        AccountValidation.validateContacts(accountIds);
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}