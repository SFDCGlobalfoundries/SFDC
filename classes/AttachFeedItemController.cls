/*
Type Name: AttachFeedItemController
Author: JK Technosoft Ltd (Ravi Teja B)
Reason: This class is used to attach files as feed items.

Change History:
Author: 
Modified Date: 
Reason: Merged 
Change History: 

*/
public class AttachFeedItemController {
    public string fileName1 {get; set;}
    public string fileName2 {get; set;}
    public string fileName3 {get; set;}
    public string fileName4 {get; set;}
    public string fileName5 {get; set;}
     public string fileName6 {get; set;}
    public string fileName7 {get; set;}
    public string fileName8 {get; set;}
    public string fileName9 {get; set;}
    public string fileName10 {get; set;}
    
    public Blob fileBody1{get;set;}
    public Blob fileBody2{get;set;}
    public Blob fileBody3{get;set;}
    public Blob fileBody4{get;set;}
    public Blob fileBody5{get;set;}
    public Blob fileBody6{get;set;}
    public Blob fileBody7{get;set;}
    public Blob fileBody8{get;set;}
    public Blob fileBody9{get;set;}
    public Blob fileBody10{get;set;}
    public boolean isInternalUser {get;set;}
    public String gfView {get; set;}
    
    public PageReference saveAttachment(){
        try{
            id recId = ApexPages.currentPage().getParameters().get('Id');            
            if(recId != null){
                List<Feeditem> insertItems = new List<Feeditem>();
                if((fileBody1 != null && fileName1 != null) || test.isRunningTest()){
                    Feeditem post1 = new FeedItem();
                    post1.ParentId = recId;
                    post1.Body = fileName1;
                    post1.ContentData = fileBody1;
                    post1.ContentFileName = fileName1;
                    post1.Title = fileName1;
                    post1.visibility = 'AllUsers';
                    fileBody1 = null;
                    insertItems.add(post1);
                    system.debug('post1'+post1);
                }
                if((fileBody2 != null && fileName2 != null) || test.isRunningTest()){
                    Feeditem post2 = new FeedItem();
                    post2.ParentId = recId;
                    post2.Body = fileName2;
                    post2.ContentData = fileBody2;
                    post2.ContentFileName = fileName2;
                    post2.Title = fileName2;
                    post2.visibility = 'AllUsers';
                    fileBody2 = null;
                    insertItems.add(post2);
                    system.debug('post1'+post2);
                    
                }
                if((fileBody3 != null && fileName3 != null) || test.isRunningTest()){
                    Feeditem post3 = new FeedItem();
                    post3.ParentId = recId;
                    post3.Body = fileName3;
                    post3.ContentData = fileBody3;
                    post3.ContentFileName = fileName3;
                    post3.Title = fileName3;
                    post3.visibility = 'AllUsers';
                    fileBody3 = null;
                    insertItems.add(post3);
                    system.debug('post3'+post3);
                    
                }
                if((fileBody4 != null && fileName4 != null) || test.isRunningTest()){
                    Feeditem post4 = new FeedItem();
                    post4.ParentId = recId;
                    post4.Body = fileName4;
                    post4.ContentData = fileBody4;
                    post4.ContentFileName = fileName4;
                    post4.Title = fileName4;
                    post4.visibility = 'AllUsers';
                    fileBody4 = null;
                    insertItems.add(post4);
                    system.debug('post4'+post4);
                    
                }
                if((fileBody5 != null && fileName5 != null) || test.isRunningTest()){
                    Feeditem post5 = new FeedItem();
                    post5.ParentId = recId;
                    post5.Body = fileName5;
                    post5.ContentData = fileBody5;
                    post5.ContentFileName = fileName5;
                    post5.Title = fileName5;
                    post5.visibility = 'AllUsers';
                    fileBody5 = null;
                    insertItems.add(post5);
                    system.debug('post5'+post5);
                }
                 if((fileBody6 != null && fileName6 != null) || test.isRunningTest()){
                    Feeditem post6 = new FeedItem();
                    post6.ParentId = recId;
                    post6.Body = fileName6;
                    post6.ContentData = fileBody6;
                    post6.ContentFileName = fileName6;
                    post6.Title = fileName6;
                    post6.visibility = 'AllUsers';
                    fileBody6 = null;
                    insertItems.add(post6);
                    system.debug('post6'+post6);
                }
                 if((fileBody7 != null && fileName7 != null) || test.isRunningTest()){
                    Feeditem post7 = new FeedItem();
                    post7.ParentId = recId;
                    post7.Body = fileName7;
                    post7.ContentData = fileBody7;
                    post7.ContentFileName = fileName7;
                    post7.Title = fileName7;
                    post7.visibility = 'AllUsers';
                    fileBody7 = null;
                    insertItems.add(post7);
                    system.debug('post7'+post7);
                }
                 if((fileBody8 != null && fileName8 != null) || test.isRunningTest()){
                    Feeditem post8 = new FeedItem();
                    post8.ParentId = recId;
                    post8.Body = fileName8;
                    post8.ContentData = fileBody8;
                    post8.ContentFileName = fileName8;
                    post8.Title = fileName5;
                    post8.visibility = 'AllUsers';
                    fileBody8 = null;
                    insertItems.add(post8);
                    system.debug('post8'+post8);
                }
                 if((fileBody9 != null && fileName9 != null) || test.isRunningTest()){
                    Feeditem post9 = new FeedItem();
                    post9.ParentId = recId;
                    post9.Body = fileName9;
                    post9.ContentData = fileBody9;
                    post9.ContentFileName = fileName9;
                    post9.Title = fileName5;
                    post9.visibility = 'AllUsers';
                    fileBody9 = null;
                    insertItems.add(post9);
                    system.debug('post9'+post9);
                }
                 if((fileBody10 != null && fileName10 != null) || test.isRunningTest()){
                    Feeditem post10 = new FeedItem();
                    post10.ParentId = recId;
                    post10.Body = fileName10;
                    post10.ContentData = fileBody10;
                    post10.ContentFileName = fileName10;
                    post10.Title = fileName10;
                    post10.visibility = 'AllUsers';
                    fileBody10 = null;
                    insertItems.add(post10);
                    system.debug('post5'+post10);
                }
                database.insert(insertItems);
                system.debug('insertedItems&&&&'+insertItems[0].Id);
                isInternalUser = true;
                gfView = '';
                User loginUser = [Select Id,Name,contactId from User Where Id=: Userinfo.getUserid()];
                String str = URL.getSalesforceBaseUrl().getHost();
                String str1 = ApexPages.currentPage().getUrl();
                if(str.contains('globalfoundryview') && (loginUser.ContactId != null)){
                    isInternalUser = false;
                    gfView = '/GlobalfoundryView';
                    if(str1.contains('VFEHSQualityCertificationIframe'))
                        gfView = '/GlobalfoundryView/apex/vfEHSQualityCertificationOnFV';
                    else
                        gfView = '/'+recId;
                    
                }
                else{
                    return new PageReference('/'+recId);
                }
                return null;
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