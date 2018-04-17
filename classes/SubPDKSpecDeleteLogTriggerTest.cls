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
private class SubPDKSpecDeleteLogTriggerTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTESTACC');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
      
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    
     private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c,ASIC_Business_Flag__c FROM Account Where Name =: AccountName];
                       
        return acct;
    }

   static testMethod void SubPDKSpecDeleteLogTriggerTest() {
        
        List<SObject> lstEnvVar = Test.loadData(Environment_Variable__c.sObjectType,'TestEnvironmentVariablesData');
        List<SObject> lstErrorCodes = Test.loadData(Error_Codes__c.sObjectType,'TestErrorCodesData');
        List<Account> listOfAcc = new List<Account>();
        List<Id> listOfAccIds = new List<Id>();
        List<Design_Spec__c> listOfDSpec = new List<Design_Spec__c>();
        Account acc = getAccount('MYTESTACC');
        //Account acc = FV_PDKTestDataTest.getAccount();
         listOfAcc.add(acc);
         listOfAccIds.add(acc.Id);
       
        ID pdk = FV_PDKTestDataTest.getPdk();
        //Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Specific Account Release', pdk, 'Demo B1');
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdk, 'Demo B1');
        PDK_Patch__c patch = FV_PDKTestDataTest.getPdkPatch(pdk);
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdk, 11111, '0.11UM');
        Design_Spec__c dSpec2 = FV_PDKTestDataTest.getDesignSpec('Release To white list', 'abc', 'Spec 2', pdk, 12121, '0.11UM');
        Design_Spec__c dSpec3 = FV_PDKTestDataTest.getPDKPatchSpec('Specific Account Release', 'abc', 'Spec 2', patch.Id, 88, '0.11UM');
        listOfDSpec.add(dSpec1);
        listOfDSpec.add(dSpec2);
        listOfDSpec.add(dSpec3);
        insert listOfDSpec;
        
        White_List__c wList = FV_PDKTestDataTest.getWhiteList(listOfDSpec[1].Id, acc.Id);
        List<Sub_PDK_Spec__c> listOfSPdkSpecs = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c sps1 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[0].Id,'5555');
        Sub_PDK_Spec__c sps2 = FV_PDKTestDataTest.getSubPdkSpec(sPdk.Id,listOfDSpec[1].Id,'11');
        listOfSPdkSpecs.add(sps1);
        listOfSPdkSpecs.add(sps2);
        
        insert listOfSPdkSpecs;
        
        Test.startTest();
            delete listOfSPdkSpecs;
        Test.stopTest();
    }
}