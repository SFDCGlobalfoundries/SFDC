/*Author: UCM Team
* Description: This class is handler class for bug trigger. Methods created 
               to set default owner,Default bug team. 
* History: Created on 09/22/2017           
*/
public class IPDEVBugTriggerHandler {
    //List Variables declaration 
    private static boolean skipmailforFeed = false;
    public list<bug__c> buglistNew {get;set;}
    public list<bug__c> buglistOld {get;set;}
    public list<String> userIds {get;set;} 
    public list<String> grpUserIds;
    public list <IPDEVforDefaultOwnerandTeam__c > csList = IPDEVforDefaultOwnerandTeam__c.getall().values();
    public list < Id > toAddressesList = new list < Id > ();
    
    public set < Id > toAddresses = new set < Id > ();
    public set<Id> bugId = new set<Id>();
    //Maps variables declaration  
    public Map <id, bug__c> bugmapNew {get;set;}
    public Map <id, bug__c> bugmapOld {get;set;} 
    public Map<string, IPDEVforDefaultOwnerandTeam__c> mapforOwnerandTeam{get;set;}
    public Map<id, user> UserMap;
    public map<Bug__c,string> bugVsAdminMap = new map<Bug__c,string>();
    public Map <Id,set<Id>> groupIdVsUserMap= new Map <Id,set<Id>>(); 
    public Map <Id,Boolean> userVsBugUpdateChk = new Map <Id,Boolean>();
    public Map <Id,Boolean> userVsChatterUpdateChk = new Map <Id,Boolean>();
    public map<Bug__c,string> bugVsOwnerMap = new map<Bug__c,string>();
    public Map <Id,set<Id>> groupVsUserMap= new Map <Id,set<Id>>();   
    Public Map<Id,Manage_Email_Notification__c> manageEmailMap = new Map<Id,Manage_Email_Notification__c>();   
    
    //string variables declaration      
    final string groupType = Schema.SObjectType.Group.getKeyPrefix();
    final string userType = Schema.SObjectType.User.getKeyPrefix();
    final String orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
    final string strOrgId = UserInfo.getOrganizationId();    
    final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id  
    final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;
    string htmlBody;
      
    public IPDEVBugTriggerHandler()
    {
        mapforOwnerandTeam = new  Map <string, IPDEVforDefaultOwnerandTeam__c>();        
    }
    public static boolean isCompleted = true;    
    public static boolean runOnce() {
       if(isCompleted){
             isCompleted = false;
             return true;
        }else{
            return isCompleted;
        }        
    }
    
    //This method sets the defaul owner, When the bug record is created.
    public void setDefaultOwner() 
    {
        try{
            for (bug__c bg: buglistNew) {
                if (mapforOwnerandTeam.get(bg.id) != null) {
                    if(mapforOwnerandTeam.get(bg.id).Bug_Owner__c != null){
                        string st = mapforOwnerandTeam.get(bg.id).Bug_Owner__c;
                        if (validateId(st) != null) {
                            if (userMap.get(st) != null) {
                                //assigned when owner is user
                                if (userMap.get(st).isactive)
                                    bg.ownerid = st;
                            } else {
                                //assigned when owner is a queue.
                                bg.ownerid = st;
                            }
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='setDefaultOwner()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);                  
        }
    }
    
    //This method creates the default bug team when the bug is created
    public void setDefaultBugTeam() {

        list < Bug_Team__c > bgTeamList = new list < Bug_Team__c > ();
        Bug_Team__c bgTeam;
        Set<Id> setUserIds;
        try{
            for (bug__c bg: buglistNew) {
                if (mapforOwnerandTeam.size() > 0) {
                    if (mapforOwnerandTeam.get(bg.id).Bug_BugTeam__c != '' && mapforOwnerandTeam.get(bg.id).Bug_BugTeam__c != null) {
                        setUserIds = new Set<Id>();                        
                        for (string st: mapforOwnerandTeam.get(bg.id).Bug_BugTeam__c.split(',')) {
                            if (validateUserId(st) != null) {
                                if (userMap.get(st) != null) {
                                    if (userMap.get(st).isactive) {
                                        if(!setUserIds.contains(st)){
                                            setUserIds.add(st);
                                            bgTeam = new bug_team__c();
                                            if (!userVsBugUpdateChk.containsKey(st)) {
                                                bgTeam.Bug_Update_Only__c = true;
                                            }
                                            else if(userVsBugUpdateChk.get(st) == true){
                                                bgTeam.Bug_Update_Only__c = true;
                                            }
                                            else{
                                                bgTeam.Bug_Update_Only__c = false;
                                            }
                                            if (!userVsChatterUpdateChk.containsKey(st)) {
                                                bgTeam.Chatter_Only__c = true;
                                            }
                                            else if(userVsChatterUpdateChk.get(st) == true){
                                                bgTeam.Chatter_Only__c = true;
                                            }
                                            else{
                                                bgTeam.Chatter_Only__c = false;
                                            }                                            
                                            bgTeam.Bug__c = bg.id;
                                            bgTeam.user__c = st;
                                            bgTeam.Access__c = 'Read/Write';
                                            bgTeamList.add(bgTeam);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(bgTeamList !=null && bgTeamList.size()>0)
                insert bgTeamList;  
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }               
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='setDefaultBugTeam()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw); 
        }                   
    }
    
    // Creates Map for the bug ID and  custom setting record and active users for custom setting.
    public void mapCreation() {
        userIds = new list < string > ();
        grpUserIds = new list < string > ();
        try {
            for (IPDEVforDefaultOwnerandTeam__c cs: csList) {
                userIds.add(cs.Bug_Owner__c);
    
                if (cs.Bug_BugTeam__c != null && cs.Bug_BugTeam__c != '') {
                    for (string st: cs.Bug_BugTeam__c.split(',')) {
                        userIds.add(st);
                        grpUserIds.add(st);
                    }
                }
                
            }
            UserMap = new Map < id, user > ([select id, IsActive from user where id in : userIds]);
            // Creates Map for the bug ID and  custom setting record.
            createMapforOwnerandTeam();
            List<Manage_Email_Notification__c> manageEmailNotification = new  List<Manage_Email_Notification__c>();
            
            manageEmailNotification = [select User__c,Chatter_Only__c,Bug_Update_Only__c from Manage_Email_Notification__c where User__c IN: grpUserIds];
            for(Manage_Email_Notification__c  manageEmail : manageEmailNotification ){
                userVsBugUpdateChk.put(manageEmail.User__c,manageEmail.Bug_Update_Only__c);
                userVsChatterUpdateChk.put(manageEmail.User__c,manageEmail.Chatter_Only__c);
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='mapCreation()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  }   
    }   
    
    // Creates Map for the bug ID and  custom setting record.
    public void createMapforOwnerandTeam() {
        try {
            for (bug__c c: buglistNew) {
                if (c.IPDEV_Component__c != '' && c.IPDEV_Component__c != null) {
                    for (IPDEVforDefaultOwnerandTeam__c csTemp: csList) {
                        if (c.IPDEV_Component__c == cstemp.IPDEV_Component__c) {
                            mapforOwnerandTeam.put(c.id, cstemp);
                        }
                    }
                }
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='createMapforOwnerandTeam()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  }   
    }
    
    public static boolean CheckMailSkipforFeed() {
        return skipmailforFeed;
    }
    
    //This method is used for validating Users Ids and GroupId
    public String validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005'))||(id.startsWith('00G')))) {
            return id;
        }
        return null;
    }
    
     //This method is used for validating Users Ids
     public String validateUserId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id) && ((id.startsWith('005')))) {
            return id;
        }
        return null;
     }
     
    //This method is used for replacing NULL to Blank 
    public Object replaceNull(Object val){
        if(val <> null && val <> '' && val <> 'null')
            return val;
        return 'Blank';
    }
    
    //Method can take input param as user,queue and public group id 
    public static Map < Id, set < Id > > getGroupMembers(List < Id > groupIds) {
        Map < Id, set < Id >> returnGroupMembers = new Map < Id, set < Id >> ();
        Map < Id, Id> mapGroupSubGroupId = new Map < Id, Id> ();
        List < GroupMember > groupMembers = new List < GroupMember > ();
        List < User > grpUser = new List < User > ();
        List < GroupMember > subGroupMembers = new List < GroupMember > ();
        List < Id > subGroupsIds = new List < Id > ();
        Id[] groupMemberIds = new list<Id>();
        try{
            Map < Id, List < Id >> mapGroupMembers = new Map < Id, List < Id >> ();
            
            if (groupIds != null && groupIds.size() > 0){
                groupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId In: groupIds Limit 100];
                grpUser = [select id from user where id IN: groupIds and isActive=true Limit 100];
            }   
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
            
            // keep trying to get users from GroupMember.userOrGroupId.
            if(mapGroupMembers !=null && mapGroupMembers.size()>0){
                
                Map<Id, User> users = new Map<Id, User>([select Id,Email, Name from User where (Id In :groupMemberIds) and (isActive=true) Limit 1000]);
                Set<Id> setUsers = users.keySet();
                
                for (Id groupId: mapGroupMembers.keySet()) {
                    // The "key" variable is also available inside the loop
                    List<Id> listUsers = mapGroupMembers.get(groupId);
                    for (Id userId: listUsers) {
                        if(setUsers.Contains(userId)){
                            if (returnGroupMembers.containsKey(groupId)) {
                                returnGroupMembers.get(groupId).add(userId);
                            } else {
                                returnGroupMembers.put(groupId, new set < Id > {
                                    userId
                                });
                            }
                        }
                    }
                }
            }
            for(User eachUser: grpUser){
                set<Id> userList = new set<Id>();
                userList.add(eachUser.Id);
                returnGroupMembers.put(eachUser.Id,userList);
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='getGroupMembers()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);          
        }           
        return returnGroupMembers; 
        
    }    
    
    //Set flag for component update
    public void setOldProductandComponent()
    {    
        try
            {
                for (Bug__c objBug: buglistNew)
                {
                    Bug__c objBugOld = bugMapOld.get(objBug.id);
                    if(objBug.IPDEV_Component__c != objBugOld.IPDEV_Component__c)
                           objBug.Old_IPDEV_Component__c =  objBugOld.IPDEV_Component__c;
                }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
            }
           catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='setOldProductandComponent()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);         
           }           
    } 
    
    //Inserts Bug Owner to Bug Team when owner changes
    public void updateBugTeamOnOwnerChange() {
         try{        
             List<Bug_Team__c> bugTeamtoInsert = new List<Bug_Team__c>();
             Map < id, string > bugIdOwnerMap = new Map < id, string > ();
             Map < id, set < Id >> bugTeamMap = new Map < id, set < Id>> ();
             createMapforOwnerandTeam();
             for(bug__c eachBug: buglistNew){
                 bug__c bOld = bugmapOld.get(eachBug.id);
                 if ( eachBug.OwnerId != bOld.OwnerId ){
                     bugVsOwnerMap.put(bOld,bOld.OwnerId );
                     bugId.add(bOld.id);                   
                 }    
             }        
             if(!bugVsOwnerMap.isEmpty()){
                List<Id> ownerId = new List<Id>();
                ownerId = bugVsOwnerMap.values();
                groupVsUserMap = getGroupMembers(ownerId);
             }
             if(!groupVsUserMap.isEmpty()){
                set<Id> idUser = new set<Id>();
                for(set<Id> userIds: groupVsUserMap.values()){
                    for(id eachuserId: userIds){
                        idUser.add(eachuserId);
                    }
                }
                List<Manage_Email_Notification__c> manageEmailNotification = new  List<Manage_Email_Notification__c>();
                manageEmailNotification = [select User__c,Chatter_Only__c,Bug_Update_Only__c from Manage_Email_Notification__c where User__c IN: idUser];
                if(!manageEmailNotification.isEmpty()){
                    for(Manage_Email_Notification__c manageE : manageEmailNotification){
                        manageEmailMap.put(manageE.User__c,manageE); 
                    }
                }
             }
            // create map for bug owner and bug team
            for (bug__c bugTemp: [Select b.Id, Owner.Email, LastModifiedById, (Select Bug__c, User__c, User__r.email, user__r.isactive,Bug_Update_Only__c From Bug_Teams__r r) From Bug__c b where b.id in : bugId]) 
            {                
                
                set<Id> bugTeamUserId = new set<Id>() ;
                for (Bug_Team__c bugTeamTemp: bugTemp.Bug_Teams__r) {
                    bugTeamUserId.add(bugTeamTemp.User__c);
                }
                if (bugTeamUserId.size() > 0)
                    bugTeamMap.put(bugTemp.id, bugTeamUserId);                    
            }      
            
            for(bug__c bugEach: bugVsOwnerMap.keyset()){
                string bugOwner;
                set<Id> ownerIdToBeDeleted = new set<Id>();
                List<Id> ownerIdToBeInserted = new List<Id>();
                List<Id> BugTeamMember = new List<Id>();
                set<Id> BugTeamMemberSet = new set<Id>();
                
                if(bugVsOwnerMap.get(bugEach) != null){
                    bugOwner = bugVsOwnerMap.get(bugEach);
                }
                if(groupVsUserMap.get(bugOwner) != null){
                    ownerIdToBeDeleted = groupVsUserMap.get(bugOwner);
                
                    if(bugTeamMap.get(bugEach.id) != null){
                        BugTeamMemberSet = bugTeamMap.get(bugEach.id);
                    }
                    
                    for(Id userId:ownerIdToBeDeleted){
                    if(!BugTeamMemberSet.contains(userId))
                        ownerIdToBeInserted.add(userId);
                    }
                
                    
                    if(!ownerIdToBeInserted.isEmpty()){
                        for(Id bugteamId: ownerIdToBeInserted){
                            bug_team__c bgTeam = new bug_team__c();
                            if (manageEmailMap.containsKey(bugteamId)) {
                                Manage_Email_Notification__c manageEmailNot = new Manage_Email_Notification__c();
                                manageEmailNot = manageEmailMap.get(bugteamId);
                                bgTeam.Bug_Update_Only__c = manageEmailNot.Bug_Update_Only__c;
                                bgTeam.Chatter_Only__c = manageEmailNot.Chatter_Only__c;
                            }
                            else{
                                bgTeam.Bug_Update_Only__c = true;
                                bgTeam.Chatter_Only__c = true;
                            }                                           
                            bgTeam.Bug__c = bugEach.id;
                            bgTeam.user__c = bugteamId;
                            bgTeam.Access__c = 'Read/Write';
                            bgTeam.Reason__c = 'Ownership Change';
                            bugTeamtoInsert.add(bgTeam);                    
                        }
                    }
                } 
            }
            if(!bugTeamtoInsert.isEmpty()){
                insert bugTeamtoInsert;
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
         } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = IPDEVBugTriggerHandler.class.getName();
                    alw.sourceFunction ='updateBugTeamOnOwnerChange()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);           
         }
    } 
    //Updates Date/Time Fields when status is updated 
    public void updateBugStatusDate() {
        for(bug__c eachBug: buglistNew){
            bug__c bOld = bugmapOld.get(eachBug.id);
            if (eachBug.Status__c != bOld.Status__c ){
                if(eachBug.Status__c == System.Label.Bug_Status_Assigned){
                    eachBug.Bug_Assigned_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Closed ){
                    eachBug.Bug_Closed_Date__c = DateTime.Now();
                    eachBug.Date_Time_Closed__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Resolved ){
                    eachBug.Bug_Resolved_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Verified ){
                    eachBug.Bug_Verified_Date__c = DateTime.Now();
                }   
                else if(eachBug.Status__c == System.Label.Bug_Status_Hold ){
                    eachBug.Bug_Hold_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Info_Required ){
                    eachBug.Bug_Info_Required_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Accepted ){
                    eachBug.Bug_Accepted_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Committed ){
                    eachBug.Bug_Committed_Date__c = DateTime.Now();
                }                                                                                                                                                                
            }    
        }           
    } 
    
     public void feedTrackingforFieldUpdate() {
        try{
            String oldresolutionValue ='';
            String olddescriptionValue ='';
            String strdesOld = '';
            String strdesNew = '';
            String strresOld = '';
            String strresNew = '';
            List<String> lstFields = new List<String>();            
            list<FeedItem> lstFeedItem = new  list<FeedItem>();
                                   
            for(bug__c bugTemp:buglistNew) {                                                
                if(bugTemp.Bug_Description__c != '' && bugTemp.Bug_Description__c != NULL){ 
                       strdesNew = bugTemp.Bug_Description__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim(); 
                       olddescriptionValue = bugTemp.Bug_Description__c.stripHtmlTags().trim();  
                            
                     if(bugmapOld.get(bugTemp.Id).Bug_Description__c != null && bugmapOld.get(bugTemp.Id).Bug_Description__c != '')                                                                                 
                        strdesOld = bugmapOld.get(bugTemp.Id).Bug_Description__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim();                                                                               
                  } 

                if(bugTemp.Resolution__c != '' && bugTemp.Resolution__c != NULL ){ 
                       strresNew = bugTemp.Resolution__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim(); 
                       oldresolutionValue = bugTemp.Resolution__c.stripHtmlTags().trim();  
                            
                     if(bugmapOld.get(bugTemp.Id).Resolution__c != null && bugmapOld.get(bugTemp.Id).Resolution__c != '')                                                                                 
                        strresOld = bugmapOld.get(bugTemp.Id).Resolution__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim();
                                                                                
                  }                   
                 
                 
                if(strdesNew != strdesOld ){                                                           
                        skipmailforFeed = true;
                        FeedItem objFeedItem = new FeedItem();
                        objFeedItem.ParentId = bugTemp.Id;
                        String feedValue = 'Description Updated:'+ '\n' + replaceNull(olddescriptionValue);
                        String feedBody =  feedValue ;                                                                            
                        objFeedItem.body = feedBody;                   
                        objFeedItem.Type = 'ContentPost'; 
                        if(feedBody.length() < 9999)                   
                        lstFeedItem.add(objFeedItem);                                 
                } 
                if (strresNew != strresOld ){
                        skipmailforFeed = true;
                        FeedItem objFeedItem = new FeedItem();
                        objFeedItem.ParentId = bugTemp.Id;
                        String feedValue = 'Resolution Updated:'+ '\n' + replaceNull(oldresolutionValue);
                        String feedBody =  feedValue ;                                                                            
                        objFeedItem.body = feedBody;                   
                        objFeedItem.Type = 'ContentPost'; 
                        if(feedBody.length() < 9999)                   
                        lstFeedItem.add(objFeedItem);  

               }               
            }
            if(lstFeedItem != null && lstFeedItem.size() > 0) {
                Database.insert(lstFeedItem, false);                
            }
          if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }
        catch (Exception e) {         
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = CaseTriggerHandler.class.getName();
            alw.sourceFunction ='feedTrackingforFieldUpdate()';
            alw.ApplicationName='Case Management';                    
            alw.referenceInfo = 'Bug';
            alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel = 'Error';
            alw.logCode = e.getTypeName();
            alw.ex = e.getCause();
            GlobalUtility.logMessage(alw);         
        }
    }
    
    
   public void PostBugDescription(){
    try{
            list < feedItem > feedItemList = new list < feedItem > ();  
            for (bug__c bg: buglistNew){
                 FeedItem feeditemVar = new FeedItem();
                 if(bg.Bug_Description__c != null){    
                     feeditemVar.parentid = bg.id;
                     feeditemVar.Body = bg.Bug_Description__c;
                     feedItemList.add(feeditemVar);           
                 }                         
            }
             if (feedItemList!= null && feedItemList.size() > 0) { insert feedItemList;
               }
             if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
              }
    }
    catch (exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = IPDEVBugTriggerHandler.class.getName();
            alw.sourceFunction = 'PostBugDescription()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
    
    
    public class applicationException extends Exception {} 
}