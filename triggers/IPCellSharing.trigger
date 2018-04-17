/*
    Author: Nikhil Bajaj
    Description: This trigger help to insert/update group of IPElement  in IPCell sharing object.
    [where ever we create ipcell record respective ipelement group name  will be inserted in ipcell sharing object]
    IPElement- Parent(Lookup Relationship)
    IPCell-Child
    Date-6-8-2016
*/
trigger IPCellSharing on IP_Cell__c(after insert, after update) {
    
    new IPCellSharing_TriggerHandler().run();

}