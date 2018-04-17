/*
    Author: Nino Bustillos
    Description: Creates new contact during HCM Employee insert and updates contact during update.
    History:
        Nbustillos  01242013    - Code creation.
        Nbustillos  01252013    - Added upsert logic.
        Nbustillos  01282013    - Added code logic for status field.
        @ Change history: 19.07.2017 / Amit Kumar Ojha / Invoked the ITAR Certification Helper Class
        @ Change history: 11.08.2017 / Amit Kumar Ojha / For TeamRoom ITAR Permission Set Assignment
	    @ Change history: 07/03/2018 / Dinesh Suggala / Added one more condition "&& psAssig.AssigneeId==hcmEmployee.User__c"
*/
trigger HCMEmployeeSyncToContact on HCM_Employee__c (after insert, after update, before update) {
    
    Set<String> hcmRecordIds = new Set<String>();
    String gfAccountID = EnvironmentVariable.get('HCM Emp AccountId');
    Set<Id> assignedUsers = new Set<Id>();
	List<PermissionSetAssignment> deletePermAssign = new List<PermissionSetAssignment>();
	List<PermissionSetAssignment> insertPermAssign = new List<PermissionSetAssignment>();
	List<PermissionSetAssignment> prmisonSetAssign = new List<PermissionSetAssignment>();
    
	if(Trigger.isAfter) {
		for(HCM_Employee__c hcmEmployee : trigger.new){
			// get id if there are any changes on firstname, lastname, email
			if(trigger.isUpdate){
				if((hcmEmployee.First_Name__c!=trigger.oldMap.get(hcmEmployee.Id).First_Name__c) || 
				   (hcmEmployee.Last_Name__c!=trigger.oldMap.get(hcmEmployee.Id).Last_Name__c) ||
				   (hcmEmployee.Email_Address__c!=trigger.oldMap.get(hcmEmployee.Id).Email_Address__c) ||
				   (hcmEmployee.Status__c!=trigger.oldMap.get(hcmEmployee.Id).Status__c)){
					
					hcmRecordIds.add(hcmEmployee.Id);
				}
			}else{
				hcmRecordIds.add(hcmEmployee.Id);
			}
		}
    
		// Insert/update new information.
		List<Contact> contactsToUpsert = new List<Contact>();
		for(String HCMId : hcmRecordIds){
			HCM_Employee__c hcmEmployee = trigger.newMap.get(HCMId);
			contactsToUpsert.add(new Contact(FirstName=hcmEmployee.First_Name__c,
											 LastName=hcmEmployee.Last_Name__c,
											 Email=hcmEmployee.Email_Address__c,
											 Status__c=hcmEmployee.Status__c,
											 HCM_Record_ID__c=hcmEmployee.Id,
											 AccountId=gfAccountID));                       
		}
		
		if(contactsToUpsert.size()>0){
			upsert contactsToUpsert HCM_Record_ID__c;
		}
		
		// Checking if the Logged in User is a Sys Admin
		Boolean isSysAdmin = false;
		
		// Get the logged in User Profile
		List<User> userList = new List<User>();
		userList = [SELECT Id, ProfileId, Profile.Name FROM User WHERE Id =: Userinfo.getUserId() AND isActive = true AND Profile.Name = 'System Administrator' LIMIT 1];
		
		if(!userList.isEmpty()) { 
			isSysAdmin = true;       
		}
		
		// Don't allow Users with Admin Profile and Users with Integration Profile to access ITAR Apps.
		if (!IntegrationUserUtil.isSkipTrigger() || !isSysAdmin) {
			// This Update Operation should only work for ITAR Apps Section
			// Checking for TeamRoom ITAR Permission Set Assignment
			PermissionSet pSet = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Restricted_Team_Room_Permission_Set' LIMIT 1];
			List<PermissionSetAssignment> prmisonSetAssign = new List<PermissionSetAssignment>();
			Map<Id,PermissionSetAssignment> permissionSetMap = new Map<Id,PermissionSetAssignment>();
		   
			if(pSet.Id != null) {
				prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSetId =: pSet.Id];
			}
			
			if(!prmisonSetAssign.isEmpty()) {
			   for(PermissionSetAssignment assign : prmisonSetAssign) {
					permissionSetMap.put(assign.AssigneeId,assign);
			   }
		    }
	            
			if(Trigger.isUpdate) {
				for(HCM_Employee__c hcmEmployee : trigger.new){
					if((hcmEmployee.ITARCertified__c != trigger.oldMap.get(hcmEmployee.Id).ITARCertified__c) || 
					   (hcmEmployee.ITAR_EndDate__c != trigger.oldMap.get(hcmEmployee.Id).ITAR_EndDate__c) ||
					   (hcmEmployee.DropBox_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).DropBox_ITAR__c) ||
					   (hcmEmployee.DropBox_Non_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).DropBox_Non_ITAR__c) ||
					   (hcmEmployee.Conferencing_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).Conferencing_ITAR__c) || 
					   (hcmEmployee.Remote_Mask_Viewer_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).Remote_Mask_Viewer_ITAR__c) ||
					   (hcmEmployee.Remote_Mask_Viewer_Non_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).Remote_Mask_Viewer_Non_ITAR__c)){
					   //(hcmEmployee.TeamRoom_ITAR__c && !trigger.oldMap.get(hcmEmployee.Id).TeamRoom_ITAR__c)){
					   
						// Calling the ITAR App Provisioning Features
						ITAR_Certified_Utility.appProvisionInternalUserAlert(Trigger.oldMap, Trigger.newMap);
					}
					
					Set<Id> userIds = new Set<Id>();
					
					if(Trigger.oldMap.get(hcmEmployee.Id).TeamRoom_ITAR__c != true && hcmEmployee.TeamRoom_ITAR__c && !prmisonSetAssign.isEmpty() && !permissionSetMap.isEmpty() && !permissionSetMap.containsKey(hcmEmployee.User__c)) {
						if(!userIds.contains(hcmEmployee.User__c)) {
							userIds.add(hcmEmployee.User__c);
						}
					} else if(Trigger.oldMap.get(hcmEmployee.Id).TeamRoom_ITAR__c != true && hcmEmployee.TeamRoom_ITAR__c && prmisonSetAssign.isEmpty()){
						if(!userIds.contains(hcmEmployee.User__c)) {
							userIds.add(hcmEmployee.User__c);
						}	
					} else if(Trigger.oldMap.get(hcmEmployee.Id).TeamRoom_ITAR__c != false && hcmEmployee.TeamRoom_ITAR__c == false) {
						if(!prmisonSetAssign.isEmpty()) {
							for(PermissionSetAssignment psAssig : prmisonSetAssign){
								if(psAssig.AssigneeId != null && psAssig.AssigneeId==hcmEmployee.User__c) {
								
										assignedUsers.add(psAssig.AssigneeId);
								
								}
							}
						}
					}
					if(!userIds.isEmpty()) {
						AddRemoveTeamRoomITARPermSet.addUsersToPermissionSet(userIds, pSet.Name);	
					}
					
					if(!assignedUsers.isEmpty()) {
						AddRemoveTeamRoomITARPermSet.removeUsersFromPermissionSet(assignedUsers, pSet.Name);
					}
				}
			}
		}
	}
	/*else if (Trigger.isBefore) {
		if(Trigger.isUpdate) {
			for(HCM_Employee__c hcmEmployee : Trigger.New) {
				if(hcmEmployee.ITARCertified__c && Trigger.oldMap.get(hcmEmployee.Id).ITARCertified__c == false) {
					hcmEmployee.TeamRoom_ITAR__c = true;
				} 
			}
		}
    } */   
}