@isTest
public class AttachFeedItemControllerTest{
    public static testMethod void AttachFeedItemControllerTestMethod(){
        
        Other_EHS_CSR_Certificate__c ehs = new Other_EHS_CSR_Certificate__c();
        ehs.Certificate_Title__c = 'Test EHC';
        ehs.Certificate_Type__c = 'Material Declaration';
        ehs.Effective_Date__c = system.today();
        ehs.Expiry_Date__c = system.today()+3;
        ehs.Fabs__c = 'CORPORATE';
        insert ehs;
        
        
        Test.setCurrentPageReference(new PageReference('globalfoundryview/apex/AttachFeedItem')); 
        system.currentPageReference().getParameters().put('Id', ehs.Id);
        AttachFeedItemController cont = new AttachFeedItemController();
        cont.fileName1 = 'test1';
        cont.fileBody1 = Blob.valueOf('test filebody1');
        cont.fileName2 = 'test2';
        cont.fileBody2 = Blob.valueOf('test filebody2');
        cont.fileName3 = 'test3';
        cont.fileBody3 = Blob.valueOf('test filebody3');
        cont.fileName4 = 'test4';
        cont.fileBody4 = Blob.valueOf('test filebody4');
        cont.fileName5 = 'test5';
        cont.fileBody5 = Blob.valueOf('test filebody5');
        cont.fileName6 = 'test6';
        cont.fileBody6 = Blob.valueOf('test filebody6');
        cont.fileName7 = 'test5';
        cont.fileBody7 = Blob.valueOf('test filebody5');
        cont.fileName8 = 'test5';
        cont.fileBody8 = Blob.valueOf('test filebody5');        
        cont.fileName9 = 'test5';
        cont.fileBody9 = Blob.valueOf('test filebody9'); 
        cont.fileName10 = 'test5';
        cont.fileBody10 = Blob.valueOf('test filebody9'); 
       
        
        cont.saveAttachment();
        Id feedId = [SELECT Id,ParentId,RelatedRecordId,Title,ContentType,Type FROM FeedItem WHERE ParentId=:ehs.Id LIMIT 1].Id;
        Test.setCurrentPageReference(new PageReference('/apex/EHS_zipAndDownload?Impact=&Id='+ehs.Id));
        FeedItemAttachmentComponentController cont3 = new FeedItemAttachmentComponentController();
        Test.setCurrentPageReference(new PageReference('/apex/EHS_zipAndDownload?BCM=&Id='+ehs.Id));
        FeedItemAttachmentComponentController cont2 = new FeedItemAttachmentComponentController();
        Test.setCurrentPageReference(new PageReference('/apex/EHS_zipAndDownload?EHS=&Id='+ehs.Id));
        FeedItemAttachmentComponentController cont1 = new FeedItemAttachmentComponentController();

        cont1.relatedRecordId = feedId;
        cont1.download();
        cont1.viewFile();
        cont1.deleteFile();
        
    }
}