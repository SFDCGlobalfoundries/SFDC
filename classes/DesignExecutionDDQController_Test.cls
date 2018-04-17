/**
* Author: Sandesh Singh
* Project: DIW 
* Description: This Test_DesignExectionSignOffController class will be used to test singOff module flow on DE track
**/
@isTest(seeAllData =false)
public class DesignExecutionDDQController_Test {
    private static testMethod void designDeliverableMapTest(){
        Map<String,Object> fieldddQMap = new Map<String,Object>();
        fieldddQMap.put('Milestone__c', 'RTA');
        Design_Deliverable_Questions__c ddQObj =DesignExecutionDeliverable_DataFactory.createDesignExectionDDQ(fieldddQMap);
		DesignExecutionDeliverableController ddQ = new DesignExecutionDeliverableController();
        Map<String,List<Design_Deliverable_Questions__c>> mapOfDDQ = new Map<String,List<Design_Deliverable_Questions__c>>();
        test.startTest();
        mapOfDDQ = ddQ.getDesignDeliverableMap();
        system.assert(!mapOfDDQ.isEmpty());
        system.assertEquals(mapOfDDQ.keySet().size(), 1);
        system.assert(!mapOfDDQ.get('RTA').isEmpty());
        system.assert(mapOfDDQ.get('RTA').size()==1);
        test.stopTest();
    }
    
    
}