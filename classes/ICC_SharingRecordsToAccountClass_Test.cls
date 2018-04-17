/**
* Author: Anil Kumar Reddy L
* Company: JK Technosoft
* Project: ICC
* Description: Test Class for ICC_SharingRecordsToAccountClass
* History
*    Anil Kumar Reddy L 23/05/2017 - Created  
**/
@isTest
public class ICC_SharingRecordsToAccountClass_Test {
    @TestSetup
    public static void setup() { 
       	DataUtilTest.loadEnvironmentVariables();
        List<Map<String,Object>> accList = new List<Map<String,Object>>();
        RecordType rt = [SELECT  Id FROM RecordType WHERE SObjectType = 'Account'  AND Name = 'Customer'];
        Map<String,Object> fieldValueMap = New Map<String,Object>();
        fieldValueMap.put('Name','NamePvt company');
        fieldValueMap.put('Stage__c','Unqualified');
        fieldValueMap.put('Site_Department__c','Test Department1');
        fieldValueMap.put('Sub_Type__c','Direct');
        fieldValueMap.put('Transaction_Type__c','Transactional');
        fieldValueMap.put('Region__c','APJ');
        fieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
        fieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
        fieldValueMap.put('Bill_To_City__c','Test City');
        fieldValueMap.put('Corporate_City__c','Test City');
        fieldValueMap.put('Bill_To_Country__c','Singapore');
        fieldValueMap.put('Corporate_Country__c','Singapore');
        fieldValueMap.put('RecordTypeId',rt.id);
        fieldValueMap.put('Short_Name__c','TestAcct');
		accList.add(fieldValueMap);
              
        Map<String,Object> SecondFieldValueMap = New Map<String,Object>();
        SecondFieldValueMap.put('Name','NameSecond company');
        SecondFieldValueMap.put('Stage__c','Unqualified');
        SecondFieldValueMap.put('Site_Department__c','Test Department1');
        SecondFieldValueMap.put('Sub_Type__c','Direct');
        SecondFieldValueMap.put('Transaction_Type__c','Transactional');
        SecondFieldValueMap.put('Region__c','APJ');
        SecondFieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
        SecondFieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
        SecondFieldValueMap.put('Bill_To_City__c','Test City');
        SecondFieldValueMap.put('Corporate_City__c','Test City');
        SecondFieldValueMap.put('Bill_To_Country__c','Singapore');
        SecondFieldValueMap.put('Corporate_Country__c','Singapore');
        SecondFieldValueMap.put('RecordTypeId',rt.id);
        SecondFieldValueMap.put('Short_Name__c','TestAcct2');
        accList.add(SecondFieldValueMap);
        
        List<Account> accntObjs = AccountDataFactory.createAccounts(accList,2);
        system.debug('accntObj#######'+accntObjs);
        
        //List<Map<String,Object>> accSecList = new List<Map<String,Object>>();
        Map<String,Object> chldFieldValueMap = New Map<String,Object>();
        chldFieldValueMap.put('Name','accntChildObj');
        chldFieldValueMap.put('Stage__c','Unqualified');
        chldFieldValueMap.put('Site_Department__c','Test Department1');
        chldFieldValueMap.put('Sub_Type__c','Direct');
        chldFieldValueMap.put('Transaction_Type__c','Transactional');
        chldFieldValueMap.put('Region__c','APJ');
        chldFieldValueMap.put('Bill_To_Address_1__c','Test Address 1');
        chldFieldValueMap.put('Corporate_Address_1__c','Corporate Address 1');
        chldFieldValueMap.put('Bill_To_City__c','Test City');
        chldFieldValueMap.put('Corporate_City__c','Test City');
        chldFieldValueMap.put('Bill_To_Country__c','Singapore');
        chldFieldValueMap.put('Corporate_Country__c','Singapore');
        chldFieldValueMap.put('RecordTypeId',rt.id);
        chldFieldValueMap.put('Short_Name__c','TestAcct3');
        chldFieldValueMap.put('parentid',accntObjs[1].id);
		//accSecList.add(chldFieldValueMap);
		Account accntChildObj = AccountDataFactory.createAccount(chldFieldValueMap);
        system.debug('accntChildObj#######'+accntChildObj);
		
		
        Map<String,Object> secondLeveFldMap = New Map<String,Object>();
        secondLeveFldMap.put('Name','accntGrndChildObj');
        secondLeveFldMap.put('Stage__c','Unqualified');
        secondLeveFldMap.put('Site_Department__c','Test Department1');
        secondLeveFldMap.put('Sub_Type__c','Direct');
        secondLeveFldMap.put('Transaction_Type__c','Transactional');
        secondLeveFldMap.put('Region__c','APJ');
        secondLeveFldMap.put('Bill_To_Address_1__c','Test Address 1');
        secondLeveFldMap.put('Corporate_Address_1__c','Corporate Address 1');
        secondLeveFldMap.put('Bill_To_City__c','Test City');
        secondLeveFldMap.put('Corporate_City__c','Test City');
        secondLeveFldMap.put('Bill_To_Country__c','Singapore');
        secondLeveFldMap.put('Corporate_Country__c','Singapore');
        secondLeveFldMap.put('RecordTypeId',rt.id);
        secondLeveFldMap.put('Short_Name__c','TestAcct5');
        secondLeveFldMap.put('parentid',accntChildObj.id);
        //accSecList.add(secondLeveFldMap);
       	Account accntGrndChildObj = AccountDataFactory.createAccount(secondLeveFldMap);
		system.debug('accntGrndChildObj#######'+accntGrndChildObj);
		
		List<Contact> contList = new List<Contact>();
        Contact con1 = new Contact(
            LastName = 'test',
            FirstName = 'testing1',
            AccountId = accntChildObj.Id,
            Email = 'test@testing.com',
            Department__c = 'Design',
            Status__c = 'Draft',
            Is_Portal_User_Active__c=false,
            Is_Portal_User_Created__c =false
        );
        contList.add(con1);
        insert contList;
        system.debug('contList#######'+contList);
		checkRecursive.run = true;
        List<Profile> lstProfiles = [Select Id, Name from Profile where name = 'Customer Portal Admin'];
         
        User portalUser = new User(ProfileId = lstProfiles[0].Id,
                                   Username = 'portaluser@testorg.com',
                                   Alias = 'auser',
                                   Email='portaluser@testorg.com',
                                   EmailEncodingKey='UTF-8',
                                   Firstname='Bruce',
                                   Lastname='Wayne',
                                   LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US',
                                   TimeZoneSidKey='America/Chicago',
                                   Portal_Login__c='abc1',
                                   IsActive = true, 
                                   ContactId = contList[0].Id , 
                                   HCM_Login_ID__c='abc',
                                   federationidentifier='abcdef'
                                  );
        insert portalUser;
        
		ICC_ContractSoldToAccounts__c iccCon = new ICC_ContractSoldToAccounts__c();
        iccCon.Name = 'DMEA';
        insert iccCon;
    }
    
    
    public static testMethod void icc_Sharing_Shipment(){
        test.startTest();
		System.debug('icc_Sharing_Shipment%%%%% Start');
        List<Account> accntObjs = [select id,name from Account];
        Account firstParentHry;
        Account zerothParentHry;
        Account accntGrndChildObj;
		for(Account acc : accntObjs ){
			if(acc.name == 'accntGrndChildObj'){
				accntGrndChildObj = acc;
			}
            if(acc.name == 'NameSecond company'){
                firstParentHry = acc;
            }
            if(acc.name == 'NamePvt company'){
                zerothParentHry = acc;
            }
		}
		system.debug('accntGrndChildObj&&&'+accntGrndChildObj);
		checkRecursive.run = true;
        
        List<Shipment__c> shipList = new List<Shipment__c>();
        
        Shipment__c ship3 = new Shipment__c();
        ship3.Account__c = firstParentHry.id;
        ship3.Contract_Sold_To_Account__c = zerothParentHry.id;
        ship3.Contract_Sold_To__c = 'DMEA';
        ship3.Name = 'SalesOrder3';
       	shipList.add(ship3);
        
        Shipment__c ship1 = new Shipment__c();
        ship1.Account__c = zerothParentHry.id;
        ship1.End_Customer_Account__c = accntGrndChildObj.id;
        ship1.Name = 'SalesOrder1';
        shipList.add(ship1);

        Shipment__c ship2 = new Shipment__c();
        ship2.Account__c = zerothParentHry.id;
        ship2.Contract_Sold_To_Account__c = accntGrndChildObj.id;
        ship2.Contract_Sold_To__c = 'DMEA';
        ship2.Name = 'SalesOrder2';
       	shipList.add(ship2);
        
		insert shipList;
       	System.debug('shipList%%%%% Start'+shipList);
        checkRecursive.run = true;
        Map<id,Contact> oldContMap = new Map<id,Contact>();
      Contact con2 = new Contact(
            LastName = 'test',
            FirstName = 'testing44',
            AccountId = firstParentHry.Id,
            Email = 'test44@testing.com',
            Department__c = 'Design',
            Status__c = 'Draft',
            Is_Portal_User_Active__c=false,
            Is_Portal_User_Created__c =false
        );
        Insert con2;
        oldContMap.put(con2.id, con2);
		System.debug('con2%%%%% Start'+con2);
		
         checkRecursive.run = true;
			List<Profile> lstProfiles = [Select Id, Name from Profile where name = 'Customer Portal Admin'];
			User portalUser2 = new User(ProfileId = lstProfiles[0].Id,
									   Username = 'portaluser11@testorg.com',
									   Alias = 'auser11',
									   Email='portaluser11@testorg.com',
									   EmailEncodingKey='UTF-8',
									   Firstname='Bruce11',
									   Lastname='Wayne11',
									   LanguageLocaleKey='en_US',
									   LocaleSidKey='en_US',
									   TimeZoneSidKey='America/Chicago',
									   Portal_Login__c='abcpl111',
									   IsActive = true, 
									   ContactId = con2.Id , 
									   HCM_Login_ID__c='abchd112',
									   federationidentifier='fedTdy'
									  );
			insert portalUser2;
			System.debug('portalUser2%%%%% '+portalUser2);
					
			checkRecursive.run = true;
        
        List<Shipment__c> updlst = new List<Shipment__c>();
        Shipment__c shipUpd1 = new Shipment__c(id=shipList[0].id , Contract_Sold_To_Account__c = accntObjs[1].id,Contract_Sold_To__c = 'DMEA');
    	updlst.add(shipUpd1);
        Shipment__c shipUpd2 = new Shipment__c(id=shipList[2].id , Account__c = accntGrndChildObj.id , Contract_Sold_To_Account__c = accntObjs[0].id,Contract_Sold_To__c = 'DMEA');
		updlst.add(shipUpd2);
        Shipment__c shipUpd3 = new Shipment__c(id=shipList[1].id , Account__c = accntGrndChildObj.id , End_Customer_Account__c = accntObjs[0].id);
		updlst.add(shipUpd3);
        system.debug('updlst**'+updlst);
        update updlst;
		System.debug('updlst%%%%% '+updlst);
        System.debug('icc_Sharing_Shipment%%%%% End');
        List<contact> contList = new List<contact>();
        contList.add(con2);
        ICC_SharingRecordsToAccountClass icc = new ICC_SharingRecordsToAccountClass();
        Map<id,Set<id>> mapAcc = new Map<id,Set<id>>();
        set<id>  childset = new set <id>();
        childset.add(accntGrndChildObj.id);
        mapAcc.put(firstParentHry.id, childset);
        //createAccountSalesMap (List<contact> triggerNewContact , List<sobject> sObjectList, Map<id,Set<id>> acctHrcyMap, String shareObjName){
        icc.createAccountSalesMap(contList,updlst,mapAcc,'Shipment__Share');
        
        Map<id,Contact> newContMap = new Map<id,Contact>([select id,name,AccountId ,Email ,Is_Portal_User_Active__c,Is_Portal_User_Created__c from contact where id =:con2.id]);
        system.debug('newContMap***'+newContMap);
        contact cont = newContMap.get(con2.id);
        cont.Is_Portal_User_Active__c = true;
        cont.Is_Portal_User_Created__c = true;
        newContMap.put(con2.id,cont);
        ICC_SharingRecordsToAccountClass.shareAccessToPortalAccounts(newContMap,oldContMap );
        test.stopTest();
    }
    
    public static testMethod void icc_Sharing_SalesOrder(){
        test.startTest();
		System.debug('icc_Sharing_SalesOrder%%%%% Start');
        List<Account> accntObjs = [select id,name from Account];
		system.debug('accntObjs**'+accntObjs);
        Account accntGrndChildObj;
		for(Account acc : accntObjs ){
			if(acc.name == 'accntGrndChildObj'){
				accntGrndChildObj = acc;
			}
		}
		
        List<Sales_Order_Line__c> soList = new List<Sales_Order_Line__c>();
        Sales_Order_Line__c salesOrd = new Sales_Order_Line__c();
        salesOrd.Account__c = accntObjs[0].id;
        salesOrd.End_Customer_Account__c = accntGrndChildObj.id;
        salesOrd.Name = 'SalesOrder1';
        soList.add(salesOrd);

        Sales_Order_Line__c salesOrd2 = new Sales_Order_Line__c();
        salesOrd2.Account__c = accntObjs[0].id;
        salesOrd2.Contract_Sold_To_Account__c = accntGrndChildObj.id;
        salesOrd2.Contract_Sold_To__c = 'DMEA';
        salesOrd2.Name = 'SalesOrder2';
       	soList.add(salesOrd2);
        
        Sales_Order_Line__c salesOrd3 = new Sales_Order_Line__c();
        salesOrd3.Account__c = accntObjs[0].id;
        salesOrd3.Name = 'SalesOrder3';
       	soList.add(salesOrd3);
        
        Sales_Order_Line__c salesOrd4 = new Sales_Order_Line__c();
        salesOrd4.Account__c = accntObjs[0].id;
        salesOrd4.Contract_Sold_To_Account__c = accntGrndChildObj.id;
        salesOrd4.Name = 'SalesOrder4';
       	soList.add(salesOrd4);
        
        insert soList;
        system.debug('soList**'+soList);
        checkRecursive.run = true;
         Sales_Order_Line__c salesOrdUpd = new Sales_Order_Line__c(id=soList[0].id , Contract_Sold_To_Account__c = accntObjs[1].id,Contract_Sold_To__c = 'DMEA');
    	system.debug('salesOrdUpd**'+salesOrdUpd);
        update salesOrdUpd;
        system.debug('salesOrdUpd**'+salesOrdUpd);
      
		System.debug('icc_Sharing_SalesOrder%%%%% End');
        
        test.stopTest();
    }
    
    public static testMethod void icc_Sharing_LotStatus(){
        test.startTest();
		System.debug('icc_Sharing_LotStatus%%%%% Start');
      	List<Account> accntObjs = [select id,name from Account];
        Account accntGrndChildObj;
		for(Account acc : accntObjs ){
			if(acc.name == 'accntGrndChildObj'){
				accntGrndChildObj = acc;
			}
		}
        checkRecursive.run = true;
        List<LOT_Status__c> lotStatList = new List<LOT_Status__c>();
        LOT_Status__c lotstat = new LOT_Status__c();
        lotstat.Account__c = accntObjs[0].id;
        lotstat.End_Customer_Account__c = accntGrndChildObj.id;
        lotstat.Name = 'SalesOrder1';
        lotStatList.add(lotstat);

        LOT_Status__c lotStat2 = new LOT_Status__c();
        lotStat2.Account__c = accntObjs[0].id;
        lotStat2.Contract_Sold_To_Account__c = accntGrndChildObj.id;
        lotStat2.Contract_Sold_To__c = 'DMEA';
        lotStat2.Name = 'SalesOrder2';
       	lotStatList.add(lotStat2);
        
        insert lotStatList;
		System.debug('lotStatList%%%%% Start'+lotStatList);
        checkRecursive.run = true;
        LOT_Status__c lotStatUpd = new LOT_Status__c(id=lotStatList[0].id , Contract_Sold_To_Account__c = accntObjs[1].id,Contract_Sold_To__c = 'DMEA');
    	system.debug('lotStatUpd**'+lotStatUpd);
        update lotStatUpd;
        System.debug('icc_Sharing_LotStatus%%%%% End');
        test.stopTest();
    }

    public static testMethod void icc_Sharing_LOTHistory(){
        test.startTest();
		System.debug('icc_Sharing_LOTHistory%%%%% Start');
      	List<Account> accntObjs = [select id,name from Account];
        Account accntGrndChildObj;
		for(Account acc : accntObjs ){
			if(acc.name == 'accntGrndChildObj'){
				accntGrndChildObj = acc;
			}
		}
        checkRecursive.run = true;
        List<LOT_History__c> lotHstList = new List<LOT_History__c>();
        LOT_History__c lotHis1 = new LOT_History__c();
        lotHis1.Account__c = accntObjs[0].id;
        lotHis1.End_Customer_Account__c = accntGrndChildObj.id;
        lotHis1.Name = 'SalesOrder1';
        lotHstList.add(lotHis1);

        LOT_History__c lotHis2 = new LOT_History__c();
        lotHis2.Account__c = accntObjs[0].id;
        lotHis2.Contract_Sold_To_Account__c = accntGrndChildObj.id;
        lotHis2.Contract_Sold_To__c = 'DMEA';
        lotHis2.Name = 'SalesOrder2';
       	lotHstList.add(lotHis2);
        
        insert lotHstList;
		System.debug('lotHstList%%%%% lotHstList'+lotHstList);
        checkRecursive.run = true;
        LOT_History__c lotHisUpd = new LOT_History__c(id=lotHstList[0].id , Contract_Sold_To_Account__c = accntObjs[1].id,Contract_Sold_To__c = 'DMEA');
    	system.debug('lotStatUpd**'+lotHisUpd);
        update lotHisUpd;
        System.debug('lotHisUpd%%%%%'+lotHisUpd);
        test.stopTest();
    }

}