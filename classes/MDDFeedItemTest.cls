/* 
 Type Name: MDDFeedItemTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test class for MDDFeedItem controller
 
 */
@isTest
public class MDDFeedItemTest {
    public static testMethod void MDDFeedItemTestmethod(){
        DataUtilTest.loadEnvironmentVariables();
        RecordType rt = [SELECT  Id FROM RecordType WHERE SObjectType = 'Account'  AND Name = 'Customer'];
        user us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        Contact conobj1;
        Account accntObj;
        System.runAs(us){
            Map<String,Object> fieldValueMap = New Map<String,Object>();
            fieldValueMap.put('Name','NamePvt company');
            fieldValueMap.put('Stage__c','Unqualified');
            fieldValueMap.put('Site_Department__c','Test Department1');
            fieldValueMap.put('Sub_Type__c','Direct');
            fieldValueMap.put('Transaction_Type__c','Transactional');
            fieldValueMap.put('Region__c','APJ');
            fieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
            fieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
            fieldValueMap.put('Bill_To_City__c','Test City');
            fieldValueMap.put('Corporate_City__c','Test City');
            fieldValueMap.put('Bill_To_Country__c','Singapore');
            fieldValueMap.put('Corporate_Country__c','Singapore');
            fieldValueMap.put('RecordTypeId',rt.id);
            fieldValueMap.put('Short_Name__c','TestAcct');
            
            accntObj = AccountDataFactory.createAccount(fieldValueMap);
            conobj1=new Contact(FirstName='Mr',
                                LastName='Testcon1rr',
                                AccountId=accntObj.Id,
                                Email='con1@gf.com',
                                Department__c='Design;Engineering',
                                is_portal_user_active__c=false
                               ); 
            insert conObj1;
        }
        Part_Family__c f = new Part_Family__c();
        f.Name = 'test family';
        insert f;
        Part__c p = new Part__c();
        p.Part_Number__c = '0000000001';
        p.Part_Family__c = 'test family';
        p.Part_Type__c = 'FC PBGA';
        insert p;
        Account_Part_Map__c accP = new Account_Part_Map__c();
        accP.Account__c = accntObj.Id;
        accP.Part__c = p.Id;
        insert accP;
        Profile portalProfile = [SELECT Id,Name FROM Profile where Name= 'Overage Customer Portal Admin' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' and Name like '%Customer%' Limit 1];
        User portalUser1 = new User(Username = 'portaluser1@testorg13.com',
                               Alias = 'auser',
                               Email='portaluser1@testorg.com',
                               EmailEncodingKey='UTF-8',
                               Firstname='Bruce3',
                               Lastname='Wayne4',
                               LanguageLocaleKey='en_US',
                               LocaleSidKey='en_US',
                               TimeZoneSidKey='America/Chicago',
                               ContactId=conobj1.Id,
                               IsActive = true ,ProfileId = portalProfile.Id
                              );
        ApexPages.StandardController sc = new ApexPages.StandardController(f);
        MDDFeedItem mdd = new MDDFeedItem(sc);
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        system.currentPageReference().getParameters().put('Id', f.Id);
        mdd.fileName = 'test';
        mdd.fileBody = Blob.valueOf('test filebody');
        mdd.saveAttachment();
        mdd.fileName = 'test';
        mdd.saveAttachment();
    }
}