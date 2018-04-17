/*
    Author:
    Description:
    History:
        Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/

@isTest(SeeAllData = false)
private class AgreementToSignatoryTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();        
    }
    
    static List<Account> createAccount(){
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();            
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            
            fieldValueMapList.add(fieldValueMap);   
            
        }
        return AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    static testmethod void AgreementAccountInsertTest(){        
        
        test.startTest();
           // this is the puprose of the Agreement and Account Sync process 
           List<GFV_NDA_Account_Sync_Settings__c> ndaSyncSettings = new List<GFV_NDA_Account_Sync_Settings__c>{
            new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailsTo', value__c = 'sreedhar.karukonda@globalfoundries.com\nwinhwang.lim@globalfoundries.com'),
              new GFV_NDA_Account_Sync_Settings__c(Name='ndaSyncApplicableTo', value__c = 'In Effect->Activated\nIn Effect->Being Amended'),
              new GFV_NDA_Account_Sync_Settings__c(Name='errorEmailSubject', value__c = '[IMPORTANT] NDA sync to accounts failed.'),
              new GFV_NDA_Account_Sync_Settings__c(Name='syncApplicableRecordTypes', value__c = 'DS_2_Party_NDA\nDS_Multi_Party_NDA\nDS_Other_Party_NDA\nLegacy_NDA\nMulti_Party_NDA\nOther_Party_NDA\nGLOBALFOUNDRIES_NDA')
                };
          
          insert ndaSyncSettings;
            
          List<Account> acctsList = createAccount();                         
                
            System.assertEquals('MYTEST ACCOUNT1', acctsList[0].name);
            System.assertEquals('MYTEST ACCOUNT2', acctsList[1].name);
           
            //insert the different contacts for every account  
            List<Contact> MyconList = new List<Contact>();
            Contact Mycon1 = new Contact(
                firstName = 'test1', lastName = 'test1',accountId = acctsList[0].id);
             MyconList.add(Mycon1);
            Contact Mycon2 = new Contact(
                firstName = 'test2', lastName = 'test2',accountId = acctsList[1].id);
            MyconList.add(Mycon2);
               insert MyconList;
                             
            System.assertEquals('test1', MyconList[0].firstName );  
            System.assertEquals('test1', MyconList[0].lastName ); 
            System.assertEquals('test2', MyconList[1].firstName );  
            System.assertEquals('test2', MyconList[1].lastName ); 
           
           //insert the user with  GF Biz Ops Alliances prfile 
           List < User > UserList = new List < User > ();
            Profile p1 = [Select Id from Profile where name = 'System Administrator'];              
           User u = new User(ProfileId = p1.Id, Username = 'ndauser1' + System.now().format('MMddyyyyHHmmss') + '@testnda.com',                          
                      Alias = 'nuser', Email = 'ndauser@test.com', EmailEncodingKey = 'UTF-8', Firstname = 'nda',                          
                      Lastname = 'user', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago');              
                      insert u;
                      
            Map <String,Schema.RecordTypeInfo> recordTypecustNDA = Apttus__APTS_Agreement__c.sObjectType.getDescribe().getRecordTypeInfosByName();
            Id RecTypeIdNDA = recordTypecustNDA.get(Label.NDA_Multi_Party_Record_Type).getRecordTypeId();           
            test.stopTest();          
           
           //Multi party agreement need to be inserted  
            Apttus__APTS_Agreement__c myarmnt= new Apttus__APTS_Agreement__c(Name='MyGLOBALFOUNDRIES NDA1', 
                RecordTypeId = RecTypeIdNDA,Apttus__Account__c = acctsList[0].Id,Apttus__Primary_Contact__c = MyconList[0].Id,GF_Department_Name__c = 'Sales', 
                Region__c = 'US East',Purpose__c = 'Testing',Type__c = 'none',Apttus__Status_Category__c = 'Request',GF_Contract_Start_Date__c = date.today(),
                GF_Contract_End_Date__c = date.today()+ 10,Apttus__Status__c='Request',How_many_Other_Parties_for_the_NDA__c = '2',               
                Account_2__c = acctsList[1].Id,Contact_2__c = MyconList[1].Id,Account_3__c = acctsList[1].Id,Contact_3__c = MyconList[1].Id,Account_4__c = acctsList[1].Id,Contact_4__c = MyconList[1].Id);
                
                System.runAs(u) { 
                insert myarmnt;
                
                //update the agreement with different status category 
                myarmnt.Apttus__Status_Category__c = 'In Authoring';
                update myarmnt; }            
                     
                System.assertEquals('MyGLOBALFOUNDRIES NDA1', myarmnt.name);
                System.assertEquals('2',myarmnt.How_many_Other_Parties_for_the_NDA__c);
              
    }
   

  }