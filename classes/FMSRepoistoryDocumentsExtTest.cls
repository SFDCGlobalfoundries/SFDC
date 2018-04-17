/*
 * @ Author :- Abhita Bansal
 * @ Description :- contains the test logic for FMSRepoistoryDocumentsExt Class.
 * @ Date :- 06/08/2017
 * @ Change History :-  
 **/
@isTest
public class FMSRepoistoryDocumentsExtTest {

    static testMethod void testRepoistoryDoc() {
    
        test.startTest();
        
        Document document = new Document();
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = UserInfo.getUserId();
        insert document;
        
        FMSRepoistoryDocumentsExt repoistExt = new FMSRepoistoryDocumentsExt(new ApexPages.StandardController(document));
        repoistExt.getDocs();
        
        Test.stopTest();
    }

}