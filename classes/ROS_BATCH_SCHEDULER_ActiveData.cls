global class ROS_BATCH_SCHEDULER_ActiveData implements Schedulable {
   global void execute(SchedulableContext sc) {
      ROS_BATCH_UpdateInactiveDays batchActiveData = new ROS_BATCH_UpdateInactiveDays(); 
      Database.executebatch(batchActiveData, Integer.valueOf(Environment_Variable__c.getInstance('ROS_ACTIVE_RETICLE_BATCH_SIZE').Value__c));
   }
}