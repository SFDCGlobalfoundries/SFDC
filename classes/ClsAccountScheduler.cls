/*
Type Name: ClsAccountScheduler 
Author: Cognizant
Created Date: 26-April-2013
Reason: This is scheduler class used for scheduling the batch class ClsUpdateAccountDeactivationError. 
Change History:
Author: Cognizant
Modified Date: 
Reason: 
……..
……..
*/


global class ClsAccountScheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     ClsUpdateAccountDeactivationError  batchCall = new ClsUpdateAccountDeactivationError(); //ur batch class
      database.executebatch(batchCall);
    }
}