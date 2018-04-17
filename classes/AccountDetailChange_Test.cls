/*
    Author: Ariz Solito
    Description: Apex test class for AccountDetailChange class
    History: 
    Asolito      23/04/2013     - Apex code created
    ZAmbat       04282014       - Updated code to SeeAllData=true as fix for SFDC test limitations.
    Tlai         19052014       - Updated Territory value of account
    Ashwini      04132015       - Updated code for making SeeAllData=false and refactoring of test class.    
*/
@istest(SeeAllData=false)
public with sharing class AccountDetailChange_Test {    
    
    @testSetup static void testdata() {
            DataUtilTest.loadEnvironmentVariables();  
            
            Map<String,Object> fieldValueMap = new Map<String,Object>();            
            fieldValueMap.put('Name', 'TEST rec');            
            fieldValueMap.put('stage__c', 'Unqualified');
            fieldValueMap.put('short_name__c', 'TESTrec2');
            fieldValueMap.put('sub_type__c', 'Direct');
            fieldValueMap.put('site_department__c', 'test dept');          
            fieldValueMap.put('transaction_type__c', 'transactional');
            fieldValueMap.put('account_profile__c', 'Fabless - Emerging');            
            fieldValueMap.put('Process_Tech_Interested__c', 'Mature (> 0.11um)');
            fieldValueMap.put('region__c', 'APJ');
            fieldValueMap.put('Sales_Territory__c', 'Japan Korea');
            fieldValueMap.put('financial_territory__c', 'Japan Korea');          
            fieldValueMap.put('Copy_Address__c', true);
            fieldValueMap.put('Corporate_Address_1__c', 'Lee');            
            fieldValueMap.put('Corporate_Country__c', 'Japan');
            fieldValueMap.put('Organization_Unit__c', 'GF Investment LLC OU');
            fieldValueMap.put('bill_to_location__c', 'YES');
            fieldValueMap.put('total_employee__c', 100);          
            fieldValueMap.put('end_customer__c', 'people');
            fieldValueMap.put('Revenue_Potential__c', 'High Potential');            
            fieldValueMap.put('Target_Account__c', 'Yes');
            fieldValueMap.put('Fab_9_10__c','No');
            
            AccountDataFactory.createAccount(fieldValueMap);                                                 
    }
        
    static testMethod void testClass(){
    
        List<User> users = new List<User>();
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');       
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');               
        
        User u2 = new User(alias = 'ts2', email='testaccss2@test.com',
        emailencodingkey='UTF-8', lastname='TestLast2', firstname='TestFirst2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss23@test.com',communitynickname='tsss2',FederationIdentifier='Test3');      
        
        User u3 = new User(alias = 'ts3', email='testaccss3@test.com',
        emailencodingkey='UTF-8', lastname='TestLast3', firstname='TestFirst3', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss24@test.com',communitynickname='tsss3',FederationIdentifier='Test4');
        
        test.startTest();
                
        users.add(u); 
        users.add(u1);
        users.add(u2);
        users.add(u3);   
        insert users;                               
                       
        System.runAs(u){
        
            //creating a new account will fire the account proxy trigger and will call the send() method of the class                                                                   
            Account acc = getAccount('TEST rec');                                                         
                        
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = u1.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1'
            );
            
            Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = u2.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='2',
                Account_Role_ID__c='test2'
            );
            
            Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = u3.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Application Engineer',
                Sequence_No__c='3',
                Account_Role_ID__c='test3'
            );
            
            List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3};             
            insert atps;
            
            Contact con = new Contact(
                firstName = 'test', 
                lastName = 'test',
                accountId = acc.id
            );
            insert con;  
                                  
            test.stopTest();
            //call the methods under the class
            AccountDetailChange.setPrimaryAddress(new List<String>{acc.id});             
                                              
            AccountDetailChange.send(acc);
            AccountDetailChange.send(con);                                 
            
        }                               
    }
    
    static testMethod void testClass2(){
    
        List<User> users = new List<User>();
    
        User u = new User(alias = 'ts', email='testaccs@test.com',
        emailencodingkey='UTF-8', lastname='TestLast', firstname='TestFirst', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss@test.com',communitynickname='tss',FederationIdentifier='Test');       
        
        User u1 = new User(alias = 'ts1', email='testaccss@test.com',
        emailencodingkey='UTF-8', lastname='TestLast1', firstname='TestFirst1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss22@test.com',communitynickname='tsss',FederationIdentifier='Test2');                
        
        User u2 = new User(alias = 'ts2', email='testaccss2@test.com',
        emailencodingkey='UTF-8', lastname='TestLast2', firstname='TestFirst2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss23@test.com',communitynickname='tsss2',FederationIdentifier='Test3');
        
        User u3 = new User(alias = 'ts3', email='testaccss3@test.com',
        emailencodingkey='UTF-8', lastname='TestLast3', firstname='TestFirst3', languagelocalekey='en_US',
        localesidkey='en_US', profileid = '00e90000001232a',
        timezonesidkey='America/Los_Angeles', username='testaccss24@test.com',communitynickname='tsss3',FederationIdentifier='Test4');
        
        test.startTest();        
        
        users.add(u); 
        users.add(u1);
        users.add(u2);
        users.add(u3);   
        insert users;  
                  
                       
        System.runAs(u){
        
            //creating a new account will fire the account proxy trigger and will call the send() method of the class                                            
            Account acc = getAccount('TEST rec');                       
            test.stopTest();            
            
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(
                User__c = u1.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Customer Service Rep',
                Sequence_No__c='1',
                Account_Role_ID__c='test1239'
            );
            
            Account_Team_Proxy__c atp2 = new Account_Team_Proxy__c(
                User__c = u2.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Backup Customer Service Rep',
                Sequence_No__c='2',
                Account_Role_ID__c='test1240'
            );
            
            Account_Team_Proxy__c atp3 = new Account_Team_Proxy__c(
                User__c = u3.id,
                Account__c=acc.id,
                Account_Access__c='Read/Write',
                Opportunity_Access__c='Read/Write',
                Team_Role__c='Primary Field Application Engineer',
                Sequence_No__c='3',
                Account_Role_ID__c='test1241'
            );
            
            List<Account_Team_Proxy__c> atps = new List<Account_Team_Proxy__c>{atp,atp2,atp3};                             
            insert atps;
                                   
            Contact con2 = new Contact(
                firstName = 'test', 
                lastName = 'test',
                accountId = acc.id
            );
            insert con2;
            
            acc.stage__c = 'Authorized';
            acc.customer_number__c = '30001';
            acc.Primary_Contact__c = con2.id;
            acc.copy_address__c = false;            
            //update acc;
            
            Account_Address__c addr1 = new Account_Address__c();
            addr1.Account__c = acc.id;
            addr1.Location__c = 'test loc';
            addr1.Status__c = 'Inactive';
            addr1.Type__c = 'Bill To Address';
            insert addr1;
            
            AccountDetailChange.getDetails(acc);
            
            //call the methods under the class
            AccountDetailChange.send2(acc);
            AccountDetailChange.send2(con2);                                    
            
        }                               
    }
    
     private static Account getAccount(string AccountName)
    {
        // Select columns you would like to use in your test class for the object. If only ID is used, just select ID
        Account acct = [SELECT Id, stage__c, customer_number__c, Primary_Contact__c,copy_address__c  FROM Account Where Name =: AccountName];
        
        return acct;
    }
}