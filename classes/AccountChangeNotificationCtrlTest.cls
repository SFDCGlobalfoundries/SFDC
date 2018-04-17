/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountChangeNotificationCtrlTest {
	
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
         List<AccountChangeFieldsConfig__c> fieldList = new List<AccountChangeFieldsConfig__c>();
        fieldList.add(new AccountChangeFieldsConfig__c(name='Account Name',FieldApiName__c = 'TextName'));
        fieldList.add(new AccountChangeFieldsConfig__c(name='Parent Account',FieldApiName__c = 'Parent'));
        fieldList.add(new AccountChangeFieldsConfig__c(name='Region',FieldApiName__c = 'Region__c'));
        Database.insert(fieldList,false);
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');  
        fieldValueMap.put('Account_Type__c', 'Customer');                           
        fieldValueMap.put('sub_type__c', 'Indirect');        
        fieldValueMap.put('site_department__c', 'IT');  
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('recordtypeid',EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        AccountDataFactory.createAccount(fieldValueMap);
        
    }

    static testMethod void myUnitTest() {
         test.starttest();
          Account acc = getAccount('MYTEST ACCOUNT1');
        
        acc.Name='test2';
        update acc;
         AccountChangeNotificationCtrl myClass = new AccountChangeNotificationCtrl ();
         myclass.sendEmail('');
         myclass.nullCheck('null');
         myclass.nullcheck('abc');
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
     	 myclass.mthdDummy();
         test.stopTest();
    }
    
    private static Account getAccount(string AccountName){
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}