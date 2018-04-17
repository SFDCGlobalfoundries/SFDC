/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This data factory class will be used to DesignDeliverableQuestions data in different Test classes
**/
public class DesignExecutionDeliverable_DataFactory {
	public static Design_Deliverable_Questions__c createDesignExectionDDQ(Map<String,Object> fieldValueMap)
         {
            // Create DesignDeliverableQuestions with default data that is required, this will handle cases where required fields are not set
            Design_Deliverable_Questions__c ddQ = new Design_Deliverable_Questions__c();
			ddQ.Comments__c = 'Test Comment';
            ddQ.Deliverables__c = 'Test Deliverable'; 
            for(String ddQfieldName:fieldValueMap.keySet())
            {
              ddQ.put(ddQfieldName, fieldValueMap.get(ddQfieldName));        
            }
           system.debug('Design Deliverable Questions' +ddQ);
           insert ddQ;
           return ddQ;
         
         }
}