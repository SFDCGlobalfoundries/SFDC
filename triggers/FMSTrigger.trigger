/*
  Author: Anirban Roy
  Description: This is the test class for FMStrigger.
  History:
    ARoy        06262017   - code creation.
    ARoy		28062017   - Added Trigger Framework
*/
trigger FMSTrigger on Form_Management_System__c (before insert, after insert, after update,before update, before delete) {
    system.debug('-inside-');
    new FMSTriggerHandler().run(); 
}