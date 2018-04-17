/*
*@ Author    :- Sunita Char
*@ Company    :- Cognizant technology
*@ Date      :- 30/1/2015
*@ Description  :- #CR : 31836 - Test class for the class FV_FetchAllATPBatchCls
*@ History    :- 
*/
@isTest(SeeAllData=false)
private class FV_FetchAllATPBatchTest
{
  @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('Account_Present_In_OT__c', true);        
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
        AccountDataFactory.createAccounts(fieldValueMapList,2);
  }
  static testMethod void testAccTeamProxyBatch()
  {
    
    List<Account_Team_Proxy__c> listFetched= new List<Account_Team_Proxy__c>(); 
        
        listFetched.addall(getATPRecords());
        
        insert listFetched;
        
        FV_FetchAllATPBatchCls atpBatch = new FV_FetchAllATPBatchCls ();
        Test.startTest();
        Database.executeBatch(atpBatch );  
        Test.stopTest(); 
    }
    
    static testMethod void testScheduler(){
        Test.StartTest();
        System.schedule('Test1'+system.now(),  '0 0 0/1 1/1 * ? *', new FV_FetchAllATPScheduler());
        Test.StopTest();
    }  
  
  
  
  private static List<Account_Team_Proxy__c> getATPRecords(){
       List<Account_Team_Proxy__c> atpList=new List<Account_Team_Proxy__c>();
       
        Account a = getAccount('MYTEST ACCOUNT1');
        
        Account a1 = getAccount('MYTEST ACCOUNT2');
      
     Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
     User user1 = new User( ProfileId = profile1.Id,
                                                Username = 'user3241@testorg.com',
                                                Alias = 'auser1',
                                                Email='user1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                HCM_Login_ID__c='E101234'
                                                );
     insert  user1 ;        
           
      Account_Team_Proxy__c atpObj = new Account_Team_Proxy__c (  User__c=User1.Id,
                                                             Account__c=a.Id,
                                                             Account_Access__c='Read/Write',
                                                             Opportunity_Access__c='Read/Write',
                                                             Team_Role__c='DE - IP Technical'
                                                             );
       
       Account_Team_Proxy__c atpObj1 = new Account_Team_Proxy__c (  User__c=User1.Id,
                                                             Account__c=a1.Id,
                                                             Account_Access__c='Read/Write',
                                                             Opportunity_Access__c='Read/Write',
                                                             Team_Role__c='DE - IP Technical'
                                                             );
                                                             
     atpList.add(atpObj);                                                                                                           
     atpList.add(atpObj1);
     
     Internal_Impersonation_Mapping__c obj=new Internal_Impersonation_Mapping__c();
     obj.User_Shortname__c=user1.HCM_Login_ID__c;
     //obj.Accounts_ShortName__c=a.Short_Name__c,a1.Short_Name__c;
     obj.Sync_Needed__c =True;
     insert obj;
     return atpList;  
       
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

  
}