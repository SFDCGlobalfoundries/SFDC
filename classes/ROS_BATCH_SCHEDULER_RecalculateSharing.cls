global class ROS_BATCH_SCHEDULER_RecalculateSharing implements Schedulable {
   global void execute(SchedulableContext sc) {
      ROS_ReCalculateSharing batchRecalculateSharing = new ROS_ReCalculateSharing(); 
      Database.executebatch(batchRecalculateSharing, 20);
   }
}