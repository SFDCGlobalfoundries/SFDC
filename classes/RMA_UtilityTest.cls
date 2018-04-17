/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This is a test class for RMA_Utility,RMA_UserLocaleDateTimeFormatterCtrl,RMA_CycleTimeHistoryExt, RMA_MailLogInboundEmailHandler 
 * History:
 *    SurendranadhNune 23122015  -   Created.
 *                            
 **/
@isTest
public class RMA_UtilityTest {

    Static RMA__c rmaRec;
    static Account acc;
    @TestSetup
    static void loadTestData(){
         DataUtilTest.loadEnvironmentVariables();
         prepareTestRecords();
    }
    
    static void prepareTestRecords(){
        acc = RMA_TestDataUtility.createAccount();
        rmaRec = RMA_TestDataUtility.createRMA(1, acc);     
    }
    
    static testmethod void testRMA_CycleTimeHistoryExt(){
        rmaRec = [select id,Fab__c from RMA__c limit 1][0];
        Test.startTest();
            Test.setCurrentPage(Page.RMA_CycleTimeHistory);
            RMA_CycleTimeHistoryExt Ext = new RMA_CycleTimeHistoryExt(new ApexPages.StandardController(rmaRec));
        Test.stopTest();
    }
    
    //Tests RMA_CycleTimeHistoryExt, RMA_MailLogInboundEmailHandler
    static testmethod void testRMA_Mail_LogTest(){
        
       rmaRec = [select id,name from RMA__c limit 1][0];
       User testUser = [select Id from User where isActive = true and Profile.Name = 'System Administrator' limit 1];
              
       system.runAs(testUser){       
           Test.startTest();    
               RMA_UserLocaleDateTimeFormatterCtrl localectrl = new RMA_UserLocaleDateTimeFormatterCtrl();  
               localectrl.dateTimeValue = datetime.now();
               localectrl.getTimeZoneValue();
               
               // Create a new email, envelope object and Attachment
               Messaging.InboundEmail email = new Messaging.InboundEmail();
               Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
               email.subject = rmaRec.Name;
               env.fromAddress = 'user@acme.com';
               email.toAddresses = new String[]{'test1@gmail.com', 'test2@gmail.com'};
               email.ccAddresses = new String[]{'test3@gmail.com', 'test4@gmail.com'};
               email.htmlbody = 'Test email';
            
               // call the class and test it with the data in the testMethod
               RMA_MailLogInboundEmailHandler emailServiceObj = new RMA_MailLogInboundEmailHandler();
               emailServiceObj.handleInboundEmail(email, env );
               rma_audit_log__c mailLog= [select id,to__c,cc__c,Subject__c,Email_Body__c,RMA__c
                                          from rma_audit_log__c 
                                          where recordtypeId=: RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.MAIL_LOG)][0]; 
                
               Test.setCurrentPage(Page.RMA_Mail_Log_Resend);
               RMA_Mail_Log_ResendCtrl ctrl = new RMA_Mail_Log_ResendCtrl(new ApexPages.StandardController(mailLog));
               ctrl.addCC = 'testuser5@gmail.com';
               ctrl.resend();
			   ctrl.hasAdminPriv();
           Test.stopTest();
       }
    }
    
    static testmethod void testUtilityMethods(){
        acc = [select id from account limit 1];
        rmaRec = [select id,name from RMA__c limit 1][0];
        Test.startTest();
            RMA_TestDataUtility.createRMAReturnInvoice(rmaRec, acc); 
            rma_utility.getTabFromShortName(RMA_CONSTANTS.tabName_DISPOSITION_OF_WAFER);
            rma_utility.getTabFromShortName(RMA_CONSTANTS.tabName_FAB_VALIDATION);
            rma_utility.getTabFromShortName(RMA_CONSTANTS.tabName_RMA_INFORMATION);
            rma_utility.getTabFromShortName('test');
            rma_utility.getPickListValues('rma__c', 'Status__c');
            RMA_Utility.retrieveRMAEmailServiceAddress('RMA Mail log Service');
            RMA_utility.getRMAtotalSystemMode(rmaRec.id);
            RMA_utility.QueryLineItemsSystemMode(rmaRec.id);
            
            
            //updating RMA with mandatory fields
            rmaRec.Access_Impact__c = 'Safety Impact';
            rmaRec.Description_Return_Particulars__c = 'test';
            rmaRec.Description_of_Reason_s__c = 'test';
            rmaRec.RMA_Category__c = 'Technical/ Turnkey';
            rmaRec.Disposition_of_Wafers__c = 'Return to GF';
            rmaRec.Customer_Request_Date__c = System.TODAY()-1;
            rmaRec.Justification_Fab_Validation__c = 'test';
            rmaRec.Justification_PRF__c = 'test';
            rmaRec.Justification_CAR__c = 'test';
            rmaRec.Justification_FOC__c = 'test';
            rmaRec.Justification_Field_Reliability_Failure__c = 'test';
            rmaRec.Potential_Impact_Wafers__c = 20;
            rmaRec.Lot_Device_To_Return__c = 'testLot1-123456;';
            rmaRec.Region_Head__c = UserInfo.getUserId();
            rmaRec.Sales_SVP__c = UserInfo.getUserId();
            rmaRec.ownerId = [select Id, Name from Group where Name LIKE 'RMA Fab Director- FAB 1' and Type = 'Queue'][0].id;
            update rmaRec;
            
            //Submitting RMA for Approval
            ApexPages.StandardController sc = new ApexPages.StandardController(rmaRec);
            PageReference pageRef = Page.RMA_view;
            pageRef.getParameters().put('id', String.valueOf(rmaRec.Id));
            Test.setCurrentPage(pageRef);
            RMA_Edit_Extension obj2 = new RMA_Edit_Extension(sc);
            Test.setCurrentPage(pageRef);
            obj2.sumbitForApproval();
            RMA_utility.checkApprover(rmaRec.id);
        Test.stopTest();            
    }
    
    static testmethod void testMoveToLibrary(){
        //Creating a Content Document
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.Title = 'Test';
        contentVersionObj.PathOnClient = 'TestFile.txt';
        contentVersionObj.VersionData = Blob.valueOf('Test Content');
        contentVersionObj.IsMajorVersion = true;
        insert contentVersionObj;
        ContentVersion testContent = [SELECT ContentDocumentId FROM ContentVersion where Id = :contentVersionObj.Id];
        RMA_utility.moveToLibrary(testContent.ContentDocumentId);
    }
    
    static testmethod void testRMA_Mail_LogTest2(){
        
       rmaRec = [select id,name from RMA__c limit 1][0];
       User testUser = [select Id, isActive, Profile.Name from User where isActive = true and Profile.Name = 'GF System Admin' limit 1];
       
       system.runAs(testUser){
       
           Test.startTest();    
               RMA_UserLocaleDateTimeFormatterCtrl localectrl = new RMA_UserLocaleDateTimeFormatterCtrl();  
               localectrl.dateTimeValue = datetime.now();
               localectrl.getTimeZoneValue();
               
               // Create a new email, envelope object and Attachment
               Messaging.InboundEmail email = new Messaging.InboundEmail();
               Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
            
               email.subject = rmaRec.Name;
               env.fromAddress = 'user@acme.com';
               email.toAddresses = new String[]{'test1@gmail.com', 'test2@gmail.com'};
               email.ccAddresses = new String[]{'test3@gmail.com', 'test4@gmail.com'};
               email.htmlbody = 'Test email';
            
               // call the class and test it with the data in the testMethod
               RMA_MailLogInboundEmailHandler emailServiceObj = new RMA_MailLogInboundEmailHandler();
               emailServiceObj.handleInboundEmail(email, env );
               rma_audit_log__c mailLog = new rma_audit_log__c();
               List<rma_audit_log__c> lstmailLog= [select id,to__c,cc__c,Subject__c,Email_Body__c, RMA__c
                                              from rma_audit_log__c 
                                              where recordtypeId=: RMA_Utility.getRecordTypeId('RMA_Audit_log__c', RMA_Constants.MAIL_LOG)]; 
               if(lstmailLog != NULL && !lstmailLog.isEmpty()){
                   mailLog = lstmailLog[0];
                   Test.setCurrentPage(Page.RMA_Mail_Log_Resend);
                   RMA_Mail_Log_ResendCtrl ctrl = new RMA_Mail_Log_ResendCtrl(new ApexPages.StandardController(mailLog));
                   ctrl.addCC = 'testuser5@gmail.com';
                   ctrl.resend();
                   ctrl.hasAdminPriv();
               }
           Test.stopTest();
            
       }
    }
}