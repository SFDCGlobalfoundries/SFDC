/*
    Author: Sandesh Singh
    Description: This is the test class data factory for NextQBR.   
    History:
        Sandesh 04/10/2017    - code creation.
*/
@isTest
public class NextQBRDataFactory {
	
    public static List<Next_QBR__c> getNextQBRs(List<Map<String,Object>> fieldValueMaps,Integer numRecs){
       Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap1.put('Delivery_G__c', 10);
        MeritIndexDataFactory.createMerit(fieldValueMap1);
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numRecs)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of Next QBR you want to create.');
        }
        List<Next_QBR__c> nextQBRs = new List<Next_QBR__c>();
        
        for(Integer i=0;i<numRecs;i++)                    
        {
            Next_QBR__c nextQBRTemp = new Next_QBR__c(Actual__c= i+1,
                                          Area_of_Excellence__c= 'Test Area Of Excellence',
                                          Forecast__c = 10 + i,
                                          Order__c = i+1,
										  Target__c = 12 +i                                                      
                                          );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    nextQBRTemp.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            nextQBRs.add(nextQBRTemp);    
        }
        insert nextQBRs;
        return nextQBRs; 
    }
}