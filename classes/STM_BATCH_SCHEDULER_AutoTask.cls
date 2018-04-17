global class STM_BATCH_SCHEDULER_AutoTask implements Schedulable {
   global void execute(SchedulableContext sc) {
      STM_BATCH_AutoTaskFeed batchData = new STM_BATCH_AutoTaskFeed();
      Database.executebatch(batchData, Integer.valueOf(System.Label.STM_AUTOTASK_BATCH_SIZE));
   }
}