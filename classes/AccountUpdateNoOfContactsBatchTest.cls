/*
    Author: Zymark Ambat
    Description: This serves as the Test class for AccountUpdateNoOfContactsBatch and AccountUpdateNoOfContactsBatchScheduler.
    History: 
        ZAmbat      05282014    - Code creation.
        Ashwini     03262015    - Refactoring test class.
        
*/
@isTest(SeeAllData=false)
public class AccountUpdateNoOfContactsBatchTest {
    @testSetup static void methodName() {
        DataUtilTest.loadEnvironmentVariables();
                 
        Map<String,Object> fieldValueMap = new Map<String,Object>();                    
        fieldValueMap.put('short_name__c', 'ZAIHTESTACCT');
        fieldValueMap.put('Name', 'TESTACCTZAIH12345');
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
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));            
                    
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static string createContact(string testAccountId) {
        Contact testContact = new Contact();
        testContact.AccountId = testAccountId;
        testContact.FirstName = 'test';
        testContact.LastName = 'test';
        testContact.Email = 'test@test.com';
        
        insert testContact;
        
        return testContact.Id;
    }
    
    static testMethod void testAccountUpdateNoOfContactsBatch() {
        string testAcctId = getAccount('TESTACCTZAIH12345').id;
        string testContactId = AccountUpdateNoOfContactsBatchTest.createContact(testAcctId);
        
        test.startTest();
            Database.executeBatch(new AccountUpdateNoOfContactsBatch(), 1);
        test.stopTest();
    }
    
    static testMethod void testAccountUpdateNoOfContactsBatchScheduler() {
        test.startTest();
            AccountUpdateNoOfContactsBatchScheduler d = new AccountUpdateNoOfContactsBatchScheduler();
            String s = '0 0 23 * * ?';
            system.schedule('AccountUpdateNoOfContactsBatchScheduler123', s, d);
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    } 
}