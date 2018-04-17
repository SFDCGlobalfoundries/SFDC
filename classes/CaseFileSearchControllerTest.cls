/*
Type Name: CaseFileSearchControllerTest 
Author: UCM Team
Created Date: 24-Feb-2016
Reason: This is the Test class for "CaseFileSearchController" class. 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/
@isTest(SeeAllData = false)
public class CaseFileSearchControllerTest {
    /* ************ CaseFileSearch Controller Start************** */
    static Case caseObj;
    static FeedItem fdItem;
    static Attachment attach;
    static ContentVersion doc;
    static List<ContentDocument> documents;
    
     @testSetup static void testdata() {
       // DataUtilTest.loadEnvironmentVariables();  
        system.debug('start of the program'); 
     User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
 }  
    
    
    private static void init() {
        caseObj = new Case(
            Status = 'New', Origin = 'Email', Type = 'Bug',Description = 'Test 2', Subject = 'Test 2', 
            Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
            Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK'
        );
        insert caseObj;
        
                
        
        attach = new Attachment( Name='Unit Test Attachment2', parentId=caseObj.id);     
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body 2');
        attach.body=bodyBlob;
        insert attach;
                
        //document insertion
        doc = new ContentVersion();
        string title='TITLE.pdf';
        string before = 'tesstTextetest'; 
        Blob beforeblob = Blob.valueOf(before);
        doc.Title = title;
        doc.PathOnClient = title;
        doc.Origin = 'H';
        doc.VersionData = beforeblob;
        insert doc; 
        
        
        system.debug('pankaj322'+doc.id);
        
        ContentDocumentLink testLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: doc.Id].ContentDocumentId,
            LinkedEntityId = caseObj.id,
            ShareType = 'V');
            
        insert testLink;
        
        fdItem = new FeedItem(
            ParentId=caseObj.Id,                     
            Body='test.pdf',
            
            
            RelatedRecordId = doc.id
        );
        insert fdItem ;
        
        //ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :doc.Id LIMIT 1];
    
       // documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
       // ContentDocumentLink cdl = New ContentDocumentLink();
       // cdl.LinkedEntityId = caseObj.id;
      //  cdl.ContentDocumentId = documents[0].Id;
      //  cdl.shareType = 'V';
      //  insert cdl;
       
    }
    private static testmethod void caseFileSearchTestMethod() {
        init();
        
        Test.startTest();
        
        PageReference ref1 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref1);
        CaseFileSearchController c = new CaseFileSearchController();  
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('caseNumber', '000');
        ApexPages.currentPage().getParameters().put('creator', '');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c.caseNumber='000';
        c.createdDate='THIS_YEAR';
        c.creator='';
        c.SearchName='Test';
        c.SearchCaseAttachment();
        c.chatterQuery();
        c.getFileList();
        c.ClearAll();
        c.getattChatterValues();
        c.getdatesFilter();
        c.SortToggle();    
        
        Test.stopTest(); 
    }
    
    private static testmethod void caseFileSearchAll() {
        init();
        
        Test.startTest();
        
        PageReference ref2 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref2);
        CaseFileSearchController c2 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('caseNumber', '000');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c2.caseNumber='000';
        c2.createdDate='THIS_YEAR';
        c2.creator='Alex';
        c2.SearchName='Test';
        c2.SearchCaseAttachment();
        c2.chatterQuery();
                
        Test.stopTest();
    }
    private static testmethod void caseFileSearchName() {
        init();
        
        Test.startTest();
        
        PageReference ref3 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref3);
        CaseFileSearchController c3 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', '');
        ApexPages.currentPage().getParameters().put('caseNumber', '000');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c3.caseNumber='000';
        c3.createdDate='THIS_YEAR';
        c3.creator='Alex';
        c3.SearchName='';
        c3.SearchCaseAttachment();
        c3.chatterQuery();
         
        Test.stopTest();
    }
    private static testmethod void caseFileSearchNameOnly() {
        init();
        
        Test.startTest();
        
        PageReference ref4 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref4);
        CaseFileSearchController c4 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('caseNumber', '');
        ApexPages.currentPage().getParameters().put('creator', '');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c4.caseNumber='';
        c4.createdDate='THIS_YEAR';
        c4.creator='';
        c4.SearchName='Test';
        c4.SearchCaseAttachment();
        c4.chatterQuery();
                
        Test.stopTest();
    }
    private static testmethod void caseFileSearchCaseNumOnly() {
        init();
        
        Test.startTest();
        
        PageReference ref5 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref5);
        CaseFileSearchController c5 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', '');
        ApexPages.currentPage().getParameters().put('caseNumber', '000');
        ApexPages.currentPage().getParameters().put('creator', '');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c5.caseNumber='000';
        c5.createdDate='THIS_YEAR';
        c5.creator='';
        c5.SearchName='';
        c5.SearchCaseAttachment();
        c5.chatterQuery();
                
        Test.stopTest();
    }
    private static testmethod void caseFileSearchCaseNum() {
        init();
        
        Test.startTest();
        
        PageReference ref6 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref6);
        CaseFileSearchController c6 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('caseNumber', '');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c6.caseNumber='';
        c6.createdDate='THIS_YEAR';
        c6.creator='Alex';
        c6.SearchName='Test';
        c6.SearchCaseAttachment();
        c6.chatterQuery();
        
        Test.stopTest();
    }
    private static testmethod void caseFileSearchCreator() {
        init();
        
        Test.startTest();
        
         PageReference ref7 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref7);
        CaseFileSearchController c7 = new CaseFileSearchController(); 
        ApexPages.currentPage().getParameters().put('SearchName', '');
        ApexPages.currentPage().getParameters().put('caseNumber', '');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c7.caseNumber='';
        c7.createdDate='THIS_YEAR';
        c7.creator='Alex';
        c7.SearchName='';
        c7.SearchCaseAttachment();
        c7.chatterQuery();
        
        Test.stopTest();
    }
    private static testmethod void caseFileSearchNegative() {
        init();
        
        Test.startTest();
        
        PageReference ref8 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref8);
        CaseFileSearchController c8 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', '');
        ApexPages.currentPage().getParameters().put('caseNumber', '');
        ApexPages.currentPage().getParameters().put('creator', '');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        c8.caseNumber='';
        c8.createdDate='THIS_YEAR';
        c8.creator='';
        c8.SearchName='';
        c8.SearchCaseAttachment();
        c8.chatterQuery(); 
        
        Test.stopTest();
    }
    private static testmethod void caseFileSearchQuery() {
        Case caseObjs = new Case(
            Status = 'New', Origin = 'Email', Type = 'Bug',Description = 'Test 2', Subject = 'Test 2', 
            Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
            Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK'
        );
        insert caseObjs;
        PageReference ref1 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref1);
        CaseFileSearchController c1 = new CaseFileSearchController(); 
        List<Id> idList = new List<Id>();
        idList.add(caseObjs.Id);
        c1.getUserRecordAccessList(idList);
    }
    private static testmethod void caseFileSearchAttach() {
        
        DataUtilTest.loadEnvironmentVariables(); 
        CaseDataUtilTest.loadCustomSettingVariables(); 
        init();
        Test.startTest();
        
        Account a = new Account(name = 'acctest14', Site_Department__c = 'Site13', Sub_Type__c = 'Direct',
                Transaction_Type__c = 'Transactional', Region__c = 'APJ', Bill_To_Address_1__c = 'New Bill43',
                Bill_To_City__c = 'city13', Bill_To_Country__c = 'Austria', Corporate_Address_1__c = '',
                Corporate_City__c = 'city13', Corporate_Country__c = 'Austria');
        insert a;
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;
                       
        List < User > UserList = new List < User > ();
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin' limit 1];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@testorg1.com',
                          Alias = 'auser5', Email = 'portaluser1@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal5',
                          Lastname = 'user5', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc123');
        UserList.add(u);
        
          
        
        AttachedContentDocument att2 = new AttachedContentDocument ();
        
        
        PageReference ref9 = new PageReference('/apex/CaseFileSearch');
        Test.setCurrentPage(ref9);
        CaseFileSearchController c9 = new CaseFileSearchController();
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('caseNumber', caseObj.CaseNumber);
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        ApexPages.currentPage().getParameters().put('createdDate', 'THIS_YEAR');
        ApexPages.currentPage().getParameters().put('alpha', 'All');
        c9.caseNumber='000';
        c9.createdDate='THIS_YEAR';
        c9.creator='Alex';
        c9.SearchName='Test';
        
        CaseFileSearchController.CaseSubClass testWrap = new  CaseFileSearchController.CaseSubClass('Attachment',caseObj,att2 );
        CaseFileSearchController.CaseSubClass testWrap1 = new  CaseFileSearchController.CaseSubClass('Chatter',caseObj,att2 );
        c9.filesList.add(testWrap);
        c9.SortField=null;
        testWrap.compareTo(testWrap1);
        System.runAs(u) {
            c9.SearchCaseAttachment();
            c9.chatterQuery();
        }                
        Test.stopTest();
    }
}