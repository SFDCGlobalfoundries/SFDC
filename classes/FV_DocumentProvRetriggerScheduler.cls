/*
*@ Author       :- Navneet Rajput 
*@ Company      :- Cognizant technology
*@ Date         :- 04/11/2014
*@ Description  :- Scheduler for documentProvisioningBatchableCls, It helps to schedule class after every 30 mintues
*@ History      :- #CR
*/

global with sharing class FV_DocumentProvRetriggerScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        
      FV_PDKProvisioningRetriggerBatchCls dProvisioning = new FV_PDKProvisioningRetriggerBatchCls();
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(dProvisioning, 100);
      }
   }
   // Method return count of number of running jobs
    private static Integer getRunnigJobCount() {
        return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
    }
    // Method retuns 1 if same job is already running and 0 if not runnig
    private static Integer getSameJobCount(){
        
        return (Integer)[Select count()From AsyncApexJob Where JobType = 'BatchApex' 
                         and ApexClass.Name = 'FV_PDKProvisioningRetriggerBatchCls' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }

}