/*
Author: Devendra
Description: Apex class will auto-void Reservation forms if
-> Notification for creation of Frame to FAE/customer based on geometry
-> Notification after change to both fae/customer/tapeout team
-> Notification after PTRF creation/tapeout(workflow email alert)
History:
Devendra     03162016     - code creation.
*/

global class SFFGNotificationScheduler implements Schedulable {

    global void execute(SchedulableContext SC){
    	SFFGEmailNotificationBatch bc=new SFFGEmailNotificationBatch();
    	Database.executeBatch(bc,50);
    }
    
    //for testing purpose through devconsole
    //global SFFGNotificationScheduler(){ 
    //	SFFGEmailNotificationBatch bc=new SFFGEmailNotificationBatch();
    //	Database.executeBatch(bc,50);
    //}
}