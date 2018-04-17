/*
    Author: Anirban Roy
    Description: Scheduler class to call the batch class IPDeclarationSyncBatch.
    History:
        ARoy        12062013    - code creation.
*/
global class IPDeclarationSyncScheduler implements Schedulable{
	global void execute(SchedulableContext sc){
         database.executeBatch(new IPDeclarationSyncBatch());         
    }
}