@isTest
public class CLMAgreementTaskNotificationBatchTest
{   
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
    
    public static testMethod void CLMAgreementTaskNotificationBatchTestmethod()
    {
        
        
        
        
        // Creating test owner of task
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'CLMTest', Email='CLMTestUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='CLMTestingUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='CLMTestUser@testorg.com');

        insert u;
        
       Account acc= getAccount('MYTEST ACCOUNT1');
        
        
        Contact con = new Contact(
                firstName = 'test1', 
                lastName = 'test1',
                accountId = acc.id,
                email='contacttest@abc.com');
                
                insert con;
                
                
        
        RecordType rt = [Select ID, Name ,DeveloperName From RecordType Where sObjectType = 'Apttus__APTS_Agreement__c' and DeveloperName ='Procurement_Agreements' limit 1];  
           
           
           
        List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'suvajit.majumder@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'Procurement_Agreements')
                };
          
          insert ndaSyncSettings;    
 
        //Creating test agreement
         
          
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
        agr.Name='Test Agreement';
        agr.RecordTypeId =rt.Id;
        agr.CLM_Contract_Description__c='Test';
        agr.Apttus__Account__c=acc.id;
        agr.CLM_Evergreen__c='Yes';
        agr.GF_Contract_Start_Date__c=Date.today();
        
        insert agr;
        

        Task t=new Task(OwnerId=u.Id,Subject='Test Subject',ActivityDate=Date.today(),WhatId=agr.id,Status='Not Started',Priority='Low',IsReminderSet=True,ReminderDateTime=DateTime.Now().addDays(1));
        insert t;
        test.startTest();  

        //initiating an instance of the batch job   
        
        Database.executeBatch(new CLMAgreementTaskNotificationBatch(),100);
        test.stopTest();  
        
        }
        
        
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
  }