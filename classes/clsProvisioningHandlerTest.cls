/*
Type Name: clsProvisioningHandlerTest
Author: Cognizant
Created Date: 16-August-2013
Reason: This is the Test class for class clsIntegrationUtil. 
Change History:
Author: Cognizant 
Modified Date:27/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
*/
@isTest(seeAllData=false)
public class clsProvisioningHandlerTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
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
        fieldValueMap.put('Fab_9_10__c','No');

        AccountDataFactory.createAccount(fieldValueMap);
    }
          
    static testMethod void testSpec()
    {
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
          RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
          
          Map<Id,List<Id>> mapInputProvReq = new Map<Id,List<Id>>();
          List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
        
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;
         
         lstUserIds.add(portalUser.Id);
        
        Design_Spec__c objDesignSpec = new Design_Spec__c();
        
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';
        
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';
        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';
        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';
                              
        insert objDesignSpec;
        system.assertEquals(objDesignSpec.Name,'Test Name'); 
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = objDesignSpec.Id;
        wl.Account__c = accntObj.Id;
        wl.RecordTypeId = recTypeDS.Id;
        
        insert wl;
        
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Status__c='Provisioned';
        insert dp;
        
        mapInputProvReq.put(objDesignSpec.Id, lstUserIds);
        
        ClsProvisioningHandler controller = new ClsProvisioningHandler();            
        
        test.startTest();        
        controller.doProvision(mapInputProvReq, 'Spec');
        controller.doProvisionUpdates(mapInputProvReq, 'Spec'); 
        controller.deProvisioningMethod(mapInputProvReq, 'Spec');       
        test.StopTest();
    }
    
    static testMethod void testSubPDK()
    {
        
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
          RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
            
          Map<Id,List<Id>> mapInputProvReq = new Map<Id,List<Id>>();
          List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
        
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;
         
         lstUserIds.add(portalUser.Id);
         
         Design_Spec__c objDesignSpec = new Design_Spec__c();
        
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';
        
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';
        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';
        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';
                              
        insert objDesignSpec;
        system.assertEquals(objDesignSpec.Name,'Test Name'); 
        
        Sub_PDK__c obj = new Sub_PDK__c(); 
        obj.Name = 'Test Name';
        obj.Bundle_Name__c = 'Test Bundle Name';
        obj.Release_Status__c = 'Release To White List';
                              
        insert obj;
        
        Sub_PDK__c obj2 = new Sub_PDK__c(); 
        obj2.Name = 'Test Name 2';
        obj.Bundle_Name__c = 'Test Bundle Name 2';
        obj2.Release_Status__c = 'Release To White List';
                              
        insert obj2;
        
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = objDesignSpec.Id;
        wl.Account__c = accntObj.Id;
        wl.RecordTypeId = recTypeDS.Id;
        
        insert wl;
        
        White_List__c wl2 = new White_List__c();
        wl2.Sub_PDK__c = obj.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypeSPDK.Id;
        
        insert wl2;
        
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Design_Spec__c = objDesignSpec.Id;
        objsps.Sub_PDK__c = obj.Id;
        
        insert objsps;
        
        Sub_PDK_Spec__c objsps2 = new Sub_PDK_Spec__c();
        objsps2.Design_Spec__c = objDesignSpec.Id;
        objsps2.Sub_PDK__c = obj2.Id;
        
        insert objsps2;
        test.startTest();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Sub_PDK__c = obj.Id;
        dp.Status__c='Provision In Progress';
        insert dp;
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Design_Spec__c = objDesignSpec.Id;
        dp2.Sub_PDK_Provisioned_for__c = obj.Id+';'+obj2.Id;
        dp2.Status__c='Provisioned';
        insert dp2;
        
        Profile objProfile = [Select Id,Name from Profile where Id =: UserInfo.getProfileId()];
        
        Provisioning_Profiles_with_Approval__c ppfa = new Provisioning_Profiles_with_Approval__c();
        ppfa.name = objProfile.name;
        ppfa.needsApproval__c = true;
        insert ppfa;
        
        Tech_Geometry_with_Provisioning_Approval__c tgpa = new Tech_Geometry_with_Provisioning_Approval__c();
        tgpa.name = 'test tech geo';
        insert tgpa;
        
        mapInputProvReq.put(obj.Id, lstUserIds);
                          
        ClsProvisioningHandler controller = new ClsProvisioningHandler();
                
        controller.doProvision(mapInputProvReq, 'SubPDK');
        controller.doProvisionUpdates(mapInputProvReq, 'SubPDK'); 
        controller.deProvisioningMethod(mapInputProvReq, 'SubPDK');       
        test.StopTest();
       
    }
    
    static testMethod void testPackage()
    {
        
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
          RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
          Map<Id,List<Id>> mapInputProvReq = new Map<Id,List<Id>>();
          List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
        
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;
         
         lstUserIds.add(portalUser.Id);
         
         Design_Spec__c objDesignSpec = new Design_Spec__c();
        
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';
        
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';
        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';
        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';
                              
        insert objDesignSpec;
        system.assertEquals(objDesignSpec.Name,'Test Name'); 
        
        Profile objProfile = [Select Id,Name from Profile where Id =: UserInfo.getProfileId()];
        
        Provisioning_Profiles_with_Approval__c ppfa = new Provisioning_Profiles_with_Approval__c();
        ppfa.name = objProfile.name;
        ppfa.needsApproval__c = true;
        insert ppfa;
        
        Tech_Geometry_with_Provisioning_Approval__c tgpa = new Tech_Geometry_with_Provisioning_Approval__c();
        tgpa.name = 'test tech geo';
        insert tgpa;
        
        test.startTest(); 
               
        Package__c obj = new Package__c();
 
        obj.Name = 'Test Name';
        obj.Package_Release_Status__c = 'Release To White List';
                              
        insert obj;
               
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = objDesignSpec.Id;
        wl.Account__c = accntObj.Id;
        wl.RecordTypeId = recTypeDS.Id;
        
        insert wl;
        
        White_List__c wl2 = new White_List__c();
        wl2.Package__c = obj.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypePCK.Id;
        
        insert wl2;
        
        Package_Spec__c objps = new Package_Spec__c();
        objps.Design_Spec__c = objDesignSpec.Id;
        objps.Package__c = obj.Id;
        
        insert objps;
            
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Package__c = obj.Id;     
        dp.status__c='Provisioned';        
        insert dp;

        mapInputProvReq.put(obj.Id, lstUserIds);
        
        ClsProvisioningHandler controller = new ClsProvisioningHandler();            
        
                            
        controller.doProvision(mapInputProvReq, 'Package');
        controller.doProvisionUpdates(mapInputProvReq, 'Package');
        controller.deProvisioningMethod(mapInputProvReq, 'Package');       
        test.StopTest();
    }
    
    static testMethod void testTeamRoom()
    {
        
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
          RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
          Map<Id,List<Id>> mapInputProvReq = new Map<Id,List<Id>>();
          
          List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');           
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;         
         lstUserIds.add(portalUser.Id);
         
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';                            
        insert objDesignSpec;
        system.assertEquals(objDesignSpec.Name,'Test Name'); 
        
        Profile objProfile = [Select Id,Name from Profile where Id =: UserInfo.getProfileId()];
        
        Provisioning_Profiles_with_Approval__c ppfa = new Provisioning_Profiles_with_Approval__c();
        ppfa.name = objProfile.name;
        ppfa.needsApproval__c = true;
        insert ppfa;
        
        Tech_Geometry_with_Provisioning_Approval__c tgpa = new Tech_Geometry_with_Provisioning_Approval__c();
        tgpa.name = 'test tech geo';
        insert tgpa;
        
        test.startTest(); 
               
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';                             
        insert objPck;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'Test Name';
        objSubPDK.Bundle_Name__c = 'Test Bundle Name';
        objSubPDK.Release_Status__c = 'Release To White List';                             
        insert objSubPDK;
        
        List<White_List__c> lstWhiteList = new List<White_List__c>();       
        White_List__c wl1 = new White_List__c();
        wl1.Design_Spec__c = objDesignSpec.Id;
        wl1.Account__c = accntObj.Id;
        wl1.RecordTypeId = recTypeDS.Id;
        White_List__c wl2 = new White_List__c();
        wl2.Package__c = objPck.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypePCK.Id;
        White_List__c wl3 = new White_List__c();
        wl3.Sub_PDK__c = objSubPDK.Id;
        wl3.Account__c = accntObj.Id;
        wl3.RecordTypeId = recTypeSPDK.Id;
        lstWhiteList.add(wl1);
        lstWhiteList.add(wl2);
        lstWhiteList.add(wl3);       
        insert lstWhiteList;
        
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'TestTeamRoom';
        tm.Team_Room_Description__c = 'Test Description';
    tm.Primary_Account__c=accntObj.id;
        insert tm;
        
        List<Team_Room_Doc__c> lstTeamRoomDoc = new List<Team_Room_Doc__c>();
        Team_Room_Doc__c tmd1 = new Team_Room_Doc__c();
        tmd1.Team_Room__c = tm.id;
        tmd1.Design_Spec__c = objDesignSpec.Id;
        Team_Room_Doc__c tmd2 = new Team_Room_Doc__c();
        tmd2.Team_Room__c = tm.id;
        tmd2.Design_Package__c = objPck.Id;
        Team_Room_Doc__c tmd3 = new Team_Room_Doc__c();
        tmd3.Team_Room__c = tm.id;
        tmd3.Sub_PDK__c = objSubPDK.Id;
        lstTeamRoomDoc.add(tmd1);
        lstTeamRoomDoc.add(tmd2);
        lstTeamRoomDoc.add(tmd3);
        insert lstTeamRoomDoc;

        mapInputProvReq.put(tm.Id, lstUserIds);
        
        ClsProvisioningHandler controller = new ClsProvisioningHandler();                                             
        controller.doProvision(mapInputProvReq, 'TeamRoom');
        
        delete objPck;
        delete objSubPDK;
              
        test.StopTest();
    }
    
    static testMethod void testTeamRoom2()
    {
        
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
          RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
          Map<Id,List<Id>> mapInputProvReq2 = new Map<Id,List<Id>>();
          Map<Id,List<Id>> mapInputProvReq3 = new Map<Id,List<Id>>();
          Map<Id,List<Id>> mapInputProvReq4 = new Map<Id,List<Id>>();
          List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');           
          insert conobj;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          User portalUser = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.id,
                                                Portal_Login__c='abc12'
                                               );
                                               
         insert   portalUser   ;         
         lstUserIds.add(portalUser.Id);
         
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'DRC';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = 'test tech geo';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';                            
        insert objDesignSpec;
        system.assertEquals(objDesignSpec.Name,'Test Name'); 
        
        test.startTest(); 
               
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';                             
        insert objPck;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'Test Name';
        objSubPDK.Bundle_Name__c = 'Test Bundle Name';
        objSubPDK.Release_Status__c = 'Release To White List';                             
        insert objSubPDK;
        
        List<White_List__c> lstWhiteList = new List<White_List__c>();       
        White_List__c wl1 = new White_List__c();
        wl1.Design_Spec__c = objDesignSpec.Id;
        wl1.Account__c = accntObj.Id;
        wl1.RecordTypeId = recTypeDS.Id;
        White_List__c wl2 = new White_List__c();
        wl2.Package__c = objPck.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypePCK.Id;
        White_List__c wl3 = new White_List__c();
        wl3.Sub_PDK__c = objSubPDK.Id;
        wl3.Account__c = accntObj.Id;
        wl3.RecordTypeId = recTypeSPDK.Id;
        lstWhiteList.add(wl1);
        lstWhiteList.add(wl2);
        lstWhiteList.add(wl3);       
        insert lstWhiteList;
        
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'TestTeamRoom';
        tm.Team_Room_Description__c = 'Test Description';
    tm.Primary_Account__c=accntObj.id;
        insert tm;
        
        List<Team_Room_Doc__c> lstTeamRoomDoc = new List<Team_Room_Doc__c>();
        Team_Room_Doc__c tmd1 = new Team_Room_Doc__c();
        tmd1.Team_Room__c = tm.id;
        tmd1.Design_Spec__c = objDesignSpec.Id;
        Team_Room_Doc__c tmd2 = new Team_Room_Doc__c();
        tmd2.Team_Room__c = tm.id;
        tmd2.Design_Package__c = objPck.Id;
        Team_Room_Doc__c tmd3 = new Team_Room_Doc__c();
        tmd3.Team_Room__c = tm.id;
        tmd3.Sub_PDK__c = objSubPDK.Id;
        lstTeamRoomDoc.add(tmd1);
        lstTeamRoomDoc.add(tmd2);
        lstTeamRoomDoc.add(tmd3);
        insert lstTeamRoomDoc;
    
    List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp1 = new Document_Provisioning__c ();
        dp1.User__c = portalUser.Id;
        dp1.Design_Spec__c = objDesignSpec.Id;
        dp1.Team_Rooms_Provisioned_for__c = tm.id;
        dp1.Status__c='Provisioned';
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Sub_PDK__c = objSubPDK.Id;
        dp2.Team_Rooms_Provisioned_for__c = tm.id;
        dp2.Status__c='Provisioned';
        
        Document_Provisioning__c dp3 = new Document_Provisioning__c ();
        dp3.User__c = portalUser.Id;
        dp3.Design_Package__c = objPck.Id;
        dp3.Team_Rooms_Provisioned_for__c = tm.id;
        dp3.status__c='Provisioned';
        listDP.add(dp1);
        listDP.add(dp2); 
        listDP.add(dp3);                  
        insert listDP;
        
        mapInputProvReq2.put(objDesignSpec.Id,lstUserIds);
        mapInputProvReq3.put(objSubPDK.Id,lstUserIds);
        mapInputProvReq4.put(objPck.Id,lstUserIds);
        
        ClsProvisioningHandler controller = new ClsProvisioningHandler();                                             

        controller.deProvisioningMethod(mapInputProvReq2, 'TeamRoomSpec');
        controller.deProvisioningMethod(mapInputProvReq3, 'TeamRoomSubPDK');
        controller.deProvisioningMethod(mapInputProvReq4, 'TeamRoomPackage');
        delete objPck;
        delete objSubPDK;
              
        test.StopTest();
    }
        
      private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}