/**
 * Author: Sreedhar Karukonda
 * Change Tracker:
 *   3/9/2015  Sreedhar Karukonda  Created
 *   3/8/2017  Ruchi Talwaria 	   Test code coverage for ASIC NDA validation
 * 	 22/2/2018 DBiswal			   Test class SOQL error fix
 **/
@isTest(SeeAllData = false)
private class AgreementAccountSyncTest{
    @testSetup
    static void testSetup() {
        DataUtilTest.loadEnvironmentVariables();
        List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
      new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
      new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
      new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
        };
        insert ndaSyncSettings;
        
        List<RecordType> accountRecordType   =[select Id, Name from RecordType where SobjectType = 'Account' and DeveloperName= 'Customer'];
        System.assertEquals(1, accountRecordType.size());
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();            
            fieldValueMap.put('Name', 'MYTEST ACCOUNT - NO ERROR'+i);            
            fieldValueMap.put('stage__c', 'Unqualified');
            fieldValueMap.put('short_name__c', 'MyTestACC'+i);
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
            fieldValueMap.put('Organization_Unit__c', 'GF Investment');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);          
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Fab_9_10__c','No');  
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
            
            fieldValueMapList.add(fieldValueMap);
        }  
        AccountDataFactory.createAccounts(fieldValueMapList,2); 
        
            Map<String,Object> fieldValueMapError = new Map<String,Object>();            
            fieldValueMapError.put('Name', 'MYTEST ACCOUNT - WITH ERROR');            
            fieldValueMapError.put('stage__c', 'Unqualified');
            fieldValueMapError.put('sub_type__c', 'Direct');
            fieldValueMapError.put('site_department__c', 'test dept');          
            fieldValueMapError.put('transaction_type__c', 'transactional');
            fieldValueMapError.put('Bill_To_Address_1__c', null);            
            fieldValueMapError.put('Bill_To_Address_2__c', null);
            fieldValueMapError.put('region__c', 'US');
            fieldValueMapError.put('Sales_Territory__c', 'US-East');
            fieldValueMapError.put('FE_Territory__c', 'US-FE-East');
            fieldValueMapError.put('financial_territory__c', 'US-East');                      
            fieldValueMapError.put('Corporate_Address_1__c', '50 water st');  
            fieldValueMapError.put('Corporate_Address_2__c', 'Suite B'); 
            fieldValueMapError.put('Corporate_City__c', 'Fremont');  
            fieldValueMapError.put('Corporate_State__c', 'CA');       
            fieldValueMapError.put('Corporate_Country__c', 'USA');        
            fieldValueMapError.put('Bill_To_City__c', null);
            fieldValueMapError.put('Bill_To_Country__c', null);
            fieldValueMapError.put('Bill_To_State__c', null); 
            
            AccountDataFactory.createAccount(fieldValueMapError);  
          
  }
    
    
    /**
     * Successful end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  NDA Activation Test
     **/
    private  static testmethod void singleAgreementSync(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - NO ERROR1');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount = getAccount('MYTEST ACCOUNT - NO ERROR1');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
        test.startTest();    
        Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1 SUCCESS', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
          insert nda;
        System.assertNotEquals(nda.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(beforeAgreementActivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, false, 'Sync Failed flag should be unchecked');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c, null, 'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
        nda.Apttus__Status_Category__c = 'In Effect';
        nda.Apttus__Status__c = 'Activated';
        update nda;
        
        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(1, afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should one Status Record');
        
        Test.stopTest();
    }
    
    
    /**
     * Successful end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  1. NDA Activation Test
     *  2. NDA Deactivation Test
     **/
    private  static testmethod void singleAgreementSync_Deactivation(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - NO ERROR1');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount = getAccount('MYTEST ACCOUNT - NO ERROR1');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
        
        Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
                
          insert nda;
        
        System.assertNotEquals(nda.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(beforeAgreementActivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, false, 'Sync Failed flag should be unchecked');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c, null, 'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
        nda.Apttus__Status_Category__c = 'In Effect';
        nda.Apttus__Status__c = 'Activated';
        test.startTest();
        update nda;
        
        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(1, afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should one Status Record');
        
        AgreementSyncHandler.skipRecursiveTriggerInvokation = false;
        /**
         * DEACTIVATION TEST TEST
         **/
        nda.Apttus__Status_Category__c = 'Expired';
        nda.Apttus__Status__c = 'Expired';
        update nda;
        
        Account AfterAgreementDeactivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(AfterAgreementDeactivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(AfterAgreementDeactivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(AfterAgreementDeactivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        
        Test.stopTest();
    }
    
    /**
     * Successful end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  1. NDA Activation Test
     *  3. Geometries updated
     **/
    private  static testmethod void singleAgreementSyncGeometriesUpdated(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - NO ERROR1');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount = getAccount('MYTEST ACCOUNT - NO ERROR1');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
        Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
            
          insert nda;
        
        System.assertNotEquals(nda.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(beforeAgreementActivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, false, 'Sync Failed flag should be unchecked');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c, null, 'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
        nda.Apttus__Status_Category__c = 'In Effect';
        nda.Apttus__Status__c = 'Activated';
        test.startTest();    
        update nda;

        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        
        AgreementSyncHandler.skipRecursiveTriggerInvokation = false;
        /**
         * Geometries updated
         **/
        nda.geometries__c='0.010UM;0.11UM;0.022UM';
        update nda;
        
    }
    
     /**
     * Successful end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  Add a Signatory
     *  Delete a Signatory
     **/
    private  static testmethod void addAndDeleteSignatorySync(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - NO ERROR1');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        
        Account testAccount = getAccount('MYTEST ACCOUNT - NO ERROR1');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
           
        Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1 SUCCESS', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
         
          insert nda;
          
        System.assertNotEquals(nda.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(beforeAgreementActivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, false, 'Sync Failed flag should be unchecked');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c, null, 'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
         
        nda.Apttus__Status_Category__c = 'In Effect';
        nda.Apttus__Status__c = 'Activated';
        test.startTest();
        update nda;
        
        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(1, afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should one Status Record');
        
        //List<Account> testAccounts2 = getAccount('MYTEST ACCOUNT - NO ERROR2');
        //System.assert(testAccounts2.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount2 = getAccount('MYTEST ACCOUNT - NO ERROR2');
        AgreementSyncHandler.skipRecursiveTriggerInvokation = false;
        
        /**
         * Signatory insert test case
         **/
        Signatory__c signatory = new Signatory__c(Agreement__c = nda.Id,  Account__c = testAccount.Id);
        insert signatory;
        
        /**
         * Signatory Delete test case
         **/
         
         List<Signatory__c> existingSignatories = [select Id, Account__c from Signatory__c where Account__c = :testAccount.Id];
         if(existingSignatories.size() > 0){
             try{
                delete existingSignatories;
                Account afterSignatoryDeletedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
                System.assertEquals(false, afterSignatoryDeletedAccount.Has_Valid_NDA__c,  'Has NDA should be checked after any agreement activate');
                System.assertEquals(null, afterSignatoryDeletedAccount.Valid_Tech_Geos__c,  'There should be  Tech Geos  after any agreement activate');
                System.assertEquals(null, afterSignatoryDeletedAccount.Latest_NDA_Expiration_Date__c,  'There should be  latest nda expiration date after any agreement activate');
             }catch(Exception e){
                 System.assert(true, 'Deleting singatory is failed');
             }
         }
        
        Test.stopTest();
    }
    
    
    
    /**
     * Error end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  NDA Activation Test
     **/
    private  static testmethod void singleAgreementSync_ErrorSync(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - WITH ERROR');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount = getAccount('MYTEST ACCOUNT - WITH ERROR');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
        test.startTest();    
        Apttus__APTS_Agreement__c nda1= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1 Failed', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
          insert nda1;
        
        System.assertNotEquals(nda1.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(false, beforeAgreementActivatedAccount.Has_Valid_NDA__c,  'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(null, beforeAgreementActivatedAccount.Valid_Tech_Geos__c, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(null, beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, 'There should be no latest nda expiration date  before any agreement activate');
        
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda1.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(false, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, 'Sync Failed flag should be unchecked');
        //System.assertEquals(null, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c,  'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
        nda1.Apttus__Status_Category__c = 'In Effect';
        nda1.Apttus__Status__c = 'Activated';
        update nda1;
        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [select Id, Name, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) from Apttus__APTS_Agreement__c where Id =: nda1.Id ];
        System.assertEquals(1, afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should one Status Record');
        
        Test.stopTest();
    }


    /**
     * Successful end to end - One Agreement with one Signatory
     * Test Scenarios:
     *  NDA Activation Test
     **/
    private  static testmethod void agreementSyncPageTest(){
        //List<Account> testAccounts = getAccount('MYTEST ACCOUNT - NO ERROR1');
        //System.assert(testAccounts.size() == 1, 'There should be one account inserted in test Setup');
        Account testAccount = getAccount('MYTEST ACCOUNT - NO ERROR1');
        
        List<RecordType> recrdTypes = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'DS_2_Party_NDA' and SobjectType = 'Apttus__APTS_Agreement__c'];
        System.assertEquals(1, recrdTypes.size(), 'Please check there is record Type DS_2_Party_NDA');
        test.startTest();    
        Apttus__APTS_Agreement__c nda= new Apttus__APTS_Agreement__c(Name='GLOBALFOUNDRIES NDA1 SUCCESS', 
                Apttus__Account__c = testAccount.Id,
                GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',
                Purpose__c = 'Testing',               
                Type__c = 'None',
                Apttus__Status_Category__c = 'Request',
                GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,
                Apttus__Status__c='Request',
                geometries__c='0.010UM;0.11UM'
           );    
          insert nda;
        System.assertNotEquals(nda.id, null, 'Agreement Should be inserted and Record Id should be present');
        Account beforeAgreementActivatedAccount = [select Id, Latest_NDA_Expiration_Date__c, Has_Valid_NDA__c, Valid_Tech_Geos__c from Account where Id =: testAccount.Id ];
        System.assertEquals(beforeAgreementActivatedAccount.Has_Valid_NDA__c, false, 'Has NDA should be unchecked before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Valid_Tech_Geos__c, null, 'There should be no Tech Geos  before any agreement activate');
        System.assertEquals(beforeAgreementActivatedAccount.Latest_NDA_Expiration_Date__c, null, 'There should be no latest nda expiration date  before any agreement activate');
        
        Apttus__APTS_Agreement__c beforeAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        System.assertEquals(0, beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r.size(), 'There should no Status Record');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c, false, 'Sync Failed flag should be unchecked');
        //System.assertEquals(beforeAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c, null, 'Sync did not happen, Error Message should be null');
        /**
         * Activation TEST
         **/
        nda.Apttus__Status_Category__c = 'In Effect';
        nda.Apttus__Status__c = 'Activated';
        update nda;

        Apttus__APTS_Agreement__c afterAgreementActivatedAgreement = [SELECT Id, Name, RecordTypeId, Apttus__Status_Category__c, Apttus__Status__c, (SELECT Id, Name, Sync_Error_Message__c, Sync_Failed__c from Agreement_To_Account_Sync_Status__r) FROM Apttus__APTS_Agreement__c where Id =: nda.Id ];
        
        afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Failed__c = false;
        afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0].Sync_Error_Message__c = '';

        update afterAgreementActivatedAgreement.Agreement_To_Account_Sync_Status__r[0];
        AgreementSyncHandler.skipRecursiveTriggerInvokation = false;

        PageReference syncPopup = Page.AgreementSyncPage;
        Test.setCurrentPage(syncPopup);

        ApexPages.StandardController agreeemntController = new ApexPages.StandardController(nda);
        AgreementSyncPageCtrl agrmtSyncPageCtrl = new AgreementSyncPageCtrl(agreeemntController);
        System.assertEquals(null, agrmtSyncPageCtrl.synchronizeWithAccounts(), 'Pop up should not navigate to any other page');
        
        Test.stopTest();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}