/*
    Author: Anirban Roy
    Description: This is the test class for the GMPLOpportunityTrigger trigger.  
    History:
        ARoy        04242014    - code creation.
        Ashwini     04162015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(SeeAllData=false)
public class GMPLOpportunityTriggerTest {
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
    
    // Creation of an opportunity
    static Id createOpp(Id acctId){
      Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.09UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('X1st_Product_TO_Date__c',date.newinstance(2012, 12, 21));
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    // Creation of opportunities
    static List<Opportunity> createOppList(Id acctId){
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1; i<=2; i++){
          Map<String,Object> fieldValueMap = new Map<String,Object>();
          fieldValueMap.put('AccountId',acctId);
          fieldValueMap.put('Name','Test Opportunity'+i);  
          fieldValueMap.put('StageName','1. Discovery');
          fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
          fieldValueMap.put('Target_Process_Node__c','14XM');
          fieldValueMap.put('Market_Segment__c','Automotive');  
          fieldValueMap.put('Process_Platform__c','GF Baseline');
          fieldValueMap.put('Fab_Split__c',100);          
          fieldValueMap.put('Process_Geometry__c','0.09UM');  
          fieldValueMap.put('Process_Family__c','Generic / Nominal');
          fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
          fieldValueMap.put('X1st_Product_TO_Date__c',date.newinstance(2012, 12, 21));
          fieldValueMapList.add(fieldValueMap);
        }
        
        return OpportunityDataFactory.createOpportunities(fieldValueMapList,2);
        
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.status__c = 'Active';
        insert gmplBX009;
        return gmplBX009;
    }
    
    // Creation of GMPL/BX009
    static GMPL_BX009__c createGMPL1(){
        GMPL_BX009__c gmplBX009 = new GMPL_BX009__c();
        gmplBX009.First_Product_Test_Chip_Tape_out_Commi__c = date.newinstance(2012, 01, 01);
        gmplBX009.Fst_Product_Test_Chip_Tape_out_Expected__c = date.newinstance(2012, 01, 01);
        gmplBX009.status__c = 'Active';
        insert gmplBX009;
        return gmplBX009;
    }
    
    //Creation of GMPL Opportunity Junction
    static GMPL_Opportunity__c createGMPLOppJunction(Id gmplId, Id oppId){
        GMPL_Opportunity__c gmplOpp = new GMPL_Opportunity__c(GMPL_BX009__c = gmplId, Opportunity__c = oppId);
        insert gmplOpp;
        return gmplOpp;
    }
    
    
    static testMethod void createGMPLOppTriggerTest1(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        String oppId = GMPLOpportunityTriggerTest.createOpp(acctId);
        GMPL_BX009__c gmplBX009Obj = GMPLOpportunityTriggerTest.createGMPL();        
        
        Test.startTest();
        
        GMPL_Opportunity__c gmplOpp = GMPLOpportunityTriggerTest.createGMPLOppJunction(gmplBX009Obj.Id,oppId);
        
        
        Test.stopTest();
    }
    
    static testMethod void createGMPLOppTriggerTest2(){
        
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
        String acctId = getAccount('MYTEST ACCOUNT1').id;
        List<Opportunity> oppList = GMPLOpportunityTriggerTest.createOppList(acctId); 
        GMPL_BX009__c gmplBX009Obj = GMPLOpportunityTriggerTest.createGMPL1();
        GMPL_Opportunity__c gmplOpp = GMPLOpportunityTriggerTest.createGMPLOppJunction(gmplBX009Obj.Id,oppList[0].Id);       
        
        Test.startTest();
        
        gmplOpp.Opportunity__c = oppList[1].Id;
        update gmplOpp;
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}