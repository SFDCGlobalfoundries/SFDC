@isTest(seeAlldata = false)
private class UpdateContactOnAccessSetupTest {
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
        fieldValueMap.put('Copy_Address__c',True);          
        fieldValueMap.put('bill_to_location__c', 'Yes');            
        fieldValueMap.put('total_employee__c',100);        
        fieldValueMap.put('Fab_9_10__c','No');
        fieldValueMap.put('short_name__c','TAC1q2');
        fieldValueMap.put('Process_Tech_Interested__c','Mature (> 0.11um)');
        fieldValueMap.put('Organization_Unit__c','GF Investment LLC OU');
        fieldValueMap.put('end_customer__c','employee');
        fieldValueMap.put('Revenue_Potential__c','High Potential');
        fieldValueMap.put('Target_Account__c','Yes');
        
        AccountDataFactory.createAccount(fieldValueMap);
    }
    static Account createAccount1() {
        // Create Account
        Account testAcct = new Account();
        testAcct.Name = 'Testzb Account 1';
        testAcct.Stage__c = 'Unqualified';
        testAcct.Site_Department__c = 'Test Department';
        testAcct.Sub_Type__c = 'Direct';
        testAcct.Transaction_Type__c = 'Transactional';
        testAcct.Region__c = 'APJ';
        testAcct.Bill_To_Address_1__c = 'Test Address 1';
        testAcct.Corporate_Address_1__c = 'Corporate Address 1';
        testAcct.Bill_To_City__c = 'Test City';
        testAcct.Corporate_City__c = 'Test City';
        testAcct.Bill_To_Country__c = 'Singapore';
        testAcct.Corporate_Country__c = 'Singapore';
       
        Insert testAcct;
        
        return testAcct;
    }
    
    static testMethod void myUnitTest() {
      // User usr = [ Select id from User where ProfileId = '00e90000001AT3eAAG' limit 1];
       Account acc = getAccount('MYTEST ACCOUNT1'); 
        Account acct =UpdateContactOnAccessSetupTest.createAccount1();
        Contact contact1 = new Contact(
            FirstName = 'Test1x',
            Lastname = 'Amit1x',
            AccountId = acct.id,
            Email = 'test1x@test.com',
            Department__c = 'Engineering'
        );
        Database.insert(contact1); 
        
        //Create user for the contact
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Portal Admin' Limit 1];
        User user1 = new User(
            Username = 'test12345testq2@test.com',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'testq2',
            Email = 'test12345q2@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Kumarq2q2',
            CommunityNickname = 'test12345q2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            Department = 'IT'
        );
        Test.startTest();
        Database.insert(user1); 
        
        /*User user = new User(alias = 'test1',
               email='testaccss@test.com',
               emailencodingkey='UTF-8', 
               lastname='TestLastname', 
               firstname='TestFirstName', 
               languagelocalekey='en_US',
               localesidkey='en_US', 
               profileid = '00e90000001232a',
               timezonesidkey='America/Los_Angeles', 
               username='testaccss33@test.com',
               communitynickname='tsss',
               FederationIdentifier='Test1');
        insert user;*/
     
            
        Portal_Tab_Access__c pta = new Portal_Tab_Access__c(Account__c =acc.id, User__c = user1.Id );
        insert pta;
        
        system.assertEquals(pta.Account__c,acc.Id);
        Test.stopTest();
    }
    private static Account getAccount(string AccountName)
    {
        Account acct = [SELECT Id, Name FROM Account Where Name =: AccountName];
        
        return acct;
    }
}