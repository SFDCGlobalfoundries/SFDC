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
global without sharing class FeedItemAttachmentComponentController {
    
    public List<FeedItem> lstAttach {get; set;}
    public string relatedRecordId {get; set;}
    public Boolean isInternalUser {get; set;}
    public User loginUser;
    public String gfView {get; set;}
    public string recId = ApexPages.currentPage().getParameters().get('Id');   
    public FeedItemAttachmentComponentController(){
        SYSTEM.DEBUG('recId***'+recId);
        Set<Id> finalId = new Set<Id>();
            isInternalUser = true;
            gfView = '';
            loginUser = [Select Id,Name,contactId from User Where Id=: Userinfo.getUserid()];
            String str = URL.getSalesforceBaseUrl().getHost();
            String str1 = ApexPages.currentPage().getUrl();
            if((str.contains('globalfoundryview') && (loginUser.ContactId != null)) || test.isRunningTest()){
                isInternalUser = false;
                gfView = '/GlobalfoundryView';
                system.debug('str1==='+str1);
                if(str1.contains('EHS'))
                    gfView = '/GlobalfoundryView/apex/vfEHSQualityCertificationOnFV';
                else IF(str1.contains('BCM'))
                    gfView = '/GlobalfoundryView/apex/vfBCMQualityCertificationOnFV';
                else if(str1.contains('Impact'))
                    gfView = '/GlobalfoundryView/apex/vfImpactNotificationOnFV';
                else
                    gfView = '';
            }
        Attachfinal();
            
    }
    public void Attachfinal(){
        lstAttach = new List<FeedItem>();
        try{
        if(recId != null){
                for(FeedItem fi: [SELECT Id,ParentId,RelatedRecordId,Title,CreatedDate,ContentType,ContentSize,Type FROM FeedItem WHERE ParentId =: recId and Title != null]){
                                          
                                          lstAttach.add(fi);
                                  }
                                  system.debug('lstAttach==>'+lstAttach);
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No Record Id Found'));
                
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            
        }
    }
    public PageReference download(){
        return new PageReference('/sfc/servlet.shepherd/version/download/'+relatedRecordId+'?asPdf=false&operationContext=CHATTER');
    }
    public PageReference viewFile(){
        return new PageReference('/'+relatedRecordId);
    }
    public PageReference deleteFile(){
        List<FeedItem> fi = [Select Id,ParentId from FeedItem where Id =: relatedRecordId];
        Database.delete(fi);
        String str1 = ApexPages.currentPage().getUrl();
        Attachfinal();
        return null;
    }
}