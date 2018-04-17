/*
    Author: Amit Kumar Ojha
    Description: Apex test class for  ITAR_Certified_Utility class
    History: 
    Dinesh      14/02/2018     - Updated apex to increase the code coverage
    
*/
@isTest
public class ITAR_Certified_UtilityTest {
    static user userObj;
    
    @testsetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin' LIMIT 1];
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');                           
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'India');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'India');        
        fieldValueMap.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap);
        
        
        Map<String,Object> fieldValueMap1 = new Map<String,Object>();
        fieldValueMap1.put('Name', 'MYTEST ACCOUNT2');                           
        fieldValueMap1.put('sub_type__c', 'Direct');
        fieldValueMap1.put('site_department__c', 'test dept');          
        fieldValueMap1.put('transaction_type__c', 'transactional');                          
        fieldValueMap1.put('region__c', 'US');        
        fieldValueMap1.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Corporate_City__c', 'Test City');                
        fieldValueMap1.put('Corporate_Country__c', 'India');
        fieldValueMap1.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap1.put('Bill_To_City__c', 'Test City');            
        fieldValueMap1.put('Bill_To_Country__c', 'India');        
        fieldValueMap1.put('Fab_9_10__c','No');
        
        AccountDataFactory.createAccount(fieldValueMap1);
        
        Account acctObj=getAccount('MYTEST ACCOUNT1');
        
        List<Id> conIdList=new List<Id>();
        
        Contact conobj=new Contact();
        conobj.FirstName='Mr';
        conobj.LastName='Testcon1';
        conobj.AccountId=acctObj.Id;
        conobj.Email='con1@gf.com';
        conobj.Department__c='Design';
        //conobj.ITAR_Access_Requested__c = false;
        insert conobj;
        conIdList.add(conobj.Id);
        
        userObj = new User();
        
        userObj.Alias = 'Shyam';
        userObj.Email='shyam@test.com'; 
        userObj.EmailEncodingKey='UTF-8'; 
        userObj.LastName='Paul';
        userObj.LanguageLocaleKey='en_US'; 
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profileObj.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles'; 
        userObj.UserName='shyam@test.com';
        userObj.Portal_Login__c = 'xyz';
        userObj.contactId = conobj.Id;
        userObj.IsActive = true;
        
        insert userObj;
        
        List<ITAR_App_Provision_ATP_Roles__c> itarAppList = new List<ITAR_App_Provision_ATP_Roles__c>();
        
        ITAR_App_Provision_ATP_Roles__c itarApp1 = new ITAR_App_Provision_ATP_Roles__c(Name = 'Primary Account Manager');
        itarAppList.add(itarApp1);
        
        if(itarAppList.size() > 0) {
            insert itarAppList;
            System.assert(!itarAppList.isEmpty());
        } 
        
        ITAR_US_IT_HELP__c ithelp = new ITAR_US_IT_HELP__c(Name = 'IT-HELP.US@globalfoundries.com');
        insert ithelp;
        System.assert(ithelp != null);
        
        List<ITAR_HCM_Employee_Fields__c> csList = new List<ITAR_HCM_Employee_Fields__c>();
        
        ITAR_HCM_Employee_Fields__c cs1 = new ITAR_HCM_Employee_Fields__c(Name = 'Conferencing_ITAR__c');
        csList.add(cs1);
        ITAR_HCM_Employee_Fields__c cs2 = new ITAR_HCM_Employee_Fields__c(Name = 'DropBox_ITAR__c');
        csList.add(cs2);
        ITAR_HCM_Employee_Fields__c cs3 = new ITAR_HCM_Employee_Fields__c(Name = 'DropBox_Non_ITAR__c');
        csList.add(cs3);
        ITAR_HCM_Employee_Fields__c cs4 = new ITAR_HCM_Employee_Fields__c(Name = 'Remote_Mask_Viewer_ITAR__c');
        csList.add(cs4);
        ITAR_HCM_Employee_Fields__c cs5 = new ITAR_HCM_Employee_Fields__c(Name = 'Remote_Mask_Viewer_Non_ITAR__c');
        csList.add(cs5);
        
        if(csList.size() > 0) {
            insert csList;
            System.assert(!csList.isEmpty());  
        }
        
        List<ITAR_Users_Training_Materials__c> csMatList = new List<ITAR_Users_Training_Materials__c>();
        ITAR_Users_Training_Materials__c csMat1 = new ITAR_Users_Training_Materials__c(Name = 'DropBox (Non-ITAR)');
        csMatList.add(csMat1);
        ITAR_Users_Training_Materials__c csMat2 = new ITAR_Users_Training_Materials__c(Name = 'Remote Mask Viewer (Non-ITAR)');
        csMatList.add(csMat2);
        
        if(csMatList.size() > 0) {
        insert csMatList;
        System.assert(!csMatList.isEmpty());  
        }
        
        List<ITAR_Access_Set_up_Fields__c> iasufList = new List<ITAR_Access_Set_up_Fields__c>();
        
        ITAR_Access_Set_up_Fields__c iasuf1 = new ITAR_Access_Set_up_Fields__c(Name = 'TeamRoom_ITAR__c');
        iasufList.add(iasuf1);
        ITAR_Access_Set_up_Fields__c iasuf2 = new ITAR_Access_Set_up_Fields__c(Name = 'DropBox_ITAR__c');
        iasufList.add(iasuf2);
        ITAR_Access_Set_up_Fields__c iasuf3 = new ITAR_Access_Set_up_Fields__c(Name = 'DropBox_non_ITAR__c');
        iasufList.add(iasuf3);
        ITAR_Access_Set_up_Fields__c iasuf4 = new ITAR_Access_Set_up_Fields__c(Name = 'Remote_Mask_Viewer_ITAR__c');
        iasufList.add(iasuf4);
        ITAR_Access_Set_up_Fields__c iasuf5 = new ITAR_Access_Set_up_Fields__c(Name = 'Remote_Mask_Viewer_Non_ITAR__c');
        iasufList.add(iasuf5);
        
        if(iasufList.size() > 0) {
            insert iasufList;
            System.assert(!iasufList.isEmpty());
        }
    }

    static testMethod void itarHCMEmployee() {
        //TriggerHandler.bypass('Account_TriggerHandler');
        //TriggerHandler.bypass('User_TriggerHandler');
        Test.startTest();        
        futureitarHCMEmployee();
        ITAR_Certified_Utility.getGroupMailAddresses();
        
        ITAR_Certified_Expiry_Batch icepBatch = new ITAR_Certified_Expiry_Batch();
        Database.executeBatch(icepBatch);
        
        ITAR_Schedule_CertifiedExpiryBatch batch = new ITAR_Schedule_CertifiedExpiryBatch();
        String sch = '0 0 * * * ?';
        system.schedule('ITAR_Certified_Expiry_Batch', sch, batch);  
        Test.stopTest();
    }
    
    static testMethod void itarHCMEmployee1() {
        
        futureitarHCMEmployee1();
        Test.startTest();
        
        ITAR_Certified_Expiry_Batch icepBatch = new ITAR_Certified_Expiry_Batch();
        Database.executeBatch(icepBatch);
        
        ITAR_Schedule_CertifiedExpiryBatch batch = new ITAR_Schedule_CertifiedExpiryBatch();
        String sch = '0 0 * * * ?';
        system.schedule('ITAR_Certified_Expiry_Batch', sch, batch);  
        Test.stopTest();
    }
    
    static testMethod void itarContactAccessMethod() {
        
        itarContactAccessMethod2();
        Test.startTest();
        // Calling the Scheduler Class
        
        SchedulableContext sc;
        ITAR_Sch_Certified_Exp_PortalUsers_Batch scBatch = new ITAR_Sch_Certified_Exp_PortalUsers_Batch();
        scBatch.execute(sc);  
        
        Test.stopTest();
    }

    @future
    static void futureitarHCMEmployee() {    
        // create GF account and add to environment variables
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin' LIMIT 1];
        Profile profileAdmin = [Select Name,Id from Profile where Name = 'System Administrator' limit 1];
        PermissionSetAssignment pSet = [SELECT Id, AssigneeId,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Restricted_International_Regulations' AND Assignee.isactive=true limit 1];
        User thisUser = [SELECT Id, isportalEnabled,contactid, Name, Email FROM User WHERE id =: pset.AssigneeId and isActive = true limit 1];
        User portalUsr = [SELECT Id, Username FROM User WHERE Profileid =: profileObj.Id and isActive = true limit 1];
        
        IntegrationUsers__c skipUser = new IntegrationUsers__c(SetupOwnerId = thisUser.Id, Is_Integration_User__c= true, Skip_Trigger__c = true, Skip_Validation_Rule__c = true);
        insert skipUser;
        
            Account acctObj1=getAccount('MYTEST ACCOUNT1');
            EnvironmentVariable.put('HCM Emp AccountId',acctObj1.Id);
            
            List<Id> accIdList=new List<Id>(); 
            List<Id> conIdList1=new List<Id>();
            
            Contact conobj1=new Contact();
            conobj1.FirstName='Mr';
            conobj1.User_Name__c = 'abcportal@xyzgf.com.gf';
            conobj1.LastName='Testcon1';
            conobj1.AccountId=acctObj1.Id;
            conobj1.Email='con1@gf.com';
            conobj1.Department__c='Design';
            conobj1.ITAR_Access_Requested__c = false;
            insert conobj1;
        
            skipUser.Skip_Trigger__c =false;
            update skipUser;
            
        
        System.runAs(thisUser){
            
            conobj1.Is_Portal_User_Active__c = false;
            conobj1.ITAR_Access_Requested__c = true;
            conobj1.ITAR_Documents_Verified__c= true;
            conobj1.ITAR_Certified__c = true;
            
            update conobj1;
           
           // conIdList1.add(conobj1.Id);
           
            // Create a Case
            Case cs = new Case();
            cs.Application__c = 'Salesforce';
            cs.Business_process__c = 'Other GFV';
            cs.Description = 'ITAR provisioning for TEST'; //need to set
            cs.Region__c = 'US';
            cs.Severity__c = 'Normal';
            cs.Status ='New';
            cs.Subject = 'ITAR provisioning for TEST associated with TEST Account';
            cs.Support_Level__c = 'L1';
            cs.Type = 'Access Request';
            cs.Priority = 'Medium';
            cs.ITAR_Created_Case__c = true;
            insert cs;
            
            // Insert Portal_Tab_Access__c record
            //Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c = acctObj1.Id, User__c = portalUsr.Id, Contact__c= conobj1.id,DropBox_ITAR__c = false,TeamRoom_ITAR__c = false, DropBox_non_ITAR__c = false, Remote_Mask_Viewer_ITAR__c = false, Remote_Mask_Viewer_non_ITAR__c = false);
            // insert pta;
            //System.assert(pta.Id != null);
            
            // conobj1.ITAR_Certified__c = true;
            //update conobj1;
            
            // create test HCM Employees
            
            skipUser.Skip_Trigger__c =true;
            update skipUser;
            
            HCM_Employee__c hcmEmployee  = new HCM_Employee__c(ownerId = thisUser.id, First_Name__c='Test1', Last_Name__c='HCM Emp1',
                                             Email_Address__c='test11@test.com',Status__c='Active',
                                             ITAR_Certified__c = true, ITAR_End_Date__c = System.TODAY() + 1,
                                             Employee_ID__c='RC10001',Login_ID__c='RC1000',
                                             ITARCertified__c = false);
            
            insert hcmEmployee;
            
            hcmEmployee.First_Name__c = 'Test11';
            hcmEmployee.ITARCertified__c = true;
            hcmEmployee.ITAR_EndDate__c = System.TODAY() + 7;
            hcmEmployee.DropBox_Non_ITAR__c = true;
            hcmEmployee.Remote_Mask_Viewer_Non_ITAR__c = true;
            update hcmEmployee;
            
            hcmEmployee.TeamRoom_ITAR__c = false;
            update hcmEmployee;
            
        }  
    }
    
    @future
    static void futureitarHCMEmployee1() {    
        // create GF account and add to environment variables
        
        //Account acctObj=getAccount('MYTEST ACCOUNT1');
        
        Profile profileObj = [Select Name,Id from Profile where Name = 'Customer Portal Admin' LIMIT 1];
        Profile profileAdmin = [Select Name,Id from Profile where Name = 'System Administrator' limit 1];
        PermissionSetAssignment pSet = [SELECT Id, AssigneeId,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Restricted_International_Regulations' AND Assignee.isactive=true limit 1];
        User thisUser = [SELECT Id, isportalEnabled,contactid, Name, Email FROM User WHERE id =: pset.AssigneeId and isActive = true limit 1];
        User portalUsr = [SELECT Id, Username FROM User WHERE Profileid =: profileObj.Id and isActive = true limit 1];
        
        System.runAs(thisUser){
            Account acctObj2 = getAccount('MYTEST ACCOUNT2');
            EnvironmentVariable.put('HCM Emp AccountId',acctObj2.Id);
            List<Id> accIdList = new List<Id>(); 
            List<Id> conIdList1 = new List<Id>();
            
            Contact conobj2 = new Contact();
            conobj2.FirstName='Mr';
            conobj2.User_Name__c = portalUsr.UserName;
            conobj2.LastName='Testcon1';
            conobj2.AccountId = acctObj2.Id;
            conobj2.Email='con1@gf.com';
            conobj2.Department__c = 'Design';
            //conobj.ITAR_Access_Requested__c = false;
            //insert conobj2;
            
            conobj2.Is_Portal_User_Active__c = true;
            conobj2.ITAR_Access_Requested__c = true;
            conobj2.ITAR_Documents_Verified__c= true;
            
            conobj2.ITAR_Enabled_Date__c = System.today() - 364;
            conobj2.ITAR_Certified__c = true;
            insert conobj2;
            
            conIdList1.add(conobj2.Id);
            
            List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
            Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(Account__c = acctObj2.Id, User__c = thisUser.Id, Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write', Team_Role__c = 'Primary Account Manager');
            atpList.add(atp1);
            
            if(atpList.size() > 0) {    
                //insert atpList;
                System.assert(!atpList.isEmpty());
            }
            // Create a Case
            Case cs = new Case();
            cs.Application__c = 'Salesforce';
            cs.Business_process__c = 'Other GFV';
            cs.Description = 'ITAR provisioning for TEST'; //need to set
            cs.Region__c = 'US';
            cs.Severity__c = 'Normal';
            cs.Status ='New';
            cs.Subject = 'ITAR provisioning for TEST associated with TEST Account';
            cs.Support_Level__c = 'L1';
            cs.Type = 'Access Request';
            cs.Priority = 'Medium';
            cs.ITAR_Created_Case__c = true;
            insert cs;
            
            // Insert Portal_Tab_Access__c record
            Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c = acctObj2.Id, User__c = portalUsr.Id,Contact__c= conobj2.id,TeamRoom_ITAR__c = false, DropBox_non_ITAR__c = false,Remote_Mask_Viewer_non_ITAR__c = false);
            insert pta;
            System.assert(pta.Id != null);
            
            // create test HCM Employees
            
            
            HCM_Employee__c hcmEmployee  = new HCM_Employee__c(ownerId = thisUser.id, First_Name__c='Test2', Last_Name__c='HCM Emp2',
                                             Email_Address__c='test21@test.com',Status__c='Active',
                                             ITAR_Certified__c = true, ITAR_End_Date__c = System.TODAY() + 1,
                                             Employee_ID__c='RC10002',Login_ID__c='RC10002',
                                             ITARCertified__c = false);
            
            insert hcmEmployee;
            
            hcmEmployee.First_Name__c = 'Test21';
            hcmEmployee.ITARCertified__c = true;
            hcmEmployee.ITAR_EndDate__c = System.TODAY() + 1;
            hcmEmployee.DropBox_Non_ITAR__c = true;
            hcmEmployee.Remote_Mask_Viewer_Non_ITAR__c = true;
            update hcmEmployee;
            
            hcmEmployee.TeamRoom_ITAR__c = false;
            update hcmEmployee;
        }  
    }

    @future
    static void itarContactAccessMethod2() {
        Account testAcc = getAccount('MYTEST ACCOUNT1');
        Account testAcc1 = getAccount('MYTEST ACCOUNT2');
        
        List<Contact> conObjList = new List<Contact>();
        
        Contact conobj1 = new Contact();
        conobj1.FirstName='Mr';
        conobj1.LastName='Testcon1';
        conobj1.AccountId=testAcc.Id;
        conobj1.Email='con1@gf.com';
        conobj1.Department__c='Design';
        conobj1.ITAR_Access_Requested__c = True;
        conobj1.ITAR_Certified__c = True;
        conObjList.add(conobj1);
        //insert conobj1;
        
        Contact conobj2 = new Contact();
        conobj2.FirstName='Mr';
        conobj2.LastName='Testcon1';
        conobj2.AccountId=testAcc1.Id;
        conobj2.Email='con1@gf.com';
        conobj2.Department__c='Design';
        conobj2.ITAR_Access_Requested__c = True;
        conobj2.ITAR_Certified__c = True;
        conObjList.add(conobj2);
        //insert conobj2;
    
        if(conObjList.size() > 0) {
            insert conObjList;
        }
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        Profile portalAdmin = [SELECT Id FROM Profile WHERE Name='Customer portal Admin' LIMIT 1]; 
        
        List<User> userList = new List<User>();
        
        User u1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserxyz@gmail.com');
        userList.add(u1);    
        User u2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserabc@gmail.com');  
        userList.add(u2);
        User u3 = new User(Alias = 'standt3', Email='standarduser3@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = portalAdmin.Id, ContactId = conObjList[1].Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserxyz3@gmail.com');
        userList.add(u3);    
        User u4 = new User(Alias = 'standt4', Email='standarduser4@testorg.com', ContactId = conObjList[0].Id,
        EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = portalAdmin.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduserabc4@gmail.com');  
        userList.add(u4);
        
        if(userList.size() > 0) {    
            insert userList;
            System.assert(!userList.isEmpty());
        } 
         
        testAcc.Account_Manager__c = userList[0].Id;
        //update testAcc;
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[0].Id, Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write', Team_Role__c = 'Primary Account Manager');
        atpList.add(atp1);
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Account Administrator');
        atpList.add(atp2);
        Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(Account__c = testAcc1.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Primary Account Manager');
        atpList.add(atp3);
        
        if(atpList.size() > 0) {    
            insert atpList;
            System.assert(!atpList.isEmpty());
        }
        
        List<Contact> insertContacts = new List<Contact>();
        
        Contact con = new Contact(FirstName = 'GF',LastName = 'Test Con', AccountId = testAcc.Id, Email = userList[0].Email);
        insertContacts.add(con);
        //insert con;
        
        Contact con1 = new Contact(FirstName = 'GF1',LastName = 'Test Con1', AccountId = testAcc1.Id, Email = userList[1].Email);
        insertContacts.add(con1);
        
        if(insertContacts.size() > 0) {
            insert insertContacts;
            System.assert(!insertContacts.isEmpty());
        }
        
        List<Contact> updateContacts = new List<Contact>();
        
        insertContacts[0].Is_Portal_User_Active__c = true;
        insertContacts[0].Is_Portal_User_Created__c = true;
        insertContacts[0].ITAR_Documents_Verified__c = true;
        insertContacts[0].ITAR_Enabled_Date__c = System.Today() - 363;
        insertContacts[0].Account_Manager__c = Userinfo.getUserId();
        // con.ITAR_Access_Requested__c = true;
        insertContacts[0].ITAR_Certified__c = true;
        
        updateContacts.add(insertContacts[0]);
        
        insertContacts[1].Is_Portal_User_Active__c = true;
        insertContacts[1].Is_Portal_User_Created__c = true;
        insertContacts[1].ITAR_Documents_Verified__c = true;
        insertContacts[1].ITAR_Enabled_Date__c = System.Today() - 351; 
        insertContacts[1].Account_Manager__c = Userinfo.getUserId();
        // con.ITAR_Access_Requested__c = true;
        insertContacts[1].ITAR_Certified__c = True;
        
        updateContacts.add(insertContacts[1]);
        
        if(!updateContacts.isEmpty()) {
            update updateContacts;
        }
        System.assert(!updateContacts.isEmpty());
        
        List<Portal_Tab_Access__c> insertptaList = new List<Portal_Tab_Access__c>(); 
        // Insert Portal_Tab_Access__c record
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c = testAcc.Id, user__c= userList[2].Id, Update_by_Contact_Trigger__c = true, Contact__c= updateContacts[0].id, DropBox_non_ITAR__c = false,Remote_Mask_Viewer_non_ITAR__c = false );
        insertptaList.add(pta);
        
        Portal_Tab_Access__c pta1 = new Portal_Tab_Access__c(Account__c = testAcc1.Id,user__c= userList[3].Id, Update_by_Contact_Trigger__c = false, Contact__c= updateContacts[1].id, DropBox_non_ITAR__c = true,Remote_Mask_Viewer_non_ITAR__c = True,DropBox_ITAR__c= true);
        insertptaList.add(pta1);
    
        if(!insertptaList.isEmpty()) {
            insert insertptaList;
            System.assert(!insertptaList.isEmpty());
        }
        
        List<Portal_Tab_Access__c> updateptaList = new List<Portal_Tab_Access__c>();     
        
        insertptaList[0].DropBox_ITAR__c = False;       
        insertptaList[0].Remote_Mask_Viewer_ITAR__c = True;     
        
        updateptaList.add(insertptaList[0]);        
        
        insertptaList[1].DropBox_ITAR__c = True;        
        insertptaList[1].Remote_Mask_Viewer_ITAR__c = True;     
        
        updateptaList.add(insertptaList[1]);  
    
        if(!updateptaList.isEmpty()) {     
            update updateptaList;     
        }    
    }
    
    static testMethod void futureadd(){
    Test.startTest();
    futureaddpermissionset();
    Test.stopTest();
   } 
   
   static testMethod void futureremove(){
    Test.startTest();
    futureremovepermissionset();
    Test.stopTest();
    
   }
    
    static void futureaddpermissionset() {

        Profile profileAdmin = [Select Name,Id from Profile where Name = 'System Administrator' limit 1];
        User thisUser = [SELECT Id, Username FROM User WHERE Profileid =: profileAdmin.Id and isActive = true limit 1];
        
        System.runAs(thisUser){
           
            Account acctObj1=getAccount('MYTEST ACCOUNT1');
            EnvironmentVariable.put('HCM Emp AccountId',acctObj1.Id);

            // create test HCM Employees
            
            HCM_Employee__c hcmEmployee  = new HCM_Employee__c(ownerId = thisUser.id, First_Name__c='Test11', Last_Name__c='HCM Emp11',
                                             Email_Address__c='test111@test.com',Status__c='Active',
                                             ITAR_Certified__c = true, ITAR_End_Date__c = System.TODAY() + 1,
                                             Employee_ID__c='RC100011',Login_ID__c='RC10001',
                                             ITARCertified__c = false,User__c=thisUser.id);
            
            insert hcmEmployee;
            
            hcmEmployee.First_Name__c = 'Test11';
            hcmEmployee.ITARCertified__c = true;
            hcmEmployee.ITAR_EndDate__c = System.TODAY() + 7;
            hcmEmployee.DropBox_Non_ITAR__c = true;
            hcmEmployee.Remote_Mask_Viewer_Non_ITAR__c = true;
            update hcmEmployee;
            
            hcmEmployee.TeamRoom_ITAR__c = true;
            update hcmEmployee;
            

            }
            
    }    
    
    
    static void futureremovepermissionset() {

        Profile profileAdmin = [Select Name,Id from Profile where Name = 'System Administrator' limit 1];
        User thisUser = [SELECT Id, Username FROM User WHERE Profileid =: profileAdmin.Id and isActive = true limit 1];
        
           System.runAs(thisUser){
           
            Account acctObj1=getAccount('MYTEST ACCOUNT1');
            EnvironmentVariable.put('HCM Emp AccountId',acctObj1.Id);
            
            User u4 = new User(Alias = 'standt4', Email='standarduser4@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileAdmin.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserabc4@gmail.com');  
        
            insert u4;
            
            PermissionSet ps=[SELECT Id, Name FROM PermissionSet WHERE Name = 'Restricted_Team_Room_Permission_Set' LIMIT 1];

            PermissionSetAssignment ps1=new PermissionSetAssignment();
            ps1.AssigneeId=u4.Id;
            ps1.PermissionSetId=ps.Id;
            insert ps1;
            
           Set<Id> assignUserIds=new set<Id>();
           assignUserIds.add(u4.Id);
           AddRemoveTeamRoomITARPermSet.removeUsersFromPermissionSet(assignUserIds,ps.Name);

            // create test HCM Employees
            
            HCM_Employee__c hcmEmployee  = new HCM_Employee__c(ownerId = thisUser.id, First_Name__c='Test11', Last_Name__c='HCM Emp11',
                                             Email_Address__c='test1131@test.com',Status__c='Active',
                                             ITAR_Certified__c = true, ITAR_End_Date__c = System.TODAY() + 1,
                                             Employee_ID__c='RC100012',Login_ID__c='RC10003',
                                             ITARCertified__c =true,ITAR_EndDate__c =System.TODAY() + 7,
                                             DropBox_Non_ITAR__c =true,Remote_Mask_Viewer_Non_ITAR__c =true,TeamRoom_ITAR__c=true,User__c=u4.Id);
            
            insert hcmEmployee;
            
            hcmEmployee.TeamRoom_ITAR__c = false;
            update hcmEmployee;
           
            }
            
    }   

    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName LIMIT 1];
        return acct;
    } 
}