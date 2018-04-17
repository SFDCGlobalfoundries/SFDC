@isTest
public class InlineContactITARAppsExtCntrTest {   
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
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
		// Create Account
        AccountDataFactory.createAccount(fieldValueMap);
        
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
        Environment_Variable__c ev = new Environment_Variable__c(Name = 'ITAR Disclaimer', Value__c = 'TEST DISCLAIMER');
        
        List<ITAR_App_Provision_ATP_Roles__c> itarAppList = new List<ITAR_App_Provision_ATP_Roles__c>();
        
        ITAR_App_Provision_ATP_Roles__c itarApp1 = new ITAR_App_Provision_ATP_Roles__c(Name = 'Primary Account Manager');
        itarAppList.add(itarApp1);
        
        if(itarAppList.size() > 0) {
        	insert itarAppList;
        	System.assert(!itarAppList.isEmpty());
        }
    }
	
	static testMethod void itarContactMethod1() {
		Account testAcc = getAccount('MYTEST ACCOUNT1');
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
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Account Administrator');
        atpList.add(atp2);
        
        if(atpList.size() > 0) {    
			insert atpList;
			System.assert(!atpList.isEmpty());
        }
        
        Contact con = new Contact(FirstName = 'GF',LastName = 'Test Con', AccountId = testAcc.Id, Email = userList[0].Email);
        insert con;
        System.assert(con.Id != null);
        Test.startTest();
        con.Is_Portal_User_Active__c = true;
        con.Is_Portal_User_Created__c = true;
        update con;
        System.assert(con.Id != null);
        
        PageReference pageRef = Page.inlineContactITARAppsPage;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('Id', String.valueOf(con.Id));
		ApexPages.StandardController sc = new ApexPages.StandardController(con);
		
		InlineContactITARAppsExtCntr objCon = new InlineContactITARAppsExtCntr(sc);
		objCon.validateAuthorization();
		objCon.edit();
		objCon.save();
		objCon.cancel();	
		Test.stopTest();	
	} 
	
	static testMethod void itarContactMethod2() {
		Account testAcc = getAccount('MYTEST ACCOUNT1');
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
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Account Administrator');
        atpList.add(atp2);
        
        if(atpList.size() > 0) {    
			insert atpList;
			System.assert(!atpList.isEmpty());
        }
        Test.startTest();
        Contact con = new Contact(FirstName = 'GF',LastName = 'Test Con', AccountId = testAcc.Id, Email = userList[0].Email, Is_Portal_User_Active__c = false, ITAR_Certified__c = true, ITAR_Access_Requested__c = false, ITAR_Case_Number__c = '123452');
        insert con;
        System.assert(con.Id != null);
        
        PageReference pageRef = Page.inlineContactITARAppsPage;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('Id', String.valueOf(con.Id));
		ApexPages.StandardController sc = new ApexPages.StandardController(con);
		
		InlineContactITARAppsExtCntr objCon = new InlineContactITARAppsExtCntr(sc);
		objCon.validateAuthorization();
		objCon.edit();
		objCon.save();
		objCon.cancel();	
		
		con.Is_Portal_User_Active__c = true;
		con.ITAR_Certified__c = true;
        //con.ITAR_Access_Requested__c = true; 
		con.ITAR_Documents_Verified__c = false;
		update con;
		
		objCon = new InlineContactITARAppsExtCntr(sc);
		objCon.validateAuthorization();
		objCon.edit();
		objCon.save();
		objCon.cancel();	
		
		con.ITAR_Documents_Verified__c = true;
		update con;
		
		objCon = new InlineContactITARAppsExtCntr(sc);
		objCon.validateAuthorization();
		objCon.edit();
		objCon.save();
		objCon.cancel();	
        Test.stopTest();
	} 
	
	static testMethod void itarContactMethod3() {
		Account testAcc = getAccount('MYTEST ACCOUNT1');
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
        Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(Account__c = testAcc.Id, User__c = userList[1].Id,Account_Access__c='Read/Write',Opportunity_Access__c='Read/Write', Team_Role__c = 'Account Administrator');
        atpList.add(atp2);
        Test.startTest();
        if(atpList.size() > 0) {    
			insert atpList;
			System.assert(!atpList.isEmpty());
        }
        
        Contact con = new Contact(FirstName = 'GF',LastName = 'Test Con', AccountId = testAcc.Id, Email = userList[0].Email, Is_Portal_User_Active__c = false, ITAR_Certified__c = true, ITAR_Access_Requested__c = true, ITAR_Case_Number__c = '123452');
        insert con;
        System.assert(con.Id != null);
        
        PageReference pageRef = Page.inlineContactITARAppsPage;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('Id', String.valueOf(con.Id));
		ApexPages.StandardController sc = new ApexPages.StandardController(con);
		
		InlineContactITARAppsExtCntr objCon = new InlineContactITARAppsExtCntr(sc);
		objCon.validateAuthorization();
		objCon.edit();
		objCon.save();
		objCon.cancel();	
		
		con.ITAR_Documents_Verified__c = true;
		update con;
		
		objCon = new InlineContactITARAppsExtCntr(sc);
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