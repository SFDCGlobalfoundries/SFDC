/*
This is batch class to retry failure for SWGP-998
This batch is called from MRSBatchRetryMSIHSchedulable scheduler.
MRSBatchRetryMSIHSchedulable is dynamic called from MRSMSIHScheduleDispatcher 
using async design pattern to allow modification without stopping the running job

To schedule this batch properly:
- Schedule name: MRSBatchRetryMSIHS
- Schedule class: MRSMSIHScheduleDispatcher 

Test class: MRSBatchRetryMSIHTest
*/
global class MRSBatchRetryMSIH implements Database.Batchable <sObject> { 
    
    //iterable: limit of 50k records return by soql queries is enforced
    global Iterable<sObject> start(Database.BatchableContext BC) {
        String q1 = 'select id from mrs_layer_association__c where id in ' 
            + ' (select MRS_Layer_Association__c from MRS_Layer_Syncing_Status__c where Is_Synced_With_MSIH__c = false) ' 
            + ' and SystemModStamp = LAST_N_DAYS:3 order by mrs__c asc';
        String q2 = 'select id from mrs_layer_chip_association__c where id in ' 
            + ' (select MRS_Layer_Chip_Association__c from MRS_Layer_Chip_Syncing_Status__c where Is_Synced_With_MSIH__c = false) '
            + ' and SystemModStamp = LAST_N_DAYS:3 order by ptrf__c asc';
        list<sObject> result = new list<sObject>();
        result.addAll(Database.query(q1));
        result.addAll(Database.query(q2));
        return result;
    }
    
    global void execute(Database.BatchableContext BC, List <sObject> scope) {
        
        for(sObject s: scope) {
            s.put('Trigger_MSIH_Sync_Manual__c', true);
        }
        
        if(!scope.isEmpty()) update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        //TO-DO-FINISH
    }
}