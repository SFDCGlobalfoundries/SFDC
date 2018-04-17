/*
    Author: Sunita Char
    Description: This test class covers the AccountTeamProxy trigger.
    History: 
        
*/ 
@isTest(SeeAllData=false)
private class AccountTeamProxyTriggerTest {
    @testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
    static testMethod void runTest() 
    {
    
        
        List<User> users = new List<User>();
            User u1 = new User(
                alias = 'ts', 
                email='testing@test.com',
                emailencodingkey='UTF-8', 
                lastname='TestLast', 
                firstname='TestFirst', 
                languagelocalekey='en_US',
                localesidkey='en_US', 
                profileid = '00e90000001232a',
                timezonesidkey='America/Los_Angeles', 
                username='testing11@test.com',
                communitynickname='ts',
                FederationIdentifier='Test20141',
                Fab_Assigned__c='FAB 1'
            );
            
            User u2 = new User(
                alias = 'ts1', 
                email='testing1@test.com',
                emailencodingkey='UTF-8', 
                lastname='TestLast1', 
                firstname='TestFirst1', 
                languagelocalekey='en_US',
                localesidkey='en_US', 
                profileid = '00e90000001232a',
                timezonesidkey='America/Los_Angeles', 
                username='testing112@test.com',
                communitynickname='ts1',
                FederationIdentifier='Test20142',
                Fab_Assigned__c='FAB 1'
            );
            users.add(u1);
            users.add(u2);
            insert users;
        // Create Account
        Account a = new Account();
        a.Name = 'Test Account 1 SFDC';
        a.Site_Department__c = 'Test Department';
        a.Sub_Type__c = 'Direct';
        a.Transaction_Type__c = 'Transactional';
        a.Region__c = 'APJ';
        a.Bill_To_Address_1__c = 'Test Address 1';
        a.Corporate_Address_1__c = 'Corporate Address 1';
        a.Bill_To_City__c = 'Test City';
        a.Corporate_City__c = 'Test City';
        a.Bill_To_Country__c = 'Singapore';
        a.Corporate_Country__c = 'Singapore';
        
        Insert a;
        
       /* Opportunity testOppty = new Opportunity();
        testOppty.Name = 'Test Opportunity';
        testOppty.AccountId = a.id;
        testOppty.StageName = '1. Discovery';
        testOppty.CloseDate = Date.Today().addDays(10);
        testOppty.Target_Process_Node__c = '14XM';
        testOppty.Market_Segment__c = 'Mobility';
        testOppty.Process_Platform__c = 'GF Baseline';
        testOppty.Fab_Split__c = 100;
        testOppty.Process_Geometry__c = '0.055UM';
        testOppty.Process_Family__c = 'Generic / Nominal';
        
        Insert testOppty;
        
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = a.id;
        testOpptyProgram.Opportunity__c = testOppty.id;
        
        Insert testOpptyProgram; */
        Test.startTest();
        Account_Team_Proxy__c atp = new Account_Team_Proxy__c();
        atp.Account__c=a.id;
        atp.User__c=u1.id;
        atp.Account_Access__c='Read/Write';
        atp.Opportunity_Access__c='Read/Write';
        atp.Team_Role__c='Customer Engineer';
        atp.Fab_Assignment__c='FAB 1';
        insert atp;
        
        Account_Team_Proxy__c atp1 = new Account_Team_Proxy__c();
        atp1.Account__c=a.id;
        atp1.User__c=u2.id;
        atp1.Account_Access__c='Read/Write';
        atp1.Opportunity_Access__c='Read/Write';
        atp1.Team_Role__c='Account Maneger';
        //atp1.Fab_Assignment__c='FAB 1';
        insert atp1;
        
        atp.Team_Role__c='Fab Planner';
        
        atp.Fab_Deleted__c='test';
        atp.Flag_for_Delete__c=true;
        update atp;
        
       
        
        atp1.Team_Role__c='Fab Planner';
        atp1.Fab_Assignment__c='FAB 1';
        update atp1;
        
        atp.Fab_Assignment__c='FAB 2';
        update atp1;
        
       Test.stopTest();
    }
    
 }