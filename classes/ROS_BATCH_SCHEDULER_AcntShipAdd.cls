global class ROS_BATCH_SCHEDULER_AcntShipAdd implements Schedulable {
   global void execute(SchedulableContext sc) {
      ROS_BATCH_AcntShipAddInsert batchShipAddInsert = new ROS_BATCH_AcntShipAddInsert(); 
      Database.executebatch(batchShipAddInsert, Integer.valueOf(Environment_Variable__c.getInstance('ROS_SHIPADD_BATCH_SIZE').Value__c));
   }
}