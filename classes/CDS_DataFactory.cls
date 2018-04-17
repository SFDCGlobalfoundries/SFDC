/**
* Author: Cognizant Technology Solutions
* Project: DIW 
* Description: This data factory class will be used to CDS data in different Test classes
**/

@isTest
public class CDS_DataFactory{

     public static Custom_Design__c createCDS(Map<String,Object> fieldValueMap)
     {
        // Create Custom Design with default data that is required, this will handle cases where required fields are not set
        
        Custom_Design__c  CD = new Custom_Design__c();
        cd.CDS_Status__c = 'Draft';
        
        for(String CustomDesignfieldName:fieldValueMap.keySet())
        {
          CD.put(CustomDesignfieldName, fieldValueMap.get(CustomDesignfieldName));        
        }
       system.debug('Customer Design' +CD);
       insert CD;
       return CD;
     
     }
}