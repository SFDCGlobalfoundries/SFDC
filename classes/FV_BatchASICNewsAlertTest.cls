/*------------------------------------------------------------
Type Name: FV_BatchASICNewsAlertTest.
Author: Cognizant
Reason: This is the Test class for batch FV_BatchASICNewsAlert
        and schedule class of FV_ScheduleASICNewsAlert
        
--------------------------------------------------------------*/


@isTest
private class FV_BatchASICNewsAlertTest{
    
   @testSetup static void testdata() {
            
         DataUtilTest.loadEnvironmentVariables();
         
          List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
                fieldValueMap.put('Name', 'MYTESTACC'+z);            
                fieldValueMap.put('stage__c', 'Unqualified');        
                fieldValueMap.put('sub_type__c', 'Direct');
                fieldValueMap.put('site_department__c', 'test dept');          
                fieldValueMap.put('transaction_type__c', 'transactional');                          
                fieldValueMap.put('region__c', 'APJ');        
                fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Corporate_City__c', 'Test City');                
                fieldValueMap.put('Corporate_Country__c', 'India');
                fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
                fieldValueMap.put('Bill_To_City__c', 'Test City');            
                fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
                fieldValueMap.put('Fab_9_10__c','No');
            fieldValueMapsList.add(fieldValueMap);
        }
            
            AccountDataFactory.createAccounts(fieldValueMapsList,3);
       
      }
    static testmethod void positiveTest(){
       
       User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
      System.runAs(runningUser) {
       
        list<user> lstusr=new list<user>();     
        String dateTimeFormat = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String query = 'SELECT Id,Name,Master_PDK__c,Is_notification_completed__c,Title__c,Email_notification_status__c,Type__c from ASIC_News_Alert__c where Active__c=true AND Is_notification_completed__c=FALSE AND Published_on__c <=' + dateTimeFormat; 
        
        List<Account> accLst = getAccounts();
        Account accObj = accLst[0];
        accObj.Authorized_for_ASIC_business__c = 'Yes';
        update accObj;
        
        Account accObj1 = accLst[1];
        accObj1.Authorized_for_ASIC_business__c = 'Yes';
        update accObj1;
      
        list<Contact> conLst = new list<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accObj.Id,Email='con1@gf.com',Department__c='Procurement',Is_Portal_User_Active__c =true); 
       
        Contact conobj1=new Contact(FirstName='Mr',LastName='Testcon12',AccountId=accObj1.Id,Email='con12@gf.com',Department__c='Procurement',Is_Portal_User_Active__c =true); 
        conLst.add(conobj);
        conLst.add(conobj1);
        
        insert conLst;   
    
       // creating Customer portal user.      
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                isActive=true,
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                CommunityNickname = 'testUser123',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conLst[0].id,
                                                Portal_Login__c='abc12'
                                               );
                                               
        User portalUser2 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser3@testorg.com',
                                                Alias = 'auszr',
                                                isActive=true,
                                                Email='portaluser3@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce3',
                                                Lastname='Wayne3',
                                                LanguageLocaleKey='en_US',
                                                CommunityNickname = 'testUser1234',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conLst[1].id,
                                                Portal_Login__c='abc12'
                                               );
                                               
                
        
        lstusr=new list<user>();     
        lstusr.add(portalUser);
        lstusr.add(portalUser2);  
        Test.startTest();
        insert lstusr;      
       
       
       // creating Master PDK obj records
       PDK__c pdkObj = new PDk__c();
       pdkObj.Master_PDK_ASIC__c = true;
       pdkObj.Name = 'Test';
       pdkObj.OpenText_ID__c = 3421;
       pdkObj.Description__c = 'TestDescription';
       pdkObj.Old_Revision_ID__c = 3421; 
       pdkObj.PDK_DocTitle__c = 'Test1';
       pdkObj.Tech_Geometry__c ='0.11UM;0.13UM;'; 
       insert pdkObj;
      
        //Creating  ASIC News & Alert object records.
        list<ASIC_News_Alert__c> asicLst = new List<ASIC_News_Alert__c>();
    
        ASIC_News_Alert__c objASIC = new ASIC_News_Alert__c();
        objASIC.Master_PDK__c = pdkObj.id;
        objASIC.Title__c = 'Test News'; 
        DateTime dt = DateTime.parse('11/6/2014 12:00 AM');
        String dtOut = dt.format('yyyy-MM-dd\'T\'hh:mm:ss'); 
       // objASIC.Published_on__c =  DateTime.valueOf(dtOut);
        objASIC.Published_on__c = dt ;
        asicLst.add(objASIC);
  
        insert asicLst;
        
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = pdkObj.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'Release to White list'; 
        insert objSubPDK;
        
        sub_PDK__c objSubPDK1 = new sub_PDK__c ();
        objSubPDK1.name = 'TestSubPDK1';
        objSubPDK1.PDK__c = pdkObj.id;
        objSubPDK1.Bundle_Name__c = 'Test Bundle1';
        objSubPDK1.Release_Status__c = 'Specific Account Release ';
        insert objSubPDK1;
        
        document_provisioning__c dp = new document_provisioning__c
        (user__c=lstusr[0].Id,status__c='Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=accObj.id,Sub_PDK__c=objSubPDK1.Id);
        insert dp;
        
        List<Portal_Tab_Access__c> portalLst = new List<Portal_Tab_Access__c>();   
        Portal_Tab_Access__c portalObj = new Portal_Tab_Access__c();
        portalObj.Access_setup_Design_Kits_ASIC_DK__c = true;
        portalObj.Access_setup_News_Alerts_ASIC__c = true;
        portalObj.Contact__c = conLst[0].id;
        portalObj.Account__c =accObj.id;
        portalLst.add(portalObj);
        
        Portal_Tab_Access__c portalObj1 = new Portal_Tab_Access__c();
        portalObj1.Access_setup_Design_Kits_ASIC_DK__c = true;
        portalObj1.Access_setup_News_Alerts_ASIC__c = true;
        portalObj1.Contact__c = conLst[1].id;
        portalObj1.Account__c =accObj1.id;
        portalLst.add(portalObj1);
        
        insert portalLst;
        
        
          FV_BatchASICNewsAlert c = new FV_BatchASICNewsAlert();
          c.TestVaraible = true;
          Database.executeBatch(c);
     
        Test.stopTest();
        
   
      }    
    }
    
    static testMethod void sheduleTest()
    {
        Test.startTest();
        
        FV_ScheduleASICNewsAlert sh1 = new FV_ScheduleASICNewsAlert();      
        String sch = '0 0 23 * * ?';
        system.schedule('FV_BatchASICNewsAlert',sch,sh1);
        
        Test.stopTest();
    }
    
    static testmethod void negativeTest(){
    
    
        User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
      System.runAs(runningUser) {
       
        list<user> lstusr=new list<user>();     
        String dateTimeFormat = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String query = 'SELECT Id,Name,Master_PDK__c,Is_notification_completed__c,Title__c,Type__c from ASIC_News_Alert__c where Active__c=true AND Is_notification_completed__c=FALSE AND Published_on__c <=' + dateTimeFormat; 
        
        List<Account> lstAcc = getAccounts();
        Account accObj =lstAcc[0];
        accObj.Authorized_for_ASIC_business__c = 'Yes';
        update accObj;
      
        list<Contact> conLst = new list<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accObj.Id,Email='con1@gf.com',Department__c='Procurement',Is_Portal_User_Active__c =true); 
       
        Contact conobj1=new Contact(FirstName='Mr',LastName='Testcon12',AccountId=accObj.Id,Email='con12@gf.com',Department__c='Procurement',Is_Portal_User_Active__c =true); 
        conLst.add(conobj);
        conLst.add(conobj1);
        
        insert conLst;   
    
          
       // creating Customer portal user.      
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
        User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                isActive=true,
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                CommunityNickname = 'testUser123',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conLst[0].id,
                                                Portal_Login__c='abc12'
                                               );
        Test.startTest();                                       
        insert   portalUser;
        
        lstusr=new list<user>();     
        lstusr.add(portalUser);
       
       
       // creating Master PDK obj records
       PDK__c pdkObj = new PDk__c();
       pdkObj.Master_PDK_ASIC__c = true;
       pdkObj.Name = 'Test';
       pdkObj.OpenText_ID__c = 3421;
       pdkObj.Description__c = 'TestDescription';
       pdkObj.Old_Revision_ID__c = 3421; 
       pdkObj.PDK_DocTitle__c = 'Test1';
       pdkObj.Tech_Geometry__c ='0.11UM;0.13UM;'; 
       insert pdkObj;
      
        //Creating  ASIC News & Alert object records.
        ASIC_News_Alert__c objASIC = new ASIC_News_Alert__c();
        objASIC.Master_PDK__c = pdkObj.id;
        objASIC.Title__c = 'Test News'; 
        DateTime dt = DateTime.parse('11/6/2014 12:00 AM');
        String dtOut = dt.format('yyyy-MM-dd\'T\'hh:mm:ss'); 
       // objASIC.Published_on__c =  DateTime.valueOf(dtOut);
       objASIC.Published_on__c = dt ;
        //system.today();
        insert objASIC;
     
     
         
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = pdkObj.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'Release to White list'; 
        insert objSubPDK;
        
        sub_PDK__c objSubPDK1 = new sub_PDK__c ();
        objSubPDK1.name = 'TestSubPDK1';
        objSubPDK1.PDK__c = pdkObj.id;
        objSubPDK1.Bundle_Name__c = 'Test Bundle1';
        objSubPDK1.Release_Status__c = 'Specific Account Release ';
        insert objSubPDK1;
        
        document_provisioning__c dp = new document_provisioning__c
        (user__c=lstusr[0].Id,status__c='De-Provisioned',Spec_Level_Provisioning__c=true,AccountID__c=accObj.id,Sub_PDK__c=objSubPDK1.Id);
        insert dp;

        
        
          FV_BatchASICNewsAlert c = new FV_BatchASICNewsAlert();
          c.TestVaraible = true;
          Database.executeBatch(c);
          Database.executeBatch(c);
          Test.stopTest();
        
    }
  }
  
  private static List<Account> getAccounts()
    {
        //Because we set SeeAllData = false, this will only return test account data and not data from the org 
        List<Account> accList = [SELECT Id,ParentId,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                                 Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account];   
        
        return accList;
    }
}