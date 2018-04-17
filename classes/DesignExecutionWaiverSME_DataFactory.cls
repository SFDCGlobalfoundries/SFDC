/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This data factory class will be used to Design Execution WaiverSME data in different Test classes
**/
public class DesignExecutionWaiverSME_DataFactory {
    public static Waiver_SMEs__c createDesignExectionWaiver(Map<String,Object> fieldValueMap)
         {
            // Create Design Execution WaiverSME with default data that is required, this will handle cases where required fields are not set
            Waiver_SMEs__c w = new Waiver_SMEs__c();
            w.Check_being_reviewed__c = 'Has the SOM Methodology been run to determine if the RTx Checkpoint has been reached?'; 
            w.Section__c = 'Sign Off Module Methodology';
            w.Waiver_Type__c = 'RTL'; 
            w.To__c = 'test@gmail.com, test1@gmail.com';
            w.Profile_Permission_Sets__c = 'DIW Application Engineer,DIW Design Center Engineer,System Administrator';
            for(String waiverSMEfieldName:fieldValueMap.keySet())
            {
              w.put(waiverSMEfieldName, fieldValueMap.get(waiverSMEfieldName));        
            }
           system.debug('Design Exectuion WaiverSME' +w);
           insert w;
           return w;
         
         }
}