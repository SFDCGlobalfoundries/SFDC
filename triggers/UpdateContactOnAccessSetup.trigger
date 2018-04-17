/*
Project      : Foundry View 
Name         : UpdateContactOnAccessSetup 
Author       : Cognizant 
Created Date : 4-july-2013
Reason       :  To update a field contact in AccessSetup object based on the user selected.
Change History:
Author       : Bhavana Mohan 
Modified Date: 02-August-2017
Author       : Amit Kumar Ojha
Reason       : Adding ITAR Apps Access and to send notification to Compliance Team on different Apps selection
……..
……..
*/
trigger UpdateContactOnAccessSetup on Portal_Tab_Access__c (before insert, before update, after update) {
    List<User> userList = new List<User>();
    List<ID> userIdList = new List<ID>();
    Map<ID,ID> userContactId = new Map<ID,ID>();
    Map<ID,String> ContactShortNameId = new Map<ID,String>();
    Map<ID,User> UserContactDetails = new Map<ID,User>();
    Set<Id> contactIds = new Set<Id>();
    List<Contact> contactList = new List<Contact>();
    Set<Id> userIds = new Set<Id>();
    Set<Id> assignedUsers = new Set<Id>();
    
    if(Trigger.isBefore) {   
        for(Portal_Tab_Access__c accessSetup : Trigger.new)
        {
            if(accessSetup.User__c != null)
            {
                userIdList.add(accessSetup.User__c);
            }
        }
        
        if(userIdList != null && userIdList.size()>0)
        {
            userList = [Select u.Id,
                        u.Contact.Account_Short_Name__c,
                        u.ContactId,
                        u.Contact.Contact_Short_Name__c, 
                        u.Contact.CreatedById,
                        u.Contact.CreatedDate,
                        u.Contact.Email,
                        u.Contact.Fax,
                        u.Contact.FirstName,
                        u.Contact.CreatedByHCMLoginId__c,
                        u.Contact.LastModifiedByHCMLoginId__c,                          
                        u.Contact.HCM_Login_Id__c,
                        u.Contact.Is_Portal_User_Active__c,
                        u.Contact.Login_Id__c,
                        u.Contact.Phone,
                        u.Contact.LastModifiedById,
                        u.Contact.LastModifiedDate,
                        u.Contact.LastName,
                        u.Contact.Role__c,
                        u.Contact.Title
                        From User u where u.Id IN : userIdList and IsActive = true];
        }
        
        for(User usr : userList)
        {
            UserContactDetails.put(usr.id,usr);
        }
        for(Portal_Tab_Access__c accessSetup : Trigger.new) {
            if(UserContactDetails.containskey(accessSetup.User__c)) {
                accessSetup.Contact__c = UserContactDetails.get(accessSetup.User__c).ContactId;
                accessSetup.Contact_Short_Name__c = UserContactDetails.get(accessSetup.User__c).Contact.Contact_Short_Name__c;
                //accessSetup.Contact_Fax__c = UserContactDetails.get(accessSetup.User__c).Contact.Fax;
                accessSetup.Contact_CreatedByHCMLoginId__c = UserContactDetails.get(accessSetup.User__c).Contact.CreatedByHCMLoginId__c;
                accessSetup.Contact_CreatedDate__c = UserContactDetails.get(accessSetup.User__c).Contact.CreatedDate;
                accessSetup.Contact_Email__c = UserContactDetails.get(accessSetup.User__c).Contact.Email;
                accessSetup.Contact_FirstName__c = UserContactDetails.get(accessSetup.User__c).Contact.FirstName;
                accessSetup.Contact_HCM_Login_Id__c = UserContactDetails.get(accessSetup.User__c).Contact.HCM_Login_Id__c ;
                accessSetup.Contact_Is_Portal_User_Active__c = UserContactDetails.get(accessSetup.User__c).Contact.Is_Portal_User_Active__c ;
                accessSetup.Contact_ModifiedHCMLoginId__c = UserContactDetails.get(accessSetup.User__c).Contact.LastModifiedByHCMLoginId__c;
                accessSetup.Contact_LastModifiedDate__c = UserContactDetails.get(accessSetup.User__c).Contact.LastModifiedDate;
                accessSetup.Contact_LastName__c = UserContactDetails.get(accessSetup.User__c).Contact.LastName;
                accessSetup.Contact_Login_Id__c = UserContactDetails.get(accessSetup.User__c).Contact.Login_Id__c;
                accessSetup.Contact_Phone__c = UserContactDetails.get(accessSetup.User__c).Contact.Phone;
                accessSetup.Contact_Role__c = UserContactDetails.get(accessSetup.User__c).Contact.Role__c;
                accessSetup.Contact_Title__c = UserContactDetails.get(accessSetup.User__c).Contact.Title;
                accessSetup.Contact_Title__c = UserContactDetails.get(accessSetup.User__c).Contact.Title;
                accessSetup.Contact_AccountShortName__c =  UserContactDetails.get(accessSetup.User__c).Contact.Account_Short_Name__c;
                accessSetup.PCN_End_of_Life__c = true;
            }
        }
    }
    
    // After Update Trigger for ITAR Provisioning
    if(!IntegrationUserUtil.isSkipTrigger()) {
        PermissionSet pSet = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Restricted_Team_Room_Permission_Set_for_External_Users' LIMIT 1];
        List<PermissionSetAssignment> prmisonSetAssign = new List<PermissionSetAssignment>();
        Map<Id,PermissionSetAssignment> permissionSetMap = new Map<Id,PermissionSetAssignment>();
        if(Trigger.isAfter && Trigger.isUpdate) {
            if(pSet.Id != null) {
                prmisonSetAssign = [SELECT AssigneeId,PermissionSetId FROM PermissionSetAssignment where PermissionSetId =: pSet.Id];
            }
            if(!prmisonSetAssign.isEmpty()) {
                for(PermissionSetAssignment assign : prmisonSetAssign) {
                    permissionSetMap.put(assign.AssigneeId,assign);
                }
            }
            
            for(Portal_Tab_Access__c accessSetup : Trigger.New) {
                if(accessSetup.Contact__c != null) {
                    contactIds.add(accessSetup.Contact__c);
                }
            }
            
            if(!contactIds.isEmpty()) {
                contactList = [SELECT Id, ITAR_Certified__c FROM Contact WHERE Id IN : contactIds];		
            }
            
            if(!contactList.isEmpty()) {
                for(Portal_Tab_Access__c accessSetup : Trigger.New) {
                    if(Trigger.oldMap.get(accessSetup.Id).TeamRoom_ITAR__c != true && accessSetup.TeamRoom_ITAR__c == true){
                        if(!prmisonSetAssign.isEmpty() && !permissionSetMap.isEmpty() && !permissionSetMap.containsKey(accessSetup.User__c)) {
                            if(!userIds.contains(accessSetup.User__c)) {
                                userIds.add(accessSetup.User__c);	
                            }
                        } else if(prmisonSetAssign.isEmpty() && !permissionSetMap.isEmpty() && !permissionSetMap.containsKey(accessSetup.User__c)){
                            if(!userIds.contains(accessSetup.User__c)) {
                                userIds.add(accessSetup.User__c);	
                            }
                        } else if(permissionSetMap.isEmpty()) {
                            if(!userIds.contains(accessSetup.User__c)) {
                                userIds.add(accessSetup.User__c);	
                            }
                        }
                    }
                    if(accessSetup.TeamRoom_ITAR__c == false && Trigger.oldMap.get(accessSetup.Id).TeamRoom_ITAR__c != false) {
                        if(!permissionSetMap.isEmpty() && permissionSetMap.containsKey(accessSetup.User__c)) {
                            assignedUsers.add(accessSetup.User__c);
                            
                        }
                    }		
                }
            }		
            for(Portal_Tab_Access__c accessSetup : Trigger.New) {
                if((accessSetup.DropBox_ITAR__c && !trigger.oldMap.get(accessSetup.Id).DropBox_ITAR__c) ||
                   (accessSetup.DropBox_non_ITAR__c && !trigger.oldMap.get(accessSetup.Id).DropBox_non_ITAR__c) ||
                   (accessSetup.Remote_Mask_Viewer_ITAR__c && !trigger.oldMap.get(accessSetup.Id).Remote_Mask_Viewer_ITAR__c) ||
                   (accessSetup.Remote_Mask_Viewer_non_ITAR__c && !trigger.oldMap.get(accessSetup.Id).Remote_Mask_Viewer_non_ITAR__c) ||
                   (accessSetup.TeamRoom_ITAR__c && !trigger.oldMap.get(accessSetup.Id).TeamRoom_ITAR__c)){
                       // Notify the User on ITAR Apps on Access Set up, only if the ITAR Certified is checked in Contact 		
                       ITAR_Certified_Utility.notifyExternalUsersonAppProvision(Trigger.oldMap, Trigger.newMap);
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