/*
  Author: Anirban Roy
  Description: This is the test class for the GDSTrigger apex trigger.
  History:
    ARoy        10272014    - code creation.
    ARoy        05282015    - code modified to create proposal                           
*/

@isTest
public class GDSTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Account_Manager__c', userinfo.getuserid());        
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
    
    static testMethod void gdsApprovalTest(){
        
        Id acctId = getAccount('MYTEST ACCOUNT1').id;
        Apttus_Proposal__Proposal__c rec = createProposal(acctId, Null, Null, Null, Null); 
                                            /*[SELECT id 
                                              FROM Apttus_Proposal__Proposal__c
                                              WHERE mask_set__c <> null
                                              AND Apttus_Proposal__Account__r.Short_Name__c <> null
                                              LIMIT 1];*/
                                              
        GDS__c gds = new GDS__c(
            Quote_Proposal__c = rec.id,
            status__c = 'Draft'
        ); 
        insert gds;
        
        test.startTest();
        
        // Updating the status to Translating
        gds.Status__c = 'Translating';
        update gds;
        
        // Updating the status to Rejected
        gds.Status__c = 'Rejected';
        update gds;
        
        test.stopTest();
    }
    
    //Static method to create proposal test record
    static Apttus_Proposal__Proposal__c createProposal(Id accId, Id oppId, Id devId, Id tmrmId, String szMaskSet){
        //Setup the test records required to create the Proposal test record
        RecordType recType = [Select Id
                                From RecordType 
                               Where Name='Draft' And
                                     SobjectType = 'Apttus_Proposal__Proposal__c'];
        
        //Create a proposal from Device
        Apttus_Proposal__Proposal__c proposal = 
                    new Apttus_Proposal__Proposal__c(Apttus_Proposal__Description__c = 'Test Proposal Description ...',
                                                     Device__c = devId,
                                                     /*Mask_Set__c = szMaskSet, changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                                     Mask_Set_Long__c = szMaskSet,
                                                     Apttus_Proposal__Opportunity__c = oppId,
                                                     Apttus_Proposal__Account__c = accId,
                                                     RecordTypeId = recType.Id);
        
        insert proposal;
        return proposal;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}