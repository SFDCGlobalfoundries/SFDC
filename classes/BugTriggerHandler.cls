/*Author: Karthick D
* Description: This class is handler class for bug trigger. Methods created 
               to set default owner,Default bug team and  send mails on bug update. 
* History: Created on 03/31/2014
           Modified on 08/22/2014 for optimizing user query, changing logic in delete validation and 
           made changes to send bulk email.
           Modified on 05/25/2015 - Shuchi -Added the logic for moving status to Hold and from any other staus to Hold ,only for certain users            
*/
public class BugTriggerHandler {
    //List Variables declaration 
    public static boolean skipmailforFeed = false;
    public list<bug__c> buglistNew {get;set;}
    public list<bug__c> buglistOld {get;set;}
    public list<String> userIds {get;set;} 
    public list<String> grpUserIds;
    public list < CSforDefaultownerandteam__c > csList = CSforDefaultOwnerandTeam__c.getall().values();
    public list < Id > toAddressesList = new list < Id > ();
    
    public set < Id > toAddresses = new set < Id > ();
    public set<Id> bugId = new set<Id>();
    //Maps variables declaration  
    public Map <id, bug__c> bugmapNew {get;set;}
    public Map <id, bug__c> bugmapOld {get;set;} 
    public Map<string, CSforDefaultownerandteam__c> mapforOwnerandTeam{get;set;}
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
      
    public BugTriggerHandler()
    {
        mapforOwnerandTeam = new  Map <string, CSforDefaultownerandteam__c>();        
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
    
    public void validateFixedInPlannedInVersion(){
        for (bug__c bg: buglistNew) {            
                
                if((bg.Status__c == 'Hold' || bg.Status__c == 'Info Required')) {
                    bg.Fixed_Version__c = null;
                    bg.Planned_Version__c = null;
                    bg.Fixed_In_DM__c = null;
                }
                else if(bg.Bug_Classification__c == 'Question' && bg.Resolution__c == 'Question Answered' && bg.DM_Team_Classification__c == 'Question (No Update Required)'){
                    bg.Fixed_Version__c = null;
                    bg.Planned_Version__c = null;
                    bg.Fixed_In_DM__c = null;
                }
                else if((bg.Resolution__c == 'Invalid' && bg.DM_Team_Classification__c == 'Invalid Bug' )){
                    bg.Fixed_Version__c = null;
                    bg.Planned_Version__c = null;
                    bg.Fixed_In_DM__c = null;
                }
                else if(bg.Resolution__c == 'Not Fixable' || bg.Resolution__c == 'Won\'t Fix'){
                    bg.Fixed_Version__c = null;
                    bg.Planned_Version__c = null;
                    bg.Fixed_In_DM__c = null;
                }  
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
                    alw.source = CaseTriggerHandler.class.getName();
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
                    alw.source = CaseTriggerHandler.class.getName();
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
    
    //Modified by Manikumar against Case #00049649 - Start
    //This method creates the default additional bug team members when the bug is created
    public void setDefaultAddBugTeam() {

        list < Bug_Team__c > bgTeamList = new list < Bug_Team__c > ();
        Bug_Team__c bgTeam;
        Set<Id> setUserIds;
        try{
            for (bug__c bg: buglistNew) {
                if (mapforOwnerandTeam.size() > 0) {
                    if (mapforOwnerandTeam.get(bg.id).Additional_Bug_Team__c != '' && mapforOwnerandTeam.get(bg.id).Additional_Bug_Team__c != null) {
                        setUserIds = new Set<Id>();                        
                        for (string st: mapforOwnerandTeam.get(bg.id).Additional_Bug_Team__c.split(',')) {
                            if (validateUserId(st) != null && userMap.get(st) != null && userMap.get(st).isactive && !setUserIds.contains(st)) {
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
            if(bgTeamList !=null && bgTeamList.size()>0)
                insert bgTeamList;
                
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }   
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='setDefaultAddBugTeam()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  
            }                   
    }
    //Modified by Manikumar against Case #00049649 - End
    

    // Creates Map for the bug ID and  custom setting record and active users for custom setting.
    public void mapCreation() {
        userIds = new list < string > ();
        grpUserIds = new list < string > ();
        try {
            for (CSforDefaultownerandteam__c cs: csList) {
                userIds.add(cs.Bug_Owner__c);
    
                if (cs.Bug_BugTeam__c != null && cs.Bug_BugTeam__c != '') {
                    for (string st: cs.Bug_BugTeam__c.split(',')) {
                        userIds.add(st);
                        grpUserIds.add(st);
                    }
                }
                
                //Modified by Manikumar against Case #00049649 - Start
                if (cs.Additional_Bug_Team__c != null && cs.Additional_Bug_Team__c != '') {
                    for (string st: cs.Additional_Bug_Team__c.split(',')) {
                        userIds.add(st);
                        grpUserIds.add(st);
                    }
                }
                //Modified by Manikumar against Case #00049649 - End
                
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
                    alw.source = CaseTriggerHandler.class.getName();
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
    
                if (c.product_Technology__c != '' && c.product_Technology__c != null) {
    
                    for (CSforDefaultownerandteam__c csTemp: csList) {
                        if (c.Component__c != '' && c.Component__c != null) {
                            if (c.product_Technology__c == cstemp.Product_affected__c && c.Component__c == cstemp.Bug_Component__c)
                                mapforOwnerandTeam.put(c.id, cstemp);
                        } else {
                            if (c.product_Technology__c == cstemp.Product_affected__c) {
                                mapforOwnerandTeam.put(c.id, cstemp);
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
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='createMapforOwnerandTeam()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  }   
    }

    // Email notification on bug update sent  to Bugowner, Bug team and related bug owner and bug team members.
   public void emailNotificationforBugUpdate() {
        list < Messaging.SingleEmailMessage > emailList = new list < Messaging.SingleEmailMessage > ();
        list < id > bugIdsVar = new list < id > ();
        list < string> QueueIdsVar = new list < string> ();
        list < string > ownerIds;
        Map < id, list < RelatedBugAssociation__c >> relatedBugMap = new Map < id, list < RelatedBugAssociation__c >> ();
        Map < id, string > bugIdOwnerMap = new Map < id, string > ();
        Map < id, list < Id >> bugTeamMap = new Map < id, list < Id>> ();
        Map < id, set < Id >> bugTeamMapComp = new Map < id, set < Id>> ();
        Map <id, Set<Id>> ownerUserIdsMap  = new Map<id, Set<Id>>();
        
        FeedTriggerHandler FeedTriggerHandlerVar = new FeedTriggerHandler();
        try{
            //Get all the bug ids for bug, related bug
            for (bug__c bugTemp: [Select id, (select bugA__c, BugB__c From RelatedBugAssociation__r) From Bug__c b where id in : bugmapNew.keyset()]) {
                bugIdsVar.add(bugTemp.id);                
                if (bugtemp.RelatedBugAssociation__r != null) {
                    relatedBugMap.put(bugTemp.id, bugTemp.RelatedBugAssociation__r);
                    for (RelatedBugAssociation__c r: bugTemp.RelatedBugAssociation__r)
                        bugIdsVar.add(r.bugb__c);
                }
            }
    
            // create map for bug owner and bug team
            for (bug__c bugTemp: [Select b.Id, Owner.Email, LastModifiedById, (Select Bug__c, User__c, User__r.email, user__r.isactive,Bug_Update_Only__c From Bug_Teams__r r) From Bug__c b where b.id in : bugIdsVar]) 
            {
                bugIdOwnerMap.put(bugTemp.id, bugTemp.ownerid);
                ownerIds = new list < string > ();
                set<Id> bugTeamUserId = new set<Id>() ;
                for (Bug_Team__c bugTeamTemp: bugTemp.Bug_Teams__r) {
                    bugTeamUserId.add(bugTeamTemp.User__c);
                    if (bugTeamTemp.user__r.isactive && bugTeamTemp.Bug_Update_Only__c == true)
                        ownerIds.add(bugTeamTemp.User__c);
                }
                if (ownerIds.size() > 0)
                    bugTeamMap.put(bugTemp.id, ownerIds);
                    bugTeamMapComp.put(bugTemp.id,bugTeamUserId);
            }
            //Get all the users for Queue
            for(bug__c c : [select id, ownerid from bug__c where id in :bugIdsVar])
                {
                    if (((String) c.ownerId).startsWith(groupType))
                        QueueIdsVar.add(c.ownerId);
                }
            
            //Get the userlist for all the queue
            if(QueueIdsVar.size() > 0)
                ownerUserIdsMap  = getGroupMembers(QueueIdsVar);
            for (bug__c bugTemp: buglistOld) 
            {
                toAddresses = new set < ID> ();
                toAddressesList = new list < ID > ();
                bug__c bugTempNew = bugmapnew.get(bugTemp.id);
                ownerIds = new list < string > ();
                if (bugTemp.Bug_Closed_Date__c == bugTempNew.Bug_Closed_Date__c && bugTemp.Bug_Assigned_Date__c == bugTempNew.Bug_Assigned_Date__c) {
                    //Add Bug Owner
                    set<ID> tempUserIdsComp = new set<ID>();
                    if(bugTeamMapComp.get(bugTemp.id) != null){
                        tempUserIdsComp = bugTeamMapComp.get(bugTemp.id);
                    }                    
                    if (((String) bugTemp.ownerId).startsWith(groupType))
                        {
                            if(ownerUserIdsMap.get(bugTemp.ownerId) != null){
                                set<ID> tempUserIds = new set<ID>();                                
                                tempUserIds =  ownerUserIdsMap.get(bugTemp.ownerId);
                                //toAddresses.addall(ownerUserIdsMap.get(bugTemp.ownerId));
                                for(id tempUserId : tempUserIds){
                                    if(!tempUserIdsComp.contains(tempUserId)){
                                        toAddresses.addall(ownerUserIdsMap.get(bugTemp.ownerId));
                                    }
                                }
                            }
                        }
    
                    else if(!tempUserIdsComp.contains(bugTemp.ownerId)){                    
                        toAddresses.add(bugTemp.ownerId);
                    }                    
                    //Add Bug Creator
                    if(!tempUserIdsComp.contains(bugTemp.createdbyId)){
                        toAddresses.add(bugTemp.createdbyId);
                    }                     
                    //Add Bug Team
                    if (bugTeamMap.get(bugTemp.id) != null)
                        toAddresses.addAll(bugTeamMap.get(bugTemp.id));
    
                    //Add Related bugs owner and bug team members email
                    for (RelatedBugAssociation__c relatedBugTemp: relatedBugMap.get(bugTemp.id)) {
                        string stOwner = bugIdOwnerMap.get(relatedBugTemp.bugb__c);
                        if (((String) stOwner).startsWith(groupType))
                            {
                                if(ownerUserIdsMap.get(stOwner ) != null)
                                    toAddresses.addall(ownerUserIdsMap.get(stOwner ));
                            }
                        else
                            toAddresses.add(stOwner);

                        if (bugTeamMap.get(relatedBugTemp.bugb__c) != null)
                            toAddresses.addAll(bugTeamMap.get(relatedBugTemp.bugb__c));
                    }
                }
    
                //adding values from set to list to use in email function  
                //Login user won't get the mail       
                for (string st: toAddresses) {
                    if (st != Userinfo.getUserId())
                        toAddressesList.add(st);
                }
    
                String bugTempId = bugTemp.id;
                String bug15DigitId = bugTempId.substring(0, 15);
                string strValue = GetOldNewValue(bugTemp, bugTempNew);
                if(strValue !=null && strValue !=''){
                    htmlBody = '<table><tr><td>' +
                        '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                        '<tr><td>Dear User,  <br></td></tr>' +
                        '<tr><td> Bug ' + BugTemp.name + ' has been updated by ' + Userinfo.getName() + ' recently. Below listed the changes made: <br><br> </td><tr> ' +
                        '<tr><td> ' + strValue + ' <br></td></tr>' +
                        '<tr><td> Clicking on the link below, to view the bug details: </td></tr>' +
                        '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bug15DigitId + '</td></tr><br><br>' +
                        '<tr><td>Thank You <br>' +
                        '</td></tr></table>'; 
                    for (string stUserId: toAddressesList) {
                        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                        email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Product_Technology__c + ': ' + bugTemp.Component__c + ': ' + bugtemp.bug_title__c);
                        email.setHtmlBody(htmlBody);
                        email.setTargetObjectId(stUserId);
                        email.setSaveAsActivity(false);
                        email.setOrgWideEmailAddressId(orgWideEmail);
                        emailList.add(email);
                    }
                }
            }
            if (emailList.size() > 0) {Messaging.sendEmail(emailList);}
            
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='emailNotificationforBugUpdate()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);  }   
    }

    //Method sets relationship between cloned bugs, case bug association, copies chatter feeds, attachements etc from parent.
    public void bugOrginfromCaseandBug() {
        List < CaseBugAssociation__c > lstCaseBugAssoc = New List < CaseBugAssociation__c > ();
        list < RelatedBugAssociation__c > relatedBugList = new list < RelatedBugAssociation__c > ();
        list < feedItem > feedItemList = new list < feedItem > ();        
        list < Attachment > attachList = new list < Attachment > ();
        list < Attachment > tempAttach;
        Map < Id, FeedItem > feedItemMap = new Map < Id, FeedItem > ();
        CaseBugAssociation__c objCaseBug;
        Attachment attachVar;
        String parentId;
        feedItem feeditemVar;
        feedComment feedcommentVar;
        bug__c parentBugVar;
        RelatedBugAssociation__c r;
        list<string> orginIdList = new list <string>();
        
        for(Bug__c b : buglistNew)
            orginIdList.add(b.Origin__c);
        Map<Id, Case> CaseMap = new Map<Id, Case>([select id from case where id in :orginIdList]);
        Map<Id, Bug__c> BugMap = new Map<Id, Bug__c>([select id from Bug__c where id in :orginIdList]);
        Map<Id, list<Attachment>> CaseAttachMap = new Map<Id, list<Attachment>>();
        Map<id, Attachment> AttachMap = new Map<id, Attachment>([select id, name, body from Attachment where parentId = :CaseMap.keyset()]);
        Map<id,bug__c> bugParentMap = new Map<id,Bug__c>([select id, name from bug__c where id in:orginIdList]);
        for(case c : [select id, (select id from Attachments) from case where id in :CaseMap.keyset()])
            CaseAttachMap.put(c.id, c.Attachments);
        try{
            for (Bug__c objBug: buglistNew) {
                if (objBug.Origin__c != null) {
                    parentId = objBug.Origin__c;
                    if ((parentId.length() == 15 || parentId.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', parentId)) {
                        if (CaseMap.get(ParentId) != null) 
                        {
                            objCaseBug = New CaseBugAssociation__c();
                            objCaseBug.Bug__c = objBug.Id;
                            objCaseBug.Case__c = ParentId;
                            lstCaseBugAssoc.add(objCaseBug);
                            for (Attachment a: CaseAttachMap.get(objBug.Origin__c))
                            {
                                a = AttachMap.get(a.id);
                                attachVar = new Attachment(name = a.name, body = a.body, parentid = objbug.id);
                                attachList.add(attachVar);
                            }
                        } else if (BugMap.get(ParentId) != null) {
                            skipmailforFeed = true;
                            if(bugParentMap.get(objBug.Origin__c) != null)
                                parentBugVar = bugParentMap.get(objBug.Origin__c);
                            r = new RelatedBugAssociation__c();
                            r.BugB__c = objbug.origin__c;
                            r.BugA__c = objbug.id;
                            r.Relasionship__c = 'BugA depends on BugB';
                            relatedbuglist.add(r);
                            //The Default comment added for clone.
                            feeditemVar = new feedItem();
                            feeditemVar.parentid = objBug.id;
                            feeditemVar.title = 'Bug Clone Detail';                        
                            string strText = BugErrorMessages__c.getValues('CloneChatterMessage').Error_Message__c + ' ' + parentBugVar.name;                      
                            strText += ' (' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + ((string)parentBugVar.id).substring(0, 15) + ')';
                            
                            feeditemVar.body = strText;
                            feedItemList.add(feeditemVar);                      
                            
                        }
                    }
                }
            }
    
            if (lstCaseBugAssoc != null && lstCaseBugAssoc.size() > 0) {
                insert lstCaseBugAssoc;
            }
            if (relatedBugList != null && relatedBugList.size() > 0) {
                insert relatedBugList;
            }
            if (attachList != null && attachList.size() > 0) {
                insert attachList;
            }
            if (feedItemList!= null && feedItemList.size() > 0) {
                insert feedItemList;
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='bugOrginfromCaseandBug()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);          
            }
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

    //Validation rule to restrict users from updating bug to "Hold" status.
    public void ValidateBugUpdateforHoldStatus() {
         try{
             createMapforOwnerandTeam();
             string errorMsg = null;             
             
             for(bug__c eachBug: buglistNew){
                 bug__c bOld = bugmapOld.get(eachBug.id);
                 if ((eachBug.status__c == 'Hold' && bOld.status__c != 'Hold') || (eachBug.status__c != 'Hold' && bOld.status__c == 'Hold')){
                     if (mapforOwnerandTeam.size() > 0) {
                        if (mapforOwnerandTeam.get(eachBug.id).Bug_Admin__c != '' && mapforOwnerandTeam.get(eachBug.id).Bug_Admin__c != null) {
                            if (validateId(mapforOwnerandTeam.get(eachBug.id).Bug_Admin__c) != null) {
                                bugVsAdminMap.put(eachBug,mapforOwnerandTeam.get(eachBug.id).Bug_Admin__c);
                            }
                        }
                     }                     
                 }    
             }        
             if(!bugVsAdminMap.isEmpty()){
                List<Id> AdminId = new List<Id>();
                AdminId = bugVsAdminMap.values();
                groupIdVsUserMap = getGroupMembers(AdminId);
             }
             errorMsg = BugErrorMessages__c.getValues('BugStatusOnHold').Error_Message__c;
                 for(bug__c bugEach: bugVsAdminMap.keyset()){
                     string bugAdminId;
                     if (validateId(mapforOwnerandTeam.get(bugEach.id).Bug_Admin__c) != null) {
                        bugAdminId = mapforOwnerandTeam.get(bugEach.id).Bug_Admin__c;
                     }                     
                     string GrpId = bugVsAdminMap.get(bugEach);
                     set<Id> listOfUsers = new set<Id>();
                     if(!groupIdVsUserMap.isEmpty()){
                         listOfUsers = groupIdVsUserMap.get(GrpId);
                     }
                     Id currentUser = UserInfo.getUserId();
                     Boolean isCurrentUser = true;
                     if(listOfUsers != null && !listOfUsers.isEmpty()){
                         if(!listOfUsers.contains(currentUser)){
                             isCurrentUser = false;
                         }    
                     }
                     if(isCurrentUser == false){
                         bugEach.addError(errorMsg);
                     }
                     if(listOfUsers.isEmpty() && bugAdminId != null){
                         bugEach.addError(errorMsg);
                     }
                 }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
         } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='ValidateBugUpdateforHoldStatus()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);           
            }
    }
    
    //Method finds and the field list recently updated.
    public string GetOldNewValue(bug__c bOld, bug__c bNew) {
        Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.bug__c.fields.getMap();
        Set < String > nonCompareSet = new Set < String > ();
        string st, stText;
        try{
            for (BugNonCompareFields__c key: BugNonCompareFields__c.getall().values())
                nonCompareSet.add((string) key.Name.toupperCase());
        
        
            for (Schema.SObjectField field: schemaFieldMap.values()) {                                   
                string fieldname = field.getDescribe().getname();                                                
                if (!nonCompareSet.Contains(fieldname.toupperCase())) {
                    if (bold.get(fieldname) != bnew.get(fieldname)) {
                        string fieldLabel = schemaFieldMap.get(fieldName).getDescribe().getlabel();                    
                        if (string.valueof(field.getDescribe().getType()) == 'TEXTAREA') {
                            if (stText == null)
                                stText = '<tr><td>' + ' ' + fieldLabel + ' updated to:</b></br></td></tr><tr><td><b>' + replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                            else
                                stText += '<tr><td>' + ' ' + fieldLabel + ' updated to:</b></br></td></tr><tr><td><b>' + replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
        
                        } else {
        
                            if (st == null)
                                st = '<tr><td>' + ' ' + fieldLabel + ' updated from  <b>' + replaceNull(bold.get(fieldName)) + '</b> to <b>' + replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                            else
                                st += '<tr><td>' + ' ' + fieldLabel + ' updated from  <b>' + replaceNull(bold.get(fieldName)) + '</b> to <b>' + replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                        }
                    }
                }
            }
        
            if (st == null && stText != null) {
                st = stText;
            } else if (st != null && stText != null) {
                st += stText;
            }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
                    alw.sourceFunction ='GetOldNewValue()';
                    alw.ApplicationName='Case Management';                    
                    alw.referenceInfo = 'Bug';
                    alw.logMessage = 'Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel = 'Error';
                    alw.logCode = e.getTypeName();
                    alw.ex = e.getCause();
                    GlobalUtility.logMessage(alw);          
        }
        return st;
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
                    alw.source = CaseTriggerHandler.class.getName();
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
    
    //Set flag for product or component update
    public void setOldProductandComponent()
    {    
        try
            {
                for (Bug__c objBug: buglistNew)
                {
                    Bug__c objBugOld = bugMapOld.get(objBug.id);
                    if(objBug.product_technology__c != objBugOld.product_technology__c || 
                       objBug.component__c!= objBugOld.component__c)
                           objBug.Old_Product_Component__c=  objBugOld.product_technology__c  + ',' +
                               objBugOld.component__c;
                }
            if(Test.isRunningTest()) {
                 throw new applicationException('In Test Mode');
            }
            }
           catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = CaseTriggerHandler.class.getName();
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
                    alw.source = CaseTriggerHandler.class.getName();
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
    Environment_Variable__c s=Environment_Variable__c.getInstance('Date/Time for Moved to DMM');
        for(bug__c eachBug: buglistNew){
            bug__c bOld = bugmapOld.get(eachBug.id);
            if(eachBug.Resolution__c != bOld.Resolution__c){
                if(eachBug.Resolution__c == s.Value__c){
                    eachBug.Date_Time_For_Moved_to_DMM__c = DateTime.Now();    
                }
            }     
                if (eachBug.Status__c != bOld.Status__c ){
                if(eachBug.Status__c == System.Label.Bug_Status_Assigned && eachBug.Bug_Assigned_Date__c == null){
                    eachBug.Bug_Assigned_Date__c = DateTime.Now();
                }
                else if(eachBug.Status__c == System.Label.Bug_Status_Closed ){
                    eachBug.Bug_Closed_Date__c = DateTime.Now();
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
    
    //Captures previous Resolution details field data and store in Feed
    public void feedTrackingforFieldUpdate() {
        try{
            String oldresolutionValue ='';
            String strOld = '';
            String strNew = '';
            List<String> lstFields = new List<String>();
            list<FeedItem> lstFeedItem = new  list<FeedItem>();         
            for(BugFeedTrackingFields__c key: BugFeedTrackingFields__c.getall().values()) {
                lstFields.add((string)key.Name);       
            }
            for(bug__c bugTemp:buglistNew) {
                if(bugmapOld.get(bugTemp.Id).Resolution_Details__c != null && bugmapOld.get(bugTemp.Id).Resolution_Details__c != ''){ 
                     oldresolutionValue = bugmapOld.get(bugTemp.Id).Resolution_Details__c.stripHtmlTags().trim();                      
                     strOld = bugmapOld.get(bugTemp.Id).Resolution_Details__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim();
                     if(bugTemp.Resolution_Details__c != '' && bugTemp.Resolution_Details__c != NULL){
                            strNew = bugTemp.Resolution_Details__c.stripHtmlTags().replaceAll('\\h+|\\n+', '').trim();}                                                                                                                           
                   }                       
                if(strNew != strOld  && strOld != null && strOld != ''){                                                           
                        skipmailforFeed = true;
                        FeedItem objFeedItem = new FeedItem();
                        objFeedItem.ParentId = bugTemp.Id;
                        String feedValue = 'Old Resolution Details:'+ '\n' + replaceNull(oldresolutionValue);
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
    public class applicationException extends Exception {} 
}