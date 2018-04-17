/*
This is batch class runs on every Monday
and sends an email to CSRs about Debit Note
Author: Ravikiran Nadella
Version 1.0
*/
global class ROS_DebitNoteReminderBatch implements database.batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){
        return Database.getQueryLocator([Select id,Account__c,Account__r.name,ROS_Cycle__r.name,name,Pending_Debit_Note_Date__c,Reticle_workflow_Status__c
                                         from reticle__c where Reticle_workflow_Status__c='Pending Debit Note'
                                         and Pending_Debit_Note_Date__c !=null ]);
        
    }
    
    global void execute(Database.BatchableContext info, List<reticle__c> scope){
        
        Ros_reticleHandler ros = new Ros_reticleHandler ();
        ros.intiateEmails(scope);
    }
    
    global void finish(Database.BatchableContext info){
        
    }  
    
    
    
}