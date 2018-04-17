/* 
* @ Author : Amit Kumar Ojha
* @ Company : JK Technosoft Ltd
*/
public class AddRemoveTeamRoomITARPermSet {
    /* 
* @Method Name : addUsersToPermissionSet
* @Parameters : Set<Id>, String
* @returnType : None
* Description : This method has been written to insert all Internal Users as Assignee into the Restricted Team Room Permission Set when ever the Team Room ITAR is checked
* History : 10.08.2017 - Written the Method Logic
  @Author:Dinesh Suggala
  @ModifiedDate:07/03/2018
  @Reason- Modified the logic in addUsersToPermissionSet() .
*/
    
    @future 
    public static void addUsersToPermissionSet(Set<Id> UserIds, String pSetName){
        //Grab all the required fields from user, essential to test class
        PermissionSet pSet = [SELECT Id FROM PermissionSet WHERE Name =: pSetName];
        List<PermissionSetAssignment> prmisonSetAssign = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> insertPermAssign = new List<PermissionSetAssignment>();
        
        if(pSet.Id != null) {
            prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSetId =: pSet.Id];
        }
		
		//Added by Dinesh 7/3/2018
        set<Id> userAssigneeSet=new set<Id>();
        for(PermissionSetAssignment psassign:prmisonSetAssign){
         userAssigneeSet.add(psassign.AssigneeId);
        }
        //Ended by Dinesh
        
        if(!prmisonSetAssign.isEmpty()) {
                    for(Id i : UserIds) {
					if(!userAssigneeSet.contains(i)){ 
                        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pSet.Id, AssigneeId = i);
                        insertPermAssign.add(psa);
                    }	
                }
        }
		else {
            for(Id i : UserIds) {
                PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pSet.Id, AssigneeId = i);
                insertPermAssign.add(psa);
            }	
        }
        
        if(!insertPermAssign.isEmpty()) {
            try {
                insert insertPermAssign;
            } catch(Exception e){
                system.debug('@@'+e.getMessage());
            }
        }
    }
    
    /* 
* @Method Name : removeUsersFromPermissionSet
* @Parameters : Set<Id>, String
* @returnType : None
* Description : This method has been written to remove all Internal Users as Assignee from the Restricted Team Room Permission Set when ever the Team Room ITAR is unchecked
* History : 10.08.2017 - Written the Method Logic
*/
    
    @future 
    public static void removeUsersFromPermissionSet(Set<Id> assignedUserIds, String pSetName){
        PermissionSet pSet = [SELECT Id FROM PermissionSet WHERE Name =: pSetName];
        
        List<PermissionSetAssignment> deletePermAssign = new List<PermissionSetAssignment>();
        
        if(!assignedUserIds.isEmpty()) {
            if(pSet.Id != null) {
                deletePermAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE PermissionSet.Id =: pSet.Id AND AssigneeId IN: assignedUserIds];
            }		
        }
        
        if(!deletePermAssign.isEmpty()) {
            try {
                delete deletePermAssign;
            } catch(Exception e){
                system.debug('@@'+e.getMessage());
            }
        }
    }   
    
}