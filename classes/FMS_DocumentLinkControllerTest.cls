/*
 @class: FMS_DocumentLinkControllerTest
 @CreatedBy: Inshu Misra
 @CreatedDate: 13 Sep, 2016
 @Description: to test the FMS_DocumentLinkController class...#IM
 @Modifications-
 *
 */
    @isTest(seealldata=true)
public class FMS_DocumentLinkControllerTest {
    
    static testmethod void fmsDocumentLinkTest1(){
        
        PageReference pageRef = Page.FMS_DocumentLinkPage;            
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('documentPage', 'TrainingMat');
        

        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='http://www.google.com/'; 
        testContentInsert.Title ='Test FMS'; 
        testContentInsert.file_group__c = 'User Training';
        testContentInsert.Index_number__c = 1;
        insert testContentInsert; 

        ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :testContentInsert.Id]; 
        ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace limit 1]; 

        ContentWorkspaceDoc newWorkspaceDoc =new ContentWorkspaceDoc(); 
        newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id; 
        newWorkspaceDoc.ContentDocumentId = testContent.ContentDocumentId; 
        insert newWorkspaceDoc;

        FMS_DocumentLinkController ctrl = new FMS_DocumentLinkController();
        ctrl.getDocumentList();

        Decimal d = 1024;
        System.assertEquals('1.00 KB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1.00 MB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1.00 GB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1024.00 GB', ctrl.getSize(d));
    }
    
    static testmethod void fmsDocumentLinkTest2(){
        
        PageReference pageRef = Page.FMS_DocumentLinkPage;            
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('documentPage', 'StepPlan');

        FMS_DocumentLinkController ctrl = new FMS_DocumentLinkController();
        ctrl.getDocumentList();

        Decimal d = 1024;
        System.assertEquals('1.00 KB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1.00 MB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1.00 GB', ctrl.getSize(d));
        d = d*1024;
        System.assertEquals('1024.00 GB', ctrl.getSize(d));
    }
}