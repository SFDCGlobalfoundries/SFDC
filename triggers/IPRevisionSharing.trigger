/*
    Author: Nikhil Bajaj
    Description: This trigger help to insert/update group in IPRevision sharing object.
    [where ever we create/update ipRevision record respective ipelement group name will be inserted/updated in ipRevision sharing object]
    IPElement- Parent(Lookup Relationship)
    IPRevision-Child
    Date-6-8-2016
*/
trigger IPRevisionSharing on IP_Revision__c(after insert, after update) {
    
   new IPRevisionSharing_TriggerHandler().run();
     
}