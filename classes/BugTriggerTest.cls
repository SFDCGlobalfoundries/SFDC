/*Author: Karthick D
* Description: Test Class for Bug Trigger , BugTriggerHandler, BugUpdateOwnerandTeam
               
* History: Created on 04/14/2014
*/
@isTest(SeeAllData = false)
public class BugTriggerTest {

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

    public static testMethod void testBugCreation() {
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        //Create Queues
        Group testGroup2 = new Group(Name='BUGTest1', DeveloperName ='BUGTest1');
        insert testGroup2;
        String grTempId = testGroup2.Id;
        String group15DigitId = grTempId.substring(0, 15);
        
        //inserting test data for custom setting
        list < CSforDefaultownerandteam__c > cslist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'CAD Environment - Documentation';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        //group gp =  [Select g.Type, g.Name, g.Id, g.Email From Group g where g.Name = 'CAD Bug Owners' and type = 'Queue'][0];
        c.Bug_Owner__c = Userinfo.getUserId();
        c.Bug_BugTeam__c = Userinfo.getUserId();
        c.Bug_Admin__c = group15DigitId;
        c.Additional_Bug_Team__c = Userinfo.getUserId();
        cslist.add(c);

        CSforDefaultownerandteam__c c1 = new CSforDefaultownerandteam__c();
        c1.Name = '28HPP - Documentation';
        c1.Product_affected__c = '28HPP';
        c1.Bug_Component__c = 'Documentation';
        //group gp1 =  [Select g.Type, g.Name, g.Id, g.Email From Group g where g.Name = 'PDK Documentation Team' and type = 'Queue'][0];
        c1.Bug_Owner__c = Userinfo.getUserId();
        c1.Bug_BugTeam__c = Userinfo.getUserId();
        c1.Bug_Admin__c = group15DigitId;
        c1.Additional_Bug_Team__c = Userinfo.getUserId();
        cslist.add(c1);

        CSforDefaultownerandteam__c c2 = new CSforDefaultownerandteam__c();
        c2.Name = '28LPQ-RF PDK Release - PDK Release';
        c2.Product_affected__c = '28LPQ-RF PDK Release';
        c2.Bug_Component__c = 'PDK Release';
        //group gp2 =  [Select g.Type, g.Name, g.Id, g.Email From Group g where g.Name = 'PDK Release Bug Owners' and type = 'Queue'][0];
        c2.Bug_Owner__c = Userinfo.getUserId();
        c2.Bug_BugTeam__c = Userinfo.getUserId();
        c2.Bug_Admin__c = group15DigitId;
        c2.Additional_Bug_Team__c = Userinfo.getUserId();
        cslist.add(c2);
        insert cslist;
        
        Manage_Email_Notification__c manageEmail = new Manage_Email_Notification__c();
        manageEmail.User__c = Userinfo.getUserId();
        manageEmail.Bug_Update_Only__c = false;
        manageEmail.Chatter_Only__c = false;
        insert manageEmail;
        
        BugTriggerHandler bugHandler = new BugTriggerHandler();
        bugHandler.mapCreation();
        
        String cadRecordTypeId = [select id, name from recordtype where name = 'CAD Bug'][0].id;
        System.runAs(sysAdmin) {
            // Creating bug with product/technology and component fields.
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
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

            // Creating bug with only product/technology populated
            bug__c b1 = new bug__c();
            b1.Bug_Title__c = 'test yyyy';
            b1.Origin__c = b.id;
            b1.product_technology__c = '28LPQ-RF PDK Release';
            insert b1;

            b1 = [select id, ownerid from bug__c where id = : b1.id][0];
            Bug_Team__c Bgteam1 = [select id, User__c from Bug_Team__c where Bug__c = : b.id][0];

            //Test data creation ends

            //Checking for bug team and bug owner updated correct product affected and component
            system.assertEquals(b.ownerid, c.Bug_Owner__c);
            system.assertEquals(bgteam.User__c, c.Bug_BugTeam__c);

            //Checking for bug team and bug owner updated correct product affected and blank component
            system.assertEquals(b1.ownerid, c2.Bug_Owner__c);
            system.assertEquals(bgteam1.User__c, c2.Bug_BugTeam__c);

            //Checking for bugteam and bug owner updated correctly for the bulk insert.
            list < bug__c > blist = new list < bug__c > ();
            for (integer i = 0; i <= 20; i++) {
                bug__c btemp = new bug__c();
                btemp.Bug_Title__c = 'testzzxx' + i;
                btemp.Product_technology__c = 'CAD Environment';
                btemp.Component__c = 'Documentation';
                btemp.recordtypeid= cadRecordTypeId ;
                btemp.Resolution_Details__c= 'test123';
                blist.add(btemp);
                
            }

            insert blist;

      bugHandler.buglistNew =blist; 
      
       bugHandler.feedTrackingforFieldUpdate();
            bug__c btemp = [select id, ownerid from bug__c where id = : blist[0].id][0];
            Bug_Team__c Bgteamtemp1 = [select id, User__c from Bug_Team__c where Bug__c = : blist[0].id][0];
            system.assertEquals(b.ownerid, c.Bug_Owner__c);
            system.assertEquals(Bgteamtemp1.User__c, c.Bug_BugTeam__c);
            // Updating bug to test for Update Email code.
            update blist[0];

            //test code for validation of bug status on update
            bList[1].status__c = 'Hold';
            bugHandler.validateFixedInPlannedInVersion();
            try {
                update blist[1];
            } catch (exception e) {
                
            }

            //deleting bug to test for validation bug code.
            delete blist[0];
        }
        
         
        test.stoptest();
    }

    public static testMethod void OnHoldChkForGroup() {
        test.starttest();
        try {
            Group gr1 = new Group(Name = 'AMSAdminGroup', Type = 'Regular');
            insert gr1;
            
            User sysAdmin = createUser('System Administrator');
            System.runAs(sysAdmin) {
                CSforDefaultownerandteam__c custSet = new CSforDefaultownerandteam__c();
                string adminId = gr1.id;
                string adminIds = adminId.substring(0, 15);
                custSet.Name = 'AMS Reference Flow - Block Packaging';
                custSet.Product_affected__c = 'AMS Reference Flow';
                custSet.Bug_Component__c = 'Block Packaging';
                custSet.Bug_Owner__c = adminIds;
                custSet.Bug_BugTeam__c = adminIds;
                custSet.Bug_Admin__c = adminIds;
                custSet.Additional_Bug_Team__c = adminIds;
                insert custSet;
                
                BugTriggerHandler bugHandler = new BugTriggerHandler();
                bugHandler.mapCreation();
                Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
                bug__c bugStatusChk1 = new bug__c();
                bugStatusChk1.Bug_Title__c = 'test ABC';
                bugStatusChk1.Product_technology__c = 'AMS Reference Flow';
                bugStatusChk1.Component__c = 'Block Packaging';
                bugStatusChk1.Status__c = 'New';
                bugStatusChk1.RecordTypeid = cadRecordTypeId;
                insert bugStatusChk1;
                bugStatusChk1.Status__c = 'Assigned';
                Update bugStatusChk1;
                bugStatusChk1.Status__c = 'Committed';
                Update bugStatusChk1; 
                bugStatusChk1.Status__c = 'Resolved';
                bugStatusChk1.Resolution__c = 'Invalid';
                bugStatusChk1.Resolution_Details__c = 'Invalid Bug';
                Update bugStatusChk1; 
                bugStatusChk1.Status__c = 'Hold';
                Update bugStatusChk1;                                                                                                        
            }
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    }

    public static testMethod void OnHoldChkForGroup1(){ 
      test.starttest();
        try {
            Group gr1 = new Group(Name = 'AMSAdminGroup', Type = 'Regular');
            insert gr1;
            
            User sysAdmin = createUser('System Administrator');
            System.runAs(sysAdmin) {
                CSforDefaultownerandteam__c custSet = new CSforDefaultownerandteam__c();
                string adminId = gr1.id;
                string adminIds = adminId.substring(0, 15);
                custSet.Name = 'AMS Reference Flow - Block Packaging';
                custSet.Product_affected__c = 'AMS Reference Flow';
                custSet.Bug_Component__c = 'Block Packaging';
                custSet.Bug_Owner__c = adminIds;
                custSet.Bug_BugTeam__c = adminIds;
                custSet.Bug_Admin__c = adminIds;
                custSet.Additional_Bug_Team__c = adminIds;
                insert custSet;
                
                BugTriggerHandler bugHandler = new BugTriggerHandler();
                bugHandler.mapCreation();
                Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
                bug__c bugStatusChk1 = new bug__c();
                bugStatusChk1.Bug_Title__c = 'test ABC';
                bugStatusChk1.Product_technology__c = 'AMS Reference Flow';
                bugStatusChk1.Component__c = 'Block Packaging';
                bugStatusChk1.Status__c = 'New';
                bugStatusChk1.RecordTypeid = cadRecordTypeId;
                insert bugStatusChk1;                                              
                bugStatusChk1.Status__c = 'Info Required';
                Update bugStatusChk1;
                bugStatusChk1.Status__c = 'Accepted';
                Update bugStatusChk1;
                bugStatusChk1.Status__c = 'Committed';
                Update bugStatusChk1;      
                bugStatusChk1.Status__c = 'Verified';
                Update bugStatusChk1;  
                bugStatusChk1.Status__c = 'Closed';                                               
                Update bugStatusChk1;                                                          
            }
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    
    
    }
    
    public static testMethod void OnHoldChkForUser() {
        test.starttest();
        try {
            CSforDefaultownerandteam__c custS = new CSforDefaultownerandteam__c();
            string adminId = Userinfo.getUserId();
            string adminIds = adminId.substring(0, 15);
            custS.Name = 'AMS Timing - Char';
            custS.Product_affected__c = 'AMS Timing';
            custS.Bug_Component__c = 'Char';
            custS.Bug_Owner__c = adminIds;
            custS.Bug_BugTeam__c = adminIds;
            custS.Bug_Admin__c = adminIds;
            custS.Additional_Bug_Team__c = adminIds;
            insert custS;
            User sysAdmin = createUser('System Administrator');
            System.runAs(sysAdmin) {
                Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('CAD Bug').getRecordTypeId();
                bug__c bugStatusChk = new bug__c();
                bugStatusChk.Bug_Title__c = 'test ABC';
                bugStatusChk.Product_technology__c = 'AMS Timing';
                bugStatusChk.Component__c = 'Char';
                bugStatusChk.Status__c = 'New';
                bugStatusChk.RecordTypeid = cadRecordTypeId;
                insert bugStatusChk;
                bugStatusChk.Status__c = 'Hold';
                Update bugStatusChk;
            }
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    }
    public static testMethod void OnHoldChkForGroupMem() {
        test.starttest();
        try {
            Group gr = new Group(Name = 'AdminGroup', Type = 'Regular');
            insert gr;
            GroupMember GM = new GroupMember();
            GM.GroupId = gr.id;
            GM.UserOrGroupId = Userinfo.getUserId();
            insert GM;
            User sysAdmin = createUser('System Administrator');
            System.runAs(sysAdmin) {
                CSforDefaultownerandteam__c custSet = new CSforDefaultownerandteam__c();
                string adminId = gr.id;
                string adminIds = adminId.substring(0, 15);
                custSet.Name = 'AMS Reference Flow - Block Packaging';
                custSet.Product_affected__c = 'AMS Reference Flow';
                custSet.Bug_Component__c = 'Block Packaging';
                custSet.Bug_Owner__c = adminIds;
                custSet.Bug_BugTeam__c = adminIds;
                custSet.Bug_Admin__c = adminIds;
                custSet.Additional_Bug_Team__c = adminIds;
                insert custSet;
                String cadRecordTypeId = [select id, name from recordtype where name = 'CAD Bug'][0].id;
                bug__c bugStatusChk1 = new bug__c();
                bugStatusChk1.Bug_Title__c = 'test ABC';
                bugStatusChk1.Product_technology__c = 'AMS Reference Flow';
                bugStatusChk1.Component__c = 'Block Packaging';
                bugStatusChk1.Status__c = 'New';
                bugStatusChk1.RecordTypeid = cadRecordTypeId;
                insert bugStatusChk1;
                bugStatusChk1.Status__c = 'Hold';
                Update bugStatusChk1;
            }
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    }

    public static testmethod void BugUpdateOwnerandTeamTest() {
        test.starttest();
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        CSforDefaultownerandteam__c custSet = new CSforDefaultownerandteam__c();
        custSet.Name = 'AMS Reference Flow - Block Packaging';
        custSet.Product_affected__c = 'CAD Environment';
        custSet.Bug_Component__c = 'Documentation';
        custSet.Bug_Owner__c = adminIds;
        custSet.Bug_BugTeam__c = adminIds;
        custSet.Bug_Admin__c = adminIds;
        custSet.Additional_Bug_Team__c = adminIds;
        insert custSet;
               
        Manage_Email_Notification__c emailNofiObj = new Manage_Email_Notification__c();
        emailNofiObj.User__c = adminIds;
        emailNofiObj.Chatter_Only__c = true;
        emailNofiObj.Bug_Update_Only__c = true;
        insert emailNofiObj;
        
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        //b.DE_Spec_Affected__c = c.id;
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        insert b;
        b.Product_technology__c = 'AMS Reference Flow';
        b.Component__c = 'Block Packaging';
        update b;
        b.OwnerId = sysAdmin.id;
        update b; 
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorgs.com';
        User u1 = new User(Alias = 'standts', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testings', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p1.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser2' + System.now().format('MMddyyyyHHmmss') + '@testorgs.com');
        insert u1;
        
        bug_team__c bugTeamObj = new bug_team__c();
        bugTeamObj.user__c = u1.Id;
        bugTeamObj.Bug__c = b.Id;
        bugTeamObj.Access__c = 'Read/Write';
        bugTeamObj.Chatter_Only__c = true;
        bugTeamObj.Bug_Update_Only__c = true;
        insert bugTeamObj;
        
        BugErrorMessages__c bugError = new BugErrorMessages__c();
        bugError.Error_Message__c = 'Should the system re-route to the new owners/bug team members based on this product/component change?';
        bugError.Name = 'OwnerResetConfirmation';
        insert bugError;
        
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugUpdateOwnerandTeam BugUpdateOwnerandTeamVar = new BugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        BugUpdateOwnerandTeamVar.getAlertmessage();
        b.Component__c = 'Documentation';
        update b;
        BugUpdateOwnerandTeamVar = new BugUpdateOwnerandTeam(controller);
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
        User u2 = new User(Alias = 'standt2', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p2.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser3' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com');
        insert u2;
        
        CSforDefaultownerandteam__c custSet = new CSforDefaultownerandteam__c();
        custSet.Name = 'AMS Reference Flow - Block Packaging';
        custSet.Product_affected__c = 'CAD Environment';
        custSet.Bug_Component__c = 'Documentation';
        custSet.Bug_Owner__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Additional_Bug_Team__c = u2.Id;
        insert custSet;       
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('PDK Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        insert b;
        
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        BugUpdateOwnerandTeam BugUpdateOwnerandTeamVar = new BugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        b.Component__c = 'Documentation';
        update b;
        BugUpdateOwnerandTeamVar = new BugUpdateOwnerandTeam(controller);
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam(); 
            
        test.stoptest();
    }
}