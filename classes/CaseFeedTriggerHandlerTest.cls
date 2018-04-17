/*********************************************************************************/
  // Purpose      : CaseFeedTriggerHandlerTest class is responsible for major responsibilities / business logic required in UCM Project
  // Date created : 14th Oct, 2015
  // Created by   : GlobalFoundries
  // Author       : Manikumar M 
  // Description  : Test Class for CaseFeedCommentTrigger and CaseFeedTriggerHandler class.
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
@isTest(SeeAllData = false)
public class CaseFeedTriggerHandlerTest {
    public static testMethod void testFeedCreation(){
        DataUtilTest.loadEnvironmentVariables();
        
        Test.startTest();
        Id recordTypeCustomerApplicationId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        
        Case caseObj = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', Description='Test Description'
        );
        insert caseObj;
        
        FeedItem fdItem = new FeedItem();
        fdItem.parentid = caseObj.id;
        fdItem.body = 'test';
        fdItem.Visibility = 'AllUsers';
        insert fdItem;
        
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.commentbody = 'test1';
        insert fdComment;
        
        System.assertEquals ('test1', fdComment.commentbody);
        
        Case caseObjNew = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', Description='Test Description',
            Feed_Comment__c = 'test1',
            Last_FeedComment_IsPublished__c = true
        );
        insert caseObjNew;
        
        CaseFeedTriggerHandler CaseFeedTriggerHandlerVar = new CaseFeedTriggerHandler();
        Test.stopTest();
    }
    public static testMethod void testFeedCommentPost() {
        Test.startTest();
        // Test data creation
        
        Id recordTypeCustomerApplicationId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', 
            Description='Test Description'
        );
        insert caseObj;
        
        contentVersion cv = new contentVersion(
            pathonclient = 'test.jpg',
            versionData = EncodingUtil.base64Decode('SampleImageFile')
        );
        insert cv;          
        FeedItem fdItem = new FeedItem(
            ParentId=caseObj.Id,
            ContentFileName='test.jpg',
            ContentData=EncodingUtil.base64Decode('test'),
            Visibility = 'AllUsers'
        );
        insert fdItem ;
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.CommentType = 'ContentComment';
        fdComment.RelatedRecordId = cv.id;
        insert fdComment;
        
        CaseFeedTriggerHandler CaseFeedTriggerHandlerVar = new CaseFeedTriggerHandler();
        
        Test.stopTest();
    }
    public static testMethod void testAdminFeedCommentPost() {
        Test.startTest();
        // Test data creation
        
        Id recordTypeCustomerApplicationId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', 
            Description='Test Description'
        );
        insert caseObj;
        
        contentVersion cv = new contentVersion(
            pathonclient = 'test.jpg',
            versionData = EncodingUtil.base64Decode('SampleImageFile')
        );
        insert cv;          
        FeedItem fdItem = new FeedItem(
            ParentId=caseObj.Id,
            ContentFileName='test.jpg',
            ContentData=EncodingUtil.base64Decode('test'),
            Visibility = 'InternalUsers'
        );
        insert fdItem ;
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.CommentType = 'ContentComment';
        fdComment.RelatedRecordId = cv.id;
        insert fdComment;
        
        CaseFeedTriggerHandler CaseFeedTriggerHandlerVar = new CaseFeedTriggerHandler();
        
        Test.stopTest();
    }
    public static testMethod void testFeedFilePost() {
        
        //Test data creation
        
        Id recordTypeCustomerApplicationId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        Case caseObj = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', 
            Description='Test Description'
        );
        insert caseObj;
        test.starttest();
        Blob fileBody = Blob.valueOf('test.pptx');
        FeedItem feeditemVar = new FeedItem();
        feeditemVar.parentid = caseObj.id;
        feeditemVar.Title = 'test';
        feeditemVar.Body = 'test';
        feeditemVar.ContentFileName = '2013_01_29_TSV_Summary.pptx';
        feeditemVar.ContentDescription = '2013_01_29_TSV_Summary.pptx';
        feeditemVar.contentData = fileBody;
        insert feeditemVar;
        
        FeedItem feeditemVar1 = new FeedItem();
        feeditemVar1.parentid = caseObj.id;
        feeditemVar1.Title = 'test1';
        feeditemVar1.Body = 'test1';
        insert feeditemVar1;
        
        FeedComment feedcommentVar = new FeedComment();
        feedcommentVar = new feedComment();
        feedcommentVar.FeedItemId = feeditemVar.id;
        feedcommentVar.CommentBody = 'test';
        insert feedcommentVar;
        
        Case caseObjNew = new Case(
            RecordTypeId = recordTypeCustomerApplicationId ,
            Subject='Test Subject1', Description='Test Description',
            File_FeedComment__c = 'test',
            Last_FeedAttachment_IsPrivate__c = false,
            Last_Feed_Attachment_URL__c = 'sfc/servlet.shepherd/version/download/'+feedcommentVar.RelatedRecordId
        );
        insert caseObjNew;
        
        test.stoptest();
    }
}