/*
    Author:  Yash Kumar
    Description: Creates Opportunity Process test class 
    History:
        Ykumar      12052013    - code creation.
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        DBiswal     05182015    - Updated code for refactoring of test class.
*/

@isTest(SeeAllData=false)
private class OpportunityProcessTest {

@testSetup static void testdata() {
    DataUtilTest.loadEnvironmentVariables();
    
    Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', 'testing501');
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

static Account createAccount1() {
    
         Account testAcct = getAccount('testing501');         
        return testAcct;
    }
    
    static Opportunity createOpportunity1(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity 1');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.13UM');  
        fieldValueMap.put('Process_Family__c','Low Power / Ultra Low Leakage');        
        fieldValueMap.put('Fab_Assignment_1__c','FAB 6');
         
        return OpportunityDataFactory.createOpportunity(fieldValueMap);
        
    }   
     static Opportunity_Program__c createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity 1';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        
        return testOpptyProgram;
    }
     static testMethod void OpportunityProc() {
      test.startTest();
        
            OpportunityProcess__c opptypr= new OpportunityProcess__c();
            opptypr.Process_ID__c='6-L1313-15C-1533ZZ-LPA-0PB';
            opptypr.FAB__c='FAB 6';
            opptypr.Geometry__c='0.13UM';
            opptypr.Process_Family__c ='Low Power / Ultra Low Leakage';
            insert opptypr;
            
            Account a =OpportunityProcessTest.createAccount1();
            String testAcctId1 = a.Id;
            Opportunity testOppty1 = OpportunityProcessTest.createOpportunity1(testAcctId1);
            
            Opportunity_Program__c opptyPgm =  createOpportunityProgram(testAcctId1 , testOppty1.id);
            
            testOppty1.Design_Win_Review_Status__c= 'Won';
            testOppty1.Name = 'Test Opportunity 22';
            testOppty1.Date_Design_Win_Approved__c=System.today();
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = 'FAB 7';
            testOppty1.Process_Geometry__c='0.13UM';
            testOppty1.Process_Family__c='Low Power / Ultra Low Leakage';
            
            
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = 'FAB 6';
            testOppty1.Fab_Assignment_2__c = null;
            
            Update testOppty1;
            
            testOppty1.Fab_Assignment_1__c = null;
            testOppty1.Fab_Assignment_2__c = 'FAB 6';
            
            Update testOppty1;
            
           
            
            list<Apttus_Proposal__Proposal__c>lstApttus= new list<Apttus_Proposal__Proposal__c>();
    
            lstApttus=[Select id,Apttus_Proposal__Opportunity__c,APTPS_Primary__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c ='0069000000CNsjh' and APTPS_Primary__c=true and Apttus_Proposal__Approval_Stage__c='Process Flow Accepted'];
            list<Opportunity>lstOppty= new list<Opportunity>();
            lstOppty=[select id,Description from opportunity where id='0069000000CNsjhAAD'];
            if(lstOppty.size()>0)
            {
                lstOppty[0].Description ='test';
                update lstOppty;
            }

     }
  private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
            
              
   

}