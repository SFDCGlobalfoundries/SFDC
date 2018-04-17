/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Description: This class is used as a scheduler for BatchFabgroupShare class

    History: Harsha:05/01/17
**/    


global with sharing class BatchFabgroupShareScheduler implements Schedulable {

	 global void execute(SchedulableContext SC) {
        
      BatchFabgroupShare waiver = new BatchFabgroupShare();
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
                         and ApexClass.Name = 'BatchFabgroupShare' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}