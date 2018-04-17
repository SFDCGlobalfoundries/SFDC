/*
    Author: Zymark Ambat
    Description: This serves as the test class for the DeviceCopyController Class.
    History: 
        ZAmbat      07232013    - Code creation.
        ZAmbat      10102013    - updated code - removed asserts.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
                                - Updated annotation to SeeAllData=false 
        Ashwini     03232015    - Refactoring test class.
*/

@isTest(SeeAllData=false)
private class AccountHierarchyGeneration_Test { 
           
    @testSetup static void methodName() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
            fieldValueMap.put('short_name__c', 'TESTACCT'+z);
            fieldValueMap.put('Name', 'TESTACCTZAIH12345'+z);
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'Test Department');          
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
            fieldValueMapsList.add(fieldValueMap);
        }
            
        AccountDataFactory.createAccounts(fieldValueMapsList,3);
    }
    
    static testMethod void runTest1() {
        
        // Get Accounts
        List<Account> listAccount = getAccounts();
        
        test.startTest();
        
        // Update Account 2
        listAccount[2].ParentId = listAccount[1].Id;
        update listAccount[2];
        
        test.stopTest();
    }
    
    static testMethod void runTest2() {
    
        // Get Accounts
        List<Account> listAccount = getAccounts();
        
        test.startTest();
        
        // Update Account 2
        listAccount[2].ParentId = listAccount[1].Id;
        update listAccount[2];
        
        listAccount[1].ParentId = listAccount[0].Id;
        update listAccount[1];
        
        test.stopTest();
    }
    
    static testMethod void runTest3() {
        
        // Get Accounts
        List<Account> listAccount = getAccounts();
        
        test.startTest();
        
        // Update Account 2
        listAccount[2].ParentId = listAccount[1].Id;
        update listAccount[2];
        
        listAccount[1].ParentId = listAccount[0].Id;
        update listAccount[1];
        
        listAccount[1].ParentId = null;
        update listAccount[1];
        
        test.stopTest(); 
    }
    
    private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id, ParentId FROM Account];
        
        System.assertEquals(accList.size(), 3);
        
        return accList;
    }
}