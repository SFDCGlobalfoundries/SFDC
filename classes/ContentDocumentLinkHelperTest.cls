/*
Type Name: ContentDocumentLinkHelperTest 
Author: Dinesh Suggala(Global Foundries)
Created Date: 28-February-2018
Reason: This class is to cover the Class "ContentDocumentLinkHelper"
Author: 
Modified Date: 
Reason: 
……..
……..
*/

@isTest
public Class ContentDocumentLinkHelperTest{

 @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    private static testmethod void PreventCheckboxforfile(){
           
            RecordType recType=[Select Id from RecordType where DeveloperName='GLOBALFOUNDRIES_with_Multi_Party'];
           
            Account acctObj = getAccount('MYTEST ACCOUNT1');
            Contact conobj=new Contact();
            Restricted_Team_Room__c teamRoomObj = new Restricted_Team_Room__c(); 
            teamRoomObj.Name ='Team Room 1';
            teamRoomObj.R_Team_Room_Description__c = 'Team Room Description';
            teamRoomObj.RecordTypeId=recType.Id;
            teamRoomObj.R_Primary_Account__c=acctObj.id;
            
            insert teamRoomObj; 
            system.assert(teamRoomObj.id!=null);
           
           
            Folder__c folder=new Folder__c();
            folder.Name='Test';
            folder.Restricted_Team_Room__c=teamRoomObj.Id;

            insert folder;
                        
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

            ContentVersion cv = new ContentVersion();
            cv.title = 'test content trigger';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;         

            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=folder.Id;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;

            insert contentlink;
    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}