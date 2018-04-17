/*
Type Name: BatchTargettedDeliveryDateReminder 
Author: UCM Cognizant
Reason: This class implements to send Email alert for Targetted Delivery Date 
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
global class scheduledTargettedDeliveryDateReminder implements Schedulable {
  global void execute(SchedulableContext sc) {
  BatchTargettedDeliveryDateReminder batchTargettedDate = new BatchTargettedDeliveryDateReminder(); 
  database.executebatch(batchTargettedDate,50);
  }
}