/**
* Author: CY Goh
* Project: Test Class Automation  
* Description: This data factory class will be used to create Account data in different Test classes
**/

@isTest
public class AccountDataFactory
{
    /* Method to create Account Test Data record Dynamically*/
    public static List<Account> createAccounts(List<Map<String,Object>> fieldValueMaps,Integer numAccts)    
    {
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numAccts)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of accounts you want to create.');
        }
        
        List<Account> accountList = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++)                    
        {
            Account acc = new Account(Name='TestAccount' + i+1,
                      Site_Department__c='IT',
                      Sub_Type__c='Indirect',
                      Transaction_Type__c='Non-Transactional',
                      Region__c='US',
                      Corporate_Address_1__c = 'Test Address 1',
                      Corporate_City__c = 'Test City',
                      Corporate_Country__c = 'Test Country',
                      Fab_9_10__c = 'No',
                      Preferred_Invoice_Delivery_Option__c = 'Electronic',
                      Invoice_Delivery_Electronic__c = 'B2B',
					  Customer_Category__c = 'TFA',
                      Sold_to_VAT_Registration_Number__c = 123401234                
                      );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    acc.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            accountList.add(acc);    
        }
        
        insert accountList;
        
        return accountList;
    }
          
    /* Method to create one Account Test Data record Dynamically*/
    public static Account createAccount(Map<String,Object> fieldValueMap)
    {
        // Create Account with default data that is required, this will handle cases where required fields are not set
        Account acc = new Account(Name='TestAccount1',
                      Site_Department__c='IT',
                      Sub_Type__c='Indirect',
                      Transaction_Type__c='Non-Transactional',
                      Region__c='US',
                      Corporate_Address_1__c = 'Test Address 1',
                      Corporate_City__c = 'Test City',
                      Corporate_Country__c = 'Test Country' ,
                      Fab_9_10__c = 'No',
                      Preferred_Invoice_Delivery_Option__c = 'Electronic',
                      Invoice_Delivery_Electronic__c = 'B2B',
					  Customer_Category__c = 'TFA',
                      Sold_to_VAT_Registration_Number__c = 123401234                 
                      );          
              
        for(String fieldName: fieldValueMap.keySet())
        {
            acc.put(fieldName, fieldValueMap.get(fieldName));        
        }

        insert acc;
            
        return acc;
    }   
}