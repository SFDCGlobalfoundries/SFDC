/**
* This class will schedule a job to change case status to close once all releated bugs closed
* It will invoke a batch class to retrigger
* This class will be invoked by:
* - Schedule a job
*/
global class CaseStausToCloseBatchSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseStausToCloseBatch(),100);
    }
}