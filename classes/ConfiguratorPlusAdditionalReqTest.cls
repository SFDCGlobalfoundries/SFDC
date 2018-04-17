/**
*   Class:  ConfiguratorPlusAdditionalReqTest 
*-----------------------------------------------------------------------------------------------------------------------------------
*   Author: Ashwini Basavaraj
*   Description: Test Class for Configurator Plus AdditionalReq
*
*   History:
*       Ashwini     11262015     - code creation.
*     
**/

@isTest(seeAllData = False)
public class ConfiguratorPlusAdditionalReqTest {
    @testSetup
     static void testDataSetup(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
     }
    
    public static testMethod void testMyController() {        
        
        //Create account record
        Account testAcct = getAccount('MYTEST ACCOUNT1');        
        
        //Create Configurator Plus record
        Configurator_Plus_account_list__c accs= new Configurator_Plus_account_list__c();
        accs.Acct_short_name__c= 'mk';
        accs.Name='one';
        insert accs;
        Apttus_Proposal__Proposal__c configplus =new Apttus_Proposal__Proposal__c();
        configplus.Apttus_Proposal__Proposal_Name__c ='test';
        configplus.Apttus_Proposal__Account__c=testAcct.id;
        insert configplus;
        test.starttest();
            PageReference pageRef = new PageReference ('/apex/ConfiguratorPlusAdditionalReq?Id=' + configplus.id);
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController abc = new ApexPages.StandardController(configplus);
            ConfiguratorPlusAdditionalReqController controller = new ConfiguratorPlusAdditionalReqController(abc);
            Pagereference pgr = controller.saveform();
            system.assert(pgr.getUrl().contains(configplus.id)); 
        test.stoptest();
 }
 
 private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}