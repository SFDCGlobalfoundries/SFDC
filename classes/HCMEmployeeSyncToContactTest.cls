/*
    Author: Nino Bustillos
    Description: Test class for HCMEmployeeSyncToContact Apex Trigger
    History:
        Nbustillos  01242013    - code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        Ashwini     05152015    - Updated code for refactoring of test class.
 */
@isTest(SeeAllData=false)
private class HCMEmployeeSyncToContactTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void myUnitTest() {
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        
        // create GF account and add to environment variables
        Account gfAccount = getAccount('MYTEST ACCOUNT1');
        EnvironmentVariable.put('HCM Emp AccountId',gfAccount.Id);
        
        // create test HCM Employees
        List<HCM_Employee__c> hcmEmployees = new List<HCM_Employee__c>();
        Integer ctr = 0;
        do{
            hcmEmployees.add(new HCM_Employee__c(First_Name__c='Test', Last_Name__c='HCM Emp',
                                                 Email_Address__c='test' + ctr + '@test.com',Status__c='Active',
                                                 Employee_ID__c='RC1000'+ctr,Login_ID__c='RC1000'+ctr));
            ctr++;
        }while(ctr<5);
        insert hcmEmployees;
        
        // update HCM Employee Names
        ctr = 0;
        List<HCM_Employee__c> hcmEmployeesUpdate = new List<HCM_Employee__c>();
        Set<Id> hcmEmployeeIDs = new Set<Id>();
        Map<Id,String> hcmEmpFirstName = new Map<Id,String>();
        do{
            HCM_Employee__c hcmEmployee = hcmEmployees.get(ctr);
            hcmEmployee.First_Name__c = 'Test'+ctr;
            hcmEmployeesUpdate.add(hcmEmployee);
            ctr++;
            
            hcmEmpFirstName.put(hcmEmployee.Id,hcmEmployee.First_Name__c);
        }while(ctr<5);
        update hcmEmployeesUpdate;
        
        // retrieve contacts and check size
        List<Contact> equivalentContacts = [select firstname,HCM_Record_ID__c from Contact 
                                            where HCM_Record_ID__c in :hcmEmpFirstName.keySet()];
        system.assertEquals(5,equivalentContacts.size());
        
        // check updated firstname
        for(Contact contactRec : equivalentContacts){
            system.assertEquals(contactRec.firstname,hcmEmpFirstName.get(contactRec.HCM_Record_ID__c));
        }
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}