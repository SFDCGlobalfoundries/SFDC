/*
    Author: Sunil Arora
    Description: Scheduler class to call the batch class TeamRoomMemberDeleteBatch. 
    History:
        Sunil 05302016    - code creation.        
*/
global class TeamRoomMemberDeleteBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
         database.executeBatch(new TeamRoomMemberDeleteBatch(),5);
    }
}