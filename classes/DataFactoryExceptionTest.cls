// DataFactoryException Test Class

@isTest
private class DataFactoryExceptionTest
{
    @testSetup static void methodName() {
        DataUtilTest.loadEnvironmentVariables();
    }

    // Throw Exception when creating accounts
    @isTest static void createAccountsDataException() {
        List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
            fieldValueMap.put('short_name__c', 'ZAIHTESTACCT'+z);
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
        
        Test.startTest();
        try
        {
            AccountDataFactory.createAccounts(fieldValueMapsList,2);  
        }
        catch (DataFactoryException dfe)
        {
            System.assertEquals(dfe.getTypeName(), 'DataFactoryException');
            System.assertEquals(dfe.getDataExceptionMessage(), 'Data Exception Message');
        } 
        Test.stopTest(); 
    }
}