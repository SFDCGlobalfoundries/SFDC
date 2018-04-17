/*
    Author: Ravi Teja B
    Description: Trigger Configuration FAE Approval Reminder batch.
    
*/

global class ConfigScheduleFAEApprovalReminderEmails implements Schedulable {

global void execute(SchedulableContext ctx) {  
   
   MPWFAEApprovalReminderBatch obj= new MPWFAEApprovalReminderBatch();
   obj.objectAPIName = 'Apttus_Proposal__Proposal__c';
   obj.whomToNotify = 'FAE';
   integer batchSize = 200;
   database.executebatch(obj, batchSize);
   
  } // execute 


}