/*
    Author: Zymark Ambat
    Description: This serves as the test class for VisitationSetRegionHead.
    History: 
        ZAmbat      08252014    - Code creation.
*/
@isTest(SeeAllData=false)
public class VisitationSetRegionHeadTest {

    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 100');            
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
    }

    static Account createAccount() {
        // Create Account
          Account testAcct= getAccount('Test Account 100');        
        return testAcct;
    }
    
    static Visitation_Record__c createVisitationRecord(Id testAccountId) {
        Visitation_Record__c v = new Visitation_Record__c();
        v.Account__c = testAccountId;
        v.Visit_Name__c = 'test visit 123';
        v.Visit_Type__c = 'Visit from Customer';
        v.Visit_Location__c = 'Singapore';
        v.Visitation_Host__c = [SELECT Id FROM User WHERE IsActive=true LIMIT 1].Id;
        v.Start_Date__c = date.today();
        v.End_Date__c = date.today();
        v.NDA_In_Effect_YN__c = 'No';
        v.Purpose__c = 'Opportunity Management';
        
        insert v;
        
        return v;
    }
    
    static testMethod void testVisitationSetRegionHead() {
        test.startTest();
            Account testAccount = VisitationSetRegionHeadTest.createAccount();
            Visitation_Record__c testVisitationRecord = VisitationSetRegionHeadTest.createVisitationRecord(testAccount.Id);
            testAccount.Region_Head_lk__c = [SELECT Id FROM User WHERE isActive=true LIMIT 1].Id;
            update testAccount;
        test.stopTest();
    }
    
     private static Account getAccount(string AccountName)
        {
        Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return testAcct;
        }  
}