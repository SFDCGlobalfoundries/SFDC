/*
    Author: Bhupesh Mukhija
    Description: Test class for TeamRoomManageMembersCtrlExt defects
    History:
    BMukhija              12022013               Code Creation
*/
@isTest(SeeAllData=false)
public class TeamRoomManageMembersControllerExtTest {  

@testSetup static void testdata() {
        DataUtilTest.loadEnvironmentVariables();
                 List<Map<String,Object>>  fieldValueMapList = new List<Map<String,Object>>();
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
            fieldValueMap.put('Fab_9_10__c','no');
            fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_CUSTOMER'));
    
            fieldValueMapList.add(fieldValueMap);
        }
        AccountDataFactory.createAccounts(fieldValueMapList,2);
        Account accntObj1 = getAccount('MYTEST ACCOUNT1');
        Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
        env.value__c=accntObj1.Id;
        update env;
        
    } 
    // Update for Team Room Member Defect Tests.
    // Added becuase of User Trigger validation
    static HCM_Employee__c createHCMEmployee(String dataChange) {
        HCM_Employee__c testHCMEmployee = new HCM_Employee__c();
        
        testHCMEmployee.First_Name__c = dataChange + ' ' + 'Employee FN';
        testHCMEmployee.Last_Name__c = dataChange + ' ' + 'Employee LN';
        testHCMEmployee.Employee_ID__c = dataChange;
        testHCMEmployee.Login_ID__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Email_Address__c = dataChange + 'test.hcmemployee@gf.com';
        testHCMEmployee.Status__c = 'Active';
        
        return testHCMEmployee;
    }

    // Update for Team Room Member Defect Tests.
    static User createUser(String dataChange,User dummyUser,Id pId) {
        User testUser = new User();
        testUser.FirstName = dataChange + ' ' + 'User FN';
        testUser.LastName = dataChange + ' ' + 'User LN';
        testUser.Username = dataChange + 'test.user@gf.com';
        testUser.email = dataChange + 'test.user@gf.com';
        testUser.Email = dataChange + 'test.user@gf.com';
        testUser.Alias = dataChange + 'ALI';
        testUser.CommunityNickname = dataChange + 'COMM';
        testUser.ProfileId = pId;
        testUser.FederationIdentifier = dataChange;
        testUser.TimeZoneSidKey = dummyUser.TimeZoneSidKey;
        testUser.LocaleSidKey = DummyUser.LocaleSidKey;
        testUser.EmailEncodingKey = DummyUser.EmailEncodingKey;
        testUser.LanguageLocaleKey = DummyUser.LanguageLocaleKey;
        
        return testUser;
    }

    // Update for Team Room Member Defect Tests.
    static Team_Room__c createTeamRoom(String teamRoomChange) {
        Account accntObj1 = getAccount('MYTEST ACCOUNT1');
          
           Team_Room__c teamRoom = new Team_Room__c();
        
        teamRoom.Name = teamRoomChange;
        teamRoom.Team_Room_Description__c = teamRoomChange + ' Description';
        teamRoom.Primary_Account__c=accntObj1.id;
        
        return teamRoom;
    }

    // Update for Team Room Member Defect Tests.   
   static Team_Room_Member__c createUserMembers(String teamRoomId, String memberUserId, String access) {
        Team_Room_Member__c teamMember = new Team_Room_Member__c();

        teamMember.Team_Room__c = teamRoomId;      
        teamMember.Is_Group__c = false;
        teamMember.Access__c = access;
        teamMember.User__c = memberUserId;
        
        return teamMember;
   }

   static testMethod void testSendEmail(){
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomManageMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;
       
       List<Team_Room__c> lTeamRoom = [SELECT Id, Name, Team_Room_Description__c, Owner.Name, OwnerId FROM Team_Room__c WHERE Id =: teamRoom.Id];
       teamRoom = lTeamRoom.get(0);

       List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
       lHCMEmployee.add(createHCMEmployee('User1'));
       lHCMEmployee.add(createHCMEmployee('User2'));
       lHCMEmployee.add(createHCMEmployee('User3'));
       lHCMEmployee.add(createHCMEmployee('User4'));
       lHCMEmployee.add(createHCMEmployee('User5'));  
       
       insert lHCMEmployee;

       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];    
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;
       List<User> lTeamMemberUsers = new List<User>();       
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User1',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User2',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User3',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User4',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User5',dummyUser,profileId));
       Test.startTest();
       insert lTeamMemberUsers;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       for (User eachUser: lTeamMemberUsers) {
           lTeamMembers.add(createUserMembers(teamRoom.Id, eachUser.Id, 'Read'));
       }
       
       TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt();
       tmRmMngMemCtrlExt.TeamRoom = teamRoom;       
       tmRmMngMemCtrlExt.TeamRoomName = teamRoom.Name;
       tmRmMngMemCtrlExt.Members = lTeamMembers;
       
       Set<String> tempSet = new Set<String>();
       tmRmMngMemCtrlExt.sTeamMember = tempSet;
       
       Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].get(0);
       
       if (profile != null) {
           User user = [SELECT Id FROM User WHERE ProfileId =: profile.Id AND IsActive = true].get(0);
           
           if (user != null) {
               System.RunAs(user){
                   
                   PageReference pageReference = tmRmMngMemCtrlExt.save();
                   
               }
            }
       }
       Test.stopTest();
   }
   
    // Update for Team Room Member Defect Tests.   
   static testMethod void testTeamRoomMemberDuplication(){
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomManageMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;

       List<Team_Room__c> lTeamRoom = [SELECT Id, Name, Team_Room_Description__c, Owner.Name FROM Team_Room__c WHERE Id =: teamRoom.Id];
       teamRoom = lTeamRoom.get(0);       

       List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
       lHCMEmployee.add(createHCMEmployee('User1'));
       lHCMEmployee.add(createHCMEmployee('User2'));
       lHCMEmployee.add(createHCMEmployee('User3'));
       lHCMEmployee.add(createHCMEmployee('User4'));
       lHCMEmployee.add(createHCMEmployee('User5'));  
       
       insert lHCMEmployee;    

       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];    
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;
       List<User> lTeamMemberUsers = new List<User>();       
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User1',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User2',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User3',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User4',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User5',dummyUser,profileId));
       Test.startTest();
       insert lTeamMemberUsers;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       for (User eachUser: lTeamMemberUsers) {
           lTeamMembers.add(createUserMembers(teamRoom.Id, eachUser.Id, 'Read'));
       }
       
       TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt();
       tmRmMngMemCtrlExt.TeamRoom = teamRoom;
       tmRmMngMemCtrlExt.TeamRoomName = teamRoom.Name;       
       tmRmMngMemCtrlExt.Members = lTeamMembers;
       
       Set<String> tempSet = new Set<String>();
       tmRmMngMemCtrlExt.sTeamMember = tempSet;
       Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].get(0);
       
       if (profile != null) {
           User user = [SELECT Id FROM User WHERE ProfileId =: profile.Id AND IsActive = true].get(0);
           
           if (user != null) {
               System.RunAs(user){
       
                   
                   PageReference pageReference = tmRmMngMemCtrlExt.save();
                   
                   
                   if (pageReference != null) {
                       String pageRefUrl = pageReference.getURL();
                       String pageRefId = pageRefUrl.mid(pageRefUrl.indexOf('id='), 18);
                       // System.assert(pageRefId.equalsIgnoreCase(teamRoom.id));           
                   } else {
                        System.assert(!ApexPages.hasMessages());
                   }
               }
           }
       }
       Test.stopTest();
   }
   
   static testMethod void testTeamRoomMemberNoUserAdded(){
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomManageMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;

       HCM_Employee__c hcmEmployee = createHCMEmployee('User1');
       
       insert hcmEmployee;    

       User user = new User();     
       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];    
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;  
       user = TeamRoomManageMembersControllerExtTest.createUser('User1',dummyUser,profileId);
       Test.startTest();
       insert user;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       lTeamMembers.add(createUserMembers(teamRoom.Id, null, 'Read'));
       
       TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt();
       tmRmMngMemCtrlExt.Members = lTeamMembers;
      
       Set<String> tempSet = new Set<String>();
       tmRmMngMemCtrlExt.sTeamMember = tempSet;
       
       
       PageReference pageReference = tmRmMngMemCtrlExt.save();
       Test.stopTest();
       
       System.assert(pageReference == null);
   }
   
   static testMethod void testTeamRoomMemberNoAccessAdded(){
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomManageMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;

       HCM_Employee__c hcmEmployee = createHCMEmployee('User1');
       
       insert hcmEmployee;    

       User user = new User();
        User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];    
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;              
       user = TeamRoomManageMembersControllerExtTest.createUser('User1',dummyUser,profileId);
       Test.startTest();
       insert user;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       lTeamMembers.add(createUserMembers(teamRoom.Id, user.Id, null));
       
       TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt();
       tmRmMngMemCtrlExt.Members = lTeamMembers;
      
       Set<String> tempSet = new Set<String>();
       tmRmMngMemCtrlExt.sTeamMember = tempSet;
       
       
       PageReference pageReference = tmRmMngMemCtrlExt.save();
       Test.stopTest();
       
       System.assert(pageReference == null);
   }
   
   static testMethod void testDeleteTeamMember(){
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomManageMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;

       List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
       lHCMEmployee.add(createHCMEmployee('User1'));
       lHCMEmployee.add(createHCMEmployee('User2'));
       lHCMEmployee.add(createHCMEmployee('User3'));
       lHCMEmployee.add(createHCMEmployee('User4'));
       lHCMEmployee.add(createHCMEmployee('User5'));  
       
       insert lHCMEmployee;    

       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];    
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;
       List<User> lTeamMemberUsers = new List<User>();       
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User1',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User2',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User3',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User4',dummyUser,profileId));
       lTeamMemberUsers.add(TeamRoomManageMembersControllerExtTest.createUser('User5',dummyUser,profileId));
       Test.startTest();
       insert lTeamMemberUsers;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       for (User eachUser: lTeamMemberUsers) {
           lTeamMembers.add(createUserMembers(teamRoom.Id, eachUser.Id, 'Read'));
       }

       TeamRoomManageMembersCtrlExt tmRmMngMemCtrlExt = new TeamRoomManageMembersCtrlExt();
       tmRmMngMemCtrlExt.Members = lTeamMembers;
       
       Set<String> tempSet = new Set<String>();
       tmRmMngMemCtrlExt.sTeamMember = tempSet;
       
       Integer countMembersBeforeDel = tmRmMngMemCtrlExt.Members.size();
       
       String teamMemberToDel = lTeamMembers.get(0).id;
       ApexPages.currentPage().getParameters().put('memberId', teamMemberToDel);

       
       PageReference pageReference = tmRmMngMemCtrlExt.deleteMember();
       Test.stopTest();

       Integer countMembersAfterDel = tmRmMngMemCtrlExt.Members.size();
       
       if (pageReference == null && tmRmMngMemCtrlExt.Members != null && tmRmMngMemCtrlExt.sTeamMember != null) {
            System.assert(!tmRmMngMemCtrlExt.sTeamMember.contains(teamMemberToDel));
            System.assert(countMembersBeforeDel != countMembersAfterDel);
       } else {
            System.assert(!ApexPages.hasMessages());
       }
   }
   
   private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}