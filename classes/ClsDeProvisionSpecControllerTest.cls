/*
Type Name: ClsDeProvisionSpecControllerTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsDeProvisionSpecController. 
Change History:
Author: Cognizant
Modified Date: 21-Jan-2014
Reason: Case 00004324 
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
……..
……..
Ashwini     05132015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
public class ClsDeProvisionSpecControllerTest
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
       
    static testMethod void methodClsDeProvisionSpecController()
    {
    
               
        //DataUtilTest.loadEnvironmentVariables(); 
        Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<account>  lstAcc = new List<Account>();
        
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=accntObj.Id;
        update env;
        
 /*--------------commented by cognizant for Case 00004324------------------------------------------------*/            
      /*  Account accntObj1 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria',Short_Name__c='sn2'
                              );
                              
        insert accntObj1; */
/*---------------------------------------------------------------------------------------------------------*/        
        lstAcc.add(accntObj);
       // lstAcc.add(accntObj1);//commented by cognizant for Case 00004324
        accountID.add(accntObj.id);
      //  accountID.add(accntObj1.id);//commented by cognizant for Case 00004324
 /*--------------added by cognizant for Case 00004324------------------------------------------------*/         
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);   
        
        insert conobj;
        
/*------------------------------------------------------------------------------------------------------*/              
        Profile profile1 = [Select Id from Profile where name = 'GF Consultants'];
       // Profile profile2 = [Select Id from Profile where name = 'System Administrator'];//commented by cognizant for Case 00004324
       Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin']; //added by cognizant for Case 00004324
        HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';
        insert hcmemp;
        
        List<User> lstUsers = new List<User>();
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
                                                ContactId=conobj.id///added by cognizant for Case 00004324
                                               );

        User integUser = new User( ProfileId = profile1.Id,
                                                Username = 'integuser@testorg.com',
                                                Alias = 'integ',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Reid',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                HCM_Record_ID__c=hcmemp.id,
                                                FederationIdentifier='177314',
                                                TimeZoneSidKey='America/Chicago'                                               
                                               );
        
        lstUsers.add(portalUser);
        lstUsers.add(integUser);   
        test.starttest();                                      
        insert lstUsers;
        UserId.add(portalUser.Id);
        
        List<Design_Spec__c> lstSpecs = new List<Design_Spec__c>();
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
        objDesignSpec.Technology_Geometry__c = '2555 UM';
        objDesignSpec.Source__c = 'test source';
        objDesignSpec.PDK_Version__c = 'test pdkversion';
        objDesignSpec.DE_Version__c = 'test de version';
        objDesignSpec.Specification_sub_class__c = 'test subclass';
        objDesignSpec.Is_Latest_Revision__c = true;
        objDesignSpec.Specification_Owner__c = 'e13873';        
        objDesignSpec.Commodity_Type_for_material_spec__c = 'test commodity';
        objDesignSpec.Release_Status__c = 'Release To White List';
        lstSpecs.add(objDesignSpec);
        
        Design_Spec__c objDesignSpec2 = new Design_Spec__c();        
        objDesignSpec2.OpenText_ID__c = 1876541111;
        objDesignSpec2.Name = 'Test Name';
        objDesignSpec2.Document_Title__c = 'Test Title';
        objDesignSpec2.Old_Revision_ID__c = 45678;
        objDesignSpec2.ParentID__c = null;
        objDesignSpec2.Document_Number__c = 'Test DocNum';        
        objDesignSpec2.Revision__c = 'test rev';
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
        objDesignSpec2.Release_Status__c = 'General Release';
        lstSpecs.add(objDesignSpec2);                           
        insert lstSpecs;
        
        /*Apttus__APTS_Agreement__c ag = new Apttus__APTS_Agreement__c();
        ag.Apttus__Account__c = accntObj.Id;
        ag.Apttus__Status__c = 'Activated';
        ag.GF_Contract_Start_Date__c = Date.today()-1;
        ag.GF_Contract_End_Date__c = Date.today()+1;
        insert ag;
        
        Agreement_Geometries__c agGeo = new Agreement_Geometries__c();
        agGeo.Agreement__c = ag.Id;
        agGeo.Geometries__c = '2555 UM';
        insert agGeo;*/
        
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Design_Spec__c = objDesignSpec.Id;
        dp.Status__c = 'Provisioned';              
        insert dp;
           
        ApexPages.currentPage().getParameters().put('Id',objDesignSpec.id);
         
        ClsDeProvisionSpecController testController = new ClsDeProvisionSpecController(new ApexPages.StandardController(objDesignSpec));
       
            
            testController.verifyValidTechGeometry(null);
            testController.verifyValidTechGeometry('1234');
            system.assertEquals(testController.isValidTechGeometry,true);
            testController.verifyValidTechGeometry('0.25UM');
            testController.verifyValidSpecType(null);        
            testController.verifyValidSpecType('Stepper Tooling Forms');
            testController.getAllExistingProvisionings(objDesignSpec.id);
            testController.getAllAccounts(accountID);
            testController.addUserAccountInfoToWrapper(lstAcc);
            testController.getValidProfiles();
            testController.retrieveSpecInfo(objDesignSpec.id);
            testController.getAllRelatedUsers(UserId);
            testController.removeProvisioningRecords();
            ClsDeProvisionSpecController testController2 = new ClsDeProvisionSpecController(new ApexPages.StandardController(objDesignSpec2));
           
            System.runAs(integUser){
                ClsDeProvisionSpecController testController3 = new ClsDeProvisionSpecController(new ApexPages.StandardController(objDesignSpec)); 
            } 
                                      
        test.stoptest();
        
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name, Short_Name__c FROM Account Where Name =: AccountName];
        
        return acct;
    }
}