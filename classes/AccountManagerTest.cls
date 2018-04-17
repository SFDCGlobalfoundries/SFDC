/*
    Author: Anirban Roy
    Description: This is the test class for AccountManager class.   
    History:
        ARoy    04152013    - code creation.
        ARoy    01242013    - modified to SeeAllData=false.    
        ZAmbat  04282014    - Updated code to SeeAllData=true as fix for SFDC test limitations.    
        Tlai    19052014    - Updated Territory value of Account 
*/
@isTest (SeeAllData=false)
private class AccountManagerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                                 
        fieldValueMap.put('site_department__c', 'test dept');                                           
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');                   
        fieldValueMap.put('Copy_Address__c', true);        
        fieldValueMap.put('Fab_9_10__c','No');
        AccountDataFactory.createAccount(fieldValueMap);
               
    }
    
    static testMethod void testCopyAddressOnInsert() {
        Account acc = getAccount('MYTEST ACCOUNT1');
        acc.Copy_Address__c = true;
        update acc;        
        List<Account> accLst = new List<Account>{acc};        
        AccountManager.copyAddress(accLst);
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Copy_Address__c, Stage__c, Corporate_Address_1__c, Bill_To_Address_1__c,
                        Corporate_Address_2__c, Bill_To_Address_2__c,
                        Corporate_Address_3__c, Bill_To_Address_3__c,
                        Corporate_Address_4__c, Bill_To_Address_4__c,
                        Bill_To_City__c, Corporate_City__c,
                        Bill_To_State__c, Corporate_State__c,
                        Bill_To_Country__c, Corporate_Country__c,
                        Bill_To_Postal_Zip_Code__c, Corporate_Postal_Zip_Code__c  FROM Account Where Name =: AccountName];
        
        return acct;
    }
}