/*
  Author: Anirban Roy
  Description: This is the scheduled apex class for deletion of 30 days old data of CPQ MLG Error Log records.
  History:
    ARoy        05252015    - code creation.             
*/

global class DelCPQMLGErrorLogScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        DeleteCPQMLGErrorLog delBatch = new DeleteCPQMLGErrorLog();
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}