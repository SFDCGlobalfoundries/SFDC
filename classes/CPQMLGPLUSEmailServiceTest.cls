/*
    Author: Anirban Roy
    Description: This is the test class for CPQReportBackupController.
    History: 
        ARoy     05062015    - Code creation.
*/

@istest(SeeAllData=false)
public class CPQMLGPLUSEmailServiceTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    
    // Test method for CPQ Email Service With no existing record
    static testMethod void CPQEmailServiceTestWithNoExistRec(){
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email  
        email.subject = 'PT00001|test mail';
        email.fromAddress = 'someaddress@globalfoundries.com';
        
        // add an Binary attachment  
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        
        CPQMLGPLUSEmailService emailServ = new CPQMLGPLUSEmailService();
        emailServ.handleInboundEmail(email, env);
    }
    
    // Test method for CPQ Email Service With existing record
    static testMethod void CPQEmailServiceTestWithExistRec(){
        
        CPQ_MLGPLUS__c cpqmlgplus = new CPQ_MLGPLUS__c(Catalog_Type__c = 'First Source', Geometry__c = '0.010UM', Status__c = 'Unprocessed', Process_Technology__c = 'PT00002');
        insert cpqmlgplus;
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email  
        email.subject = 'PT00002|test mail';
        email.fromAddress = 'someaddress@globalfoundries.com';
        
        // add an Binary attachment  
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        
        CPQMLGPLUSEmailService emailServ = new CPQMLGPLUSEmailService();
        emailServ.handleInboundEmail(email, env);
    }
    
    // Test method for CPQ Email Service With email having wrong subject
    static testMethod void CPQEmailServiceTestWithWrongSub(){
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email  
        email.subject = 'test mail';
        email.fromAddress = 'someaddress@globalfoundries.com';      
        
        CPQMLGPLUSEmailService emailServ = new CPQMLGPLUSEmailService();
        emailServ.handleInboundEmail(email, env);
    }
    
    // Test method for CPQ Email Service With email having no attachment
    static testMethod void CPQEmailServiceTestWithNoAttach(){
        
        // Create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // setup the data for the email  
        email.subject = 'PT00002|test mail';
        email.fromAddress = 'someaddress@globalfoundries.com';              
        
        CPQMLGPLUSEmailService emailServ = new CPQMLGPLUSEmailService();
        emailServ.handleInboundEmail(email, env);
    }
    
}