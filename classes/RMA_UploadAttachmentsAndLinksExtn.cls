/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class is used to upload attachments and links.
 *              Attachments are uploaded into Content Files using Force.com Rest toolkit. 
 * History:
 *    SurendranadhNune 25112015  -   Created.
 *                           
 **/
public with sharing class RMA_UploadAttachmentsAndLinksExtn{
    public String sectionName{get;set;}
     
    public String selTab {get;set;}
    @Testvisible
    private RMA__c rmaObj = new RMA__c();
    
    //params
    public String contentVersionId{get;set;}
    public String delContentDocId {get;set;}
    public String fileName {get;set;}
    public List<ContentDocumentLink> contentDocumentList{get; private set;} 
    private ApexPages.StandardController thisCon;
    
    public List<RMA_linkWrapper> linkWrapperList {get;set;}
    public String linkUrl   {get;set;}
    public String description {get;set;}
    public String delrmaLinkId {get;set;}
    public String delLinkUrl {get;set;}
    public List<RMA_Attachment__c> rmaLinksList {get;set;}
    public boolean hasDeleteAccess {get;set;}
    public boolean hasUploadAccess {get;set;}
    public boolean isAdmin{get;set;}
    
    //Constructor
    public RMA_UploadAttachmentsAndLinksExtn(ApexPages.StandardController controller){
        isAdmin = false;
        sectionName = '';
        selTab = '';
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge'); 
        thisCon = controller;
        rmaObj = (RMA__c)controller.getRecord();
        contentDocumentList = new List<ContentDocumentLink>();
        rmaLinksList = new List<RMA_Attachment__c>();
        linkWrapperList = new List<RMA_linkWrapper>();
       
        List<UserRecordAccess> userRecordAccessList = new List<UserRecordAccess>([SELECT HasEditAccess,RECORDID FROM UserRecordAccess 
                                                                                  WHERE USERID=:UserInfo.getUserId()
                                                                                  AND RECORDID=:rmaObj.id]);
        isAdmin = hasAdminPriv();
        if(!userRecordAccessList.isEmpty() || isAdmin){
            hasUploadAccess = userRecordAccessList[0].HasEditAccess || isAdmin;
            hasDeleteAccess = (userRecordAccessList[0].HasEditAccess || isAdmin) && 
                              (rmaobj.status__c != 'Pending for CN Issue' || rmaobj.status__c != 'Pending for SO Issue' || rmaobj.status__c != 'Closed RMA');
        }
                                                                                         
    }

    //This method is used to check if user came to this page by changing url.
    public pageReference checkSelectedTab(){
        selTab = ApexPages.currentPage().getParameters().get('selTab');

        if(String.isBlank(selTab)){
            return thisCon.view();
        }
        sectionName = RMA_Utility.getTabFromShortName(selTab);
        getRMAAttachments();
        getRMALinks();
        return null;
    }
    
    //This method is used to retreive links associated to a tab.
    public void getRMALinks(){
        List<String> lstSection = new List<String>();
        lstSection.addAll(sectionName.split(';'));       
        rmaLinksList = [SELECT ID,Resource_URL__c,createdbyid,createddate,section__c from Rma_Attachment__c where rma__c = :rmaObj.id 
                            AND section__c in : lstSection AND Resource_URL__c !=null];
    }
    
    //This method is used to retrieve attachments related to a tab.
    public void getRMAAttachments(){
        if(String.isNotBlank(sectionName)){
            List<String> rmaAttachIds = new List<String>();
            List<String> lstSection = new List<String>();
            lstSection.addAll(sectionName.split(';'));            
            for(Rma_Attachment__c rmaAttach : [SELECT ID,attachment__c,section__c from Rma_Attachment__c where rma__c = :rmaObj.id 
                                                //AND section__c=:sectionName and attachment__c !=null]){
                                                AND section__c in :lstSection AND attachment__c !=null]){
                rmaAttachIds.add(rmaAttach.id);
            }
            
            if(!rmaAttachIds.isEmpty()){
                contentDocumentList = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocumentId, ContentDocument.Title, ContentDocument.Fileextension, 
                                              ContentDocument.ContentModifiedDate, ContentDocument.OwnerId, LinkedEntityId, ContentDocument.FileType 
                                        FROM ContentDocumentLink 
                                        WHERE LinkedEntityId 
                                        IN:rmaAttachIds 
                                        ORDER BY ContentDocument.ContentModifiedDate DESC];
            }else{
                /* Content Documents can be queried only if there is a filter.
                   If there is only one document for the section, and if the document is deleted by user,
                   then the below statement will clear the list.*/
                contentDocumentList.clear();
            }
        }
     }
     
    
     @RemoteAction
     public static boolean insertRMAAttachment(Id rmaId, Id cvId, String sName, String fileName){
     	ContentVersion contVersionRec;
        RMA_Attachment__c rmaAttachObj;
        Savepoint sp = Database.setSavepoint();
        
        try{
            if(String.isNotBlank(sName) && cvId != null){
                
                contVersionRec = [select contentDocumentid from contentversion where id=:cvId];
                rmaAttachObj =  new RMA_Attachment__c();
                rmaAttachObj.Section__c = sName;
                rmaAttachObj.attachment__c = contVersionRec.contentDocumentid;
                rmaAttachObj.rma__c = rmaId; 
                insert rmaAttachObj; 
                
                if(rmaAttachObj.id != null){
                    //Inserting a feedpost to get the content document easily using LinkedEntityId. 
                    FeedItem post = new FeedItem();
                    post.RelatedRecordId = cvId;
                    post.ParentId = rmaAttachObj.id;
                    post.Type = 'ContentPost';
                    insert post; 
                    rma_utility.moveToLibrary(contVersionRec.contentDocumentid);
                }
            }
        }catch(Exception e){
            Database.rollback(sp);
            return false;
        }
        return true;
     }
    
     //This method is used to delete the inserted Content document/ RMA attachment.
     //RMA attachment is deleted through trigger(TriggerOnContentDoForCuSRFormHandler).
     public void deleteRMAAttachment(){
        try{
            if(String.isNotBlank(delContentDocId)){
                ContentDocument cDoc = new ContentDocument(id=delContentDocId);
                delete cDoc;
                getRMAAttachments();
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.confirm, '<b>' + fileName +' </b> deleted successfully'));
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.error, 'Failed to delete <b>' +fileName + '</b>'));
        }
     }
     
     //This method is used to save links. 
     public void saveLinks(){
        List<RMA_Attachment__c> rmaAttachments = new List<RMA_Attachment__c>();
        for(RMA_linkWrapper wrapObj : linkWrapperList){
            rmaAttachments.add(wrapObj.rmaAttachObj);
        }
        try{
            insert rmaAttachments;
            linkWrapperList.clear();
            getRMALinks();
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm, 'Link added successfully.'));
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error in saving links. Please try again.'));
        }
    }
    
     //This method is used to delete link. 
     public void deleteRMALink(){
        try{
            RMA_Attachment__c rmaAttach = new RMA_Attachment__c(id=delRmaLinkId);
            delete rmaAttach;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, '<b>'+ delLinkUrl+'</b> deleted successfully.'));
            getRMALinks();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error in deleting the link. <b>' + delLinkUrl + '</b>'));
        }
    }
    
    public pageReference backToRMA(){
        return new Pagereference('/apex/RMA_view?id='+rmaObj.id+'&selTab='+selTab);
     }
     
     //This method is used to add link. 
     public void addLink(){
        if(String.IsNotBlank(linkUrl)){
            if(!linkUrl.contains(' ')){
                RMA_linkWrapper wrapObj = new RMA_linkWrapper(linkUrl, description, sectionName, rmaObj.id);
                linkWrapperList.add(wrapObj);
                saveLinks();
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a url without any spaces.'));    
            }
            linkUrl = '';
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a url.'));
        }
    }
    
    //Method to check if the logged-in user is a system administrator.
    public boolean hasAdminPriv(){
        Profile p = [select Name from Profile where Id =: userInfo.getProfileId()];
        if(p.Name.equalsIgnoreCase('System Administrator')
        || p.Name.equalsIgnoreCase('GF Consultants')
        || p.Name.equalsIgnoreCase('GF Developer')
        || p.Name.equalsIgnoreCase('GF Integration')
        || p.Name.equalsIgnoreCase('GF System Admin')){
            return true;
        }
        else{
            return false;
        }
    }
    
    public class RMA_linkWrapper{
        public Boolean isChecked {get;set;}
        public RMA_Attachment__c rmaAttachObj {get;set;}
        
        public RMA_linkWrapper(String url, String description, String sectionName, String rmaId){
            rmaAttachObj =  new RMA_Attachment__c();
            rmaAttachObj.Section__c = sectionName;
            rmaAttachObj.Resource_URL__c = url;
            rmaAttachObj.rma__c = rmaId;
            rmaAttachObj.description__c = description;
            this.isChecked = false;
        }
    }
    
}