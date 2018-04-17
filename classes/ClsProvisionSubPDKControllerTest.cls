/*
Type Name: ClsProvisionSubPDKControllerTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsProvisionSubPDKController. 
Change History:
Author: Cognizant
Modified Date: 23-Jan-2014
Reason: Case00004324
……..
……..
Ashwini     05142015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
public class ClsProvisionSubPDKControllerTest
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
    static testMethod void methodClsProvisionSubPDKController()
    {
        
         
       //DataUtilTest.loadEnvironmentVariables();     
       RecordType recTypeSPDK = [SELECT Id,Name FROM RecordType where SobjectType='White_List__c' AND Name = 'PDK'];
        
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
        objPDK2.PDK_Lifecycle_Phase__c = 'OBSOLETE';
        listPDK.add(objPDK);
        listPDK.add(objPDK2);
        insert listPDK;   
        
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        objSubPDK.Bundle_Name__c = 'Test Bundle';
        objSubPDK.Release_Status__c = 'Specific Account Release with Spec owner Approval';  //modified by cognizant on 6th march     
        insert objSubPDK;
                
        Set<String> UserId=new Set<String>();
        List<Account> listAcc = new List<Account>();
        set<String> accountID = new Set<String>();
        List<String> deptList=new  List<String>();
        Account accntObj = getAccount('MYTEST ACCOUNT1');
    
        accountID.add(accntObj.id);
        listAcc.add(accntObj);
         
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=accntObj.Id;
        update env;
         
        /*List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design');
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design');      
        lstContact.add(conobj);
        lstContact.add(conobj2);
        insert lstContact;
          
        deptList.add(conobj.Department__c);*/
/*-----------------------added by cognizant for Case 00004324------------------------------------------------*/       
        List<Contact>  lstContact = new List<Contact>();
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',Department__c='Design',UserFoundInOT__c=true);
        Contact conobj2=new Contact(FirstName='Mr',LastName='Testcon2',AccountId=accntObj.Id,Email='con2@gf.com',Department__c='Design',UserFoundInOT__c=true);      
        lstContact.add(conobj);
        lstContact.add(conobj2);
        insert lstContact;  
/*--------------------------------------------------------------------------------------------------------------*/             
        Profile profile1 = [Select Id from Profile where name = 'GF Consultants'];
       // Profile profile2 = [Select Id from Profile where name = 'System Administrator'];//commented by cognizant for Case 00004324
        Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin'];//added by cognizant for Case 00004324
        
         HCM_Employee__c hcmemp=new HCM_Employee__c();
        hcmemp.First_Name__c='abc';
        hcmemp.Last_Name__c='xxx';
        hcmemp.Employee_ID__c='177314';
        hcmemp.Email_Address__c='con1@gf.com';
        hcmemp.Login_ID__c ='abc';
        insert hcmemp;
        
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

        User integUser = new User( ProfileId = profile1.Id,
                                                Username = 'integuser@testorg.com',
                                                Alias = 'integ',
                                                Email='portaluser@testorg.com',
                                                EmailEncodingKey='UTF-8',
                                                Firstname='Bruce',
                                                Lastname='Reid',
                                                LanguageLocaleKey='en_US',
                                                LocaleSidKey='en_US',
                                                TimeZoneSidKey='America/Chicago',
                                                HCM_Record_ID__c=hcmemp.id,
                                                FederationIdentifier='177314'
                                               );
        
        
        lstUsers.add(portalUser);
        lstUsers.add(portalUser2);
        lstUsers.add(integUser);    
        test.starttest();                                     
        insert lstUsers;
        setUserIds.add(portalUser.Id);
        setUserIds.add(portalUser2.Id);
        UserId.add(portalUser.Id);
        
        List<White_List__c> lstWL = new List<White_List__c>();
        White_List__c wl2 = new White_List__c();
        wl2.Sub_PDK__c = objSubPDK.Id;
        wl2.Account__c = accntObj.Id;
        wl2.RecordTypeId = recTypeSPDK.Id;
        White_List__c wl3 = new White_List__c();
        wl3.Sub_PDK__c = objSubPDK.Id;
        wl3.Account__c = accntObj.Id;//modified by cognizant for Case 00004324
        wl3.RecordTypeId = recTypeSPDK.Id;
        lstWL.add(wl2);
        lstWL.add(wl3);       
        insert lstWL;
        
        /*Apttus__APTS_Agreement__c ag = new Apttus__APTS_Agreement__c();
        ag.Name = 'New Agreement';
        ag.Apttus__Account__c = accntObj.Id;
        ag.Apttus__Status__c = 'Activated';
        ag.GF_Contract_Start_Date__c = Date.today()-1;
        ag.GF_Contract_End_Date__c = Date.today()+1;
        insert ag;
        
        Agreement_Geometries__c agGeo = new Agreement_Geometries__c();
        agGeo.Agreement__c = ag.Id;
        agGeo.Geometries__c = '2555 UM';
        insert agGeo;*/
        
        List<Document_Provisioning__c> lstDP = new List<Document_Provisioning__c>();
        Document_Provisioning__c dp = new Document_Provisioning__c ();
        dp.User__c = portalUser.Id;
        dp.Sub_PDK__c = objSubPDK.Id;
        dp.Status__c = 'Provisioned';
        Document_Provisioning__c dp2 = new Document_Provisioning__c ();
        dp2.User__c = portalUser2.Id;
        dp2.Sub_PDK__c = objSubPDK.Id;
        dp2.Status__c = 'De-Provisioned';
        lstDP.add(dp);
        lstDP.add(dp2);           
        insert lstDP;
        
        ApexPages.currentPage().getParameters().put('Id',objSubPDK.id); 
         
        
            ClsProvisionSubPDKController testController = new ClsProvisionSubPDKController(new ApexPages.StandardController(objSubPDK));  
            ClsProvisionSubPDKController.accountWrapper accWrap = new ClsProvisionSubPDKController.accountWrapper(true,accntObj);
            testController.accountSearchList.add(accWrap);
            testController.verifyValidTechGeometry(null);
            testController.verifyValidTechGeometry('1234');
            testController.verifyValidTechGeometry('0.25UM');
            testController.verifyNonObsoleteMasterPDK(objPDK2.id);
            testController.verifyNonObsoleteMasterPDK(objPDK.id);
            testController.getValidProfiles();
            testController.retrieveSubPDKInfo(objSubPDK.id);
            testController.getAllWhiteListAccountIds(objSubPDK.id);
            testController.getProvisionedAccountIds(UserId);
            testController.showOrHideAddAccounts('Specific Account Release');
            //system.assertEquals(testController.showAddAccounts,false);//commented by cognizant on 6th march
            testController.showOrHideAddAccounts('General Release');
            testController.getAllAccounts(accountID);
            testController.getAllRelatedUsers(accountID,UserId);
            testController.getAllNoUsers(accountID);
            testController.addUserAccountInfoToWrapper(listAcc);
            testController.openSearch();
            testController.searchString = 'acc';
            testController.searchAccount();
            testController.addSelectedAccounts();
            testController.cancelAddAccount();
            testController.createQueryString('Account','WhiteListFields');  
            testController.insertProvisioningRecords();
            System.runAs(integUser){
                ClsProvisionSubPDKController testController3 = new ClsProvisionSubPDKController(new ApexPages.StandardController(objSubPDK)); 
            }
            //system.assertEquals(testController.searchString,'acc');
        test.stoptest();     
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}