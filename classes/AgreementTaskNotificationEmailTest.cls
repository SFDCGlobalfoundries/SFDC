@isTest
public class AgreementTaskNotificationEmailTest
{

     @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();   
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'MyTestACC1');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');  
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
        AccountDataFactory.createAccount(fieldValueMap);                   
    }
    
    @future
    public static void createTestTemplate()
    {
    
                    
        EmailTemplate e = new EmailTemplate (DeveloperName='TestTemplate',TemplateType= 'Text', FolderId = UserInfo.getUserId(), Name = EnvironmentVariable.get('MAIL_TEMPLATE_ON_AGREEMENT_TASK') ,isActive =True); 
        insert e;
        }
        

    public static testmethod void AgreementTaskNotificationEmailTester()
    {
        //insert new Environment_Variable__c(Name='APTS_AGREEMENT__C_OBJECT',Value__c= 'Apttus__APTS_Agreement__c');
        
        //insert new Environment_Variable__c(Name='MAIL_TEMPLATE_ON_AGREEMENT_TASK',Value__c= 'Agreement TASK Reminder Notice Template');
        
        
        // Creating test owner of task
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'CLMTest', Email='CLMTestUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='CLMTestingUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='CLMTestUser@testorg.com');

        insert u;
        
        System.runAs(u)
        {
        
        Account acc = getAccount('MYTEST ACCOUNT1');
        
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
        
        test.startTest();
        
        createTestTemplate();
        
        Task t=new Task(OwnerId=u.Id,Subject='Test Subject from Test Method',Description='Test Description. Recipients=\'abc@testmail.com\'',CLM_Email_Addresses__c='abc@xyz.com,xyz@gmail.edu.com',ActivityDate=Date.today(),WhatId=agr.id,Status='Not Started',Priority='Normal',ReminderDateTime=DateTime.Now().addDays(1));
        insert t;
        Map<Id,Task> testmap=new Map<Id,Task>();
        testmap.put(t.id,t);
        AgreementTaskNotificationEmail.AgreementAssigneeIdMapProcessor(testmap);
        List<Task> tlist=[select id from Task where Subject like '%Test Subject from Test Method%' and whatid =: agr.id and Status='Completed' and Priority='Low'];
        
        test.StopTest();
        
        System.assertEquals(1,tlist.size());
        }
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
}