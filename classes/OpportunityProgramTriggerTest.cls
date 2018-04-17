/*
    Author: Pradosh Samal
    Description: This serves as the test class for the OpportunityProgramTrigger Trigger.
    History: 
        Pradosh Samal  02-12-2018 - Code creation.
*/
@isTest(SeeAllData=false)
public class OpportunityProgramTriggerTest {
    
    @testSetup static void testData(){
        
        DataUtilTest.loadEnvironmentVariables();
        
        Account accountObj = createAccount();
    }
    
    static Account createAccount() {
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'TEST ACCOUNT-0001');
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
        
        return AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static Account_Team_Proxy__c createAccountTeamProxy(Id accountId) {        
             
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();       
        atp.Account__c = accountId ;      
        User thisUser= DeviceChecklistTestDataUtils.createUserWithDCAdmin('System Administrator');      
        atp.User__c = thisUser.Id ;        
        atp.Team_Role__c = 'Account Manager';      
        atp.Account_Access__c = 'Read/Write';      
        atp.Opportunity_Access__c = 'Read/Write';      
                    
        insert atp;        
                
        return atp;        
    }
    
    static Opportunity createOpportunity(Id accountId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',accountId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('X1st_Product_TO_Date__c',Date.Today().addDays(15));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.028UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('Fab_Assignment_1__c','FAB 3');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }
    
    static testMethod void testRun1() {
        Test.startTest();
        
        Account accountObj = [SELECT Id, Name FROM Account WHERE Name = 'TEST ACCOUNT-0001'];
        Account_Team_Proxy__c atp = createAccountTeamProxy(accountObj.Id);
        Opportunity oppty = createOpportunity(accountObj.Id);
        System.assertEquals('First Source', oppty.Opportunity_Sourcing_Type__c);
        
        Test.stopTest();
    }
}