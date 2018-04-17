/*
    Author: Zymark Ambat
    Description: This serves as the test class for the AccountOrganizationUnitPopulate Class.
    History: 
        ZAmbat      04152013    - Code creation.
*/

@isTest(SeeAllData=false)
private class AccountOrganizationUnitPopulate_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account SFDC TEST');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'SFDCTEST1');
        fieldValueMap.put('sub_type__c', 'FAB 3');
        fieldValueMap.put('End_Customer__c', 'TESTENDCUSTOMER');
        fieldValueMap.put('site_department__c', 'Test Department');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'APJ');
        fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
        fieldValueMap.put('financial_territory__c', 'Japan Korea');
        fieldValueMap.put('FE_Territory__c', 'APJ-FE-JAPAN');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
        fieldValueMap.put('Corporate_Country__c', 'Japan');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 1000);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','Test Country');
        fieldValueMap.put('Market_Segment__c','Mobility');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void testAccountOrganizationUnitPopulate() {
        
        Account a = getAccount('Test Account SFDC TEST');
        
        // Submit Organization Unit change
        a.Stage__c = 'Authorized';
        a.Approval_Request__c = 'Account Details Change';
        a.New_Organization_Unit_Request__c = 'GF Singapore Pte Ltd OU';
        
        AccountOrganizationUnitPopulate.validateOrganizationUnit(a);
        
        // Submit new change
        a.Organization_Unit__c = 'GF Singapore Pte Ltd OU';
        a.Approval_Request__c = 'Account Details Change';
        
        AccountOrganizationUnitPopulate.validateOrganizationUnit(a);
        
        a.Organization_Unit__c = AccountOrganizationUnitPopulate.populateOrganizationUnit(null, 'test');
        a.Organization_Unit__c = AccountOrganizationUnitPopulate.populateOrganizationUnit('test1', 'test2');
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Stage__c, Approval_Request__c, New_Organization_Unit_Request__c, Organization_Unit__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}