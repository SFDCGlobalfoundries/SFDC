global class STM_BATCH_SCHEDULER_AutoCopy implements Schedulable {
   global void execute(SchedulableContext sc) {
      STM_BATCH_AutoCopyFeed batchData = new STM_BATCH_AutoCopyFeed(); 
      Database.executebatch(batchData, Integer.valueOf(System.Label.STM_AUTOCOPY_BATCH_SIZE));
   }
}