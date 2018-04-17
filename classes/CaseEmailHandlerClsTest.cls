/*
Type Name: CaseEmailHandlerClsTest
Author: UCM Team
Created Date: 24/08/2016
Reason: This is the Test class for Email Service classes CaseEmailHandlerCls 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
private class CaseEmailHandlerClsTest {   
     
    static testMethod void testProcessInboundEmail() {
        Test.startTest();
        // create a new email 
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'testtech@asfd.com';
        email.subject = 'Subject asdas asdasd ';
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'someaddresstechnical@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com'};
        CaseEmailHandlerCls emailProcess = new CaseEmailHandlerCls();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);
        System.assert(result.success == true);
        
        envelope.fromAddress = 'test1@abcd.com';
        envelope.toAddress = 'qual_logistics@asfd.com';
        CaseEmailHandlerCls emailProcess1 = new CaseEmailHandlerCls();
        Messaging.InboundEmailResult result1 = emailProcess1.handleInboundEmail(email,envelope);
        System.assert(result1.success == true);
        Test.stopTest();
    }
    
    private static testmethod void testEmailHandler(){
        Test.startTest();   
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Case caseObj = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Design Enablement-Others', SubCategory__c = 'Design Flow',
                           Priority = 'Low', Internal_or_external__c = true);
        insert caseObj;
        
        caseObj = [select id, CaseNumber from Case where id = :caseObj.id];
        
        FeedItem fdItem = new FeedItem();
        fdItem.parentid = caseObj.id;
        fdItem.body = 'Test Subject1';
        fdItem.Visibility = 'AllUsers';
        insert fdItem;
        
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.commentbody = 'Test Subject1';
        insert fdComment;
        
        System.assertEquals ('Test Subject1', fdComment.commentbody);
        
        // create a new email and envelope object
        Messaging.InboundEmail emailMessage = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope emailEnv = new Messaging.InboundEnvelope();
        emailMessage.toAddresses = new String[] {'someaddresstechnical@globalfoundries.com'};
 
        // setup the data for the email
        emailMessage.subject = 'RE: Case#'+caseObj.CaseNumber+'Test Subject1';
        // call the email service class and test it with the data in the testMethod
        CaseEmailHandlerCls emailProcess = new CaseEmailHandlerCls();
        emailProcess.handleInboundEmail(emailMessage, emailEnv);
        
        Test.stopTest();
    }
}