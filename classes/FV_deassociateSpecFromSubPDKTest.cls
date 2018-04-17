/*
Type Name: FV_deassociateSpecFromSubPDKTest
Author: Cognizant
Created Date: 12/11/2014
Reason: This is the Test class for class FV_deassociateSpecFromSubPDK and trigger SubPDKSpecTrigger. 
--
Ashwini     05152015    - Updated code for refactoring of test class.
*/

@isTest(seeAllData=false)
public class FV_deassociateSpecFromSubPDKTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
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
        fieldValueMap.put('Short_Name__c','testplm');

        AccountDataFactory.createAccount(fieldValueMap);
    }
    
    static testMethod void TestdeassociateSpecFromSubPDK()
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
        
        test.startTest();
        List<PDK__c> listofPDK=new List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.OpenText_ID__c = 3421;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 3421; 
        objPDK.PDK_DocTitle__c = ''; 
        
        PDK__c objPDK1 = new PDK__c();
        objPDK1.Name = 'Test1';
        objPDK1.OpenText_ID__c = 342111;
        objPDK1.Description__c = 'TestDescription';
        objPDK1.Old_Revision_ID__c = 34211; 
        objPDK1.PDK_DocTitle__c = 'asasas'; 
        
        PDK__c objPDK2 = new PDK__c();
        objPDK2.Name = 'Test19';
        objPDK2.OpenText_ID__c = 3421101;
        objPDK2.Description__c = 'TestDescription';
        objPDK2.Old_Revision_ID__c = 34011; 
        objPDK2.PDK_DocTitle__c = 'dfdf'; 
        
        PDK__c objPDK3 = new PDK__c();
        objPDK3.Name = 'Test191';
        objPDK3.OpenText_ID__c = 34201;
        objPDK3.Description__c = 'TestDescription';
        objPDK3.Old_Revision_ID__c = 340121; 
        objPDK3.PDK_DocTitle__c = '';
        
        listofPDK.add(objPDK);
        listofPDK.add(objPDK1);
        listofPDK.add(objPDK2);
        listofPDK.add(objPDK3);
        
        insert listofPDK;
        
        List<PDK_Patch__c> lstPatch =new List<PDK_Patch__c>();
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 3421;
        objPatch.PDK__c = objPDK1.Id;
        objPatch.PDK_Version__c='v1';
        
        PDK_Patch__c objPatch1 = new PDK_Patch__c();
        objPatch1.Name = 'Test1';
        objPatch1.OpenText_ID__c = 34211;
        objPatch1.PDK__c = objPDK1.Id;
        objPatch1.PDK_Version__c='';
        
        PDK_Patch__c objPatch2 = new PDK_Patch__c();
        objPatch2.Name = 'Test71';
        objPatch2.OpenText_ID__c = 342711;
        objPatch2.PDK__c = objPDK2.Id;
        objPatch2.PDK_Version__c='';
        
        PDK_Patch__c objPatch3 = new PDK_Patch__c();
        objPatch3.Name = 'Test713';
        objPatch3.OpenText_ID__c = 3426711;
        objPatch3.PDK__c = objPDK3.Id;
        objPatch3.PDK_Version__c='v2';
        
        
        lstPatch.add(objPatch);
        lstPatch.add(objPatch1);
        lstPatch.add(objPatch2);
        lstPatch.add(objPatch3);
        insert lstPatch;
        
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
        objDesignSpec.Specification_Release_List_Long__c = 'testplm'; 
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
        objDesignSpec1.Specification_Release_List_Long__c = 'testplm'; 
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
        objDesignSpec1.PDK_Patch__c =  objPatch.Id;
        
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
        objDesignSpec2.Specification_Release_List_Long__c = 'testplm'; 
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
        objDesignSpec2.PDK_Patch__c =  objPatch1.Id;
        
        Design_Spec__c objDesignSpec3 = new Design_Spec__c();       
        objDesignSpec3.OpenText_ID__c = 5432124;
        objDesignSpec3.Name = 'Test Nam111e';
        objDesignSpec3.Document_Title__c = 'Test Title';
        objDesignSpec3.Old_Revision_ID__c = 12345567;
        objDesignSpec3.ParentID__c = null;
        objDesignSpec3.Document_Number__c = 'Test DocNum';       
        objDesignSpec3.Revision__c = 'test rev';
        objDesignSpec3.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec3.Location_Fab__c = 'test fab';        
        objDesignSpec3.Specification_Release_List_Long__c = 'testplm'; 
        objDesignSpec3.Functional_Ownership__c = 'test func owner';
        objDesignSpec3.Specification_Type__c = 'DRC';
        objDesignSpec3.Technology_Type__c = 'test tech type';
        objDesignSpec3.Technology_Geometry__c = 'test tech geo';
        objDesignSpec3.Source__c = 'test source';
        objDesignSpec3.PDK_Version__c = 'test pdkversion';
        objDesignSpec3.DE_Version__c = 'test de version';
        objDesignSpec3.Specification_sub_class__c = 'test subclass';
        objDesignSpec3.Is_Latest_Revision__c = true;
        objDesignSpec3.Specification_Owner__c = 'e13873';       
        objDesignSpec3.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec3.Release_Status__c = 'Release To White List';
        objDesignSpec3.PDK_Patch__c =  objPatch2.Id;
        
        Design_Spec__c objDesignSpec4 = new Design_Spec__c();       
        objDesignSpec4.OpenText_ID__c = 5992124;
        objDesignSpec4.Name = 'Test Nam101e';
        objDesignSpec4.Document_Title__c = 'Test Title';
        objDesignSpec4.Old_Revision_ID__c = 12345567;
        objDesignSpec4.ParentID__c = null;
        objDesignSpec4.Document_Number__c = 'Test DocNum';       
        objDesignSpec4.Revision__c = 'test rev';
        objDesignSpec4.Lifecycle_Phase__c = 'OBSOLETE';
        objDesignSpec4.Location_Fab__c = 'test fab';        
        objDesignSpec4.Specification_Release_List_Long__c = 'testplm'; 
        objDesignSpec4.Functional_Ownership__c = 'test func owner';
        objDesignSpec4.Specification_Type__c = 'DRC';
        objDesignSpec4.Technology_Type__c = 'test tech type';
        objDesignSpec4.Technology_Geometry__c = 'test tech geo';
        objDesignSpec4.Source__c = 'test source';
        objDesignSpec4.PDK_Version__c = 'test pdkversion';
        objDesignSpec4.DE_Version__c = 'test de version';
        objDesignSpec4.Specification_sub_class__c = 'test subclass';
        objDesignSpec4.Is_Latest_Revision__c = true;
        objDesignSpec4.Specification_Owner__c = 'e13873';       
        objDesignSpec4.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec4.Release_Status__c = 'Release To White List';
        objDesignSpec4.PDK_Patch__c =  objPatch3.Id;
        
        listDSs.add(objDesignSpec);
        listDSs.add(objDesignSpec1);
        listDSs.add(objDesignSpec2);
        listDSs.add(objDesignSpec3);
        listDSs.add(objDesignSpec4);
        insert listDSs;
        
        List<Sub_PDK__c> lstofsubpdk=new List<Sub_PDK__c>();
        Sub_PDK__c objSubPDK = new Sub_PDK__c(); 
        objSubPDK.Name = 'TestName';
        objSubPDK.Release_Status__c = 'Release To White List';
        objSubPDK.PDK__c = objPDK.Id;
        objSubPDK.Bundle_Name__c = 'test Bundle Name';
        
        Sub_PDK__c objSubPDK1 = new Sub_PDK__c(); 
        objSubPDK1.Name = 'TestName1';
        objSubPDK1.Release_Status__c = 'Release To White List';
        objSubPDK1.PDK__c = objPDK1.Id;
        objSubPDK1.Bundle_Name__c = 'test Bundle Name1';
        
        Sub_PDK__c objSubPDK2 = new Sub_PDK__c(); 
        objSubPDK2.Name = 'TestName1';
        objSubPDK2.Release_Status__c = 'Release To White List';
        objSubPDK2.PDK__c = objPDK2.Id;
        objSubPDK2.Bundle_Name__c = 'test Bundle Name1';
        
        Sub_PDK__c objSubPDK3 = new Sub_PDK__c(); 
        objSubPDK3.Name = 'TestName1';
        objSubPDK3.Release_Status__c = 'Release To White List';
        objSubPDK3.PDK__c = objPDK3.Id;
        objSubPDK3.Bundle_Name__c = 'test Bundle Name1';
        

        lstofsubpdk.add(objSubPDK);
        lstofsubpdk.add(objSubPDK1); 
        lstofsubpdk.add(objSubPDK2); 
        lstofsubpdk.add(objSubPDK3);
                             
        insert lstofsubpdk;
                                     
        
        
        List<Sub_PDK_Spec__c>  subPDKSpecList=new  List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objSpec=new Sub_PDK_Spec__c ();
        objSpec.Design_Spec__c =objDesignSpec.Id;
        objSpec.Sub_PDK__c=objSubPDK.Id;
        
        insert objSpec;
        
        Sub_PDK_Spec__c objSpec1=new Sub_PDK_Spec__c ();
        objSpec1.Design_Spec__c =objDesignSpec1.Id;
        objSpec1.Sub_PDK__c=objSubPDK1.Id;
        insert objSpec1;
        
        Sub_PDK_Spec__c objSpec2=new Sub_PDK_Spec__c ();
        objSpec2.Design_Spec__c =objDesignSpec2.Id;
        objSpec2.Sub_PDK__c=objSubPDK1.Id;
        insert objSpec2;
        
        Sub_PDK_Spec__c objSpec3=new Sub_PDK_Spec__c ();
        objSpec3.Design_Spec__c =objDesignSpec3.Id;
        objSpec3.Sub_PDK__c=objSubPDK2.Id;
        insert objSpec3;
        
        Sub_PDK_Spec__c objSpec4=new Sub_PDK_Spec__c ();
        objSpec4.Design_Spec__c =objDesignSpec4.Id;
        objSpec4.Sub_PDK__c=objSubPDK3.Id;
        insert objSpec4;
        
        
        
       
        subPDKSpecList.add(objSpec);
        subPDKSpecList.add(objSpec1);
        subPDKSpecList.add(objSpec2);
        subPDKSpecList.add(objSpec3);
        
       // insert subPDKSpecList;
        
      
        
        List<Document_Provisioning__c> listDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Unique_Id__c = 'abc';
        dp.Status__c = 'Provisioned';
        dp.Sub_PDK_Provisioned_for__c='objSubPDK.id;addf';
        listDP.add(dp); 
        
        Document_Provisioning__c dp1 = new Document_Provisioning__c ();
        dp1.User__c = portalUser.Id;
        dp1.Design_Spec__c = objDesignSpec.Id;
        dp1.Unique_Id__c = 'abc1';
        dp1.Status__c = 'Provisioned';
        //dp1.Sub_PDK_Provisioned_for__c='objSubPDK.id;addf';
        listDP.add(dp1); 
                       
        insert listDP;       
        
        FV_deassociateSpecFromSubPDK.deassociateSpecFromSubPDK(subPDKSpecList);
  
        delete objSpec;
        delete objSpec1;
        delete objSpec2;
        delete objSpec3;
        delete objSpec4;
        
        test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}