/*
Type Name: WRVisualforceControllerTest
Author: UCM Team
Created Date: 11-29-2015
Reason: This is the Test class for Controller WRCreateController 
Change History:
Author:  
Modified  Date: 
Reason: 
……..
……..
*/

@isTest(SeeAllData = false)
private class WRVisualforceControllerTest{

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'Test Account 117');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'Test007');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'Greater China');
        fieldValueMap.put('financial_territory__c', 'Greater China');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');
        fieldValueMap.put('Corporate_Address_2__c', 'Test Address 2');
        fieldValueMap.put('Corporate_Address_3__c', 'Test Address 3');
        fieldValueMap.put('Corporate_Address_4__c', 'Test Address 4');            
        fieldValueMap.put('Corporate_Country__c', 'Test Country');
        fieldValueMap.put('Corporate_City__c', 'Test City');
        fieldValueMap.put('Corporate_State__c', 'Test State');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
        fieldValueMap.put('bill_to_location__c', 'test');
        fieldValueMap.put('total_employee__c', 7);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'Low Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address');
        fieldValueMap.put('Account_Profile__c','Fabless - Emerging');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','India');
        AccountDataFactory.createAccount(fieldValueMap);
    }

    public static testMethod void testCreatePdkRequest() {
        
                
        list < BugErrorMessages__c> bugerrorlist = new list < BugErrorMessages__c> ();
        BugErrorMessages__c berror1 = new BugErrorMessages__c ();
        berror1 .name = 'BugResolutionValidation';
        berror1 .Error_Message__c= 'The Resolution field have to be populated for closed, verified and resolved status';
        BugErrorMessages__c berror2 = new BugErrorMessages__c ();
        berror2.name = 'BugDuplicateValidation';
        berror2.Error_Message__c= 'Duplicate Bug field should be populated for the resolution "Duplicate"';
        BugErrorMessages__c berror3 = new BugErrorMessages__c ();
        berror3 .name = 'BugDupeBlockerValidation';
        berror3 .Error_Message__c= 'DupeBlocker Duplicate Prevention';
        bugerrorlist.add(berror1);
        bugerrorlist.add(berror2);
        bugerrorlist.add(berror3);
        insert bugerrorlist;  
        
         Account acc = getAccount('Test Account 117');
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = new User(Alias = 'stdUcm1', Email = 'testUCM1@testOrg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'TestUcm1', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', Username = 'testUCMUser1@testorg.com');
        insert usr;
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421;
        insert objPDK;
        
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Technical).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Master_PDK__c = objPDK.Id,
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = true,
            AccountId = acc.Id,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypeTechnicalId
            
        );
        test.starttest();
        
        insert caseObj;
        
        String newId = caseObj.Id;
        
        Id recordTypePdkReqId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.PDKRequestRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Request_Type__c = 'Yes',
            Geometry__c = '0.11UM',
            Need_By_Date__c = Date.Today().addDays(5),
            Master_PDK__c = objPDK.Id, 
            Target_Process_Node__c = '110G',
            Proposed_Technology_Name__c = '10opp',
            Opportunity__c = opp.Id,
            Component__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypePdkReqId
        );
        insert bugObj;
        
        CaseTeamRole caseTMRoleObj = [Select Name from CaseTeamRole where Name='Case Manager (Internal)'];
    
    CaseTeamMember caseTMObj = new CaseTeamMember();
    caseTMObj.MemberId = usr.Id;
    caseTMObj.ParentId = caseObj.Id;
    caseTMObj.TeamRoleId = caseTMRoleObj.Id;
    insert caseTMObj;
    
    CC_List__c ccTeamObj=new CC_List__c();
        ccTeamObj.Bug_Work_Request__c = bugObj.Id;
        ccTeamObj.Roles_Responsibility__c = 'Subscription Only';
        ccTeamObj.Access__c = 'Read/Write';
        ccTeamObj.User__c = usr.Id;
        insert ccTeamObj;
    
        Related_Accounts__c relatedAccObj = new Related_Accounts__c(
            Bug_Work_Request__c = bugObj.Id,
            Account__c = acc.Id
        );
        insert relatedAccObj;
        
        PDK_Component__c pdkComponentObj = new PDK_Component__c(
            Product_Technology__c = '110G',
            Component__c = 'DFM',
            Bug_Work_Request__c = bugObj.Id
        );
        insert pdkComponentObj;
        
        Metal_Stacks__c metalStackObj = new Metal_Stacks__c(
            Metal_Option_Type__c = 'NA',
            Metal__c = 'Testing Metal Stack',
            Bug_Work_Request__c = bugObj.Id
        );
        insert metalStackObj;
                
        FeedItem bugFeed = new FeedItem();
        bugFeed.ParentId = bugObj.Id;
        bugFeed.body = 'Created from Case - Case '+caseObj.CaseNumber;
        insert bugFeed;
                
        PageReference pageRef = new PageReference('/apex/WRCreate?rid=' + recordTypePdkReqId + '&cid=' + caseObj.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(bugObj);
        WRCreateController WRCreateControllerVar = new WRCreateController(controller);
        WRCreateControllerVar.getBugPickVal();
        WRCreateControllerVar.getCompPickVal();
        WRCreateControllerVar.savebug();
        WRCreateControllerVar.cancelBug(); 
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = '';
        WRCreateControllerVar.savebug();
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = 'Test Sub';
        WRCreateControllerVar.bugVar.Bug_Description__c = null;
        WRCreateControllerVar.savebug();        
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = 'Test Sub';
        WRCreateControllerVar.bugVar.Bug_Description__c = 'test Desc';
        WRCreateControllerVar.bugVar.Request_Type__c = null;
        WRCreateControllerVar.savebug();
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = 'Test Sub';
        WRCreateControllerVar.bugVar.Bug_Description__c = 'test Desc';
        WRCreateControllerVar.bugVar.Request_Type__c = 'Yes';
        WRCreateControllerVar.bugVar.Geometry__c = null;
        WRCreateControllerVar.savebug(); 
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = 'Test Sub';
        WRCreateControllerVar.bugVar.Bug_Description__c = 'test Desc';
        WRCreateControllerVar.bugVar.Request_Type__c = 'Yes';
        WRCreateControllerVar.bugVar.Geometry__c = '0.11UM';
        WRCreateControllerVar.bugVar.Target_Process_Node__c = null;
        WRCreateControllerVar.savebug(); 
        
        //Run catch block
        WRCreateControllerVar.bugVar.Bug_Title__c = 'Test Sub';
        WRCreateControllerVar.bugVar.Bug_Description__c = 'test Desc';
        WRCreateControllerVar.bugVar.Request_Type__c = 'Yes';
        WRCreateControllerVar.bugVar.Geometry__c = '0.11UM';
        WRCreateControllerVar.bugVar.Target_Process_Node__c = '110G';
        WRCreateControllerVar.bugVar.Need_By_Date__c  = null;
        WRCreateControllerVar.savebug();     
        
        test.stoptest();
    }
    public static testMethod void testNegativePdkRequest() {
        test.starttest();
        
                
        Account acc = getAccount('Test Account 117');
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',acc.Id);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',date.newinstance(2012, 12, 21));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Mobility');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Super Low Power');
        fieldValueMap.put('Fab_Assignment_1__c','FAB 1');
        
        Opportunity opp = OpportunityDataFactory.createOpportunity(fieldValueMap);                
                
        Id recordTypeTechnicalId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Case_Recordtype_Internal_Case).getRecordTypeId();
         
        Case caseObj = new Case (
            Description = 'Test Desc',
            Subject = 'Test Sub',
            Target_process_node__c = '110G',
            Geometry__c = '0.11UM',
            Need_by_Date__c = Date.Today().addDays(5),
            Process_Variant__c = '10opp',
            Opportunity__c = opp.Id,
            Internal_or_external__c = false,
            Subcategory__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            AccountId = acc.Id,
            RecordTypeId = recordTypeTechnicalId
            
        );
        insert caseObj;
        
        String newId = caseObj.Id;
        
        Id recordTypePdkReqId = Schema.SObjectType.Bug__c.getRecordTypeInfosByName().get(System.Label.PDKRequestRecordTypeName).getRecordTypeId();
        
        Bug__c bugObj = new Bug__c (
            Bug_Title__c = 'Test Sub',
            Bug_Description__c = 'Test Desc',
            Request_Type__c = 'Yes',
            Geometry__c = '0.11UM',
            Need_By_Date__c = Date.Today().addDays(5),
            Target_Process_Node__c = '110G',
            Proposed_Technology_Name__c = '10opp',
            Opportunity__c = opp.Id,
            Component__c = 'DFM',
            Metal_Stack__c = 'Testing Metal Stack',
            RecordTypeId = recordTypePdkReqId
        );
        insert bugObj;            
        
        Metal_Stacks__c metalStackObj = new Metal_Stacks__c(
            Metal_Option_Type__c = 'NA',
            Metal__c = 'Testing Metal Stack',
            Bug_Work_Request__c = bugObj.Id
        );
        insert metalStackObj;
        
        Related_Accounts__c relatedAccObj = new Related_Accounts__c(
            Bug_Work_Request__c = bugObj.Id,
            Account__c = acc.Id
        );
        insert relatedAccObj;
                
        FeedItem bugFeed = new FeedItem();
        bugFeed.ParentId = bugObj.Id;
        bugFeed.body = 'Created from Case - Case '+caseObj.CaseNumber;
        insert bugFeed;
                
        PageReference pageRef = new PageReference('/apex/WRCreate?rid=' + recordTypePdkReqId + '&cid=' + caseObj.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(bugObj);
        WRCreateController WRCreateControllerVar = new WRCreateController(controller);
        WRCreateControllerVar.getBugPickVal();
        WRCreateControllerVar.getCompPickVal();
        WRCreateControllerVar.savebug();
        WRCreateControllerVar.cancelBug(); 
        
        test.stoptest();
    }
    
    private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acc = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acc;
    }
}