/* 
 Type Name: MDD_LoginControllerTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test Class for MDD_LoginController
 
 */
@isTest(SeeAllData=false)
public class MDD_LoginControllerTest{
    public static testMethod void MDD_LoginControllerTestMethod(){
        DataUtilTest.loadEnvironmentVariables();
        RecordType rt = [SELECT  Id FROM RecordType WHERE SObjectType = 'Account'  AND Name = 'Customer'];
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
        
        Account accntObj1 = AccountDataFactory.createAccount(fieldValueMap);
        Contact conobj = new Contact(FirstName='Mr',
                                     LastName='Testcon1r11r',
                                     AccountId=accntObj1.Id,
                                     Email='con12@gf.com',
                                     Department__c='Design;Engineering',//5779
                                     is_portal_user_active__c=false
                                    ); 
        insert conObj;
        Part_Family__c f = new Part_Family__c();
        f.Name = 'test family';
        insert f;
        Part__c p = new Part__c();
        p.Part_Number__c = '0000000001';
        p.Part_Family__c = 'test family';
        p.Part_Type__c = 'FC PBGA';
        insert p;
        Account_Part_Map__c accP = new Account_Part_Map__c();
        accP.Account__c = accntObj1.Id;
        accP.Part__c = p.Id;
        insert accP;
        Part__Share ps = new Part__Share();
        ps.AccessLevel = 'Read';
        ps.ParentId = p.Id;
        ps.UserOrGroupId = UserInfo.getUserId();
        ps.RowCause = Schema.Part__Share.RowCause.Part_Access__c;
        insert ps;
        MDD_LoginController mdd = new MDD_LoginController();
        mdd.getPackage();
        mdd.isModule = true;
        mdd.isWafer = false;
        mdd.PartNumber = '0000000001,0000002';
        mdd.packageType = 'FC PBGA';
        mdd.search();
        user us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        Contact conobj1;
        Account accntObj;
        System.runAs(us){
        Map<String,Object> fieldValueMap1 = New Map<String,Object>();
        fieldValueMap1.put('Name','acc');
        fieldValueMap1.put('Stage__c','Unqualified');
        fieldValueMap1.put('Site_Department__c','Site1');
        fieldValueMap1.put('Sub_Type__c','Direct');
        fieldValueMap1.put('Transaction_Type__c','Transactional');
        fieldValueMap1.put('Region__c','APJ');
        fieldValueMap1.put('Bill_To_Address_1__c','Test Address 1');
        fieldValueMap1.put('Corporate_Address_1__c','Corporate Address 1');
        fieldValueMap1.put('Bill_To_City__c','city1');
        fieldValueMap1.put('Corporate_City__c','city1');
        fieldValueMap1.put('Bill_To_Country__c','Austria');
        fieldValueMap1.put('Corporate_Country__c','Austria');
        fieldValueMap1.put('RecordTypeId',rt.id);
        fieldValueMap1.put('Short_Name__c','acc');
        
        accntObj = AccountDataFactory.createAccount(fieldValueMap1);
            conobj1=new Contact(FirstName='Mr',
                                LastName='Testcon1rr',
                                AccountId=accntObj.Id,
                                Email='con1@gf.com',
                                Department__c='Design;Engineering',
                                is_portal_user_active__c=false
                               ); 
            insert conObj1;
        }
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
        Test.startTest();                                   
        insert portalUser1;
        Account_Part_Map__c accP1 = new Account_Part_Map__c();
        accP1.Account__c = accntObj.Id;
        accP1.Part__c = p.Id;
        insert accP1;
        MDDPartSearchSharing__c m1 = new MDDPartSearchSharing__c();
        m1.Name = 'MDD Application';
        m1.Is_Active__c = false;
        insert m1;
        system.runAs(portalUser1){
            MDD_LoginController m = new MDD_LoginController();
            m.getPackage();
            m.isModule = true;
            m.isWafer = false;
            m.PartNumber = '0000000001,0000002';
            m.packageType = 'FC PBGA';
            m.search();
            m1.Is_Active__c = true;
            update m1;
            m.search();
        }        
        system.assertEquals(m1.Name, 'MDD Application');
        Test.stopTest();
    }
}