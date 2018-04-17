/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 19/02/2015
*@ Description  :- Scheduler for FV_FetchAllATPBatchCls, It helps to schedule class after every 1 hour
*@ History    :- #CR 31836

*/
global with sharing class FV_FetchAllATPScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
    
      FV_FetchAllATPBatchCls atpRecords = new FV_FetchAllATPBatchCls();
      if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(atpRecords, 100);
      }
    }
    // Method return count of number of running jobs
    private static Integer getRunnigJobCount() {
      return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
    }
    // Method retuns 1 if same job is already running and 0 if not runnig
    private static Integer getSameJobCount(){
        
        return (Integer)[Select count() 
                         From  AsyncApexJob 
                         Where JobType = 'BatchApex' 
                         and   ApexClass.Name = 'FV_FetchAllATPBatchCls' 
                         and   (Status = 'Processing' or Status = 'Preparing') limit 1];
        
    }

}

/*   
global void execute(SchedulableContext SC) {
    
      FV_FetchAllATPBatchCls ATPfetched = new FV_FetchAllATPBatchCls ();
     // if(getSameJobCount() < 1 && getRunnigJobCount() < 5){
        database.executeBatch(ATPfetched , 25);
        String CRON_EXP = '0 0 0/1 1/1 * ? *';
        system.schedule('Hourly schedule', CRON_EXP, new FV_FetchAllATPScheduler() );
     // }
   }
   // Method return count of number of running jobs
   /* private static Integer getRunnigJobCount() {
      return (Integer)[Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Processing' or Status = 'Preparing' )];
  }
  // Method retuns 1 if same job is already running and 0 if not runnig
  private static Integer getSameJobCount(){
    
    return (Integer)[Select count() 
            From   AsyncApexJob 
            Where   JobType = 'BatchApex' 
            and     ApexClass.Name = 'FV_FetchAllATPBatchCls ' 
            and   (Status = 'Processing' or Status = 'Preparing' ) limit 1];
    
  }   */

 //}