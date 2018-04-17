global class ROS_BATCH_SCHEDULER_EmailSender implements Schedulable {
   global void execute(SchedulableContext sc) {
      ROS_BATCH_DisposedReticleMailAlert batchFinalMailAlert = new ROS_BATCH_DisposedReticleMailAlert(); 
      Database.executebatch(batchFinalMailAlert, Integer.valueOf(Environment_Variable__c.getInstance('ROS_ACTIVE_RETICLE_BATCH_SIZE').Value__c));
   }
}