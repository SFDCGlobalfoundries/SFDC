/*
Author: Devendra
Description: 
-->Scheduler for purging records
History:
Devendra     24052016     - code creation.
*/

global class GlobalAppLogPurgeScheduler implements Schedulable {

    global void execute(SchedulableContext SC){
        GlobalAppLogPurgeBatch bc=new GlobalAppLogPurgeBatch ();
        Database.executeBatch(bc,2000); //deleting 2000 records in single transation 
    }
    
}