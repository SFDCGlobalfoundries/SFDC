/*
Type Name: CaseTriggerHandlerTest
Author: Cognizant Case Management Team
Created Date: 07/24/2014
Reason: This is the Test class for CaseTrigger trigger, CaseTriggerHandler class and CaseHandlerUtility class . 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
private class CaseTriggerHandlerTest {
 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();  
        system.debug('start of the program'); 
     User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
          
      System.runAs(runningUser) {


            Map<String,Object> fieldValueMap = new Map<String,Object>();            
            fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
            fieldValueMap.put('stage__c', 'Unqualified');
            fieldValueMap.put('short_name__c', 'TESTrec2');
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('region__c', 'APJ');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');          
            fieldValueMap.put('Copy_Address__c', true);
            fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);          
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Fab_9_10__c','No');
            
            AccountDataFactory.createAccount(fieldValueMap);
            
            Map<String,Object> fieldValueMap1 = new Map<String,Object>();            
            fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');            
            fieldValueMap1.put('stage__c', 'Unqualified');
            fieldValueMap1.put('short_name__c', 'gfsinternal');
            fieldValueMap1.put('sub_type__c', 'Direct');
            fieldValueMap1.put('site_department__c', 'test dept');          
            fieldValueMap1.put('transaction_type__c', 'transactional');
            fieldValueMap1.put('account_profile__c', 'Fabless - Emerging1');            
            fieldValueMap1.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap1.put('region__c', 'APJ1');
            fieldValueMap1.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap1.put('financial_territory__c', 'Japan Korea');          
            fieldValueMap1.put('Copy_Address__c', true);
            fieldValueMap1.put('Corporate_Address_1__c', 'Lee');            
            fieldValueMap1.put('Corporate_Country__c', 'Japan');
            fieldValueMap1.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap1.put('bill_to_location__c', 'YES');
            fieldValueMap1.put('total_employee__c', 100);          
            fieldValueMap1.put('end_customer__c', 'people');
            fieldValueMap1.put('Revenue_Potential__c', 'High Potential');            
            fieldValueMap1.put('Target_Account__c', 'Yes');
            fieldValueMap1.put('Fab_9_10__c','No');
            
            AccountDataFactory.createAccount(fieldValueMap1);
      }
     system.debug('end of the program');  
 }  
    /*
This method is used for Insertion of Cases for All the Record Types when Account Team Proxy Role :Primary Account Manager existed .
@method name: CaseAssignmentTest1
*/
    
    static testMethod void CaseAssignmentTest1() {
        
      CaseDataUtilTest.loadCustomSettingVariables();   
      Account a = getAccount('MYTEST ACCOUNT1');
      Account a1 = getAccount('MYTEST ACCOUNT2');
       
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a1.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;
                       
        List < User > UserList = new List < User > ();
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser3', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal5',
                          Lastname = 'user4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        UserList.add(u);
         
        Profile p = [Select Id from Profile where name = 'Standard User'];
        
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User6',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        UserList.add(u1);
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){               
            insert UserList;
        }        
        //Test begins        
        List < Case > caseList = new List < Case > ();
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
                                      
        Case c3 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 4', Subject = 'Test 8', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low', ContactId = con.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'),Hold_Justification__c = 'test');
        caseList.add(c3);
              
        Case c7 = new Case(Status = 'Reopen', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 6', Subject = 'Test 10', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low', ContactId = con.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true);
        caseList.add(c7); 
        
        Case c8 = new Case(Status = 'In Progress', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 7', Subject = 'Test 11', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low', ContactId = con.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true);
        caseList.add(c8); 
        
        Case c9 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 7', Subject = 'Test 15', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low', ContactId = con.Id,AccountId = a1.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true);
        caseList.add(c9); 
                                                     
        Group testGroup = new Group(Name='L2 test group', Type='Queue');
        insert testGroup;        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Test.startTest();
        
        System.runAs(u) {
            insert caseList;
        }
                                             
        case c31 =caseList[0];
        c31.id = caseList[0].id;
        c31.Status ='On Hold';
       // c3.Status = 'On Hold';
        c31.OwnerId = userinfo.getUserId();
       // Update c31;

                            
        System.RunAs(u) {
            c3.Reopen_Request_Status__c = 'Submitted';
        }
        
                       
        c9.ContactId = con.Id;
        c9.AccountId = a.Id;
        c9.status = 'In Progress';
        //update c9;       
               
       // system.assertEquals('In Progress',c9.status);      
        Test.stopTest();
    }
    
    static testMethod void CaseAssignmentTest3() {
        
      CaseDataUtilTest.loadCustomSettingVariables();  
      Account a = getAccount('MYTEST ACCOUNT1');
      Account a1 = getAccount('MYTEST ACCOUNT2');
      list<case> updateToCaseList = new list <Case> ();
      User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ]; 
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;
        
        List < User > UserList = new List < User > ();
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser3', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal5',
                          Lastname = 'user4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        UserList.add(u);
         
        Profile p = [Select Id from Profile where name = 'Standard User'];
        
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User6',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        UserList.add(u1);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){               
            insert UserList;
        }       
        //Test begins        
        List < Case > caseList = new List < Case > ();
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
                
        Case c6 = new Case(Status = 'Acknowledged-In Queue', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 5', Subject = 'Test 9', Category__c = 'GFV-My Devices',Subcategory__c='Web View',Target_process_node__c = 'Other',
                           Priority = 'Low', ContactId = con.Id,AccountId = a.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true);
        caseList.add(c6); 
                                       
        Case c10 = new Case(Status = 'On Hold', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',Target_process_node__c = 'Other',
                           Priority = 'Low',ContactId = con.Id,AccountId = a.Id,Internal_or_external__c = false,Hold_Justification__c = 'test');
        caseList.add(c10);
                       
        Case c12 = new Case(Status = 'In Progress', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                          Description = 'Test 2', Subject = 'Test 2', Category__c = 'GFV-My Devices',Geometry__c = '0.007UM',Target_process_node__c = 'Other',
                          Priority = 'Low', AccountId = a.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,SuppliedEmail='GFuser63@testorg.com',Public_comments__c = 'Test',Survey_Comments__c ='Test1');
        caseList.add(c12);
        
        Group testGroup = new Group(Name='L2 test group', Type='Queue');
        insert testGroup; 
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Test.startTest();
        
        System.runAs(u) {
            insert caseList;
        }
              
        case c33 =caseList[1];      
        c33.id = caseList[1].id;
        c33.Status = 'Closed - Verified';       
        c33.OwnerId = userinfo.getUserId();   
        updateToCaseList.add(c33);     
        //Update c33;
        
       // c10.OwnerId = testGroup.Id;
       // updateToCaseList.add(c10); 
        Test.stopTest();
        //Update updateToCaseList;
       
        CaseComment cc1 = new CaseComment(CommentBody = 'test class2', parentID = c12.Id, IsPublished = false);
        insert cc1;
        system.assertEquals(cc1.parentID,c12.Id);                                          
        
    }
    
    /*
    This Test method is used for trigger CaseDuplicateEmailtoCase . .
    */
    
    static testMethod void CaseAssignmentEmailtoCase1() {
    
        Account a = getAccount('MYTEST ACCOUNT1');
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;
        
        List < User > UserList = new List < User > ();
         
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser3', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal5',
                          Lastname = 'user4', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        UserList.add(u);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert UserList;
        }
                                             
        User u3 = [SELECT Id FROM User WHERE (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) AND IsActive = true LIMIT 1];// GF Integration
        //Test begins
        Test.startTest();
        List < Case > caseList1 = new List < Case > ();
        List < Case > caseList2 = new List < Case > ();
        List < Case > caseList3 = new List < Case > ();
        
        Id recordTypeSFDCSupportId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Internal_Case).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        Group testGroup = new Group(Name='Swift Support', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {   
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue  ;
        }  
        Case c = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeSFDCSupportId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Internal_or_external__c = true);
        caseList1.add(c);
        
        Case ca = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeSFDCSupportId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Internal_or_external__c = true);
        caseList1.add(ca);
                   
        
        System.runAs(u3) {
            insert caseList1;
        }
        
                
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeSFDCSupportId,
                           Description = 'Test 1', Subject = 're:Test email', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Internal_or_external__c = true,SuppliedEmail = 'test@test11.com');
        caseList2.add(c1);
        
        Case ca1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeSFDCSupportId,
                           Description = 'Test 1', Subject = 're:Test email', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Internal_or_external__c = true,SuppliedEmail = 'test@test11.com');
        caseList2.add(ca1);
        
        Case ca2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 1', Subject = 're:Test email', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Internal_or_external__c = true,SuppliedEmail = 'test@test11.com');
        caseList3.add(ca2);
        
        System.runAs(u3) {
            insert caseList2;
        }
        
        
        System.runAs(u) {
            insert caseList3;
        }
        
        system.assertEquals('test@test11.com',ca2.SuppliedEmail);
        Test.stopTest();
        
    }
    /*
    This method is used for Insertion of Cases for Validation of Account with Master PDK .
    @method name: CaseMasterPDKValidationTest
    */
    static testMethod void CaseMasterPDKValidationTest() {
        
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        List < Contact > lstContact = new List < Contact > ();
        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = accntObj.Id, Email = 'con1@gf.com', Department__c = 'Design');
        
        lstContact.add(conobj);
        insert lstContact;
        
        //Test begins
        Test.startTest();
        Set < Id > setPDKIds = new Set < Id > ();
        Map < Id, String > mapPDKIdsToNames = new Map < Id, String > ();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        setPDKIds.add(objPDK.Id);
        mapPDKIdsToNames.put(objPDK.Id, objPDK.Name);
        
        Set < Id > setPDKPatchIds = new Set < Id > ();
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        setPDKPatchIds.add(objPatch.Id);
        
        list < Design_Spec__c > listSTFs = new list < Design_Spec__c > ();
        Design_Spec__c objDesignSpec = new Design_Spec__c();
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Accounts_Provisioned_To__c = 'acc;SKYWORKS SOLUTIONS;ADVANCED MICRO DEVICES, INC.,;ADVANTEST EUROPE GMBH';
        objDesignSpec.PDK__c = objPDK.Id;
        
        listSTFs.add(objDesignSpec);
        
        insert listSTFs;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c();
        objSubPDK.Name = 'Test Name';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK.Id;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';
        objSubPDK.Accounts_Provisioned_To__c = 'acc;SKYWORKS SOLUTIONS;ADVANCED MICRO DEVICES, INC.,;ADVANTEST EUROPE GMBH';
        insert objSubPDK;
        
        List < Case > caseList = new List < Case > ();
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                           Priority = 'Low', Master_PDK__c = objPDK.Id, AccountId = accntObj.Id, Internal_or_external__c = true);
        caseList.add(c1);
        
        insert caseList;
        
        system.assertEquals('Low',c1.Priority);
        Test.stopTest();
        
    }
    
    
    static void CustomerSurveySettingInsert() {

        /********* CustomerSurveySetting Custom setting Insert ************/

        CustomerSurveySetting__c settings = CustomerSurveySetting__c.getInstance();

        if (settings == null) {
            settings = new CustomerSurveySetting__c();
            settings.Survey_Rate_0_IMG__c = 'test0';
            settings.Survey_Rate_1_IMG__c = 'test1';
            settings.Survey_Rate_2_IMG__c = 'test2';
            settings.Survey_Rate_3_IMG__c = 'test3';
            settings.Survey_Rate_4_IMG__c = 'test4';
            settings.Survey_Site_Logo__c = 'logo1';
            settings.Survey_Site_URL__c = 'http://globalfoundries.cs6.force.com/case/CaseSurvey';
            insert settings;
        }
    }
    
    
    static testMethod void CaseAskQuestionError() {
        
        CustomerSurveySettingInsert();
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User u1 = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'Gtanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'GTest',
                           Lastname = 'GUser1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        insert u1;
        
        //Test begins
        Test.startTest();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                   Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',
                   Priority = 'Low', Internal_or_external__c = true);
        System.runAs(u1){
            insert c1;
        }
        
        FeedItem feeditemVar3 = new FeedItem();
        feeditemVar3.parentid = c1.id;
        feeditemVar3.Type = 'QuestionPost';
        feeditemVar3.VISIBILITY = 'AllUsers';
        feeditemVar3.Title = 'askcustomer1';
        feeditemVar3.Body = 'askcustomer1';
        try{
            System.runAs(u1){
                insert feeditemVar3;
            }
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('a'), e.getMessage());
        }   
            
        Test.stopTest();
    }
    /*
    This method is used for teamRoomMembersPermissionOnCase methods for CaseTeamMemberHandler class Portal Users.
    @method name: TeamRoomMembersPermissionOnCaseTest2
    */
    
    static testMethod void EmailToCase() {
        
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        Account a = getAccount('MYTEST ACCOUNT1');
        
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1); 
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'Atanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'ATest',
                           Lastname = 'AUser1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'Causer', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Cportal',
                           Lastname = 'Cuser', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];               
        Test.startTest();
        system.runas(ur){
            insert UserList;
        }
        
        //Test begins
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        
        Case c1 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Emailtocase_Test1', Subject = 'Emailtocase_Test1', Category__c = 'Tapeout',
                           Priority = 'Low', Internal_or_external__c = true,AccountId = a.id );
        caseList.add(c1);
        
        Case c2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Emailtocase_Test1', Subject = 'Emailtocase_Test2', Category__c = 'Tapeout',
                           Priority = 'Low', Internal_or_external__c = true,SuppliedEmail='GFuser63@testorg.com');
        caseList.add(c2);
        insert caseList;
        
        EmailMessage em = new EmailMessage();
        em.FromAddress = con2.Email;
        em.Incoming = true;
        em.ToAddress = 'fdrytech@gmail.com';
        em.ccAddress = con1.email;
        em.ccAddress =em.ccAddress+';'+internalUser.email + ';' + 'test@testmail.com';
        em.Subject = 'Test email';
        em.TextBody = 'Hello';
        em.ParentId = c1.Id;
        insert em;
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ){
            internalUser.IsActive = false;
            update internalUser;
        }
        EmailMessage em1 = new EmailMessage();
        em1.FromAddress = con2.Email;
        em1.Incoming = true;
        em1.ToAddress = 'fdrytech@gmail.com';
        em1.ccAddress = con1.email;
        em1.ccAddress =em.ccAddress+';'+internalUser.email;
        em1.Subject = 'Test email';
        em1.TextBody = 'Hello';
        em1.ParentId = c2.Id;
        insert em1;
        system.assertEquals(em1.ParentId ,c2.id); 
        Test.stopTest();
    }  
    
    /* This method is used for Duplicate Email to Case Creation with Case Status "Closed Duplicate" Business Logic 
    when Email send with same Case Subject .
    @method name: DuplicateEmailtoCase
    */
    static testMethod void TechCaseEmailtoCase1() {
    try{
        CaseDataUtilTest.loadCustomSettingVariables();        
        DataUtilTest.LoadATPEnvVariables();
        CaseQueueSetup__c cs1=new CaseQueueSetup__c();
        cs1.Name='L2_Design_and_Technology_Support';
        cs1.QueueId__c = '00G90000002rWxV';
        insert cs1;
        Account accntObj = getAccount('MYTEST ACCOUNT1');
    
        List < User > UserList = new List < User > ();
        List < Contact > lstContact = new List < Contact > ();
        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = accntObj.Id, Email = 'con1@gf.com', Department__c = 'Design');
        
        lstContact.add(conobj);
        insert lstContact;
        User u3 = [SELECT Id FROM User WHERE (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) AND IsActive = true LIMIT 1];// GF Integration
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=accntObj.id, Team_Role__c = 'Design and Technology Support',User__c=u3.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        insert atp;
        system.assert(atp.Id!=null);
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];        
        User u1 = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'Stanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test7',
                           Lastname = 'SUser1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(u1);   
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User u2 = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'CPauser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'CPportal',
                           Lastname = 'Cpuser', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = conobj.id, Portal_Login__c = 'abc12');
        UserList.add(u2);
        
        insert UserList;
        //Test begins
        Test.startTest();
        List < Case > caseList = new List < Case > ();
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                           Priority = 'Low',  AccountId = accntObj.Id, ContactId = conobj.Id, Internal_or_external__c = false,
                           SuppliedEmail='portaluser@testorg.com');
        caseList.add(c1);
        
        Case c2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'RE: Test 2', Category__c = 'Reliability and Quality',
                           Priority = 'Low',  AccountId = accntObj.Id, ContactId = conobj.Id, Internal_or_external__c = false,
                           SuppliedEmail='portaluser@testorg.com');
        caseList.add(c2); 
        
        Case c3 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 3', Category__c = 'Reliability and Quality',
                           Priority = 'Low',  Internal_or_external__c = false,
                           SuppliedEmail='portaluser@testorg.com');
        Case c4 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'RE: Test 3', Category__c = 'Reliability and Quality',
                           Priority = 'Low',  Internal_or_external__c = false,
                           SuppliedEmail='portaluser@testorg.com');
        caseList.add(c3); 
        caseList.add(c4);
        
        System.runAs(u1){       
            insert caseList;
        
        }
        Test.stopTest();
    }catch(Exception e){
        System.Assert(e.getMessage().contains('a'), e.getMessage());
    }
        
        
    }
    static testMethod void LogisticCaseEmailtoCase1() {
    
        set<id> caseset10 = new set<id>();
        CaseQueueSetup__c cs1=new CaseQueueSetup__c();
        cs1.Name='L2_Design_and_Technology_Support';
        cs1.QueueId__c = '00G90000002rWxV';
        insert cs1;
        
        CaseQueueSetup__c cs2=new CaseQueueSetup__c();
        cs2.Name='L2 - Fab 9 Quality & Yield';
        cs2.QueueId__c = '00G90000002rWyV';
        insert cs2;
        Profile p = [Select Id from Profile where name = 'System Administrator'];        
        User u1 = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm12', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test8',
                           Lastname = 'User12', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );          
        insert u1;
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        Contact conobj = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = accntObj.Id, Email = 'portaluser@testorg.com', Department__c = 'Design');
        insert conobj;
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User u2 = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser1', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal1',
                           Lastname = 'user12', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = conobj.id, Portal_Login__c = 'abc12');
        insert u2;
        //Test begins
        Test.startTest();     
        List < Case > caseList1 = new List < Case > ();
        List < Case > caseList2 = new List < Case > ();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        Case c1 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 1', Subject = 'Test 1', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c = true,AccountId = accntObj.Id,
                           SuppliedEmail='portaluser@testorg.com');     
        caseList1.add(c1);
        Case ct1 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c = true,AccountId = accntObj.Id,
                           SuppliedEmail='portaluser@testorg.com');
        
        caseList1.add(ct1);
        System.runAs(u1){       
            insert caseList1;        
        }
        Case c2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 1', Subject = 'RE: Test 1', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c = true,AccountId = accntObj.Id,
                           SuppliedEmail='portaluser@testorg.com');
        caseList2.add(c2); 
        Case ct2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'RE: Test 2', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c = true,AccountId = accntObj.Id,
                           SuppliedEmail='portaluser@testorg.com');                                   
        
        caseList2.add(ct2);
        
        Case c10 = new Case(Status = 'new', Origin = 'Email', Type = 'Bug Report',RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low',AccountId = accntObj.Id,ContactId = conobj.Id,SuppliedEmail='GFuser63@testorg.com',Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,OwnerId = userinfo.getUserId());
      
        System.runAs(u2) {
            insert c10; 
        } 
        
        system.assertEquals('GFV-My Devices',c10.Category__c);
        caseset10.add(c10.id);
        
        System.runAs(u1){       
            insert caseList2;
        
        }    
       
           
        CaseHandlerUtility.CaseAutoApproveProcess(caseset10);
        
        
        Test.stopTest();
    }
    
   /* This method is used for CCtoCase AccountId Validation. 
     @method name: onCCtoCaseAccountIdValidation
    */
    /* this test method is used to get positive results of CaseHandlerUtility class to get valid account ids*/
    static testMethod void onCCtoCaseAccountIdValidation() {
        
        List < User > UserList = new List < User > ();
        List < Case > caseList = new List < Case > ();
        List < Id > ListOwner = new List < Id > ();
        List < Id > ListCase = new List < Id > ();
        Set < User > UserSets = new Set < User > ();
        Set < Case > Casesets = new Set < Case > ();
        Set < id> cntId = new Set < id > ();
        Set < id> feedId = new Set < id > ();
        Set < id > caseset = new Set < id > ();
        Set < id > caseset10 = new Set < id > ();
        Set < id > userset = new set < id > ();
        Set < id > accset = new set < id > ();
        Set < id > attId = new set < id > ();
        Set < Id > caseIdse = new Set < Id > () ;
        Map < String, Set < Case > > mapEmailCase = new Map < String, Set < Case > > ();
        Map < String, Set < User > > mapEmailUserIds = new Map < String, Set < User > > ();
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
           
        String type='delete';
         
                
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm13', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test13', Lastname = 'User14',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
       
        UserList.add(u1);
        
        Attachment att=new attachment(name='attachment',ContentType='emails');
        attId.add(att.id);
        Account a = getAccount('MYTEST ACCOUNT1');
        accset.add(a.id);
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
             
        insert con;        
        
        cntId.add(con.id);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin']; 
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser63' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser5', Email = 'portaluser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal15',
                          Lastname = 'user51', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        
        UserList.add(u);
        
        User u3 = [Select Id From User Where (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) And IsActive= true Limit 1];    
            
        userset.add(u.id);
        
        Test.startTest();
                                   
        Case c10 = new Case(Status = 'new', Origin = 'Email', Type = 'Bug Report',RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low',AccountId = a.Id,ContactId = con.Id,SuppliedEmail='GFuser63@testorg.com',Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,OwnerId = userinfo.getUserId());
      
        System.runAs(u) {
            insert c10; 
        } 
        caseset10.add(c10.id);
        list<string> caseIds=new list<string>(); 
        Case c2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug',
                           Description = 'Test 1', Subject = 'RE: Test 1', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c =false,AccountId = a.Id,OwnerId = userinfo.getUserId(),
                           SuppliedEmail='portaluser@testorg.com');
        insert c2;
        caseList.add(c2);
        caseset.add(c2.id);
        ListCase.add(c2.id);
        c2.OwnerId = userinfo.getUserId();
        ListOwner.add(c2.OwnerId);
        caseIdse.add(c2.Id);
         caseIds.add(C2.Id);
                   
        String encodedContentsString='ContentPost';       
        
        CaseHandlerUtility.standardUsersPermissionOnCase(caseset10);
        CaseHandlerUtility.trackException('ttft',1,'gfgyfyf','gfdfrt');
        CaseHandlerUtility.onCaseTeamContactValidation(caselist);
        CaseHandlerUtility.teamRoomMembersPermissionOnCase(caseIdse,caseIds);
       // CaseHandlerUtility.onCaseTeamMemberAdd(userset,cntId,caseset); 

        system.assertEquals(a.Id,c2.AccountId);     
        Test.stopTest();
    }
    /*  This method is used for OnAfterInsertCaseCollaboration. 
         @method name: onCCtoCaseAccountIdValidation //
    */
    
    
    static testMethod void onCCtoCaseAccountIdValidation1() {
        
        List < User > UserList = new List < User > ();
        List < Case > caseList = new List < Case > ();
        List < Id > ListOwner = new List < Id > ();
        List <Id> ListCase = new List <Id> ();
        Set < User > UserSets = new Set < User > ();
        Set < Case > Casesets = new Set < Case > ();
        Set < id> cntId = new Set < id > ();
        Set < id> feedId = new Set < id > ();
        Set < id > caseset = new Set < id > ();
        Set < id > caseset10 = new Set < id > ();
        Set < id > userset = new set < id > ();
        Set < id > accset = new set < id > ();
        Set < id > attId = new set < id > ();
        Map < String, Set < Case > > mapEmailCase = new Map < String, Set < Case > > ();
        Map < String, Set < User > > mapEmailUserIds = new Map < String, Set < User > > ();
         
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
           
        String type='delete';
                         
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm13', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test13', Lastname = 'User14',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
       
        UserList.add(u1);
        
        Attachment att=new attachment(name='attachment',ContentType='emails');
        attId.add(att.id);
        Account a = getAccount('MYTEST ACCOUNT1');

        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=a.Id;
        update env;
        
        accset.add(a.id);
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
             
        insert con;        
        
        cntId.add(con.id);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
    Test.startTest();
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser63' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser5', Email = 'portaluser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal15',
                          Lastname = 'user51', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        
        UserList.add(u);
        
        User u3 = [Select Id From User Where (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) And IsActive= true Limit 1];    
            
        userset.add(u.id);
        
        Profile profile2 = [Select Id from Profile where name = 'GF Consultants']; //GF Consultants,GF PIYE (Standard),GF System Admin,GF Apps User,
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';        
        
        insert hcmemp; 
        system.assert(hcmemp.Id!=null); 
                                //Chatter External User,Standard Platform User
        User u2 = new User(ProfileId = profile2.Id, Username = '01shivak' + System.now().format('MMddyyyyHHmmss') + '@test.com',FederationIdentifier='177314',
                          Alias = 'Nishi', Email = 'GFuser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Nishi ',HCM_Record_ID__c=hcmemp.id,
                          Lastname = 'Jha', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        
        UserList.add(u2);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert UserList; 
        } 
                  
        Case c10 = new Case(Status = 'new', Origin = 'Email', Type = 'Bug Report',RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 10', Subject = 'Test 14', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low',AccountId = a.Id,ContactId = con.Id,SuppliedEmail='GFuser63@testorg.com',Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,OwnerId = userinfo.getUserId());
      
        System.runAs(u) {
            insert c10; 
        } 
        caseset10.add(c10.id);
        
        Case c2 = new Case(Status = 'New', Origin = 'Email to Case', Type = 'Bug',
                           Description = 'Test 1', Subject = 'RE: Test 1', Category__c = 'Quality',
                           Priority = 'Low',  Internal_or_external__c =false,AccountId = a.Id,OwnerId = userinfo.getUserId(),
                           SuppliedEmail='portaluser@testorg.com');
        insert c2;
        caseList.add(c2);
        caseset.add(c2.id);
        ListCase.add(c2.id);
        c2.OwnerId = userinfo.getUserId();
        ListOwner.add(c2.OwnerId);
        
        list<string> caseIds=new list<string>();
       
        
        String encodedContentsString='ContentPost';
                        
        
        CaseHandlerUtility.removeShareFromCustomerUser(caseset,accset);
        CaseHandlerUtility.standardUsersPermissionOnCase(caseset10);
        //CaseHandlerUtility.onCaseTeamMemberAdd(userset,cntId,caseset);
        CaseHandlerUtility.caseAttachmentDelete(attId);
        CaseHandlerUtility.CaseAutoApproveProcess(caseset10);
        
       // CaseHandlerUtility.caseLastChatterFeedItemUpdate(feedId);
        CaseHandlerUtility.calculateL2L3Routings(Listcase,ListOwner);
        
        system.assertEquals('Quality',c2.Category__c);  
        Test.stopTest();
    }
    /*  This method is used for OnAfterInsertCaseCollaboration. 
         @method name: onCCtoCaseAccountIdValidation //
    */
    /* this test method is used to get positive results of CaseTriggerHandler class */
   static testMethod void callCasetriggerhandler() {
       
        List < User > UserList = new List < User > ();
        List < Case > caseList = new List < Case > ();
        Set < id> cntId = new Set < id > ();
        set<id> caseAttchid = new set<id>();
        Set < id > caseset = new Set < id > ();
        Set < id > userset = new set < id > ();
        Set < id > accset = new set < id > ();
        Set < id > attId = new set < id > ();
        
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
        
        
        Attachment att2 =new attachment(name='attachment',ContentType='emails');
        attId.add(att2.id);      
      
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        system.debug('before user object::');
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm16', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test16', Lastname = 'User46',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        
        UserList.add(u1); 
        
        Account a = getAccount('MYTEST ACCOUNT1');
        accset.add(a.id);
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con; 
        system.assert(con.Id!=null);   
        cntId.add(con.id);
        
        String encodedContentsString ='ContentPost';
        
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser63' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser17', Email = 'portaluser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal17',
                          Lastname = 'user17', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        
        UserList.add(u);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert UserList; 
        }  
        userset.add(u.id);
        
        list<string> caseonwerids=new list<string>();
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {   
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }  
          
        Test.startTest(); 
        
        Case aCase = new Case(OwnerId = UserInfo.getUserId()); 
        insert aCase;
        caseonwerids.add(aCase.OwnerId);
                
        case[] oldcase=new case[]{};
        case[] newcase=new case[]{};
        case[] updatedcase=new case[]{};  
         
         
         
        //Test.startTest(); 
         
        Case c10 = new Case(Status = 'new', Origin = 'Email to Case', Type = 'Bug Report',RecordTypeId = recordTypeCustomerApplicationId,
                                        Description = 'Test 10', Subject = 'Test 14', Category__c = 'Tape out',Subcategory__c='Web View',
                                        Priority = 'Low',AccountId = a.Id,SuppliedEmail='portaluser@testorg.com',Internal_or_external__c = false,OwnerId = userinfo.getUserId());
        caseList.add(c10);
        
        system.runAs(u)
        {
            insert c10; 
        }
       
               
        Map < ID, Case > CaseMapID = new Map < ID, Case >();
        CaseMapID.put(c10.id,c10);
     
           
        Case_Collaboration__c [] arraycase = new Case_Collaboration__c[]{};
        Case_Collaboration__c [] arrayupdatecc = new Case_Collaboration__c[]{};
        Case_Collaboration__c casecollab=new Case_Collaboration__c(name='TeamCts',Email_Id__c='dummyxyz@gmail.com',Case__c=c10.id,Contact__c=con.id,Is_Subscribed__c=false);
        insert casecollab;
        arraycase.add(casecollab);
        
        casecollab.Is_Subscribed__c = true;
        update casecollab;
        arrayupdatecc.add(casecollab);
        
        Map<id,Case_Collaboration__c> casemap=new Map<id,Case_Collaboration__c>();
        casemap.put(casecollab.id,casecollab);
        
        CaseTriggerHandler cthlr=new CaseTriggerHandler(true,1);
        cthlr.OnAfterInsertCaseCollaboration(arraycase);
         
        CaseTriggerHandler cthlr1=new CaseTriggerHandler(true,1);
        
        Test.stopTest();
    }
  
  
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
        
    }
    
    
     static testMethod void callCasetriggerhandler1() {
                    
        List < User > UserList = new List < User > ();
        List < Case > caseList = new List < Case > ();
        List <Feedcomment> newFeedComments = new list<Feedcomment>();   
        Set < id> cntId = new Set < id > ();
        Set < id > caseset = new Set < id > ();
        Set < id > userset = new set < id > ();
        Set < id > accset = new set < id > ();
        Set < id > attId = new set < id > ();
        Map < id, CaseComment> CaseCommentMapOld = new Map < id, CaseComment>();    
        
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
                        
        
        String value='null';
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        system.debug('before user object::');
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm16', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test16', Lastname = 'User46',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        
        UserList.add(u1);
        
        Account a = getAccount('MYTEST ACCOUNT1');
        accset.add(a.id);
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;    
        cntId.add(con.id);
        
        String encodedContentsString ='ContentPost';
        Attachment [] attArray = new Attachment[]{};
        Attachment att=new attachment(name='attachment',ContentType='emails',body=blob.valueOf(encodedContentsString),ParentId=a.id);
        insert att;
        
        attArray.add(att);
        attId.add(att.id);
        system.debug('before user object2::');
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser63' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser17', Email = 'portaluser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal17',
                          Lastname = 'user17', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        
        UserList.add(u);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert UserList; 
        }
        userset.add(u.id);
        system.debug('after user object2::'+UserList);
        
        list<string> caseonwerids=new list<string>();
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {   
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }  
        Test.startTest(); 
        
        Case aCase = new Case(OwnerId = UserInfo.getUserId()); 
        insert aCase;
        
        caseonwerids.add(aCase.OwnerId);     
        case[] oldcase=new case[]{};
        case[] newcase=new case[]{};
        case[] updatedcase=new case[]{};  
        Case c10 = new Case(Status = 'new', Origin = 'Email to Case', Type = 'Bug Report',RecordTypeId = recordTypeCustomerApplicationId,
                                        Description = 'Test 10', Subject = 'Test 14', Category__c = 'Tape out',Subcategory__c='Web View',
                                        Priority = 'Low',AccountId = a.Id,SuppliedEmail='portaluser@testorg.com',Internal_or_external__c = false,OwnerId = userinfo.getUserId());
        caseList.add(c10);
        
        system.runAs(u)
        {
            insert c10; 
        }
         
        
        Map < ID, Case > CaseMapID = new Map < ID, Case >();
         CaseMapID.put(c10.id,c10);
        
        Case c2 = new Case(Status = 'new', Origin = 'Email to Case', Type = 'Bug',RecordTypeId = recordTypeLogisticsId,Category__c='Quality',
                           Description = 'Test 1', Subject = 'RE: Test 1', Geometry__c='0.010UM',Target_process_node__c='10LLP',
                           Priority = 'Low',  Internal_or_external__c = false,AccountId = a.Id,ownerId=userinfo.getUserId(),
                           SuppliedEmail='test4444@gf.com',Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'));
        
        oldcase.add(c2);
        System.runAs(u) 
        {
            insert oldcase;
        } 
        Case c3 = new Case(Status = 'Closed - Verified', Origin = 'Email to Case', Type = 'Bug',RecordTypeId = recordTypeCustomerApplicationId,Category__c='Quality',
                           Description = 'Test 1', Date_Time_Verified__c=DateTime.Now(),Case_Closed_By__c = UserInfo.getUserId(),Close_Date__c = DateTime.Now(),
                           Priority = 'Low',  Internal_or_external__c = false,AccountId = a.Id,Verified_By__c=userinfo.getUserId(),ContactId = con.id,
                           SuppliedEmail='test4444@gf.com',Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'));
        
        newcase.add(c3);
        //Test.stopTest();
        System.runAs(u) 
        {
            insert newcase;
        } 
        system.debug(LoggingLevel.ERROR,'oldcase fields for case2::'+oldcase);
                
        c2.ownerId=userinfo.getUserId(); 
        c2.Status='closed';
        c2.RecordTypeId=recordTypeCustomerApplicationId;
        system.debug(LoggingLevel.ERROR,'record type::'+recordTypeCustomerApplicationId);
        c2.Expected_Close_Date__c=system.today() + 1;
        c2.Category__c='Tape out';
        
        system.debug(LoggingLevel.ERROR,'updated fields for case2::'+updatedcase);
        
        System.runAs(u) 
        {
           //pri update c2;
        } 
        updatedcase.add(c2);
        
        
        Case_Collaboration__c [] arraycase = new Case_Collaboration__c[]{};
        Case_Collaboration__c [] arrayupdatecc = new Case_Collaboration__c[]{};
        Case_Collaboration__c casecollab=new Case_Collaboration__c(name='TeamCts',Email_Id__c='dummyxyz@gmail.com',Case__c=c10.id,Contact__c=con.id,Is_Subscribed__c=false);
        insert casecollab;
        
        arraycase.add(casecollab);
        update casecollab;
        arrayupdatecc.add(casecollab);
        Map<id,Case_Collaboration__c> casemap=new Map<id,Case_Collaboration__c>();
        casemap.put(casecollab.id,casecollab);
        CaseComment cc1 = new CaseComment(CommentBody = 'test class2', parentID = c2.Id, IsPublished = false);
        CaseComment[] oldCaseComments1= new CaseComment[]{};
        CaseComment[] oldCaseComments= new CaseComment[]{};
         insert cc1;
         
         oldCaseComments.add(cc1); 
         cc1.CommentBody = 'test class3';
         Update cc1;
         oldCaseComments1.add(cc1);
         system.assertEquals(cc1.parentID,c2.Id);
        
        CaseTriggerHandler cthlr=new CaseTriggerHandler(true,1);        
        cthlr.OnAfterDeleteCaseCollaboration(arraycase,arrayupdatecc);
        //CaseTriggerHandler cthlr1=new CaseTriggerHandler(true,1); 
        cthlr.OnAfterInsertCaseAttachment(attArray);
        cthlr.caseQuestionAnswered(newFeedComments);
        cthlr.OnAfterUpdateCaseComment(oldCaseComments,oldCaseComments1,CaseCommentMapOld );
        CaseTriggerHandler.isNotBlank(value);
        CaseHandlerUtility.removeShareFromCustomerUser(caseset,accset); 
        system.assertEquals('test4444@gf.com',c3.SuppliedEmail);        
        Test.stopTest();
    }
    
    static testMethod void callCasetriggerhandlerattchment(){
    
        set<id> caseAttchid = new set<id>();
        List < User > UserList = new List < User > ();
        
        Account a = getAccount('MYTEST ACCOUNT1');
        //accset.add(a.id);
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        insert con;
        system.assert(con.Id!=null);
        
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser63' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser17', Email = 'portaluser63@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal17',
                          Lastname = 'user17', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                          ContactId = con.id, Portal_Login__c = 'abc12');
        
        UserList.add(u);
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm16', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test16', Lastname = 'User46',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        
        UserList.add(u1); 
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        system.runas(ur){
            insert UserList; 
        }
        
            
        //cntId.add(con.id);
        
        Test.startTest(); 
        
        String encodedContentsString ='ContentPost';
        Case c4 = new Case(Status = 'new', Origin = 'Email to Case', Type = 'Bug',RecordTypeId = recordTypeTechnicalId,Category__c='Quality',
                           Description = 'Test 1', Subject = 'Test 19', Geometry__c='0.010UM',Target_process_node__c='10LLP',
                           Priority = 'Low',  Internal_or_external__c = false,AccountId = a.Id,ownerId=userinfo.getUserId(),
                           SuppliedEmail='test4444@gf.com');
        System.runAs(u) 
        {
            insert c4;
        } 
        
        caseAttchid.add(c4.id);
        FeedItem listfeed=new FeedItem(Type='ContentPost',ParentId=c4.id,Body='contentpost');
        System.runAs(u1){
            insert listfeed; 
        }

        Attachment att1 = new attachment(name='attachment',ContentType='emails',body=blob.valueOf(encodedContentsString),ParentId = c4.id);
            insert att1; 
            system.assertEquals('10LLP',c4.Target_process_node__c);  
                 
       // feedId.add(listfeed.id);
       CaseHandlerUtility.feedAttachFlag = true;  
       CaseHandlerUtility.caseLastChatterFeedItemAttachmentUpdate(caseAttchid);
       CaseHandlerUtility CaseHandUtil=new CaseHandlerUtility();
      // CaseHandUtil.CaseAccountTeamProxy wrap=new CaseHandUtil.CaseAccountTeamProxy();
       system.assertEquals('10LLP',c4.Target_process_node__c);
       
        Test.stopTest();
    }
    static testMethod void CaseAssignmentTest4() {
       Test.startTest(); 
       CaseDataUtilTest.loadCustomSettingVariables();   
      Account a = getAccount('MYTEST ACCOUNT1');
      Account a1 = getAccount('MYTEST ACCOUNT2');
      Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a1.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
      insert con;
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Id recordTypeCustomerApplicationId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();
                                      
        Case c3 = new Case(AccountId = a1.Id,Status = 'New', Origin = 'Email', Type = 'Bug Report', RecordTypeId = recordTypeCustomerApplicationId,
                           Description = 'Test 4', Subject = 'Test 8', Category__c = 'GFV-My Devices',Subcategory__c='Web View',
                           Priority = 'Low', ContactId = con.Id, Internal_or_external__c = false,SkipValidationRuleInTrigger__c = true,Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'),Hold_Justification__c = 'test');
        insert c3;
        
        Test.stoptest();
        c3.Status ='On Hold';
        c3.OwnerId = userinfo.getUserId();
        c3.ContactId = con.Id;
       // c3.AccountId = a.Id;
        c3.status = 'In Progress';
        
        update c3;       
        
    }
     
    static testMethod void CaseAssignmentTest5() {
         Test.startTest();
         try{
         List < User > UserList = new List < User > ();
        Account a = getAccount('MYTEST ACCOUNT1');
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm16', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test16', Lastname = 'User46',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        
        UserList.add(u1);
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Case c2 = new Case(Status = 'new', Origin = 'Email to Case', Type = 'Bug',RecordTypeId = recordTypeTechnicalId,Category__c='Quality',
                           Description = 'Test 1', Subject = 'RE: Test 1', Geometry__c='0.010UM',Target_process_node__c='10LLP',
                           Priority = 'Low',  Internal_or_external__c = true,AccountId = a.Id,ownerId=userinfo.getUserId(),
                           SuppliedEmail='test4444@gf.com',Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'));
         insert c2;
         
         Case c3 = new Case(AccountId = a.Id,Status = 'Closed - Duplicate', Origin = 'Email',  RecordTypeId = recordTypeTechnicalId ,
                           Description = 'Test 4', Subject = 'Test 8', Category__c = 'GFV-My Devices',Subcategory__c='Web View',Parent_Case__c = c2.id ,
                           Priority = 'Low', ContactId = u1.id , Internal_or_external__c = true,SkipValidationRuleInTrigger__c = true,Close_Requested_Date__c = Datetime.valueOf('2017-10-5 12:20:20'));
        insert c3;
    
      
        c3.Status ='Closed - Duplicate';
        update c3;
		system.assertEquals('10LLP',c2.Target_process_node__c);  
        Test.stoptest();
         }
     catch (exception e) {
            System.assert(true, 'Exception ' + e);
        }
    
    }
}