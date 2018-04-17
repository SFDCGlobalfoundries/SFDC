/******************************************************************************************************************************
Class:         CPQIPRequestTest
-------------------------------------------------------------------------------------------------------------------------------
Author:        Joydev Mondol (Cognizant - 153480)
Created Date:  2/11/2013
Reason:        Test class for triggers and classes on IP Request object
--
Ashwini     04092015    - Refactoring test class.
*******************************************************************************************************************************/
               
@isTest(SeeAllData=false)
private class CPQIPRequestTest{
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
        
        List<Map<String,Object>> fieldValueMapList = new List<Map<String,Object>>();
        for(integer i=1;i<=2;i++){        
            Map<String,Object> fieldValueMap = new Map<String,Object>();
            fieldValueMap.put('Name', 'MYTEST ACCOUNT'+i);            
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
        
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);

    }
    static testMethod void testIPRequestUpdateTrigger(){
        //Setup the IP Request test records and cause the insert trigger to excecute
        
        Account acc1 = getAccount('MYTEST ACCOUNT1');
        Account acc2 = getAccount('MYTEST ACCOUNT2');
        
        User u1 = createUser('u1@gf.com');
        User u2 = createUser('u2@gf.com');
        
        Account_Team_Proxy__c atp1 = createaccountTeamProxy(acc1.Id, u1.Id, 'Primary Account Manager');
        Account_Team_Proxy__c atp2 = createaccountTeamProxy(acc1.Id, u2.Id, 'Primary Field Application Engineer');
        
        IP_Request__c ipReq = createIPRequest(acc1.Id);
        ipReq.Customer_Account_Name__c = acc2.Id;
        
        Test.startTest();
        update ipReq;
        Test.stopTest();
    }
    
    static testMethod void testIPRequestInsertTrigger(){
        //Setup the IP Request test records and cause the insert trigger to excecute
        //DataUtilTest.loadEnvironmentVariables();
        Account acc = getAccount('MYTEST ACCOUNT1');
        
        User u1 = createUser('u1@gf.com');
        User u2 = createUser('u2@gf.com');
        List<User> users = new List<User>{u1,u2};
        insert users;
        
        Account_Team_Proxy__c atp1 = createaccountTeamProxy(acc.Id, u1.Id, 'Primary Account Manager');
        Account_Team_Proxy__c atp2 = createaccountTeamProxy(acc.Id, u2.Id, 'Primary Field Application Engineer');
        List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp1,atp2};
        insert atps;
        
        Test.startTest();
        createIPRequest(acc.Id);
        Test.stopTest();
    }
        
    
    //Static method to create Account Team Proxy test record
    static Account_Team_Proxy__c createaccountTeamProxy(Id accId, Id userId, String szRole){
        Account_Team_Proxy__c atprxy = new Account_Team_Proxy__c(Account__c = accId,
                                                                 User__c = userId,
                                                                 Team_Role__c = szRole,
                                                                 account_access__c = 'Read/Write',
                                                                 opportunity_access__c = 'Read/Write');
                
        return atprxy;
    }
    
    //Static method to create User test record
    static User createUser(String szUserName){
        Profile prf = [Select Id, 
                              Name 
                         From Profile 
                        Where Name = 'System Administrator'];
                        
        User xUser = new User(alias='standt',
                                email='standarduser@testorg.com',
                                emailencodingkey='UTF-8',
                                lastname='Testing', 
                                languagelocalekey='en_US',
                                localesidkey='en_US',
                                profileid = prf.Id,
                                Portal_Login__c = 'TestLogin0001',
                                timezonesidkey='America/Los_Angeles',
                                username=szUserName);
               
        return xUser;
    }
    
    //Static method to create IP Request test record
    static IP_Request__c createIPRequest(Id accId){
        IP_Request__c ipReq = new IP_Request__c(Customer_Account_Name__c = accId);
        
        insert ipReq;
        return ipReq;
    }
    
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}