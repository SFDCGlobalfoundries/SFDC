@isTest
public class BatchToRemoveInaciveUSERTest
{
    @TestSetup
    public static void CreateTestData()
    {
     DataUtilTest.loadEnvironmentVariables();
     
     List<SObject> datalist=new List<SObject>();
     Account acct=new Account();  
     acct=(Account)Account.sObjectType.newSObject(NULL,true);
     acct.Name = 'Test';
     acct.short_name__c='TESTACC';
     //datalist.add(acct);
     insert acct;
     
     Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=acct.Id;
        update env;
     
       HCM_Employee__c hcmid1=new HCM_Employee__c();
       hcmid1= (HCM_Employee__c )HCM_Employee__c.sObjectType.newSObject(NULL,true);
       hcmid1.First_Name__c='TestFirstName1aca';
       hcmid1.Last_Name__c='TestLastName1aca';
       hcmid1.Email_Address__c='testuser1aca@testorg.com';
       String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
       Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
       String hexDigest = EncodingUtil.convertToHex(hash);

       hcmid1.Employee_ID__c=hexDigest.abbreviate(10);
       hcmid1.Login_ID__c=hexDigest.abbreviate(10);
       datalist.add(hcmid1);
       
       
       
       HCM_Employee__c hcmid2=new HCM_Employee__c();
       hcmid2= (HCM_Employee__c )HCM_Employee__c.sObjectType.newSObject(NULL,true);
       hcmid2.First_Name__c='TestFirstName2aca';
       hcmid2.Last_Name__c='TestLastName2aca';
       hcmid2.Email_Address__c='testuser2aca@testorg.com';
       hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
       hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
       hexDigest = EncodingUtil.convertToHex(hash);

       hcmid2.Employee_ID__c=hexDigest.abbreviate(10);
       hcmid2.Login_ID__c=hexDigest.abbreviate(10);
       datalist.add(hcmid2);
     
     Profile prof = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User u = [Select Id from User where ProfileId = :prof.Id and Isactive=true limit 1];
     system.runas(u){
         insert datalist;
     }
     
     datalist.clear();
     
     Profile p=[select id from Profile where Name='GF PIYE Platform'];
     User u1= new User(ProfileId = p.Id,
                                                Username = 'testuser1aca@testorg.com',
                                                Alias = 'auser1',
                                                Email='testuser1aca@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                IsActive = true, 
                                                FederationIdentifier=hcmid1.Login_ID__c,
                                                HCM_Login_ID__c=hcmid1.Login_ID__c
                                                );
     datalist.add(u1);                                                
                                                
     User u2= new User(ProfileId = p.Id,
                                                Username = 'testuser2aca@testorg.com',
                                                Alias = 'auser2',
                                                Email='testuser2aca@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                IsActive = true, 
                                                FederationIdentifier=hcmid2.Login_ID__c,
                                                HCM_Login_ID__c=hcmid2.Login_ID__c
                                                );
                                                
                                                                                           
     datalist.add(u2);
     Test.startTest();
     insert datalist;
     
     
     datalist.clear();
     
     Account_Team_Proxy__c atp1=new Account_Team_Proxy__c();
     atp1= (Account_Team_Proxy__c )Account_Team_Proxy__c.sObjectType.newSObject(NULL,true);
     atp1.Account__c=acct.id;
     atp1.User__c=u1.id;
     atp1.Account_Access__c='Read/Write';
     atp1.Team_Role__c='Field Application Engineer';
     atp1.Opportunity_Access__c='Read/Write';
     
     
     datalist.add(atp1);
     
     
     Account_Team_Proxy__c atp2=new Account_Team_Proxy__c();
     atp2= (Account_Team_Proxy__c )Account_Team_Proxy__c.sObjectType.newSObject(NULL,true);
     atp2.Account__c=acct.id;
     atp2.User__c=u2.id;
     atp2.Account_Access__c='Read/Write';
     atp2.Team_Role__c='Field Application Engineer';
     atp2.Opportunity_Access__c='Read/Write';
     
     datalist.add(atp2);
      
      
      insert datalist;
        
     Test.stopTest();
    }
    public static testmethod void TestBatch()
    {
        User u= [select id,isActive from User where Email='testuser1aca@testorg.com' limit 1];
        u.isActive=false;
        update u;
        
        test.startTest();
        Database.executeBatch(new BatchToRemoveInaciveUSER(),100);
        test.stopTest();
        
        
        Integer count1=[select count() from Account_Team_Proxy__c where User__r.Email='testuser1aca@testorg.com'];
        
        //aserting if inactive member is deleted
        System.assertEquals(0,count1);
        
        
        Integer count2=[select count() from Account_Team_Proxy__c where User__r.Email='testuser2aca@testorg.com'];
        
        //aserting if active member is still present
        System.assertEquals(1,count2);
        
    }
}