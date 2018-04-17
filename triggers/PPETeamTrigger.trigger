/*
    Author: Anirban Roy        
    Description: Trigger on PPE Team for validation and addition/removal of users from GMPL/BX009 sharing object.
    History: 
      ARoy  03172014    - Code Creation
*/


trigger PPETeamTrigger on PPE_Team__c (after delete, after insert, after update, before delete, before insert, before update) {
    
    if(trigger.isBefore){       
        // Validate User Permission for PPE Team
        /*if(!PPETeamTriggerHandler.hasRun){            
            if(trigger.isInsert || trigger.isUpdate){
            	PPETeamTriggerHandler.validateUserPermission(trigger.new);
            }
            if(trigger.isDelete){
            	PPETeamTriggerHandler.validateUserPermission(trigger.old);
            }
            PPETeamTriggerHandler.hasRun = true;
        }*/
        
        if(trigger.isInsert){       
            //Validation for Duplicate User in PPE Team
            PPETeamTriggerHandler.validateDuplicateUser(trigger.new);                      
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            PPETeamTriggerHandler.addtoGMPLShare(trigger.new); 
            
            // Add PPE Team Member to follow GMPL
            PPETeamTriggerHandler.addPPETeamToFollowGMPL(trigger.new); 
                       
        }
        
        if(trigger.isUpdate){
        	List<PPE_Team__c> ppeList = new List<PPE_Team__c>();
        	for(PPE_Team__c ppe : trigger.new){
        		if(ppe.Access_Level__c != trigger.oldMap.get(ppe.id).Access_Level__c){
        			ppeList.add(ppe);
        		}
        	}
        	if(ppeList.size()>0){
        		PPETeamTriggerHandler.addtoGMPLShare(ppeList);
        	}
        }
        
        
        if(trigger.isDelete){
            PPETeamTriggerHandler.removeFromGMPLShare(trigger.old);
            
            // Remove PPE Team Member to follow GMPL
            PPETeamTriggerHandler.removePPETeamToFollowGMPL(trigger.old);           
        }
    }
            
}