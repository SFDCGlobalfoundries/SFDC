/*Author: UCM Team
* Description: Test Class for Bug Trigger , IPDEVIPDEVBugTriggerHandler, IPDEVBugUpdateOwnerandTeam
               
* History: Created on 10/03/2017
*/
@isTest(SeeAllData = false)
public class IPDEVBugTriggerTest {

    public static User createUser(String profileName) {
        Profile p = [SELECT Id FROM Profile WHERE Name = : profileName];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        User u = new User(Alias = 'standt1', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'TestingUsr', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
        System.assert(u.id != null);
        return u;
    }

    public static testMethod void testBugCreation() {
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        //Create Queues
        Group testGroup2 = new Group(Name='IPDEVTest1', DeveloperName ='IPDEVTest1');
        insert testGroup2;
        String grTempId = testGroup2.Id;
        String group15DigitId = grTempId.substring(0, 15);
        
        //inserting test data for custom setting
        list <IPDEVforDefaultOwnerandTeam__c > cslist = new list <IPDEVforDefaultOwnerandTeam__c> ();
        IPDEVforDefaultOwnerandTeam__c c = new IPDEVforDefaultOwnerandTeam__c();
        c.Name = 'TLDLP Gen3';
        c.IPDEV_Component__c = 'TLDLP Gen3';
        c.Bug_Owner__c = Userinfo.getUserId();
        c.Bug_BugTeam__c = Userinfo.getUserId();
        c.Bug_Admin__c = group15DigitId;
        cslist.add(c);

        IPDEVforDefaultOwnerandTeam__c c1 = new IPDEVforDefaultOwnerandTeam__c();
        c1.Name = 'TLDLP Gen4';
        c1.IPDEV_Component__c = 'TLDLP Gen4';
        c1.Bug_Owner__c = Userinfo.getUserId();
        c1.Bug_BugTeam__c = Userinfo.getUserId();
        c1.Bug_Admin__c = group15DigitId;
        cslist.add(c1);

        IPDEVforDefaultOwnerandTeam__c c2 = new IPDEVforDefaultOwnerandTeam__c();
        c2.Name = '28LPQ-RF PDK Release - PDK Release';
        c2.IPDEV_Component__c = 'PDK Release';
        c2.Bug_Owner__c = Userinfo.getUserId();
        c2.Bug_BugTeam__c = Userinfo.getUserId();
        c2.Bug_Admin__c = group15DigitId;
        cslist.add(c2);
        insert cslist;
        
        Manage_Email_Notification__c manageEmail = new Manage_Email_Notification__c();
        manageEmail.User__c = Userinfo.getUserId();
        manageEmail.Bug_Update_Only__c = false;
        manageEmail.Chatter_Only__c = false;
        insert manageEmail;
        
        IPDEVBugTriggerHandler bugHandler = new IPDEVBugTriggerHandler();
        bugHandler.mapCreation();
        
        String cadRecordTypeId = [select id, name from recordtype where name = 'IPDEV Bug'][0].id;
        System.runAs(sysAdmin) {
            // Creating bug with product/technology and component fields.
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.IPDEV_Component__c = 'TLDLP Gen3';
            b.Bug_Classification__c = 'test';
            b.Priority__c = 'p1';
            b.Severity__c = 'c1';
            b.Version__c = '1.1';
            b.Bug_Description__c = 'Testing one';
            b.recordtypeid = cadRecordTypeId;
            insert b;

            b = [select id, ownerid from bug__c where id = : b.id][0];

            Bug_Team__c Bgteam = [select id, User__c, Access__c from Bug_Team__c where Bug__c = : b.id][0];
            b.Bug_Title__c = 'test zzzzz';
            update b;
             
            FeedItem feeditemVar = new FeedItem();
            feeditemVar.parentid = b.id;

            feeditemVar.Title = 'test';
            feeditemVar.Body = 'test';
            insert feeditemVar;

            FeedComment feedcommentVar = new FeedComment();
            feedcommentVar = new feedComment();
            feedcommentVar.FeedItemId = feeditemVar.id;
            feedcommentVar.CommentBody = 'test';
            insert feedcommentVar;

            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test yyyy';
            b1.Origin__c = b.id;
            b1.IPDEV_Component__c = 'TLDLP Gen4';
            insert b1;

            b1 = [select id, ownerid from bug__c where id = : b1.id][0];
            Bug_Team__c Bgteam1 = [select id, User__c from Bug_Team__c where Bug__c = : b.id][0];

            //Test data creation ends

            //Checking for bug team and bug owner updated correct product affected and component
            system.assertEquals(b.ownerid, c.Bug_Owner__c);
            system.assertEquals(bgteam.User__c, c.Bug_BugTeam__c);

            //Checking for bugteam and bug owner updated correctly for the bulk insert.
            list < bug__c > blist = new list < bug__c > ();
            for (integer i = 0; i <= 20; i++) {
                bug__c btemp = new bug__c();
                btemp.Bug_Title__c = 'testzzxx' + i;
                btemp.IPDEV_Component__c = 'TLDLP Gen3';
                btemp.recordtypeid= cadRecordTypeId ;
                blist.add(btemp);
            }

            insert blist;


            bug__c btemp = [select id, ownerid from bug__c where id = : blist[0].id][0];
            Bug_Team__c Bgteamtemp1 = [select id, User__c from Bug_Team__c where Bug__c = : blist[0].id][0];
            system.assertEquals(b.ownerid, c.Bug_Owner__c);
            system.assertEquals(Bgteamtemp1.User__c, c.Bug_BugTeam__c);
            // Updating bug to test for Update Email code.
            update blist[0];

            //test code for validation of bug status on update
            bList[1].status__c = 'Hold';
            try {
                update blist[1];
            } catch (exception e) {
                
            }

            //deleting bug to test for validation bug code.
            delete blist[0];
        }

        test.stoptest();
    }
    
    public static testmethod void BugUpdateOwnerandTeamTest() {
        test.starttest();
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        IPDEVforDefaultOwnerandTeam__c custSet = new IPDEVforDefaultOwnerandTeam__c();
        custSet.Name = 'TLDLP Gen3';
        custSet.IPDEV_Component__c = 'TLDLP Gen3';
        custSet.Bug_Owner__c = adminIds;
        custSet.Bug_BugTeam__c = adminIds;
        custSet.Bug_Admin__c = adminIds;
        insert custSet;
               
        Manage_Email_Notification__c emailNofiObj = new Manage_Email_Notification__c();
        emailNofiObj.User__c = adminIds;
        emailNofiObj.Chatter_Only__c = true;
        emailNofiObj.Bug_Update_Only__c = true;
        insert emailNofiObj;
        
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('IPDEV Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.IPDEV_Component__c = 'TLDLP Gen3';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        insert b;
        b.IPDEV_Component__c = 'TLDLP Gen4';
        b.Resolution__c = 'Fixed';
        b.Substate__c = 'Fixed';
        b.Status__c = 'Closed';
        update b;
        b.OwnerId = sysAdmin.id;
        update b; 
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorgs.com';
        User u1 = new User(Alias = 'standts1', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testings', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p1.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorgs.com');
        insert u1;
        
        bug_team__c bugTeamObj = new bug_team__c();
        bugTeamObj.user__c = u1.Id;
        bugTeamObj.Bug__c = b.Id;
        bugTeamObj.Access__c = 'Read/Write';
        bugTeamObj.Chatter_Only__c = true;
        bugTeamObj.Bug_Update_Only__c = true;
        insert bugTeamObj;
        
        BugErrorMessages__c bugError = new BugErrorMessages__c();
        bugError.Error_Message__c = 'Should the system re-route to the new owners/bug team members based on this IPDEV Component change?';
        bugError.Name = 'IPDEVOwnerResetConfirm';
        insert bugError;
        
        PageReference pageRef = new PageReference('/apex/IPDEVBugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        IPDEVBugUpdateOwnerandTeam BugUpdateOwnerandTeamVar = new IPDEVBugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        BugUpdateOwnerandTeamVar.getAlertmessage();
        b.IPDEV_Component__c = 'TLDLP Gen3';
        update b;
        BugUpdateOwnerandTeamVar = new IPDEVBugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();        
        test.stoptest();
    }
    public static testmethod void BugUpdateOwnerandTeamNegTest() {
        test.starttest();
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg1.com';
        User u2 = new User(Alias = 'standt12', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing12', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p2.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        insert u2;
        
        IPDEVforDefaultOwnerandTeam__c custSet = new IPDEVforDefaultOwnerandTeam__c();
        custSet.Name = 'TLDLP Gen3';
        custSet.IPDEV_Component__c = 'TLDLP Gen3';
        custSet.Bug_Owner__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        insert custSet;       
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('IPDEV Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.IPDEV_Component__c = 'TLDLP Gen3';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        insert b;
        
        PageReference pageRef = new PageReference('/apex/IPDEVBugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        IPDEVBugUpdateOwnerandTeam BugUpdateOwnerandTeamVar = new IPDEVBugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        b.IPDEV_Component__c = 'TLDLP Gen4';
        update b;
        BugUpdateOwnerandTeamVar = new IPDEVBugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();        
        test.stoptest();
    }
    
    
    
    public static testMethod void testFeedFilePost() {
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        
        string profileid = [select id from profile where name = 'GF Consultants'][0].id;
        
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';
        insert hcmemp;
        
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US', ProfileId = profileid,HCM_Record_ID__c=hcmemp.id,
        FederationIdentifier='177314',
        TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;

        IPDEVforDefaultOwnerandTeam__c custSet = new IPDEVforDefaultOwnerandTeam__c();
        custSet.Name = 'TLDLP Gen3';
        custSet.IPDEV_Component__c = 'TLDLP Gen3';
        custSet.Bug_Owner__c = adminIds;
        custSet.Bug_BugTeam__c = u.Id;
        custSet.Bug_Admin__c = adminIds;
        insert custSet; 
       
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('IPDEV Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.IPDEV_Component__c = 'TLDLP Gen3';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        insert b;
        
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
        
        FeedTriggerHandler feedvar = new FeedTriggerHandler();
        feedvar.setHtmlBodyForFile('test','test', 'test', '','test','test');
        feedvar.setHtmlBodyForFile('test','test', 'test', 'test','test','test');
                                        
        test.stoptest();
        }
}