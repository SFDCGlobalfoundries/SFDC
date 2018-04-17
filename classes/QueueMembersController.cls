/*
Type Name: QueueMembersController
Author: Cognizant Case Management Team
Created Date: 23-Mar-2015
Reason: Reason: This is the controllar class for QueueMembers page.
Test Class: QueueMembersControllerTest
Change History:
Author: 
Modified Date: 
……..
……..
--
*/
public class QueueMembersController{
 
    // selected queue whose members to view
    public ID queueId { get; set; }
    public string objectName { get; set; }
    public String fullname{get; set;}
    
    public list<CaseSubClass> userList {get; set;}
    
    // provide queue name to show on page
    public Group getselectedQueue() {
            Group objGroup;
            if(queueId !=null)
                objGroup = [SELECT id, name FROM group WHERE id = :queueId]; 
            return objGroup;
    }
    
    public static Set<id> GetUserIdsFromGroup(Id groupId)
    {
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();

        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId])
        {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType))
            {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType))
            {
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }

        return result;  
    }
    
    // list of all active queue members
    public List<User> getqueueMembers() {
        Set<Id> userIds = new Set<Id>(GetUSerIdsFromGroup(queueId));
            
        return [ SELECT id, firstName, lastName, alias, isactive, username, email, userRole.name, profile.name FROM user
                WHERE id In: userIds AND isactive =true ORDER BY firstName Limit 100];
    }
    
    /**
     * Controller
     */
    public QueueMembersController() {
        userList = new list < CaseSubClass > ();        
        queueId = ApexPages.currentPage().getParameters().get('queueId');
        if(ApexPages.currentPage().getParameters().get('object') !=null){
            objectName = (string)(ApexPages.currentPage().getParameters().get('object')).toLowerCase();
         }
        
    }
    
    public PageReference refresh() {
        return null;
    }
    public  void searchUser(){
        if (!isNotBlank(fullname)) {
            if (userList != null) {
                userList.clear();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, System.Label.CC_to_Case_Search_String_Error));
        }else{
            getUserIds();
            if (!(userList != null && userList.size()>0)) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No match found.'));
            }
        }
    }
    // return list of all groups the user belongs to via direct or indirect membership
    public list < CaseSubClass > getUserIds() {
        Set < Id > userIds = new Set < Id > ();
        Set < Id > publicGroupIds = new Set < Id > ();
        
        Map<Id,QueueSobject> quelist = new Map<Id,QueueSobject>();
        Map < Id, User > userMap = new Map < Id, User > ();
        Map < Id, Id > groupUserMap = new Map < Id, Id > ();
        
        List < Id > groupIdList = new List < Id > ();
        list < User > listUser = new list < User > ();
        list < GroupMember > listPublicMembers = new list < GroupMember > ();
        list < GroupMember > listGroup = new list < GroupMember > ();
        list < QueueSobject > listQueue = new list < QueueSobject > ();
    
        String[] filters = new String[] {
            '%' + fullname + '%'
        };
        userMap = new Map < ID, User > ([select Id, FirstName, LastName, Email, Name, UserRole.Name, Profile.Name, IsActive  from User where Name LIKE: filters ORDER BY firstName Limit 100]);
        userIds = userMap.keySet();
    
        listPublicMembers = [Select Id, GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN: userIds and Group.Type != : 'Queue'
            Limit 100
        ];
        
        for (GroupMember grp2: listPublicMembers) {
            publicGroupIds.add(grp2.GroupId);
            groupUserMap.put(grp2.UserOrGroupId, grp2.GroupId);
        }
    
        listGroup = [Select GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE(UserOrGroupId IN: userIds OR UserOrGroupId IN: publicGroupIds) AND UserOrGroupId != null and Group.Type = 'Queue'
            Limit 100
        ];
    
        for (GroupMember grp2: listGroup) {
            groupIdList.add(grp2.GroupId);
        }
    
        if (isNotBlank(objectName)) {
            listQueue = [Select QueueId, SobjectType FROM QueueSobject WHERE QueueId IN: groupIdList AND SobjectType = : objectName Limit 100];
        } else {
            listQueue = [Select QueueId, SobjectType FROM QueueSobject WHERE QueueId IN: groupIdList Limit 100];
        }
    
        for (QueueSobject qu: listQueue) {
            quelist.put(qu.QueueId, qu);
        }
        if (userList != null) {
            userList.clear();
        }
    
        for (GroupMember grp2: listGroup) {
            String sObjectName = '';
    
            if (quelist.get(grp2.GroupId) != null)
                sObjectName = quelist.get(grp2.GroupId).SobjectType;
    
            if (sObjectName != null && sObjectName != '') {
                if (((String) grp2.UserOrGroupId).substring(0, 3) == '005') {
                    User ur = userMap.get(grp2.UserOrGroupId);
                    if (ur != null)
                        userList.add(new CaseSubClass(ur, grp2.Group.Name, sObjectName));
                } else if (((String) grp2.UserOrGroupId).substring(0, 3) == '00G') {
                    for (GroupMember grp: listPublicMembers) {
                        if (grp2.UserOrGroupId == grp.GroupId && (((String) grp.UserOrGroupId).substring(0, 3) == '005')) {
                            User ur = userMap.get(grp.UserOrGroupId);
                            if (ur != null)
                                userList.add(new CaseSubClass(ur, grp2.Group.Name, sObjectName));
                        }
                    }
    
                }
            }
        }
    
        return userList;
    }
    
    // picklist of queues whose members to view
    public List<SelectOption> getQueueOptions() {
        Set<Id> setQueueIds = new Set<Id>();
        List<SelectOption> options = new List<SelectOption>();
        List<QueueSobject> listQueueSobject = new List<QueueSobject>();
        options.add( new SelectOption( '', '- Select -' ) );
        if(isNotBlank(objectName))
        {
            listQueueSobject = [Select QueueId, Queue.Name, SobjectType from QueueSobject Where SobjectType =: objectName ORDER BY Queue.Name];
        }else{
            listQueueSobject = [Select QueueId, Queue.Name, SobjectType from QueueSobject ORDER BY Queue.Name];
        }
        for (QueueSobject grp :  listQueueSobject) {                
                if(!setQueueIds.contains(grp.QueueId)){
                    setQueueIds.add(grp.QueueId);
                    options.add( new SelectOption( grp.QueueId, grp.Queue.Name) );
                 }
        }
        return options;
    }
            
    public with sharing class CaseSubClass{
        
        public User user {get; set;}
        public string GroupName {get; set;}
        public string groupRelatedObject {get; set;}        
        
        // sub-class initialization
        public CaseSubClass(User U, String grp, String objectName){
            User  = U;
            GroupName = grp;            
            if(objectName == 'Bug__c'){
                groupRelatedObject = 'Bug / Work Request';
            }else{
                groupRelatedObject = objectName;
            }
            
        }
    }
    
    /***
    * isNotBlank- check the string null or blank
    ***/
    public static Boolean isNotBlank(String val){
        if(val <> null && val <> '' && val <> 'null'){
            return true;
        }
        return false;
    }    
    
}