/*
    Author: Anirban Roy
    Description: This is the test class for the PPETeamATPController class.  
    History:
        ARoy        04072014    - code creation.
        DBiswal     04152015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class PPETeamATPControllerTest {
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing901');
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
    
    // Creation of an Account
    static Id createAccount(){
        Account acct= getAccount('testing901'); 
        return acct.Id;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(Id accountId){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.Account__c = accountId;       
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of PPE Team Member from Account Team Proxy test
    static testMethod void createPPETeamFromATPTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = PPETeamATPControllerTest.createAccount();
        GMPL_BX009__c gmplObj = PPETeamATPControllerTest.createGMPL(acctId);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acctId);
        ApexPages.currentPage().getParameters().put('gmplbx009Id',gmplObj.Id);
        
        PPETeamATPController ppeTeamATP = new PPETeamATPController();
        ppeTeamATP.atpWrapperList[0].ppeRoleSelected = 'Team Member';
        ppeTeamATP.atpWrapperList[0].accessLevelSelected = 'Read/Write';
        ppeTeamATP.atpWrapperList[0].selected = true;
        
        PageReference pgr = ppeTeamATP.save();
        system.assert(pgr.getUrl().contains(gmplObj.Id));
        
        Test.stopTest();
        
    }
    
    // Creation of PPE Team Member from Account Team Proxy test without selection of record
    static testMethod void createPPETeamATPWthoutSelTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = PPETeamATPControllerTest.createAccount();
        GMPL_BX009__c gmplObj = PPETeamATPControllerTest.createGMPL(acctId);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acctId);
        ApexPages.currentPage().getParameters().put('gmplbx009Id',gmplObj.Id);
        
        PPETeamATPController ppeTeamATP = new PPETeamATPController();
        ppeTeamATP.atpWrapperList[0].ppeRoleSelected = 'Team Member';
        ppeTeamATP.atpWrapperList[0].accessLevelSelected = 'Read/Write';
        
        PageReference pgr = ppeTeamATP.save();
        system.assert(pgr==null);
        
        Test.stopTest();
        
    }
    
    // Creation of PPE Team Member from Account Team Proxy error and cancellation test
    static testMethod void createPPETeamATPErrCancelTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = PPETeamATPControllerTest.createAccount();
        GMPL_BX009__c gmplObj = PPETeamATPControllerTest.createGMPL(acctId);
        
        Test.startTest();
               
        ApexPages.currentPage().getParameters().put('gmplbx009Id',gmplObj.Id);
        
        PPETeamATPController ppeTeamATP = new PPETeamATPController();
        
        ApexPages.currentPage().getParameters().put('accId',acctId);
        ppeTeamATP = new PPETeamATPController();
        
        ppeTeamATP.atpWrapperList[0].selected = true;
        
        PageReference pgr = ppeTeamATP.save();
        system.assert(pgr==null);
        
        pgr = ppeTeamATP.cancel();
        system.assert(pgr.getUrl().contains(gmplObj.Id));
        
        
        Test.stopTest();
        
    }
    
    // Creation of PPE Team Member from Account Team Proxy access level change test
    static testMethod void createPPETeamChgAccLevelTest(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = PPETeamATPControllerTest.createAccount();
        GMPL_BX009__c gmplObj = PPETeamATPControllerTest.createGMPL(acctId);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('accId',acctId);
        ApexPages.currentPage().getParameters().put('gmplbx009Id',gmplObj.Id);
        
        PPETeamATPController ppeTeamATP = new PPETeamATPController();
        ppeTeamATP.atpWrapperList[0].ppeRoleSelected = 'Team Member';
        ppeTeamATP.changeAccessLevel();
        
        ppeTeamATP.atpWrapperList[0].ppeRoleSelected = 'SQE BX009';
        ppeTeamATP.changeAccessLevel();
        
        
        Test.stopTest();
        
    }
    
   private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }   
    
}