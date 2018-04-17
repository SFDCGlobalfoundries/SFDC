/*
*@ Author       :- Navneet Rajput 
*@ Company      :- Global Foundries
*@ Date         :- 
*@ Description  :- Scheduler to call waiver collaborator batch after every 2 days
*@ History      :- 
*/

global with sharing class WaiverCollaboratorAutoEmailScheduler implements Schedulable {

	 global void execute(SchedulableContext SC) {
        
      WaiverCollaboratorEmailNotificationBatch waiver = new WaiverCollaboratorEmailNotificationBatch();
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(waiver, 10);
      }
   }
   // Method return count of number of running jobs
    private static Integer getRunnigJobCount() {
        return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
    }
    // Method retuns 1 if same job is already running and 0 if not runnig
    private static Integer getSameJobCount(){
        
        return (Integer)[Select count()From AsyncApexJob Where JobType = 'BatchApex' 
                         and ApexClass.Name = 'WaiverCollaboratorEmailNotificationBatch' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}