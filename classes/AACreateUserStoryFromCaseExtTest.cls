/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Test class for AACreateUserStoryFromCaseExt
*   History: 
*   skarukon      12/07/2015    - Apex code created    
*/

@isTest
private class AACreateUserStoryFromCaseExtTest {
    
    @isTest static void createUserStory() {
        Case sfdcAdminCase = new Case();
        sfdcAdminCase.Subject = 'Subject';
        sfdcAdminCase.Description = 'Description';
        insert sfdcAdminCase;

        AACreateUserStoryFromCaseExt createCaseCtrl = new AACreateUserStoryFromCaseExt(new ApexPages.StandardController(sfdcAdminCase));
        agf__ADM_Scrum_Team__c team = AATestData.createTeam();
        List<agf__ADM_Scrum_Team__c> allTeams = createCaseCtrl.teams;
        List<agf__ADM_Scrum_Team_Member__c> myTeams = createCaseCtrl.myTeams;
        createCaseCtrl.assignToThisTeam  = team.Id;
        createCaseCtrl.createUserStory();

        /*List<agf__ADM_Work__c> stories = [select Id, Name, agf__Scrum_Team__c, agf__Use_Prioritizer__c, agf__Subject__c, 
                                            agf__Details__c from agf__ADM_Work__c where agf__Scrum_Team__c = :team.Id];
        System.assertEquals(1, stories.size());
        */

    }
    
}