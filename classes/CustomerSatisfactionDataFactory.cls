/*
    Author: Sandesh Singh
    Description: This is the test class data factory for Customer Satisfaction.   
    History:
        Sandesh 10/10/2017    - code creation.
*/
@isTest(SeeAllData=False)
public class CustomerSatisfactionDataFactory {
    
    private static Merit__c getMerit(){
        return [Select Id, Name From Merit__c Limit 1];
    }
    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
      }
        
      public static List<Customer_Satsfaction__c> createCustomerSatisfactions(List<Map<String,Object>> fieldValueMaps,Integer numRecs) {
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap1.put('Delivery_G__c', 10);
        MeritIndexDataFactory.createMerit(fieldValueMap1);
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numRecs)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of Customer Satisfaction you want to create.');
        }
        
        List<Customer_Satsfaction__c> customerSatList = new List<Customer_Satsfaction__c>();
        Merit__c merit = getMerit();
        
        for(Integer i=0;i<numRecs;i++)                    
        {
            Customer_Satsfaction__c customerSat = new Customer_Satsfaction__c(Name='Fudan Q1 2016' + i+1,
                                          Merit_Index_for_customers__c= merit.Id,
                                          Quarter_New__c = 'Q1',
                                          Score_Year__c = '2016'
                                          );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    customerSat.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            customerSatList.add(customerSat);    
        }
        insert customerSatList;
        system.debug('---customerSat--'+customerSatList);
        return customerSatList;
        
    }
    
    
    /* Method to create one Merit Test Data record Dynamically*/
    public static Customer_Satsfaction__c createCustomerSatisfaction(Map<String,Object> fieldValueMap)
    {   
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap1.put('Delivery_G__c', 10);
        MeritIndexDataFactory.createMerit(fieldValueMap1);
        Merit__c merit = getMerit();
        // Create Account with default data that is required, this will handle cases where required fields are not set
       Customer_Satsfaction__c customerSat = new Customer_Satsfaction__c(Name='FudanTest',
                                          Merit_Index_for_customers__c= merit.Id,
                                          Quarter_New__c = 'Q1',
                                          Score_Year__c = '2016'
                                          );    
        if(null !=fieldValueMap){
          for(String fieldName: fieldValueMap.keySet())
            {
                customerSat.put(fieldName, fieldValueMap.get(fieldName));        
            }  
        }    
        system.debug('---customerSat--'+customerSat);
        List<Customer_Satsfaction__c> customerSatTemp = new List<Customer_Satsfaction__c>();
        customerSatTemp =[Select Id,Name,Merit_Index_for_customers__c,Quarter_New__c,Score_Year__c
                									From Customer_Satsfaction__c Where Name ='TestMerit 2016 Q2'];
        system.debug('---customerSatTemp--'+customerSatTemp); 
        system.debug('---customerSatTemp size--'+customerSatTemp.size()); 
        if(customerSatTemp.isEmpty())
        	insert customerSat;
        system.debug('---After customerSat--'+customerSat);    
        return customerSat;
    }   
    
}