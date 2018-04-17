/*
    Author: Zymark Ambat
    Description: Scheduller class to call the batch class DeviceYieldFeedbackBatch. 
    History:
        ZAmbat        01052015    - code creation.        
*/
global class DeviceYieldFeedbackBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
         database.executeBatch(new DeviceYieldFeedbackBatch());
    }
}