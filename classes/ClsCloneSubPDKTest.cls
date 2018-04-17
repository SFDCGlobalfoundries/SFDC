/*
Type Name: ClsCloneSubPDKTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsCloneSubPDK. 
Change History:
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
    Nbustillos  10122013    - Added call to loadEnvironmentVariables() method.
*/
@isTest
public class ClsCloneSubPDKTest
{    
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
    }
    
    static testMethod void mothodCloneSubPDK()
    {
        
        RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
        List<Account> listAcc=new  List<Account>();
        Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<String> deptList=new  List<String>();
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        Account accntObj1 = getAccount('MYTEST ACCOUNT2');
        accountID.add(accntObj.id);
        accountID.add(accntObj1.id);
        listAcc.add(accntObj);
        listAcc.add(accntObj1);
        
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
        
        List<PDK__c> listPDK = new List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 123;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123;
        objPDK.PDK_Lifecycle_Phase__c = 'RELEASED';
        PDK__c objPDK2 = new PDK__c();
        objPDK2.Name = 'Test';
        objPDK2.PDK_DocTitle__c = 'TestDoc';
        objPDK2.OpenText_ID__c = 456;
        objPDK2.Description__c = 'TestDescription';
        objPDK2.Old_Revision_ID__c = 123;
        objPDK2.PDK_Lifecycle_Phase__c = 'OBSOLETE';
        listPDK.add(objPDK);
        listPDK.add(objPDK2);
        insert listPDK;
        
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
        objDesignSpec.PDK__c = objPDK.Id;                             
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
        objDesignSpec2.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
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
        Design_Spec__c objDesignSpec3 = new Design_Spec__c();       
        objDesignSpec3.OpenText_ID__c = 77777;
        objDesignSpec3.Name = 'Test Name';
        objDesignSpec3.Document_Title__c = 'Test Title';
        objDesignSpec3.Old_Revision_ID__c = 12345;
        objDesignSpec3.ParentID__c = 3421;
        objDesignSpec3.Document_Number__c = 'Test DocNum';        
        objDesignSpec3.Revision__c = 'rev 1.0';
        objDesignSpec3.Lifecycle_Phase__c = 'test phase';
        objDesignSpec3.Location_Fab__c = 'test fab';       
        objDesignSpec3.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
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
        objDesignSpec3.PDK__c = objPDK.Id;
        Design_Spec__c objDesignSpec4 = new Design_Spec__c();       
        objDesignSpec4.OpenText_ID__c = 88889;
        objDesignSpec4.Name = 'Test Name';
        objDesignSpec4.Document_Title__c = 'Test Title';
        objDesignSpec4.Old_Revision_ID__c = 12345;
        objDesignSpec4.ParentID__c = 3421;
        objDesignSpec4.Document_Number__c = 'Test DocNum';        
        objDesignSpec4.Revision__c = 'rev 1.0';
        objDesignSpec4.Lifecycle_Phase__c = 'test phase';
        objDesignSpec4.Location_Fab__c = 'test fab';       
        objDesignSpec4.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
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
        objDesignSpec4.PDK_Patch__c = objPatch.Id;    
        lstDSpec.add(objDesignSpec);
        lstDSpec.add(objDesignSpec2);
        lstDSpec.add(objDesignSpec3); 
        lstDSpec.add(objDesignSpec4);                              
        insert lstDSpec;
        
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        objSubPDK.Release_Status__c = 'Release To White list';
        insert objSubPDK;
        
        List<Sub_PDK_Spec__c> listSPS = new List<Sub_PDK_Spec__c>();
        Sub_PDK_Spec__c objsps = new Sub_PDK_Spec__c();
        objsps.Sub_PDK__c = objSubPDK.Id;
        objsps.Design_Spec__c = objDesignSpec3.Id;
        Sub_PDK_Spec__c objsps2 = new Sub_PDK_Spec__c();
        objsps2.Sub_PDK__c = objSubPDK.Id;
        objsps2.Design_Spec__c = objDesignSpec4.Id;
        listSPS.add(objsps);
        listSPS.add(objsps2);
        insert listSPS;
        
        List<White_List__c> lstWL = new List<White_List__c>();
        White_List__c wl2 = new White_List__c();
        wl2.Sub_PDK__c = objSubPDK.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypeSPDK.Id;
        /*White_List__c wl3 = new White_List__c();
        wl3.Sub_PDK__c = objSubPDK.Id;
        wl3.Account__c = accntObj1.Id;
        wl3.RecordTypeId = recTypeSPDK.Id;*/
        lstWL.add(wl2);
        //lstWL.add(wl3);       
        insert lstWL;
        
        ApexPages.currentPage().getParameters().put('Id',objSubPDK.id); 
        ClsCloneSubPDK  testController = new ClsCloneSubPDK(new ApexPages.StandardController(objSubPDK));  
        test.starttest(); 
            testController.createQueryString('sub_pdk__c','InputFields');
            testController.clearSearch();
            testController.findWhiteList();
            testController.findDesignSpec();
            testController.SubPDK.Release_Status__c = 'Specific Account Release';
            testController.showWLAccountSection();
            system.assertEquals(testController.wlpanel,false);
            testController.SubPDK.Release_Status__c = 'Release to White list';
            testController.showWLAccountSection();
            testController.SubPDK.Name = null; 
            testController.saveSubPdk();
            testController.SubPDK.Name = 'Test Sub PDK'; 
            testController.SubPDK.Bundle_Name__c = 'Test Bundle Name';
            testController.SubPDK.Release_Status__c = null;
            testController.saveSubPdk();
            testController.SubPDK.Release_Status__c = 'Specific Account Release';
            testController.saveSubPdk();
            testController.SubPDK.Release_Status__c = 'Release to White list';
            testController.subPdkWhiteList.add(new ClsCloneSubPDK.accountWrapper(true,accntObj));
            testController.subPdkWhiteList.add(new ClsCloneSubPDK.accountWrapper(true,accntObj1));
            testController.PDKDesignSpec.add(new ClsCloneSubPDK.designSpecWrapper(true,objDesignSpec));
            testController.PDKDesignSpec.add(new ClsCloneSubPDK.designSpecWrapper(true,objDesignSpec2));
            testController.PDKDesignSpec.add(new ClsCloneSubPDK.designSpecWrapper(false,objDesignSpec3));
            testController.PDKDesignSpec.add(new ClsCloneSubPDK.designSpecWrapper(false,objDesignSpec4));
            testController.saveSubPdk();           
            testController.searchString='acc'; 
            testController.searchAccount();
            testController.addSelectedAccounts();
            testController.cancelAddAccount();
        test.stoptest(); 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}