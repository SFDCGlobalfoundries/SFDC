/*trigger to handle  EarlyWarningstatus 
which update Version Id , update Is latest version 
Author: Rahul Majumder
Version 1.0
*/

trigger EarlyWarningStatusTrigger on Early_Warning_Status__c (after insert, after update) 
{ 
    if(RecursionPrevent.runonce())
    {
        if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
        {                   
            ICC_EarlyWarningStatusTriggerHandler.updateVersions(Trigger.new);            
        }
    }
}