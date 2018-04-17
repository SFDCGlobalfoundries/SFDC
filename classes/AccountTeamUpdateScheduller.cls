/*
    Author: Anirban Roy
    Description: Scheduller class to call the batch class AccountTeamUpdateBatch. 
    History:
        ARoy        04222013    - code creation.        
*/
global class AccountTeamUpdateScheduller implements Schedulable {
    global void execute(SchedulableContext sc){
         database.executeBatch(new AccountTeamUpdateBatch());
    }
}