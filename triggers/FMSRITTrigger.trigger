/*
  Author: Anirban Roy
  Description: This is the trigger on RIT Drop box object to populate the FMS history records.
  History:
    ARoy        06122017    - code creation.
    ARoy		28062017	- Added Trigger Framework              
*/
trigger FMSRITTrigger on FMS_RIT_Drop_Box__c (after insert, after update, before delete) {
    new FMSRITDropboxTriggerHandler().run(); 
}