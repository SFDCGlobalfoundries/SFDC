/*
    Author: Harsha Vardhan
    Company: Cognizant
    Project: DRC/DFM Application
    Details:This class is used as a Scheduler for BatchAccTeamProxyFaeShare .
    History: Mohan :- 11/01/17
**/    
global with sharing class BatchAccTeamProxySchedule implements Schedulable {

     global void execute(SchedulableContext SC) {
         
      BatchAccTeamProxyFaeShare waiver = new BatchAccTeamProxyFaeShare();
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
          if(!test.isrunningtest())
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
                         and ApexClass.Name = 'BatchAccTeamProxyFaeShare' 
                         and (Status = 'Processing' or Status = 'Preparing' )];
        
    }
}