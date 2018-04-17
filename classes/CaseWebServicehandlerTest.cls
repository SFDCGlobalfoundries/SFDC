/*
Type Name: CaseWebServicehandlerTest
Author: Cognizant Case Management Team
Created Date: 11/27/2015
Reason: This is the Test class for CaseWebServicehandler class. 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest
private class CaseWebServicehandlerTest
{  
    static testMethod void testassignL2Button1(){
        CaseDataUtilTest.loadCustomSettingVariables();
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test503');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
        CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        insert queue1;
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        insert queue2;
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        insert queue3;
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        insert queue4;
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        insert queue5;
        
        
        
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        
        Test.startTest();
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=a.id, Team_Role__c = 'Design and Technology Support',User__c=internalUser.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        
        insert atp;
        
        //Test begins
                                       
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c1);
        Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.012UM',Target_process_node__c ='14LPP',
                           Priority = 'Low', Internal_or_external__c = false);
        caseList.add(c2);
        
        System.runAs(portalUser ) {
            insert caseList;
        }
        
        CaseWebServiceHandler.assignL2Button(c1.Id);
        CaseWebServiceHandler.assignL2Button(c2.Id);       
        CaseWebServiceHandler.check_Region();
        //system.assertEquals(c7.Category__c, c7.Category__c);
      Test.stopTest();
  }
  static testMethod void testassignL2Button2(){
      
      CaseDataUtilTest.loadCustomSettingVariables();
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test503');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'SiPh');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
         CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        insert queue1;
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        insert queue2;
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        insert queue3;
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        insert queue4;
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        insert queue5;
                
       
       
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=a.id, Team_Role__c = 'Design and Technology Support',User__c=internalUser.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        
        Test.startTest();
        //insert atp;
        
        //Test begins
        
        //Test.startTest();        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
        
        Case c3 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c3);
        
        Case c4 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false);
        caseList.add(c4);
                       
        System.runAs(portalUser ) {
            insert caseList;
        }
        
      
        CaseWebServiceHandler.assignL2Button(c3.Id);
        CaseWebServiceHandler.assignL2Button(c4.Id);
        //CaseWebServiceHandler.check_Region();
        
      Test.stopTest();
      
  }
  static testMethod void testassignL2Button5(){
      
      CaseDataUtilTest.loadCustomSettingVariables();
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test503');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
        CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        insert queue1;
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        insert queue2;
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        insert queue3;
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        insert queue4;
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        insert queue5;
        
        
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=a.id, Team_Role__c = 'Design and Technology Support',User__c=internalUser.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        Test.startTest();
        insert atp;
        
        //Test begins
        
        //Test.startTest();
                        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
               
        Case c5 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false);
        caseList.add(c5);       
        Case c6 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 4', Subject = 'Test 4', Category__c = 'Tape Out',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false);
       // caseList.add(c6); 
        
                             
        System.runAs(portalUser ) {
            insert caseList;
        }
             
        CaseWebServiceHandler.assignL2Button(c5.Id);
       // CaseWebServiceHandler.assignL2Button(c6.Id);
        //CaseWebServiceHandler.check_Region();
      Test.stopTest();
      
  }
  
  static testMethod void testassignL2Button3(){
        CaseDataUtilTest.loadCustomSettingVariables();
        
        //Test.startTest(); 
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test504');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'SiPh');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=a.id, Team_Role__c = 'Design and Technology Support',User__c=internalUser.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        Test.startTest();       
        insert atp;
        
        //Test.startTest();    
        list<CaseQueueSetup__c> queuelist = new list<CaseQueueSetup__c>();
                
        CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        queuelist.add(queue1);
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        queuelist.add(queue2);
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        queuelist.add(queue3);
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        queuelist.add(queue4);
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        queuelist.add(queue5);
        CaseQueueSetup__c queue6=new CaseQueueSetup__c();
        queue6.Name='ESD_LUP_Team';
        queue6.QueueId__c ='00G90000002Bz50';
        queuelist.add(queue6);
        insert queuelist;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
       
        Case c1 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'ESD/Latch Up',Geometry__c='0.010UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c1);
        
        Case c7 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 5', Subject = 'Test 5', Category__c = 'ESD/Latch Up',Geometry__c='0.028UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false);
        caseList.add(c7); 
        
         System.runAs(portalUser ) {
            insert caseList;
        }
        CaseWebServiceHandler.assignL2Button(c1.Id);        
        CaseWebServiceHandler.assignL2Button(c7.Id);
        CaseWebServiceHandler.getGroupMember();
       // CaseWebServiceHandler.check_Region();
        
        Account a2 = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct',
                                Transaction_Type__c = 'Transactional', Region__c = 'SiPh', Bill_To_Address_1__c = 'New Bill',
                                Bill_To_City__c = 'city1', Bill_To_Country__c = 'USA', Bill_To_State__c = 'CA',Corporate_Address_1__c = '',
                                Corporate_City__c = 'city1', Corporate_Country__c = 'USA',Corporate_State__c='USA');
        //insert a2;
      Test.stopTest();
  
}  
   static testMethod void testassignL2Button4() {
        CaseDataUtilTest.loadCustomSettingVariables();
        
        //Test.startTest(); 
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test504');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
         list<CaseQueueSetup__c> queuelist = new list<CaseQueueSetup__c>();
                
        CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        queuelist.add(queue1);
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        queuelist.add(queue2);
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        queuelist.add(queue3);
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        queuelist.add(queue4);
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        queuelist.add(queue5);
        CaseQueueSetup__c queue6=new CaseQueueSetup__c();
        queue6.Name='ESD_LUP_Team';
        queue6.QueueId__c ='00G90000002Bz50';
        queuelist.add(queue6);
        insert queuelist;
       
       
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        Account_Team_Proxy__c atp=new Account_Team_Proxy__c(Account__c=a.id, Team_Role__c = 'Design and Technology Support',User__c=internalUser.Id,
                                                            Account_Access__c = 'Read/Write', Opportunity_Access__c = 'Read/Write');
        
        Test.startTest();       
        //insert atp;
        
        //Test.startTest();    
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
       
        
        
        Case c2 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.032UM',Target_process_node__c ='CSOI 32',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c2);
        Case c3 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'ESD/Latch Up',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c3);
        Case c4 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'ESD/Latch Up',Geometry__c='0.032UM',Target_process_node__c ='32LP',
                           Priority = 'Low', Internal_or_external__c = false, AccountId = a.Id);
        caseList.add(c4);
        //Test begins
         
         System.runAs(portalUser ) {
            insert caseList;
        }
       
        CaseWebServiceHandler.assignL2Button(c2.Id);
        CaseWebServiceHandler.assignL2Button(c3.Id);
        CaseWebServiceHandler.assignL2Button(c4.Id);
        //CaseWebServiceHandler.getGroupMember();
        //CaseWebServiceHandler.check_Region();
     
        Account a2 = new Account(name = 'acc1', Site_Department__c = 'Site1', Sub_Type__c = 'Direct',
                                Transaction_Type__c = 'Transactional', Region__c = 'SiPh', Bill_To_Address_1__c = 'New Bill',
                                Bill_To_City__c = 'city1', Bill_To_Country__c = 'USA', Bill_To_State__c = 'CA',Corporate_Address_1__c = '',
                                Corporate_City__c = 'city1', Corporate_Country__c = 'USA',Corporate_State__c='USA');
        //insert a2;
      Test.stopTest();
  }
  
  
  static testMethod void testassignL2CheckRegion() {
      
      CaseDataUtilTest.loadCustomSettingVariables();
        
        List < User > UserList = new List < User > ();
        List < Account > lstAccount = new List < Account > ();
        List < Team_Room_Member__c > lstTmMem = New List < Team_Room_Member__c > ();
        List < Case > caseList = new List < Case > ();
        
        DataUtilTest.loadEnvironmentVariables();
        RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
        Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
        fieldValueAccMap.put('Name', 'test503');
        fieldValueAccMap.put('Stage__c', 'Unqualified');
        fieldValueAccMap.put('Short_Name__c', 'test725');
        fieldValueAccMap.put('Site_Department__c', 'cts.com');
        fieldValueAccMap.put('Account_Type__c', 'Customer');
        fieldValueAccMap.put('Organization_Unit__c', 'sg;us');
        fieldValueAccMap.put('Copy_Address__c', true);
        fieldValueAccMap.put('Corporate_Address_1__c', 'test');
        fieldValueAccMap.put('Corporate_City__c', 'sg');
        fieldValueAccMap.put('Corporate_Country__c', 'sg');        
        fieldValueAccMap.put('Financial_Territory__c', 'Greater China');
        fieldValueAccMap.put('Region__c', 'APJ');
        fieldValueAccMap.put('Sub_Type__c', 'Direct');
        fieldValueAccMap.put('Transaction_Type__c', 'Transactional');
        fieldValueAccMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueAccMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueAccMap.put('Fab_9_10__c', 'No');
        fieldValueAccMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        Account a = AccountDataFactory.createAccount(fieldValueAccMap); 
        
         CaseQueueSetup__c queue1=new CaseQueueSetup__c();
        queue1.Name='L2_Customer_Design_Support_APJ_EMEA';
        queue1.QueueId__c ='00G90000002DjzZ';
        insert queue1;
        CaseQueueSetup__c queue2=new CaseQueueSetup__c();
        queue2.Name='L2_Customer_Design_Support_US';
        queue2.QueueId__c ='00G90000002DjzU';
        insert queue2;
        CaseQueueSetup__c queue3=new CaseQueueSetup__c();
        queue3.Name='L2_Design_and_Technology_Support';
        queue3.QueueId__c ='00GO0000001lfJa';
        insert queue3;
        CaseQueueSetup__c queue4=new CaseQueueSetup__c();
        queue4.Name='L2_L3_ESD_LUP_Fab1_8';
        queue4.QueueId__c ='00GO00000029Vy7';
        insert queue4;
        CaseQueueSetup__c queue5=new CaseQueueSetup__c();
        queue5.Name='L2_L3_ESD_LUP_SGP';
        queue5.QueueId__c ='00GO00000029M39';
        insert queue5;
                
       
       
        List < Contact > contactList = new List < Contact > ();
        
        Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept',Email = 'portaluser@testorg.com', Is_Portal_User_Active__c = true);
        contactList.add(con1);     
        Contact con2 = new Contact(FirstName = 'Mr2', LastName = 'Testcon2', AccountId = a.Id, Department__c = 'GF Dept',Email = 'con2@gf.com', Is_Portal_User_Active__c = true);
        contactList.add(con2); 
        insert contactList;        
        
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User internalUser = new User(ProfileId = p.Id, Username = 'testTR123' + System.now().format('MMddyyyyHHmmss') + '@TRtest.com',
                           Alias = 'tanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'Test',
                           Lastname = 'User1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          );
        UserList.add(internalUser);
        
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                           Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                           Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                           ContactId = con1.id, Portal_Login__c = 'abc12');
        UserList.add(portalUser); 
        insert UserList;
        
        Test.startTest();
        //insert atp;
        
        //Test begins
        
        //Test.startTest();        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
                
        Case c4 = new Case(Status = 'New', Origin = 'Email', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                           Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Geometry__c='0.060UM',Target_process_node__c ='Other',
                           Priority = 'Low', Internal_or_external__c = false,Region__c = 'AP');
        caseList.add(c4);
                       
        System.runAs(portalUser ) {
            insert caseList;
        }
        CaseWebServiceHandler.assignL2Button(c4.Id);             
        CaseWebServiceHandler.check_Region();
        
      Test.stopTest();
      
      
      
      
  }
}