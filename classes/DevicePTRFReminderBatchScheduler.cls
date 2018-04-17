/*
    Author: Zymark Ambat
    Description: This batch class is the scheduler for DevicePTRFReminderBatch.
    History: 
        ZAmbat      04082014    - Code creation.
*/

global class DevicePTRFReminderBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
         database.executeBatch(new DevicePTRFReminderBatch());
    }
}