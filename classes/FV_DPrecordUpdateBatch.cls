/*
/*
Project      : FoundryView
Name         : FV_DPrecordUpdate
Author       : GF- Prajnith Karra
Created Date : 21/1/2015
Reason       : Batch Class to update all DP records one by one.
               Batch size 1 to be maintained becasue OT team can't handle more records in queue.
Id batchInstanceId = Database.executeBatch(new FV_DPrecordUpdateBatch(), 1);
               
 
*/

global class FV_DPrecordUpdateBatch implements Database.Batchable<sObject>{

    global final String query = 'Select ID from Sub_PDK__c WHERE Sub_PDK_Lifecycle_Phase__c != \''+ 'OBSOLETE' + '\' LIMIT 49999';
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sobject>  scope){
        List<Sub_PDK__c> PDKList = (List<Sub_PDK__c>)scope;
        for(Sub_PDK__c sc : PDKList){            
            FV_DPrecordUpdate.updateDPrecord(''+sc.ID);
        }
    }
    
     global void finish(Database.BatchableContext BC){}
     
    
}