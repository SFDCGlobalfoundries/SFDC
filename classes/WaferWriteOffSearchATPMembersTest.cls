/*
    Author: Zymark Ambat
    Description: This Class serves as the test class for WaferWriteOffSearchATPMembers.
    History: 
        ZAmbat      03162015    - Code creation.
        NJain       04272015    - SeeAddData made False
*/

@isTest(SeeAllData=false)
private class WaferWriteOffSearchATPMembersTest {
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
         
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 009');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);

        string accountId = WaferWriteOffSearchATPMembersTest.createAccount();
        Wafer_Write_Off__c wwo = WaferWriteOffSearchATPMembersTest.createWaferWriteOff(accountId);
        WaferWriteOffSearchATPMembersTest.createATPAccountManagers(accountId);
    }
    
    static Id createAccount() {
        Account testAcct= getAccount('Test Account 009');
        return testAcct.id;
        }
    
    static Wafer_Write_Off__c createWaferWriteOff(string accountId) {
        Wafer_Write_Off__c w = new Wafer_Write_Off__c();
        w.Customer_Name__c = accountId;
        w.Fab__c = 'Fab 2';
        w.Reason__c = 'Others';
        w.Other_Reason__c = 'test';
        w.Total_Value__c = 100;
        w.Total_Provisioned__c = 50;
        w.Status__c = 'Draft';
        
        insert w;
        
        return w;
    }
    
    static void createATPAccountManagers(string accountId) {
        List<User> listUser = [
            SELECT    Id
            FROM      User
            WHERE     Profile.Name LIKE 'GF%'
                      AND IsActive = true
            LIMIT 3
        ];
        
        List<Account_Team_Proxy__c> listATP = new List<Account_Team_Proxy__c>();
        for (integer i=0; i<3; i++) {
            Account_Team_Proxy__c a = new Account_Team_Proxy__c();
            a.User__c = listUser[i].Id;
            a.Account__c = accountId;
            a.Team_Role__c = 'Account Manager';
            a.Account_Access__c = 'Read/Write';
            a.Case_Access__c = 'Read/Write';
            
            listATP.add(a);
        }
        
        insert listATP;
    }
    
    static testMethod void testWaferWriteOffSearchATPMembers() {
        Wafer_Write_Off__c wwo = [select id,Customer_Name__c from Wafer_Write_Off__c limit 1];
        test.startTest();
            WaferWriteOffSearchATPMembers.retrieveAccountManager(new List<Wafer_Write_Off__c>{wwo});
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
        {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
        }
}