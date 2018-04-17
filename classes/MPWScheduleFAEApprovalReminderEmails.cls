/*
    Author: Kanishk Singh
    Description: Trigger FAE Approval Reminder batch.
    
*/

global class MPWScheduleFAEApprovalReminderEmails implements Schedulable {

global void execute(SchedulableContext ctx) {  
   
   MPWFAEApprovalReminderBatch obj= new MPWFAEApprovalReminderBatch();
    integer batchSize = 200;
    database.executebatch(obj, batchSize);
   
  } // execute 


}