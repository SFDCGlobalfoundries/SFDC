/*
	@Author :- Abhita Bansal
 */
@isTest
private class WaiverCollaboratorEmailNotBatchTest {
	
	@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
    }
	

    static testMethod void myEmailNotiBatchMethod() {
       
       Database.BatchableContext BC;
       
       //list<User> user = DesignCollaboratorTestData.getUserTestData();
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
       //User user1 = DesignCollaboratorTestData.getUserTestData1();
       Account account = DesignCollaboratorTestData.getAccountTestData();
       List<Account_Team_Proxy__c> accTeam = DesignCollaboratorTestData.getAccountTeamTestData(account.Id, users[0].Id, users[1].Id); 
       Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator5(users[0].FederationIdentifier, users[1].FederationIdentifier); 
       list<Wavier_Collaborator__c> waiverCollList = new list<Wavier_Collaborator__c>();
       waiverCollList.add(waiverColl);
       
       Test.startTest();
       
       WaiverCollaboratorEmailNotificationBatch emailNotiBatch = new WaiverCollaboratorEmailNotificationBatch();
       emailNotiBatch.start(BC);
       emailNotiBatch.execute(null, waiverCollList);
       emailNotiBatch.finish(BC);
       
       Test.stopTest();
    }
    
    static testMethod void myEmailNotiBatchMethod1() {
       
       Database.BatchableContext BC;
       
       //list<User> user = DesignCollaboratorTestData.getUserTestData();
       //User user1 = DesignCollaboratorTestData.getUserTestData1();
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
       Account account = DesignCollaboratorTestData.getAccountTestData();
       List<Account_Team_Proxy__c> accTeam = DesignCollaboratorTestData.getAccountTeamTestData(account.Id, users[0].Id, users[1].Id); 
       Wavier_Collaborator__c waiverColl = DesignCollaboratorTestData.getWaiverCollaborator6(users[0].FederationIdentifier, users[1].FederationIdentifier); 
       list<Wavier_Collaborator__c> waiverCollList = new list<Wavier_Collaborator__c>();
       waiverCollList.add(waiverColl);
       
       Test.startTest();
       
       WaiverCollaboratorEmailNotificationBatch emailNotiBatch = new WaiverCollaboratorEmailNotificationBatch();
       emailNotiBatch.start(BC);
       emailNotiBatch.execute(null, waiverCollList);
       
       Test.stopTest();
    }
}