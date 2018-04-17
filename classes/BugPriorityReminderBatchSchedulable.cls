/*Author: UCM Team
* Description: This class is schedular class for BugPriorityReminderBatch
* History: Created on 01/30/2018
*/
global class BugPriorityReminderBatchSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BugPriorityReminderBatch(),100);
    }
}