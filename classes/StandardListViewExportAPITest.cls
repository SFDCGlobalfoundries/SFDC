/*
Type Name: StandardListViewExportAPITest
Author: Cognizant Case Management Team
Created Date: 20-Jan-2015
Reason: Reason: This is the Test class for StandardListViewExportAPI class. 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(SeeAllData = false)
private class StandardListViewExportAPITest {
    private static testMethod void standardListViewExportAPITest1() {
            DataUtilTest.loadEnvironmentVariables();
            RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
            fieldValueAccMap.put('Name', 'test502');
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
            
            List < Contact > contactList = new List < Contact > ();
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            insert contactList;
            system.assertEquals(con1.Email,'con1@gf.com');
            List < User > UserList = new List < User > ();
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];  
            User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                ContactId = con1.id, Portal_Login__c = 'abc12' );
            UserList.add(u);
            insert UserList;
    
            Test.startTest();
            List < Case > caseList = new List < Case > ();
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            Case c1 = new Case(Status = 'New', Origin = 'Phone', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
                Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
            caseList.add(c1);
            
            System.runAs(u) {      
                insert caseList;
            }
           
           StandardListViewExportAPI contr1 = new StandardListViewExportAPI();
           StandardListViewExportAPI.Columns csub1 = new StandardListViewExportAPI.Columns();
           PageReference ref3 = new PageReference('/apex/StandardListViewExport');
           Test.setCurrentPage(ref3);
           ApexPages.currentPage().getParameters().put('Object', 'Case');
           ApexPages.currentPage().getParameters().put('listName', 'All Cases');
           ApexPages.currentPage().getParameters().put('listid', '00B90000006kRPI');
           contr1.fetchListviewRecords();
           
           StandardListViewExportAPI contr2 = new StandardListViewExportAPI();
           StandardListViewExportAPI.Columns csub3 = new StandardListViewExportAPI.Columns();
           PageReference ref5 = new PageReference('/apex/StandardListViewExport');
           Test.setCurrentPage(ref5);
           ApexPages.currentPage().getParameters().put('Object', null);
           contr2.fetchListviewRecords(); 
             
           System.runAs(u) {                                 
                StandardListViewExportAPI c = new StandardListViewExportAPI();
                StandardListViewExportAPI.Columns csub2 = new StandardListViewExportAPI.Columns();
                PageReference ref4 = new PageReference('/apex/StandardListViewExport');
                Test.setCurrentPage(ref4);
                ApexPages.currentPage().getParameters().put('Object', 'Case');
                ApexPages.currentPage().getParameters().put('listName', 'All Cases');
                ApexPages.currentPage().getParameters().put('listid', '00B90000006kRPI');
                c.fetchListviewRecords();
            }
           
        Test.stopTest();
    } 
    private static testMethod void standardListViewExportToCSVTest1(){
            DataUtilTest.loadEnvironmentVariables();
            RecordType recordType =  [Select Id from RecordType where Name = 'Customer' AND SObjectType = 'Account'];
            Map<String,Object> fieldValueAccMap = new Map<String,Object>();       
            fieldValueAccMap.put('Name', 'test501');
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
            
            List < Contact > contactList = new List < Contact > ();
            Contact con1 = new Contact(FirstName = 'Mr1', LastName = 'Testcon1', AccountId = a.Id, Department__c = 'GF Dept', Email = 'con1@gf.com', Is_Portal_User_Active__c = true);
            contactList.add(con1);
            insert contactList;
            system.assertEquals(con1.Email,'con1@gf.com');
            List < User > UserList = new List < User > ();
            Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];  
            User u = new User(ProfileId = profile1.Id, Username = 'portaluser1' + System.now().format('MMddyyyyHHmmss') + '@cctest.com',
                Alias = 'auser', Email = 'portaluser@testorg.com', EmailEncodingKey = 'UTF-8', Firstname = 'portal',
                Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago',
                ContactId = con1.id, Portal_Login__c = 'abc12' );
            UserList.add(u);
            insert UserList;
    
            Test.startTest();
            List < Case > caseList = new List < Case > ();
            Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
            Case c1 = new Case(Status = 'New', Origin = 'Phone', Type = 'Bug', RecordTypeId = recordTypeTechnicalId,
                Description = 'Test 2', Subject = 'Test 2', Category__c = 'Tape Out',Classification__c ='Issue',Internal_or_external__c = false,
                Priority = 'Low' , Geometry__c = '0.14UM' ,SubCategory__c = 'Device' ,PDK_Name__c = 'test PDK' , AccountId = a.Id);
            caseList.add(c1);
            
            System.runAs(u) {      
                insert caseList;
            }
           
           StandardListViewExportAPI contr1 = new StandardListViewExportAPI();
           StandardListViewExportAPI.Columns csub1 = new StandardListViewExportAPI.Columns();
           PageReference ref3 = new PageReference('/apex/StandardListViewExportToCSV');
           Test.setCurrentPage(ref3);
           ApexPages.currentPage().getParameters().put('Object', 'Case');
           ApexPages.currentPage().getParameters().put('listName', 'All Cases');
           ApexPages.currentPage().getParameters().put('listid', '00B90000006kRPI');
           contr1.fetchListviewRecords();
           
           StandardListViewExportAPI contr2 = new StandardListViewExportAPI();
           StandardListViewExportAPI.Columns csub3 = new StandardListViewExportAPI.Columns();
           PageReference ref5 = new PageReference('/apex/StandardListViewExportToCSV');
           Test.setCurrentPage(ref5);
           ApexPages.currentPage().getParameters().put('Object', null);
           contr2.fetchListviewRecords(); 
             
           System.runAs(u) {                                 
                StandardListViewExportAPI c = new StandardListViewExportAPI();
                StandardListViewExportAPI.Columns csub2 = new StandardListViewExportAPI.Columns();
                PageReference ref4 = new PageReference('/apex/StandardListViewExportToCSV');
                Test.setCurrentPage(ref4);
                ApexPages.currentPage().getParameters().put('Object', 'Case');
                ApexPages.currentPage().getParameters().put('listName', 'All Cases');
                ApexPages.currentPage().getParameters().put('listid', '00B90000006kRPI');
                c.fetchListviewRecords();
            }
             
        Test.stopTest();
    }
}