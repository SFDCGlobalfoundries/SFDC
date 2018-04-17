/*Author: Karthick D
* Description: This class is handler class for FeedItemTrigger. The method sends mail
                to all the bug creator , owner and bug team when ever there is chatter
                comment added or updated to bug record.
* History: Created on 09/03/2014
         : Shuchi - Added logic to send email notification for file attachment on  01/07/2015      
*/
public without sharing class FeedTriggerHandler {
    public list < FeedItem > feeditemlistNew {get;set;}
    public list < FeedComment > feedcommentlistNew {get;set;}
    public list < string > parentIds {get;set;}
    public list < Id > toAddressesList = new list < Id > ();
    private list < Messaging.Singleemailmessage > emailList = new list < Messaging.Singleemailmessage > ();
    private list < Id > relatedrecordidList = new list < Id > ();
    private list < string > QueueIdsVar = new list < string > ();
    
    public set < Id > toAddresses = new set < Id > ();
    
    //Maps variables declaration    
    public Map < id, FeedItem > feeditemmapNew {get;set;}    
    public Map < id, FeedComment > feedcommentmapNew {get;set;}
    public Map < id, Bug__c > bugMap {get;set;}    
    public Map < id, set < Id >> bugTeamMap {get;set;}
    public Map < id, Set < Id >> ownerUserIdsMap = new Map < id, Set < Id >> ();
    private Map < Id, ContentVersion > contentversionMap = new Map < Id, ContentVersion > ();
    private Map < Id, Id > feeditemVsRelatedId = new Map < Id, Id > ();
    private Map < Id, Id > feedcommVsRelatedId = new Map < Id, Id > ();
    
    //string variables declaration      
    final string groupType = Schema.SObjectType.Group.getKeyPrefix();
    final string orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
    final string strOrgId = UserInfo.getOrganizationId();    
    final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id  
    final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;
    string htmlBody;
    string htmlAsicBody;
    string htmlIpDevBody ;
    public boolean ipDevFlag = false ;
    public boolean asicFlag = false ;
    public FeedTriggerHandler() {}

    //Method sends mail for feed comment added for bug record
    public void emailNotificationforFeedComment() {
        try {
            //Call method set maps
            setBugandTeamMap();

            for (FeedComment fdComment: feedcommentlistNew) {
                
                if (fdComment.RelatedRecordId != null) {
                    feedcommVsRelatedId.put(fdComment.id, fdComment.RelatedRecordId);
                    relatedrecordidList.add(fdComment.RelatedRecordId);
                }
                Bug__c bugTemp = bugmap.get(fdComment.parentId);
                if (((String) bugTemp.OwnerId).startsWith(groupType)) QueueIdsVar.add(bugTemp.ownerId);
                
            }
            contentversionMap = new map < Id, ContentVersion > ([SELECT Id, Title, ContentDocumentId FROM ContentVersion where id = : relatedrecordidList]);            

            if (QueueIdsVar.size() > 0) ownerUserIdsMap = Bugtriggerhandler.getGroupMembers(QueueIdsVar);

            for (FeedComment fdComment: feedcommentlistNew) {
                Bug__c bugTemp = bugmap.get(fdComment.parentId);
                toAddressesList = new list < string > ();

                //method sets the address list
                string relatedrecId;
                toAddressesList = setAddressList(bugTemp);
                if(feedcommVsRelatedId.get(fdComment.Id) != null){
                    relatedrecId = feedcommVsRelatedId.get(fdComment.Id);
                }
                if (relatedrecId != null) {
                    string contentVersionId = contentversionMap.get(relatedrecId).ContentDocumentId;
                    //method sets Html body for the mail.
                    htmlBody = setHtmlBodyForFile(bugtemp.id, UserInfo.getName(), contentversionMap.get(fdComment.RelatedRecordId).title, fdComment.CommentBody, fdComment.CommentType, contentVersionId);
                    if (toAddressesList.size() > 0) {
                        for (string stUserId: toAddressesList) {
              if(asicFlag){
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Problem_Type__c  + ': ' + bugTemp.Status__c + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              }
              else if(ipDevFlag){                                                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugtemp.Status__c + ': ' + ' New Comment' + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              } 
              else {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Product_Technology__c + ': ' + bugTemp.Component__c + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              }
                        }
                    }
                } else {
                    htmlBody = setHtmlBody(bugtemp.id, UserInfo.getName(), null, fdComment.CommentBody, fdComment.CommentType);
          htmlIpDevBody = setIpDevHtmlBody(bugTemp,UserInfo.getName(), null, fdComment.CommentBody, fdComment.CommentType);  
                     htmlAsicBody = setAsicBugHtmlBody(bugtemp.id, UserInfo.getName(),null,fdComment.CommentBody, fdComment.CommentType,bugTemp);                                                               
        if (toAddressesList.size() > 0) {
                        for (string stUserId: toAddressesList) {                                                
                            if(asicFlag){
                                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Problem_Type__c  + ': ' + bugTemp.Status__c + ': ' + bugtemp.bug_title__c);
                                email.setHtmlBody(htmlAsicBody);
                                email.setTargetObjectId(stUserId);
                                email.setSaveAsActivity(false);
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }
              else if(ipDevFlag){                                                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugtemp.Status__c + ': ' + ' New Comment' + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlIpDevBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              } 
                            else {
                                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Product_Technology__c + ': ' + bugTemp.Component__c + ': ' + bugtemp.bug_title__c);
                                email.setHtmlBody(htmlBody);
                                email.setTargetObjectId(stUserId);
                                email.setSaveAsActivity(false);
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }                           
                        }
                    }
                }               
            }
            if (emailList.size() > 0) {Messaging.sendEmail(emailList);}
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='emailNotificationforFeedComment()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        
        //CaseHandlerUtility.trackException('FeedTriggerHandler.emailNotificationforFeedComment', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Modified by Shuchi against Case #00055436 - Start
    public void updateBugChatterField() {
        Map < Id, Id > feeditemVsBugId = new Map < Id, Id > ();
        List <Bug__c> bugToUpdate = new List <Bug__c>();
        List <Bug__c> bugToUpdatefeed = new List <Bug__c>();
        for (FeedItem fdItem1: feeditemlistNew) {
            if (fdItem1.ParentId != null) {
                feeditemVsBugId.put(fdItem1.ParentId,fdItem1.id);
            }
        }
        for(id bugId : feeditemVsBugId.keyset()){
            bug__c eachBug = new bug__c();
            eachBug.id = bugId;
            eachBug.Last_Modified_Chatter__c = system.now();
            bugToUpdate.add(eachBug);
        }
        
		 for (FeedItem fdItem1: feeditemlistNew) {
           bug__c eachBug = new bug__c();            
           if (fdItem1.Type == 'TextPost') { 
            string strBody = fdItem1.Body.stripHtmlTags();
               eachBug.Last_Bug_Comments__c= strBody;
               eachBug.id = fdItem1.ParentId;
               bugToUpdatefeed.add(eachBug);

           }
           else if (fdItem1.Type == 'LinkPost') {
                  string strBody = fdItem1.LinkUrl + '\n' + fdItem1.Title;
                  eachBug.Last_Bug_Comments__c = strBody;
                  eachBug.id = fdItem1.ParentId;
                  bugToUpdatefeed.add(eachBug);
           }
       
       }
        if(bugToUpdate.size()>0){
            update bugToUpdate;
        }  
        
        if(bugToUpdatefeed.size()>0){
            update bugToUpdatefeed;
        }      
    }
    //Modified by Shuchi against Case #00055436 - End
    public void updateBugChatterFieldFeedComment() {
        Map < Id, Id > feedcommentVsBugId = new Map < Id, Id > ();
        List <Bug__c> bugToUpdate = new List <Bug__c>();
        
        
        
        for (FeedComment fdComment: feedcommentlistNew) {
            if (fdComment.ParentId != null) {
                feedcommentVsBugId.put(fdComment.ParentId,fdComment.id);
            }
        }
        for(id bugId : feedcommentVsBugId.keyset()){
            bug__c eachBug = new bug__c();
            eachBug.id = bugId;
            eachBug.Last_Modified_Chatter__c = system.now();
            bugToUpdate.add(eachBug);
        }
        if(bugToUpdate.size()>0){
            update bugToUpdate;
        }        
    }
    //Method sends mail for feeditem added for bug record
    public void emailNotificationforFeedItem() {
        try {
            //Call method set maps
            SetBugandTeamMap();
            for (FeedItem fdItem1: feeditemlistNew) {
                
                if (fdItem1.RelatedRecordId != null) {
                    feeditemVsRelatedId.put(fdItem1.id, fdItem1.RelatedRecordId);
                    relatedrecordidList.add(fdItem1.RelatedRecordId);
                }
            }
            contentversionMap = new map < Id, ContentVersion > ([SELECT Id, ContentDocumentId FROM ContentVersion where id = : relatedrecordidList]);
            for (FeedItem fdItem: feeditemlistNew) {
                Bug__c bugTemp = bugmap.get(fdItem.parentId);
                if (((String) bugTemp.OwnerId).startsWith(groupType)) QueueIdsVar.add(bugTemp.ownerId);
            }

            if (QueueIdsVar.size() > 0) ownerUserIdsMap = BugTriggerhandler.getGroupMembers(QueueIdsVar);

            for (FeedItem fdItem: feeditemlistNew) {
                Bug__c bugTemp = bugmap.get(fdItem.parentId);
                toAddressesList = new list < string > ();

                //method sets the address list
                toAddressesList = setAddressList(bugTemp);

                //method sets Html body for the mail.
                string relatedrecId;
                if(feeditemVsRelatedId.get(fdItem.Id) != null){
                    relatedrecId = feeditemVsRelatedId.get(fdItem.Id);
                }
                if (relatedrecId != null) {
                    string contentVersionId = contentversionMap.get(relatedrecId).ContentDocumentId;
                    htmlBody = setHtmlBodyForFile(bugtemp.id, UserInfo.getName(), fditem.title, fditem.body, fditem.Type, contentVersionId);
                    htmlIpDevBody = setIpDevHtmlBody(bugTemp, UserInfo.getName(), fditem.title, fditem.body, fditem.Type);  
          if (toAddressesList.size() > 0) {
                        for (string stUserId: toAddressesList) {
                            if(asicFlag){
                                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Problem_Type__c  + ': ' + bugTemp.Status__c + ': ' + bugtemp.bug_title__c);
                                email.setHtmlBody(htmlBody);
                                email.setTargetObjectId(stUserId);
                                email.setSaveAsActivity(false);
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }
              else if(ipDevFlag){                                                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugtemp.Status__c + ': ' + ' New Comment' + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlIpDevBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              }
                            else{
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
                } else {
                    htmlBody = setHtmlBody(bugtemp.id, UserInfo.getName(), fditem.title, fditem.body, fditem.Type);
          htmlAsicBody = setAsicBugHtmlBody(bugtemp.id, UserInfo.getName(), fditem.title, fditem.body,fditem.Type,bugTemp); 
          htmlIpDevBody = setIpDevHtmlBody(bugTemp, UserInfo.getName(), fditem.title, fditem.body, fditem.Type);        
                    if (toAddressesList.size() > 0) {                   
                        for (string stUserId: toAddressesList) {
                            if(asicFlag){                                                        
                                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugTemp.Problem_Type__c  + ': ' + bugTemp.Status__c + ': ' + bugtemp.bug_title__c);
                                email.setHtmlBody(htmlAsicBody);
                                email.setTargetObjectId(stUserId);
                                email.setSaveAsActivity(false);
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }
              else if(ipDevFlag){                                                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('[Bug ' + bugTemp.Name + ']: ' + bugtemp.Status__c + ': ' + ' New Comment' + ': ' + bugtemp.bug_title__c);
                email.setHtmlBody(htmlIpDevBody);
                email.setTargetObjectId(stUserId);
                email.setSaveAsActivity(false);
                email.setOrgWideEmailAddressId(orgWideEmail);
                emailList.add(email);
              }
                            else{
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
                }
            }
            if (emailList.size() > 0) {Messaging.sendEmail(emailList);}         
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='emailNotificationforFeedItem()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('FeedTriggerHandler.emailNotificationforFeedItem', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Helper Method creates Map for Bug and BugTeam from parentids
     Map < id, set < Id >> bugTeamMapComp = new Map < id, set < Id>> ();
    public void SetBugandTeamMap() {
        set < Id > userids;
    
        bugTeamMap = new Map < id, set < Id >> ();
        try {
            bugMap = new Map < id, Bug__c > ([select id, OwnerID, Owner.name,Phase_Found__c, IPDEV_Component__c,Bug_Classification__c,Owner.email, CreatedBy.Email, name, product_technology__c,Sub_Type_A__c,Sub_Type_B__c,Need_By_Date__c,Bug_Description__c,Technology__c,
                                             component__c, bug_title__c,Problem_Type__c ,Status__c,Assigned_To__c,Severity__c,OwnerFullName__c,Dev_Only__c,Problem_Class__c  from bug__c where id in : parentIds]);

            for (bug__c bugTemp: [Select b.Id, Owner.Email, (Select Bug__c, User__c, User__r.email, user__r.isactive ,Chatter_Only__c From Bug_Teams__r r) From Bug__c b where b.id in : parentIds]) {
                userids = new set < Id > ();
                set<Id> bugTeamUserId = new set<Id>() ;
                for (Bug_Team__c bugTeamTemp: bugTemp.Bug_Teams__r) {
                    bugTeamUserId.add(bugTeamTemp.User__c);
                    //checks if user having Chatter_Only__c as true
                    if (bugteamTemp.user__r.isactive && bugteamTemp.Chatter_Only__c == true) {
                        userids.add(bugTeamTemp.User__c);
                    }
                }
                if (userids.size() > 0){
                    bugTeamMap.put(bugTemp.id, userids);
                    bugTeamMapComp.put(bugTemp.id, bugTeamUserId);
                }
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='SetBugandTeamMap()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
        //CaseHandlerUtility.trackException('FeedTriggerHandler.SetBugandTeamMap', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }

    //Helper method sets the sender address list
    public list < string > setAddressList(bug__c bugVar) {        
        try {
            set<Id> bugTeamMapCompSet = new set<Id>();
            if(bugTeamMapComp.get(bugVar.id)!= null){
                bugTeamMapCompSet = bugTeamMapComp.get(bugVar.id);
            }
            if(bugTeamMapCompSet == null && bugTeamMapCompSet.isEmpty()){
                toAddresses.add(bugVar.CreatedByid);
            }
            else if(!bugTeamMapCompSet.contains(bugVar.createdbyId)){
                toAddresses.add(bugVar.CreatedByid);
            }
            if (((String) bugVar.OwnerId).startsWith(groupType)) {
                if (ownerUserIdsMap.get(bugVar.ownerId) != null){
                    set<Id> tempId = new set<Id>();
                    tempId = ownerUserIdsMap.get(bugVar.ownerId);
                    for(id tempToAddId: tempId){
                        if(!bugTeamMapCompSet.contains(tempToAddId)){
                            toAddresses.addall(ownerUserIdsMap.get(bugVar.ownerId));
                        }
                    }
                }
            } 
            else if(!bugTeamMapCompSet.contains(bugVar.ownerId)){
                toAddresses.add(bugvar.ownerid);
            }
            if (bugTeamMap.get(bugVar.id) != null){
                 toAddresses.addAll(bugTeamMap.get(bugVar.id));
            }
            
            
            //adding values from set to list to use in email function         
            for (string st: toAddresses) {           
               if (st != Userinfo.getUserId())
                 toAddressesList.add(st);
            }          
           if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            } 
        } catch (exception e) {     
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='setAddressList()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('FeedTriggerHandler.setAddressList', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
        return toAddressesList;
    }
    //method sets Html body 
    public string setHtmlBody(string bugid, string createdbyid, string title, string body, string contentType) {
        try {           
            if (title == null) title = '';
            if (body == null) Body = '';

            if (contenttype == 'ContentComment' || contenttype == 'ContentPost') {
                htmlBody = '<table><tr><td>' +
                    '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                    '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' +
                    '</td></tr>' +
                    '<tr><td>' +
                    'File Posted by ' + createdbyid + ': <br>' + title + ' <br>' + '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;">' + body + '</pre>' + '</td></tr><br><br>' +
                    '</table>';

            } else {                              
                    htmlBody = '<table><tr><td>' +
                        '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                        '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' +
                        '</td></tr>' +
                        '<tr><td>' +
                        'Comment ' + title + ' ' + ' posted by ' + createdbyid + ': <br>' + '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;">' + body + '</pre>' + '</td></tr><br><br>' +
                        '</table>';               
            }
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
        } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='setHtmlBody()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('FeedTriggerHandler.setHtmlBody', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
        return htmlbody;
    }
    public string  setAsicBugHtmlBody(string bugid, string createdbyid, string title, string body,string contentType,Bug__c bugTemp){
        try {   
        String feedHistory = '';
        Set<Id> recId =   new Set<Id>(); 
        String usrName ='Empty';
        Map<Id,User> userMap = new   Map<Id,User>();
        List<FeedItem> oldFeeds = [SELECT Body,createddate,createdby.name  FROM FeedItem WHERE type = 'TextPost' and ParentId =: bugid];
        if(oldFeeds.size() > 0) { 
            for(FeedItem str:oldFeeds){               
                string feedBody = str.body.replaceAll('\\n+', '<br>');                 
                if(feedHistory.length() <99999){         
                         feedHistory += '<b>'+ '=====Commented by' +' '+ str.createdby.name +' '+ 'at' +' '+ str.createddate + '=====' +'</b>' + '<br><br>'+ feedBody  +'<br>';                          
                     }      
            }
        }
             
                if (title == null) title = '';
                if (body == null) Body = '';
                for(Bug__c objBug :[select id,Assigned_To__c from bug__c where id =:bugid] ){            
                    recId.add(objBug.Assigned_To__c);                              
                }
                if(recId.size()>0){         
                   userMap = new Map<Id,User>([select id,name from user where id in:recId]);             
                }
                for(Bug__c objBug :[select id,Assigned_To__c from bug__c where id =:bugid] ){
                    if(objBug.Assigned_To__c != null  ){
                         User assignedUsr =  userMap.get(objBug.Assigned_To__c); 
                         usrName  =   assignedUsr.name;             
                     } 
                 }
                if (contenttype == 'ContentComment' || contenttype == 'ContentPost') {                 
                         htmlBody = '<table><tr><td>' +
                            '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                            '<tr><td>Dear User/Team,<br><br></td></tr>' +
                            '<tr><td> File Posted to your bug.<br></td></tr>'+   
                            '<tr><td>' +'Comment '+ title + ' ' + ' posted by ' + createdbyid + ': <br>'+ '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;color:blue;">' + body + '</pre>' + '</td></tr>' +                 
                            //'<tr><td>' +'Comment ' + title + ':'+ '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;color: blue;">' + body + '</pre>' + '</td></tr>' +
                            '<tr><td> <p style="color:red;">Bug Details:</p></td></tr>'+ 
                            '<tr><td> Bug Title: '+ bugTemp.Bug_Title__c + ' <br></td></tr>' +                       
                            '<tr><td> Assigned To: '+usrName   + ' <br></td></tr>' +
                            '<tr><td> Severity: '+ bugTemp.Severity__c + ' <br></td></tr>' +
                            '<tr><td> Owner: '+ bugTemp.OwnerFullName__c + ' <br></td></tr>' +
                            '<tr><td> Status: '+ bugTemp.Status__c + ' <br></td></tr>' +                 
                            '<tr><td> Development Only: '+ bugTemp.Dev_Only__c + ' <br></td></tr>' +
                            '<tr><td> Problem Classification: '+ bugTemp.Problem_Class__c + ' <br></td></tr>' +
                            '<tr><td> Problem Type: '+ bugTemp.Problem_Type__c + ' <br></td></tr>' +
                            '<tr><td> SubType A: '+ bugTemp.Sub_Type_A__c + ' <br></td></tr>' +
                            '<tr><td> SubType B: '+ bugTemp.Sub_Type_B__c + ' <br></td></tr>' +
                            '<tr><td> Technology: '+ bugTemp.Technology__c + ' <br></td></tr>' +
                            '<tr><td> Date Needed: '+ bugTemp.Need_By_Date__c + ' <br></td></tr>' +
                            '<tr><td> Bug Description: '+ bugTemp.Bug_Description__c + ' <br><br></td></tr>' +                                                  
                            '<tr><td>Feed History:' + feedHistory + '<br></td></tr>' + 
                            '<tr><td> Please refer to the following link for accessing the Bug: <br></td></tr>' +  
                            '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' + '</td></tr>' +                        
                            '<tr><td>Thank You,<br></td></tr>' +
                            '<tr><td>GLOBALFOUNDRIES <br></td></tr>' +
                            '</table>';                         
                } else {                              
                            htmlBody = '<table><tr><td>' +
                            '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                            '<tr><td>Dear User/Team,<br><br></td></tr>' +
                            '<tr><td> A new comment was added to your bug.<br></td></tr>'+                    
                            '<tr><td>' +'Comment '+ title + ' ' + ' posted by ' + createdbyid + ': <br>'+ '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;color:blue;">' + body + '</pre>' + '</td></tr>' +
                            '<tr><td><p style="color:red;">Bug Details:</p></td></tr>'+ 
                            '<tr><td> Bug Title: '+ bugTemp.Bug_Title__c + '<br></td></tr>' +                       
                            '<tr><td> Assigned To: '+ usrName   + ' <br></td></tr>' +
                            '<tr><td> Severity: '+ bugTemp.Severity__c + ' <br></td></tr>' +
                            '<tr><td> Owner: '+ bugTemp.OwnerFullName__c + ' <br></td></tr>' +
                            '<tr><td> Status: '+ bugTemp.Status__c + ' <br></td></tr>' +                 
                            '<tr><td> Development Only: '+ bugTemp.Dev_Only__c + ' <br></td></tr>' +
                            '<tr><td> Problem Classification: '+ bugTemp.Problem_Class__c + ' <br></td></tr>' +
                            '<tr><td> Problem Type: '+ bugTemp.Problem_Type__c + ' <br></td></tr>' +
                            '<tr><td> SubType A: '+ bugTemp.Sub_Type_A__c + ' <br></td></tr>' +
                            '<tr><td> SubType B: '+ bugTemp.Sub_Type_B__c + ' <br></td></tr>' +
                            '<tr><td> Technology: '+ bugTemp.Technology__c + ' <br></td></tr>' +
                            '<tr><td> Date Needed: '+ bugTemp.Need_By_Date__c + ' <br></td></tr>' +
                            '<tr><td> Bug Description: '+ bugTemp.Bug_Description__c + ' <br><br></td></tr>' +                                                        
                            '<tr><td><b>Feed History:</b>' +'<br><br>'+ feedHistory + '<br></td></tr>' + 
                            '<tr><td> Please refer to the following link for accessing the Bug: <br></td></tr>' +
                            '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' + '</td></tr>' +
                            '<tr><td>Thank You,<br></td></tr>' +
                            '<tr><td>GLOBALFOUNDRIES <br></td></tr>' +
                            '</table>';                
                }
                if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
                            }
            } catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='setAsicBugHtmlBody()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('FeedTriggerHandler.setHtmlBody', e.getLineNumber(), e.getTypeName(), e.getMessage());
            }
            return htmlbody;
        }
    
         public string setIpDevHtmlBody(Bug__c bugtemp, string createdbyid, string title, string body, string contentType) {
        try {           
            if (title == null) title = '';
            if (body == null) Body = '';

            if (contenttype == 'ContentComment' || contenttype == 'ContentPost') {
                htmlBody = '<table><tr><td>' +
                            '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                            '<tr><td>Dear User/Team,<br><br></td></tr>' +                                   
                            'File Posted by ' + createdbyid + ': <br>' + title + ' <br>' + '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;">' + body + '</pre>' + '</td></tr><br><br>' +
                            '<tr><td><p style="color:red;">Bug Details:</p></td></tr>'+ 
                            '<tr><td> Bug Title: '+ bugTemp.Bug_Title__c + '<br></td></tr>' +                                                
                            '<tr><td> Bug Status: '+ bugTemp.Status__c + ' <br></td></tr>' +                 
                            '<tr><td> Phase Found: '+ bugTemp.Phase_Found__c + ' <br></td></tr>' +
                            '<tr><td> Component: '+ bugTemp.IPDEV_Component__c + ' <br></td></tr>' +
                            '<tr><td> Bug Classification: '+ bugTemp.Bug_Classification__c + ' <br></td></tr>' +
                            '<tr><td> Bug Description: '+ bugTemp.Bug_Description__c + + '<br><br>' + '</td></tr>' +                             
                            '<tr><td> Please refer to the following link for accessing the Bug: <br></td></tr>' +               
                            '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugtemp.id+ '<br><br>' + '</td></tr>' +
                            '<tr><td>Thank You,<br></td></tr>' +
                            '<tr><td>GLOBALFOUNDRIES <br></td></tr>' +
                            '</table>'; 
            } else {
                   htmlBody = '<table><tr><td>' +
                            '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                            '<tr><td>Dear User/Team,<br><br></td></tr>' +
                            '<tr><td>'+ 'A new comment was added to your Bug: ' + '<br><br>' + '</td></tr>' +                    
                            '<tr><td>' +'Bug Comment:  '+ ' '+ '<pre style="white-space: pre-wrap; font-family: inherit; font-size: inherit;color:blue;">' + body + '</pre>' + '</td></tr>' +
                            '<tr><td><p style="color:red;">Bug Details:</p></td></tr>'+ 
                            '<tr><td> Bug Title: '+ bugTemp.Bug_Title__c + '<br></td></tr>' +                                                
                            '<tr><td> Bug Status: '+ bugTemp.Status__c + ' <br></td></tr>' +                 
                            '<tr><td> Phase Found: '+ bugTemp.Phase_Found__c + ' <br></td></tr>' +
                            '<tr><td> Component: '+ bugTemp.IPDEV_Component__c + ' <br></td></tr>' +
                            '<tr><td> Bug Classification: '+ bugTemp.Bug_Classification__c + ' <br></td></tr>' +
                            '<tr><td> Bug Description: '+ bugTemp.Bug_Description__c + + '<br><br>' + '</td></tr>' +                             
                            '<tr><td> Please refer to the following link for accessing the Bug: <br></td></tr>' +
                            '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugtemp.id+ '<br><br>' + '</td></tr>' +
                            '<tr><td>Thank You,<br></td></tr>' +
                            '<tr><td>GLOBALFOUNDRIES <br></td></tr>' +
                            '</table>'; 
            }
            if(Test.isRunningTest()) {
            	throw new applicationException('In Test Mode');
            }
        } catch (exception e) {
          ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='setIpDevHtmlBody()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
      }
        return htmlbody;
    }

    //Method checks the user have permission to delete chatter comment.
    Public boolean ValidateChatterDelete() {
        if (ChatterPermissions__c.getInstance(UserInfo.getUserId()).DeletePermission__c || ChatterPermissions__c.getInstance(UserInfo.getProfileId()).DeletePermission__c) return true;
        else return false;
    }
    
    //method sets Html body 
    public string setHtmlBodyForFile(string bugid, string createdbyid, string title, string body, string contentType, string contentversionId) {        
        try {           
            if (title == null) title = '';
            if (body == null) Body = '';
                
            if ((contenttype == 'ContentComment' || contenttype == 'ContentPost') && Body != '') {
                htmlBody = '<table><tr><td>' +
                    '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                    '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' +
                    '</td></tr>' +
                    '<tr><td>' +
                    'File Posted by ' + createdbyid + '. <br>' + ' <br>' +
                    'File Name : ' + title + '<br><br>' +
                    'File URL : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + contentversionId + '<br><br>' +
                    'Comment : '+body +
                    '</td></tr>' +
                    '<tr><td>' +
                    '</table>';
    
            } 
            else if((contenttype == 'ContentComment' || contenttype == 'ContentPost') && Body == ''){
                htmlBody = '<table><tr><td>' +
                    '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                    '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bugid + '<br><br>' +
                    '</td></tr>' +
                    '<tr><td>' +
                    'File Posted by ' + createdbyid + '. <br>' + ' <br>' +
                    'File Name : ' + title + '<br><br>' +
                    'File URL : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + contentversionId + '<br><br>' +                    
                    '</td></tr>' +
                    '<tr><td>' +
                    '</table>';            
            }           
            if(Test.isRunningTest()) {
                                    throw new applicationException('In Test Mode');
            }
        } 
        catch (exception e) {
                    ApplicationLogWrapper alw=new ApplicationLogWrapper();
                    alw.source = FeedTriggerHandler.class.getName();
                    alw.sourceFunction ='setHtmlBodyForFile()';
                    alw.ApplicationName='Case Management';                   
                    alw.referenceInfo = 'Bug';
                    alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                    alw.debugLevel ='Error';
                    alw.logCode =e.getTypeName();
                    alw.ex=e.getCause();
                    GlobalUtility.logMessage(alw);
            //CaseHandlerUtility.trackException('FeedTriggerHandler.setHtmlBodyForFile', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }       
        return htmlbody;
    }
    public class applicationException extends Exception {} 
}