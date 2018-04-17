/*
*@ Author       :- SUHAS BARGI
*@ Company      :- Global Foundries
*@ Date         :- 
*@ Description  :- Scheduler to call waiver collaborator batch after every 24 hrs for Template 2 - Reminder for: Release of DRC Report to Customer, scheduled batch to trigger the mail
* @ Template 4 : reminder mail, scheduled batch - Collaborator status is “Pending Customer/ Foundry” for >2days. THEN IF Release Report pending for every 24hrs until closed
*@ History      :- 
*/

global with sharing class DRCCustEMailNotifiyBatchScheduler implements Schedulable {

	 global void execute(SchedulableContext SC) {
        
      DRCReleaseToCustEMailNotifiyBatch waiver = new DRCReleaseToCustEMailNotifiyBatch();
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(waiver,199);
      }
   }
   // Method return count of number of running jobs
    private static Integer getRunnigJobCount() {
        return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
    }
    // Method retuns 1 if same job is already running and 0 if not runnig
    private static Integer getSameJobCount(){
        
        return (Integer)[Select count()From AsyncApexJob Where JobType = 'BatchApex' 
                         and ApexClass.Name = 'DRCReleaseToCustEMailNotifiyBatch' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}