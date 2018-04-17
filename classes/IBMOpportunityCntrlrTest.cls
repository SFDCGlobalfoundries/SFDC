/*
  Author: Ariz Solito
  Description: Test class for controller class IBMOpportunityCntrlr
  History:
    ASolito         03172015    - code creation.
*/
@isTest(SeeAllData=false)
public class IBMOpportunityCntrlrTest  {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    //Method will test IBM oppty
    static testMethod void testClassIBMOppty(){                        
        RecordType recType = [SELECT id 
                                FROM RecordType 
                                WHERE Name='IBM Account' 
                                LIMIT 1];
                                
        Account acc = getAccount('MYTEST ACCOUNT1');      
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.50UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
       
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
                     
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        IBMOpportunityCntrlr ctrl = new IBMOpportunityCntrlr(sc);
        
        PageReference pageRef = Page.IBMOpportunity;        
        Test.setCurrentPage(pageRef);  
               
        //call the instance methods        
        ctrl.redirect();                                        
    }   
    
    //Method will test non IBM oppty    
    static testMethod void testClassNonIBMOppty(){                        
        RecordType recType = [SELECT id 
                                FROM RecordType 
                                WHERE Name='Customer' 
                                LIMIT 1];
                                
        Account acc = getAccount('MYTEST ACCOUNT1');      
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.50UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
       
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        IBMOpportunityCntrlr ctrl = new IBMOpportunityCntrlr(sc);
        
        PageReference pageRef = Page.IBMOpportunity;        
        Test.setCurrentPage(pageRef);  
        
               
        //call the instance methods        
        //view redirect
        ctrl.redirect(); 
        
        ApexPages.currentPage().getParameters().put('retURL',opp.id);
        //edit redirect
        ctrl.redirect();      
        
                                               
    } 
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}