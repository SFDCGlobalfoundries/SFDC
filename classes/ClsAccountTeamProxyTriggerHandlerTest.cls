/*
Type Name: ClsAccountTeamProxyTriggerHandlerTest
Author: Cognizant
Created Date: 16-April-2013
Reason: This is the Test class for class accountTeamProxyTriggerHandler. 
Change History:
    Vijay 04202015      - added the testmethods to test the onAfterInsert, onAfterUpdate and onAfterUpdate mehtods.
  Devendra  10142015      - Updated to fix device validation error

*/
@isTest
public class ClsAccountTeamProxyTriggerHandlerTest
{
    /* 
      static testMethod void CreateData()
     { 
        List<Account_Team_Proxy__c> atpList=new List<Account_Team_Proxy__c>();
     
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      
        System.runAs (thisUser) {
        
       
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User user1 = new User( ProfileId = profile1.Id,
                                        Username = System.now().millisecond() + 'test2@test.com',
                                        Alias = 'batman',
                                        Email='bruce.wayne@wayneenterprises.com',
                                        EmailEncodingKey='UTF-8',
                                        Firstname='Bruce',
                                        Lastname='Wayne',
                                        LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US',
                                        TimeZoneSidKey='America/Chicago'
                                       );
                     
         insert user1;
         User user2 = new User( ProfileId = profile1.Id,
                                        Username = System.now().millisecond() + 'test1@test.com',
                                        Alias = 'batman1',
                                        Email='bruce1.wayne@wayneenterprises.com',
                                        EmailEncodingKey='UTF-8',
                                        Firstname='Bruce1',
                                        Lastname='Wayne',
                                        LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US',
                                        TimeZoneSidKey='America/Chicago'
                                       );
                     
                     
         insert user2;
         
         Account accntObj = new Account(name ='acc',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Primary_CSR__c=null,Account_Admin__c=null,
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria'
                              );
        insert accntObj ;                 
        Account_Team_Proxy__c accntprxyObj = new Account_Team_Proxy__c(User__c =user1.Id,Team_Role__c='Primary Customer Service Rep', Account__c=accntObj.Id);
                        
        insert accntprxyObj;
    
       
   
        Accountteammember ATMObj=new Accountteammember();
        ATMObj.UserId=accntprxyObj.User__c ;
        ATMObj.AccountId=accntprxyObj.Account__c;
        ATMObj.TeamMemberRole=accntprxyObj.Team_Role__c;
        
        insert ATMObj;
        
     
        
        atpList.add(accntprxyObj);
       
        
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com');   
        
        insert conobj;
        
        Test.startTest(); 
        ClsAccountTeamProxyTriggerHandler.populatePrimaryCSR(atpList);
        
        delete accntprxyObj;
        Test.stopTest();
     }
  
   }
  */
    
    
    @testSetup static void testSetupData(){
        List<RecordType> recordTypeList = [Select Id from RecordType where sObjectType ='Account' and developerName = 'GLOBALFOUNDRIES_Internal'];
        DataUtilTest.loadEnvironmentVariables();

        Account account = InternalDeviceTestUtil.createAccount('Test Account1', 'Qualified', 'TestAccount1', 'Site', 'Direct', 'transactional', 'Fabless - Emerging',
                                             'Mature (> 0.11um)', 'APJ', 'APJ-FE-CHINA', 'APJ-China', 'APJ-China', true, '50 water', 'Bijing', 'China',  '50', 'GF Investment LLC OU', 
                                             100);
                                        
        if(!recordTypeList.isEmpty()){                      
            account.RecordTypeId = recordTypeList[0].Id;
        }
        update account;
        System.debug('account====='+account);
        List<RecordType> deviceRecTypeList = [Select Id from RecordType where sObjectType ='Device__c' and developerName = 'Internal_Device'];
        
        Device__c device = InternalDeviceTestUtil.createDevice('TestInternalDevice', 'Fab 2', 'Design In', 'Active', '100', System.today(), 
                                                                '1234567890', 'Single Product',  account.Id, '0.028UM', 'Super Low Power');
        device.Device_Mask_Set_Title__c = 'MSTTRT1';
        device.Reticle_Type__c = 'Multi Layer Reticle (MLR)';  
        device.Enabled_via_previous_MPW_1__c = 'No';                                                                                                            
        if(!deviceRecTypeList.isEmpty()){                       
            device.RecordTypeId = deviceRecTypeList[0].Id;
        }
        insert device;
    }
  
  
    static testMethod void testOnAfterInsert(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 2];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<3; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        Account account =[SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1];
        
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        Test.startTest();
        insert atpList;
        Test.stopTest();
    }
    
    
    static testMethod void testOnAfterUpdate(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 1];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<2; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        Account account =[SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1];
        
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Account Administrator',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        insert atpList;
        Test.startTest();
        for(Account_Team_Proxy__c atp:atpList){
            atp.Account_Access__c ='Read Only';
        }
        System.debug('-------------'+atpList);
        update atpList;
        Test.stopTest();
    }
    
    static testMethod void testOnAfterDelete(){
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name = 'Salesforce' and p.name ='GF FAE/FTS' LIMIT 1];
        List<User> userList = [Select Id From User Where ProfileId = :profiles[0].Id AND IsActive=true Limit 2];
        
        if(userList.isEmpty()){
            DataUtilTest.LoadHCMEnvVariables(); 
            List<HCM_Employee__c> hcmEmployeeList = new List<HCM_Employee__c>();
            for(Integer i = 1; i<3; i++){
                hcmEmployeeList.add(InternalDeviceTestUtil.createHCMEmployee('FAEtest'+i, 'User'+i, 'FAEFTS'+i, 'IT', 'testFAEFTSUser'+i+'@testFAEFTSUser.com',
                                                                                        'TestTitle', '999999999','FAEtest'+i));
                userList.add(InternalDeviceTestUtil.createUser('FAEtest'+i, 'testFAEFTSUser'+i+'@testFAEFTSUser1.com', 'User1', 'FAEFTS'+i, profiles[0].Id, 
                                                            'testFAEFTSUser'+i+'@testFAEFTSUser.com', 'FAEtest'+i));
            }
        
            insert hcmEmployeeList;
            insert userList;
        }   
        Test.startTest();
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        Account account =[SELECT Id FROM Account WHERE Name='Test Account1' LIMIT 1];
        
        for(User u:userList){
            atpList.add(new Account_Team_Proxy__c(User__c = u.id, Account__c=account.id, Account_Access__c='Read/Write',Team_Role__c='Primary Customer Service Rep',
                                                Sequence_No__c='1',  Account_Role_ID__c='test'));
        }
        insert atpList;
        
        delete atpList;
        Test.stopTest();
    }
}