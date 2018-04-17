/*
    Author: Mallika Seth
    Description: This is the test class for the PairingTableTrigger.  
    History:
        MSeth     1122015    - code creation.
*/
@isTest(SeeAllData=false)
private class PairingTableTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing701');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));       
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Id createAccount() {
        // Create Account
        Account testAcct = getAccount('testing701'); 
        return testAcct.Id;
    }
 
    static Id createMaskSetTtitle(){
        Mask_Set_Title__c mst = new Mask_Set_Title__c();
        mst.Name = 'MSTTRT';
        mst.Reticle_Type__c = 'Multi Layer Reticle (MLR)';
        insert mst;
        return mst.Id;
    }
    
    
  
    
    static testMethod void PairingTableTriggerTest1() {
                
        string acctId = PairingTableTriggerTest.createAccount();
        String MSTId = PairingTableTriggerTest.createMaskSetTtitle();
                
        test.startTest();
            // Create Pairing Table
           Pairing_Table__c PT = new Pairing_Table__c();
            PT.Name = 'TESTPT';
            PT.Mask_Set_Title_Text__c ='MSTTRT';
            PT.PRF_Number__c = 'MPRF_123';
            insert PT;
            
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
   
}