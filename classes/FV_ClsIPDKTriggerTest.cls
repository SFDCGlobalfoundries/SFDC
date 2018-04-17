/*
Type Name: FV_ClsIPDKTriggerTest.
Author: Cognizant
Created Date: 13-Nov-2014
Reason: This is the Test class for trigger FV_IPDKTrigger. 

……..
……..
Ashwini     05152015    - Updated code for making SeeAllData=false and refactoring of test class.
*/

@isTest(seeAllData = false)
public class FV_ClsIPDKTriggerTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
       
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
            fieldValueMap.put('short_name__c', 'TAC'+i);        
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');                          
            fieldValueMap.put('region__c', 'APJ');        
            fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Corporate_City__c', 'Test City');                
            fieldValueMap.put('Corporate_Country__c', 'Austria');
            fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
            fieldValueMap.put('Bill_To_City__c', 'Test City');            
            fieldValueMap.put('Bill_To_Country__c', 'Austria');        
            fieldValueMap.put('Fab_9_10__c','No');
            
            fieldValueMapList.add(fieldValueMap);
        }
        
      //  AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    static testMethod void methodFV_ClsIPDKTriggerTest()
    {
    //DataUtilTest.loadEnvironmentVariables(); 
    
   // Profile profile1 = [Select Id from Profile where name = 'System Administrator']; 
       

   /* User user1= new User( ProfileId = profile1.Id,
                                                Username = 'user1@testorg.com',
                                                Alias = 'user1',
                                                Email='user@testorg.com',
                                                 EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago'

                                               );*/
                                               
    User user1=[Select id 
                       from user 
                       where Profile.name='System Administrator' and isActive=true limit 1];                                         

  // insert user1;
    
   User loggedinUser=[Select id from user where id=:UserInfo.getUserId()]; 
   
    system.runas(user1)
    {
   
    
    GroupMember gm= new GroupMember(); 
    gm.GroupId=System.label.DS_Group_Id;
    gm.UserOrGroupId = loggedinUser.Id;
    insert gm; 
   
   
   }
   
  
   system.runas(loggedinUser)
   {
     
    //Create portal account owner
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    Profile profile1 = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
    User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
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
    Database.insert(portalAccountOwner1);
    
   //Create account
    Account accntObj = new Account(
        Name = 'TestAccount3456',
        OwnerId = portalAccountOwner1.Id
        );
    Database.insert(accntObj);
                    
    Account accntObj1 = new Account(
        Name = 'TestAccount123',
        OwnerId = portalAccountOwner1.Id
    );
    Database.insert(accntObj1);
    
    accntObj = new Account();
    accntObj1 = new Account();   
    accntObj = [SELECT Id, Name FROM Account Where Name ='TestAccount3456'];
    accntObj1 = [SELECT Id, Name FROM Account Where Name ='TestAccount123']; 
    //Account accntObj = getAccount('MYTEST ACCOUNT1');                              
    //Account accntObj1 = getAccount('MYTEST ACCOUNT1');  
            
    //Create contact
    Contact contact1=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);   
    insert contact1;
    
    //Test.startTest();    
    //Create user
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Portal Admin' AND UserType = 'PowerCustomerSuccess' Limit 1];
    User portalUser = new User(
        Username = System.now().millisecond() + 'test12345@test.com',
        ContactId = contact1.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test123',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );
    Database.insert(portalUser);
       
    /* Account accntObj = getAccount('MYTEST ACCOUNT1');                              
     Account accntObj1 = getAccount('MYTEST ACCOUNT1');         
     
     Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);   
        
     insert conobj;
     
     
      Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin' AND UserType = 'PowerCustomerSuccess']; //added by cognizant for Case 00004324
      UserRole r = [SELECT Id,DeveloperName,Name,PortalType  FROM UserRole Where PortalType='CustomerPortal'  LIMIT 1];
       
      User portalUser = new User(
            Username = 'test12345test@test.com',
            ContactId = conobj.Id,
            ProfileId = profile2.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Kumar',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            UserRoleId = r.Id,
            IsActive = true
            //userType = 'PowerCustomerSuccess'
            
        );
        Database.insert(portalUser); 
   */
      /*User portalUser=[Select id 
                       from user 
                       where Profile.name='Customer Portal Admin' and isActive=true limit 1];   */                                      
 

      /*  User portalUser = new User( ProfileId = profile2.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id
                                               );*/

     // insert portaluser;  
     
     Test.startTest();
     
     list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
     lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007,Specification_Type__c='IP Design Kit'));
     lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007,Specification_Type__c='IP Design Kit'));
     insert lstspec;
     
     list<Document_Provisioning__c > lstDP=new list<Document_Provisioning__c >();
     Document_Provisioning__c dp = new Document_Provisioning__c ();
     dp.User__c = portalUser.Id;
     dp.Design_Spec__c = lstspec[0].Id;
     dp.Status__c = 'Provisioned';
     lstDP.add(dp);
     
    
     insert lstDP;
     
     IPDK_Constant__c ipConst1 = new IPDK_Constant__c(name='DoNotReplyEmail', value__c ='DoNotReplyEmail@gmail.com');
     insert ipConst1;  
     list<IPDK_License_Information__c > lstIPLA=new list<IPDK_License_Information__c>();
     lstIPLA.add(new IPDK_License_Information__c (Account__c=accntObj.id,Specification__c=lstSpec[0].id));
     lstIPLA.add(new IPDK_License_Information__c (Account__c=accntObj1.id,Specification__c=lstSpec[1].id));
     
     insert lstIPLA;

     
     lstIPLA[0].Account__c=accntObj1.id;
     update lstIPLA[0];
     
    
     
     delete lstIPLA[0];
     Test.stopTest();
     }
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
  }