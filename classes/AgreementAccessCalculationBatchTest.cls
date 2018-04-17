@isTest
public class AgreementAccessCalculationBatchTest
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
            
        AccountDataFactory.createAccount(fieldValueMap);
    }    
    
    public static testMethod void AgreementAccessCalculationBatchTestMethod()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        UserRole r= [SELECT Id FROM UserRole WHERE DeveloperName='General_TD_Non_Legal'];
        
        
        User u = new User(Alias = 'CLMTest', Email='CLMTestUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='CLMTestingUser', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=r.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='CLMTestUser@testorg.com');
                
        System.runAs(u)
        {  
            Account acc = getAccount('MYTEST ACCOUNT1');
        
            Contact con = new Contact(
                firstName = 'test1', 
                lastName = 'test1',
                accountId = acc.id,
                email='contacttest@abc.com');
                
                insert con;
                
         
         RecordType rt = [Select ID, Name ,DeveloperName From RecordType Where sObjectType = 'Apttus__APTS_Agreement__c' and DeveloperName ='GENERAL_2_Party_NDA' limit 1];  
           
           
           
        List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'suvajit.majumder@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'GENERAL_2_Party_NDA')
                };
          
          test.startTest();  
          insert ndaSyncSettings; 
          
                 
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
        agr.Name='Test Agreement';
        agr.RecordTypeId =rt.Id;
        agr.CLM_Contract_Description__c='Test';
        agr.Apttus__Account__c=acc.id;
        agr.CLM_Evergreen__c='Yes';
        agr.GF_Contract_Start_Date__c=Date.today();
        agr.OwnerId=u.id;
        insert agr;
        

       

        //initiating an instance of the batch job   
        
        Database.executeBatch(new AgreementAccessCalculationBatch(),100);
        test.stopTest();  
        
        }
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id FROM Account Where Name =: AccountName];
        
        return acct;
    }
}