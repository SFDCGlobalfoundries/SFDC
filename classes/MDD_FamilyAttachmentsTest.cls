/* 
 Type Name: MDD_FamilyAttachmentsTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test Class for MDD_FamilyAttachments
 
 */
@isTest
public class MDD_FamilyAttachmentsTest{
    public static TestMethod void  MDD_FamilyAttachmentsTestMethod(){
        Part_Family__c f = new Part_Family__c();
        f.Name = 'test family';
        insert f;
        Part__c p = new Part__c();
        p.Part_Number__c = '0000000001';
        p.Part_Family__c = 'test family';
        p.Part_Type__c = 'FC PBGA';
        insert p;
        Attachment att = new Attachment();
        att.ParentId = f.Id;
        att.ContentType = 'text';
        att.Name = 'test attach';
        att.Body = Blob.valueOf('A new attachment test');
        insert att;
        FeedItem i = new FeedItem();
        i.Body = 'test';
        i.ParentId = f.id;
        insert i;
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('id', f.Id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(f);
        MDD_FamilyAttachments mdd = new MDD_FamilyAttachments(sc);
        mdd.recId = i.Id;
        mdd.fam = f;
        mdd.attach();
        mdd.attachFile();
        mdd.deleteFile();
        mdd.download();
        mdd.viewFile();
    }
}