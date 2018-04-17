/**
* Author: Surendranadh Nune
* Company: GlobalFoundries,India
* Project: New Part Creation 
* Description: This class acts as a helper for processing the records that enter NPCFormTrigger
* History:
*    SurendranadhNune 21102015  -   Created    - Created a method to fix case 47700 
*                           
**/

public with sharing class NPCFormTriggerHelper {
    
    /* Author: Surendranadh Nune
     * Description : This method is used to verify the following when CE is trying to approve/reject NPC from "Items to Approve" section:
     *               - Check if comments are entered when rejecting NPC.
     *               - Check if PI/YE users were added when approving NPC.
     */
    public static void checkPIYEAndRejectionComments(Map<id, New_Part_Creation_Form__c> newNpCMap, Map<id, New_Part_Creation_Form__c> oldNPCMap){
        Map<id, New_Part_Creation_Form__c> rejectedNpcMap = new Map<id, New_Part_Creation_Form__c>();
        Map<id, New_Part_Creation_Form__c> acceptedNpcMapWithoutPIYE = new Map<id, New_Part_Creation_Form__c>();
        List<Id> rejProcessInstanceIds = new List<Id>{};
        List<Id> acceptedProcessInstanceIds = new List<Id>{};
        
        //used to prevent error from being thrown when updating CDRS(assigning PID).
        Set<Id> npcWithPID = new Set<Id>();
        
        system.debug('%%% newNpCMap.keyset() : ' + newNpCMap.keyset() );
        
        for(BX_041__c cdrsObj : [SELECT ID, Device__r.NPC_Form__c 
                                 FROM BX_041__c 
                                 WHERE Device__r.NPC_Form__c
                                 IN: newNpCMap.keyset() 
                                 and Assigned_Process_ID__c != null
                                 and Device__r.NPC_Form__r.Reason_for_New_Part__c =: EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER')
                                ]){
                                    system.debug('inside for');
            npcWithPID.add(cdrsObj.Device__r.NPC_Form__c);
        }
        system.debug('\n\n npcWithoutPID : ' + npcWithPID);
        for(New_Part_Creation_Form__c npc : newNpCMap.values()){
            
            New_Part_Creation_Form__c oldNpc = oldNPCMap.get(npc.id);
            
            if(!(npcWithPID.contains(npc.id)) && oldnpc.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_SUBMITTED') && 
               npc.NPC_Form_Status__c == EnvironmentVariable.get('NPC_STATUS_PEND_PID_REASSIGN') && 
               npc.Approval_Status__c != oldNpc.Approval_Status__c && npc.Approval_Status__c == 'Approved' && 
               npc.Reason_for_New_Part__c == EnvironmentVariable.get('NPC_REASON_FAB_TRANSFER') &&
               npc.PIYE_Approver_1__c == null && npc.PIYE_Approver_2__c == null && npc.PIYE_Approver_3__c == null && npc.PIYE_Approver_4__c == null){
                
                npc.addError('<b><font color="red">Please add PI/YE users for approving NPC.</font></b> &nbsp;&nbsp;'+
                             '<a id="linkToNPC" href="#" onClick="changeUrl();">Click here to NPC </a>'+
                             '<script>function changeUrl(){ var url="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+npc.id+'"; window.location.href = url;}</script>');
            }
            
            //Rejected NPC
            if(npc.Approval_Status__c != oldNpc.Approval_Status__c && npc.Approval_Status__c == 'Rejected'){
                rejectedNpcMap.put(npc.id, npc);
            }
        }
        if(rejectedNpcMap.keyset().size() > 0){
    
        for (New_Part_Creation_Form__c npc : [SELECT (SELECT ID
                                                  FROM ProcessInstances
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1)
                                          FROM New_Part_Creation_Form__c
                                          WHERE ID IN :rejectedNpcMap.keySet()]){
            if(npc.ProcessInstances != null && npc.ProcessInstances.size() > 0)
                rejProcessInstanceIds.add(npc.ProcessInstances[0].Id);
        }
        
        for (ProcessInstance pi : [SELECT TargetObjectId,id,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1)
                                   FROM ProcessInstance
                                   WHERE Id IN :rejProcessInstanceIds
                                   ORDER BY CreatedDate DESC]){ 
          if(pi.steps != null && pi.steps.size() > 0){                                                    
              if ((pi.Steps[0].Comments == null || 
                   pi.Steps[0].Comments.trim().length() == 0))
              {
                rejectedNpcMap.get(pi.TargetObjectId).addError('<b><font color="red">Please enter Comments for rejecting NPC.</font></b> &nbsp;&nbsp;'+
                                                               '<a id="linkToApprovalPage" href="javascript:history.go(-1)">< Back </a>');
              }
          }
        }
        }  
    }
}