/*
    Author:         Cognizant Technology Solution
    Company:        Cognizant Technology Solution
    Description:    This class is used to schedule apex ROS_BATCH_UpdateReticleInactiveDays
    History:        Name        Date         Comments
                    -----------------------------------------
                    CTS         19/03/2014    Created class
*/

global class ROS_SCHEDULE_UpdateReticleInactiveDays implements Schedulable{

    global void execute(SchedulableContext SC) {
        ROS_BATCH_UpdateReticleInactiveDays batchUpdateReticleInactiveDays = new ROS_BATCH_UpdateReticleInactiveDays();
        Database.executeBatch(batchUpdateReticleInactiveDays,
                             Integer.valueOf(Environment_Variable__c.getInstance('ROS_ACTIVE_RETICLE_BATCH_SIZE').Value__c));
    }

}