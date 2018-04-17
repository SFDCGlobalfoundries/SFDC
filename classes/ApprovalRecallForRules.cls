global without sharing class ApprovalRecallForRules implements Schedulable{
    
         global void execute(SchedulableContext SC) {
            
          ApprovalRecallBatch waiver = new ApprovalRecallBatch();
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
                             and ApexClass.Name = 'ApprovalRecallBatch' 
                             and (Status = 'Processing' or Status = 'Preparing' )];
            
        }
    
    }