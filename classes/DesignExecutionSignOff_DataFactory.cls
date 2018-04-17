/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This data factory class will be used to Design Execution SignOff Module data in different Test classes
**/

@isTest
public class DesignExecutionSignOff_DataFactory {
	public static Sign_off_Module__c createDesignExectionSignOffModule(Map<String,Object> fieldValueMap)
     {
        // Create Design Execution sign Off Module with default data that is required, this will handle cases where required fields are not set
        Sign_off_Module__c som = new Sign_off_Module__c();
        som.RTL_Checkpoint_Reached__c = true;
        som.stage__c = 'RTP'; 
        som.RIT_Type__c = 'A/B';
        for(String somfieldName:fieldValueMap.keySet())
        {
          som.put(somfieldName, fieldValueMap.get(somfieldName));        
        }
       system.debug('Design Exectuion sign Off Module' +som);
       insert som;
       return som;
     
     }
}