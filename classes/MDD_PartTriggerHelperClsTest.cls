/* 
 Type Name: MDD_PartTriggerHelperClsTest
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: Test Class for MDD_PartTriggerHelperCls
 
 */
@isTest
public class MDD_PartTriggerHelperClsTest {
    public static TestMethod void MDD_PartTriggerHelperClsTestMethod(){
        DataUtilTest.loadEnvironmentVariables();
        RecordType rt = [SELECT  Id FROM RecordType WHERE SObjectType = 'Account'  AND Name = 'Customer'];
        
        user us = [Select ID from User where IsActive = true and UserRoleId != null and ContactId = null LIMIT 1];
        Account accntObj;
        Contact conobj1;
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
                                Department__c='Design;Engineering',//5779
                                is_portal_user_active__c=false
                               ); 
            insert conObj1;
        }
        
        test.startTest();
        MDD_ERP_Update__c md = MDD_ERP_Update__c.getInstance('ERP Updates');
        if(md == null){
        	MDD_ERP_Update__c mdERP = new MDD_ERP_Update__c();
            mdERP.Name = 'ERP Updates';
            mdERP.Is_Active__c = true;
            insert mdERP;
        }
        
        Part__c p1 = new Part__c();
        p1.Family_Weight__c = 5.5;
        p1.Part_Family__c = 'test family';
        insert p1;
        Part_Family__c f = new Part_Family__c();
        f.Name = 'test family';
        insert f;
        Account_Part_Map__c accP = new Account_Part_Map__c();
        accP.Account__c = accntObj.Id;
        accP.Part__c = p1.Id;
        insert accP;
        Part_Family__c f1 = new Part_Family__c();
        f1.Name = 'test family1';
        insert f1;
        p1.Part_Family__c = 'test family1';
        update p1;
        test.stopTest();
    }
}