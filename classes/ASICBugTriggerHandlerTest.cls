/*Author: UCM Team(Kali)
* Description: Test Class for ASICBugTriggerHandler, ASICBugUpdateOwnerAndTeam
               
* History: Created on 10/6/2016
*/
@isTest(SeeAllData = false)
private class ASICBugTriggerHandlerTest {

    private static testMethod void test() {

    }
    
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
    
    public static testmethod void BugUpdateOwnerandTeamTest() {
        try{
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
        User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = adminIds;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   'ESPRESSO';
        custSet.Sub_Type_B__c   =   'System Hardware';
        custSet.Sub_Type_C__c   =   'Arabica Boards';
        insert custSet;
        test.starttest();       
        Manage_Email_Notification__c emailNofiObj = new Manage_Email_Notification__c();
        emailNofiObj.User__c = adminIds;
        emailNofiObj.Chatter_Only__c = true;
        emailNofiObj.Bug_Update_Only__c = true;
        insert emailNofiObj;
        
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Boards';
        
        insert b;
        
        b.sub_Type_C__c     =   '';
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
        ASICBugUpdateOwnerAndTeam BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        //BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        BugUpdateOwnerandTeamVar.getAlertmessage();
        b.Component__c = 'Documentation';
        update b;   
        test.stoptest();
        }catch(Exception e){}
       
    }
    public static testmethod void BugUpdateOwnerandTeamNegTest() {
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
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
        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   'ESPRESSO';
        custSet.Sub_Type_B__c   =   'System Hardware';
        custSet.Sub_Type_C__c   =   'Arabica Boards';
        custSet.Sub_Type_D__c  = 'Auto Test Plan Gen';
        insert custSet;       
              
        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Arabica Boards';
        b.Sub_Type_D__c   =  'Auto Test Plan Gen';
        insert b;
        test.starttest();
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        ASICBugUpdateOwnerAndTeam BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        
        BugUpdateOwnerandTeamVar.validateId(adminIds);
        BugUpdateOwnerandTeamVar.validateUserId(adminIds);
        b.Component__c = 'Documentation';
        
        update b;
        BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        BugUpdateOwnerandTeamVar.bugvar.Old_SubTypeA_TypeB_TypeC_TypeD__c = 'ESPRESSO,System Hardware,Arabica Boards,Auto Test Plan Gen';
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();        
        test.stoptest();
    }
    
    
    public static testMethod void test11(){
        
       
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
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
        
        Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
        
        custSet.Bug_Owners__c = adminIds;
        custSet.Bug_BugTeam__c = u2.Id;
        custSet.Bug_Admin__c = adminIds;
        custSet.Sub_Type_A__c   =   'ESPRESSO';
        custSet.Sub_Type_B__c   =   'System Hardware';
        custSet.Sub_Type_C__c   =   'Arabica Boards';
        insert custSet;       
              
         test.starttest();
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz123z1';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        b.Bug_Classification__c = 'test';
        b.Priority__c = 'p1';
        b.Severity__c = 'c1';
        b.Version__c = '1.1';
        b.recordtypeid = BugrecordTypeId;
        b.Sub_Type_A__c   =   'ESPRESSO';
        b.Sub_Type_B__c   =   'System Hardware';
        b.Sub_Type_C__c   =   'Arabica Boards';
        b.Bug_Description__c = 'test';
        b.Origin__c =  'test';
        insert b;
        
        b.Status__c = 'Info Required';
        b.Priority__c  = 'P1 - High';
       // b.DevComplete__c = true;
        update b;
        
        PageReference pageRef = new PageReference('/apex/BugUpdateOwnerandTeam?rid=' + BugrecordTypeId);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(b);
        ASICBugUpdateOwnerAndTeam BugUpdateOwnerandTeamVar = new ASICBugUpdateOwnerAndTeam(controller);
        b.Sub_Type_D__c   =   'Arabica Boards';
        b.Old_SubTypeA_TypeB_TypeC_TypeD__c = 'Fx-14 Onwards,Fx-14P';
                
        BugUpdateOwnerandTeamVar.ResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.NoResetOwnerandTeam();
        BugUpdateOwnerandTeamVar.validateUserId('12345');
        BugUpdateOwnerandTeamVar.validateId('12345');
            
        test.stoptest();
    
    }
    
    public static testMethod void OnHoldChkForGroup() {
        test.starttest();
        try {
            Group gr1 = new Group(Name = 'AMSAdminGroup', Type = 'Regular');
            insert gr1;
            Contact objContact = new Contact();
            objContact.firstName = 'Kali';
            objContact.lastname  = 'Sandipam';
            objContact.email = 'noreply@salesforce.com';
            
            insert objContact;
            String userId = UserInfo.getUserId();
            User sysAdmin = createUser('System Administrator');
            System.runAs(sysAdmin) {
                Bug_Default_Owner_Team__c custSet = new Bug_Default_Owner_Team__c();
                string adminId = gr1.id;
                string adminIds = adminId.substring(0, 15);
                custSet.Bug_Owners__c = adminIds;
                custSet.Bug_BugTeam__c = adminIds;
                custSet.Bug_Admin__c = adminIds;
                custSet.Sub_Type_A__c = 'ESPRESSO';
                custSet.Sub_Type_B__c = 'System Hardware';
                insert custSet;
                
                ASICBugTriggerHandler bugHandler = new ASICBugTriggerHandler();
                bugHandler.csList.add(custSet);
                ASICBugTriggerHandler.CheckMailSkipforFeed();
                bugHandler.mapCreation(); 
                bugHandler.setDefaultBugTeam();
                bugHandler.validateUserId(String.valueOf(UserInfo.getUserId()));
                Id cadRecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
                
                bug__c bugStatusChk1 = new bug__c();
                bugStatusChk1.Bug_Title__c = 'test ABC';
                bugStatusChk1.Product_technology__c = 'AMS Reference Flow';
                bugStatusChk1.Component__c = 'Block Packaging';
                bugStatusChk1.Status__c = 'New';
                bugStatusChk1.RecordTypeid = cadRecordTypeId;
                bugStatusChk1.Sub_Type_A__c = '';
                bugStatusChk1.Assigned_To__c = sysAdmin.Id;
                bugStatusChk1.Status__c = System.Label.Bug_Status_Closed;
                insert bugStatusChk1;
                bugHandler.buglistNew.add(bugStatusChk1);
                
                bugHandler.updateBugStatusDate();
                
                Map<Id,Bug__c> mapsBugs = new Map<Id, Bug__c>();
                mapsBugs.put(bugStatusChk1.Id, bugStatusChk1);
                
                
                bugHandler.mapforOwnerandTeam.put(bugStatusChk1.Id, custSet);
                bugStatusChk1.Sub_Type_A__c = 'ESPRESSO';
                bugStatusChk1.Sub_Type_B__c = 'System Hardware';
                bugStatusChk1.Status__c = 'Assigned';
                bugStatusChk1.Assigned_To__c = sysAdmin.Id;
                Update bugStatusChk1;
                List<Bug__c> listBugs = new List<Bug__c>();
                listBugs.add(bugStatusChk1);
                ASICBugEmailTemplateHandler.sendEmailToAssignedToOwner(listBugs,mapsBugs);
                
                bugHandler.buglistNew.add(bugStatusChk1);
                bugHandler.createMapforOwnerandTeamBasedOnSubtypes();
                custSet.Sub_Type_C__c = 'Arabica Boards';
                update custSet;
                bugStatusChk1.Sub_Type_C__c = 'Arabica Boards';
                bugStatusChk1.Status__c = 'Committed';
                Update bugStatusChk1; 
                bugHandler.createMapforOwnerandTeamBasedOnSubtypes();
                
                custSet.Sub_Type_D__c   =   'Boards';
                update custSet;
                bugStatusChk1.Sub_Type_D__c = 'Boards';
                bugStatusChk1.Status__c = 'Resolved';
                bugStatusChk1.Resolution__c = 'Invalid';
                bugStatusChk1.Resolution_Details__c = 'Invalid Bug';
                Update bugStatusChk1; 
                bugHandler.createMapforOwnerandTeamBasedOnSubtypes();
                bugHandler.updateBugStatusDate();
                
            }
        } catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
        test.stoptest();
    }
    
    private static testMethod void testMethod11(){
        
        test.starttest();
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        //Create Queues
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        Group testGroup2 = new Group(Name='BUGTest1', DeveloperName ='BUGTest1');
        insert testGroup2;
        String grTempId = testGroup2.Id;
        String group15DigitId = grTempId.substring(0, 15);
        
        //inserting test data for custom setting
        list < Bug_Default_Owner_Team__c > cslist = new list < Bug_Default_Owner_Team__c > ();
        Bug_Default_Owner_Team__c c = new Bug_Default_Owner_Team__c();
        c.Bug_Owners__c = Userinfo.getUserId();
        c.Bug_BugTeam__c = Userinfo.getUserId();
        c.Bug_Admin__c = group15DigitId;
        c.Sub_Type_A__c = 'ESPRESSO';
        c.Sub_Type_B__c = 'System Hardware';
        c.Sub_Type_C__c = 'Boards';
        cslist.add(c);

        Bug_Default_Owner_Team__c c1 = new Bug_Default_Owner_Team__c();
        c1.Bug_Owners__c = Userinfo.getUserId();
        c1.Bug_BugTeam__c = Userinfo.getUserId();
        c1.Bug_Admin__c = group15DigitId;
        c1.Sub_Type_A__c = 'ESPRESSO';
        c1.Sub_Type_B__c = 'System Hardware';
        c1.Sub_Type_C__c = 'Arabica Boards';
        cslist.add(c1);

        Bug_Default_Owner_Team__c c2 = new Bug_Default_Owner_Team__c();
        c2.Bug_Owners__c = Userinfo.getUserId();
        c2.Bug_BugTeam__c = Userinfo.getUserId();
        c2.Bug_Admin__c = group15DigitId;
        c2.Sub_Type_A__c = 'ESPRESSO';
        c2.Sub_Type_B__c = 'System Hardware';
        c2.Sub_Type_C__c = 'Test Station';
        cslist.add(c2);
        insert cslist;
        
        Manage_Email_Notification__c manageEmail = new Manage_Email_Notification__c();
        manageEmail.User__c = Userinfo.getUserId();
        manageEmail.Bug_Update_Only__c = false;
        manageEmail.Chatter_Only__c = false;
        insert manageEmail;
        
        ASICBugTriggerHandler bugHandler = new ASICBugTriggerHandler();
        bugHandler.mapCreation();
        
        String cadRecordTypeId = [select id, name from recordtype where name = 'ASIC Bug'][0].id;
        System.runAs(sysAdmin) {
            // Creating bug with product/technology and component fields.
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.Sub_Type_A__c =   'ESPRESSO';
            b.Sub_Type_B__c =   'System Hardware';
            b.Sub_Type_C__c =   'Arabica Boards';
            b.recordtypeid  =   cadRecordTypeId;
            b.Assigned_To__c = UserInfo.getUserId();
            insert b;
            
            system.debug(b);
            b.Sub_Type_C__c =   'Boards';
            update b;
            b.IsAsicCIASubmitted__c = true;
            update b;
            
            bugHandler.setOldProductandComponentBasedonSubTypes();
            b = [select id, ownerid from bug__c where id = : b.id][0];

        }

        test.stoptest();
    
    }
    
     private static testMethod void asicCustomerTest(){
        
        
        //Test data creation
        User sysAdmin = createUser('System Administrator');
        //User sysAdmin = createUser('System Administrator');
        string adminId = Userinfo.getUserId();
        string adminIds = adminId.substring(0, 15);
        //Create Queues
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        Group testGroup2 = new Group(Name='BUGTest1', DeveloperName ='BUGTest1');
        insert testGroup2;
        String grTempId = testGroup2.Id;
        String group15DigitId = grTempId.substring(0, 15);
        
        //inserting test data for custom setting
        list < Bug_Default_Owner_Team__c > cslist = new list < Bug_Default_Owner_Team__c > ();
        Bug_Default_Owner_Team__c c = new Bug_Default_Owner_Team__c();
        c.Bug_Owners__c = Userinfo.getUserId();
        c.Bug_BugTeam__c = Userinfo.getUserId();
        c.Bug_Admin__c = group15DigitId;
        c.Sub_Type_A__c = 'ESPRESSO';
        c.Sub_Type_B__c = 'System Hardware';
        c.Sub_Type_C__c = 'Boards';
        cslist.add(c);
        
        insert cslist;
        
        List<ASICCustomerProject__c> cstprjct = new list<ASICCustomerProject__c> ();
        ASICCustomerProject__c cst = new ASICCustomerProject__c();
        cst.name = '1';
        cst.Name__c = '3COM - FRAMER (TELAVIV ISRAEL)';
        cst.Bug_Team__c =  adminIds;
        cstprjct.add(cst);
        
        ASICCustomerProject__c c1 = new ASICCustomerProject__c();
        c1.name = '2';
        c1.Name__c = '3RDEYE TECH - IP PARTNER (WASHINGTON DC)';
        c1.Bug_Team__c =  adminIds;
        cstprjct.add(c1);
        
        insert cstprjct;
        
        
        
        Manage_Email_Notification__c manageEmail = new Manage_Email_Notification__c();
        manageEmail.User__c = Userinfo.getUserId();
        manageEmail.Bug_Update_Only__c = false;
        manageEmail.Chatter_Only__c = false;
        insert manageEmail;
        
        ASICBugTriggerHandler bugHandler = new ASICBugTriggerHandler();
        bugHandler.mapCreation();
        test.starttest();
        String cadRecordTypeId = [select id, name from recordtype where name = 'ASIC Bug'][0].id;
        System.runAs(sysAdmin) {
            // Creating bug with product/technology and component fields.
            bug__c b = new bug__c();
            b.Bug_Title__c = 'test zzzz';
            b.Product_technology__c = 'CAD Environment';
            b.Component__c = 'Documentation';
            b.Sub_Type_A__c =   'ESPRESSO';
            b.Sub_Type_B__c =   'System Hardware';
            b.Sub_Type_C__c =   'Arabica Boards';
            b.recordtypeid  =   cadRecordTypeId;
            b.Assigned_To__c = UserInfo.getUserId();
            b.Customer_Project__c  = '3COM - FRAMER (TELAVIV ISRAEL)' ;
            insert b;
            
            system.debug(b);
            b.Sub_Type_C__c =   'Boards';
            update b;
            b.IsAsicCIASubmitted__c = true;
            update b;
            b.Customer_Project__c = '3RDEYE TECH - IP PARTNER (WASHINGTON DC)';
            update b;
            
            bugHandler.setOldProductandComponentBasedonSubTypes();
            b = [select id, ownerid from bug__c where id = : b.id][0];

        }

        test.stoptest();
    
    }
}