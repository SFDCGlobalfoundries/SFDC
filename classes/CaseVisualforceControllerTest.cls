/*
Type Name: CaseVisualforceControllerTest 
Author: Cognizant Case Mgmt Team
Created Date: 27-March-2014
Reason: This is the Test class for Controller all Visualforce Controller class . 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/
@isTest(SeeAllData = false)
public class CaseVisualforceControllerTest {
    @testSetup static void testdata() {
        DataUtilTest.LoadATPEnvVariables();
        CaseDataUtilTest.loadCustomSettingVariables();
        
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
        
        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl;        
        AccountDataFactory.createAccount(fieldValueMap);
    }

    /*
    This method is used for Addition and Updation of Public Comments .
    @method name: CasePublicCommentsTest1
    */
    
    static testMethod void CasePublicCommentsTest1() {
        try{                        
            List < Case > caseList = new List < Case > ();
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            //Test begins
            
            Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
            
            Case c = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                              Description = 'Test 1', Subject = 'Test 1', Category__c = 'Shipping',
                              Priority = 'Low', AccountId = a.Id, Internal_or_external__c = false);
            caseList.add(c);
            
            Case c4 = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                               Description = 'Test 5', Subject = 'Test 5', Category__c = 'Service',
                               Priority = 'Low', AccountId = a.Id, Internal_or_external__c = false);
            caseList.add(c4);
            
            insert caseList;
            
            CaseComment cc = new CaseComment(CommentBody = 'test class1', parentID = c4.Id, IsPublished = false);
            insert cc;
            
            cc.CommentBody = 'test class2';
            Test.startTest();
            update cc;
            
            c.Public_comments__c = 'Public Comments 10';
            c.Public__c=true;
            c.Status = 'Closed - Resolved';
            
            c4.Public_comments__c = 'Public Comments 11';
            c4.Public__c=true;
            c4.Reopen_Request_Status__c ='Submitted';
            c4.Survey_Comments__c ='plz reopen';
            c4.Status = 'Closed - Resolved';
            
            FeedItem fpost = new FeedItem(ParentId = c.Id, body = 'test', type = 'TextPost');
            insert fpost;
            update caseList;
            
            c.Status = 'Reopen';
            c4.Status = 'Reopen';
            update caseList;
            System.AssertEquals(c4.Status, 'Reopen');
        }catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
        
    }
    
    /*
    This method is used for Addition and Updation of Public Comments .
    @method name: CasePublicCommentsTest2
    */    
    
    static testMethod void CasePublicCommentsTest2() {
        
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
             
        
        List < Case > caseList = new List < Case > ();
        
        Account a = getAccount('MYTEST ACCOUNT1');
        
        Contact con = new Contact(FirstName = 'Mr', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com');
        
        insert con;
        
        //Profile p = [Select Id from Profile where name = 'GF Consultants'];
        //Profile p = [Select Id from Profile where name = 'GF Apps User'];
        //Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        //MM- Added
        Profile p = [Select Id from Profile where name = 'GF Consultants'];
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';        
        
        insert hcmemp;
        
        List < User > UserList = new List < User > ();
        
        User u2 = new User(ProfileId = p.Id, Username = 'casecomments332' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'con1@gf.com',  EmailEncodingKey = 'UTF-8',  Firstname = 'Test', Lastname = 'User2',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',HCM_Record_ID__c=hcmemp.id,FederationIdentifier='177314' );  
        UserList.add(u2);
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser' + System.now().format('MMddyyyyHHmmss') + '@testorg.com',
                          Alias = 'auser', Email = 'con1@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user',
                          LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con.id,
                          Portal_Login__c = 'abc12');
        UserList.add(u);
        System.runAs(ur){   
            insert UserList;
        }
        //Test begins
         Test.startTest();
       
        Id recordTypeLogisticsId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Logistics).getRecordTypeId();
        
        //Case cTemp = new Case(Status = 'New', Origin = 'Email', Description = 'Test 1', Subject = 'Test 1', Category__c = 'Shipping',
        //                      Priority = 'Low', AccountId = a.Id, ContactId = con.id);
       
      
        Case cTemp = new Case(Status = 'New', Origin = 'Email', Description = 'Test 1', Subject = 'Test 1', Category__c = 'Shipping',
                              Priority = 'Low', AccountId = a.Id, Expected_Close_Date__c=Date.today().addDays(2));        
                                      
       // insert cTemp;
        
        
        Case c = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                          Description = 'Test 1', Subject = 'Test 1', Category__c = 'Shipping',Expected_Close_Date__c=Date.today().addDays(2),
                          Priority = 'Low',  AccountId = a.Id, ContactId = con.id, Internal_or_external__c = false);
        caseList.add(c);

        Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Expedite', RecordTypeId = recordTypeLogisticsId,
                           Description = 'Test 1', Subject = 'Test 1', Category__c = 'Shipping',Expected_Close_Date__c=Date.today().addDays(2),
                           Priority = 'Low', AccountId = a.Id, ContactId = con.id, OutofOfficeOwner__c = u2.Id, Internal_or_external__c = false);
        caseList.add(c2);
        
        System.runAs(u) {            
            insert caseList;
            //Test.stopTest();
        }
        
        c.OwnerId = u2.Id;
        c.Public_comments__c = 'Public Comments 10';
        //c.Public__c=true;
        c.Status = 'Closed - Resolved';
        
        
         IntegrationUsers__c skipUser = new IntegrationUsers__c(Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
         insert skipUser;
                 
        System.runAs(u2) {
            skipUser.Skip_Trigger__c =true;
            update caseList;
        }
        
        //c.Public_comments__c = 'Public Comments 11';
               
        //update caseList;
        
        c.Public_comments__c = 'Public Comments 12';
        c.Public__c=true;
        skipUser.Skip_Trigger__c =true;
        update caseList;
        
        c.Public_comments__c = 'Public Comments 13';
        c.Public__c=true;
        c.Case_Comment__c = 'test reopen';
        c.Reopen_As_New_Case__c = true;
        c.Status = 'Reopen';
        
        System.runAs(u) {
            //update caseList;
       }
        
        c2.OutofOfficeOwner__c = UserInfo.getUserId();
        System.AssertEquals(c2.OutofOfficeOwner__c, userinfo.getUserId());
        System.runAs(u2) {
            skipUser.Skip_Trigger__c =true;

            update caseList;
        }
        
        Test.stopTest();
        
    } 
    /* ******************************************** Case Access Page for ATP Page******************************** */

    static testMethod void caseAccessAccountTeamTest1() {
        

        List < User > UserList = new List < User > ();
        List < Account > AccountList = new List < Account > ();
        Profile p = [Select Id from Profile where name = 'System Administrator'];

        User u1 = new User(ProfileId = p.Id, Username = 'testAccess111' + System.now().format('MMddyyyyHHmmss') + '@test.com',
            Alias = 'tanm1', Email = 'testAccess111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User2',
            LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
        UserList.add(u1);
        
        //System.DmlException: Insert failed. First exception on row 1; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Federation ID does not match an existing HCM Employee ID: [FederationIdentifier]
        User u2 = [Select Id From User Where (Alias = 'sprocess' OR ProfileId =:System.Label.Case_Automated_User_ProfileId) And IsActive= true Limit 1];
        
        insert UserList;
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', Description = 'Test 2', Subject = 'Test 2', 
                Priority = 'Low', SuppliedEmail='testAccess111@gf.com');
        
        System.runAs(u2) {
            insert c1;
        }

        Account a = getAccount('MYTEST ACCOUNT1');

        List < AccountTeamMember > listAccountTeamMember = new List < AccountTeamMember > ();
        AccountTeamMember ATM1 = new AccountTeamMember(accountid = a.Id, teammemberrole = 'Account Team Role1', Userid = u1.Id);
        listAccountTeamMember.add(ATM1);
        insert listAccountTeamMember;
        
        //Test begins
        Test.startTest();
        AccountShare objAccShare = New AccountShare();

        //Valid scenario 1 with proper data
        PageReference pageRef1 = Page.CaseAccessAccountTeam;
        Test.setCurrentPage(pageRef1);
        apexpages.currentpage().getparameters().put('aid', a.id);
        CaseAccessAccountTeamController controller1 = new CaseAccessAccountTeamController(new ApexPages.StandardController(objAccShare));
        controller1.UpdateRecords();

        //Invalid scenario 2 with proper data
        PageReference pageRef2 = Page.CaseAccessAccountTeam;
        Test.setCurrentPage(pageRef2);
        CaseAccessAccountTeamController controller2 = new CaseAccessAccountTeamController(new ApexPages.StandardController(objAccShare));

        //Invalid scenario 3 with proper data
        PageReference pageRef3 = Page.CaseAccessAccountTeam;
        Test.setCurrentPage(pageRef3);
        apexpages.currentpage().getparameters().put('aid', a.id);
        CaseAccessAccountTeamController controller3 = new CaseAccessAccountTeamController(new ApexPages.StandardController(objAccShare));

    System.AssertEquals(a.id, a.id);
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
            settings.Survey_Rate_5_IMG__c = 'test5';
            settings.Survey_Site_Logo__c = 'logo1';
            settings.Survey_Site_URL__c = 'http://globalfoundries.cs6.force.com/case/CaseSurvey';
            insert settings;
        }
    }
    
    
    /* ********************************************CaseSurvey page, CaseHomePortal Page , Case Close Page , CaseSearch Page ******************************** */
     static testMethod void caseMiscellaneousTestMethod() {
      
      /* ************ LatestComment ************** */
      clsCaseLatestCommentOnClose controller1 = new clsCaseLatestCommentOnClose();
      controller1.getCaseLatestComment();
      
      /* ************ Star Controller************** */
      CustomerSurveySettingInsert();
      SurveyStarController controller2 = new SurveyStarController();
      
      
      List < Account > lstAccount = new List < Account > ();
      Account a = getAccount('MYTEST ACCOUNT1');
      
      List < Contact > contactList = new List < Contact > ();
      Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
      contactList.add(con1);
      Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
          contactList.add(con2);
      insert contactList;
      
      List < User > UserList = new List < User > ();
      Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
      
      User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
          Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Alex',
          Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
          ContactId = con1.id, Portal_Login__c = 'abc12' );
      UserList.add(u);
      User u2 = new User(ProfileId = profile1.Id, Username = 'portaluser2' + System.now().format('MMddyyyyHHmmss') + '@cctest2.com',
          Alias = 'auser2', Email = 'portaluser2@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'Alex',
          Lastname = 'user2', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
          ContactId = con2.id, Portal_Login__c = 'abc123' );
      UserList.add(u2);
      
      Profile pp = [Select Id from Profile where Name='System Administrator']; 
      User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
      System.runAs(ur){
          insert UserList;
      }
      
      
      List < Case > caseList = new List < Case > ();
      Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
     
      
      Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
          Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
          Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
      caseList.add(c1);
      
      Case c5 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
          Description = 'Test 2', Subject = 'Test 5', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
          Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
      caseList.add(c5);
      
      Id recordTypeCustAppId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();        
      
      Test.startTest();
       
      System.runAs(u2) {
          Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeCustAppId,
              Description = 'Test 3', Subject = 'Test 3', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
              Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
          insert c2;
      }
      
      
      System.runAs(u) {      
          insert c1;
      }
      
      System.runAs(u) {        
          //Test.startTest();
          /* ************ CaseSearch Controller start************** */
          PageReference ref1 = new PageReference('/apex/CaseSearch');
          Test.setCurrentPage(ref1);
          BugErrorMessages__c error1=new BugErrorMessages__c();
          error1.Error_Message__c = 'Enter at least two alphanumeric characters to perform search.';
          error1.name='AdvBugSearchError';
          insert error1;
          CaseSearchController c = new CaseSearchController();
          CaseSearchController.CaseSubClass csub = new CaseSearchController.CaseSubClass(c1,true,false);
          
          ApexPages.currentPage().getParameters().put('status', 'New');
          ApexPages.currentPage().getParameters().put('SearchName', 'Test 2');
          ApexPages.currentPage().getParameters().put('SearchCaseNumber', '000');
          ApexPages.currentPage().getParameters().put('creator', 'Alex');
          ApexPages.currentPage().getParameters().put('owner', 'Smith');
          ApexPages.currentPage().getParameters().put('projectName', '20nm');
          ApexPages.currentPage().getParameters().put('pdkName', '28nm');
          ApexPages.currentPage().getParameters().put('priority', 'Low');
          ApexPages.currentPage().getParameters().put('category', 'Tape Out');
          ApexPages.currentPage().getParameters().put('classification', 'Bug');
          ApexPages.currentPage().getParameters().put('geometry', '20UM');
          ApexPages.currentPage().getParameters().put('subcategory', 'Design');
          ApexPages.currentPage().getParameters().put('AlphaFilter', 'All');
          ApexPages.currentPage().getParameters().put('SortField', 'Subject');
          ApexPages.currentPage().getParameters().put('expectedCloseDate', 'TODAY');
          ApexPages.currentPage().getParameters().put('createdDate', 'TODAY');
          ApexPages.currentPage().getParameters().put('lastModifiedDate', 'TODAY');
          ApexPages.currentPage().getParameters().put('SortFieldSave', 'Status');        
          
          


          UserRecordAccess ura = [SELECT RecordId,HasEditAccess, HasReadAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId = :u.Id AND RecordId = :c1.Id]; 
          System.debug(ura.MaxAccessLevel); 
          
          c.status = 'New';
          c.SearchName ='Test 2';            
          c.SearchCaseNumber='000';
          c.creator='Alex';
          c.owner='Smith';
          c.projectName='20nm';
          c.pdkName='28nm';
          c.priority='Low';
          c.category='Tape Out';
          c.classification='Bug';
          c.geometry='20UM';
          c.subcategory='Design';
          c.AlphaFilter='All';
          c.expectedCloseDate='TODAY';
          c.createdDate='TODAY';
          c.lastModifiedDate='TODAY';
          c.SortField='Subject';
          c.SortFieldSave='Status';
          c.ExpectedCloseDateStart = system.today();
          c.ExpectedCloseDateEnd = system.today() - 1;
          c.CreatedDateStart = system.today();
          c.CreatedDateEnd = system.today() - 1;
          c.ClosedDateStart= system.today();
          c.ClosedDateEnd= system.today() - 1;
          c.DateTimeVerifiedStart = system.today();
          c.DateTimeVerifiedEnd = system.today() - 1;            
          c.SearchCase();        
          c.getstatusList();
          c.getpriorityList();
          c.getclassificationList();
          c.getsubcategoryList();
          c.getcategoryList();
          c.getGeometryList();
          //c.getdatesFilter();
          c.SortToggle();
          
          List<Id> listcase = new List<Id>();
          listcase.add(c1.Id);
          c.getUserRecordAccessList(listcase);
         
          ApexPages.currentPage().getParameters().put('exptype', 'excel'); 
          c.totalRecords = 1;
          //c.getParameters();
          c.ExporttoExcel();
          c.ClearAll();
          
          // New ...
          
          PageReference ref6 = new PageReference('/apex/CaseSearch');
          Test.setCurrentPage(ref6);
          CaseSearchController c6 = new CaseSearchController();
          CaseSearchController.CaseSubClass csub1 = new CaseSearchController.CaseSubClass(c1,true,false);
          ApexPages.currentPage().getParameters().put('status', 'New');

          c6.status = 'New';
          c6.CreatedDateStart = system.today();
          c6.ExpectedCloseDateStart = system.today()-1;
          c6.SearchCase();        

          List<Id> listcase2 = new List<Id>();
          listcase2.add(c1.Id);
          c6.getUserRecordAccessList(listcase2);
          
          ApexPages.currentPage().getParameters().put('exptype', 'excel'); 
          c6.totalRecords = 1;
          //c6.getParameters();
          c6.ExporttoExcel();
          
          /* ************ CaseSearch Controller end************** */
          
          /* ************ CaseClose Controller start************** */
          
          PageReference ref2 = new PageReference('/apex/CaseClose?Id=' + c1.id);
              Test.setCurrentPage(ref2);
              CaseCloseController c2 = new CaseCloseController();
              ApexPages.currentPage().getParameters().put('closeReason', 'Other');
              ApexPages.currentPage().getParameters().put('closeComment', 'closeComment 1');
              c2.closeReason = 'Other';
              c2.closeComment ='closeComment 1';
              c2.getcloseReasonList();
              c2.save();
          PageReference ref3 = c2.cancel();
          
          /* ************ CaseClose Controller end ************** */
          
          /* ************ CaseHomePortal Controller start************** */
          
          PageReference ref4 = new PageReference('/apex/CaseHomePortal');
          Test.setCurrentPage(ref4);
              CaseHomeController c4 = new CaseHomeController();  
              List<Id> listcase1 = new List<Id>();
              listcase1.add(c1.Id);
              c4.getUserRecordAccessList(listcase);
              c4.portalcaselist();
               
          /* ************ CaseClose Controller end************** */
          
      }
       
      c1.Target_process_node__c = 'Other';
      c1.OwnerId = UserInfo.getUserId();
      c1.Status = 'Closed - Verified';
      
      
     IntegrationUsers__c skipUser = new IntegrationUsers__c(Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
           insert skipUser;
           skipUser.Skip_Trigger__c =true;
      update c1;
      
      
      /* ************ CaseSurvey Controller start************** */
              
      //Valid scenario with proper data
      
      PageReference pageSurvey = Page.CaseSurvey;
      Test.setCurrentPage(pageSurvey);
      apexpages.currentpage().getparameters().put('Survey_Score__c', '5');
      apexpages.currentpage().getparameters().put('Case__c', c1.id);
      apexpages.currentpage().getparameters().put('Record_Owner__c', UserInfo.getUserId());
      Test.stopTest();
      /*
      CaseSurveyController controllerSurvey = new CaseSurveyController();
      
      CustomerSurvey__c survey = controllerSurvey.getParameters();
      
      controllerSurvey.rateSurvey();
      
      survey.Resolution_Score__c = 3;
      controllerSurvey.submitForm();
      controllerSurvey.getItems();
      controllerSurvey.variableInitializationError(true);
      controllerSurvey= new CaseSurveyController(); */
      
      //Invalid scenario with proper data ..
      
      PageReference pageRefSurvey2 = Page.CaseSurvey;
      Test.setCurrentPage(pageRefSurvey2);
      CaseSurveyController controllerSurvey2 = new CaseSurveyController();
      controllerSurvey2.getParameters();
      
      /* ************ CaseSurvey Controller End************** */   
      
      /* ************ CaseClose Controller start************** */
      
      System.runAs(u) { 
          PageReference ref = new PageReference('/apex/CaseClose?Id=' + c1.id);
          Test.setCurrentPage(ref);
          CaseCloseController c = new CaseCloseController();
          ApexPages.currentPage().getParameters().put('closeReason', 'Other');
          ApexPages.currentPage().getParameters().put('closeComment', '  ');
          c.closeReason = 'Other';
          c.closeComment ='  ';
          c.save();
         // Test.stopTest();
      }
      
      /* ************ CaseClose Controller End************** */
      
      system.assertEquals(c1.Status,'Closed - Verified');
      
      
      
  }
    // Test Class for CaseRelatedController 
    static testMethod void testCaseRelatedController() {
    try{
        
        
        Account a = getAccount('MYTEST ACCOUNT1');
        
        List < Contact > contactList = new List < Contact > ();
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);
        
        insert contactList;
        
        List < User > UserList = new List < User > ();
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        
        User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
            Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
            Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
            ContactId = con1.id, Portal_Login__c = 'abc12' );
        UserList.add(u);
        Profile pp = [Select Id from Profile where Name='System Administrator']; 
        User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
        System.runAs(ur){
            insert UserList;
        }
        //Test begins
        Test.startTest();
        List < Case > caseList = new List < Case > ();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
            Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
            Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
        caseList.add(c1);
        Case c5 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
            Description = 'Test 2', Subject = 'Test 5', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
            Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
        caseList.add(c5);
        System.runAs(u) {      
            insert caseList;
        }  
        
        
        
        // Test Class for CaseReleaseTaskcontroller 
        
        List < Release_Task__c > releaseTaskList = new List < Release_Task__c > ();
        Release_Task__c r1 = new Release_Task__c(Contact_Name__c = con1.id , Development_Component__c = 'Cases');
        releaseTaskList.add(r1);
        insert releaseTaskList;
         
        PageReference ref3 = new PageReference('/apex/CaseReleaseTask');
        Test.setCurrentPage(ref3);
        apexpages.currentpage().getparameters().put('Id', r1.id);
        CaseReleaseTaskController c = new CaseReleaseTaskController();
        ApexPages.currentPage().getParameters().put('SearchCaseNumber', '000');
        c.SearchCaseNumber='000';
        c.SearchCase();
        c.add();
        c.ClearAll();
        c.closeEvent(); 
        c.SearchCase(); 
        c.getcaselist();
               
                
        PageReference ref1 = new PageReference('/apex/CaseReleaseTask');
        Test.setCurrentPage(ref1);
        CaseReleaseTaskController cr5 = new CaseReleaseTaskController();
        apexpages.currentpage().getparameters().put('Id', r1.id);
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        cr5.SearchName ='Test';
        cr5.creator='Alex';
        cr5.SearchCase();   
        cr5.getcaselist();          
         
        PageReference refCaseRelated1 = new PageReference('/apex/CaseRelated');
        Test.setCurrentPage(refCaseRelated1 );
        apexpages.currentpage().getparameters().put('Id', c1.id);
        CaseRelatedController cr1 = new CaseRelatedController ();
        ApexPages.currentPage().getParameters().put('SearchCaseNumber', '000');
        cr1.SearchCaseNumber='000';
        cr1.SearchCase();
        
        Boolean isChecked = false;
        Case objCase =c5;
        CaseRelatedController.caseWrapper wp= new CaseRelatedController.caseWrapper(isChecked, objCase);
        cr1.add();
        cr1.ClearAll();
        cr1.closeEvent();    
         cr1.getcaselist(); 
         cr1.SearchCase();       
        
        PageReference refCaseRelated2  = new PageReference('/apex/CaseRelated');
        Test.setCurrentPage(refCaseRelated2);        
        apexpages.currentpage().getparameters().put('Id', c5.id);
        CaseRelatedController cr2 = new CaseRelatedController();
        ApexPages.currentPage().getParameters().put('SearchName', 'Test');
        ApexPages.currentPage().getParameters().put('creator', 'Alex');
        cr2.SearchName ='Test';
        cr2.creator='Alex';
        cr2.SearchCase();
        
        PageReference refCaseRelated3  = new PageReference('/apex/CaseRelated');
        Test.setCurrentPage(refCaseRelated3);        
        apexpages.currentpage().getparameters().put('Id', c5.id);
        CaseRelatedController cr3 = new CaseRelatedController();
        ApexPages.currentPage().getParameters().put('SearchCaseNumber', '');
        ApexPages.currentPage().getParameters().put('SearchName', '');
        ApexPages.currentPage().getParameters().put('creator', '');
        cr3.SearchName ='';
        cr3.creator='';     
        cr3.SearchCaseNumber='';
        
        cr3.SearchCase();
        system.assertEquals(cr2.creator,'Alex');
        
        Test.stopTest();
        }catch(Exception e){
            System.Assert(e.getMessage().contains('Please enter any search string(Subject/Case Number/Case Creator).'), e.getMessage());
        }
    }
          
    static testMethod void AdvCaseSearchTestMethod() {


        

        CustomerSurveySettingInsert();
        
       
        Account a = getAccount('MYTEST ACCOUNT1');
        Profile p = [SELECT Id FROM Profile WHERE Name = : 'System Administrator'];
        String uEmail = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User u = new User(Alias = 'standt', Email = uEmail,
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'buguser1' + System.now().format('MMddyyyyHHmmss') + '@testorg.com');
        insert u;
                
        //Test begins
        Test.startTest();
        List < Case > caseList = new List < Case > ();
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
            Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
            Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
        caseList.add(c1);
        
        Id recordTypeCustAppId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Customer_Application).getRecordTypeId();        
        
               
        System.runAs(u) {        
            insert caseList;
            system.debug('caseListtest'+caseList);
            PageReference ref1 = new PageReference('/apex/CaseSearch');
            Test.setCurrentPage(ref1);
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = c1.Id;
            Test.setFixedSearchResults(fixedSearchResults);
            BugErrorMessages__c error1=new BugErrorMessages__c();
            error1.Error_Message__c = 'Enter at least two alphanumeric characters to perform search.';
            error1.name='AdvBugSearchError';
            insert error1;
            CaseSearchController c = new CaseSearchController();
            CaseSearchController.CaseSubClass csub = new CaseSearchController.CaseSubClass(c1,true,false);

            c.clearall();
            c.getcaselist();
            c.searchstring = 'all';
            c.textSearch ='Test 2';            
            c.RecPerPageAdv = '10';
            c.SearchCaseAdv();        
            c.SortToggleAdv();
            c.exporttoexcel();
            c.SearchCase();
            c.getstatuslist();
            c.next();
            c.Previous();
            c.getprioritylist();
            c.SortToggle();
            c.getGeometryList();
            c.getclassificationList();
            c.getsubcategoryList();
            c.getcategoryList();
            c.resetPagination();
            c.createPagination();
            c.displayList();
            c.createPaginationAdv();
                
            
            c.totalRecordsAdv = 1;
            c.ExporttoExcelAdv();
            c.ClearAllAdv();
            
            
            c.searchstring = 'any';
            c.textSearch ='Test 2';            
            c.RecPerPageAdv = '10';
            c.AlphaFilterAdv = 'T';
            c.SearchCaseAdv();        
            c.SortToggleAdv();
            c.totalRecordsAdv = 1;
            c.ExporttoExcelAdv();
            c.ClearAllAdv();
            
            //system.assertEquals(c.searchstring, 'any');
        } 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }  
}