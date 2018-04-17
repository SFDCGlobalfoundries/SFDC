/*
Type Name: WRFeedTriggerHandler
Author: Cognizant
Created Date: 04-07-2015
Reason: Reason: This is the controller class for all Feed Item and Feed Comment Email related activities.
Test Class: WorkRequestTriggerHandlerTest
Change History:
Author: 
Modified Date: 
History: Shuchi - Added logic to send email notification for file attachment on  01/07/2015 
……..
……..
--
*/
public with sharing class WRFeedTriggerHandler {
    //List Variables declaration    
    public list<FeedItem> feeditemlistNew {get;set;}
    public list <string> parentIds {get;set;}
    public list<FeedComment> feedcommentlistNew {get;set;}    
    public list < string > toAddressesList = new list < string > ();
    private list < Messaging.Singleemailmessage > emailList = new list < Messaging.Singleemailmessage > ();
    private list < Id > relatedrecordidList = new list < Id > ();    
    public set < string > toAddresses = new set < string > ();
    
    //Maps variables declaration    
    public Map<id, list<string>> toAddressMap {get;set;}
    public Map <id, FeedItem> feeditemmapNew {get;set;}    
    public Map<id, bug__c> bugMap {get;set;}    
    public Map <id, FeedComment> feedcommentmapNew {get;set;}
    private Map < Id, Id > feedcommVsRelatedId = new Map < Id, Id > ();
    private Map < Id, Id > feeditemVsRelatedId = new Map < Id, Id > ();     
    //string variables declaration   
    final string orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
    final string strOrgId = UserInfo.getOrganizationId();    
    final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id  
    final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;
    string htmlBody,subject;
    
    public WRFeedTriggerHandler() {
        parentIds = new list<string>();
        bugMap = new Map<id, bug__c>();
    }
    
    //Method sends mail for feedcomment added for WR record
    public void emailNotificationforFeedComment() {
        try { 
            FeedTriggerHandler feedtriggerhandlerVar = new FeedTriggerHandler();           
            Map < Id, ContentVersion > contentversionMap;
            list < Id > relatedrecordidList = new list < Id > ();
    
            //Set Map for toaddresses
            GettoAddress();
            for (FeedComment fdComment: feedcommentlistNew) {                
                if (fdComment.RelatedRecordId != null) {
                    feedcommVsRelatedId.put(fdComment.id, fdComment.RelatedRecordId);
                    relatedrecordidList.add(fdComment.RelatedRecordId);
                }
            }            
            contentversionMap = new map < Id, ContentVersion > ([SELECT Id, Title, ContentDocumentId FROM ContentVersion where id = : relatedrecordidList]);    
            for (feedComment f: feedcommentlistNew) {
                string relatedrecId;
                bug__c wrTemp = bugMap.get(f.parentid);
                list<string> toAddressesListTemp = new list < string > ();
                if(toAddressMap.get(f.parentid) != null){
                    toAddressesListTemp = toAddressMap.get(f.parentid);
                }
                if(feedcommVsRelatedId.get(f.Id) != null){
                    relatedrecId = feedcommVsRelatedId.get(f.Id);
                }
                if (relatedrecId != null) {
                    string contentVersionId = contentversionMap.get(relatedrecId).ContentDocumentId;
                    htmlBody = feedtriggerhandlerVar.setHtmlBodyForFile(wrTemp.id, UserInfo.getName(), contentversionMap.get(f.RelatedRecordId).title,  f.CommentBody, f.CommentType, contentVersionId);
                    if (toAddressesListTemp.size() > 0) {
                        String bug15DigitId = (string) f.parentId;
                        bug15DigitId = bug15DigitId.substring(0, 15);                   
                        subject = setSubject(wrTemp, f.CommentType);
                        
                        for (string stUserId: toAddressMap.get(f.parentId)) {
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject(subject);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stUserId);
                            email.setSaveAsActivity(false);
                            //email.setSenderDisplayName(UserInfo.getName());
                            email.setOrgWideEmailAddressId(orgWideEmail);
                            emailList.add(email);
                        }
                   }               
                }
                else {
                        subject = setSubject(wrTemp, f.CommentType);
                        htmlBody = feedtriggerhandlerVar.setHtmlBody(wrTemp.id, UserInfo.getName(), null , f.CommentBody, f.CommentType);
                        if (toAddressesListTemp.size() > 0) {
                            for (string stUserId: toAddressMap.get(f.parentId)) {
                                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                                email.setSubject(subject);
                                email.setHtmlBody(htmlBody);
                                email.setTargetObjectId(stUserId);
                                email.setSaveAsActivity(false);
                                //email.setSenderDisplayName(UserInfo.getName());
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }
                        }
               }
            }           
            if (emailList.size() > 0) {Messaging.sendEmail(emailList); }
       } 
        catch (exception e) {CaseHandlerUtility.trackException('WRFeedTriggerHandler.emailNotificationforFeedComment', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }

    //Method sends mail for feeditem added for WR record
    public void emailNotificationforFeedItem() {
        try {
            FeedTriggerHandler feedtriggerhandlerVar = new FeedTriggerHandler();  
            bugMap = new Map < id, bug__c > ([select id from bug__c where id in : parentids]);
            
            Map < Id, ContentVersion > contentversionMap;
            //Set Map for toaddresses
            GettoAddress();
            for (FeedItem fdItem1: feeditemlistNew) {                
                if (fdItem1.RelatedRecordId != null) {
                    feeditemVsRelatedId.put(fdItem1.id, fdItem1.RelatedRecordId);
                    relatedrecordidList.add(fdItem1.RelatedRecordId);
                }
            }

            contentversionMap = new map < Id, ContentVersion > ([SELECT Id, ContentDocumentId FROM ContentVersion where id = : relatedrecordidList]);    
            for (FeedItem f: feeditemlistNew) {
                string relatedrecId;
                if(feeditemVsRelatedId.get(f.Id) != null){
                    relatedrecId = feeditemVsRelatedId.get(f.Id);
                }            
                bug__c wrTemp = bugMap.get(f.parentId);
                if (relatedrecId != null) {
                    
                    if (toAddressMap.get(f.parentId).size() > 0) {
                       String bug15DigitId = (string) f.parentID;
                        bug15DigitId = bug15DigitId.substring(0, 15);
                        string contentVersionId = contentversionMap.get(relatedrecId).ContentDocumentId;
                        htmlBody = feedtriggerhandlerVar.setHtmlBodyForFile(wrTemp.id, UserInfo.getName(), f.title,  f.body, f.Type, contentVersionId);
                        subject = setSubject(wrTemp, f.Type);
                        for (string stUserId: toAddressMap.get(f.parentId)) {
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject(subject);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stUserId);
                            email.setSaveAsActivity(false);
                            //email.setSenderDisplayName(UserInfo.getName());
                            email.setOrgWideEmailAddressId(orgWideEmail);
                            emailList.add(email);
                        }
                    }
                }
                else{
                        String bug15DigitId = (string) f.parentID;
                        bug15DigitId = bug15DigitId.substring(0, 15);
        
                        htmlBody = feedtriggerhandlerVar.setHTMLBody(f.parentId, UserInfo.getName(), f.title, f.body, f.Type);
                        subject = setSubject(wrTemp, f.Type);
                        for (string stUserId: toAddressMap.get(f.parentId)) {
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject(subject);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stUserId);
                            email.setSaveAsActivity(false);
                            //email.setSenderDisplayName(UserInfo.getName());
                            email.setOrgWideEmailAddressId(orgWideEmail);
                            emailList.add(email);
                        }
                }
            
            }
            if (emailList.size() > 0) {
                Messaging.sendEmail(emailList);
            }
        } catch (exception e) {CaseHandlerUtility.trackException('WRFeedTriggerHandler.emailNotificationforFeedItem', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }

    //Method gets all toaddressids
    public list < string > GettoAddress() {
        try{
            toAddressMap = new map < id, list < string >> ();
            bugMap = new Map < id, bug__c > ([select id, OwnerID, Owner.name, Owner.email, CreatedBy.Email, name,
                Target_Process_Node__c, Geometry__c, bug_title__c, Short_title__c  from bug__c where id in : parentIds
            ]);
            //Get all WR request IDs
            for (bug__c b: [select id, createdbyid, ownerid from bug__c where id in : parentids]) {
                toAddresses = new set < string > ();
                toAddressesList = new list < string > ();
    
                // Get all cc list members
                for (CC_List__c c: [select id, user__c from CC_List__c where Bug_Work_Request__c = : b.id and user__r.isactive = true And Email_Opt_Out__c = false Limit 100]){
                    if(!toAddresses.Contains(c.user__c))
                        toAddresses.add(c.user__c);
                } 
                
                // Get all Component team members
                for (component_team__c c: [select id, user__c from component_team__c where Bug_Work_Request__c = : b.id and user__r.isactive = true And Email_Opt_Out__c = false Limit 100]){
                    if(!toAddresses.Contains(c.user__c))
                        toAddresses.add(c.user__c);
                }
    
                //Add the set to list
                    for (string st: toAddresses) {    
                        toAddressesList.add(st);
                    }
                toAddressMap.put(b.id, toAddressesList);
            }
        } catch (exception e) {CaseHandlerUtility.trackException('WRFeedTriggerHandler.GettoAddress', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        return null;
    }
    
    
    //method sets Html Subject
    public string setSubject(Bug__c wrTemp, string contentType) {
         string emailSubject;
         if (contenttype == 'ContentComment' || contenttype == 'ContentPost') {
             emailSubject = 'WR[' + wrTemp.Name + '] - New File Posted - ' + wrTemp.Short_title__c ;
         } else {
             emailSubject = 'WR[' + wrTemp.Name + '] - New Comment Posted - ' + wrTemp.Short_title__c ;
         }
        return emailSubject;   
    }

}