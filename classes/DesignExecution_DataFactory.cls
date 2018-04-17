/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This data factory class will be used to Design Execution data in different Test classes
**/

@isTest
public class DesignExecution_DataFactory {
	public static Design_Execution__c createDesignExection(Map<String,Object> fieldValueMap)
     {
        // Create Design Execution with default data that is required, this will handle cases where required fields are not set
        Design_Execution__c deOBJ = new Design_Execution__c();
        deOBJ.Actual_Date__c = system.today();
        
        for(String DesignExectuionfieldName:fieldValueMap.keySet())
        {
          deOBJ.put(DesignExectuionfieldName, fieldValueMap.get(DesignExectuionfieldName));        
        }
       system.debug('Design Exectuion' +deOBJ);
       insert deOBJ;
       return deOBJ;
     
     }
}