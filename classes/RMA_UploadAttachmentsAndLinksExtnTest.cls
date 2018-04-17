@isTest
public without sharing class RMA_UploadAttachmentsAndLinksExtnTest {
    
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         Account acc = RMA_TestDataUtility.createAccount();
    }
    
    static testmethod void testUploadAttachments(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc);
        Test.startTest(); 
            Test.setCurrentPage(Page.RMA_UploadAttachmentsAndLinks);
            
            RMA_UploadAttachmentsAndLinksExtn extn = new RMA_UploadAttachmentsAndLinksExtn(new ApexPages.StandardController(rmaRec));
            system.assert(extn.hasUploadAccess && extn.hasDeleteAccess);
                
            //Testing without parameters
            extn.checkSelectedTab();
            system.assert(String.isBlank(extn.SelTab));
            
            //Testing with parameters
            ApexPages.currentPage().getParameters().put('selTab', RMA_Constants.tabName_RMA_INFORMATION);
            extn.checkSelectedTab();
            system.assertEquals(extn.SelTab, RMA_Constants.tabName_RMA_INFORMATION);
            
            //Test uploadAttachment
            ContentVersion doc = new ContentVersion();
            string before = 'Testing base 64 encode'; 
            Blob beforeblob = Blob.valueOf(before);
            doc.Title = 'title';
            doc.PathOnClient = 'title.txt';
            doc.VersionData = beforeblob;
            insert doc; 
            
            //covercatchblock
            RMA_UploadAttachmentsAndLinksExtn.insertRMAAttachment(rmaRec.id, rmaRec.id, RMA_Constants.RMA_INFORMATION, doc.PathOnClient);
                
            extn.contentVersionId = doc.id;
            RMA_UploadAttachmentsAndLinksExtn.insertRMAAttachment(rmaRec.id, (String)doc.id, RMA_Constants.RMA_INFORMATION, doc.PathOnClient);
            
            system.assert([SELECT ID,attachment__c from Rma_Attachment__c where rma__c = :extn.rmaObj.id 
                           and section__c=:extn.sectionName and attachment__c !=null].size() > 0);
                           
            //Test Delete Attachment
            
            //covercatchblock
            extn.delContentDocId = 'invalidid';
            extn.deleteRMAAttachment();
            
            extn.getRMAAttachments();
            extn.delContentDocId = extn.contentDocumentList[0].ContentDocumentId;
            extn.deleteRMAAttachment();
            system.assert(extn.contentDocumentList.size() == 0);                           
       Test.stopTest();
    }
    
    static testmethod void testUploadLinks(){
        Account acc = [select id from account limit 1];
        RMA__c rmaRec = RMA_TestDataUtility.createRMA(1, acc);
        Test.startTest(); 
            Test.setCurrentPage(Page.RMA_UploadAttachmentsAndLinks);
            ApexPages.currentPage().getParameters().put('selTab', RMA_Constants.tabName_RMA_INFORMATION);
            RMA_UploadAttachmentsAndLinksExtn extn = new RMA_UploadAttachmentsAndLinksExtn(new ApexPages.StandardController(rmaRec));
            extn.linkUrl = null;
            extn.addLink();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages[0].getSummary(), 'Please enter a url.');
            
            extn.linkUrl = 'invalid url';
            extn.addLink();
            pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages[1].getSummary(), 'Please enter a url without any spaces.');
            
            //covercatch
            extn.saveLinks();
            
            extn.linkUrl = 'https://test.salesforce.com';
            extn.addLink();
            pageMessages = ApexPages.getMessages();
            system.assertEquals(pageMessages[2].getSummary(), 'Link added successfully.');
            
            //Delete link
            //covercatch
            extn.delRmaLinkId = 'invalidid';
            extn.deleteRMALink();
            
            extn.delRmaLinkId = extn.rmaLinksList[0].id;
            extn.deleteRMALink();
            system.assertEquals(extn.rmaLinksList.size(), 0);
            extn.backToRMA();
       Test.stopTest();         
    }
    
}