/*
Type Name: clsVFDeProvisionPackageControllerTest.
Author: Cognizant
Created Date: 17-Aug-2013
Reason: This is the Test class for classes clsVFAddPackageSpecController,clsVFDeProvisionPackageController,ClsProvisionPackageController & trigger PackageTriggerHandler. 
Change History:Department populated by Sunil Arora on 18th sep, 2014 for case # 29898
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: (Case 00004324)
Author: IBM
Modified Date: 18-sep-2014
Reason: (Case 29898)
……..
……..
Ashwini     05142015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
public class clsVFDeProvisionPackageControllerTest
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
    static testMethod void methodclsVFDeProvisionPackageController()
    {  
 /*----------------------added by cognizant on 17/2/2014---------------------------------------------------------------------*/ 
       Profile profile2 = [Select Id from Profile where name = 'System Administrator'];
       User sysuser= new User( ProfileId = profile2.Id,
                                                Username = 'user3@testorg.com',
                                                Alias = 'user3',
                                                Email='user1@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Reid',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                UserRoleId='00E90000000R2T1'                                              
                                               );
                                               
       insert  sysuser;
       
       system.runas( sysuser)
       {                                    
        //DataUtilTest.loadEnvironmentVariables();//added by cognizant on 17/2/2014
/*------------------------------------------------------------------------------------------*/        
        list<Design_Spec__c> lstSpec=new list<Design_Spec__c>();
        lstSpec.add(new Design_Spec__c(Name='Spec-001',Document_Number__c='007',technology_geometry__c='0.10UM',OpenText_ID__c=7007007));
        lstSpec.add(new Design_Spec__c(Name='Spec-002',Document_Number__c='007007',technology_geometry__c='0.10UM',OpenText_ID__c=7007));
        insert lstspec;
        
        package__c objPkg = new package__c();
        objPkg.Name = 'Test';
        objPkg.Tech_Geometry__c = '0.10UM';
        objPkg.Package_Release_Status__c='Draft';
        insert objPkg;  
        
        list<Package_Spec__c> lstPckgSpec=new list<Package_Spec__c>();
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[0].id));
        lstPckgSpec.add(new Package_Spec__c(package__c=objPkg.id,design_spec__c=lstspec[1].id));
        insert lstPckgSpec;
        
        objPkg.Package_Release_Status__c='Specific Customer Release';
        update objPkg;
              
        
        Set<String> UserId=new Set<String>();
        
        List<String> deptList=new  List<String>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        //Department populated by Sunil Arora on 18th sep, 2014 for case # 29898
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',UserFoundInOT__c=true,Department__c='Design');   //modified by cognizant for Case 00004324
        test.starttest();   
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
        
       // UserId.add(portalUser.Id);
        
        list<document_provisioning__c> lstprov=new list<document_provisioning__c>();
        lstprov.add(new document_provisioning__c(design_package__c=objPkg.id,user__c=portalUser.Id,status__c='Provisioned'));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[0].id,user__c=portalUser.Id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg.id));
        lstprov.add(new document_provisioning__c(design_spec__c=lstspec[1].id,user__c=portalUser.Id,status__c='Provisioned',Packages_Provisioned_for__c=objPkg.id));
        insert lstprov;
        system.assert(lstprov[0].status__c=='Provisioned');
        
        PageReference pg = Page.VFDeProvisionPackage;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('Id',objPkg.id); 
        clsVFDeProvisionPackageController testController = new clsVFDeProvisionPackageController(new ApexPages.StandardController(objPkg));  
        

        List<clsVFDeProvisionPackageController.Accountwrapper> lst =new list<clsVFDeProvisionPackageController.Accountwrapper>();
        lst=testController.lstwAccounts ;
        for(clsVFDeProvisionPackageController.Accountwrapper w:lst)
            w.selected=true;
        testController.lstwAccounts=lst;
        testController.next();
        
        List<clsVFDeProvisionPackageController.Accountwrapper> lst2 =new list<clsVFDeProvisionPackageController.Accountwrapper>();
        lst2=testController.selectedlstwAccounts ;
        for(clsVFDeProvisionPackageController.Accountwrapper w:lst2){
            for(clsVFDeProvisionPackageController.userwrapper w2:w.usrwrap)
                w2.selected=true;
        }
        testController.selectedlstwAccounts = lst2;
        
        testController.deProvisionPackage();
        test.stoptest();
        }//added by cognizant on 17/2/2014
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}