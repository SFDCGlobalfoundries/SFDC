/*Author: Karthick D
 * Description: Test Class for Bug Team Trigger and Bug Manage Members controller (BugManageMembersCtrlExt)
 * History:
 */

@isTest(SeeAllData = false)
public class BugTeamMemberTest {
    public static testMethod void testBugTeam() {
        Test.startTest();
        //Test data creation 
        list < CSforDefaultownerandteam__c > clist = new list < CSforDefaultownerandteam__c > ();
        CSforDefaultownerandteam__c c = new CSforDefaultownerandteam__c();
        c.Name = 'cc1';
        c.Product_affected__c = 'CAD Environment';
        c.Bug_Component__c = 'Documentation';
        c.Bug_Owner__c = Userinfo.getUserId();

        c.Bug_BugTeam__c = Userinfo.getUserId();
        clist.add(c);
        insert clist;

        bug__c bteamtest = new bug__c();
        bteamtest.Bug_Title__c = 'test zzzz';
        bteamtest.Product_technology__c = 'CAD Environment';
        bteamtest.Component__c = 'Documentation';
        insert bteamtest;

        bug__c b = new bug__c();
        b.Bug_Title__c = 'test zzzz';
        b.Product_technology__c = 'CAD Environment';
        b.Component__c = 'Documentation';
        insert b;

        b = [select id, name from bug__c where id = : b.id][0];

        bug__c b1 = new bug__c();
        b1.Bug_Title__c = 'test zzzz';
        b1.Product_technology__c = 'CAD Environment';
        b1.Component__c = 'Documentation';
        insert b1;
        //Test data creation ends

        PageReference pageRef = new PageReference('/apex/BugManageMember?id=' + b.id);
        Test.setCurrentPage(pageRef);
        BugManageMembersCtrlExt BugManageMembersCtrlExtVar = new BugManageMembersCtrlExt();
        BugManageMembersCtrlExtVar.BugRoom = b;

        pageRef = new PageReference('/apex/BugManageMember?id=' + b.id);
        Test.setCurrentPage(pageRef);
        BugManageMembersCtrlExtVar = new BugManageMembersCtrlExt();
        BugManageMembersCtrlExtVar.BugRoom = b;
        BugManageMembersCtrlExtVar.addNewRow();
        Bug_Team__c bgteam = new bug_Team__c();
        Bug_Team__c bgteam1 = new bug_Team__c();
        Bug_Team__c bgteam2 = new bug_Team__c();
        Bug_Team__c bgteam3 = new bug_Team__c();

        bgteam1.Is_Group__c = false;
        bgteam1.Access__c = 'Read';
        bgteam1.user__c = null;
        bgteam1.bug__c = b.id;

        bgteam.Is_Group__c = false;
        bgteam.Access__c = null;
        bgteam.user__c = userinfo.getUserId();
        bgteam.bug__c = b.id;

        bgteam2.Is_Group__c = false;
        bgteam2.Access__c = 'Read';
        bgteam2.user__c = userinfo.getUserId();
        bgteam2.bug__c = b.id;

        bgteam3.Is_Group__c = false;
        bgteam3.Access__c = 'Read';
        bgteam3.user__c = userinfo.getUserId();
        bgteam3.bug__c = b.id;
        BugManageMembersCtrlExtVar.members = new list < bug_team__c > ();
        BugManageMembersCtrlExtVar.members.add(bgteam);
        BugManageMembersCtrlExtVar.Save();

        BugManageMembersCtrlExtVar.members = new list < bug_team__c > ();
        BugManageMembersCtrlExtVar.members.add(bgteam1);
        BugManageMembersCtrlExtVar.Save();

        delete[select id from bug_team__c where bug__c = : b.id];
        BugManageMembersCtrlExtVar.sTeamMember = new Set < String > ();
        BugManageMembersCtrlExtVar.members = new list < bug_team__c > ();
        BugManageMembersCtrlExtVar.members.add(bgteam2);
        BugManageMembersCtrlExtVar.Save();

        BugManageMembersCtrlExtVar.members = new list < bug_team__c > ();
        BugManageMembersCtrlExtVar.members.add(bgteam3);
        BugManageMembersCtrlExtVar.Save();

        BugManageMembersCtrlExtVar.deleteMember();

        pageRef = Page.BugTeamMembers;
        Test.setCurrentPage(pageRef);
        Apexpages.StandardController controller = new Apexpages.StandardController(bteamtest);
        BugTeamMembersControllerExt BugTeamMembersControllerExtVar = new BugTeamMembersControllerExt(controller);
        BugTeamMembersControllerExtVar.getTeamRoom();
        BugTeamMembersControllerExtVar.getTeamMembers();
        BugTeamMembersControllerExtVar.getAllTeamMembers();
        BugTeamMembersControllerExtVar.deleteMember();

        //Delete the bug team members of the bug.
        list < Bug_Team__c > bgshare = [SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c
        FROM Bug_Team__c WHERE Bug__c = : b1.id];
        system.debug('bgushareeee' + Bgshare);
        delete[SELECT Id, User__c, User__r.Name, User__r.ProfileId, User__r.UserRoleId, Access__c, Is_Group__c, Group_Selected__c, Group_ID__c, Group_Name__c
        FROM Bug_Team__c WHERE Bug__c = : b1.id];
        Test.stopTest();
    }
}