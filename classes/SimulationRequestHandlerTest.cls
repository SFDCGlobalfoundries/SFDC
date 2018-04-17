/*
Type Name: SimulationRequestHandlerTest
Author: Cognizant Case Mgmt Team
Created Date: 25-07-2015
Reason: This is the test class for SimulationRequestHandler.
Change History:
Author: Shuchismita Mallik
Modified Date: 30-07-2015
â€¦â€¦..
â€¦â€¦..
--
*/
@isTest(SeeAllData = false)
private class SimulationRequestHandlerTest {
    public static User createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
        System.assert(u.id != null);
        return u;
    }
    //Method to validate SR Insert,Update
    //Validate Chatter email notification
    public static testMethod void testSRCreation() {
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        //Create Queues
        Group testGroup2 = new Group(Name='BUGTest1', DeveloperName ='BUGTest1');
        insert testGroup2;
        String grTempId = testGroup2.Id;
        String group15DigitId = grTempId.substring(0, 15);
        
        //inserting test data for custom setting
        list < SRNonCompareFields__c> clist = new list < SRNonCompareFields__c > ();

        SRNonCompareFields__c c1 = new SRNonCompareFields__c();
        c1.Name = 'CreatedById';
        clist.add(c1);
        SRNonCompareFields__c c2 = new SRNonCompareFields__c();
        c2.Name = 'CreatedBy_User__c';
        clist.add(c2);
        SRNonCompareFields__c c3 = new SRNonCompareFields__c();
        c3.Name = 'CreatedDate';
        clist.add(c3);
        insert clist;
        Id SRRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('Simulation Request').getRecordTypeId();
        System.runAs(sysAdmin) {
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Status__c = 'New';
            b.Priority__c = 'P4';
            b.Bug_Description__c = 'test';
            b.RecordTypeId = SRRecordTypeId;
            
            insert b;
            b.Bug_Description__c = 'test1';
            update b;
            
            Blob fileBody = Blob.valueOf('test.pptx');
            FeedItem feeditemVar = new FeedItem();
            feeditemVar.parentid = b.id;
            feeditemVar.Title = 'test';
            feeditemVar.Body = 'test';
            feeditemVar.ContentFileName = '2013_01_29_TSV_Summary.pptx';
            feeditemVar.ContentDescription = '2013_01_29_TSV_Summary.pptx';
            feeditemVar.contentData = fileBody;
            insert feeditemVar;

            FeedItem feeditemVar1 = new FeedItem();
            feeditemVar1.parentid = b.id;
            feeditemVar1.Title = 'test1';
            feeditemVar1.Body = 'test1';
            insert feeditemVar1;
                                    
            FeedComment feedcommentVar = new FeedComment();
            feedcommentVar = new feedComment();
            feedcommentVar.FeedItemId = feeditemVar.id;
            feedcommentVar.CommentBody = 'test';
            insert feedcommentVar;
        }

        test.stoptest();
    }
}