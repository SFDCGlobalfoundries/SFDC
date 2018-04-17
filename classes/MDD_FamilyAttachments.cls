/* 
 Type Name: MDD_FamilyAttachments
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: FeedItems display for the related PartFamily record with view,
            delete,attach and download functions.
 
 */
public class MDD_FamilyAttachments{
    public List<FeedItem> lstAttach {get; set;}
    public string relatedRecordId {get; set;}
    public string recId {get; set;}
    Id stdId = ApexPages.currentPage().getParameters().get('id');
    public Part_Family__c fam {get; set;}
    public boolean showErrPan {get;set;}
    public String str {get; set;}
    
    public MDD_FamilyAttachments(ApexPages.StandardController controller) {
        showErrPan = false;
        if(stdId != null){
            Part_Family__c fam = new Part_Family__c();
            fam = [Select Id,Name from Part_Family__c where Id =: stdId];
            List<FeedItem> lstAttach = new List<FeedItem>();
            attach();
        }
        else{
            showErrPan = true;
        }
        str = '';
        for(MDD_EngineeringSpec__c lstStatic : [Select Id,Name, Content__c from MDD_EngineeringSpec__c order By Name Asc ]){
            str+=lstStatic.Content__c;
        }
    }
    public List<FeedItem> attach(){
        lstAttach = new List<FeedItem>();
        for(FeedItem fi : [ SELECT Id,ParentId,ContentType,RelatedRecordId, ContentFileName, Title 
                            FROM FeedItem 
                            WHERE ParentId =: stdId and Title != null]){
                lstAttach.add(fi);
        }
        
        return lstAttach;
    }
    public PageReference attachFile(){
        return new PageReference('/apex/MDDFeedItem?id='+stdId);
    }
    public PageReference download(){
        return new PageReference('/sfc/servlet.shepherd/version/download/'+relatedRecordId+'?asPdf=false&operationContext=CHATTER');
    }
    public PageReference viewFile(){
        return new PageReference('/'+relatedRecordId);
    }
    public PageReference deleteFile(){
        FeedItem fi = [Select Id from FeedItem where Id =: recId];
        delete fi;
        return new PageReference('/'+stdId);
    }
}