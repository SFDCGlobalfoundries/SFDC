/*
    Author: Sandesh Singh
    Description: This is the test class data factory for PostQBR.   
    History:
        Sandesh 04/10/2017    - code creation.
*/
@isTest
public class PostQBRDataFactory {
    
    private static Merit__c getMerit(){
        return [Select Id, Name From Merit__c LIMIT 1];
    }
    
	public static List<Post_QBR_Action_Plan__c> getPostQBRs(List<Map<String,Object>> fieldValueMaps,Integer numRecs){
       Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        // Overwrite default values
        fieldValueMap1.put('Delivery_G__c', 10);
        MeritIndexDataFactory.createMerit(fieldValueMap1);
        // Validate parameters
        if (fieldValueMaps != null && fieldValueMaps.size() != numRecs)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of Next QBR you want to create.');
        }
        List<Post_QBR_Action_Plan__c> postQBRs = new List<Post_QBR_Action_Plan__c>();
        
        for(Integer i=0;i<numRecs;i++)                    
        {
            Post_QBR_Action_Plan__c postQBRTemp = new Post_QBR_Action_Plan__c(Subject__c= 'DPML improvement'+i,
                                          Merit_Index_for_customers__c= getMerit().Id,
                                          Completion__c = 'Open',
                                          Status__c = 'Green'										                                                        
                                          );    
            if (fieldValueMaps != null)
            {      
                Map<String,Object> fieldValueMap = fieldValueMaps.get(i);
                for(String fieldName: fieldValueMap.keySet())
                {
                    postQBRTemp.put(fieldName, fieldValueMap.get(fieldName));        
                }
            }
            postQBRs.add(postQBRTemp);    
        }
        
        system.debug('---postQBRs---'+postQBRs);
        insert postQBRs;
        return postQBRs; 
    }
}