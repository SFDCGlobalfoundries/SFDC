/*Author: Vijay Vemuru
    Description: Controller for Sending Executives Reports for Customer Visitation
    History:
    Created     -     Vijay Vemuru-    04/21/2016      - code creation.
*/
public class VisitationReportController {
    public list<Visitation_Executive__c> visitExecutiveList{get;set;}
    public List<Visitation_Attendee__c> visitationAttendeeList{get;set;}
    public map<id,string> requeststatusMap{get;set;}
    
    Map<string,Visitation_Executive__c> visitExcutives =  new Map<string,Visitation_Executive__c>();
        
    public VisitationReportController() {
        visitExecutiveList = new list<Visitation_Executive__c>();
        visitationAttendeeList = new List<Visitation_Attendee__c>();
        requeststatusMap = new map<id,string>();
        visitExcutives = Visitation_Executive__c.getAll();
    
        if(visitExcutives != null ) {
            for(Visitation_Executive__c exec : visitExcutives.values()) {
                visitExecutiveList.add(exec);
            } 
        }
        tableData();    
    }
    
    public void tableData() {
        Date tday= system.today();
        Date lastMonth = tday.addmonths(-1);
        set<string> customerStatus= new set<string>{'3. Logistics Preparation','4. Logistics Complete'};
        visitationAttendeeList = [SELECT id,Attendee__c,Request_Status__c,Attendee__r.name,Visitation__r.Account__r.name,
                              Visitation__r.Account__c,Visitation__r.Visitation_Host__r.name,Visitation__r.Start_Date__c,Visitation__r.End_Date__c,
                              Visitation__r.Location__c,visitation__r.Purposes__c,Visitation__r.name 
                              FROM Visitation_Attendee__c 
                              WHERE createddate>=: lastMonth AND Visitation__r.Customer_Status__c IN:customerStatus];
      
           for (Visitation_Attendee__c visit : visitationAttendeeList) {
            if(visitExcutives.containsKey(visit.Attendee__r.name)) {
                if(visit.Request_Status__c   == 'Requested') {
                    requeststatusMap.put(visit.id,'R');
                } else if(visit.Request_Status__c    == 'Declined') {
                    requeststatusMap.put(visit.id,'D');
                } else if(visit.Request_Status__c    == 'Confirmed') {
                    requeststatusMap.put(visit.id,'C');
                } 
                
            }
       
       }
    }
}