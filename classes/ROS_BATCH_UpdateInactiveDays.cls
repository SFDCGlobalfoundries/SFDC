/*
    Author:
    Company:        Cognizant Technology Solution
    Description:
    History:
*/
public class ROS_BATCH_UpdateInactiveDays implements Database.Batchable<sObject> {

    public Database.QueryLocator start (Database.BatchableContext batchableContext) {
        System.debug('BATCH STARTED');

        return Database.getQueryLocator('SELECT Id' +
                                           + ', Name' +
                                           + ', Day_Inactive__c' +
                                     + ' FROM Reticle__c ' +
                                     + ' WHERE ROS_Status__c = null ');
    }

    public void execute (Database.BatchableContext batchableContext, List<Reticle__c> lReticle) {
        
        if (!lReticle.isEmpty()) {
            System.debug('RECORDS SUBMITTED FOR PROCESS : ' + lReticle.size());
            System.debug('JOB ID : ' + batchableContext.getJobId());

            for (Reticle__c eachReticle :lReticle) {
                eachReticle.Day_Inactive__c = eachReticle.Day_Inactive__c + 1;
            }
            
            update lReticle;
        }
    }

    public void finish (Database.BatchableContext batchableContext) {
        ROS_BATCH_ActiveReticleDailyLoad activeReticleLoad = new ROS_BATCH_ActiveReticleDailyLoad();
        Database.executeBatch(activeReticleLoad);
    }
}