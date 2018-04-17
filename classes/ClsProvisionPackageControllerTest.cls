/*
Type Name: ClsProvisionPackageControllerTest.
Author: Cognizant
Created Date: 17-Aug-2013
Reason: This is the Test class for classes clsVFAddPackageSpecController,clsVFDeProvisionPackageController,ClsProvisionPackageController & trigger PackageTriggerHandler. 
Change History:
Author: Cognizant
 Modified Date: 23-Jan-2014
Reason: Case00004324 
……..
……..
Ashwini     04072015    - Refactoring test class.
*/
@isTest(seeAllData = false)
public class ClsProvisionPackageControllerTest
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
    
    static testMethod void methodclsVFAddPackageSpecController()
    {
        //DataUtilTest.loadEnvironmentVariables(); 
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007));
        insert lstspec;
        
        package__c objPkg = new package__c();
        objPkg.Name = 'Test';
        objPkg.Tech_Geometry__c = '0.11UM';
        objPkg.Package_Release_Status__c='Draft';
        insert objPkg;  
        
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[1].id));
       // insert lstPckgSpec;
        
        objPkg.Package_Release_Status__c='Specific Customer Release';
        update objPkg;
              
        
        Set<String> UserId=new Set<String>();        
        List<String> deptList=new  List<String>();        
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
       
        test.starttest(); 
    
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',UserFoundInOT__c=true,Department__c='Design');//modified by cognizant for Case00004324
        insert conobj;
                          
        RecordType rtypes = [Select Name, Id From RecordType 
                  where sObjectType='White_list__c' and isActive=true and name like '%Package%' limit 1];
                  
        /**          
        list<white_list__c> lstWL=new list<white_list__c>();
        lstWL.add(new white_list__c(account__c=accntObj.id,package__c=objPkg.id,recordtypeid=rtypes.id));
        lstWL.add(new white_list__c(account__c=accntObj1.id,package__c=objPkg.id,recordtypeid=rtypes.id));
        insert lstWL;
        **/
              
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
        PageReference pg = Page.VFProvisionPackage;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objPkg.id); 
        ClsProvisionPackageController testController = new ClsProvisionPackageController(new ApexPages.StandardController(objPkg));  
        
        testController.searchText='7';
        testController.searchAccount();
        testController.searchText='acc';
        testController.searchAccount();
        

        List<ClsProvisionPackageController.wrapper> lst =new list<ClsProvisionPackageController.wrapper>();
        lst=testController.searchResult;
        for(ClsProvisionPackageController.Wrapper w:lst)
            w.selected=true;
        testController.searchResult=lst;
        testController.next();
        
        List<ClsProvisionPackageController.wrapper> lst2 =new list<ClsProvisionPackageController.wrapper>();
        lst2=testController.wrapSelectedAccounts;
        for(ClsProvisionPackageController.Wrapper w:lst2){
            for(ClsProvisionPackageController.Wrapper2 w2:w.usrs)
                w2.selected=true;
        }
        testController.wrapSelectedAccounts=lst2;

        testController.provisionPackage();
        test.stoptest();
        /**
        objPkg.Package_Release_Status__c='Draft';
        update objPkg;
        objPkg.Package_Release_Status__c='Release to White list';
        update objPkg;
        testController.setupWhiteListProvisioning();                
        **/
    }
    
    
    
    static testMethod void methodclsVFAddPackageSpecControllerWhiteList()
    {
        //DataUtilTest.loadEnvironmentVariables(); 
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007));
        insert lstspec;
        
        package__c objPkg = new package__c();
        objPkg.Name = 'Test';
        objPkg.Tech_Geometry__c = '0.11UM';
        objPkg.Package_Release_Status__c='Draft';
        insert objPkg;  
        
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[1].id));
       // insert lstPckgSpec;
        
        objPkg.Package_Release_Status__c='Specific Customer Release';
        update objPkg;
              
        
        Set<String> UserId=new Set<String>();        
        List<String> deptList=new  List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);///modified by cognizant for Case00004562        
        insert conobj;
        
        
        RecordType rtypes = [Select Name, Id From RecordType 
                  where sObjectType='White_list__c' and isActive=true and name like '%Package%' limit 1];
                  
                  
        list<white_list__c> lstWL=new list<white_list__c>();
        lstWL.add(new white_list__c(account__c=accntObj.id,package__c=objPkg.id,recordtypeid=rtypes.id));
        //lstWL.add(new white_list__c(account__c=accntObj1.id,package__c=objPkg.id,recordtypeid=rtypes.id));
        
        test.starttest(); 
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
        PageReference pg = Page.VFProvisionPackage;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objPkg.id); 
        ClsProvisionPackageController testController = new ClsProvisionPackageController(new ApexPages.StandardController(objPkg));  
        
        testController.searchText='7';
        testController.searchAccount();
        testController.searchText='acc';
        testController.searchAccount();
        
        /**
        List<ClsProvisionPackageController.wrapper> lst =new list<ClsProvisionPackageController.wrapper>();
        lst=testController.searchResult;
        for(ClsProvisionPackageController.Wrapper w:lst)
            w.selected=true;
        testController.searchResult=lst;
        testController.next();
        
        List<ClsProvisionPackageController.wrapper> lst2 =new list<ClsProvisionPackageController.wrapper>();
        lst2=testController.wrapSelectedAccounts;
        for(ClsProvisionPackageController.Wrapper w:lst2){
            for(ClsProvisionPackageController.Wrapper2 w2:w.usrs)
                w2.selected=true;
        }
        testController.wrapSelectedAccounts=lst2;
        **/
        
        objPkg.Package_Release_Status__c='Draft';
        update objPkg;
        objPkg.Package_Release_Status__c='Release to White list';
        update objPkg;
        testController.setupWhiteListProvisioning();                
        test.stoptest();  
        testController.provisionPackage();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}