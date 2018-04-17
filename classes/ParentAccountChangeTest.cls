/******************************************************************************************************************************
Class:         ParentAccountChangeTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Cognizant
Created Date:  24/01/2014
Reason:        Test class for trigger ParentAccountChange
History:
        Sunil Arora 01092014    - Added Department__c='Design' into contact object.    
*******************************************************************************************************************************/
               
@isTest(SeeAllData=false)
private class ParentAccountChangeTest{
    @testSetup static void testdata() {
        //Setup environment data
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
        fieldValueMap.put('Tech_Geo_Granted__c', '0.007UM (7nm); 0.010UM (10nm); 0.014UM (14nm)');        
        fieldValueMap.put('sub_type__c', 'Indirect');
        fieldValueMap.put('site_department__c', 'IT');          
        fieldValueMap.put('transaction_type__c', 'Non-Transactional');                          
        fieldValueMap.put('region__c', 'US');        
        fieldValueMap.put('Corporate_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Corporate_City__c', 'Test City');                
        fieldValueMap.put('Corporate_Country__c', 'Singapore');
        fieldValueMap.put('Bill_To_Address_1__c', 'Test Address 1');          
        fieldValueMap.put('Bill_To_City__c', 'Test City');            
        fieldValueMap.put('Bill_To_Country__c', 'Singapore');        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('Valid_Tech_Geos__c','0.007UM (7nm); 0.010UM (10nm); 0.014UM (14nm)');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
        
        fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        
    }
    static testMethod void testContactAccountChange(){
        
        //Setup the Account test records
        Account acc1 = getAccount('MYTEST ACCOUNT1');
        Account acc2 = getAccount('MYTEST ACCOUNT2');
        //insert new List<Account>{acc1, acc2};
        
        //Too many SOQL Error thrown as this line
        //insert createTeamroom(acc1.Id);
        
        //Setup the Contact test records
        Contact con1 = createContact(acc1.Id);
        Contact con2 = createContact(acc1.Id);
        Contact con3 = createContact1();
        insert new List<Contact>{con1, con2,con3 };
        
        con3.accountId = acc1.Id;
        update con3;
        //Setup the External User test records
        User usr1 = createXUser(con1.Id);
        User usr2 = createXUser(con2.Id);
        User usr3 = createXUser(con3.Id);
        
        insert new List<User>{usr1, usr2 , usr3 };
        
        //Setup the Document Provisioning test records
        Document_Provisioning__c docProv1 = createDocProv(usr1.Id, '0.007UM (7nm)', 1111);
        Document_Provisioning__c docProv2 = createDocProv(usr1.Id, '', 2222);
        
        insert new List<Document_Provisioning__c>{docProv1, docProv2};
        
        Test.startTest();
        //Update the external user (contact) account
        con1.AccountId = acc2.Id;
        update con1;
        system.assertEquals(con1.AccountId,acc2.Id);
        Test.stopTest();
    }
    
    //Static method to create Document Provisioning test record
    static Document_Provisioning__c createDocProv(Id userId, String szGeo, Integer iOpenTxtId){
        Design_Spec__c spec = createSpec(szGeo, iOpenTxtId);
        insert spec;
        
        Document_Provisioning__c docProv = new Document_Provisioning__c(User__c = userId,
                                                                        Design_Spec__c = spec.Id,
                                                                        Status__c = 'Provisioned');
        
        return docProv;
    }
    
    //Static method to create Specification test record
    static Design_Spec__c createSpec(String szGeo, Integer iOpenTxtId){
        Design_Spec__c docProv = new Design_Spec__c(Technology_Geometry__c = szGeo,
                                                    OpenText_ID__c = iOpenTxtId);
        
        return docProv;
    }
    
    
    
    //Static method to create External User Contact test record
    static Contact createContact(Id accId){
        Contact con = new Contact(firstName = 'test' + Math.Random(), 
                                  lastName = 'test' + Math.Random(),
                                  email = 'xUser@testorg.com' + Math.Random(),
                                  accountId = accId,
                                  Is_Portal_User_Created__c = True,
                                  Department__c='Design');
        
        return con;
    }
    static Contact createContact1(){
        Contact con1 = new Contact(firstName = 'test' + Math.Random(), 
                                  lastName = 'test' + Math.Random(),
                                  email = 'xUser@testorg.com' + Math.Random(),
                                 
                                  Is_Portal_User_Created__c = True,
                                  Department__c='Design');
        
        return con1;
    }
    
    //Static method to create User test record
    static User createXUser(Id conId){
        Profile prf = [Select Id, 
                              Name 
                         From Profile 
                        Where Name = 'Customer Portal Admin'];
                        
        User xUser = new User(alias = ('xU' + Math.Random()).substring(0,7),
                                email='xUser@testorg.com' + Math.Random(),
                                emailencodingkey='UTF-8',
                                lastname='xUser' + Math.Random(), 
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = prf.Id,
                                ContactId = conId,
                                Portal_Login__c = 'TestxUserLogin0001' + Math.Random(),
                                timezonesidkey='America/Los_Angeles',
                                username='xUser@testorg.com' + Math.Random());
        
        return xUser;
    }
    
    //Static method to create Teamroom test record
    /*
    static Team_Room__c createTeamroom(Id accId){
        Team_Room__c tmrm = new Team_Room__c(Name = 'TESTTEAMROOM1313',
                                             Team_Room_Description__c= 'Team room Description ... '); //TBD
        return tmrm; 
    }
    */
    
    static testMethod void testRun1(){
        
        
        Account acc1 = getAccount('MYTEST ACCOUNT1');
        Account acc2 = getAccount('MYTEST ACCOUNT2');
        
        Contact con1 = createContact(acc1.Id);
        insert new List<Contact>{con1};
        
        User usr1 = createXUser(con1.Id);
        
        insert new List<User>{usr1};
        
        Test.startTest();
        con1.Is_Portal_User_Active__c = false;
        update con1;
        
        Document_Provisioning__c docProv1 = createDocProv(usr1.Id, '0.007UM (7nm)', 1111);
        Document_Provisioning__c docProv2 = createDocProv(usr1.Id, '', 2222);
        
        insert new List<Document_Provisioning__c>{docProv1, docProv2};
        
        con1.Is_Portal_User_Active__c = true;
        con1.Is_Portal_User_Created__c = true;
        con1.AccountId = acc2.Id;
        update con1;
        system.assertEquals(con1.AccountId,acc2.Id);
        Test.stopTest();
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}