/*
- First created sometime in 2015 to to data migration for swgp-270
- now update to do data migration for swgp-998
this batch class is used to backpatching existing layer/layer chip records to have their associated shadow object

Recommend batch size: 200
*/
global class Batch_SendDataMigration implements Database.Batchable < sObject > {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select id from mrs_layer_association__c where id not in (select MRS_Layer_Association__c from MRS_Layer_Syncing_Status__c)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List <mrs_layer_association__c> scope) {
        list<mrs_layer_chip_association__c> lchip = [
            select id 
            from mrs_layer_chip_association__c 
            where layer__c in :scope 
                and id not in (select MRS_Layer_Chip_Association__c from MRS_Layer_Chip_Syncing_Status__c)
        ];
        
        list<MRS_Layer_Syncing_Status__c> t1 = new list<MRS_Layer_Syncing_Status__c>();
        list<MRS_Layer_Chip_Syncing_Status__c> t2 = new list<MRS_Layer_Chip_Syncing_Status__c>();
        
        for(mrs_layer_association__c m: scope) {
            t1.add(new MRS_Layer_Syncing_Status__c(MRS_Layer_Association__c = m.Id));
        }
        
        for(mrs_layer_chip_association__c m: lchip) {
            t2.add(new MRS_Layer_Chip_Syncing_Status__c(MRS_Layer_Chip_Association__c = m.id));
        }
        
        insert t1;
        insert t2;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}