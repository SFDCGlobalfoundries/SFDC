/*
Type Name: ClsDeProvisionSubPDKControllerTest.
Author: Cognizant
Created Date: 16-Aug-2013
Reason: This is the Test class for class ClsDeProvisionSubPDKController. 
Change History:Just populated department field while creating contact
Author: Cognizant
Modified Date: 18-sep-2014
Reason: Case 29898
……..
……..
Ashwini     05132015    - Updated code for refactoring of test class.
*/
@isTest(seeAllData = false)
public class ClsDeProvisionSubPDKControllerTest
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
       
    static testMethod void methodClsDeProvisionSubPDKController()
    {
        //DataUtilTest.loadEnvironmentVariables(); 
        PDK__c objPDK = new PDK__c();
        objPDK.Name = 'Test';
        objPDK.PDK_DocTitle__c = 'TestDoc';
        objPDK.OpenText_ID__c = 93799501;
        objPDK.Description__c = 'TestDescription';
        objPDK.Old_Revision_ID__c = 123;
        objPDK.Tech_Geometry__c = '2555 UM'; 
        insert objPDK;   
        
        sub_PDK__c objSubPDK = new sub_PDK__c ();
        objSubPDK.name = 'TestSubPDK';
        objSubPDK.PDK__c = objPDK.id;
        insert objSubPDK;
        
        Set<String> UserId=new Set<String>();
        set<String> accountID = new Set<String>();
        List<account>  lstAcc = new List<Account>();
        List<String> deptList=new  List<String>();
        Account accntObj = getAccount('MYTEST ACCOUNT1');
        
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=accntObj.Id;
        update env;        
 /*--------------commented by cognizant for Case 00004324------------------------------------------------*/    
       /* Account accntObj1 = new Account(name ='acc1',Site_Department__c='Site1',Sub_Type__c='Direct',
                              Transaction_Type__c='Transactional',Region__c='APJ',Bill_To_Address_1__c='New Bill',
                              Bill_To_City__c='city1',Bill_To_Country__c='Austria',Corporate_Address_1__c='',
                              Corporate_City__c='city1',Corporate_Country__c='Austria',Short_Name__c='sn2'
                              );
                              
        insert accntObj1; */
 /*-------------------------------------------------------------------------------------------------------*/       
        lstAcc.add(accntObj);
       // lstAcc.add(accntObj1);//commented by cognizant for Case 00004324
        accountID.add(accntObj.id);
       // accountID.add(accntObj1.id);//commented by cognizant for Case 00004324
 /*------------------------added by cognizant for Case 00004324-------------------------------------------------*/
 /*Department populated by Sunil Arora on 18/9/2014 for case 29898-------*/
        Contact conobj=new Contact(FirstName='Mr',LastName='Testcon1',AccountId=accntObj.Id,Email='con1@gf.com',UserFoundInOT__c=true, Department__c='Design');   
        
        insert conobj;
 /*----------------------------------------------------------------------------------------------------------------*/         
       /* deptList.add(conobj.Department__c);*/
              
         Profile profile1 = [Select Id from Profile where name = 'GF Consultants'];
       // Profile profile2 = [Select Id from Profile where name = 'System Administrator'];//Commented by cognizant for Case 00004324
         Profile profile2 = [Select Id from Profile where name = 'Customer Portal Admin'];//added by cognizant for Case 00004324
         
         
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
                                                ContactId=conobj.Id//added by cognizant for Case 00004324
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
        dp.Sub_PDK__c = objSubPDK.Id;
        dp.Status__c = 'Provisioned';               
        insert dp;
        system.assertEquals(dp.User__c, portalUser.Id);  
        ApexPages.currentPage().getParameters().put('Id',objSubPDK.id);        
        
            ClsDeProvisionSubPDKController testController = new ClsDeProvisionSubPDKController(new ApexPages.StandardController(objSubPDK));
            //system.assertEquals(testController.isValidProfile, true);  
            testController.getAllExistingProvisionings(objSubPDK.id);
            testController.getAllAccounts(accountID);
            testController.addUserAccountInfoToWrapper(lstAcc);
            testController.addUserAccountInfoToWrapper(lstAcc);
            testController.retrieveSubPDKInfo(objSubPDK.id);
            testController.getAllRelatedUsers(UserId);
            testController.removeProvisioningRecords();
            System.runAs(integUser){
                ClsDeProvisionSubPDKController testController3 = new ClsDeProvisionSubPDKController(new ApexPages.StandardController(objSubPDK));
            }
            
        test.stoptest(); 
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}