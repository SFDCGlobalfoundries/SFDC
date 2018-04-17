/*
Type Name: ClsCreateSubPDKTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsCreateSubPDK. 
Change History:
Author: Cognizant 
Modified Date:27/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
Nbustillos  10122013  - Added call to loadEnvironmentVariables() method.
Author :Global Foundries(Dinesh)
Modified Date:28/09/2017
Reason: Test Class Updated to cover the pagination code
  
*/
@isTest
public class ClsCreateSubPDKTest
{    
    
     @testSetup static void testdata() {
            
        DataUtilTest.loadEnvironmentVariables();
         
        List<Map<String,Object>> fieldValueMapsList = new List<Map<String,Object>>();
        for (integer z=1; z<=3; z++) {
            Map<String,Object> fieldValueMap = new Map<String,Object>();                    
                fieldValueMap.put('Name', 'MYTEST ACCOUNT'+z);            
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
    
    static testMethod void CreateSubPDK()
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
     
        Set<String> UserId=new Set<String>();
        List<String> deptList=new  List<String>();
       
        set<String> accountID = new Set<String>();
        
        List<Account> listAcc= getAccounts(); //getting test account data
   
        accountID.add(listAcc[0].id);
        accountID.add(listAcc[1].id);
  
        /*List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design');      
        lstContact.add(conobj);
        lstContact.add(conobj2);
        insert lstContact;
          
        deptList.add(conobj.Department__c);
              
        Profile profile1 = [Select Id from Profile where name = 'Customer Portal Admin'];*/
        Profile profile2 = [Select Id from Profile where name = 'System Administrator'];
        
        List<User> lstUsers = new List<User>();
        set<String> setUserIds = new set<String>();
        User portalUser = new User( ProfileId = profile2.Id,
                                                Username = 'portaluser@testorg.com',
                                                Alias = 'auser',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Wayne',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago'
                                               );
        User portalUser2 = new User( ProfileId = profile2.Id,
                                                Username = 'portaluser2@testorg.com',
                                                Alias = 'auser2',
                                                Email='portaluser2@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Wayne',
                                                Lastname='Bruce',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago'
                                               );

        User integUser = new User( ProfileId = profile2.Id,
                                                Username = 'integuser@testorg.com',
                                                Alias = 'integ',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Reid',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago'                                               
                                               );
        
        lstUsers.add(portalUser);
        lstUsers.add(portalUser2);
        lstUsers.add(integUser);
                                               
        insert lstUsers;
        setUserIds.add(portalUser.Id);
        setUserIds.add(portalUser2.Id);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Access_ASIC_PDK_Admin'];
        insert new PermissionSetAssignment(AssigneeId = lstUsers[0].id, PermissionSetId = ps.Id );
        
        PermissionSet ps1 = [SELECT ID From PermissionSet WHERE Name = 'Access_PDK_Admin'];
        insert new PermissionSetAssignment(AssigneeId = lstUsers[0].id, PermissionSetId = ps1.Id );
		 
		 //Added by Dinesh 27/9/2017
         PDKPagination__c pdkrecords=new PDKPagination__c();
         pdkrecords.Name='1';
         pdkrecords.RecordsPerPage__c='2';
           
         insert pdkrecords;
       
        //Ended the Code by Dinesh
        
        List<PDK__c> listPDK = new List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 123;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123;
        objPDK.Master_PDK_ASIC__c = false;
        objPDK.PDK_Lifecycle_Phase__c = 'RELEASED';
        PDK__c objPDK2 = new PDK__c();
        objPDK2.Name = 'Test';
        objPDK2.PDK_DocTitle__c = 'TestDoc';
        objPDK2.OpenText_ID__c = 456;
        objPDK2.Description__c = 'TestDescription';
        objPDK2.Old_Revision_ID__c = 123;
        objPDK2.PDK_Lifecycle_Phase__c = 'OBSOLETE';
        objPDK2.Master_PDK_ASIC__c = true;
        listPDK.add(objPDK);
        listPDK.add(objPDK2);
        insert listPDK;
		system.assertEquals(listPDK,listPDK);
        
        PDK_Patch__c objPatch = new PDK_Patch__c();
        objPatch.Name = 'Test';
        objPatch.OpenText_ID__c = 66555;
        objPatch.PDK__c = objPDK.Id;
        insert objPatch;
                 
        List<Design_Spec__c> lstDSpec = new List<Design_Spec__c>();
        Design_Spec__c objDesignSpec = new Design_Spec__c();       
        objDesignSpec.OpenText_ID__c = 55555;
        objDesignSpec.Name = 'Test Name';
        objDesignSpec.Document_Title__c = 'Test Title';
        objDesignSpec.Old_Revision_ID__c = 12345;
        objDesignSpec.ParentID__c = 3421;
        objDesignSpec.Document_Number__c = 'Test DocNum';        
        objDesignSpec.Revision__c = 'rev 1.0';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';       
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is';// CR # 4562 – Field replaced
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
        objDesignSpec.PDK__c = objPDK.Id;  
		
		Design_Spec__c objDesignSpec1 = new Design_Spec__c();       
        objDesignSpec1.OpenText_ID__c = 555552;
        objDesignSpec1.Name = 'Test Name';
        objDesignSpec1.Document_Title__c = 'Test Title1';
        objDesignSpec1.Old_Revision_ID__c = 123456;
        objDesignSpec1.ParentID__c = 3421;
        objDesignSpec1.Document_Number__c = 'Test DocNum';        
        objDesignSpec1.Revision__c = 'rev 1.0';
        objDesignSpec1.Lifecycle_Phase__c = 'test phase';
        objDesignSpec1.Location_Fab__c = 'test fab';       
        objDesignSpec1.Specification_Release_List_Long__c = 'intel;is';
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
        objDesignSpec1.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec1.Release_Status__c = 'Specific Account Release'; 
        objDesignSpec1.PDK__c = objPDK.Id; 
        
        Design_Spec__c objDesignSpec3 = new Design_Spec__c();       
        objDesignSpec3.OpenText_ID__c = 555555;
        objDesignSpec3.Name = 'Test Name';
        objDesignSpec3.Document_Title__c = 'Test Title';
        objDesignSpec3.Old_Revision_ID__c = 123457;
        objDesignSpec3.ParentID__c = 3421;
        objDesignSpec3.Document_Number__c = 'Test DocNum';        
        objDesignSpec3.Revision__c = 'rev 1.0';
        objDesignSpec3.Lifecycle_Phase__c = 'test phase';
        objDesignSpec3.Location_Fab__c = 'test fab';       
        objDesignSpec3.Specification_Release_List_Long__c = 'intel;is';
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
        objDesignSpec3.Release_Status__c = 'Specific Account Release'; 
        objDesignSpec3.PDK__c = objPDK.Id; 
		
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();    
        objDesignSpec2.OpenText_ID__c = 66666;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 12345;
        objDesignSpec2.ParentID__c = 3421;
        objDesignSpec2.Document_Number__c = 'Test DocNum';        
        objDesignSpec2.Revision__c = 'rev 1.0';
        objDesignSpec2.Lifecycle_Phase__c = 'test phase';
        objDesignSpec2.Location_Fab__c = 'test fab';       
        objDesignSpec2.Specification_Release_List_Long__c = 'intel;is';// CR # 4562 – Field replaced
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
        objDesignSpec2.PDK_Patch__c = objPatch.Id;
        lstDSpec.add(objDesignSpec);
        lstDSpec.add(objDesignSpec2);
        lstDSpec.add(objDesignSpec1);
        lstDSpec.add(objDesignSpec3); 
		
        insert lstDSpec;
        
        ApexPages.currentPage().getParameters().put('Id',objPDK.id); 
        test.starttest(); 
        System.runAs(lstUsers[0]) {
            
          ClsCreateSubPDK  testController = new ClsCreateSubPDK(new ApexPages.StandardController(objPDK));         
            testController.createQueryString('Design_Spec__c','SelectDesignSpec');  
            testController.findParentDesignSpecs();
            testController.newSubPDK.Release_Status__c = 'Specific Account Release';
            testController.showWLAccountSection();
            testController.newSubPDK.Release_Status__c = 'Release to White list';
            testController.showWLAccountSection(); 
            system.assertEquals(testController.showWLAccountsSection,true);           
            testController.saveNewSubPDK();
            testController.newSubPDK.Name = 'Test Sub PDK';
            testController.newSubPDK.Bundle_Name__c = 'Test Bundle Name';
            testController.newSubPDK.Release_Status__c = null;
            testController.saveNewSubPDK();
            testController.newSubPDK.Release_Status__c = 'Release to White list';
            testController.saveNewSubPDK();
            testController.newSubPDK.Release_Status__c = 'Release to White list';
            testController.masterDesignSpec.add(new ClsCreateSubPDK.designSpecWrapper(true,objDesignSpec));
            testController.patchDesignSpec.add(new ClsCreateSubPDK.designSpecWrapper(true,objDesignSpec));
            testController.WLAccounts.add(new ClsCreateSubPDK.accountWrapper(true,listAcc[0]));
            testController.saveNewSubPDK();
           
            testController.searchString='acc'; 
            testController.searchAccount();
            testController.accountSearchList.add(new ClsCreateSubPDK.accountWrapper(true,listAcc[0]));
            testController.addSelectedAccounts();
            testController.clearSearch();
            testController.cancelAddAccount();
            
            ClsCreateSubPDK  testController2 = new ClsCreateSubPDK(new ApexPages.StandardController(objPDK2)); 
          
            // Calling more methods to cover more lines of code. changes by Ashish Jadhav.
            testController.newSubPDK.Release_Status__c = 'General Release';  
            testController.saveNewSubPDK();
            testController.newSubPDK.Release_Status__c = 'Specific Account Release with Spec owner Approval';
            testController.saveNewSubPDK();
            
            testController.validateStatus();
			
			//Added by Dinesh on 25/9/2017
            testController.counter=0;
            testController.beginning();
            testController.next();
            testController.previous();
            testController.last();
            testController.getDisableNext();
            testController.getDisablePrevious();
            testController.getTotalPages();
            //Ended by Dinesh
        
      
    }
    
     System.runAs(lstUsers[1]) {
             
          ClsCreateSubPDK  testController = new ClsCreateSubPDK(new ApexPages.StandardController(objPDK));         
            testController.createQueryString('Design_Spec__c','SelectDesignSpec');  
            testController.findParentDesignSpecs();
            testController.newSubPDK.Release_Status__c = 'Specific Account Release';
            testController.showWLAccountSection();
            testController.newSubPDK.Release_Status__c = 'Release to White list';
            testController.showWLAccountSection(); 
            system.assertEquals(testController.showWLAccountsSection,true);           
            testController.saveNewSubPDK();
            testController.newSubPDK.Release_Status__c = 'Release to White list';
            testController.masterDesignSpec.add(new ClsCreateSubPDK.designSpecWrapper(true,objDesignSpec));
            testController.patchDesignSpec.add(new ClsCreateSubPDK.designSpecWrapper(true,objDesignSpec));
            testController.saveNewSubPDK();    
         
    }
       
        test.stoptest();  
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