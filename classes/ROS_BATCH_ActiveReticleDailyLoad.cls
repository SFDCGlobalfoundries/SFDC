/*
    Author:
    Company:        Cognizant Technology Solution
    Description:
    History:
        NJain    22-Sep-14    Added the condition in QueryLocator to filter out Reticle Datawarhouse that have Reticle_Status as 'Expected'
*/
public class ROS_BATCH_ActiveReticleDailyLoad implements Database.Batchable<sObject>, Database.Stateful {
    public boolean isTestClass = false;
    public integer totalCount;

    public ROS_BATCH_ActiveReticleDailyLoad() {
        totalCount = 0;
    }

    public Database.QueryLocator start (Database.BatchableContext batchableContext) {
        System.debug('BATCH STARTED');
        if(!isTestClass){
            return Database.getQueryLocator('SELECT Id' +
                                           + ', Name' +
                                           + ', CustomerDevice_ID__c' +
                                           + ', Customer_ID__c' +
                                           + ', Customer_Name__c' +
                                           + ', FAB__c' +
                                           + ', GlobalFoundries_DeviceID__c' +
                                           + ', Region_Name__c' +
                                           + ', Reticle_Type__c' +
                                           + ', Reticle_Status__c' +
                                           + ', ROS_Cycle__c' +
                                           + ', InactiveDay__c' +
                                           + ', IsActive__c' +
                                           + ', Device_Type__c' +
                                           + ', Job_Id__c' +
                                     + ' FROM Reticle_Datawarehouse__c ' +
                                     + ' WHERE IsActive__c = true '
                                     + '    AND Duplicate_Record__c = false'
                                     + '    AND Job_Id__c = null and Customer_ID__c <> null'
                                     + '    AND Reticle_Status__c != \'Expected\'');
        }else{
        return Database.getQueryLocator('SELECT Id' +
                                           + ', Name' +
                                           + ', CustomerDevice_ID__c' +
                                           + ', Customer_ID__c' +
                                           + ', Customer_Name__c' +
                                           + ', FAB__c' +
                                           + ', GlobalFoundries_DeviceID__c' +
                                           + ', Region_Name__c' +
                                           + ', Reticle_Type__c' +
                                           + ', Reticle_Status__c' +
                                           + ', ROS_Cycle__c' +
                                           + ', InactiveDay__c' +
                                           + ', IsActive__c' +
                                           + ', Device_Type__c' +
                                           + ', Job_Id__c' +
                                     + ' FROM Reticle_Datawarehouse__c ' +
                                     + ' WHERE IsActive__c = true '
                                     + '    AND Duplicate_Record__c = false'
                                     + '    AND Job_Id__c = null and Customer_ID__c <> null limit 1');
        }
        
    }

    public void execute(Database.BatchableContext batchableContext, List<Reticle_Datawarehouse__c> lReticleDw) {
        if (!lReticleDw.isEmpty()) {
            //Increment count of reticle dataware house records processed
            totalCount = totalCount + lReticleDw.size();

            for (Reticle_Datawarehouse__c eachReticleDw :lReticleDw) {
                eachReticleDw.Job_Id__c = batchableContext.getJobId();
            }

            update lReticleDw;

            ROS_ReticleDatawareHouseBatchHelper.createActiveReticles(lReticleDw);

            List<Reticle__c> lReticle = [ SELECT Id, Name, Invalid__c, Invalid_Reason__c 
                                          FROM Reticle__c 
                                          WHERE Job_Id__c = :batchableContext.getJobId() AND IsActive__c = true AND Invalid__c = true ];

            if (lReticle != null && !lReticle.isEmpty()) {
                //Update invalid reason on reticle datawarehouse
                ROS_ReticleDatawareHouseBatchHelper.updateInvalidReason(lReticle, lReticleDw, batchableContext.getJobId());

                //Delete invalid reticles
                Database.DeleteResult[] drList = Database.delete(lReticle, false);

                // Iterate through each returned result
                for(Database.DeleteResult dr : drList) {
                    if (!dr.isSuccess()) {
                        // Operation failed, so get all errors
                        for(Database.Error err : dr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Reticle fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext batchableContext) {
        ROS_BATCH_DeleteActiveRDWH batchDeleteActiveRDWH = new ROS_BATCH_DeleteActiveRDWH(batchableContext.getJobId(), totalCount);
        Database.executeBatch(batchDeleteActiveRDWH, 100);
    }
}