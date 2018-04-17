/*
Type Name: CaseResetOwnershipClsTest
Author: UCM Team
Created Date: 02/28/2018
Reason: This is the Test class for CaseResetOwnershipCls. 
Change History:
Author: 
Modified Date: 
Reason: 
…… ..
……..
*/
@isTest(seeAllData=false)
public class CaseResetOwnershipClsTest {
  @testSetup 
   public static void testdata() {
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
  
  
  //Positive Inputs
  static testMethod void resetCaseOwnershipMethod() {          
    Test.startTest();
        
          
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'sUcm1', Email = 'testUCM9@testsOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestsUcm1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testsUCMUser9@testsorg.com');
        insert usr;
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Internal_or_external__c = true,
            //AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Close_Requested_Date__c = System.now(),
            Status = 'New',
            Date_Time_Verified__c = System.now(),
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
        );
        
        System.runAs (usr) {
            insert caseObj;
            
            caseObj.Status = 'In Progress'; 
            update caseObj;
        }
         
                 
        PageReference pageRef3 = Page.CaseResetOwnershipPage;
        Test.setCurrentPage(pageRef3);
        apexpages.currentpage().getparameters().put('Id', caseObj.id);                
        CaseResetOwnershipCls controller3 = new CaseResetOwnershipCls(new ApexPages.StandardController(caseObj));
        controller3.resetCaseOwnership();
        
        PageReference pageRef4 = Page.CaseClosedVerfiedPage;
        Test.setCurrentPage(pageRef4);
        apexpages.currentpage().getparameters().put('Id', caseObj.id);                
        CaseResetOwnershipCls controller = new CaseResetOwnershipCls(new ApexPages.StandardController(caseObj));
        controller.closedVerified();
                
        system.assertEquals('In Progress',caseObj.status);  
        
        Test.stopTest();
  }
  
  static testMethod void closedVerifiedMethod() {
        Test.startTest();
                  
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'sUcm11', Email = 'testUCM91@testsOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestsUcm11', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testsUCMUser91@testsorg.com');
        insert usr;
        
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc1',
            Subject = 'Test Sub1',
            Target_process_node__c = '110G',
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Internal_or_external__c = true,
            //AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Close_Requested_Date__c = System.now(),
            Status = 'New',
            CreatedById =UserInfo.getUserId(),
            Date_Time_Verified__c = System.now(),
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
        );
        
        System.runAs (usr) {
            insert caseObj;
            
            caseObj.Status = 'Closed - Resolved'; 
            update caseObj;
        }
        PageReference pageRef4 = Page.CaseClosedVerfiedPage;
        Test.setCurrentPage(pageRef4);
        apexpages.currentpage().getparameters().put('Id', caseObj.id);                
        CaseResetOwnershipCls controller = new CaseResetOwnershipCls(new ApexPages.StandardController(caseObj));
        controller.closedVerified();
        
        system.assertEquals('Closed - Resolved',caseObj.status);  
        
        Test.stopTest();
  }
     
}