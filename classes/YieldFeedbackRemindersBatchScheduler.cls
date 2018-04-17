/*
    Author: Zymark Ambat
    Description: Scheduller class to call the batch class YieldFeedbackRemindersBatch. 
    History:
        ZAmbat        01052015    - code creation.        
*/
global class YieldFeedbackRemindersBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
         database.executeBatch(new YieldFeedbackRemindersBatch());
    }
}