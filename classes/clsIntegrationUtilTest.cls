/*
Type Name: clsIntegrationUtilTest
Author: Cognizant
Created Date: 16-August-2013
Reason: This is the Test class for class clsIntegrationUtil. 
Change History:
Author: Cognizant
Modified Date: 23-Jan-2014
Reason: Case00004562
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
Ashwini     04072015    - Refactoring test class.
Ashwini     04302015    - Test method 'testRemoveelse' added to increase code coverage.
*/
@isTest
public class clsIntegrationUtilTest
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
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
     
    static testMethod void testDesignSpecs()
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
        // DataUtilTest.loadEnvironmentVariables();
         
         spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
    
         insert cstSetVar ;
         
         Map<String,Spec_owner__c> cstMap=Spec_owner__c.getAll();
         System.Debug(Logginglevel.warn,'Map--->'+cstMap);
         System.Debug(Logginglevel.warn,'Map--->'+cstMap.get('Default'));
         
         
    
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 1234;
        objWrapper.parentId = null;
        objWrapper.oldRevisionId = 1235;
        objWrapper.documentTitle = 'test doc title';
        objWrapper.documentNumber = 'test doc num';
        objWrapper.revision = 'ver 1.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';
        objWrapper.specificationReleaseCategory = 'Specific Account Release';
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper);
        test.StopTest();
       }
    }
    
    static testMethod void testPDKSpecs()
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
        //DataUtilTest.loadEnvironmentVariables();
        
        spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
         
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
            
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 1234;
        objWrapper.parentId = 3421;
        objWrapper.oldRevisionId = 1235;
        objWrapper.documentTitle = 'test doc title';
        objWrapper.documentNumber = 'test doc num';
        objWrapper.revision = 'ver 1.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';
        objWrapper.specificationReleaseCategory = 'Specific Account Release';
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper);
        test.StopTest();
       }
    }
    
    
    static testMethod void testBlankUpdateSpecs()
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
       //DataUtilTest.loadEnvironmentVariables();
       
       spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
         
         
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        
        List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
          
          system.debug('###'+accntobj);
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',UserFoundInOT__c=true,AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');          
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
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
        Set<Id> setDSpecId = new Set<Id>();
        List<Design_Spec__c> lstDSpec = new List<Design_Spec__c>();       
        objDesignSpec.OpenText_ID__c = 55555;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = 3421;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'rev 1.0';
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
        objDesignSpec.PDK_Patch__c = objPatch.Id;                             
        insert objDesignSpec;
        lstDSpec.add(objDesignSpec);
        setDSpecId.add(objDesignSpec.Id);
        
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;     
        dp.Status__c = 'Provisioned';     
        insert dp;
        
        Sub_PDK__c objspdk = new Sub_PDK__c(); 
        objspdk.Name = 'Test Name 2';
        objspdk.Release_Status__c = 'Release To White List';                              
        insert objspdk;
        
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Design_Spec__c = objDesignSpec.Id;
        objsps.Sub_PDK__c = objspdk.Id;       
        insert objsps;
            
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 55555;
        objWrapper.parentId = 3421;
        objWrapper.oldRevisionId = 5556;
        objWrapper.documentTitle = 'test doc title 2';
        objWrapper.documentNumber = 'test doc num';
        objWrapper.revision = 'rev 1.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';
        objWrapper.specificationReleaseCategory = 'Specific Account Release';
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper);
        clsIntegrationUtil.deleteProvisionings(setDSpecId);
        clsIntegrationUtil.deleteSubPDKSpecs(setDSpecId);
        clsIntegrationUtil.deletePDKSpecs(lstDSpec);
        test.StopTest();
        }
    }
    
    static testMethod void testRevisionUpdateSpecs()
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
        spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
        
        RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        
        List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,UserFoundInOT__c=true,Email='con1@gf.com',Department__c='Design');          
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
                                                isActive = true,
                                                Portal_Login__c='abc12'
                                               );                
         insert   portalUser   ;        
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
        Set<Id> setDSpecId = new Set<Id>();
        List<Design_Spec__c> lstDSpec = new List<Design_Spec__c>();       

        objDesignSpec.OpenText_ID__c = 66606;//modified by cognizant Case00004562
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;

        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'rev 1.0';
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
        objDesignSpec.Is_Latest_Revision__c = false;
        objDesignSpec.Specification_Owner__c = 'e13873';       
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List'; 
        objDesignSpec.PDK_Patch__c = objPatch.Id;                             
        insert objDesignSpec;
        
        lstDSpec.add(objDesignSpec);
        setDSpecId.add(objDesignSpec.Id);
        
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = objDesignSpec.Id;
        wl.Account__c = accntObj.Id;
        wl.RecordTypeId = recTypeDS.Id;       
        insert wl;
        
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;       
        insert dp;
        
        Sub_PDK__c objspdk = new Sub_PDK__c(); 
        objspdk.Name = 'Test Name 2';
        objspdk.Release_Status__c = 'Release To White List';                              
        insert objspdk;
        
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Design_Spec__c = objDesignSpec.Id;
        objsps.Sub_PDK__c = objspdk.Id;       
        insert objsps;
            
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 66606;


        objWrapper.parentId = null;
        objWrapper.oldRevisionId = 555622;
        objWrapper.documentTitle = 'test doc title 2';
        objWrapper.documentNumber = 'test doc num';

        objWrapper.revision = 'rev 3.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';

        objWrapper.specificationReleaseCategory = 'Specific Account Release';
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper.add(objWrapper);
        
       clsIntegrationUtil.WrapperDesignSpec objWrapper2 = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper2.openTextId = 66698;
        objWrapper2.parentId = null;
        objWrapper2.oldRevisionId = 6666223;
        objWrapper2.documentTitle = 'test doc title 2';
        objWrapper2.documentNumber = 'test doc num';
        objWrapper2.revision = 'rev 2.0';
        objWrapper2.lifecyclePhase = 'OBSOLETE';
        objWrapper2.locationFab = 'fab 3';
        //objWrapper2.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper2.specificationReleaseList = 'intel;is';
        objWrapper2.functionalOwnership = 'test func owner';
        objWrapper2.specificationType = 'Stepper Tooling Forms';
        objWrapper2.technologyType = 'test tech';
        objWrapper2.technologyGeometry = 'test techgeo';
        objWrapper2.source = 'test source';
        objWrapper2.pdkVersion = 'test pdk ver';
        objWrapper2.deVersion = 'test de ver';
        objWrapper2.specificationSubClass = 'test spec sc';
        objWrapper2.specificationOwner = 'e13873';
        objWrapper2.specificationReleaseCategory = 'Specific Account Release';
        objWrapper2.commodityType = 'test comm';
        objWrapper2.description = 'test descr';
        lstWrapper.add(objWrapper2);
        
         // prajnith       
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper);
        test.StopTest();
        }
    }
    
    static testMethod void testRemoveSpecs()
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
        //DataUtilTest.loadEnvironmentVariables();
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        
        List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1'); 
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,UserFoundInOT__c=true,Email='con1@gf.com',Department__c='Design');          
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
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
        Set<Id> setDSpecId = new Set<Id>();
        List<Design_Spec__c> lstDSpec = new List<Design_Spec__c>();       
        objDesignSpec.OpenText_ID__c = 88888;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = 3421;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'rev 1.0';
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
        objDesignSpec.PDK_Patch__c = objPatch.Id;                             
        insert objDesignSpec;
        
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 88888;
        objWrapper.parentId = 3421;
        objWrapper.oldRevisionId = 5556;
        objWrapper.documentTitle = 'test doc title 2';
        objWrapper.documentNumber = 'test doc num';
        objWrapper.revision = 'rev 1.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';
        objWrapper.specificationReleaseCategory = 'REMOVE';
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper);
        test.StopTest();
        }
    }
        
    //Added by Ashwini to increase code coverage on 30/04/2015
    /*
    static testMethod void testRemoveelse()
    {
    
        //DataUtilTest.loadEnvironmentVariables();
        
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        
        List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = new Account(name ='acc',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria'
                              );                             
          insert accntObj; 
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,UserFoundInOT__c=true,Email='con1@gf.com',Department__c='Design');          
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
        
        Spec_Owner__c testvalue = new Spec_Owner__c();
        testvalue.Name = 'Default';
        testvalue.UserId__C = '005900000010YhW';
        insert testvalue;
        
        Design_Spec__c objDesignSpec = new Design_Spec__c(); 
        Set<Id> setDSpecId = new Set<Id>();
        List<Design_Spec__c> lstDSpec = new List<Design_Spec__c>();       
        objDesignSpec.OpenText_ID__c = 88888;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = 3421;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'rev 1.0';
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
        objDesignSpec.PDK_Patch__c = objPatch.Id;                             
        insert objDesignSpec;
        
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper9 = new list<clsIntegrationUtil.WrapperDesignSpec>();
        clsIntegrationUtil.WrapperDesignSpec objWrapper = new clsIntegrationUtil.WrapperDesignSpec();
        objWrapper.openTextId = 88888;
        objWrapper.parentId = 3421;
        objWrapper.oldRevisionId = 5556;
        objWrapper.documentTitle = 'test doc title 2';
        objWrapper.documentNumber = 'test doc num';
        objWrapper.revision = 'rev 2.0';
        objWrapper.lifecyclePhase = 'released';
        objWrapper.locationFab = 'fab 3';
        //objWrapper.revisionReleaseDate = DateTime.parse('01/01/1990');
        objWrapper.specificationReleaseList = 'intel;is';
        objWrapper.functionalOwnership = 'test func owner';
        objWrapper.specificationType = 'Stepper Tooling Forms';
        objWrapper.technologyType = 'test tech';
        objWrapper.technologyGeometry = 'test techgeo';
        objWrapper.source = 'test source';
        objWrapper.pdkVersion = 'test pdk ver';
        objWrapper.deVersion = 'test de ver';
        objWrapper.specificationSubClass = 'test spec sc';
        objWrapper.specificationOwner = 'e13873';
        objWrapper.specificationReleaseCategory = Null;
        objWrapper.commodityType = 'test comm';
        objWrapper.description = 'test descr';
        lstWrapper9.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper9);
        test.StopTest();
    } */
    
    //End 
    
    static testMethod void testWL()
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
       //DataUtilTest.loadEnvironmentVariables();
      
        RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        set<String> setDSpecIds = new set<String>();
        map<Decimal,String> mapDSInserted = new map<Decimal,String>();
        map<Decimal,List<White_List__c>> existingChildWLMap = new map<Decimal,List<White_List__c>>();
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
        setDSpecIds.add(objDesignSpec.Id);
        mapDSInserted.put(objDesignSpec.OpenText_ID__c,objDesignSpec.Id);
        
        list<White_List__c> lstWhiteLists = new list<White_List__c>();
        White_List__c wl = new White_List__c();
        wl.Design_Spec__c = objDesignSpec.Id;
        wl.Account__c = accntObj.Id;
        wl.RecordTypeId = recTypeDS.Id;        
        insert wl;
        lstWhiteLists.add(wl);
        existingChildWLMap.put(objDesignSpec.OpenText_ID__c,lstWhiteLists);
            
        list<clsIntegrationUtil.wrapperWhiteList> lstWrapper = new list<clsIntegrationUtil.wrapperWhiteList>();
        clsIntegrationUtil.wrapperWhiteList objWrapper = new clsIntegrationUtil.wrapperWhiteList();
        objWrapper.description = 'test descr';
        objWrapper.accountShort = 'shortname';
        objWrapper.designSpecOTId = 54321;
        objWrapper.oldRevisionId = 12345;
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integrateWhiteList(lstWrapper);
        clsIntegrationUtil.fetchChildWhiteListsBySpecIds(setDSpecIds);
        clsIntegrationUtil.reparentAndUpdateWhiteList(mapDSInserted, existingChildWLMap);
        clsIntegrationUtil.changeWhiteListParent(objDesignSpec.Id,lstWhiteLists);
        clsIntegrationUtil.upsertReparentedWhiteListRecords(lstWhiteLists);
        clsIntegrationUtil.deletePreviousWhiteList(lstWhiteLists);
        test.StopTest();
        
        list<White_List__c> delWhiteList = new list<White_List__c>();
        delWhiteList  = [SELECT ID FROM White_List__c];
        delete delWhiteList;        
        clsIntegrationUtil.integrateWhiteList(lstWrapper); 
         }       
    }
    
    static testMethod void testupdateContactOnOTUserCreation()
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
      
       spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
                 
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
        
        List<Id> lstUserIds = new List<Id>();
          
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',UserFoundInOT__c=true,AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');          
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

                                                Portal_Login__c='abc12',
                                                FederationIdentifier ='123232'
                                               );                
         insert   portalUser   ;        
                   
        test.startTest();
        clsIntegrationUtil.updateContactOnOTUserCreation('12345','123232',true);
        clsIntegrationUtil.updateContactOnOTUserCreation('12345','12',true);                        
        test.StopTest();
        }
    }
    
    static testMethod void testSpecOwnerIDs()
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
        
          Account accntObj = getAccount('MYTEST ACCOUNT1');
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',UserFoundInOT__c=true,AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');          
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
                                                Portal_Login__c='abc12',
                                                HCM_Login_ID__c = '12345',
                                                isActive = true
                                               );                
         insert   portalUser   ;  
         set<string> userIDs = new set<string>();
         userIDs.add(portalUSer.ID);   
         system.debug('USer****'+portalUser.HCM_Login_Id__c);
         system.debug('USer****'+portalUser.IsActive);
         system.debug('USer****'+portalUser.UserType);                       
         clsIntegrationUtil.fetchAllSpecsOwnersByIds(userIDs);
         }
    }
        
    static testMethod void testPDK()
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
        //DataUtilTest.loadEnvironmentVariables();
        
        spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
         
        list<clsIntegrationUtil.wrapperPDK> lstWrapper = new list<clsIntegrationUtil.wrapperPDK>();
        clsIntegrationUtil.wrapperPDK objWrapper = new clsIntegrationUtil.wrapperPDK();
        objWrapper.openTextId = 86420;
        objWrapper.oldRevisionId = 86421;
        objWrapper.pdkId = 'PDK-600021';
        objWrapper.description = 'PDK-600021';
        objWrapper.pdkDoctitle = 'PDK-600021';
        objWrapper.pdkVersion = 'PDK-600021';
        objWrapper.technology = 'PDK-600021';
        objWrapper.techGeometry = 'PDK-600021';
        objWrapper.pdkLifecyclePhase = 'PDK-600021';
        objWrapper.pdkLocationFab = 'PDK-600021';
        objWrapper.pdkSubClass = 'PDK-600021';
        objWrapper.pdkSpecificationOwner = 'PDK-600021';
        objWrapper.pdkFunctionalOwnership = 'PDK-600021';
        objWrapper.pdkSpecificationType = 'PDK-600021';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integratePDK(lstWrapper);
        test.StopTest();
        }
    }
    
    static testMethod void testPDKBlankUpdate()
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
        //DataUtilTest.loadEnvironmentVariables();
       
       
       spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
         
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'test Name';
        objPDK.PDK_DocTitle__c = 'test Name';
        objPDK.OpenText_ID__c = 77777;
        objPDK.Description__c = 'test Name';
        objPDK.Old_Revision_ID__c = 86444;        
        objPDK.PDK_Functional_Ownership__c = 'test Name';
        objPDK.PDK_Lifecycle_Phase__c = 'Released';
        objPDK.PDK_Location_Fab__c = 'test Name';
        objPDK.PDK_Specification_Owner__c = 'e13873';       
        objPDK.PDK_Sub_class__c = 'test Name';
        objPDK.PDK_Version__c = 'ver 1.0';
        objPDK.Tech_Geometry__c = 'test Name';
        objPDK.Technology__c = 'test Name';
        objPDK.PDK_ID__c = 'test Name';
        objPDK.Is_Latest_Version__c = true;       
        insert objPDK;
            
        list<clsIntegrationUtil.wrapperPDK> lstWrapper = new list<clsIntegrationUtil.wrapperPDK>();
        clsIntegrationUtil.wrapperPDK objWrapper = new clsIntegrationUtil.wrapperPDK();
        objWrapper.openTextId = 77777;
        objWrapper.oldRevisionId = 86444;
        objWrapper.pdkId = 'PDK-600021';
        objWrapper.description = 'PDK-600021';
        objWrapper.pdkDoctitle = 'PDK-600021';
        objWrapper.pdkVersion = 'ver 1.0';
        objWrapper.technology = 'PDK-600021';
        objWrapper.techGeometry = 'PDK-600021';
        objWrapper.pdkLifecyclePhase = 'PDK-600021';
        objWrapper.pdkLocationFab = 'PDK-600021';
        objWrapper.pdkSubClass = 'PDK-600021';
        objWrapper.pdkSpecificationOwner = 'PDK-600021';
        objWrapper.pdkFunctionalOwnership = 'PDK-600021';
        objWrapper.pdkSpecificationType = 'PDK-600021';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integratePDK(lstWrapper);
        test.StopTest();
        }
    }
    
    static testMethod void testPDKVersionUpdate()
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
       // DataUtilTest.loadEnvironmentVariables();
        
        spec_owner__c cstSetVar =new spec_owner__c (name='Default');
         cstSetVar.userid__c='005900000010YhW';
         insert cstSetVar ;
         
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'test Name';
        objPDK.PDK_DocTitle__c = 'test Name';
        objPDK.OpenText_ID__c = 88888;
        objPDK.Description__c = 'test Name';
        objPDK.Old_Revision_ID__c = 86555;        
        objPDK.PDK_Functional_Ownership__c = 'test Name';
        objPDK.PDK_Lifecycle_Phase__c = 'Released';
        objPDK.PDK_Location_Fab__c = 'test Name';
        objPDK.PDK_Specification_Owner__c = 'e13873';       
        objPDK.PDK_Sub_class__c = 'test Name';
        objPDK.PDK_Version__c = 'ver 1.0';
        objPDK.Tech_Geometry__c = 'test Name';
        objPDK.Technology__c = 'test Name';
        objPDK.PDK_ID__c = 'test Name';
        objPDK.Is_Latest_Version__c = true;       
        insert objPDK;
            
        list<clsIntegrationUtil.wrapperPDK> lstWrapper = new list<clsIntegrationUtil.wrapperPDK>();
        clsIntegrationUtil.wrapperPDK objWrapper = new clsIntegrationUtil.wrapperPDK();
        objWrapper.openTextId = 88888;
        objWrapper.oldRevisionId = 86556;
        objWrapper.pdkId = 'PDK-600021';
        objWrapper.description = 'PDK-600021';
        objWrapper.pdkDoctitle = 'PDK-600021';
        objWrapper.pdkVersion = 'ver 2.0';
        objWrapper.technology = 'PDK-600021';
        objWrapper.techGeometry = 'PDK-600021';
        objWrapper.pdkLifecyclePhase = 'PDK-600021';
        objWrapper.pdkLocationFab = 'PDK-600021';
        objWrapper.pdkSubClass = 'PDK-600021';
        objWrapper.pdkSpecificationOwner = 'PDK-600021';
        objWrapper.pdkFunctionalOwnership = 'PDK-600021';
        objWrapper.pdkSpecificationType = 'PDK-600021';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integratePDK(lstWrapper);
        test.StopTest();
        }
    }
    
    static testMethod void testPDKPatch()
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
       // DataUtilTest.loadEnvironmentVariables();
        

        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'test Name';
        objPDK.PDK_DocTitle__c = 'test Name';
        objPDK.OpenText_ID__c = 86423;
        objPDK.Description__c = 'test Name';
        objPDK.Old_Revision_ID__c = 86444;        
        objPDK.PDK_Functional_Ownership__c = 'test Name';
        objPDK.PDK_Lifecycle_Phase__c = 'Released';
        objPDK.PDK_Location_Fab__c = 'test Name';
        objPDK.PDK_Specification_Owner__c = 'e13873';       
        objPDK.PDK_Sub_class__c = 'test Name';
        objPDK.PDK_Version__c = 'ver 1.0';
        objPDK.Tech_Geometry__c = 'test Name';
        objPDK.Technology__c = 'test Name';
        objPDK.PDK_ID__c = 'test Name';
        objPDK.Is_Latest_Version__c = true;       
        insert objPDK;
            
        list<clsIntegrationUtil.wrapperPDKPatch> lstWrapper = new list<clsIntegrationUtil.wrapperPDKPatch>();
        clsIntegrationUtil.wrapperPDKPatch objWrapper = new clsIntegrationUtil.wrapperPDKPatch();
        objWrapper.openTextId = 86422;
        objWrapper.parentId = 86423;
        objWrapper.pdkPatchId = 'PDK-600021';
        objWrapper.description = 'PDK-600021';
        objWrapper.pdkPatchDoctitle = 'PDK-600021';
        objWrapper.parentPdkVersion = 'PDK-600021';
        objWrapper.technology = 'PDK-600021';
        objWrapper.techGeometry = 'PDK-600021';
        objWrapper.pdkPatchLifecyclePhase = 'PDK-600021';
        objWrapper.pdkPatchLocationFab = 'PDK-600021';
        objWrapper.pdkPatchSubClass = 'PDK-600021';
        objWrapper.pdkPatchSpecificationOwner = 'PDK-600021';
        objWrapper.pdkPatchFunctionalOwnership = 'PDK-600021';
        objWrapper.pdkVersion = 'PDK-600021';
        objWrapper.pdkRevision = 'PDK-600021';
        objWrapper.pdkSpecificationType = 'PDK-600021';
        objWrapper.pdkParentPDKId = 'PDK-600021';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integratePDKPatch(lstWrapper);
        test.StopTest();
        }
    }
    
    static testMethod void testPDKPatchBlankUpdate()
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
        //DataUtilTest.loadEnvironmentVariables();
       
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'test Name';
        objPDK.PDK_DocTitle__c = 'test Name';
        objPDK.OpenText_ID__c = 55666;
        objPDK.Description__c = 'test Name';
        objPDK.Old_Revision_ID__c = 86444;        
        objPDK.PDK_Functional_Ownership__c = 'test Name';
        objPDK.PDK_Lifecycle_Phase__c = 'Released';
        objPDK.PDK_Location_Fab__c = 'test Name';
        objPDK.PDK_Specification_Owner__c = 'e13873';       
        objPDK.PDK_Sub_class__c = 'test Name';
        objPDK.PDK_Version__c = 'ver 1.0';
        objPDK.Tech_Geometry__c = 'test Name';
        objPDK.Technology__c = 'test Name';
        objPDK.PDK_ID__c = 'test Name';
        objPDK.Is_Latest_Version__c = true;       
        insert objPDK;
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 66555;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
            
        list<clsIntegrationUtil.wrapperPDKPatch> lstWrapper = new list<clsIntegrationUtil.wrapperPDKPatch>();
        clsIntegrationUtil.wrapperPDKPatch objWrapper = new clsIntegrationUtil.wrapperPDKPatch();
        objWrapper.openTextId = 66555;
        objWrapper.parentId = 55666;
        objWrapper.pdkPatchId = 'PDK-600021';
        objWrapper.description = 'PDK-600021';
        objWrapper.pdkPatchDoctitle = 'PDK-600021';
        objWrapper.parentPdkVersion = 'PDK-600021';
        objWrapper.technology = 'PDK-600021';
        objWrapper.techGeometry = 'PDK-600021';
        objWrapper.pdkPatchLifecyclePhase = 'PDK-600021';
        objWrapper.pdkPatchLocationFab = 'PDK-600021';
        objWrapper.pdkPatchSubClass = 'PDK-600021';
        objWrapper.pdkPatchSpecificationOwner = 'PDK-600021';
        objWrapper.pdkPatchFunctionalOwnership = 'PDK-600021';
        objWrapper.pdkVersion = 'PDK-600021';
        objWrapper.pdkRevision = 'PDK-600021';
        objWrapper.pdkSpecificationType = 'PDK-600021';
        objWrapper.pdkParentPDKId = 'PDK-600021';
        lstWrapper.add(objWrapper);
        
        test.startTest();
        clsIntegrationUtil.integratePDKPatch(lstWrapper);
        test.StopTest();
        }
    }
  
  static testMethod void testNullCalls()
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
      // DataUtilTest.loadEnvironmentVariables();
      
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper1 = new list<clsIntegrationUtil.WrapperDesignSpec>();
        list<clsIntegrationUtil.wrapperWhiteList> lstWrapper2 = new list<clsIntegrationUtil.wrapperWhiteList>();
        list<clsIntegrationUtil.wrapperPDK> lstWrapper3 = new list<clsIntegrationUtil.wrapperPDK>();    
        list<clsIntegrationUtil.wrapperPDKPatch> lstWrapper4 = new list<clsIntegrationUtil.wrapperPDKPatch>();
        
        test.startTest();
        clsIntegrationUtil.integrateSpec(lstWrapper1);
        clsIntegrationUtil.integrateWhiteList(lstWrapper2);
        clsIntegrationUtil.integratePDK(lstWrapper3);
        clsIntegrationUtil.integratePDKPatch(lstWrapper4);
        test.StopTest();
        }
    }
    static testMethod void testNDASyncOnAccCreationInOT(){
    
     User runningUser = [
                SELECT      Id
                FROM        User
                WHERE       Profile.Name = 'System Administrator'
                            AND UserRoleId != null
                            AND IsActive = true
                LIMIT 1
            ];
            
    System.runAs(runningUser) {
   // DataUtilTest.loadEnvironmentVariables();

    Account accntObj = getAccount('MYTEST ACCOUNT1');

    Test.startTest();
    clsIntegrationUtil.updateAccOnCreationInOT('01p900000036UW','testAcc',true);
    clsIntegrationUtil.updateAccOnCreationInOT('01p900000036UW','test',true);
    clsIntegrationUtil.updateAccOnCreationInOT(null,'test',true);
    Test.stopTest();
    }

}
     static testMethod void testNullCalls2()
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
        list<clsIntegrationUtil.WrapperDesignSpec> lstWrapper1 = new list<clsIntegrationUtil.WrapperDesignSpec>();
        list<clsIntegrationUtil.wrapperWhiteList> lstWrapper2 = new list<clsIntegrationUtil.wrapperWhiteList>();
        list<clsIntegrationUtil.wrapperPDK> lstWrapper3 = new list<clsIntegrationUtil.wrapperPDK>();    
        list<clsIntegrationUtil.wrapperPDKPatch> lstWrapper4 = new list<clsIntegrationUtil.wrapperPDKPatch>();
        
        list<White_List__c> delWhiteList = new list<White_List__c>();
        delWhiteList  = [SELECT ID FROM White_List__c];
        delete delWhiteList;
        test.startTest();
        clsIntegrationUtil.integrateWhiteList(lstWrapper2); 
        clsIntegrationUtil.WrapperDesignSpec wDesignSpec = new clsIntegrationUtil.WrapperDesignSpec();
        clsIntegrationUtil.wrapperWhiteList wWhitelist = new clsIntegrationUtil.wrapperWhiteList(); 
        clsIntegrationUtil.wrapperPDK wPdk =  new clsIntegrationUtil.wrapperPDK();
        clsIntegrationUtil.wrapperPDKPatch wPdkpatch = new clsIntegrationUtil.wrapperPDKPatch();
               
        test.StopTest();
        
    }
  }  
  
  private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id,Name,sub_type__c,site_department__c,transaction_type__c,region__c,
                        Corporate_Address_1__c,Corporate_City__c,Corporate_Country__c,Fab_9_10__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
    
}