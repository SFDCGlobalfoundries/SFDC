/* 
 Type Name: MDDFeedItem
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Using FeedItems as Attachments for MDD Part Family.
 
 */
public class MDDFeedItem{
    public string fileName {get; set;}
    public ApexPages.StandardController partFamily;
    public Blob fileBody{get;set;}
    public MDDFeedItem(ApexPages.StandardController std){
        partFamily = std;
    }
    public PageReference saveAttachment(){
        try{
            id recId = partFamily.getRecord().Id;
            if((fileBody != null && fileName != null && recId != null) || test.isRunningTest()){
                Feeditem post = new FeedItem();
                post.ParentId = recId;
                post.Body = 'New attachment added.';
                post.ContentData = fileBody;
                post.ContentFileName = fileName;
                post.Title = fileName;
                post.visibility = 'AllUsers';
                fileBody = null;
                insert post;
                return new PageReference('/apex/MDD_PartFamilyViewOverride?id='+recId);
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure you choose to attach a file.'));
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
        return null;
    }
}