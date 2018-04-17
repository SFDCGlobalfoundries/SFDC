/*
Type Name: BNPTaskAssigneeCreateCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 18/08/2016
Description: This class serves controller for BNPTaskAssigneeCreate page.
Test Class: 
Change History:
*/
public class BNPTaskAssigneeCreateCtrl{
    public String selectedCountry1{get;set;}
    public String usrGrpName {get; set;}
    public Id usrGrpId {get; set;}
    public RFQ_Task_Assignee__c tskAssigneeObj {get;set;}
    public RFQ_Task_Assignee__c tskAssigneeObj1 {get;set;}
    public String outputString = '';
    public String outputString1 = '';
    public Id outputString2;
    ApexPages.standardController stdContrl = null;
    
    /**
    *  Constructor of this Controller 
    *  @name <BNPTaskAssigneeCreateCtrl>
    *  @param <ApexPages.StandardController> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    public BNPTaskAssigneeCreateCtrl(ApexPages.StandardController controller)
    {
        stdContrl = controller;
        tskAssigneeObj = (RFQ_Task_Assignee__c)controller.getRecord();
        Id tskAssigneeId = tskAssigneeObj.id;
        //Map<String,String> parameters = ApexPages.currentPage().parameters();
        System.debug('task Assignee : ' +tskAssigneeObj);
        if(tskAssigneeId != null){
            tskAssigneeObj1 = [Select id, Task_Assignee__c, Task_Assignee_Id__c  from RFQ_Task_Assignee__c Where id =: tskAssigneeId];
            String getParName = ApexPages.currentPage().getParameters().get('retUrl');
            if(getParName != ''){
                usrGrpName = tskAssigneeObj1.Task_Assignee__c;
                usrGrpId = tskAssigneeObj1.Task_Assignee_Id__c;
            }
        }
        
    }
    
    /**
    *  The getter method used in the page to display Assignee Type (User, Group)
    *  @name <getCountriesOptions>
    *  @param <NA>
    *  @return <List<SelectOption>>
    *  @throws exception-<exception description>
    */
    public List<SelectOption> getCountriesOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('User','User'));
        countryOptions.add(new SelectOption('Group','Group'));
        
 
        return countryOptions;
    }
    
    /**
    *  The Purpose of this method is to create Task Assignee 
    *  @name <Save>
    *  @param <NA> 
    *  @return <pageReference>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    public pageReference Save(){
        
        if(usrGrpName != null && usrGrpName != ''){
            system.debug('Hiiiiiiiiiii');
            system.debug('usrGrpName :' +usrGrpName);
            if(selectedCountry1 == 'User'){
                system.debug('selectedCountry1 :' +selectedCountry1);
                 List<User> usr = [Select id, Email, Name from User Where Name =: usrGrpName and IsActive =: true Limit 1];
                 system.debug('usrList :' +usr.size());
                 if(usr.size() > 0){
                    outputString = usr[0].Email;
                    outputString1 = usr[0].id;
                    outputString2 = usr[0].id;
                 }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please enter valid User'));
                    return null;
                 }
             
            }else if(selectedCountry1 == 'Group'){
                List<Group> usrGrpIdNew = [Select id, Name from Group Where Name =: usrGrpName Limit 1];
                if(usrGrpIdNew.size() > 0){
                    Map <Id, List<Id>> grpIdMemberIdMap = getGroupMembersId(usrGrpIdNew[0].id);
                    List<Id> usrIdList = new List<Id>();
                    if(!grpIdMemberIdMap.isEmpty()){
                        outputString2 = usrGrpIdNew[0].id;
                        for(String userId : grpIdMemberIdMap.get(usrGrpIdNew[0].id)){
                            outputString1 += userId+','; 
                            usrIdList.add(userId);
                        }
                        List<User> usrEmailList = [Select id, Email, Name from User Where id In: usrIdList];
                        
                        for(User usrEmail : usrEmailList){
                            outputString += usrEmail.Email+',';
                        }
                        
                        System.debug('Before :' +outputString);
                        outputString = outputString.removeEnd(',');
                        outputString1 = outputString1.removeEnd(',');
                        System.debug('After :' +outputString);
                    }
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please enter valid group'));
                    return null;
                }
            }
            tskAssigneeObj.Task_Assignee_Email__c = outputString;
            tskAssigneeObj.All_Task_Assignee_Id__c = outputString1;
            tskAssigneeObj.Task_Assignee_Id__c = outputString2;
            tskAssigneeObj.Task_Assignee__c = usrGrpName;
         
        }
        system.debug('User/Group Id :' +usrGrpId);
        try{
            upsert tskAssigneeObj;
        }catch(Exception excp){
            GlobalUtility.logMessage('Error','BNPTaskAssigneeCreateCtrl','Save','','Exception while creating Task Assignee',String.valueof(excp.getMessage()),'','BnP',excp,0);
            return null;
        }
        return new PageReference('/' + tskAssigneeObj.id);
    }
    
    /**
    *  The Purpose of this method is to return to previous page. 
    *  @name <cancel>
    *  @param <NA> 
    *  @return <pageReference>
    *  @throws exception-<exception description>
    */
    public PageReference cancel()
    {
        return stdContrl.cancel();
    }
    
    /**
    *  The Purpose of this method is to redirect to BNPTaskAssigneeGroupCreation page. 
    *  @name <refreshsection>
    *  @param <NA> 
    *  @return <pageReference>
    *  @throws exception-<exception description>
    */
    public pageReference refreshsection(){
        PageReference pageRef = new PageReference('/apex/BNPTaskAssigneeGroupCreation');
        return pageRef;
    }
    
    /**
    *  Returns Map of Group Id and its related Group Member Ids. 
    *  @name <getGroupMembersId>
    *  @param <Id> 
    *  @return <Map <Id, List <Id>>>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    public static Map <Id, List <Id>> getGroupMembersId(Id groupIdNew) {
        Map <Id, List <String>> returnGroupMembers = new Map <Id, List <String>> ();
        Map <Id, Id> mapGroupSubGroupId = new Map <Id, Id> ();
        List <GroupMember> groupMembers = new List <GroupMember> ();
        List <GroupMember> subGroupMembers = new List <GroupMember> ();
        List <Id> subGroupsIds = new List <Id> ();
        Id[] groupMemberIds = new list<Id>();

        try {
            Map <Id, List <Id>> mapGroupMembers = new Map <Id, List <Id>> ();
            if (groupIdNew != null)
                groupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId =: groupIdNew];
            if (groupMembers != null && groupMembers.size() > 0) {
                for (GroupMember gm: groupmembers) {
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = gm.GroupId;
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                   } else {
                        subGroupsIds.add(gm.UserOrGroupId); // if group members are groups get those groups members
                        if (!mapGroupMembers.containsKey(gm.UserOrGroupId))
                            mapGroupSubGroupId.put(gm.UserOrGroupId, gm.GroupId);
                    }
                }
            }
            //Iterate through only 1 sub-group level where the group member is another.
            if (subGroupsIds != null && subGroupsIds.size() > 0)
                subGroupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: subGroupsIds Limit 100];
    
            if (subGroupMembers != null && subGroupMembers.size() > 0) {
                for (GroupMember gm: subGroupMembers) {
                    
                    if (!((string) gm.UserOrGroupId).startsWith('00G')) {
                        Id groupId = mapGroupSubGroupId.get(gm.GroupId);
                        if (mapGroupMembers.containsKey(groupId)) {
                            mapGroupMembers.get(groupId).add(gm.UserOrGroupId);
                        } else {
                            mapGroupMembers.put(groupId, new List < Id > {
                                gm.UserOrGroupId
                            });
                        }
                        groupMemberIds.add(gm.userOrGroupId);
                    }
                }
            }
            
            // Keep trying to get users from GroupMember.userOrGroupId.
            if(mapGroupMembers !=null && mapGroupMembers.size()>0){
                
                Map<Id, User> users = new Map<Id, User>([select Id,Email, Name from User where (Id In :groupMemberIds) and (isActive=true) Limit 1000]);
                Set<Id> setUsers = users.keySet();
                
                for (Id groupId: mapGroupMembers.keySet()) {
                    // The "key" variable is also available inside the loop
                    List<Id> listUsers = mapGroupMembers.get(groupId);
                    for (Id userId: listUsers) {
                        if(setUsers.Contains(userId)){
                            User usr = users.get(userId);
                            if (returnGroupMembers.containsKey(groupId)) {
                                //returnGroupMembers.get(groupId).add(userId);
                                returnGroupMembers.get(groupId).add(usr.Id);
                            } else {
                                /*returnGroupMembers.put(groupId, new List <Id> {
                                    userId
                                });*/
                                returnGroupMembers.put(groupId, new List <String> {
                                    usr.Id
                                });
                            }
                        }
                    }
                }
            }
        } catch (Exception excp) {
            //e.getMessage();
            GlobalUtility.logMessage('Error','BNPTaskAssigneeCreateCtrl','getGroupMembersId','','Exception while fetching group members',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
        return returnGroupMembers; // return group members with group members email id
    }  
}