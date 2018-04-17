/*
    Author:         Ankit Singhal
    Company:        Cognizant Technology Solution
    Description:        
    History:
    
    Ankit Singhal   26082013     -     Class Creation
    CTS             10 OCt 2013        Add Varibale pass Current Cycle.
                 
    */
global class ROS_BATCH_DeleteInvalidReticle implements Database.Batchable<sObject> {
    private String invalidDataJobId;
    private List<Reticle_Datawarehouse__c> lRetDwh;
    
    public ROS_BATCH_DeleteInvalidReticle(String jobId) {
        invalidDataJobId = jobId;
        // lRetDwh = lRetDwhParam;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Invalid__c, Invalid_Reason__c FROM Reticle__c WHERE Job_Id__c = \'' + invalidDataJobId + '\'');
    }

    global void execute(Database.BatchableContext BC, List<Reticle__c> lReticleDataDel) {
        // TODO: UPDATE INVALID REASON
        // ROS_ReticleDatawareHouseBatchHelper.updateInvalidReason(lReticleDataDel, lRetDwh);
        Database.delete(lReticleDataDel);
    }
    
    global void finish(Database.BatchableContext BC) {

    }
}