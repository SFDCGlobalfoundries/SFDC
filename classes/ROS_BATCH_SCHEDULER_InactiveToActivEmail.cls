/*
    Company:        Cognizant Technology Solution
    Description:    Scheduler Class to send Email in there are any Reticles pending for Inactive to Active Conversion
    History:
    NJain    23-Sep-14    Created the class
*/
global class ROS_BATCH_SCHEDULER_InactiveToActivEmail implements Schedulable {
   global void execute(SchedulableContext sc) {
      ROS_Batch_InactiveToActiveEmail batchSendEmail = new ROS_Batch_InactiveToActiveEmail(); 
      Database.executebatch(batchSendEmail, 100);
   }
}