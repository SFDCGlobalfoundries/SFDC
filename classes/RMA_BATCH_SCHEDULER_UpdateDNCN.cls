/*
    Company:        Cognizant Technology Solution
    Description:    Scheduler class for RMA_BATCH_UpdateDNCN  to update the DNCN details on the RMA request.
    History:        1/12/2016    Created the class    
*/

global class RMA_BATCH_SCHEDULER_UpdateDNCN implements Schedulable{
    global void execute(SchedulableContext sc) {
        RMA_BATCH_UpdateDNCN batchJob= new RMA_BATCH_UpdateDNCN();
        Database.executebatch(batchJob, 100);
    }
}