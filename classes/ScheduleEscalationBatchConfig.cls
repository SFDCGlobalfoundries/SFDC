/******************************************************************************************************************************
Class:         ScheduleEscalationBatchConfig
-------------------------------------------------------------------------------------------------------------------------------
Author:        Karna Shiva (GF - 1016934)
Created Date:  06/04/2016
Reason:        This class will schedule the ApprovalEscalationBatchConfig batch class for
               sending escalation email to Approvers managers.
History:       

*******************************************************************************************************************************/
global class ScheduleEscalationBatchConfig implements Schedulable{
     global void execute(SchedulableContext sc) {

      String ObjectName ='Apttus_Proposal__Proposal__c',Status='Pending';
      Integer Days =5;
        ApprovalEscalationBatchConfig b = new ApprovalEscalationBatchConfig(ObjectName,Days,Status); 
    
        database.executebatch(b,1500);
     }
 }