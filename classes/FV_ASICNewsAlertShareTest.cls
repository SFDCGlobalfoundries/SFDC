/*------------------------------------------------------------
Type Name: FV_ASICNewsAlertShareTest.
Author: Cognizant
Reason: This is the Test class for trigger FV_ASICNewsAlertShare
        and FV_ASICNewsAlert_Customer class
--------------------------------------------------------------*/

@isTest
Public class FV_ASICNewsAlertShareTest
{
  // Creating account object data using AccountDataFactory util class
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
      
      
    // For Positive testing.
    public static testMethod void onAfterUpdateTest()
    {
      
       User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
      System.runAs(runningUser) {
       
        List<Account> accLst = getAccounts();
        Account accObj = accLst[0];                 
       
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
        insert conobj;
          
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
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
     insert   portalUser;
       
       
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
        objASIC.Published_on__c = system.today();
        insert objASIC;
          test.starttest();   
        Package__c objPkg = FV_PDKTestDataTest.getPackage(accObj);      
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdkObj.ID, 'Demo B1');        
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdkObj.ID, 11111, '0.11UM');        
        insert dSpec1 ;
        
        List<Document_Provisioning__c> docProvinLst = new List<Document_Provisioning__c>();
        document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, dSpec1.Id, accObj.Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
      
        document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, dSpec1.Id, accObj.Id,Id.valueOf(UserInfo.getUserId()),'De-Provisioned');
        
        docProvinLst.add(dp1);
        docProvinLst.add(dp2);
        
        insert docProvinLst;
         
      
      
       List<Document_Provisioning__c> docProLst = new List<Document_Provisioning__c>();
        Document_Provisioning__c objDocuProvisionNew = new Document_Provisioning__c();
        objDocuProvisionNew.id = docProvinLst[0].id;
        objDocuProvisionNew.AccountID__c = accObj.id;
        objDocuProvisionNew.PDK__c = pdkObj.id;
        objDocuProvisionNew.Sub_PDK__c = sPdk.id;
        objDocuProvisionNew.Status__c = 'Provisioned';
       
        Document_Provisioning__c objDocuProvisionNew1 = new Document_Provisioning__c();
        objDocuProvisionNew1.id = docProvinLst[1].id;
        objDocuProvisionNew1.AccountID__c = accObj.id;
        objDocuProvisionNew1.PDK__c = pdkObj.id;
        objDocuProvisionNew1.Sub_PDK__c = sPdk.id;
        objDocuProvisionNew1.Status__c = 'Provisioned';
       
        docProLst.add(objDocuProvisionNew);
        docProLst.add(objDocuProvisionNew1);
        
        update docProLst;  
           
      test.stopTest();
    }
  }
 
  //For Negative test
    public static testMethod void onAfterUpdateNegativeTest()
    {
       
       
        User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
        System.runAs(runningUser) {
        
        List<Account> accLst = getAccounts();
        Account accObj = accLst[0];      

        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accObj.Id,Email='con1@gf.com',Department__c='Procurement'); 
        insert conobj;
          
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
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
      insert   portalUser;
       
       
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
        objASIC.Published_on__c = system.today();
        insert objASIC;
        test.startTest();        
        Package__c objPkg = FV_PDKTestDataTest.getPackage(accObj);      
        Sub_PDK__c sPdk = FV_PDKTestDataTest.getSubPdk('PDK 1','Release To white list', pdkObj.ID, 'Demo B1');        
        Design_Spec__c dSpec1 = FV_PDKTestDataTest.getDesignSpec('Specific Account Release', 'abc', 'Spec 1', pdkObj.ID, 11111, '0.11UM');        
        insert dSpec1 ;
        
        List<Document_Provisioning__c> docProvinLst = new List<Document_Provisioning__c>();
        document_provisioning__c dp1 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, dSpec1.Id, accObj.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
         
        
        document_provisioning__c dp2 = FV_PDKTestDataTest.getDocumentProvisioningRecords(objPkg.Id, sPdk.Id, dSpec1.Id, accObj.Id,Id.valueOf(UserInfo.getUserId()),'Provisioned');
                         
        docProvinLst.add(dp1);
        docProvinLst.add(dp2);
       
        insert docProvinLst;
      
       
        
        List<Document_Provisioning__c> docProLst = new List<Document_Provisioning__c>();
        Document_Provisioning__c objDocuProvisionNew = new Document_Provisioning__c();
        objDocuProvisionNew.id = docProvinLst[0].id;
        objDocuProvisionNew.AccountID__c = accObj.id;
        objDocuProvisionNew.PDK__c = pdkObj.id;
        objDocuProvisionNew.Sub_PDK__c = sPdk.id;
        objDocuProvisionNew.Status__c = 'De-Provisioned';
        
        Document_Provisioning__c objDocuProvisionNew1 = new Document_Provisioning__c();
        objDocuProvisionNew1.id = docProvinLst[1].id;
        objDocuProvisionNew1.AccountID__c = accObj.id;
        objDocuProvisionNew1.PDK__c = pdkObj.id;
        objDocuProvisionNew1.Sub_PDK__c = sPdk.id;
        objDocuProvisionNew1.Status__c = 'De-Provisioned';
        
        docProLst.add(objDocuProvisionNew);
        docProLst.add(objDocuProvisionNew1);
       
        update docProLst; 
       
        // calling FV_ASICNewsAlertTriggerHandler class.
        ASIC_News_Alert__c objASICUpdate = new ASIC_News_Alert__c();
        objASICUpdate.Master_PDK__c = pdkObj.id;
        objASICUpdate.Title__c = 'Test News';
        objASICUpdate.Active__c = true;
        objASICUpdate.Published_on__c = system.today();
        insert objASICUpdate;
      
        // creating test for FV_ASICNewsAlert_Customer class
        
        ApexPages.StandardController sc = new ApexPages.standardController(objASICUpdate);
        FV_ASICNewsAlert_Customer asicCustomer = new FV_ASICNewsAlert_Customer(sc);
        
       test.stopTest();
    
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