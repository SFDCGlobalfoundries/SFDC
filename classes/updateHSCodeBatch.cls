global class updateHSCodeBatch implements Database.Batchable<sObject>{

global Database.QueryLocator start(Database.BatchableContext BC){

      return Database.getQueryLocator([Select id,Reticle_workflow_Status__c from Reticle__c where Reticle_workflow_Status__c='Pending for Fab\'s Follow-up' 
                                       and ROS_Status__c='Return' and HS_Code_Assigned__c=false]);
   
   }

global void execute(Database.BatchableContext BC, List<Reticle__c> scope){
    
     for(Reticle__c rt : scope){
         rt.Reticle_workflow_Status__c='Pending HS Code Assignment';
     }
     database.update(scope,false);
    }
    
     global void finish(Database.BatchableContext info){    
   }

    
}