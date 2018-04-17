/*
    Company:        Cognizant Technology Solution
    Description:    This batch class will update inactive days field on reticle if actual inactive days value is 366.
    History:

    CTS    18/03/2014    Class Creation
*/

global class ROS_BATCH_UpdateReticleInactiveDays implements Database.Batchable<sObject> {

    public ROS_BATCH_UpdateReticleInactiveDays() {
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date inactiveStartDate = date.today().addDays(-366);
        return Database.getQueryLocator('SELECT Id, Day_Inactive__c ' +
                                        'FROM   Reticle__c ' +
                                        'WHERE  IsActive__c = true AND ' +
                                               'Reticle_workflow_Status__c != \'Closed\' AND ' +
                                               'Inactive_Days_Start_Date__c = :inactiveStartDate');
    }

    global void execute(Database.BatchableContext BC, List<Reticle__c> listReticle) {
        if(listReticle != null && !listReticle.isEmpty()) {
            //update reticle inactive days
            for(Reticle__c reticle : listReticle) {
                reticle.Day_Inactive__c = 366;
            }

            Database.SaveResult[] srList = Database.update(listReticle, false);

            for(Database.SaveResult sr : srList) {
                if(!sr.isSuccess()) {
                    // Operation failed, so get all errors
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Reticle fields that affected this error: ' + err.getFields());        
                    }
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}