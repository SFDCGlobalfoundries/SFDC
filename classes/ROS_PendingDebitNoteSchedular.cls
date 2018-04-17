/*
This is used to schedule DebitNoteReminder
batch on every Monday
Author: Ravikiran Nadella
Version 1.0
*/
global class ROS_PendingDebitNoteSchedular implements Schedulable {
   global void execute(SchedulableContext SC) {
     list<reticle__c>scope = new list<reticle__c>();
 scope = [Select id,Account__c,Account__r.name,ROS_Cycle__r.name,name,Pending_Debit_Note_Date__c,
                         Reticle_workflow_Status__c from reticle__c where Reticle_workflow_Status__c='Pending Debit Note'
                         and Pending_Debit_Note_Date__c !=null ];
                         
                         if(!scope.isEmpty()){
                           
                           Ros_reticleHandler ros = new Ros_reticleHandler ();
                            ros.intiateEmails(scope);
                         
                         }
   }
}