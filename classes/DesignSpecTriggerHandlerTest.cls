/*
Type Name: DesignSpecTriggerHandlerTest
Author: Cognizant
Created Date: 24-April-2013
Reason: This is the Test class for class DesignSpecTriggerHandler. 
Change History:
Author: Cognizant 
Modified Date: 9/1/2014rem
Reason: Change in the PDK name 
??..
??..
Change History:Changing Spec Owner field in document provisioning record for change of owner for parent specification record
Author: Cognizant 
Modified Date: 27/01/2014
Reason: Case#00004561:  Subject: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
*/
@isTest(seeAllData=false)
public class DesignSpecTriggerHandlerTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('Short_Name__c', 'TAC1');        
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
    static testMethod void testmergeInternalReleaseRecords()
    {      
          
          RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
          
          User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
          set<Id> setDSIds = new set<Id>();
          Account accntObj ;
          Contact conobj;
          
          
          accntObj = getAccount('MYTEST ACCOUNT1'); 
         
          conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');           
          insert conobj;         
          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
                     

          System.runAs(admUser){
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
         }
        
        test.startTest();  
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
        objDesignSpec.Specification_Release_List_Long__c= 'intel;amd'; // CR # 4562 ? Field replaced
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
        setDSIds.add(objDesignSpec.Id);
               
        List<White_List__c> lstWhiteList = new List<White_List__c>();       
        White_List__c wl1 = new White_List__c();
        wl1.Design_Spec__c = objDesignSpec.Id;
        wl1.Account__c = accntObj.Id;
        wl1.RecordTypeId = recTypeDS.Id;
        lstWhiteList.add(wl1);   
        insert lstWhiteList;
        
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'TestTeamRoom';
        tm.Team_Room_Description__c = 'Test Description';
        insert tm;
        
        List<Team_Room_Doc__c> lstTeamRoomDoc = new List<Team_Room_Doc__c>();
        Team_Room_Doc__c tmd1 = new Team_Room_Doc__c();
        tmd1.Team_Room__c = tm.id;
        tmd1.Design_Spec__c = objDesignSpec.Id;
        lstTeamRoomDoc.add(tmd1);
        insert lstTeamRoomDoc;
        
        
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        //dp2.User__c = portalUser.Id;
        dp2.Design_Spec__c = objDesignSpec.Id;
        dp2.Sub_PDK__c= null;
        dp2.Status__c = 'Provisioned';
        
        dp2.Acc_Short_Name__c='intel';
        insert dp2; 
        
        objDesignSpec.Specification_Release_List_Long__c= 'gf';
        update objDesignSpec;
        
        
        DesignSpecTriggerHandler.mergeInternalReleaseRecords(setDSIds);
        system.assertEquals(objDesignSpec.Specification_Release_List_Long__c,'gf');
        test.stopTest();        
    }
    
    static testMethod void testprovOnStatusChageToSAR()
    {      
                   
          Account accntObj = getAccount('MYTEST ACCOUNT1');          
           
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');
            Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design');      
            lstContact.add(conobj);
            lstContact.add(conobj2);
            insert lstContact;          
              
          User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
           

        List<User> lstUsers = new List<User>();
        set<String> setUserIds = new set<String>();
        System.runAs(admUser){
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
        User portalUser2 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser2@testorg.com',
                                                Alias = 'auser2',
                                                Email='portaluser2@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Wayne',
                                                Lastname='Bruce',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj2.id,
                                                Portal_Login__c='def12'
                                                

                                               );
        lstUsers.add(portalUser);
        lstUsers.add(portalUser2);                                       
        
        test.startTest();
        
        insert lstUsers;
        }        
               
        list<Design_Spec__c> listSTFs = new list<Design_Spec__c>(); 
        Set<Id> SetOfDSIds=new Set<Id>();    
           
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
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        objDesignSpec.Release_Status__c = 'Internal Use Only';                            
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 54322;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'test rev';
        objDesignSpec2.Lifecycle_Phase__c = 'test phase';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm;testplm2'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List';                                    
        listSTFs.add(objDesignSpec);
        listSTFs.add(objDesignSpec2);
        SetOfDSIds.add(objDesignSpec2.id);
        SetOfDSIds.add(objDesignSpec.id);
        insert listSTFs;
         
         
        PDK__c objPDK1 = new PDK__c();
        objPDK1.Name = 'Test1';
        objPDK1.OpenText_ID__c = 342231;
        objPDK1.Description__c = 'TestDescription1';
        objPDK1.Old_Revision_ID__c = 34211; 
        objPDK1.PDK_DocTitle__c = '';
        insert objPDK1;
         
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'TestName';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK1.Id;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';                             
        insert objSubPDK;
        
        List<Sub_PDK_Spec__c>  subPDKSpecList=new  List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objSpec=new Sub_PDK_Spec__c ();
        objSpec.Design_Spec__c =objDesignSpec2.Id;
        objSpec.Sub_PDK__c=objSubPDK.Id;
        subPDKSpecList.add(objSpec);

        
        Sub_PDK_Spec__c objSpec1=new Sub_PDK_Spec__c ();
        objSpec1.Design_Spec__c =objDesignSpec.Id;
        objSpec1.Sub_PDK__c=objSubPDK.Id;
        subPDKSpecList.add(objSpec1);
  
        insert subPDKSpecList; 
        
        objDesignSpec2.Release_Status__c = 'Specific Account Release';   
        update objDesignSpec2;
        
        DesignSpecTriggerHandler.provOnStatusChageToSAR(SetOfDSIds);
        
        objDesignSpec2.Release_Status__c = 'Release To White List';   
        update objDesignSpec2;
        DesignSpecTriggerHandler.provOnStatusChageToWL(SetOfDSIds);
        
        objDesignSpec.Release_Status__c = 'Release To White List';    
        update objDesignSpec;
        
        DesignSpecTriggerHandler.provOnStatusChageToWLfromInternal(SetOfDSIds);
        
        objDesignSpec.Release_Status__c = 'Internal Use Only';    
        update objDesignSpec;
        system.assertEquals(objDesignSpec.Release_Status__c,'Internal Use Only');
        DesignSpecTriggerHandler.deProvisionInternalSpecs(SetOfDSIds);
        DesignSpecTriggerHandler.deProvisionWhiteListSpecs (SetOfDSIds);
        test.stopTest();        
    }
    static testMethod void testshareSpectoPLMlist()
    {      
                 
          Account accntObj = getAccount('MYTEST ACCOUNT1');         
           
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');
            Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design');      
            lstContact.add(conobj);
            lstContact.add(conobj2);
            insert lstContact;          
              
          User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
           

        List<User> lstUsers = new List<User>();
        set<String> setUserIds = new set<String>();
        System.runAs(admUser){
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
        User portalUser2 = new User( ProfileId = profile1.Id,
                                                Username = 'portaluser2@testorg.com',
                                                Alias = 'auser2',
                                                Email='portaluser2@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Wayne',
                                                Lastname='Bruce',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj2.id,
                                                Portal_Login__c='def12'
                                                

                                               );
        lstUsers.add(portalUser);
        lstUsers.add(portalUser2);                                       
        
        test.startTest();
        
        insert lstUsers;
        }        
               
        list<Design_Spec__c> listSTFs = new list<Design_Spec__c>();          
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
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 54322;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'test rev';
        objDesignSpec2.Lifecycle_Phase__c = 'test phase';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm;testplm2'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List';                                    
        listSTFs.add(objDesignSpec);
        listSTFs.add(objDesignSpec2);
        insert listSTFs;
         
         
        PDK__c objPDK1 = new PDK__c();
        objPDK1.Name = 'Test1';
        objPDK1.OpenText_ID__c = 342231;
        objPDK1.Description__c = 'TestDescription1';
        objPDK1.Old_Revision_ID__c = 34211; 
        objPDK1.PDK_DocTitle__c = '';
        insert objPDK1;
         
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'TestName';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK1.Id;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';                             
        insert objSubPDK;
        
        List<Sub_PDK_Spec__c>  subPDKSpecList=new  List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objSpec=new Sub_PDK_Spec__c ();
        objSpec.Design_Spec__c =objDesignSpec2.Id;
        objSpec.Sub_PDK__c=objSubPDK.Id;
        subPDKSpecList.add(objSpec);

        
        Sub_PDK_Spec__c objSpec1=new Sub_PDK_Spec__c ();
        objSpec1.Design_Spec__c =objDesignSpec.Id;
        objSpec1.Sub_PDK__c=objSubPDK.Id;
        subPDKSpecList.add(objSpec1);

        insert subPDKSpecList; 
        system.assertEquals(objSpec1.Design_Spec__c,objDesignSpec.Id);
        DesignSpecTriggerHandler.shareSpectoPLMlist(listSTFs);
        DesignSpecTriggerHandler.addAccProvToSTF(listSTFs);
        
        test.stopTest();        
    }
    
    static testMethod void testdeProvisionObsoleteSpec()
    {      
                   
          Account accntObj = getAccount('MYTEST ACCOUNT1');
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            
            lstContact.add(conobj);
  
           insert lstContact;   
          
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
                  
                User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
                User portalUser ;
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
        System.runAs(admUser){
        portalUser = new User( ProfileId = profile1.Id,
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
        lstUsers.add(portalUser);   
        insert lstUsers; 
        }
        setUserIds.add(portalUser.Id); 
        
    
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        
        list<Design_Spec__c> listDSs = new list<Design_Spec__c>();
        set<Id> setDSIds = new set<Id>();          
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 54322;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'test rev';
        objDesignSpec2.Lifecycle_Phase__c = 'test phase';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm;testplm2'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List'; 
        objDesignSpec2.PDK__c = objPDK.Id;                                                           
        listDSs.add(objDesignSpec);
        listDSs.add(objDesignSpec2);
        insert listDSs;
        setDSIds.add(objDesignSpec.Id);
        setDSIds.add(objDesignSpec2.Id);
        system.assertEquals(objDesignSpec2.Name,'Test Name');
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Status__c = 'Sent for Approval';
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Design_Spec__c = objDesignSpec2.Id;
        dp2.Status__c = 'Sent for Approval';
        dp2.Spec_Owner__c = portalUser.Id;
        listDP.add(dp);
        listDP.add(dp2);                  
        insert listDP;
        
        Set<Id> setOfDpIds = new Set<Id>();
        setOfDpIds.add(dp2.Id);
        
        test.startTest(); 
        DesignSpecTriggerHandler.deProvisionObsoleteSpec(listDSs, setDSIds);
        DesignSpecTriggerHandler.provisionReleasedSpec(listDSs, setDSIds);
        DesignSpecTriggerHandler.removeProvisioningForInactiveUsers(setUserIds);
        DesignSpecTriggerHandler.removeProvisioningForInactiveUsersFuture(setUserIds);
        DesignSpecTriggerHandler.deProvisionInternalSpecs(setDSIds);
        DesignSpecTriggerHandler.getApprovalProcessComments(setOfDpIds);
        DesignSpecTriggerHandler.submitApprovalProcessHighVolume(listDP);
               
        test.stopTest();        
    }
    
    static testMethod void testreassignSpecsToPDK()
    {      
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            lstContact.add(conobj);
            insert lstContact;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
                     
            User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
            User portalUser ;
           
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
         System.runAs(admuser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers;
        } 
        setUserIds.add(portalUser.Id);
        
        Set<Id> setPDKIds = new Set<Id>();
        Map<Id, String> mapPDKIdsToNames = new Map<Id, String>();                  
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = ''; //added by cognizant
        insert objPDK;
        setPDKIds.add(objPDK.Id);
        mapPDKIdsToNames.put(objPDK.Id,objPDK.Name);
/*----------------added by cognizant----------------------------------------------------------*/        
        PDK__c objPDK1 = new PDK__c();
        objPDK1.Name = 'Test1';
        objPDK1.OpenText_ID__c = 342231;
        objPDK1.Description__c = 'TestDescription1';
        objPDK1.Old_Revision_ID__c = 34211; 
        objPDK1.PDK_DocTitle__c = '';
        insert objPDK1;
        
        mapPDKIdsToNames.put(objPDK1.Id,objPDK1.Name);
  
        Set<String> setofspecids= new Set<String>();//added by cognizant
        List<PDK_Patch__c> lstPatch =new List<PDK_Patch__c>();//added by cognizant
        Set<String> setSubPDKIds = new Set<String>();//added by cognizant
        String PDKVersion;//added by cognizant
/*---------------------------------------------------------------------------------------------*/              
        Set<Id> setPDKPatchIds = new Set<Id>(); 
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK.Id;
        objPatch.PDK_Version__c='Ver1.0';//added by cognizant
        
/*-------------------------------added by cognizant----------------------------*/        
       // insert objPatch;//commented by cognizant
        
        PDK_Patch__c objPatch1 = new PDK_Patch__c();
        objPatch1.Name = 'Test';
        objPatch1.OpenText_ID__c = 34214;
        objPatch1.PDK__c = objPDK.Id;
        objPatch1.PDK_Version__c='';//added by cognizant
        
        lstPatch.add(objPatch);//added by cognizant
        lstPatch.add(objPatch1);//added by cognizant
        insert lstPatch;//added by cognizant
 /*-------------------------------------------------------------------------------*/       
        setPDKPatchIds.add(objPatch.Id);
        setPDKPatchIds.add(objPatch1.Id);//added by cognizant

        list<Design_Spec__c> listDSs = new list<Design_Spec__c>();
        set<Id> setDSIds = new set<Id>();          
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 5541;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        objDesignSpec.PDK_Patch__c =  objPatch.Id;
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 5432122;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'test rev';
        objDesignSpec2.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List';
        objDesignSpec2.PDK__c =  objPDK.Id;
        listDSs.add(objDesignSpec);
        listDSs.add(objDesignSpec2);
        insert listDSs;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'TestName';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK.Id;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';                             
        insert objSubPDK;
        setSubPDKIds.add(objSubPDK.Id);//added by cognizant
/*-----------------------added by cognizant------------------------------------------------------------*/ 

        Sub_PDK__c objSubPDK1 = new Sub_PDK__c(); 
        objSubPDK1.Name = 'Test1';
        objSubPDK1.Release_Status__c = 'Release To White List';
        objSubPDK1.PDK__c = objPDK1.Id;
        objSubPDK1.Bundle_Name__c = 'test Bundle Name12121';                             
        insert objSubPDK1;
        setSubPDKIds.add(objSubPDK1.Id);//added by cognizant
     
        
        Design_Spec__c objDesignSpec1 = new Design_Spec__c();       
        objDesignSpec1.OpenText_ID__c = 543211;
        objDesignSpec1.Name = 'Test Name11';
        objDesignSpec1.Document_Title__c = 'Test Title1';
        objDesignSpec1.Old_Revision_ID__c = 123451;
        objDesignSpec1.ParentID__c = null;
        objDesignSpec1.Document_Number__c = 'Test DocNum';       
        objDesignSpec1.Revision__c = 'test rev';
        objDesignSpec1.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec1.Location_Fab__c = 'test fab';        
        objDesignSpec1.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
        objDesignSpec1.Functional_Ownership__c = 'test func owner';
        objDesignSpec1.Specification_Type__c = 'DRC';
        objDesignSpec1.Technology_Type__c = 'test tech type';
        objDesignSpec1.Technology_Geometry__c = 'test tech geo';
        objDesignSpec1.Source__c = 'test source';
        objDesignSpec1.PDK_Version__c = 'test pdkversion';
        objDesignSpec1.DE_Version__c = 'test de version';
        objDesignSpec1.Specification_sub_class__c = 'test subclass';
        objDesignSpec1.Is_Latest_Revision__c = true;
        objDesignSpec1.Specification_Owner__c = 'e13873';       
        objDesignSpec1.Commodity_Type_for_material_spec__c = 'test commodity1';
        objDesignSpec1.Release_Status__c = 'Release To White List';
        objDesignSpec1.PDK_Patch__c =  objPatch1.Id;
        
        insert objDesignSpec1;
        
        
     /***************Added By Cognizant***********/ 
        List<Sub_PDK_Spec__c>  subPDKSpecList=new  List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objSpec=new Sub_PDK_Spec__c ();
        objSpec.Design_Spec__c =objDesignSpec2.Id;
        objSpec.Sub_PDK__c=objSubPDK.Id;
        subPDKSpecList.add(objSpec);
        setofspecids.add(objSpec.id);
        
        Sub_PDK_Spec__c objSpec1=new Sub_PDK_Spec__c ();
        objSpec1.Design_Spec__c =objDesignSpec.Id;
        objSpec1.Sub_PDK__c=objSubPDK1.Id;
        subPDKSpecList.add(objSpec1);
        setofspecids.add(objSpec1.id);
        
        Sub_PDK_Spec__c objSpec2=new Sub_PDK_Spec__c ();
        objSpec2.Design_Spec__c =objDesignSpec1.Id;
        objSpec2.Sub_PDK__c=objSubPDK1.Id;
        subPDKSpecList.add(objSpec2);
        setofspecids.add(objSpec2.id);
        
        insert subPDKSpecList;
       
         PDKVersion=objPatch.PDK_Version__c;
         
         
        
/*------------------------------------------------------------------------------------------------------------------*/        
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Sub_PDK__c = objSubPDK.Id;
        listDP.add(dp); 
        listDP.add(dp2);                 
        insert listDP;
        test.startTest();
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);
/*------------------------added by cognizant------------------------------------------*/        
    /*
        objSubPDK.Bundle_Name__c = 'test Bundle1 Name11';    
        update objSubPDK;   
        objSubPDK1.Bundle_Name__c = 'test Bundle1 Name1';    
        update objSubPDK1;  
     */ 
        objPDK1.name = 'test12';
        objPDK1.PDK_DocTitle__c = 'test1 test1';
        update objPDK1;
        
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);
        //objSubPDK1.Bundle_Name__c = 'test Bundle1 Name2';    
        //update objSubPDK1; 
        
        Set<Id>  setPDKIdsRevisionChanged = new Set<Id>();
        
        setPDKIdsRevisionChanged.add(objPDK1.Id);
              
        objPDK1.PDK_Version__c= '2.0ver';
        update objPDK1;
    
        
        DesignSpecTriggerHandler.reassignSpecsToPDK(setPDKIdsRevisionChanged);
        
        Set<Id>  setPDKIdsObsolete= new Set<Id>();
        objPDK1.PDK_Lifecycle_Phase__c= 'Obsolete';
        update objPDK1;
        setPDKIdsObsolete.add(objPDK1.id);
        DesignSpecTriggerHandler.deprovisionAllForObsoletePDK(setPDKIdsObsolete);
        
        delete objSpec;
        
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);
      
        delete objSpec1;
        
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);
      
        delete objSpec2;
        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);
        
        objPatch.PDK_Version__c='';
        update objPatch;
        

        DesignSpecTriggerHandler.modifySubPDKName(mapPDKIdsToNames);


        
/*-------------------------------------------------------------------------------*/        
        DesignSpecTriggerHandler.deprovisionAllForObsoletePDK(setPDKIds);
        DesignSpecTriggerHandler.deprovisionAllForObsoletePDKPatch(setPDKPatchIds);
        DesignSpecTriggerHandler.reassignSpecsToPDK(setPDKIds); 
       // DesignSpecTriggerHandler.generateNameList('intel;is');
       // DesignSpecTriggerHandler.generateNameList('intel1');//added by cognizant
         
        test.stopTest();        
    }
    
   static testMethod void testdeprovisionForWhiteListDeletion()
    {      
        
        RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
        RecordType recTypePCK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Package'];
        RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
        set<String> setAccIds = new set<String>();  
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        setAccIds.add(accntObj.Id); 
      
        List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
        lstContact.add(conobj);
        insert lstContact;          
          
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
          
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
        User portalUser ;
       
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
         System.runAs(admuser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers;
        } 
        setUserIds.add(portalUser.Id);
        
        Set<Id> setPDKIds = new Set<Id>();                  
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        setPDKIds.add(objPDK.Id);
        
        list<Design_Spec__c> listDSs = new list<Design_Spec__c>();
        set<Id> setDSIds = new set<Id>();          
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        objDesignSpec.Accounts_Provisioned_To__c = accntObj.Name;//added by cognizant
        listDSs.add(objDesignSpec);
        insert listDSs;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'Test Name';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK.Id;    
        objSubPDK.Accounts_Provisioned_To__c = accntObj.Name;//added by cognizant                        
        insert objSubPDK;
       
        test.startTest();
        
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';   
        objPck.Accounts_Provisioned_To__c = accntObj.Name;//added by cognizant                                  
        insert objPck;
        
        List<White_List__c> lstWhiteList = new List<White_List__c>();       
        White_List__c wl1 = new White_List__c();
        wl1.Design_Spec__c = objDesignSpec.Id;
        wl1.Account__c = accntObj.Id;
        wl1.RecordTypeId = recTypeDS.Id;
        White_List__c wl2 = new White_List__c();
         wl2.Design_Spec__c = objDesignSpec.Id;
        wl2.Package__c = objPck.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypePCK.Id;
        White_List__c wl3 = new White_List__c();
         wl3.Design_Spec__c = objDesignSpec.Id;
        wl3.Sub_PDK__c = objSubPDK.Id;
        wl3.Account__c = accntObj.Id;
        wl3.RecordTypeId = recTypeSPDK.Id;
        /*Added By Cognizant starts*/
           White_List__c wl4 = new White_List__c();
         //wl4.Design_Spec__c = objDesignSpec.Id;
        wl4.Sub_PDK__c = objSubPDK.Id;
        wl4.Account__c = accntObj.Id;
        wl4.RecordTypeId = recTypeSPDK.Id;
   White_List__c wl5 = new White_List__c();
         //wl4.Design_Spec__c = objDesignSpec.Id;
        wl5.Package__c = objPck.Id;
        wl5.Account__c = accntObj.Id;
        wl5.RecordTypeId = recTypePCK.Id;
/*Added By Cognizant ends*/
        lstWhiteList.add(wl1);
        lstWhiteList.add(wl2);
       lstWhiteList.add(wl3); 
/*Added By Cognizant starts*/
         lstWhiteList.add(wl4);
       lstWhiteList.add(wl5);
/*Added By Cognizant ends*/      
        insert lstWhiteList;
        
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Sub_PDK__c = objSubPDK.Id;
        dp2.Design_Spec__c = objDesignSpec.Id;
        Document_Provisioning__c dp3 = new Document_Provisioning__c ();
        dp3.User__c = portalUser.Id;
        dp3.Design_Package__c = objPck.Id;
        dp3.Design_Spec__c = objDesignSpec.Id;
    
    /*Added By Cognizant starts*/
     Document_Provisioning__c dp4 = new Document_Provisioning__c ();
        dp4.User__c = portalUser.Id;
        dp4.Design_Package__c = objPck.Id;
       
    Document_Provisioning__c dp5 = new Document_Provisioning__c ();
        dp5.User__c = portalUser.Id;
        dp5.Sub_PDK__c = objSubPDK.Id;
    /*Added By Cognizant ends*/
        listDP.add(dp); 
        listDP.add(dp2);
        listDP.add(dp3);
/*Added By Cognizant starts*/
    listDP.add(dp4);
        listDP.add(dp5); 
/*Added By Cognizant ends*/                 
        insert listDP;
        
        DesignSpecTriggerHandler.deprovisionForWhiteListDeletion(lstWhiteList);
        //DesignSpecTriggerHandler.addAccountProvisionedTo(listDP); //Uncommented By Cognizant for Code coverage
        //DesignSpecTriggerHandler.removeAccountProvisionedTo(listDP,setAccIds);
        test.stopTest();        
    }
    
    static testMethod void testdeassociateSpecFromSubPDK()
    {      
          
        Account accntObj = getAccount('MYTEST ACCOUNT1');
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            lstContact.add(conobj);
            insert lstContact;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
        User portalUser ;
        
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
         System.runAs(admuser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers;
        } 
        setUserIds.add(portalUser.Id);
        
        Set<Id> setPDKIds = new Set<Id>();                  
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        insert objPDK;
        setPDKIds.add(objPDK.Id);
      
        list<Design_Spec__c> listDSs = new list<Design_Spec__c>();
        set<Id> setDSIds = new set<Id>();          
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54321;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        objDesignSpec.PDK__c =  objPDK.Id;
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 5432332;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'test rev';
        objDesignSpec2.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List';
        objDesignSpec2.PDK__c =  objPDK.Id;
        listDSs.add(objDesignSpec);
        listDSs.add(objDesignSpec2);
        insert listDSs;
        
        test.startTest();
        List<Sub_PDK__c> lstSPDK = new List<Sub_PDK__c>();
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'Test Name';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK.Id;
        Sub_PDK__c objSubPDK2 = new Sub_PDK__c(); 
        objSubPDK2.Name = 'Test Name';
        objSubPDK2.Release_Status__c = 'Release To White List';
        objSubPDK2.PDK__c = objPDK.Id;
        lstSPDK.add(objSubPDK);  
        lstSPDK.add(objSubPDK2);                            
        insert lstSPDK;
        
        List<Sub_PDK_Spec__c> lstSPS = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Design_Spec__c = objDesignSpec.Id;
        objsps.Sub_PDK__c = objSubPDK.Id;
        Sub_PDK_Spec__c objsps2 = new Sub_PDK_Spec__c();
        objsps2.Design_Spec__c = objDesignSpec2.Id;
        objsps2.Sub_PDK__c = objSubPDK.Id;
        Sub_PDK_Spec__c objsps3 = new Sub_PDK_Spec__c();
        objsps3.Design_Spec__c = objDesignSpec2.Id;
        objsps3.Sub_PDK__c = objSubPDK2.Id;
        lstSPS.add(objsps);
        lstSPS.add(objsps2);          
        insert lstSPS;
        insert objsps3;
                
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Sub_PDK_Provisioned_for__c = objSubPDK.Id;
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Design_Spec__c = objDesignSpec2.Id;
        dp2.Sub_PDK_Provisioned_for__c = objSubPDK.Id+';'+objSubPDK2.Id;
        listDP.add(dp);
        listDP.add(dp2);                 
        insert listDP;
        
        
        DesignSpecTriggerHandler.deassociateSpecFromSubPDK(lstSPS);
        
        test.stopTest();        
    }
    
    static testMethod void testassignOldSpecToLockedPackage()
    {      
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            lstContact.add(conobj);
            insert lstContact;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
            User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
           User portalUser ;
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
        System.runAs(admuser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers; 
        }
        setUserIds.add(portalUser.Id);
        
        Map<Decimal,String> mapRevisionIdsToIds = new Map<Decimal,String>();
        list<Design_Spec__c> listDSs = new list<Design_Spec__c>(); 
        list<Design_Spec__c> listDSpecs = new list<Design_Spec__c>();        
        set<Id> setDSIds = new set<Id>();          
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 54324;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 54325;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum';       
        objDesignSpec.Revision__c = 'rev 1.0';
        objDesignSpec.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
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
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();       
        objDesignSpec2.OpenText_ID__c = 54323;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 54324;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';       
        objDesignSpec2.Revision__c = 'rev 2.0';
        objDesignSpec2.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec2.Location_Fab__c = 'test fab';        
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm'; // CR # 4562 ? Field replaced
        objDesignSpec2.Functional_Ownership__c = 'test func owner';
        objDesignSpec2.Specification_Type__c = 'DRC';
        objDesignSpec2.Technology_Type__c = 'test tech type';
        objDesignSpec2.Technology_Geometry__c = 'test tech geo';
        objDesignSpec2.Source__c = 'test source';
        objDesignSpec2.PDK_Version__c = 'test pdkversion';
        objDesignSpec2.DE_Version__c = 'test de version';
        objDesignSpec2.Specification_sub_class__c = 'test subclass';
        objDesignSpec2.Is_Latest_Revision__c = true;
        objDesignSpec2.Specification_Owner__c = 'e13873';       
        objDesignSpec2.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec2.Release_Status__c = 'Release To White List';
        listDSs.add(objDesignSpec);
        listDSs.add(objDesignSpec2);
        insert listDSs;
        mapRevisionIdsToIds.put(objDesignSpec2.Old_Revision_ID__c,objDesignSpec2.Id);
        listDSpecs.add(objDesignSpec2);
        setDSIds.add(objDesignSpec2.Id);
        
        test.startTest();
        
        List<Package__c> listPck = new List<Package__c>();
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List'; 
        objPck.Locked__c  = true; 
        listPck.add(objPck);
/*-----------------------------added by cognizant-------------------------------------------------------------*/        
        Package__c objPck1 = new Package__c();
        objPck1.Name = 'Test Name';
        objPck1.Package_Release_Status__c = 'Release To White List'; 
        listPck.add(objPck1);
   
/*---------------------------------------------------------------------------------------------------------------*/        
        Package__c objPck2 = new Package__c();
        objPck2.Name = 'Test Name';
        objPck2.Package_Release_Status__c = 'Release To White List'; 
        
        listPck.add(objPck2);                       
        insert listPck;
        
        Package_Spec__c objps = new Package_Spec__c();
        objps.Design_Spec__c = objDesignSpec2.Id;
        objps.Package__c = objPck.Id;        
        insert objps;
                
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec2.Id;
        dp.Packages_Provisioned_for__c = objPck.Id+';'+objPck2.Id;
        dp.Spec_Level_Provisioning__c= true;//added by cognizant
        listDP.add(dp);
/*---------------------------added by cognizant---------------------------------------------------------------------*/        
        Document_Provisioning__c dp1 = new Document_Provisioning__c ();
        dp1.User__c = portalUser.Id;
        dp1.Design_Spec__c = objDesignSpec2.Id;
        dp1.Packages_Provisioned_for__c = objPck.Id;
        
        
        listDP.add(dp1);   
/*-------------------------------------------------------------------------------------------------------------------*/                      
        insert listDP;
        
        DesignSpecTriggerHandler.assignOldSpecToLockedPackage(listDSpecs, setDSIds, mapRevisionIdsToIds);
        test.stopTest();        
    }
    
    static testMethod void testTeamRoomProvisioning()
    {    
          
        RecordType recTypeTRExt = [SELECT Id,Name FROM RecordType where SobjectType='Team_Room__c' AND Name = 'GLOBALFOUNDRIES with Multi-Party'];
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            lstContact.add(conobj);
            insert lstContact;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
            User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
            User portalUser ;
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
        System.runAs(admuser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers; 
        }
        setUserIds.add(portalUser.Id);
        
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'TestTeamRoom';
        tm.Team_Room_Description__c = 'Test Description';
        tm.RecordTypeId = recTypeTRExt.Id;
        insert tm;
        
        List<Team_Room_Member__c> lstTeamRoomMember = new List<Team_Room_Member__c>();
        Team_Room_Member__c trm = new Team_Room_Member__c();
        trm.Team_Room__c = tm.Id;
        trm.User__c = portalUser.Id;
        trm.Team_Room_Role__c = 'Moderator';
        lstTeamRoomMember.add(trm);
        insert lstTeamRoomMember;
        
        test.startTest(); 
        DesignSpecTriggerHandler.createTeamRoomProvisioningByAddingMembers(lstTeamRoomMember);
        DesignSpecTriggerHandler.teamRoomDeprovisioningByRemovingMembers(lstTeamRoomMember);//added by cognizant
        test.stopTest();        
    }
    
    static testMethod void testTeamRoomProvisioningByDocs()
    {      
          
        Account accntObj = getAccount('MYTEST ACCOUNT1'); 
          
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');     
            lstContact.add(conobj);
            insert lstContact;          
              
          Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];
            
        User admUser=[select id from User where Profile.name like '%system admin%' and isActive=true limit 1];
                        User portalUser ;
        List<User> lstUsers = new List<User>();
        set<Id> setUserIds = new set<Id>();
        System.runAs(admUser){
        portalUser = new User( ProfileId = profile1.Id,
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
      
        lstUsers.add(portalUser);                                  
        insert lstUsers;
        } 
        setUserIds.add(portalUser.Id);
        
        Team_Room__c tm = new Team_Room__c();
        tm.name = 'TestTeamRoom';
        tm.Team_Room_Description__c = 'Test Description';
        insert tm;

        
        test.startTest(); 
               
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
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 ? Field replaced
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
        
       
        Package__c objPck = new Package__c();
        objPck.Name = 'Test Name';
        objPck.Package_Release_Status__c = 'Release To White List';                             
        insert objPck;
        
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'Test Name';
        objSubPDK.Release_Status__c = 'Release To White List';                             
        insert objSubPDK;
        
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
       
        DesignSpecTriggerHandler.createTeamRoomProvisioningByAddingDocs(lstTeamRoomDoc);
        /*Added By Cognizant starts*/
    List<Document_Provisioning__c> docProvList=new List<Document_Provisioning__c>();
    Document_Provisioning__c dp1 = new Document_Provisioning__c ();
        dp1.User__c = portalUser.Id;
        dp1.Design_Spec__c = objDesignSpec.Id;
dp1.Team_Rooms_Provisioned_for__c=tm.id;
    dp1.Status__c = 'Provisioned';
Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Sub_PDK__c = objSubPDK.Id;
dp2.Team_Rooms_Provisioned_for__c=tm.id;
    dp2.Status__c = 'Provisioned';
Document_Provisioning__c dp3 = new Document_Provisioning__c ();
        dp3.User__c = portalUser.Id;
        dp3.Design_Package__c = objPck.Id;
dp3.Team_Rooms_Provisioned_for__c=tm.id;
    dp3.Status__c = 'Provisioned';
docProvList.add(dp1);
docProvList.add(dp2);
docProvList.add(dp3);

insert docProvList;
    
        /*Added By Cognizant ends*/
        DesignSpecTriggerHandler.teamRoomDeprovisioningByRemovingDocs(lstTeamRoomDoc);//added by cognizant
        test.stopTest();        
    }

static testMethod void testChangedSpecOwnerDocProvisioningRecords(){
         
         
        Account accntObj = getAccount('MYTEST ACCOUNT1'); 
         
          Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1567@gf.com',Department__c='Design');           
          insert conobj;
          
          Contact conobj1=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2567@gf.com',Department__c='Development');           
          insert conobj1;

        User portalUser;
        User portalUser2;
        List<User> userList=new List<User>();
        
        User admUserObj=[select id from User where Profile.name='System Administrator' and isActive=true limit 1];
          System.runAs(admUserObj){      
        //lstUsers.add(portalUser); 
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        portalUser = new User(
                        UserRoleId = portalRole.Id,
                        ProfileId = profile1.Id,
                        Username = System.now().millisecond() + 'test2222@test.com',
                        Alias = 'batman',
                        Email='bruce.wayne@wayneenterprises.com',
                        EmailEncodingKey='UTF-8',
                        Firstname='Bruce',
                        Lastname='Wayne',
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',
                        TimeZoneSidKey='America/Chicago'
        );
        portalUser2 = new User(
                        UserRoleId = portalRole.Id,
                        ProfileId = profile1.Id,
                        Username = System.now().millisecond() + 'test3333@test.com',
                        Alias = 'batman2',
                        Email='bruce.wayne3@wayneenterprises.com',
                        EmailEncodingKey='UTF-8',
                        Firstname='Brucer',
                        Lastname='Waynes',
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',
                        TimeZoneSidKey='America/Chicago'
            );
        userList.add(portalUser);
        userList.add(portalUser2);
        insert userList;
        }
        
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
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 ? Field replaced
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
        objDesignSpec.Release_Status__c ='Specific Account Release with Spec owner Approval';
        objDesignSpec.OwnerId=portalUser.Id;                      
           Test.startTest();
        insert objDesignSpec;
        
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser.Id;
        dp2.Design_Spec__c = objDesignSpec.Id;
        dp2.Status__c = 'Sent for Approval';
        dp2.Spec_Owner__c = portalUser.Id;
        insert dp2; 
        
     
        
        /*Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;*/
        
         objDesignSpec.OwnerId=portalUser2.id;
         //objDesignSpec.Revision__c = 'test rev2';
         update objDesignSpec; 
         
         objDesignSpec.Lifecycle_Phase__c = 'obsolete';
         update objDesignSpec; 
         
          objDesignSpec.Lifecycle_Phase__c = 'test';
         update objDesignSpec;
         
         objDesignSpec.Release_Status__c ='internal use only'; 
         update objDesignSpec;
        Test.stopTest();
       
        
        
}

private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}