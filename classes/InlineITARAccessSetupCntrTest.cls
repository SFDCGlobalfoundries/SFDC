@isTest
public class InlineITARAccessSetupCntrTest {   
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();            
        fieldValueMap.put('Name', 'MYTEST ACCOUNT1');            
        fieldValueMap.put('stage__c', 'Unqualified');
        fieldValueMap.put('short_name__c', 'MyTestACC1');
        fieldValueMap.put('sub_type__c', 'Direct');
        fieldValueMap.put('site_department__c', 'test dept');          
        fieldValueMap.put('transaction_type__c', 'transactional');
        fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
        fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
        fieldValueMap.put('region__c', 'US');
        fieldValueMap.put('Sales_Territory__c', 'US-East');
        fieldValueMap.put('FE_Territory__c', 'US-FE-East');
        fieldValueMap.put('financial_territory__c', 'US-East');          
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', '50 water st');  
        fieldValueMap.put('Corporate_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Corporate_City__c', 'Fremont');  
        fieldValueMap.put('Corporate_State__c', 'CA');       
        fieldValueMap.put('Corporate_Country__c', 'USA');
        fieldValueMap.put('Bill_To_Address_1__c', '50 water st');  
        fieldValueMap.put('Bill_To_Address_2__c', 'Suite B'); 
        fieldValueMap.put('Bill_To_City__c', 'Fremont');  
        fieldValueMap.put('Bill_To_State__c', 'CA');       
        fieldValueMap.put('Bill_To_Country__c', 'USA');
        fieldValueMap.put('Organization_Unit__c', 'GF Investment');
        fieldValueMap.put('bill_to_location__c', 'YES');
        fieldValueMap.put('total_employee__c', 100);          
        fieldValueMap.put('end_customer__c', 'people');
        fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
        fieldValueMap.put('Target_Account__c', 'Yes');
        fieldValueMap.put('Fab_9_10__c','No');      
        
        // Create Account
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
        
        // Create Account
        AccountDataFactory.createAccount(fieldValueMap1);
        // Insert Custom Settings Data
        List<Error_Codes__c> errorCodeList = new List<Error_Codes__c>();
        
        Error_Codes__c ec1 = new Error_Codes__c(Name = 'ITAR CERTIFIED IF PORTAL USER', Message__c = 'TEST EC1');
        errorCodeList.add(ec1);
        Error_Codes__c ec2 = new Error_Codes__c(Name = 'ITAR CERTIFIED IF DOCUMENTS VERIFIED', Message__c = 'TEST EC2');
        errorCodeList.add(ec2);
        Error_Codes__c ec3 = new Error_Codes__c(Name = 'ITAR APPS RESTRICTION', Message__c = 'TEST EC3');
        errorCodeList.add(ec3);
        
        if(errorCodeList.size() > 0) {
            insert errorCodeList;
            System.assert(!errorCodeList.isEmpty());
        }
        
        List<Environment_Variable__c> envVarList = new List<Environment_Variable__c>();
        
        Environment_Variable__c ev1 = new Environment_Variable__c(Name = 'ITAR Disclaimer', Value__c = 'TEST DISCLAIMER');
        envVarList.add(ev1);
        
        Environment_Variable__c ev2 = new Environment_Variable__c(Name = 'ITAR EDIT ACCESS SET UP', Value__c = 'DONT ALLOW ACCESS');
        envVarList.add(ev2);
        
        Environment_Variable__c ev3 = new Environment_Variable__c(Name = 'ACCT_TM_PRXY_TM_RL_PFTS', Value__c = 'Primary Field Application Engineer');
        envVarList.add(ev3);
        
        if(envVarList.size() > 0) {
            //insert envVarList;
            //System.assert(!envVarList.isEmpty());
        }
        
        List<ITAR_App_Provision_ATP_Roles__c> itarAppList = new List<ITAR_App_Provision_ATP_Roles__c>();
        
        ITAR_App_Provision_ATP_Roles__c itarApp1 = new ITAR_App_Provision_ATP_Roles__c(Name = 'Primary Account Manager');
        itarAppList.add(itarApp1);
        
        if(itarAppList.size() > 0) {
            insert itarAppList;
            System.assert(!itarAppList.isEmpty());
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
    
    static testMethod void itarContactAccessMethod1() {
        Account testAcc = getAccount('MYTEST ACCOUNT1');
        Account testAcc1 = getAccount('MYTEST ACCOUNT2');
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1]; 
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
        
        if(userList.size() > 0) {    
            insert userList;
            System.assert(!userList.isEmpty());
        }   
        
        List<Account_Team_Proxy__c> atpList = new List<Account_Team_Proxy__c>();
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[0].Id, Account_Access__c='Read/Write', Opportunity_Access__c='Read/Write', Team_Role__c = 'Primary Account Manager');
        atpList.add(atp1);
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(Account__c = testAcc1.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Account Administrator');
        atpList.add(atp2);
        
        if(atpList.size() > 0) {    
            insert atpList;
            System.assert(!atpList.isEmpty());
        }
        Test.startTest();
        Contact con = new Contact(FirstName = 'GF',LastName = 'Test Con', AccountId = testAcc.Id, Email = userList[0].Email,Is_Portal_User_Active__c = true,Is_Portal_User_Created__c = true,
                ITAR_Documents_Verified__c = true,ITAR_Access_Requested__c = true,ITAR_Certified__c = true);
        insert con;
        System.assert(con.Id != null);
        
        // Insert Portal_Tab_Access__c record
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c = testAcc.Id, Contact__c= con.id,TeamRoom_ITAR__c = false, DropBox_non_ITAR__c = false,Remote_Mask_Viewer_non_ITAR__c = false);
        insert pta;
        System.assert(pta != null);
        
        PageReference pageRef = Page.inlineITARAccessSetupPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(pta.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(pta);

        InlineITARAccessSetupCntr objCon = new InlineITARAccessSetupCntr(sc);
        objCon.validateAuthorization();
        objCon.edit();
        objCon.save();
        objCon.cancel();
        
        pta.TeamRoom_ITAR__c = true;    
        pta.DropBox_non_ITAR__c = true; 
        pta.Remote_Mask_Viewer_non_ITAR__c = true;
        update pta;
        
        objCon = new InlineITARAccessSetupCntr(sc);
        objCon.validateAuthorization();
        objCon.edit();
        objCon.save();
        objCon.cancel();
        
        Test.stopTest();
    } 
    
    private static Account getAccount(String AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName LIMIT 1];
        return acct;
    }
}