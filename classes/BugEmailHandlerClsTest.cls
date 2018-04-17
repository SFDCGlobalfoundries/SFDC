@isTest(SeeAllData = false)
private class BugEmailHandlerClsTest {   
     
    static testMethod void testProcessInboundEmail() {
        Test.startTest();
        // create a new email 
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'test@asfd.com';
        email.subject = 'Subject asdas asdasd ';
        email.plainTextBody = 'Test email';
        //email.fromname = 'FirstName LastName';
        email.toAddresses = new String[] {'someaddresstechnical@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com'};
        BugEmailHandlerCls emailProcess = new BugEmailHandlerCls();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);
        System.assert(result.success == true);              
        Test.stopTest();
    }
    
    private static testmethod void testEmailHandler(){
        Test.startTest();   
        Id recordTypeTechnicalId = Schema.SObjectType.Bug__C.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__C(Status__c = 'New', Bug_Title__c = 'Test', RecordTypeId = recordTypeTechnicalId,
                           Product_Technology__c = '28HPP', Component__c = 'Documentation',Version__c = '0.09',
                           Bug_Classification__c = 'Question' , Customer_Severity__c = 'Minor'
                           );
        insert bugObj;
        
        bugObj = [select id,Name from Bug__C where id = :bugObj.id];
        
        FeedItem fdItem = new FeedItem();
        fdItem.parentid = bugObj.id;
        fdItem.body = 'Test Subject1';
        //fdItem.Visibility = 'AllUsers';
        insert fdItem;
                       
       // System.assertEquals ('Test Subject1', fdComment.commentbody);
        
        // create a new email and envelope object
        Messaging.InboundEmail emailMessage = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope emailEnv = new Messaging.InboundEnvelope();
 
        // setup the data for the email
        emailMessage.subject = 'RE: Bug#'+bugObj.Name+'Test Subject1';
        // call the email service class and test it with the data in the testMethod
        BugEmailHandlerCls emailProcess = new BugEmailHandlerCls();
        emailProcess.handleInboundEmail(emailMessage, emailEnv);
        
        Test.stopTest();
    }
    
    private static testmethod void testEmailHandlerWithAttachment(){
        Test.startTest();
        // create a new email 
        
        
        Id recordTypeTechnicalId = Schema.SObjectType.Bug__C.getRecordTypeInfosByName().get(System.Label.BugPDKRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__C(Status__c = 'New', Bug_Title__c = 'Test', RecordTypeId = recordTypeTechnicalId,
                           Product_Technology__c = '28HPP', Component__c = 'Documentation',Version__c = '0.09',
                           Bug_Classification__c = 'Question' , Customer_Severity__c = 'Minor'
                           );
        insert bugObj;
        
        bugObj = [select id,Name from Bug__C where id = :bugObj.id];
        
        FeedItem fdItem = new FeedItem();
        fdItem.parentid = bugObj.id;
        fdItem.body = 'Test Subject1';
        //fdItem.Visibility = 'AllUsers';
        insert fdItem;      
        
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        envelope.fromAddress = 'test@abcd.com';
        envelope.toAddress = 'test@asfd.com';
        //email.subject = 'Subject asdas asdasd ';
        email.subject = 'RE: Bug#'+bugObj.Name+'Test Subject1';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Test email'; 
        email.toAddresses = new String[] {'someaddresstechnical@email.com'};
        email.ccAddresses = new String[] {'one@email.com','two@email.com'};
      
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'data.txt';
        inAtt.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt };
      
        Messaging.InboundEmail.TextAttachment tattachment = new Messaging.InboundEmail.TextAttachment();
        tattachment.body = 'this is just a test';
        tattachment.fileName = 'textfiletwo3.txt';
        tattachment.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { tattachment };
        //email.fromname = 'FirstName LastName';                     
        BugEmailHandlerCls emailProcess = new BugEmailHandlerCls();
        Messaging.InboundEmailResult result = emailProcess.handleInboundEmail(email,envelope);       
        
        System.assert(result.success == true);              
        Test.stopTest();        
    }
}