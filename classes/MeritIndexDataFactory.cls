/*
    Author: Sandesh Singh
    Description: This is the test class data factory for Merit Index.   
    History:
        Sandesh 04/10/2017    - code creation.
*/
@isTest
public class MeritIndexDataFactory {
	
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
      }
    
     public static Account createSingleAccount() {
        AcctRegHeadMappingTgrHandler.bypassAcctTrigger = true;
        Map<String,Object> mapOfAccount = new Map<String,Object>();
        mapOfAccount.put('Name','Fudan');
        mapOfAccount.put('Short_Name__c','Fudan'); 
        Account acc = AccountDataFactory.createAccount(mapOfAccount);
        system.debug('----accTemp----'+acc);
        return acc;
    }
    
    private static Account getAccount()
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id FROM Account Where Id =:createSingleAccount().Id];
        return acct;
    }

    /* Method to create Merit Test Data record Dynamically*/
    public static List<Merit__c> createMeritss(List<Map<String,Object>> fieldValueMaps,Integer numRecs)    
    {	
       
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numRecs)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of accounts you want to create.');
        }
        
        List<Merit__c> meritList = new List<Merit__c>();
        Account acc = getAccount();
        
        for(Integer i=0;i<numRecs;i++)                    
        {
            Merit__c merit = new Merit__c(Name='TestMerit' + i+1,
					                      Account__c= acc.Id
					                      );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    merit.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            meritList.add(merit);    
        }
        
        insert meritList;
        
        return meritList;
    }
    
    /* Method to create one Account Test Data record Dynamically*/
    public static Merit__c createMerit(Map<String,Object> fieldValueMap)
    {	
        List<Account> listAcc = new List<Account>();
        listAcc = [Select Id, Name From Account LIMIT 1];
        Account acc = new Account();
        Merit__c merit;
        if(listAcc.isEmpty()){
    		acc = getAccount();
            // Create Account with default data that is required, this will handle cases where required fields are not set
            merit = new Merit__c(Name='TestMerit',Account__c= acc.Id);
            
            for(String fieldName: fieldValueMap.keySet())
            {
                merit.put(fieldName, fieldValueMap.get(fieldName));        
            }
            
            insert merit;
        }
        return merit;
    }   

}