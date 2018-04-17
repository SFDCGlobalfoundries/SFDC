/*
*@ Author       :- SUHAS BARGI
*@ Company      :- Global Foundries
*@ Date         :- 
*@ Description  :- Scheduler to call waiver collaborator batch after every 24 hrs for Template 6: reminder mail, scheduled batch - At least one GF-Review-result = (“FDCC” OR “FDi”) for >2days. THEN IF Release Report pending for every 24hrs until closed
* @ Item8 Template – Notification of Foundry-to-risk open approval, FAE trigger foundry-to-risk approval AND open for <2d
*@ History      :- 
*/

global with sharing class DRCFAENotifyToCustBatchScheduler implements Schedulable {

	 global void execute(SchedulableContext SC) {
        
      DRCFAENotifyToCustDiscussionBatch waiver = new DRCFAENotifyToCustDiscussionBatch();
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
                         and ApexClass.Name = 'DRCFAENotifyToCustDiscussionBatch' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}