/*
Type Name: SimulationRequestHandler
Author: Cognizant Case Mgmt Team
Created Date: 25-07-2015
Reason: This is the controller class for WorkRequestTrigger related to Simulation Request.
Test Class: SimulationRequestHandlerTest
Change History:
Author: Shuchismita Mallik
Modified Date: 30-07-2015
……..
……..
--
*/
public class SimulationRequestHandler {
    //List variables declaration 
    List<Bug__share> updateShare = new List<Bug__share>();
    public list <string> parentIds {get;set;}
    public list <string> parentId;
    public list<FeedItem> feeditemlistNew {get;set;}
    public list<FeedComment> feedcommentlistNew {get;set;} 
    private list < Messaging.Singleemailmessage > emailList = new list < Messaging.Singleemailmessage > ();
    public list < string > toAddressesList = new list < string > ();
    private list < Id > relatedrecordidList = new list < Id > ();
    
    //Map Variables declaration 
    public Map<id, bug__c> bugMap {get;set;}  
    private Map < Id, Id > feedcommVsRelatedId = new Map < Id, Id > ();  
    private Map < Id, Id > feeditemVsRelatedId = new Map < Id, Id > (); 
    public Map<id, list<string>> toAddressMap {get;set;}
        
    //string variables declaration      
    final string groupType = Schema.SObjectType.Group.getKeyPrefix();
    final string userType = Schema.SObjectType.User.getKeyPrefix();
    final string strOrgId = UserInfo.getOrganizationId();    
    final string gfDocId = System.Label.GF_Logo_Document_Id; // GF Logo Id  
    final string strDocUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + gfDocId + '&oid=' + strOrgId;
    string htmlBody,subject;
    final string orgWideEmail = System.Label.Bug_OrgWideEmailAddress;
    
    BugTriggerHandler BugTriggerHandlerVar = new BugTriggerHandler();
    public set < string > toAddresses = new set < string > ();
      
    
    public SimulationRequestHandler() {
        parentIds = new list<string>();
        bugMap = new Map<id, bug__c>();
    }

    //Shares record with SR creator on after insert event
    public void onAfterInsertSimulationRequest(Bug__c[] srNewList) {
        onInsertBugShareAndUpdateOwner(srNewList);
    }
    /*Shares record with SR Owner on after Update
      Shares record with SR creator on after Update
      Email Notification on SR update */
    public void onAfterUpdateSimulationRequest(Bug__c[] oldSR, Bug__c[] updatedSR, Map < ID, Bug__c > SROldMap) {
        onInsertBugShareAndUpdateOwner(updatedSR, SROldMap);
        onUpdateBugShareOnOwnerChange(updatedSR, SROldMap);
        emailNotificationforSRUpdate(updatedSR, SROldMap);
    }
    //Shares record with SR creator on after Update
    public void onUpdateBugShareOnOwnerChange(Bug__c[] updatedSR, Map < ID, Bug__c > SRMap){
        Set < Id > SRIdstoSetOwner = new Set < Id > ();
        for (Bug__c objSR: updatedSR) {
            Bug__c oldObjSR = SRMap.get(objSR.Id);
            if (objSR.ownerId != oldObjSR.ownerId && objSR.ownerId != objSR.createdById) {
                SRIdstoSetOwner.add(objSR.Id);
            }  
        }    
        List<Bug__c> bugToUpdateOwner = new List<Bug__c>();
        if(!SRIdstoSetOwner.isEmpty()){
            bugToUpdateOwner = [select id,ownerId,createdById from Bug__c where id in : SRIdstoSetOwner];
        }
        for(Bug__c bugEach: bugToUpdateOwner){
            createShareforCreated(bugEach);
        } 
        if(!updateShare.isEmpty()){
            insert updateShare;
            updateShare.clear();
        }  
    }
    public list<Bug__share> createShareforCreated(Bug__c allBug){        
        updateShare.add(new Bug__Share(ParentId = allBug.Id, UserOrGroupId = allBug.createdById, AccessLevel = 'Edit'));        
    return updateShare;
    }

    //Shares record with SR Owner on after Update
    private void onInsertBugShareAndUpdateOwner(Bug__c[] updatedSR, Map < ID, Bug__c > SRMap) {
        try {
            Set < Id > SRIds = new Set < Id > ();
            for (Bug__c objSR: updatedSR) {
                Bug__c oldObjSR = SRMap.get(objSR.Id);
                if (objSR.IsAssignment__c != oldObjSR.IsAssignment__c && objSR.IsAssignment__c) {
                    SRIds.add(objSR.Id);
                }  
            }
            if (SRIds != null && SRIds.size() > 0) insertBugShareAndUpdateOwner(SRIds);

        } catch (Exception e) {
            CaseHandlerUtility.trackException('WorkRequestTriggerHandler.onInsertBugShareAndUpdateOwner', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Method to insert Creator into Bug SHare object and Update Owner
    public void onInsertBugShareAndUpdateOwner(bug__c[] srNewList) {
        try {
            Set < Id > setIds = New Set < Id > ();
            for (bug__c srObj: srNewList) {
                setIds.add(srObj.Id);
            }
            if (setIds != null && setIds.size() > 0) insertBugShareAndUpdateOwner(setIds);
        } catch (Exception e) {
            CaseHandlerUtility.trackException('SimulationRequestHandler.onInsertBugShareAndUpdateOwner', e.getLineNumber(), e.getTypeName(), e.getMessage());
        }
    }
    //Method to insert Creator into Bug SHare object and Update Owner (Simulation Request Queue)   
    public static void insertBugShareAndUpdateOwner(Set < Id > setIds) {
        try {
            List < Bug__Share > lstBugShare = New List < Bug__Share > ();
            List < Bug__c > lstBug = New List < Bug__c > ();
            List < Bug__c > listBugTemp = [SELECT Id, OwnerId, IsAssignment__c from Bug__c WHERE Id In: setIds];
            List < Bug__Share > listBugShareTemp = [SELECT Id from Bug__Share WHERE ParentId In: setIds AND UserOrGroupId = : UserInfo.getUserId() AND RowCause = 'Manual'];
            string queueId = System.Label.Simulation_Request_Queue;
            for (Bug__c objBug: listBugTemp) {
                if (listBugShareTemp.isEmpty()) {
                    lstBugShare.add(new Bug__Share(ParentId = objBug.Id, UserOrGroupId = UserInfo.getUserId(), RowCause = 'Manual', AccessLevel = 'Edit'));
                }     
                lstBug.add(new Bug__c(Id = objBug.Id, OwnerId = queueId , IsAssignment__c = false));
            }
            if (lstBug != null && lstBug.size() > 0) update lstBug;
            if (lstBugShare != null && lstBugShare.size() > 0) insert lstBugShare;

        } catch (Exception e) {
            CaseHandlerUtility.trackException('SimulationRequestHandler.insertBugShareAndUpdateOwner', e.getLineNumber(), e.getTypeName(), e.getMessage());
       }
    }
    //Sends email On Comment/File post in the FeedItem related to SR
    Public void emailNotificationforFeedItem() {
        try {
            parentId = new list <string>();
            parentId = parentids;
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
                bug__c srTemp = bugMap.get(f.parentId);
                if (relatedrecId != null) {
                    
                    if (toAddressMap.get(f.parentId).size() > 0) {
                        String bug15DigitId = (string) f.parentID;
                        bug15DigitId = bug15DigitId.substring(0, 15);
                        string contentVersionId = contentversionMap.get(relatedrecId).ContentDocumentId;
                        htmlBody = feedtriggerhandlerVar.setHtmlBodyForFile(srTemp.id, UserInfo.getName(), f.title,  f.body, f.Type, contentVersionId);
                        subject = setSubject(srTemp, f.Type);
                        for (string stUserId: toAddressMap.get(f.parentId)) {
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject(subject);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stUserId);
                            email.setSaveAsActivity(false);
                            email.setOrgWideEmailAddressId(orgWideEmail);
                            emailList.add(email);
                        }
                    }
                }
                else{
                        String bug15DigitId = (string) f.parentID;
                        bug15DigitId = bug15DigitId.substring(0, 15);
        
                        htmlBody = feedtriggerhandlerVar.setHTMLBody(f.parentId, UserInfo.getName(), f.title, f.body, f.Type);
                        subject = setSubject(srTemp, f.Type);
                        for (string stUserId: toAddressMap.get(f.parentId)) {
                            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                            email.setSubject(subject);
                            email.setHtmlBody(htmlBody);
                            email.setTargetObjectId(stUserId);
                            email.setSaveAsActivity(false);
                            email.setOrgWideEmailAddressId(orgWideEmail);
                            emailList.add(email);
                        }
                }
            
            }
           if (emailList.size() > 0) {
                Messaging.sendEmail(emailList);
            }
        } catch (exception e) {CaseHandlerUtility.trackException('SimulationRequestHandler.emailNotificationforFeedItem', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }
    //Method sends mail for feedcomment added for SR record
    public void emailNotificationforFeedComment() {
        try {
            parentId = new list <string>();
            parentId = parentids;         
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
                toAddressesListTemp = toAddressMap.get(f.parentid);
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
                                email.setOrgWideEmailAddressId(orgWideEmail);
                                emailList.add(email);
                            }
                        }
               }
            }           
            if (emailList.size() > 0) {Messaging.sendEmail(emailList); }
        } 
        catch (exception e) {CaseHandlerUtility.trackException('SimulationRequestHandler.emailNotificationforFeedComment', e.getLineNumber(), e.getTypeName(), e.getMessage());}
    }
    //Method gets all toaddressids
    List<Id> ownerId = new List<Id>();
    Map < Id, set < Id > > GroupVsUserMap = new Map < Id, set < Id > >();
    public list < string > GettoAddress() {
        try{
            toAddressMap = new map < id, list < string >> ();
            bugMap = new Map < id, bug__c > ([select id, OwnerID, Owner.name, Owner.email, CreatedBy.Email, name,
                Target_Process_Node__c, Geometry__c, bug_title__c, Short_title__c  from bug__c where id in : parentId
            ]);

            for (bug__c b: [select id, createdbyid, ownerid from bug__c where id in : parentid]) {
                  ownerId.add(b.ownerid); 
            }
            GroupVsUserMap = BugTriggerHandler.getGroupMembers(ownerId);
            for (bug__c b: [select id, createdbyid, ownerid from bug__c where id in : parentid]) {
               set<Id> ownerIdSet = new set<Id>();
                toAddresses = new set < string > ();
                toAddressesList = new list < string > ();
                toAddresses.add(b.createdbyid); 
                //toAddresses.add(b.ownerid);  
                if(GroupVsUserMap.get(b.ownerid) != null){
                    ownerIdSet =  GroupVsUserMap.get(b.ownerid);                
                    for(Id eachOwnerId :ownerIdSet ){
                        toAddresses.add(eachOwnerId);
                    }     
                }         
                //Add the set to list
                if(!toAddresses.isEmpty()){
                    for (string st: toAddresses) {    
                        toAddressesList.add(st);
                    }
                    toAddressMap.put(b.id, toAddressesList);
                }
            }
        } catch (exception e) {CaseHandlerUtility.trackException('SimulationRequestHandler.GettoAddress', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        return null;
    }
    //Method to Set Subject for Chatter email notification
    public string setSubject(Bug__c srTemp, string contentType) {
         string emailSubject;
         if (contenttype == 'ContentComment' || contenttype == 'ContentPost') {
             emailSubject = 'Simulation Request[' + srTemp.Name + '] - New File Posted - ' + srTemp.Short_title__c ;
         } else {
             emailSubject = 'Simulation Request[' + srTemp.Name + '] - New Comment Posted - ' + srTemp.Short_title__c ;
         }
        return emailSubject;   
    }
    //Email Notification on SR update
    public void emailNotificationforSRUpdate(Bug__c[] updatedSR,Map < ID, Bug__c > SROldMap) {
    try{
        set<string> toAddressesSet = new set<string>();
        List < GroupMember > groupMembers = new List < GroupMember > ();
        Set <String> grpMemUserId = new Set <String>();
        String simulationReq = System.Label.Simulation_Request_Queue;
        groupMembers = [Select Id, GroupId, UserOrGroupId From GroupMember Where GroupId =: simulationReq Limit 100];                 
        for(GroupMember gm: groupMembers){
            grpMemUserId.add(gm.UserOrGroupId);
        }
        
        parentId = new list <string>();           
        for (bug__c bugTemp: updatedSR) 
        {
            parentId.add(bugTemp.id);
        }           
        GettoAddress();
        
        for (bug__c bugTemp: updatedSR){   
            List<string> toAddressUpdateList = new List<string> ();
            List<string> toAddressUpdateListFinal = new List<string> ();
            set<string> toAddressUpdateSet = new set<string> ();
            String bugTempId = bugTemp.id;
            String bug15DigitId = bugTempId.substring(0, 15);
            string strValue;            
            if(toAddressMap.get(bugTemp.id)!= null){
                toAddressUpdateList = toAddressMap.get(bugTemp.id);
                toAddressUpdateSet.addALL(toAddressUpdateList);
            }
            if(!groupMembers.isEmpty()){
                    toAddressUpdateSet.addALL(grpMemUserId);
            }
            if(!toAddressUpdateSet.isEmpty()){
                toAddressUpdateListFinal.addALL(toAddressUpdateSet);                        
                strValue = GetOldNewValue(SROldMap.get(bugTemp.id),bugTemp);
            }
            if(strValue !=null && strValue !=''){
                htmlBody = '<table><tr><td>' +
                    '<img id=r1sp1 src=' + strDocUrl + '></img>' + '</td></tr>' +
                    '<tr><td>Dear User,  <br></td></tr>' +
                    '<tr><td> Simulation Request ' + BugTemp.name + ' has been updated by ' + Userinfo.getName() + ' recently. Below listed the changes made: <br><br> </td><tr> ' +
                    '<tr><td> ' + strValue + ' <br></td></tr>' +
                    '<tr><td> Clicking on the link below, to view the Simulation Request details: </td></tr>' +
                    '<tr><td>' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + bug15DigitId + '</td></tr><br><br>' +
                    '<tr><td>Thank You <br>' +
                    '</td></tr></table>'; 
                for (string stUserId1: toAddressUpdateListFinal) {
                    Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                    email.setSubject('Simulation Request[' + bugTemp.Name + '] - ' + bugtemp.Short_Title__c);
                    email.setHtmlBody(htmlBody);
                    email.setTargetObjectId(stUserId1);
                    email.setSaveAsActivity(false);
                    email.setOrgWideEmailAddressId(orgWideEmail);
                    emailList.add(email);
                }
            }
        }
        if (emailList.size() > 0) {Messaging.sendEmail(emailList);}
    } 
    catch (exception e) {CaseHandlerUtility.trackException('SimulationRequestHandler.emailNotificationforSRUpdate', e.getLineNumber(), e.getTypeName(), e.getMessage());}
   }
    //Method finds and the field list recently updated.
    public string GetOldNewValue(bug__c bOld, bug__c bNew) {
        Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.bug__c.fields.getMap();
        Set < String > nonCompareSet = new Set < String > ();
        string st, stText;
        try{
            for (SRNonCompareFields__c key: SRNonCompareFields__c.getall().values())
                nonCompareSet.add((string) key.Name.toupperCase());
       
        
            for (Schema.SObjectField field: schemaFieldMap.values()) {
                string fieldname = field.getDescribe().getname();
                if (!nonCompareSet.Contains(fieldname.toupperCase())) {
                    if (bold.get(fieldname) != bnew.get(fieldname)) {
                        string fieldLabel = schemaFieldMap.get(fieldName).getDescribe().getlabel();                    
                        if (string.valueof(field.getDescribe().getType()) == 'TEXTAREA') {
                            if (stText == null)
                                stText = '<tr><td>' + ' ' + fieldLabel + ' updated to:</b></br></td></tr><tr><td><b>' + BugTriggerHandlerVar.replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                            else
                                stText += '<tr><td>' + ' ' + fieldLabel + ' updated to:</b></br></td></tr><tr><td><b>' + BugTriggerHandlerVar.replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
        
                        } else {
        
                            if (st == null)
                                st = '<tr><td>' + ' ' + fieldLabel + ' updated from  <b>' + BugTriggerHandlerVar.replaceNull(bold.get(fieldName)) + '</b> to <b>' + BugTriggerHandlerVar.replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                            else
                                st += '<tr><td>' + ' ' + fieldLabel + ' updated from  <b>' + BugTriggerHandlerVar.replaceNull(bold.get(fieldName)) + '</b> to <b>' + BugTriggerHandlerVar.replaceNull(bnew.get(fieldName)) + '</b></br></td></tr>' + ' ';
                        }
                    }
                }
            }
        
            if (st == null && stText != null) {
                st = stText;
            } else if (st != null && stText != null) {
                st += stText;
            }
        } catch (exception e) {CaseHandlerUtility.trackException('SimulationRequestHandler.GetOldNewValue', e.getLineNumber(), e.getTypeName(), e.getMessage());}
        return st;
    }
}