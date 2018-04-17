/*    
    Author: 
    Description: 
    History:
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
        DBiswal     05182015    - Updated code for refactoring of test class.
        
*/
@isTest
public class OppHistoryControllerTest{
   
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
   
   static testMethod void doTestOppHistoryController(){
      // try{
      
        // Load Environment Variables   
        //DataUtilTest.loadEnvironmentVariables();
        
            test.startTest();
            Account acct= getAccount('testing501'); 
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();
          fieldValueMap.put('AccountId',acct.id);
          fieldValueMap.put('Name','Test Oppty');  
          fieldValueMap.put('StageName','1. Discovery');
          fieldValueMap.put('CloseDate',System.today().addYears(1));  
          fieldValueMap.put('Target_Process_Node__c','14XM');
          fieldValueMap.put('Market_Segment__c','Mobility');  
          fieldValueMap.put('Process_Platform__c','GF Baseline');
          fieldValueMap.put('Fab_Split__c',100);          
          fieldValueMap.put('Process_Geometry__c','0.055UM');  
          fieldValueMap.put('Process_Family__c','Generic / Nominal');                
          fieldValueMap.put('Marketing_Recommendation__c','Recommend for Approval');
           
          Opportunity oppty = OpportunityDataFactory.createOpportunity(fieldValueMap);
            
            Design_Win_Approval_History__c  desig = new Design_Win_Approval_History__c(Account__c=acct.id,opportunity__c=oppty.id);
            insert desig ;
            System.currentPageReference().getParameters().put('id',desig.id);
            ApexPages.StandardController Con = new ApexPages.StandardController(desig);
            
            OppHistory ObjHis = new OppHistory(Con);
            ObjHis.Back(); 
            Quarterly_Revenues_History__c QuaRevHis = new Quarterly_Revenues_History__c(Fiscal_Quarter__c='2013-Q2',Opportunity__c=oppty.id,Design_Win_Approval_History__c=desig.id );
            insert QuaRevHis ;
            ObjHis.getQuartRevRecords(); 
            test.stopTest();
      //  }
      //  catch(Exception exp)
      //  {
            
      //  }

    }
    
     private static Account getAccount(string AccountName)
            {
                Account acct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return acct;
            }  
}