/*
    Author: Anirban Roy
    Description: Test class for TeamRoomMembersControllerExt
    History:
        ARoy            12022013            Code Creation
        BMukhija        04142013            Update for Show All/Show More Functionality
*/
@isTest(SeeAllData=false)
public class TeamRoomMembersControllerExtTest {

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
    }

    static testMethod void doTestTeamRoomMemCntrlrExt(){
        test.startTest();
         
        Account accntObj1 = getAccount('MYTEST ACCOUNT1');
        
        Team_Room__c tmRm = new Team_Room__c(Name='Team Room 007',Team_Room_Description__c = 'Meeting Team Room',Primary_Account__c=accntObj1.id);
        insert tmRm;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(tmRm);
        TeamRoomMembersControllerExt tmRmMemCntrlrExt = new TeamRoomMembersControllerExt(sc);
        Team_Room__c tmRms = tmRmMemCntrlrExt.getTeamRoom();
        System.assert(tmRms!=null);
        
        Group grp = new Group(Name='GlobalFoundries Group', Type = 'Regular');
        insert grp;
        
        Team_Room_Member__c tmRmMem = new Team_Room_Member__c();
        tmRmMem.Group_Id__c = grp.id;
        tmRmMem.Group_Selected__c=true;
        tmRmMem.Is_Group__c = true;
        tmRmMem.Team_Room__c = tmRm.id; 
        tmRmMem.Access__c = 'Read/Write';
        insert tmRmMem;
        
        Team_Room_Member__c tmRmMem1 = new Team_Room_Member__c();
        tmRmMem1.User__c = UserInfo.getUserId();
        tmRmMem1.Group_Selected__c=false;
        tmRmMem1.Is_Group__c = false;
        tmRmMem1.Team_Room__c = tmRm.id; 
        tmRmMem1.Access__c = 'Read/Write';
        insert tmRmMem1;
        
        apexpages.currentpage().getparameters().put('memberId',tmRmMem.id);
        
        List<Team_Room_Member__c> tmRmMemLst = tmRmMemCntrlrExt.members;
        System.assert(tmRmMemLst!=null);
        
        PageReference pgRef = tmRmMemCntrlrExt.deleteMember();
        System.assert(pgRef==null);
        test.stopTest();
     }
     
    static Team_Room__c createTeamRoom(String teamRoomChange) {
        Account accntObj1 = getAccount('MYTEST ACCOUNT2');
        
        Team_Room__c teamRoom = new Team_Room__c();
        
        teamRoom.Name = teamRoomChange;
        teamRoom.Team_Room_Description__c = teamRoomChange + ' Description';
        teamRoom.Primary_Account__c=accntObj1.id;
        
        return teamRoom;
    }
    
   static Team_Room_Member__c createUserMembers(String teamRoomId, String memberUserId, String access) {
        Team_Room_Member__c teamMember = new Team_Room_Member__c();

        teamMember.Team_Room__c = teamRoomId;      
        teamMember.Is_Group__c = false;
        teamMember.Access__c = access;
        teamMember.User__c = memberUserId;
        
        return teamMember;
   }

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
    static User createUser(String dataChange,User dummyUser, Id pId) {
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

   static testMethod void testShowAll(){
   
       Account acc = getAccount('MYTEST ACCOUNT1');
       Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=acc.Id;
       update env;
       // Create Dummy Team Room, Team Member Data
       Team_Room__c teamRoom = TeamRoomMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;
       
       List<Team_Room__c> lTeamRoom = [SELECT Id, Name, Team_Room_Description__c, Owner.Name, OwnerId FROM Team_Room__c WHERE Id =: teamRoom.Id];
       teamRoom = lTeamRoom.get(0);

       List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
       lHCMEmployee.add(createHCMEmployee('U1'));
       lHCMEmployee.add(createHCMEmployee('U2'));
       lHCMEmployee.add(createHCMEmployee('U3'));
       lHCMEmployee.add(createHCMEmployee('U4'));
       lHCMEmployee.add(createHCMEmployee('U5'));
       lHCMEmployee.add(createHCMEmployee('U6'));
       lHCMEmployee.add(createHCMEmployee('U7'));
       lHCMEmployee.add(createHCMEmployee('U8'));
       lHCMEmployee.add(createHCMEmployee('U9'));
       lHCMEmployee.add(createHCMEmployee('U10'));
       lHCMEmployee.add(createHCMEmployee('U11'));
       lHCMEmployee.add(createHCMEmployee('U12'));
       lHCMEmployee.add(createHCMEmployee('U13'));
       lHCMEmployee.add(createHCMEmployee('U14'));
       
       insert lHCMEmployee;
       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;
       List<User> lTeamMemberUsers = new List<User>();       
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U1',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U2',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U3',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U4',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U5',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U6',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U7',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U8',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U9',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U10',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U11',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U12',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U13',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U14',dummyUser, profileId));
       Test.startTest();
       insert lTeamMemberUsers;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       for (User eachUser: lTeamMemberUsers) {
           lTeamMembers.add(createUserMembers(teamRoom.Id, eachUser.Id, 'Read'));
       }
       
       insert lTeamMembers;
       
       ApexPages.StandardController standardController = new ApexPages.StandardController(teamRoom);       
       TeamRoomMembersControllerExt tmRmMemCtrlExt = new TeamRoomMembersControllerExt(standardController);
       
       if (tmRmMemCtrlExt != null && tmRmMemCtrlExt.members != null && tmRmMemCtrlExt.members.size() > 0) {
           System.assert(tmRmMemCtrlExt.members.size() == 5);
           
           tmRmMemCtrlExt.getAllTeamMembers();
           
           //System.assert(tmRmMemCtrlExt.members.size() == 14);
       }
       Test.stopTest();
   }

   static testMethod void testShowNextAndDelete(){
       Account acc = getAccount('MYTEST ACCOUNT1');
       Environment_Variable__c env = [select id,name,value__c from Environment_Variable__c where name='HCM Emp AccountId'];
       env.value__c=acc.Id;
       update env;

       // Create Dummy Team Room, Team Member Data       
       Team_Room__c teamRoom = TeamRoomMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;
       
       List<Team_Room__c> lTeamRoom = [SELECT Id, Name, Team_Room_Description__c, Owner.Name, OwnerId FROM Team_Room__c WHERE Id =: teamRoom.Id];
       teamRoom = lTeamRoom.get(0);

       User dummyUser = [SELECT id, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User LIMIT 1];
       Id profileId = [SELECT id FROM Profile WHERE Name = 'GF App User Platform'].get(0).id;
       List<HCM_Employee__c> lHCMEmployee = new List<HCM_Employee__c>();
       lHCMEmployee.add(createHCMEmployee('U1'));
       lHCMEmployee.add(createHCMEmployee('U2'));
       lHCMEmployee.add(createHCMEmployee('U3'));
       lHCMEmployee.add(createHCMEmployee('U4'));
       lHCMEmployee.add(createHCMEmployee('U5'));
       lHCMEmployee.add(createHCMEmployee('U6'));
       lHCMEmployee.add(createHCMEmployee('U7'));
       lHCMEmployee.add(createHCMEmployee('U8'));
       lHCMEmployee.add(createHCMEmployee('U9'));
       lHCMEmployee.add(createHCMEmployee('U10'));
       lHCMEmployee.add(createHCMEmployee('U11'));
       lHCMEmployee.add(createHCMEmployee('U12'));
       lHCMEmployee.add(createHCMEmployee('U13'));
       lHCMEmployee.add(createHCMEmployee('U14'));
       
       insert lHCMEmployee;

       List<User> lTeamMemberUsers = new List<User>();       
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U1',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U2',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U3',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U4',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U5',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U6',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U7',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U8',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U9',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U10',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U11',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U12',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U13',dummyUser, profileId));
       lTeamMemberUsers.add(TeamRoomMembersControllerExtTest.createUser('U14',dummyUser, profileId));
       Test.startTest();
       insert lTeamMemberUsers;
       
       List<Team_Room_Member__c> lTeamMembers = new List<Team_Room_Member__c>();
       for (User eachUser: lTeamMemberUsers) {
           lTeamMembers.add(createUserMembers(teamRoom.Id, eachUser.Id, 'Read'));
       }
       
       insert lTeamMembers;
       
       ApexPages.StandardController standardController = new ApexPages.StandardController(teamRoom);       
       TeamRoomMembersControllerExt tmRmMemCtrlExt = new TeamRoomMembersControllerExt(standardController);
       
       if (tmRmMemCtrlExt != null && tmRmMemCtrlExt.members != null && tmRmMemCtrlExt.members.size() > 0) {
           System.assert(tmRmMemCtrlExt.members.size() == 5);
           
           tmRmMemCtrlExt.getTeamMembers();
           
           System.assert(tmRmMemCtrlExt.members.size() == 10);
           
           if (lTeamMembers != null && lTeamMembers.size() > 0) {
               ApexPages.currentPage().getParameters().put('memberId', lTeamMembers.get(0).Id);
               tmRmMemCtrlExt.deleteMember();
               
               //System.assert(tmRmMemCtrlExt.members.size() == 9);               
           }
       }
       Test.stopTest();
   }
   
   static testMethod void testNoTeamRoom() {
       // Create Dummy Team Room Data
       Team_Room__c teamRoom = TeamRoomMembersControllerExtTest.createTeamRoom('Test Team Room');
       
       insert teamRoom;
   
       ApexPages.StandardController standardController = new ApexPages.StandardController(teamRoom);       
       TeamRoomMembersControllerExt tmRmMemCtrlExt = new TeamRoomMembersControllerExt(standardController);

       //System.assert(tmRmMemCtrlExt.totalRecordCount == 0);
       //System.assert(tmRmMemCtrlExt.retrivedRecordCount== 0);       
   }
   
   private static Account getAccount(string AccountName)
            {
                Account testAcct= [SELECT Id, Name FROM Account Where Name =: AccountName];
        
                return testAcct;
            }  
}