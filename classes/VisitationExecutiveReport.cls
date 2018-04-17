/*Author: Vijay Vemuru
    Description: This Class is for Sending Executives Reports
    History:
    Created     -     Vijay Vemuru-    05/02/2016      - code creation.
*/
public class VisitationExecutiveReport {
    public id visitId{get;set;}
    public VisitationExecutiveReport(){
    }
    public List<Visitation_Attendee__c> getAttendeeList() {
        List<Visitation_Attendee__c> attendeeList = [Select id,Title__c,Visitation__r.name,Name,
                                                         Visitation__r.Account__r.name,Visitation__r.Visitation_Host__r.name,Visitation__r.Start_Date__c,
                                                         Visitation__r.End_Date__c,Visitation__r.Visit_Location__c
                                                         FROM Visitation_Attendee__c WHERE Visitation__c=:visitId AND Type_of_attendee__c =: 'Customer Attendee'];   
        return attendeeList;
    }
}