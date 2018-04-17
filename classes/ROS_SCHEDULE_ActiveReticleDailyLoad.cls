/*
    Author:         Cognizant Technology Solution
    Company:        Cognizant Technology Solution
    Description:    This class is used to schedule apex ROS_BATCH_ActiveReticleDailyLoad
    History:        Name        Date         Comments
                    -----------------------------------------
                    CTS         11/02/2014    Created class
*/

global class ROS_SCHEDULE_ActiveReticleDailyLoad implements Schedulable{

    global void execute(SchedulableContext SC) {
        ROS_BATCH_ActiveReticleDailyLoad batchActiveReticleDailyLoad = new ROS_BATCH_ActiveReticleDailyLoad();
        Database.executeBatch(batchActiveReticleDailyLoad,
                             Integer.valueOf(Environment_Variable__c.getInstance('ROS_ACTIVE_RETICLE_BATCH_SIZE').Value__c));
    }

}