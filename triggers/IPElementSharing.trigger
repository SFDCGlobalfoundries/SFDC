/*
    Author: Nikhil Bajaj
    Description: This trigger help to insert/update group in IPelement,IPcell and IPrevision sharing object and send email to group member. 
    IPElement- Parent(Lookup Relationship)
    IPCell and IPRevision-Child
    Date-6-8-2016
*/
trigger IPElementSharing on IP_Element__c(after insert, after update,before delete) {
    
    new IPElementSharing_TriggerHandler().run();
}