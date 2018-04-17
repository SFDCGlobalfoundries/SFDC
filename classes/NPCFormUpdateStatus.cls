/*
    Author: Zymark Ambat
    Description: This Class manages the status update of NPC Forms.
    History: 
        ZAmbat  06182013    - Code creation.
        Asolito 10012013 	- added logic to set for approval records to approved when the status is set to Closed
        ARoy	02122014	- updated code to make npc status to "Executed" on Device stage update to "Prototype"
*/

public class NPCFormUpdateStatus {

    //Added Asolito 10012013 - added logic to set for approval records to approved when the status is set to Executed
    public static void setStatusToClose(List<String> NPCIDs){                               
        List<String> approvalProcesses = new List<String>();        
        for(ProcessInstance p :[SELECT id, (SELECT id
                                              FROM WorkItems
                                              WHERE isDeleted = false
                                              LIMIT 1) 
                                  FROM ProcessInstance
                                  WHERE targetObjectId IN :NPCIDs
                                  AND status = 'Pending'
                                  AND isDeleted = false]){
            for(ProcessInstanceWorkItem pi:p.WorkItems){                                                
                approvalProcesses.add(pi.id);
            }                                                               
        }
        
        List<Approval.ProcessWorkitemRequest> approveSteps = new List<Approval.ProcessWorkitemRequest>();
        for(String a: approvalProcesses){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Auto approve NPC record: status was set to Executed');
            req.setAction('Approve');
            req.setWorkitemId(a);
            approveSteps.add(req);           
        }
        
        try {               
            Approval.process(approveSteps);                         
        } catch (Exception e){
            System.debug('Error in approval process:' +e);
        }
        system.debug('approveSteps ===========================> ' + approveSteps.size());
    }

    public static void updateNPC(set<String> crmdids) {
        List<New_Part_Creation_Form__c> listNPC = new List<New_Part_Creation_Form__c>();
        List<String> npcIds = new List<String>();
        for (New_Part_Creation_Form__c npc : [SELECT        Id
                                                            , Device_Status__c
                                                            , NPC_Form_Status__c
                                              FROM          New_Part_Creation_Form__c
                                              WHERE         CRM_DID__c IN :crmdids]) {
            
            npc.Device_Status__c = 'Prototype';
            if(npc.NPC_Form_Status__c == 'In Execution'){
            	npcIds.add(npc.Id);
            	npc.NPC_Form_Status__c = 'Executed';	
            }                                    
            
            listNPC.add(npc);                        
        }

        if (listNPC.size() > 0) {
            update listNPC;
        }
        
        if(npcIds.size() > 0){
        	setStatusToClose(npcIds);
        }
    }

}