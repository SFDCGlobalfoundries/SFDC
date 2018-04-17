/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This data factory class will be used to Design Execution Waiver data in different Test classes
**/
public class DesignExecutionWaiver_DataFactory {
    public static Waivers__c createDesignExectionWaiver(Map<String,Object> fieldValueMap)
         {
            // Create Design Execution Waiver with default data that is required, this will handle cases where required fields are not set
            Waivers__c w = new Waivers__c();
            w.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
            w.Section__c = 'Sign Off Module Methodology';
            w.Waiver_Type__c = 'RTL'; 
            for(String waiverfieldName:fieldValueMap.keySet())
            {
              w.put(waiverfieldName, fieldValueMap.get(waiverfieldName));        
            }
           system.debug('Design Exectuion Waiver' +w);
           insert w;
           return w;
         
         }
}