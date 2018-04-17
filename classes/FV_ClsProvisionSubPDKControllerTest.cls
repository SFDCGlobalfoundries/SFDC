/*
Type Name: FV_ClsProvisionSubPDKControllerTest.
Author: Cognizant
Created Date: 5-Sep-2014
Reason: This is the Test class for class FV_ClsProvisionSubPDKController. 

……..
……..
Ashwini     04082015    - Refactoring test class.
*/

@isTest(seeAllData = false)
public class FV_ClsProvisionSubPDKControllerTest
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
    
    static testMethod void methodFV_ClsProvisionSubPDKController()
    {
         
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007));
        insert lstspec;
        
        List<PDK__c> listPDK=new  List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 93799501;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123; 
        objPDK.PDK_Lifecycle_Phase__c = 'Obsolete';
        objPDK.Tech_Geometry__c = '0.25UM'; 
        PDK__c objPDK2 = new PDK__c();
        objPDK2.Name = 'Test';
        objPDK2.PDK_DocTitle__c = 'TestDoc';
        objPDK2.OpenText_ID__c = 93799502;
        objPDK2.Description__c = 'TestDescription';
        objPDK2.Old_Revision_ID__c = 123; 
        objPDK2.PDK_Lifecycle_Phase__c = '';
        listPDK.add(objPDK);
        listPDK.add(objPDK2);
        insert listPDK;  
         
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'General Release';  
        objPDK.Tech_Geometry__c = '0.25UM';     
        insert objSubPDK; 
        
         
        Set<String> UserId=new Set<String>();       
        List<String> deptList=new  List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        Profile profile12 = [Select Id,name from Profile where id =: userinfo.getProfileId()];
        Profiles_for_Provisioning__c pfp = new Profiles_for_Provisioning__c();
        pfp.name = profile12.name;
        insert pfp;
                 
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',UserFoundInOT__c=true,Department__c='Design');//modified by cognizant for Case00004324

        
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
                                               
        insert   portalUser;
        
        UserId.add(portalUser.Id);
        PageReference pg = Page.FV_VFProvisionSubPDK;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objSubPDK.id); 
        FV_ClsProvisionSubPDKController testController = new FV_ClsProvisionSubPDKController(new ApexPages.StandardController(objSubPDK));  
        
        testController.searchText='7';
        testController.searchAccount();
        testController.searchText='acc';
        testController.searchAccount();
        
        List<FV_ClsProvisionSubPDKController.wrapper> lst =new list<FV_ClsProvisionSubPDKController.wrapper>();
        lst=testController.searchResult;
        for(FV_ClsProvisionSubPDKController.Wrapper w:lst)
        w.selected=true;
        testController.searchResult=lst;
        testController.next();
        
        List<FV_ClsProvisionSubPDKController.wrapper> lst2 =new list<FV_ClsProvisionSubPDKController.wrapper>();
        lst2=testController.wrapSelectedAccounts;
        for(FV_ClsProvisionSubPDKController.Wrapper w:lst2){
            for(FV_ClsProvisionSubPDKController.Wrapper2 w2:w.usrs)
                w2.selected=true;
        }
        testController.wrapSelectedAccounts=lst2;

       testController.provisionPDK();
       testController.getValidProfiles();
       testController.showOrHideAddAccounts(objSubPDK.Release_Status__c);
       testController.verifyNonObsoleteMasterPDK(objPDK.Id);
       testController.verifyValidTechGeometry(objSubPDK.Tech_Geometry__c );
   
    }
    
    static testMethod void methodFV_ClsProvisionSubPDKControllerWhiteList()
    {
     
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007));
        insert lstspec;
        
        List<PDK__c> listPDK=new  List<PDK__c>();
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 93799501;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123; 
        objPDK.PDK_Lifecycle_Phase__c = 'RELEASED';
        objPDK.Tech_Geometry__c = '2555 UM';
        PDK__c objPDK2 = new PDK__c();
        objPDK2.Name = 'Test';
        objPDK2.PDK_DocTitle__c = 'TestDoc';
        objPDK2.OpenText_ID__c = 93799502;
        objPDK2.Description__c = 'TestDescription';
        objPDK2.Old_Revision_ID__c = 123; 
        objPDK2.PDK_Lifecycle_Phase__c = '';
        listPDK.add(objPDK);
        listPDK.add(objPDK2);
        insert listPDK;  
         
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'Specific Account Release';       
        insert objSubPDK; 
        
        Set<String> UserId=new Set<String>();        
        List<String> deptList=new  List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',UserFoundInOT__c=true,Department__c='Design');//modified by cognizant for Case00004324        
        insert conobj;
        
           RecordType rtypes = [Select Name, Id From RecordType 
                  where sObjectType='White_list__c' and isActive=true and name like '%PDK%' limit 1];
                  
    
        list<white_list__c> lstWL=new list<white_list__c>();
        lstWL.add(new white_list__c(account__c=accntObj.id,Sub_PDK__c=objSubPDK.id,recordtypeid=rtypes.id));                
        
        insert lstWL;
        
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
                                                //UserFoundInOT__c=true//added by cognizant for Case00004562
                                               );
                                               
        
        insert   portalUser;
        
         UserId.add(portalUser.Id);
        PageReference pg = Page.FV_VFProvisionSubPDK;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objSubPDK.id); 
        FV_ClsProvisionSubPDKController testController = new FV_ClsProvisionSubPDKController(new ApexPages.StandardController(objSubPDK));  
        
        testController.searchText='7';
        testController.searchAccount();
        testController.searchText='acc';
        testController.searchAccount();
        
        testController.provisionPdk();
        objSubPDK.Release_Status__c='Release to White list';
        update objSubPDK;
        testController.setupWhiteListProvisioning();                
        
        //testController.provisionPdk();
        
       testController.getValidProfiles();
       testController.showOrHideAddAccounts(objSubPDK.Release_Status__c);
       testController.verifyNonObsoleteMasterPDK(objPDK.Id);
       testController.verifyValidTechGeometry(objSubPDK.Tech_Geometry__c );
    
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }

}