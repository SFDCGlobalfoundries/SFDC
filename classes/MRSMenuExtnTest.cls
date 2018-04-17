/*
    Author: Cognizant
    Description: Apex test class for MRSMenuExtn class
    History: 
    Cognizant      08/06/2014    - Apex code created
*/
@istest(SeeAllData=false)
public class MRSMenuExtnTest {
	
	/**
	This method initialize data using throughout this test class.
	The create data method are: 
	- SwiftDataUtilityTest.customSystemData();
	@author		SWIFT TEAM
	@since		7-April-2015
	*/
	@testSetup static void setup() {
		SwiftDataUtilityTest.customSystemData();
	}
     
     /**
        This test method tests all the method of MRSMenuExtn class for System Administrator.
        @method name: MenuExtnTest
        @parameter:   none.
        @return :     None.
     **/

     static testmethod void MenuExtnSATest(){       
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) {           
            list<User> listUser = new list<User>();       
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
            User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
            listUser.add(userSA);
            listUser.add(userSU);
            listUser.add(userSUFE); 
            insert listUser; 
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin']; 
            System.assertNotEquals(groupGS.Id,null);
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = userSU.Id;
            insert groupMember;
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSUFE.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;        
            system.runAs(userSA){
                //createPermissionConfigValues(); 
                test.startTest();
                MRSMenuExtn controller = new MRSMenuExtn();

                controller.Page = 'Layer Summary';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Customer';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Foundry';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Customer';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Foundry';
                controller.redirect();
                controller.Page = 'SendData-Prime';
                controller.redirect();
                controller.Page = 'SendData-Frame';
                controller.redirect();
                controller.Page = 'MEBESJobview-Customer';
                controller.redirect();
                controller.Page = 'MEBESJobview-Foundry';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutCentre';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutApp';
                controller.redirect();
                controller.Page = 'MEBESJobview-GlobalShuttle';
                controller.redirect();
                controller.Page = 'MEBESJobview-MDP';
                controller.redirect();
                controller.Page = 'MEBESJobview-MPWTDTI';
                controller.redirect();
                controller.Page = 'Hold/Resume Layer';
                controller.redirect();
                System.assertEquals(controller.showdetailsection, true);   
                test.stopTest();              
            }
        }         
     }

     /**
        This test method tests all the method of MRSMenuExtn class for Standard User.
        @method name: MenuExtnTest
        @parameter:   none.
        @return :     None.
     **/
     static testmethod void MenuExtnSUTest(){       
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) {           
            list<User> listUser = new list<User>();       
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
            User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
            listUser.add(userSA);
            listUser.add(userSU);
            listUser.add(userSUFE); 
            insert listUser; 
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin']; 
            System.assertNotEquals(groupGS.Id,null);
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = userSU.Id;
            insert groupMember;
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSU.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;        
            system.runAs(userSU){
                test.startTest();
                MRSMenuExtn controller = new MRSMenuExtn();
                //system.assertEquals(controller.groupIdAndGroupMemberMap,null);
                //system.assertEquals(controller.mrsFieldPermissionConfig.keySet(),null);
                controller.Page = 'Layer Summary';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Customer';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Foundry';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Customer';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Foundry';
                controller.redirect();
                controller.Page = 'SendData-Prime';
                controller.redirect();
                controller.Page = 'SendData-Frame';
                controller.redirect();
                controller.Page = 'MEBESJobview-Customer';
                controller.redirect();
                controller.Page = 'MEBESJobview-Foundry';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutCentre';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutApp';
                controller.redirect();
                controller.Page = 'MEBESJobview-GlobalShuttle';
                controller.redirect();
                controller.Page = 'MEBESJobview-MDP';
                controller.redirect();
                controller.Page = 'MEBESJobview-MPWTDTI';
                controller.redirect();
                controller.Page = 'Hold/Resume Layer';
                controller.redirect();
                test.stopTest();
                System.assertEquals(controller.showHoldResumeButton , true);  
            }
            
        }         
     }   

     static testmethod void MenuExtnSUTest2(){       
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) {           
            list<User> listUser = new list<User>();       
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
            User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
            listUser.add(userSA);
            listUser.add(userSU);
            listUser.add(userSUFE); 
            insert listUser; 
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin']; 
            System.assertNotEquals(groupGS.Id,null);
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = userSU.Id;
            insert groupMember;
            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSU.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;        
            system.runAs(userSU){
                test.startTest();
                MRSMenuExtn controller = new MRSMenuExtn();
                //system.assertEquals(controller.groupIdAndGroupMemberMap,null);
                //system.assertEquals(controller.mrsFieldPermissionConfig.keySet(),null);
                controller.Page = 'Layer Summary';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Customer';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Foundry';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Customer';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Foundry';
                controller.redirect();
                controller.Page = 'SendData-Prime';
                controller.redirect();
                controller.Page = 'SendData-Frame';
                controller.redirect();
                controller.Page = 'MEBESJobview-Customer';
                controller.redirect();
                controller.Page = 'MEBESJobview-Foundry';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutCentre';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutApp';
                controller.redirect();
                controller.Page = 'MEBESJobview-GlobalShuttle';
                controller.redirect();
                controller.Page = 'MEBESJobview-MDP';
                controller.redirect();
                controller.Page = 'MEBESJobview-MPWTDTI';
                controller.redirect();
                controller.Page = 'Hold/Resume Layer';
                controller.redirect();
                test.stopTest();
                System.assertEquals(controller.showHoldResumeButton , true);  
            }
            
        }         
     }   

     static testmethod void MenuExtnSUTest3(){       
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) {           
            list<User> listUser = new list<User>();       
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
            User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
            listUser.add(userSA);
            listUser.add(userSU);
            listUser.add(userSUFE); 
            insert listUser; 
            /*Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin']; 
            System.assertNotEquals(groupGS.Id,null);
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = userSU.Id;
            insert groupMember;*/
            //Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSU.id,Account__c=acc.id,Account_Access__c='Read/Write',
            //Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            //insert atp;        
            system.runAs(userSU){
                test.startTest();
                MRSMenuExtn controller = new MRSMenuExtn();
                //system.assertEquals(controller.groupIdAndGroupMemberMap,null);
                //system.assertEquals(controller.mrsFieldPermissionConfig.keySet(),null);
                controller.Page = 'Layer Summary';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Customer';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Foundry';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Customer';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Foundry';
                controller.redirect();
                controller.Page = 'SendData-Prime';
                controller.redirect();
                controller.Page = 'SendData-Frame';
                controller.redirect();
                controller.Page = 'MEBESJobview-Customer';
                controller.redirect();
                controller.Page = 'MEBESJobview-Foundry';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutCentre';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutApp';
                controller.redirect();
                controller.Page = 'MEBESJobview-GlobalShuttle';
                controller.redirect();
                controller.Page = 'MEBESJobview-MDP';
                controller.redirect();
                controller.Page = 'MEBESJobview-MPWTDTI';
                controller.redirect();
                controller.Page = 'Hole/Resume Layer';
                controller.redirect();
                 ApexPages.currentPage().getParameters().put('Customer','customer');
                 ApexPages.currentPage().getParameters().put('mst','mst');                
                test.stopTest();
                System.assertEquals(controller.showHoldResumeButton , true);  
            }
            
        }         
     } 
     
     /**
        This test method tests all the method of MRSMenuExtn class for Field Engineer.
        @method name: MenuExtnTest
        @parameter:   none.
        @return :     None.
     **/     

     static testmethod void MenuExtnFETest(){       
        // comment-out, refactor with testSetup method setup()
        // SwiftDataUtilityTest.customSystemData();
        Account acc = SwiftDataUtilityTest.createTestAccount();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User thisUser = [SELECT Id FROM User WHERE ProfileId =:sysAdminProfile.Id and isActive=true limit 1];
        System.runAs (thisUser) {           
            list<User> listUser = new list<User>();       
            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            UserRole usrRole=[SELECT Id FROM UserRole WHERE Name = 'GLOBALFOUNDRIES Corporate'];
            User userSA = new User(alias = 'testMRS', email='testMRS@test.com',
            emailencodingkey='UTF-8', lastname='testMRSLast', firstname='testMRSFirst', languagelocalekey='en_US',
            localesidkey='en_US', profileid = sysAdminProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS@test.com',communitynickname='testMRS');
            User userSU = new User(alias = 'testMRS2', email='testMRS2@test.com',
            emailencodingkey='UTF-8', lastname='testMRS2Last', firstname='testMRS2First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS2@test.com',communitynickname='testMRS2'); 
            User userSUFE = new User(alias = 'testMRS3', email='testMRS3@test.com',
            emailencodingkey='UTF-8', lastname='testMRS3Last', firstname='testMRS3First', languagelocalekey='en_US',
            localesidkey='en_US', profileid = stdUserProfile.Id, UserRoleId = usrRole.Id,
            timezonesidkey='America/Los_Angeles', username='testMRS3@test.com',communitynickname='testMRS3');   
            listUser.add(userSA);
            listUser.add(userSU);
            listUser.add(userSUFE); 
            insert listUser; 
            Group groupGS = [select Id, DeveloperName, Name from Group where DeveloperName = 'SWIFT_Admin']; 
            System.assertNotEquals(groupGS.Id,null);
            GroupMember groupMember = new GroupMember();           
            groupMember.GroupId = groupGS.Id;
            groupMember.UserOrGroupId = userSU.Id;
            insert groupMember;
            Account_Team_Proxy__c atp = new Account_Team_Proxy__c(User__c = userSUFE.id,Account__c=acc.id,Account_Access__c='Read/Write',
            Opportunity_Access__c='Read/Write',Team_Role__c='Field Application Engineer',Sequence_No__c='1',Account_Role_ID__c='test1239');       
            insert atp;        
            system.runAs(userSUFE){           
                test.startTest();
                MRSMenuExtn controller = new MRSMenuExtn();
                controller.Page = 'Layer Summary';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Customer';
                controller.redirect();
                controller.Page = 'GDSOUTReview-Foundry';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Customer';
                controller.redirect();
                controller.Page = 'FrameMockupReview-Foundry';
                controller.redirect();
                controller.Page = 'SendData-Prime';
                controller.redirect();
                controller.Page = 'SendData-Frame';
                controller.redirect();
                controller.Page = 'MEBESJobview-Customer';
                controller.redirect();
                controller.Page = 'MEBESJobview-Foundry';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutCentre';
                controller.redirect();
                controller.Page = 'MEBESJobview-TapeoutApp';
                controller.redirect();
                controller.Page = 'MEBESJobview-GlobalShuttle';
                controller.redirect();
                controller.Page = 'MEBESJobview-MDP';
                controller.redirect();
                controller.Page = 'MEBESJobview-MPWTDTI';
                controller.parameter = 'Customer=TEstCustomer&';
                controller.redirect();                
                controller.Page = 'Hold/Resume Layer';
                controller.parameter = 'Customer=TEstCustomer&mst=testMST&';
                controller.redirect();
                String showRemoteJobviewLink = null == ( controller.showRemoteJobviewLink ) ? '' : '';
                test.stopTest();
                System.assertEquals(controller.showHoldResumeButton , true);  
            }
            
        }         
     }       
}