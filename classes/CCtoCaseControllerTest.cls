/*
Type Name: CCtoCaseControllerTest
Author: Cognizant Case Management Team
Created Date: 02/17/2015
Reason: This is the Test class for CCtoCase related controller and Case collaboration class . 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData=false)
private class CCtoCaseControllerTest{
      /* ******************************************** CCtoCase Page******************************** */
    @testSetup static void testdata() {
       DataUtilTest.LoadATPEnvVariables();
       CaseDataUtilTest.loadCustomSettingVariables();
       
       List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
       for(integer i=1;i<=2;i++){
           Map<String,Object> fieldValueMap = new Map<String,Object>();
           fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            
           fieldValueMapList.add(fieldValueMap);            
       }
        //Inserting custom setting data
        Bill_To_Address_Number__c bl = new Bill_To_Address_Number__c();
        bl.Name='Update Bill To Address No';
        bl.Bill_To_Address_Number__c = 2072;
        insert bl; 
               
       AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    static testMethod void CCtoCaseControllerTest() {
        
        try {
                
            List < User > UserList = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Case > lstCase = new List < Case > ();
    
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
            
            Environment_Variable__c envCustom = new Environment_Variable__c();
            envCustom.name = 'CreateSharingOnContactCheck' ;
            envCustom.value__c = 'false' ;
            insert envCustom;
    
            List < Contact > contactList = new List < Contact > ();
    
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con2);
            
            Contact con3 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a2.Id, Department__c = 'GF Dept', Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con3);
    
            insert contactList;
    
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
    
            User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con1.id, Portal_Login__c = 'abc12'
            );
            UserList.add(u);
            
            User u2 = new User(ProfileId = profile1.Id,
                Username = 'portaluser2' + System.now().format('MMddyyyyHHmmss') + '@cctest.com', Alias = 'auser', Email = 'portaluser@testorg.com',
                EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Chicago', ContactId = con3.id, Portal_Login__c = 'abc12');
            UserList.add(u2);
    
            insert UserList;
    
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
    
            
            Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                Priority = 'Low', AccountId = a.Id, AccountThirdParty__c = a2.Id, Internal_or_external__c = false);
            lstCase.add(c1);
    
            Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 3', Subject = 'Test 3', Category__c = 'Reliability and Quality',
                Priority = 'Low', ContactId = con2.id, Internal_or_external__c = false);
            Test.startTest();
            lstCase.add(c2);
            
            insert lstCase;
            
            //c2.Status  ='Closed - Resolved';
            //update c2;
    
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase1', Contact__c = con2.id, Case__c = c1.id, Email_Id__c = con2.Email, Is_Subscribed__c = true);
    
            System.runAs(u) {
                insert cc;
    
                PageReference pageRef3 = Page.CCtoCaseAdd;
                Test.setCurrentPage(pageRef3);
                apexpages.currentpage().getparameters().put('Id', c1.id);
                apexpages.currentpage().getparameters().put('ccId', cc.id);
                CCtoCaseController controller3 = new CCtoCaseController(new ApexPages.StandardController(c1));
    
                controller3.add();
                controller3.unsubscribe();
                controller3.subscribe();
                controller3.AllContacts();
                controller3.searchString = 'Mr2';
                controller3.searchContact();            
                controller3.insertCaseCollaborator(contactList);
                controller3.editCC();
                controller3.deleteCC();
                controller3.clearcontact();
    
                PageReference pageRef4 = Page.CCtoCaseAdd;
                Test.setCurrentPage(pageRef4);
                apexpages.currentpage().getparameters().put('Id', c2.id);
                CCtoCaseController controller4 = new CCtoCaseController(new ApexPages.StandardController(c2));    
            }
            
            Case_Collaboration__c cc2 = new Case_Collaboration__c(Name = 'Test cctocase2', Contact__c = con3.id, Case__c = c1.id, Email_Id__c = con2.Email, Is_Subscribed__c = true);
            insert cc2;
            
            System.runAs(u) {                
                cc2.Is_Subscribed__c = false;
                update cc2;
            }    
            delete cc2;
            
            Test.stopTest();
        } catch (Exception e) {
           System.debug('pankaj21'+e);
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
    }
    
    static testMethod void CCtoCaseControllerTest2(){
     try{
            
            Map<user,string> usrRoleMap = new Map<user,string>();
            Map<user,string> portalRoleMap = new Map<user,string>();
            List < User > UserList = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Case > lstCase = new List < Case > ();
            
            Environment_Variable__c envCustom = new Environment_Variable__c();
            envCustom.name = 'Case_Team_Role_Id_Case_Stakeholder' ;
            envCustom.value__c = 'test' ;
            insert envCustom;
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
            Test.startTest();
            List < Contact > contactList = new List < Contact > ();
    
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
                          
            insert contactList;
        
        
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
    
           User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con1.id, Portal_Login__c = 'abc12'
            );
            UserList.add(u);
                       
    
            Profile p = [Select Id from Profile where name = 'Standard User'];
        
            User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User6',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
            UserList.add(u1); 
                          
            insert UserList;
            
            usrRoleMap.put(u1,'CaseCollaborator'); 
            portalRoleMap.put(u,'CaseCollaborator');                    
            //Test begins
            
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();                
            Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                Priority = 'Low', AccountId = a.Id, AccountThirdParty__c = a2.Id, Internal_or_external__c = false);
            lstCase.add(c1);
                    
            insert lstCase;
            
           // c2.Status  ='Closed - Resolved';            
           // update c2;
            
            
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase1', Contact__c = con1.id, Case__c = c1.id, Email_Id__c = con1.Email, Is_Subscribed__c = true);
    
            System.runAs(u) {
                insert cc;
                boolean flag = true;
                PageReference pageRef5 = Page.CCtoCaseAdd;
                Test.setCurrentPage(pageRef5);
                apexpages.currentpage().getparameters().put('Id', c1.id);
                apexpages.currentpage().getparameters().put('ccId', cc.id);
                CCtoCaseController controller5 = new CCtoCaseController(new ApexPages.StandardController(c1));
                
                controller5.filterString = 'User';
                controller5.searchString = 'Test';
                controller5.searchContact();
                 
                CCtoCaseController.userWrapper usrwraper = new CCtoCaseController.userWrapper(flag,u1,'');
                controller5.userSearchList.add(usrwraper);
                controller5.add();
                controller5.insertUsrCaseCollaborator(usrRoleMap); 
                
                controller5.clearcontact();
                
                 
            }                        

        } catch (Exception e) {
        system.debug('pankaj21'+e);
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
    
    static testMethod void CCtoCaseControllerTest3(){
     try{                      
            Map<user,string> portalRoleMap = new Map<user,string>();
            List < User > UserList = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Case > lstCase = new List < Case > ();
            
            Environment_Variable__c envCustom = new Environment_Variable__c();
            envCustom.name = 'Case_Team_Role_Id_Case_Stakeholder' ;
            envCustom.value__c = 'test' ;
            insert envCustom;
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
            
           
            
            List < Contact > contactList = new List < Contact > ();    
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
                          
            insert contactList;
                
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
    
           User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con1.id, Portal_Login__c = 'abc12'
            );
            UserList.add(u);
                       
    
            Profile p = [Select Id from Profile where name = 'Standard User'];
        
            User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User6',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
            UserList.add(u1); 
                          
            insert UserList;
            
           
            portalRoleMap.put(u,'CaseCollaborator');                    
            //Test begins
             Test.startTest();
             
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();                
            Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                Priority = 'Low', AccountId = a.Id, AccountThirdParty__c = a2.Id, Internal_or_external__c = false);
            lstCase.add(c1);
                    
            insert lstCase;
            
           // c2.Status  ='Closed - Resolved';            
           // update c2;
            
            
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase1', Contact__c = con1.id, Case__c = c1.id, Email_Id__c = con1.Email, Is_Subscribed__c = true);
    
            System.runAs(u) {
                insert cc;
                boolean flag = true;
                PageReference pageRef5 = Page.CCtoCaseAdd;
                Test.setCurrentPage(pageRef5);
                apexpages.currentpage().getparameters().put('Id', c1.id);
                apexpages.currentpage().getparameters().put('ccId', cc.id);                                              
                CCtoCaseController controller6 = new CCtoCaseController(new ApexPages.StandardController(c1));
                
                controller6.filterString   = 'ContUser';
                controller6.searchString = 'portal';
                controller6.searchContact();
                
                CCtoCaseController.portaluserwrapper usrwraper1 = new CCtoCaseController.portaluserwrapper(flag,u,'');
                controller6.portalUserSearchList.add(usrwraper1);
                controller6.add();
                controller6.insertPortalUsrCaseCollaborator(portalRoleMap);
                
                 
            }                        

        } catch (Exception e) {
        system.debug('pankaj21'+e);
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
    
    
    
     static testMethod void CCtoCaseControllerTest4(){
     try{                      
            
            List < User > UserList = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Case > lstCase = new List < Case > ();
                                    
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
                                   
            List < Contact > contactList = new List < Contact > (); 
            
            CasePredefinedTeam__c casePreTeam  = new CasePredefinedTeam__c();
            casePreTeam.name = 'UCM';
            casePreTeam.Internal_Team__c = '0B4900000004Gah';
            insert casePreTeam ;
            
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
                          
            insert contactList;
                
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
    
           User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal', Lastname = 'user',
                LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago', ContactId = con1.id, Portal_Login__c = 'abc12'
            );
            UserList.add(u);
                       
    
            Profile p = [Select Id from Profile where name = 'Standard User'];
        
            User u1 = new User(ProfileId = p.Id, Username = '010test666' + System.now().format('MMddyyyyHHmmss') + '@test.com',
                           Alias = 'tanm1', Email = 'test4444@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test', Lastname = 'User6',
                           LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');
            UserList.add(u1); 
                          
            insert UserList;
            
            Profile pp = [Select Id from Profile where Name='System Administrator']; 
        
            User ur = [Select Id, Name,IsActive from User where IsActive=true AND userRoleId != null and ContactId = null and ProfileID=:pp.Id Limit 1];
                                     
            //Test begins
             Test.startTest();
             
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();                
           
            Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                Priority = 'Low', AccountId = a.Id, AccountThirdParty__c = a2.Id, Internal_or_external__c = false);
            lstCase.add(c1);
                    
            insert lstCase;
            
           // c2.Status  ='Closed - Resolved';            
           // update c2;
            
           CaseTeamTemplate caseTeamTemp = new CaseTeamTemplate (Name = 'UCM' , Description = 'Test' );
           System.runAs(ur) {
               insert caseTeamTemp;
           }
            CaseTeamTemplateRecord caseTeamTempRec = new CaseTeamTemplateRecord(ParentId = c1.id, TeamTemplateId = caseTeamTemp.id);
            System.runAs(ur) {
               insert caseTeamTempRec;
            }
             system.debug('pankaj1'+caseTeamTempRec.id);    
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase1', Contact__c = con1.id, Case__c = c1.id, Email_Id__c = con1.Email, Is_Subscribed__c = true);
            
            
            System.runAs(u) {
                insert cc;
                boolean flag = true;
                PageReference pageRef5 = Page.CCtoCaseAdd;
                Test.setCurrentPage(pageRef5);
                apexpages.currentpage().getparameters().put('createdBy','UCM');
                apexpages.currentpage().getparameters().put('ccId', cc.id); 
                 apexpages.currentpage().getparameters().put('Id', c1.id);
                                                           
                CCtoCaseController controller6 = new CCtoCaseController();
                
                controller6.caseTeamSearchString    = 'UCM';
                controller6.searchUserString    = 'UCM';
                controller6.searchUserId = caseTeamTemp.id; 
                controller6.UserString = 'UCM';
                controller6.UserId   =   caseTeamTemp.id;    
                controller6.clearFlagCheck = true;
                controller6.SetValues();
                controller6.addAllUsers();
                controller6.runSearch();
                
               
                CCtoCaseController.CaseTeamWrap usrwraper1 = new CCtoCaseController.CaseTeamWrap(caseTeamTemp,flag);
                controller6.listCaseTeam.add(usrwraper1);
                controller6.UserString = 'UCM';
                controller6.UserId   =  caseTeamTemp.id;    
                controller6.clearFlagCheck = false;                                              
                controller6.SetValues();
                controller6.addCaseTeam();
            }                        

        } catch (Exception e) {
        system.debug('pankaj21'+e.getLineNumber());
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
   
   
   
    /*
    This Test method is used for @method name: onCCtoCaseAccountIdValidation 
    for CCtoCase AccountId Validation
    */
    
    static testMethod void onCCtoCaseAccountIdValidationTest1() {
        
       
        try {                        
            
            List < Account > lstAccount = new List < Account > ();
            List < Case > caseList = new List < Case > ();
                                   
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
            
            List < Contact > contactList = new List < Contact > ();
            
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id,Department__c = 'GF Dept', Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con2);
            
            insert contactList;            
            
             Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
                
            
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            Test.startTest();
             
            Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                               Description = 'Test 1111', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                               Priority = 'Low', AccountId = a.Id, ContactId = con1.Id, Internal_or_external__c = false);
            caseList.add(c1);
            
            insert caseList;
            
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase', Contact__c = con2.id, Case__c = c1.id, Email_Id__c = con2.Email, Is_Subscribed__c = true);
                                  
            insert cc;
                                                       
            c1.AccountId = a2.Id;
            
            update caseList;
            
            c1.AccountId = null;
            c1.ContactId = null;
            c1.Internal_or_external__c = true;
            
            update caseList;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    
    static testMethod void onCCtoCaseAccountIdValidationTest2() {
        
        Test.startTest();
        try {                                    
            
            List < User > lstUsers = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Contact > contactList = new List < Contact > ();
            List < Case > caseList = new List < Case > ();
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');

            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con2);
            
            insert contactList;
            
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            
            Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                               Description = 'Test 2222', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                               Priority = 'Low', Internal_or_external__c = true);
            caseList.add(c2);
            
            insert caseList;
            
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase', Contact__c = con2.id, Case__c = c2.id, Email_Id__c = con2.Email, Is_Subscribed__c = true);
            
            insert cc;
            
            c2.AccountId = null;
            c2.Internal_or_external__c = false;
            
            update caseList;
            
            c2.Internal_or_external__c = true;
            
            update caseList;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    
    static testMethod void onCCtoCaseUnsubscribeTest1() {
        
        
        try {                                    
            
            List < Account > lstAccount = new List < Account > ();
            List < Contact > contactList = new List < Contact > ();
            List < Case > caseList = new List < Case > ();
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Account a2 = getAccount('MYTEST ACCOUNT2');
            
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            
            
            insert contactList;            
            
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            
            Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                               Description = 'Test 2222', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                               Priority = 'Low', AccountId=a.Id,  Internal_or_external__c = false);
            caseList.add(c2);
            Test.startTest();
            insert caseList;
            
            c2.AccountId = a2.Id;
            c2.Status = 'In Progress';
            
            update caseList;
            
            Case_Collaboration__c cc = new Case_Collaboration__c(Name = 'Test cctocase', Contact__c = con1.id, Case__c = c2.id, Email_Id__c = con1.Email, Is_Subscribed__c = true);
            
            insert cc;
            
            cc.Is_Subscribed__c = false;            
            update cc;            
            
            delete cc;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    
    
    static testMethod void onCCtoCaseTeamValidationTest1() {
        
        Test.startTest();
        try {                        
            
            List < User > UserList = new List < User > ();
            List < Account > lstAccount = new List < Account > ();
            List < Contact > contactList = new List < Contact > ();
            List < Case > caseList = new List < Case > ();
            
            Profile p = [Select Id from Profile where name = 'System Administrator'];
            User u2 = new User(ProfileId = p.Id, Username = 'test3333' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                               Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                               Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                              );
            UserList.add(u2);
            
            Account a = getAccount('MYTEST ACCOUNT1');
            
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con2);
            
            insert contactList;
            
            
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
            User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                              Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                              Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                              ContactId = con1.id, Portal_Login__c = 'abc12');
            UserList.add(u);
            
            insert UserList;
            
            
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            
            Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                               Description = 'Test 2222', Subject = 'Test 2', Category__c = 'Reliability and Quality',
                               Priority = 'Low', AccountId = a.Id, Internal_or_external__c = false);
            caseList.add(c2);
            
            System.runAs(u) {
                insert caseList;
            }
            
            c2.OwnerId = u2.Id;
            
            update caseList;
            c2.Status = 'Acknowledged-In Queue';
            c2.Internal_or_external__c = true;
            
            update caseList;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            //System.AssertEquals(expectedExceptionThrown, true);
        }
        
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}