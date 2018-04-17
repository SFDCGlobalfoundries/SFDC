/*
Type Name: ClsProvisionDocumentControllerTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsProvisionDocumentController. 
Change History:
Author: Cognizant
Modified Date: 24-Jan-2014
Reason: Case 00004324
Author: Cognizant 
Modified Date:27/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
Ashwini     04072015    - Refactoring test class.

*/
@isTest(seeAllData = false)
public class ClsProvisionDocumentControllerTest
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
        RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
        RecordType recTypeDS1 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Suppliers'];//added on 8th oct
        RecordType recTypeDS2 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Customer'];//added on 8th oct
        
        Group objGroup=[Select Id, Name from Group where name = 'Supplier Users Internal'];
        Group objGroup1=[Select Id, Name from Group where name = 'EDA Group'];
        Profiles_for_Provisioning__c setofprofiles =new Profiles_for_Provisioning__c(); //Custom Setting for Contact Fields
        setofprofiles.Name='System Administrator';//Static record 1 of custom setting
        insert setofprofiles;
        
        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true limit 1];
        System.Runas(userobj){
            Set<String> UserId=new Set<String>();
            set<String> accountID = new Set<String>();
            List<account>  lstAcc = new List<Account>();
            List<String> deptList=new  List<String>();
            Account accntObj = getAccount('MYTEST ACCOUNT1');        
            lstAcc.add(accntObj);
            accountID.add(accntObj.id);
            test.startTest();
            List<Contact>  lstContact = new List<Contact>();
            Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);
            Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design',UserFoundInOT__c=true);      
            lstContact.add(conobj);
            lstContact.add(conobj2);
            insert lstContact;
            
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];//added by cognizant for Case 00004324
            Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin'];//added by cognizant for Case 00004324
           
            
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
                                                    TimeZoneSidKey='America/Chicago',
                                                    ContactId=conobj.Id//added  by cognizant for Case 00004324
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
                                                    TimeZoneSidKey='America/Chicago',
                                                    ContactId=conobj2.Id//added  by cognizant for Case 00004324
                                                   );
    
            User integUser = new User( ProfileId = profile1.Id,//modified by cognizant for Case 00004324
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
            system.assertEquals(integUser.Email,'portaluser@testorg.com'); 
            setUserIds.add(portalUser.Id);
            setUserIds.add(portalUser2.Id);    
            test.stopTest();                    
        }
    }
    
    static testMethod void methodClsProvisionDocumentController()
    {
        //DataUtilTest.loadEnvironmentVariables(); 
        RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
       /* RecordType recTypeDS1 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Suppliers'];//added on 8th oct
        RecordType recTypeDS2 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Customer'];//added on 8th oct
        
        Group objGroup=[Select Id, Name from Group where name = 'Supplier Users Internal'];
        Group objGroup1=[Select Id, Name from Group where name = 'EDA Group'];
        
         Profiles_for_Provisioning__c setofprofiles =new Profiles_for_Provisioning__c(); //Custom Setting for Contact Fields
         setofprofiles.Name='System Administrator';//Static record 1 of custom setting
         insert setofprofiles; */
        
        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true limit 1];    
        System.Runas(userobj)
        {
        Account accntObj = getAccount('MYTEST ACCOUNT1');   
        List<account>  lstAcc = new List<Account>(); 
        set<String> setUserIds = new set<String>();
        set<String> accountID = new Set<String>();
        lstAcc.add(accntObj); 
        accountID.add(accntObj.id);
        Set<String> UserId=new Set<String>();
        User portalUser = [Select Id, Name from User where Email='portaluser@testorg.com' limit 1];
        User portalUser2 = [Select Id, Name from User where email='portaluser2@testorg.com' limit 1];
        /*Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<account>  lstAcc = new List<Account>();
        List<String> deptList=new  List<String>();
        Account accntObj = getAccount('MYTEST ACCOUNT1');    
        lstAcc.add(accntObj);        
        accountID.add(accntObj.id);
        
        List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design',UserFoundInOT__c=true);      
        lstContact.add(conobj);
        lstContact.add(conobj2);
        insert lstContact;
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];//added by cognizant for Case 00004324
        Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin'];//added by cognizant for Case 00004324
       
        
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
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.Id//added  by cognizant for Case 00004324
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
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj2.Id//added  by cognizant for Case 00004324
                                               );

        User integUser = new User( ProfileId = profile1.Id,//modified by cognizant for Case 00004324
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
        */
        test.starttest(); 
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
        objDesignSpec.Specification_Type__c = 'Ip Design Kit';
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
        
        List<Document_Provisioning__c> lstDocProv = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Status__c = 'Provisioned';//added on 8th oct
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser2.Id;
        dp2.Design_Spec__c = objDesignSpec.Id;
        dp2.Status__c = 'De-Provisioned';
        lstDocProv.add(dp);
        lstDocProv.add(dp2);
        insert lstDocProv;
        
        ApexPages.currentPage().getParameters().put('Id',objDesignSpec.id); 
        ClsProvisionDocumentController  testController = new ClsProvisionDocumentController(new ApexPages.StandardController(objDesignSpec));  
        
            testController.verifyValidTechGeometry(null);
            testController.verifyValidTechGeometry('1234');
            testController.verifyValidTechGeometry('0.25UM');
            testController.verifyValidSpecType(null);
            testController.verifyValidSpecType('Stepper Tooling Forms');
            testController.getAllExistingProvisionings(objDesignSpec.id);
            testController.addUserAccountInfoToWrapper(lstAcc);
            
            testController.getValidProfiles();
            
            testController.retrieveSpecInfo(objDesignSpec.id);
            testController.getAllWhiteListAccountIds(objDesignSpec.id);
            testController.getProvisionedAccountIds(setUserIds);
            testController.showOrHideAddAccounts(null);
            testController.showOrHideAddAccounts('General Release');
            testController.showOrHideAddAccounts('Specific Account Release');
            system.assertEquals(testController.showAddAccounts,false);
            
            testController.getAllAccounts(accountID);
            testController.getAllRelatedUsers(accountID,UserId);
            testController.getAllNoUsers(accountID);
            testController.openSearch();
            
            //ClsProvisionDocumentController.accountwrapper  testController1 = new ClsProvisionDocumentController.accountwrapper(false,accntObj1);
            //testController.accountSearchList.add(testController1);
            
            testController.searchString = '';//added on 8th oct
            testController.searchAccount();
            
            
            
            testController.searchString = 'acc';
            testController.searchAccount();
            
            testController.addSelectedAccounts();
            testController.cancelAddAccount();
            testController.createQueryString('Account','WhiteListFields');
            testController.insertProvisioningRecords();
       }
       test.stoptest();
    }
    
    static testMethod void methodClsProvisionDocumentController1()
    {
        //DataUtilTest.loadEnvironmentVariables(); 
      /*  RecordType recTypeDS = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'Design Spec'];
        RecordType recTypeDS1 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Suppliers'];//added on 8th oct
        RecordType recTypeDS2 = [SELECT Id,Name FROM RecordType where SobjectType='Account' AND Name = 'Customer'];//added on 8th oct
        
        Group objGroup=[Select Id, Name from Group where name = 'Supplier Users Internal'];
        Group objGroup1=[Select Id, Name from Group where name = 'EDA Group'];
        
         Profiles_for_Provisioning__c setofprofiles =new Profiles_for_Provisioning__c(); //Custom Setting for Contact Fields
         setofprofiles.Name='System Administrator';//Static record 1 of custom setting
         insert setofprofiles;
        
        Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<account>  lstAcc = new List<Account>();
        List<String> deptList=new  List<String>(); */
        
        User userobj=[Select Id from User where Profile.Name='System Administrator' and isactive=true  limit 1]; 
        System.Runas(userobj)
        {
            Account accntObj = getAccount('MYTEST ACCOUNT1');   
            List<account>  lstAcc = new List<Account>(); 
            set<String> setUserIds = new set<String>();
            set<String> accountID = new Set<String>();
            lstAcc.add(accntObj); 
            accountID.add(accntObj.id);
            Set<String> UserId=new Set<String>();
            User portalUser = [Select Id, Name from User where Email='portaluser@testorg.com' limit 1];
            User portalUser2 = [Select Id, Name from User where email='portaluser2@testorg.com' limit 1];        
        /*Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        lstAcc.add(accntObj);
       
        
        accountID.add(accntObj.id);
       
        List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design',UserFoundInOT__c=true);      
        lstContact.add(conobj);
        lstContact.add(conobj2);
        insert lstContact;
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];//added by cognizant for Case 00004324
        Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin'];//added by cognizant for Case 00004324
       
        
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
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj.Id//added  by cognizant for Case 00004324
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
                                                TimeZoneSidKey='America/Chicago',
                                                ContactId=conobj2.Id//added  by cognizant for Case 00004324
                                               );

       lstUsers.add(portalUser);
        lstUsers.add(portalUser2);
                                      
        insert lstUsers;
        setUserIds.add(portalUser.Id);
        setUserIds.add(portalUser2.Id);
        */
        test.starttest(); 
        Design_Spec__c objDesignSpec = new Design_Spec__c();
        
        objDesignSpec.OpenText_ID__c = 543281;
        objDesignSpec.Name = 'Test Name7';
        objDesignSpec.Document_Title__c = 'Test Title1';
        objDesignSpec.Old_Revision_ID__c = 123475;
        objDesignSpec.ParentID__c = null;
        objDesignSpec.Document_Number__c = 'Test DocNum1';        
        objDesignSpec.Revision__c = 'test rev';
        objDesignSpec.Lifecycle_Phase__c = 'test phase';
        objDesignSpec.Location_Fab__c = 'test fab';        
        objDesignSpec.Specification_Release_List_Long__c = 'intel;is'; // CR # 4562 – Field replaced
        objDesignSpec.Functional_Ownership__c = 'test func owner';
        objDesignSpec.Specification_Type__c = 'Logic';
        objDesignSpec.Technology_Type__c = 'test tech type';
        objDesignSpec.Technology_Geometry__c = '0.25UM';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = false;
        objDesignSpec.Specification_Owner__c = 'e13873';        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Specific Account Release';                              
        insert objDesignSpec;
		system.assertEquals(objDesignSpec.Name,'Test Name7'); 
		
        ApexPages.currentPage().getParameters().put('Id',objDesignSpec.id); 
        ClsProvisionDocumentController  testController = new ClsProvisionDocumentController(new ApexPages.StandardController(objDesignSpec));          
            testController.verifyValidTechGeometry(null);
            testController.verifyValidTechGeometry('1234');
            testController.verifyValidTechGeometry('0.25UM');
            testController.verifyValidSpecType(null);
            testController.verifyValidSpecType('Stepper Tooling Forms');
            testController.getAllExistingProvisionings(objDesignSpec.id);
            testController.addUserAccountInfoToWrapper(lstAcc);            
            testController.getValidProfiles();            
            testController.retrieveSpecInfo(objDesignSpec.id);
            testController.getAllWhiteListAccountIds(objDesignSpec.id);
            testController.getProvisionedAccountIds(null);
            testController.showOrHideAddAccounts(null);
            testController.showOrHideAddAccounts('General Release');
            testController.showOrHideAddAccounts('Specific Account Release');
            //system.assertEquals(testController.showAddAccounts,false);            
            testController.getAllAccounts(accountID);
            testController.getAllRelatedUsers(accountID,null);
            testController.getAllNoUsers(accountID);
            testController.openSearch();
            testController.searchString = '';//added on 8th oct
            testController.searchAccount();
            testController.searchString = 'acc';
            testController.searchAccount();            
            testController.addSelectedAccounts();
            testController.cancelAddAccount();
            testController.createQueryString('Account','WhiteListFields');
            testController.insertProvisioningRecords();
    }
    test.stoptest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name, Short_Name__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}