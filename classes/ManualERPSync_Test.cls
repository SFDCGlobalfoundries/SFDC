/*
    Author: Ariz Solito
    Description: Apex test class for ManualERPSync
    History: 
        Asolito      04232013    - Apex code created
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Ashwini     05182015    - Updated code for refactoring of test class.
*/
@isTest
private class ManualERPSync_Test {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 007');            
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
     static testMethod void testClass(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Account acc= getAccount('Test Account 007');          
        
        String logId;
        for(IntegrationLog__c i: [SELECT id FROM IntegrationLog__c WHERE sfdc_row_id__c = :acc.id]){
            logId = i.id;
        }           
        
        PageReference pageRef = Page.ManualERPSync;
        Test.setCurrentPage(pageRef);
        
        //set the account and integrationLog id parameters
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.currentPage().getParameters().put('logid',logid);

        //initiate the callout
        ManualERPSync ctrl = new ManualERPSync();
        ctrl.init();                
    } 
    
    private static Account getAccount(string AccountName)
            {
                Account acc= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acc;
            }        
}