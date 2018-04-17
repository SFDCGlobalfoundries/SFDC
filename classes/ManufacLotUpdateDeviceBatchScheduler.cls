/*
    Author: Thomas Lai
    Description: Scheduler to run ManufacLotUpdateDeviceBatch . 
                 The sync from other systemm to SFDC first starts at 5:30AM PST and takes around 20 mins, Every 4 hours per day
    History: 
        TLai        02172014    - code creation.
*/
global class ManufacLotUpdateDeviceBatchScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      ManufacLotUpdateDeviceBatch b = new ManufacLotUpdateDeviceBatch(); 
      integer bSize = Integer.valueOf(Environment_Variable__c.getInstance('MANUFACTURE_LOT_BATCH_SIZE').value__c);
      if(!Test.isRunningTest()){  database.executebatch(b,bSize);}
     
      
   }
}