@isTest
public class NDAShareOnNonLegalRoleTriggerTest
{
      @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();
                
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT');            
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
            fieldValueMap.put('Fab_9_10__c','no');           
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            AccountDataFactory.createAccount(fieldValueMap);
      }

      public static User setupTestUser()
      {      
                Profile p = [SELECT Id FROM Profile WHERE Name= 'System Administrator' limit 1]; 
                UserRole r= [select id from UserRole where DeveloperName='General_TD_Non_Legal'];
                User u = new User(Alias = 'NDATest', Email='NDATestuser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='NDATestuser', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId=r.id, HCM_Login_ID__c = 'RC3591',
                TimeZoneSidKey='America/Los_Angeles', UserName='NDATest'+'@testorg.com'); 
                
                
                insert u;
                return u;
                
      }
      
       
      public static void setupNDATestData()
      {
        User u = setupTestUser();
         System.runAs(u)
                {
                
       List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>
       {
      new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
      new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
      new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
      new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
        };
        insert ndaSyncSettings;
        
        List<RecordType> accountRecordType   =[select Id, Name from RecordType where SobjectType = 'Account' and DeveloperName= 'Customer'];
        Account testAccount = getAccount('MYTEST ACCOUNT');
            
        List<RecordType> recrdTypes = [select DeveloperName,Id from RecordType where DeveloperName='GENERAL_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c' and isActive=True];
        
        
             
                
               
          
                
          //User u = [SELECT Id FROM User where Alias = 'NDATest' LIMIT 1];
          List<Apttus__APTS_Agreement__c> agrlist=new List<Apttus__APTS_Agreement__c>();  
               
             
            
                Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='NDATESTREC1', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = NULL,
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM',
                OwnerId=Userinfo.getUserId(),
                RecordTypeId=recrdTypes[0].id
                );  
                
            
                
                
                insert nda;
                
            
                }
                
                
           
           
       }
       
       
       public static void setupCLMTestData()
      {
       User u = setupTestUser();
        System.runAs(u)
                {
                
       List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>
       {
      new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
      new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
      new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
      new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
        };
        insert ndaSyncSettings;
        
        List<RecordType> accountRecordType   =[select Id, Name from RecordType where SobjectType = 'Account' and DeveloperName= 'Customer'];
        Account testAccount = getAccount('MYTEST ACCOUNT');
            
        List<RecordType> recrdTypes = [select DeveloperName,Id from RecordType where DeveloperName='Procurement_Agreements' and SobjectType = 'Apttus__APTS_Agreement__c' and isActive=True];
        
        
             
                
               
          
                
          //User u = [SELECT Id FROM User where Alias = 'NDATest' LIMIT 1];
          List<Apttus__APTS_Agreement__c> agrlist=new List<Apttus__APTS_Agreement__c>();  
               
             
            
                Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='CLMTESTREC1', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = NULL,
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM',
                OwnerId=Userinfo.getUserId(),
                RecordTypeId=recrdTypes[0].id
                );  
                
            
                
                
                insert nda;
                
            
                }
                
                
           
           
       }


public static testmethod void TestFunc1()
{

               
    
    setupNDATestData();
        
    Integer countUser=[SELECT count() FROM User where UserRoleId  in (select id from UserRole where DeveloperName='General_TD_Non_Legal') and isActive=True];
    Integer Ndasharecount=[select count() from Apttus__APTS_Agreement__share where ParentId in (select id from Apttus__APTS_Agreement__c where Name='NDATESTREC1') and RowCause ='Share_NDA_records_with_TD_Non_Legal_Role__c'];
       
    
    System.assertEquals(Ndasharecount,countUser-1);
    
    }
    



public static testmethod void TestFunc2()
{

               
    
    setupCLMTestData();
        
    Integer countUser=[SELECT count() FROM User where UserRoleId  in (select id from UserRole where DeveloperName='General_TD_Non_Legal') and isActive=True];
    Integer CLMsharecount=[select count() from Apttus__APTS_Agreement__share where ParentId in (select id from Apttus__APTS_Agreement__c where Name='CLMTESTREC1') and Rowcause ='Share_NDA_records_with_TD_Non_Legal_Role__c'];
    
    
    System.assertEquals(CLMsharecount,countUser-1);
   
    }
    
   private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}