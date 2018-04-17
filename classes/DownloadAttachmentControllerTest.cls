/*
Type Name: DownloadAttachmentControllerTest
Author: Cognizant Case Management Team
Created Date: 23rdDec2015
Reason: This is the Test class for DownloadAttachmentController class, UCMZipUtil class and UCMZipWebServiceHandler class . 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(seeAllData=false)
private class DownloadAttachmentControllerTest
{  
    public static User createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
        System.assert(u.id != null);
        return u;
    }
    //Method to validate SR Insert,Update
    //Validate Chatter email notification
    public static testMethod void testSRCreation() {
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');        
        Id SRRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('Simulation Request').getRecordTypeId();
        System.runAs(sysAdmin) {
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Status__c = 'New';
            b.Priority__c = 'P4';
            b.Bug_Description__c = 'test';
            b.RecordTypeId = SRRecordTypeId;
            
            insert b;
            b.Bug_Description__c = 'test1';
            update b;
            
            Attachment attach=new Attachment();  
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=b.id;
            insert attach;
            
            Blob fileBody = Blob.valueOf('test.pptx');
            FeedItem feeditemVar = new FeedItem();
            feeditemVar.parentid = b.id;
            feeditemVar.Title = 'test';
            feeditemVar.Body = 'test';
            feeditemVar.ContentFileName = '2013_01_29_TSV_Summary.pptx';
            feeditemVar.ContentDescription = '2013_01_29_TSV_Summary.pptx';
            feeditemVar.contentData = fileBody;
            insert feeditemVar;
            
            contentVersion cv = new contentVersion(pathonclient = '2013_01_29_TSV_Summary.pptx',versionData = EncodingUtil.base64Decode('SampleFile'));
            insert cv;   
            FeedComment feedcommentVar = new FeedComment();
            feedcommentVar = new feedComment();
            feedcommentVar.FeedItemId = feeditemVar.id;
            feedcommentVar.CommentType = 'ContentComment';
            feedcommentVar.RelatedRecordId = cv.id;
            insert feedcommentVar;      
            
            Test.setCurrentPageReference(new PageReference('Page.DownloadAttachment'));
            System.currentPageReference().getParameters().put('id', b.id);
            DownloadAttachmentController d1=new DownloadAttachmentController();
            d1.prepareSelectedIds();
            d1.cancel();
            
            String zip1=UCMZipWebServiceHandler.getAttachmentById(attach.Id);
            String zip11=UCMZipWebServiceHandler.saveToDocument('Unit Test Attachment Body','abc.zip');
            String zip2=UCMZipWebServiceHandler.getAttachmentById(feeditemVar.Id);
            String zip22=UCMZipWebServiceHandler.saveToDocument('test.pptx','abc1.zip');
            String zip3=UCMZipWebServiceHandler.getAttachmentById(cv.Id);
            String zip33=UCMZipWebServiceHandler.saveToDocument('SampleFile','abc2.zip');
        }

        test.stoptest();
    }
}