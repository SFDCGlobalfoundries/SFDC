/*
Type Name: DownloadAttachmentController 
Author: Case Management Team 
Created Date: 22/12/2015
Reason: Reason: This is the generic class which is used to download all the attachments associated with one record.
Test Class: DownloadAttachmentControllerTest
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
public class DownloadAttachmentController {
    public String objectName{
        get;
        set;
    }
    public List < attachmentWrapper > att {
        get;
        set;
    }
    public String selectedAttIds {
        get;
        set;
    }
    public DownloadAttachmentController() { 
        transient list < AllAttachment > feedItemAttachmentList = new List < AllAttachment > ();   
        transient list < AllAttachment > feedCommentAttachmentList = new List < AllAttachment > ();   
        transient list < AllAttachment > fileAttachmentList = new List < AllAttachment > ();
        try{
            if(ApexPages.currentPage().getParameters().get('id')!=NULL){ 
                feedItemAttachmentList = feedItemAttachmentMethod(ApexPages.currentPage().getParameters().get('id'));
                feedCommentAttachmentList = feedCommentAttachmentMethod(ApexPages.currentPage().getParameters().get('id'));
                fileAttachmentList = fileAttachmentMethod(ApexPages.currentPage().getParameters().get('id'));   
                objectName=findObjectNameFromRecordIdPrefix(ApexPages.currentPage().getParameters().get('id'));
                createListofAllAttachments(feedItemAttachmentList,feedCommentAttachmentList,fileAttachmentList);        
                
            }else{
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please pass parameters (ID) properly'));
            }
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please pass parameters properly'));
            System.debug(e);
        }
    }
    public void createListofAllAttachments(list < AllAttachment > feedItemAttachmentList, List < AllAttachment > feedCommentAttachmentList,list < AllAttachment > fileAttachmentList ){
        transient list < AllAttachment > listOfAllAttachments = new List < AllAttachment > (); 
        att = new List < attachmentWrapper > ();
        if (feedItemAttachmentList!= null && feedItemAttachmentList.size() > 0) 
            listOfAllAttachments.addAll(feedItemAttachmentList);
        if (feedCommentAttachmentList!= null && feedCommentAttachmentList.size() > 0) 
            listOfAllAttachments.addAll(feedCommentAttachmentList);
        if (fileAttachmentList!= null && fileAttachmentList.size() > 0) 
            listOfAllAttachments.addAll(fileAttachmentList);
        if(listOfAllAttachments!= null && listOfAllAttachments.size() > 0){
            for (AllAttachment attachments: listOfAllAttachments) 
                att.add(new attachmentWrapper(false, attachments));
        }       
    }
    public List<AllAttachment> feedItemAttachmentMethod (Id recordId){
        transient list < AllAttachment > filesList = new List < AllAttachment > ();     
        transient List < FeedItem > listFeedItemFiles = [SELECT Id,                                    
                                                                ContentFileName,
                                                                Title,
                                                                ContentSize,
                                                                CreatedDate,
                                                                RelatedRecordId,
                                                                LastModifiedDate,
                                                                InsertedBy.Name,
                                                                Visibility
                                                                FROM FeedItem
                                                                WHERE ParentId = : recordId
                                                                AND Type = 'ContentPost'];  
        if (listFeedItemFiles != null && listFeedItemFiles.size() > 0) {
            for (FeedItem fi: listFeedItemFiles)
                filesList.add(new AllAttachment(fi));
        }
        
        return filesList;
    }
    public List<AllAttachment> feedCommentAttachmentMethod (Id recordId){
        transient list < AllAttachment > filesList = new List < AllAttachment > ();   
        transient List < FeedComment > feedCommentList = [select id, RelatedRecordId from FeedComment where ParentId = : recordId AND CommentType = 'ContentComment'];                                                          
        transient list < Id > relatedrecordidList = new list < Id > ();
        transient list < ContentVersion > listFeedCommentFiles = new list < ContentVersion > ();        
                                               
        if (feedCommentList != null && feedCommentList.size() > 0) {
            for (FeedComment fc: feedCommentList) {
                if (fc.RelatedRecordId != null) {
                    relatedrecordidList.add(fc.RelatedRecordId);
                }
            }
        }
        if (relatedrecordidList != null && relatedrecordidList.size() > 0) 
            listFeedCommentFiles = [SELECT  Id,
                                            ContentModifiedDate,
                                            ContentSize,
                                            CreatedDate,
                                            Owner.Name,
                                            PublishStatus,
                                            Title,
                                            FileExtension
                                            FROM contentversion
                                            WHERE id IN: relatedrecordidList];
                                            
        if (listFeedCommentFiles != null && listFeedCommentFiles.size() > 0) {
            for (contentversion fc: listFeedCommentFiles)
                filesList.add(new AllAttachment(fc));
        }
        return filesList;
    }
    public List<AllAttachment> fileAttachmentMethod (Id recordId){
        transient list < AllAttachment > filesList = new List < AllAttachment > ();     
        transient List < Attachment > listAttachment = [Select  Id,
                                                                Owner.Name,
                                                                Name,
                                                                CreatedDate,
                                                                LastModifiedDate,
                                                                BodyLength,
                                                                IsPrivate
                                                                FROM Attachment
                                                                WHERE ParentId = : recordId];
                
        if (listAttachment != null && listAttachment.size() > 0) {
            for (Attachment att: listAttachment)
                filesList.add(new AllAttachment(att));
        }
        return filesList;
    }
       
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
        String objectName = '';
        String recordName = '';
        try{
            //Get prefix from record ID
            //This assumes that you have passed at least 3 characters
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
             
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                String CaseNumber ='CaseNumber';
                //Check if the prefix matches with requested prefix
                if(prefix!=null && myIdPrefix==prefix){
                    if(prefix.equals('500')){
                        objectName = r.getName();
                        string query = 'select id, '+CaseNumber+' from '+objectName+' where id='+'\'' + recordIdOrPrefix + '\'';
                        sObject cases=(sObject) Database.query(query);
                        recordName=String.valueOf(cases.get('CaseNumber'));
                        break;
                    }else{
                        String Name='Name';
                        objectName = r.getName();
                        string query = 'select id, '+Name+' from '+objectName+' where id='+'\'' + recordIdOrPrefix + '\'';
                        sObject cases=(sObject) Database.query(query);
                        recordName=String.valueOf(cases.get('Name'));
                        break;
                    }
                }
            }
        
        }catch(Exception e){
            System.debug(e);
        }
        return recordName;
    }
    
    public void prepareSelectedIds() {
        selectedAttIds = '';
        
        for (attachmentWrapper attWrap: att) {
            if (attWrap.isChecked) {
                selectedAttIds += attWrap.attObj.RecordId + ',';
            }
        }
        if (selectedAttIds.length() > 0) {
            selectedAttIds = selectedAttIds.substring(0, selectedAttIds.length() - 1);
        }
    }
    public PageReference Cancel(){
        if(ApexPages.currentPage().getParameters().get('id')!=NULL)
           return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        else
            return null;
    }
    //Wrapper class for select All functionality
    public class attachmentWrapper {
        public boolean isChecked {
            get;
            set;
        }
        public AllAttachment attObj {
            get;
            set;
        }

        public attachmentWrapper(boolean selectFlag, AllAttachment attachments) {
            isChecked = selectFlag;
            attObj = attachments;
        }
    }
    //AllAttachment - Sub-Class to hold Attachment & FeedItem object values
    public class AllAttachment {

        public Boolean isChatter {
            get;
            set;
        }
        public string Name {
            get;
            set;
        }
        public decimal Size {
            get;
            set;
        }
        public string OwnerName {
            get;
            set;
        }
        public Boolean isPublic {
            get;
            set;
        }
        public Datetime lastmodified {
            get;
            set;
        }
        public Datetime created {
            get;
            set;
        }
        public string urlDownload {
            get;
            set;
        }
        public Id RecordId;
        // AllAttachment initialization
        public AllAttachment(Attachment att) {
            RecordId = att.Id;
            isPublic = true;
            Name = att.Name;
            Size = att.BodyLength;
            OwnerName = att.Owner.Name;
            if (att.IsPrivate) {
                isPublic = false;
            }
            created = att.CreatedDate;
            lastmodified = att.LastModifiedDate;
            urlDownload = '/'+att.Id;
            isChatter = false;
        }
        public AllAttachment(FeedItem fi) {
            RecordId = fi.Id;
            isPublic = true;
            Name = fi.ContentFileName;
            Size = fi.ContentSize;
            OwnerName = fi.InsertedBy.Name;
            if (fi.Visibility == 'InternalUsers') {
                isPublic = false;
            }
            created = fi.CreatedDate;
            lastmodified = fi.LastModifiedDate;
            urlDownload = '/' +fi.RelatedRecordId;
            isChatter = true;
        }
        public AllAttachment(contentversion fc) {
            RecordId = fc.Id;
            isPublic = true;
            string url = '';
            Name = fc.Title + '.' + fc.FileExtension;
            Size = fc.ContentSize;
            OwnerName = fc.Owner.Name;
            if (fc.PublishStatus == 'P') {
                isPublic = true;
            } else if (fc.PublishStatus == 'R') {
                isPublic = false;
            }
            created = fc.CreatedDate;
            lastmodified = fc.ContentModifiedDate;
            urlDownload = '/' + fc.Id;
            isChatter = true;
        }
    }
}