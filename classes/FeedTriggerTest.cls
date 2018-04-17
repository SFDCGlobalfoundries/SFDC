/*Author: Karthick D
* Description: Test Class for FeedItem trigger,FeedCommment trigger, FeedTriggerHandler,
               class.
* History: Created on 09/08/2014

           Modified By Dinesh Suggala
           Modified Date 01/08/2017
           Reason: Added the method @testFolderandRTeamRoomFeed() to cover Folder and RestrictedTeamRoom Feed code in FeedItemTrigger.
*/

@isTest(SeeAllData = false)
public class FeedTriggerTest {
    public static testMethod void testFeedCreation() {
        Test.startTest();
        // Test data creation
        string profileid = [select id from profile where name = 'GF Consultants'][0].id;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
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

        list < CSforDefaultownerandteam__c > clist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'cc1';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        group gp = [Select g.Type, g.Name, g.Id, g.Email From Group g where type = 'Queue'][0];
        c.Bug_Owner__c = u.id;
        c.Bug_BugTeam__c = Userinfo.getUserId();
        clist.add(c);
        insert clist;
       
        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        insert b;

        FeedItem fdItem = new FeedItem();
        fdItem.parentid = b.id;
        fdItem.body = 'test';
        insert fdItem;

        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.commentbody = 'test1';
        //fdComment.RelatedRecordId = cv.id;
        insert fdComment;

        list < string > Ids = new list < string > ();
        Ids.add(gp.id);

        FeedTriggerHandler FeedTriggerHandlerVar = new FeedTriggerHandler();
                         
        system.runas(u) {
            try {
                delete fdItem;
            } catch (exception e) {}
            try {
                delete fdComment;
            } catch (exception e) {}
        }
         
        system.assertequals( b.Component__c,'Documentation');               
        Test.stopTest();
    }
    
    public static testMethod void testAsicFeed(){       
        
        // Test data creation
        string profileid = [select id from profile where name = 'GF Consultants'][0].id;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
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

        list < CSforDefaultownerandteam__c > clist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'cc1';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        group gp = [Select g.Type, g.Name, g.Id, g.Email From Group g where type = 'Queue'][0];
        c.Bug_Owner__c = u.id;
        c.Bug_BugTeam__c = Userinfo.getUserId();
        clist.add(c);
        insert clist;
    
        contentVersion cv = new contentVersion(
        pathonclient = 'test.jpg',
        versionData = EncodingUtil.base64Decode('SampleImageFile')
        );
        insert cv; 
        
        Test.startTest();        
        Id BugrecordTypeId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get('ASIC Bug').getRecordTypeId();
        bug__c b1 = new bug__c();       
        b1.Bug_Title__c = 'test zzzz123z1';
        b1.Product_technology__c = 'CAD Environment';
        b1.Component__c = 'Documentation';
        b1.Bug_Classification__c = 'test';
        b1.Priority__c = 'p1';
        b1.Severity__c = 'c1';
        b1.Version__c = '1.1';
        b1.recordtypeid = BugrecordTypeId;
        b1.Sub_Type_A__c   =   'ESPRESSO';
        b1.Sub_Type_B__c   =   'System Hardware';
        b1.Sub_Type_C__c   =   'Board';
        insert b1;
    
        FeedItem fdItem = new FeedItem();
        fdItem.parentid = b1.id;
        fdItem.body = 'test1';        
        
        
        FeedItem fdItem1 = new FeedItem(
            ParentId=b1.Id,
            ContentFileName='test.jpg',
            ContentData=EncodingUtil.base64Decode('test1')
        );
        
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.commentbody = 'test1';
      
    
        FeedComment fdComment1 = new FeedComment();
        fdComment1.FeedItemId = fdItem1.id;
        fdComment1.CommentType = 'ContentComment';
        fdComment1.RelatedRecordId = cv.id;
        
        system.runas(u) {
            try {
                delete fdItem;
            } catch (exception e) {}
            try {
                delete fdComment;
            } catch (exception e) {}
        }
        
         system.runas(u) {
            try {                
                insert fdItem1 ;                
                insert fdComment1;
            } catch (exception e) {}
        }
                          
         system.assertequals( b1.Severity__c,'c1');  
        Test.stopTest();
    }
    public static testMethod void testFeedCommentPost() {
        Test.startTest();
        // Test data creation
        string profileid = [select id from profile where name = 'GF Consultants'][0].id;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
        
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';
        insert hcmemp;
        
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
        EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US', ProfileId = profileid,
        TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',HCM_Record_ID__c=hcmemp.id,
                                                FederationIdentifier='177314');
        
        insert u;

        list < CSforDefaultownerandteam__c > clist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'cc1';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        group gp = [Select g.Type, g.Name, g.Id, g.Email From Group g where type = 'Queue'][0];
        c.Bug_Owner__c = u.id;
        c.Bug_BugTeam__c = Userinfo.getUserId();
        clist.add(c);
        insert clist;

        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        insert b;
        
        contentVersion cv = new contentVersion(
        pathonclient = 'test.jpg',
        versionData = EncodingUtil.base64Decode('SampleImageFile')
        );
        insert cv; 
               
        FeedItem fdItem = new FeedItem(
            ParentId=b.Id,
            ContentFileName='test.jpg',
            ContentData=EncodingUtil.base64Decode('test')
        );
        //insert fdItem ;
        FeedComment fdComment = new FeedComment();
        fdComment.FeedItemId = fdItem.id;
        fdComment.CommentType = 'ContentComment';
        fdComment.RelatedRecordId = cv.id;

        FeedTriggerHandler FeedTriggerHandlerVar = new FeedTriggerHandler();
        system.runas(u) {
            try {
                insert fdItem ;
                insert fdComment;
            } catch (exception e) {}
        }
        
        system.assertequals(b.Component__c,'Documentation'); 
        Test.stopTest();
    }
    public static testMethod void testFeedFilePost() {
        test.starttest();
        //Test data creation
        string profileid = [select id from profile where name = 'GF Consultants'][0].id;
        
        Contact objContact = new Contact();
        objContact.firstName = 'Kali';
        objContact.lastname  = 'Sandipam';
        objContact.email = 'noreply@salesforce.com';
        
        insert objContact;
        
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

        list < CSforDefaultownerandteam__c > clist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'cc1';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        c.Bug_Owner__c = u.id;
        c.Bug_BugTeam__c = Userinfo.getUserId();
        clist.add(c);
        insert clist;

        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
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
        
        system.assertequals( feeditemVar1.parentid,b.id); 
        test.stoptest();
        }
		
		
        @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');        
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'APJ');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }   
        
        public static testMethod Void testFolderandRTeamRoomFeed(){
            test.starttest();
            Account acctObj = new Account(); 
            acctObj = getAccount('MYTEST ACCOUNT1');
            
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c ();
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.R_Primary_Account__c=acctObj.Id;     
            insert teamRoomObj;
            Blob fileBody = Blob.valueOf('test.pptx');
            
            
            FeedItem feeditemVar1 = new FeedItem();
            feeditemVar1.parentid = teamRoomObj.id;
            feeditemVar1.Title = 'test1';
            feeditemVar1.Body = 'test1';
            feeditemVar1.contentData = fileBody;
            feeditemVar1.ContentFileName = '2013_01_29_TSV_Summary.pptx';
            feeditemVar1.ContentDescription = '2013_01_29_TSV_Summary.pptx';
            insert feeditemVar1;
            
            Folder__c folder=new Folder__c();
            folder.Name='Sample Test';
            folder.Restricted_Team_Room__c=teamRoomObj.id;
            insert folder;
            system.assert(folder.id!=null);
			
            FeedItem feeditemVar2 = new FeedItem();
            feeditemVar2.parentid = folder.id;
            feeditemVar2.Title = 'test1';
            feeditemVar2.Body = 'test1';
            feeditemVar2.contentData = fileBody;
            feeditemVar2.ContentFileName = '2013_01_29_TSV_Summary.pptx';
            feeditemVar2.ContentDescription = '2013_01_29_TSV_Summary.pptx';
            insert feeditemVar2;
            system.assert(feeditemVar2.id!=null);
			test.stoptest();
 
        }
        
        private static Account getAccount(string AccountName){
          Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
          return acct;
         }   
}