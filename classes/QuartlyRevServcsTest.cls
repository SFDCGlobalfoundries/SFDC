/*
    Author: Anirban Roy
    Description: This is the test class for the QuarterlyRevenueService webservice class.  
    History:
        ARoy    03052013    - code creation.
*/
@isTest(SeeAllData=false)
private class QuartlyRevServcsTest {

    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
         List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMap.put('Fab_9_10__c','no');
           
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    //Creating dummy account
    static Id createAccount(){
         Account acc= getAccount('MYTEST ACCOUNT2');
        
        return acc.Id;
    }
    //Creating dummy opportunity
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
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Opportunity_Sourcing_Type__c','First Source');  
        fieldValueMap.put('X1st_Product_Production_Date__c',date.newInstance(2013,3,5));
        fieldValueMap.put('Years_of_Production__c',6);
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    //testMethod to test the reset functionality
    static testMethod void resetQtrRevTest(){
                
        test.startTest();
        
        String acctId = QuartlyRevServcsTest.createAccount();
        String oppId = QuartlyRevServcsTest.createOpp(acctId);
        test.stopTest();
        //Query to find the Quarterly Revenue
        List<Quarterly_Revenue_Object__c> qtrRevList = [select ASP__c,Volume__c from Quarterly_Revenue_Object__c 
                                    where Opportunity__c = :oppId];
        
        for(Quarterly_Revenue_Object__c qtrRev : qtrRevList){
            qtrRev.ASP__c = 10;
            qtrRev.Volume__c = 10;
        }       
        
        update qtrRevList;
        
        String status = QuarterlyRevenueService.resetForecast(oppId);
        system.assertEquals(status,'OK');              

        
    }
 private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }     
}