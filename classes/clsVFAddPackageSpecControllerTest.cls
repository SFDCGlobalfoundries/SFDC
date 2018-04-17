/*
Type Name: clsVFAddPackageSpecControllerTest.
Author: Cognizant
Created Date: 17-Aug-2013
Reason: This is the Test class for classes clsVFAddPackageSpecController,clsVFDeProvisionPackageController,ClsProvisionPackageController & trigger PackageTriggerHandler. 
Change History:
Author: 
Modified Date: 
Reason: 
â€¦â€¦..
â€¦â€¦..
*/
@isTest(seeAllData = false)
public class clsVFAddPackageSpecControllerTest
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

        AccountDataFactory.createAccount(fieldValueMap);
    }
    static testMethod void methodclsVFAddPackageSpecController()
    {
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.11UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.11UM',OpenText_ID__c=7007));
        insert lstspec;
        
        package__c objPkg = new package__c();
        objPkg.Name = 'Test';
        objPkg.Tech_Geometry__c = '0.11UM';
         objPkg.Package_Release_Status__c = 'Draft';
        insert objPkg;  
        
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[1].id));
        insert lstPckgSpec;
              
        
        Set<String> UserId=new Set<String>();        
        List<String> deptList=new  List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
                
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');   
        
        insert conobj;
        
          
        deptList.add(conobj.Department__c);
              
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
        
        Profile objProfile = [Select Id,Name from Profile where Id =: UserInfo.getProfileId()];
        Provisioning_Profiles_with_Approval__c ppfa = new Provisioning_Profiles_with_Approval__c();
        ppfa.name = objProfile.name;
        ppfa.needsApproval__c = true;
        insert ppfa;
        
        Tech_Geometry_with_Provisioning_Approval__c tgpa = new Tech_Geometry_with_Provisioning_Approval__c();
        tgpa.name = 'test tech geo';
        insert tgpa;
        
        test.starttest(); 
        PageReference pg = Page.VFAddPackageSpec;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objPkg.id); 
        clsVFAddPackageSpecController testController = new clsVFAddPackageSpecController(new ApexPages.StandardController(objPkg));  
        
        testController.lstPckgSpec = lstspec;
        Document_Provisioning__c docProvisioning = new Document_Provisioning__c();
        
        docProvisioning.Status__c='Provisioned';
        docProvisioning.Design_Package__c = objPkg.id;
        docProvisioning.User__c=portalUser.Id;
        
        insert docProvisioning;
        // Test coverage for wrapper class
        clsVFAddPackageSpecController.specWrapper wrapper = new clsVFAddPackageSpecController.specWrapper(lstspec[0]);
        clsVFAddPackageSpecController.specWrapper wrapper1 = new clsVFAddPackageSpecController.specWrapper();
        
        testController.searchText='7';
        testController.searchSpecs();
        testController.searchText='007';
        testController.searchSpecs();
        
        testController.searchText='777';
        testController.searchSpecs();
        
        testController.searchText='007';
        testController.searchSpecs();
        List<clsVFAddPackageSpecController.specWrapper> lst =new list<clsVFAddPackageSpecController.specWrapper>();
        lst=testController.searchResultWrapper;
        for(clsVFAddPackageSpecController.specWrapper w:lst)
            w.checked=true;
        testController.searchResultWrapper=lst;
        testController.addToPackage();
        testController.remSpecId=lstSpec[0].id;
        testController.removeSpec();
        testController.addToPackage();
        testController.save();
        
        testController.clearSearchResult();
        testController.cancel();
        
        
        objPkg.Package_Release_Status__c='Specific Customer Release';
        update objPkg;
        
        test.stoptest();  
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}