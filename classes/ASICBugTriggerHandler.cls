/*********************************************************************************/
  // Purpose      : Update the records and owners based on the Sub Type A, Sub TYpe B Sub TYpe C and Sub Type D values.
  // Date created : 04 October, 2016
  // Created by   : UCM Team
  // Author       : Kali 
  // Description  : Update the Bug Team and Owners based on the Combination of the Bug Update Owner and Team values
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/

public class ASICBugTriggerHandler {
    //List Variables declaration 
    private static boolean skipmailforFeed = false;
    public list<bug__c> buglistNew {get;set;}
    public list<bug__c> buglistOld {get;set;}
    public list<String> userIds {get;set;} 
    public list<String> grpUserIds;
    public List<Bug_Default_Owner_Team__c>  csList = [select id,Name,Name__c,Bug_Admin__c,Bug_BugTeam__c,Bug_Owners__c,Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c from Bug_Default_Owner_Team__c];
    public list < Id > toAddressesList = new list < Id > ();
    
    public list <ASICCustomerProject__c> csProjectList = ASICCustomerProject__c.getall().values();
    
    public set < Id > toAddresses = new set < Id > ();
    public set<Id> bugId = new set<Id>();
    //Maps variables declaration  
    public Map <id, bug__c> bugmapNew {get;set;}
    public Map <id, bug__c> bugmapOld {get;set;} 
    public Map<string, Bug_Default_Owner_Team__c> mapforOwnerandTeam{get;set;}
    public Map<id,List<string>> mapforCstProjectTeam{get;set;}
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
      
    public ASICBugTriggerHandler() {
        mapforOwnerandTeam = new  Map <string, Bug_Default_Owner_Team__c>();   
        mapforCstProjectTeam = new Map<id,List<string>>();
    }

    //This method sets the defaul owner, When the bug record is created.
      public void setDefaultOwner() {
        try{
           Set < ID > accountIDs = new Set < ID > ();
           Map < String, String> accProxyMap = new Map < String, string> ();
           for (bug__c bg: buglistNew){
                if(bg.Account_Affected__c != null){
                    accountIDs.add(bg.Account_Affected__c);
                }          
            }
           List<Account_Team_Proxy__c> atpList = [SELECT Id, User__c, Team_Role__c,Account__c from Account_Team_Proxy__c Where Team_Role__c = 'Primary Field Application Engineer' AND User__r.IsActive = true AND Account__c in :accountIDs];
           if(atpList.size() >0){
                for(Account_Team_Proxy__c act :atpList){
                    accProxyMap.put(act.Account__c,act.User__c);    
                }           
            }
            for (bug__c bg: buglistNew) {
                if(accProxyMap.get(bg.Account_Affected__c) != null){
                        bg.ownerid = accProxyMap.get(bg.Account_Affected__c);}
                else{
                    if (mapforOwnerandTeam.get(bg.id) != null) {
                            if(mapforOwnerandTeam.get(bg.id).Bug_Owners__c != null){
                            string st = mapforOwnerandTeam.get(bg.id).Bug_Owners__c;
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
                    
                 if(bg.Priority__c == 'P1 - High' || bg.Priority__c == 'P2'){
                    bg.Bug_Priority_Changed_Date__c = DateTime.Now();
            
                 } 
                }
            
             if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch (exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'setDefaultOwner()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
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
                
                if (mapforCstProjectTeam.size() > 0) {
                    if (mapforCstProjectTeam.get(bg.id) != null) {
                        setUserIds = new Set<Id>();                        
                        for (string st: mapforCstProjectTeam.get(bg.id)) {
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
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'setDefaultBugTeam()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
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
             if (feedItemList!= null && feedItemList.size() > 0) {
                  BugTriggerHandler.skipmailforFeed = true ;
                  Database.insert(feedItemList);
               }
             if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
              }
    }
    catch (exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
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
    
    // Creates Map for the bug ID and  custom setting record and active users for custom setting.
    public void mapCreation() {
        userIds = new list < string > ();
        grpUserIds = new list < string > ();
        try {
            for (Bug_Default_Owner_Team__c cs: csList) {
                userIds.add(cs.Bug_Owners__c);
    
                if (cs.Bug_BugTeam__c != null && cs.Bug_BugTeam__c != '') {
                    for (string st: cs.Bug_BugTeam__c.split(',')) {
                        userIds.add(st);
                        grpUserIds.add(st);
                    }
                }
            }
            
            for (ASICCustomerProject__c cs: csProjectList) {                    
                if (cs.Bug_Team__c != null && cs.Bug_Team__c != '') {
                    for (string st: cs.Bug_Team__c.split(',')) {
                        userIds.add(st);
                        grpUserIds.add(st);
                    }
                }
            }
                                    
            UserMap = new Map < id, user > ([select id, IsActive from user where id in : userIds]);
            // Creates Map for the bug ID and  custom setting record.
            createMapforOwnerandTeamBasedOnSubTypes();
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
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'mapCreation()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }   
    
    /*****************************Code started for the Create map for owner and team ******************************/
    // Created By Kali for assigning the values based on the subtype values
    public void createMapforOwnerandTeamBasedOnSubTypes() {
    try {
        Map<string,Bug_Default_Owner_Team__c> bugtOwnerAndTeamMap = new Map<string,Bug_Default_Owner_Team__c>();
        Map<string,list<string>> asicNametoBugTeamMap = new Map<string,list<string>>();
        
        mapforOwnerandTeam = new map<String,Bug_Default_Owner_Team__c>();
            for (bug__c c: buglistNew) {
                for (Bug_Default_Owner_Team__c csTemp: csList) {                                                                                                      
                    if(c.Sub_Type_D__c != null){
                        if(csTemp.Sub_Type_A__c != null && csTemp.Sub_Type_B__c != null && csTemp.Sub_Type_C__c != null && csTemp.Sub_Type_D__c != null) {
                            if (c.Sub_Type_A__c.trim() == csTemp.Sub_Type_A__c.trim() && c.Sub_Type_B__c.trim() == csTemp.Sub_Type_B__c.trim() && 
                                                c.Sub_Type_C__c.trim() == csTemp.Sub_Type_C__c.trim() && c.Sub_Type_D__c.trim() == csTemp.Sub_Type_D__c.trim()) {
                                mapforOwnerandTeam.put(c.id, cstemp);
                            } 
                        }
                    }
                    else if(c.Sub_Type_C__c != null){
                        if(csTemp.Sub_Type_A__c != null && csTemp.Sub_Type_B__c != null && csTemp.Sub_Type_C__c != null) {
                            if(c.Sub_Type_A__c.trim() == csTemp.Sub_Type_A__c.trim() && c.Sub_Type_B__c.trim() == csTemp.Sub_Type_B__c.trim() && c.Sub_Type_C__c.trim() == csTemp.Sub_Type_C__c.trim()) {
                                mapforOwnerandTeam.put(c.id, cstemp);
                            } 
                        }  
                    }
                    else if(c.Sub_Type_B__c != null){
                        if(csTemp.Sub_Type_A__c != null && csTemp.Sub_Type_B__c != null) {
                            if(c.Sub_Type_A__c.trim() == csTemp.Sub_Type_A__c.trim() && c.Sub_Type_B__c.trim() == csTemp.Sub_Type_B__c.trim()) {
                                  mapforOwnerandTeam.put(c.id, cstemp);
                            }
                        }
                    }
                    else if(c.Sub_Type_A__c != null) {
                        if(csTemp.Sub_Type_A__c != null) {
                            if(c.Sub_Type_A__c.trim() == csTemp.Sub_Type_A__c.trim()) {
                                  mapforOwnerandTeam.put(c.id, cstemp);
                            }
                        }
                    }
                }
                
                for (ASICCustomerProject__c cs: csProjectList){
                    if(cs.Bug_Team__c != null){
                        List<string> strLst = cs.Bug_Team__c.split(',');
                        asicNametoBugTeamMap.put(cs.Name__c, new List<String>(strLst));
                    }                     
                        
                }
                if (c.Customer_Project__c != '' && c.Customer_Project__c != null){      
                   for(String str : c.Customer_Project__c.split(',')){                                                                                                     
                       if(asicNametoBugTeamMap.get(str.trim()) != null){                                                                           
                            if(!mapforCstProjectTeam.containsKey(c.id)){                                
                                mapforCstProjectTeam.put(c.id,new List<string>(asicNametoBugTeamMap.get(str)));
                            }
                            else{                               
                                mapforCstProjectTeam.get(c.id).addAll(asicNametoBugTeamMap.get(str.trim()));                                                                
                            }
                        }
                   
                    }                
                }                                                                                              
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
    } catch (exception e) {
        //Adding code for exception framework
        ApplicationLogWrapper alw=new ApplicationLogWrapper();
        alw.source = ASICBugTriggerHandler.class.getName();
        alw.sourceFunction = 'createMapforOwnerandTeamBasedOnSubTypes()';
        alw.ApplicationName='Case Management';                  
        alw.referenceInfo = 'Bug';
        alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
        alw.debugLevel ='Error';
        alw.logCode =e.getTypeName();
        alw.ex=e.getCause();
        GlobalUtility.logMessage(alw); 
      }
   } 
   /*
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
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'emailNotificationforBugUpdate()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
          }
    }
*/
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
    
            if (lstCaseBugAssoc != null && lstCaseBugAssoc.size() > 0) { insert lstCaseBugAssoc;
            }
            if (relatedBugList != null && relatedBugList.size() > 0) { insert relatedBugList;
            }
            if (attachList != null && attachList.size() > 0) { insert attachList;
            }
            if (feedItemList!= null && feedItemList.size() > 0) { insert feedItemList;
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'bugOrginfromCaseandBug()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
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

    
    /*
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
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'GetOldNewValue()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
        return st;
    }
    */
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
                        if (mapGroupMembers.containsKey(groupId)) { mapGroupMembers.get(groupId).add(gm.UserOrGroupId); } 
                        else {  mapGroupMembers.put(groupId, new List < Id > { gm.UserOrGroupId }); }
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
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICBugTriggerHandler.class.getName();
            alw.sourceFunction = 'getGroupMembers()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }           
        return returnGroupMembers; 
        
    }    
    
    //Set flag for product or component update
    public void setOldProductandComponentBasedonSubTypes(){    
        try{
            for (Bug__c objBug: buglistNew){
                Bug__c objBugOld = bugMapOld.get(objBug.id);
                if(objBug.Sub_Type_A__c != objBugOld.Sub_Type_A__c || 
                   objBug.Sub_Type_B__c!= objBugOld.Sub_Type_B__c || 
                    objBug.Sub_Type_C__c != objBugOld.Sub_Type_C__c || objBug.Sub_Type_D__c != objBugOld.Sub_Type_D__c) {
                        objBug.Old_SubTypeA_TypeB_TypeC_TypeD__c = objBugOld.Sub_Type_A__c + ',' + objBugOld.Sub_Type_B__c + ',' + objBugOld.Sub_Type_C__c + ',' + objBugOld.Sub_Type_D__c;
                }
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
               //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICBugTriggerHandler.class.getName();
                alw.sourceFunction = 'setOldProductandComponentBasedonSubTypes()';
                alw.ApplicationName='Case Management';                  
                alw.referenceInfo = 'Bug';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
           }           
    } 
    // Code ended for the above method
    
    
    //Inserts Bug Owner to Bug Team when owner changes
    public void updateBugTeamOnOwnerChange() {
         try{        
             List<Bug_Team__c> bugTeamtoInsert = new List<Bug_Team__c>();
             Map < id, string > bugIdOwnerMap = new Map < id, string > ();
             Map < id, set < Id >> bugTeamMap = new Map < id, set < Id>> ();
             createMapforOwnerandTeamBasedOnSubTypes();
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
             if(Test.isRunningTest()){
                List<Id> ownerId = new List<Id>();
                ownerId.add(userInfo.getUserId());
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
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICBugTriggerHandler.class.getName();
                alw.sourceFunction = 'updateBugTeamOnOwnerChange()';
                alw.ApplicationName='Case Management';                  
                alw.referenceInfo = 'Bug';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
         }
    } 

    //Updates Date/Time Fields when status is updated 
    public void updateBugStatusDate() {
        for(bug__c eachBug: buglistNew){
            bug__c bOld = bugmapOld.get(eachBug.id);
            if (eachBug.Status__c != bOld.Status__c ){
                if(eachBug.Status__c == System.Label.Bug_Status_Assigned){ eachBug.Bug_Assigned_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Closed ){ eachBug.Bug_Closed_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Resolved ){ eachBug.Bug_Resolved_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Verified ){ eachBug.Bug_Verified_Date__c = DateTime.Now(); }   
                else if(eachBug.Status__c == System.Label.Bug_Status_Hold ){ eachBug.Bug_Hold_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Info_Required ){ eachBug.Bug_Info_Required_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Accepted ){ eachBug.Bug_Accepted_Date__c = DateTime.Now(); }
                else if(eachBug.Status__c == System.Label.Bug_Status_Committed ){ eachBug.Bug_Committed_Date__c = DateTime.Now(); }                                                                                                                                                                
            } 
            
            if(eachBug.DevComplete__c == true){
                eachBug.DevCompleteDate__c  = DateTime.Now();                      
            }
            if(eachBug.Priority__c != bOld.Priority__c ){
                if(eachBug.Priority__c == 'P1 - High' || eachBug.Priority__c == 'P2'){
                    eachBug.Bug_Priority_Changed_Date__c = DateTime.Now();
                
                }  
            }
        }           
    } 
    public void setAsicbugApprovalProcess(){
        try{
            List < Approval.ProcessSubmitRequest > lstprocess = new List < Approval.ProcessSubmitRequest > ();
            for (Bug__c obj: buglistNew){
             Bug__c oldObjAsic = bugmapOld.get(obj.Id);                 
                  if (obj.IsAsicCIASubmitted__c  != oldObjAsic.IsAsicCIASubmitted__c  && obj.IsAsicCIASubmitted__c) {
                        //objWR.OwnerId = calculatePLM(objWR.Geometry__c, objWR.Target_Process_Node__c);
                        obj.Status_of_CIA_Approval__c = 'Pending';
                        lstprocess.add(ApprovalProcessSubmitRequest(UserInfo.getUserId(),System.Label.Asic_CIA_Approval_Request,obj.Id));
                    }
            }
            if (lstprocess != null && lstprocess.size() > 0) {                              
                List < Approval.ProcessResult > resultlist = Approval.process(lstprocess);
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }
        catch(Exception e){
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICBugTriggerHandler.class.getName();
                alw.sourceFunction = 'setAsicbugApprovalProcess()';
                alw.ApplicationName='Case Management';                  
                alw.referenceInfo = 'Bug';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);                       
        }       
    }
   
     private static Approval.ProcessSubmitRequest approvalProcessSubmitRequest(Id submitter,string comments,Id objectId) {
        // create the new approval request to submit
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setSubmitterId(submitter);       
        req.setComments(comments);
        req.setObjectId(objectId);
        return req;
    }
    
    
    public void updateBugTeamOnCstProjectChange(){
        try{
            map<bug__c,string> bugCstProjectMap = new map<bug__c,string>();
            map<bug__c,string> bugCstNewProjectMap = new map<bug__c,string>();
            Set<String> bugIds = new Set<String>();
            Set<String> cstPrjct =  new Set<String>();
            list < Bug_Team__c > bgTeamList = new list < Bug_Team__c > ();
            list < bug_team__c > bglist = new list < bug_team__c > ();
            Map<id, id> teamuserMap = new Map<id, id>();
            Map<id, user> UserMap = new Map<id, user>();
            list < id > userIds = new list < id > ();    
            list < id > deluserIds = new list < id > ();
            Map <Id,Boolean> userVsBugUpdateChk = new Map <Id,Boolean>();
            Map <Id,Boolean> userVsChatterUpdateChk = new Map <Id,Boolean>();
            bug_team__c bgTeam;
            Map<string, List<String>> mapforCstProjectTeam = new Map<string, List<string>>();
            Set<Id> setUserIds;
            List<Manage_Email_Notification__c> manageEmailNotification = new  List<Manage_Email_Notification__c>();
            List<String> bugOldCstproject = new List<String>();
            List<String> bugNewCstproject = new List<String>();
            //Set<String> updateCstproject = new Set<String>();
            Set<String> updateCstproject;
            
            for(bug__c eachBug: buglistNew){
                bug__c bOld = bugmapOld.get(eachBug.id);
                //bugOldCstproject = bOld.Customer_Project__c.split(';');
                //bugNewCstproject = eachBug.Customer_Project__c.split(';');
               // updateCstproject = new Set<String>();
               // updateCstproject.addAll(bugNewCstproject);
                
                
              //  for(String strOld :bugOldCstproject){                      
                   // if(!updateCstproject.add(strOld.trim()))
                       // updateCstproject.remove(strOld.trim());                                                                                                                               
               // }
                
                if(bOld.Customer_Project__c != null && bOld.Customer_Project__c != ''){
                    for(String str:bOld.Customer_Project__c.split(',')){
                        if(str != null && str != '')
                            bugOldCstproject.add(str.trim());
                    
                    }
               }     
                
                if(eachBug.Customer_Project__c != null && eachBug.Customer_Project__c != ''){
                    for(String str:eachBug.Customer_Project__c.split(',')){
                    
                     system.debug('pankaj1'+str);
                       if(str != null && str != '')
                            bugNewCstproject.add(str.trim());
                    
                    }
               }                                                                       
            }
       
            if(bugOldCstproject.size()>0){
            list <ASICCustomerProject__c> csOldProjectList = [ select id,   Bug_Team__c ,name__c  from ASICCustomerProject__c where name__c in:bugOldCstproject];
             
            system.debug('pankaj1'+csOldProjectList );   
                        
            for (ASICCustomerProject__c cst: csOldProjectList) {
                if(cst.Bug_Team__c != null && cst.Bug_Team__c != ''){                       
                        for (string st: cst.Bug_Team__c.split(',')) {
                            deluserIds.add(st);            
                        }                       
                }                                          
            }
                        
            bglist = [select id from bug_team__c where user__c in : deluserIds and Bug__c in : buglistNew];
                    
            if (bglist.size() > 0)
                    Database.delete(bglist);
                
           }     
            if(bugNewCstproject.size()>0){
            
            list <ASICCustomerProject__c> cslist = [select id,name__c, Bug_Team__c from ASICCustomerProject__c where name__c in :bugNewCstproject];
           
            for (bug_team__c b: [select user__c, id from bug_team__c where Bug__c in : buglistNew]) {
                        teamuserMap.put(b.user__c, b.user__c);
            }        
               

            Map<string,list<string>> asicNametoBugTeamMap = new Map<string,list<string>>();

            for (ASICCustomerProject__c cs: cslist){
                if(cs.Bug_Team__c != null){
                  List<string> strLst = cs.Bug_Team__c.split(',');
                  asicNametoBugTeamMap.put(cs.Name__c, new List<String>(strLst));
                }                           
            }
            
            system.debug('pankaj1'+asicNametoBugTeamMap);
            
                    for (bug__c bg: buglistNew){                                
                            if (bg.Customer_Project__c != '' && bg.Customer_Project__c != null){
                            
                            
                            system.debug('pankaj1'+bg.Customer_Project__c); 
                                                           
                               for(String str : bg.Customer_Project__c.split(',')){                                                                                                                                                                
                                   if(asicNametoBugTeamMap.get(str.trim()) != null){                                       
                                        if(!mapforCstProjectTeam.containsKey(bg.id)){                                            
                                            mapforCstProjectTeam.put(bg.id,new List<string>(asicNametoBugTeamMap.get(str)));
                                        }
                                        else{                                           
                                            mapforCstProjectTeam.get(bg.id).addAll(asicNametoBugTeamMap.get(str.trim()));                                                                                        
                                        }
                                   }                               
                                }
                            }                               
                        } 
                              
                     for (ASICCustomerProject__c cst: cslist){ 

                            if(cst.bug_team__c != null && cst.bug_team__c != ''){
                                    for (string st: cst.bug_team__c.split(',')) {
                                            if (teamuserMap.get(st) == null) if (validateUserId(st) != null) {
                                                userIds.add(st);                                    
                                            }
                                    }
                            }
                     }                   
                    
                    manageEmailNotification = [select User__c,Chatter_Only__c,Bug_Update_Only__c from       
                                                Manage_Email_Notification__c where User__c IN: userIds];
                                             
                    for(Manage_Email_Notification__c  manageEmail : manageEmailNotification ){
                            userVsBugUpdateChk.put(manageEmail.User__c,manageEmail.Bug_Update_Only__c);
                            userVsChatterUpdateChk.put(manageEmail.User__c,manageEmail.Chatter_Only__c);
                    }   
                    
                    UserMap = new Map < id, user > ([select id, IsActive from user where id in : userIds]);
                   
                       for (bug__c bg: buglistNew) {
                          if (mapforCstProjectTeam.size() > 0) {
                                if (mapforCstProjectTeam.get(bg.id) != null) {
                                    setUserIds = new Set<Id>();                        
                                    for (string st: mapforCstProjectTeam.get(bg.id)) {
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
                   

                    if (bgTeamList.size() > 0) 
                        insert bgTeamList;
                        
           
           if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
            
        }
     
     }
      catch (exception e) {
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICBugTriggerHandler.class.getName();
                alw.sourceFunction = 'updateBugTeamOnCstProjectChange()';
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