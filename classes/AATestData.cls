/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as Test data creation for all Agile Accelerator customizations related Test classes
*   History: 
*   skarukon      09/22/2015    - Apex code created    
*/

@isTest
public class AATestData {
    public  static agf__ADM_Product_Tag__c createProductTag(){
        agf__ADM_Product_Tag__c productTag = new agf__ADM_Product_Tag__c();
        productTag.agf__Active__c = true;
        productTag.agf__Team_Tag_Key__c = 'My team Tag';
        //insert productTag;
        return productTag;
    }
    public static agf__ADM_Scrum_Team__c createTeam(){
        agf__ADM_Scrum_Team__c team = new agf__ADM_Scrum_Team__c();
        team.agf__Active__c = true;
        team.Name= 'My Team';
        team.agf__Cloud__c = 'Core';
        //insert team;
        return team;
    }

    public static agf__ADM_Build__c createBuild(){
        agf__ADM_Build__c build = new agf__ADM_Build__c();
        build.Name = 'MyBuild'+ Math.Random();
        build.Release_Date__c = Date.today()+21;
        build.agf__Release_Freeze__c = Date.today()+14;
        //insert build;
        return build;
    }

    public static List<agf__ADM_Work__c> createUserStories(agf__ADM_Build__c build, Integer numberOfStories){
        List<agf__ADM_Work__c> stories = new List<agf__ADM_Work__c>();
        for(Integer index = 0; index < numberOfStories; index++){
            agf__ADM_Work__c work = new agf__ADM_Work__c();
            work.agf__Subject__c = 'Subject '+ index;
            work.agf__Description__c = 'Description '+index;
            work.agf__Scheduled_Build__c = build.Id;
            stories.add(work);
        }
        //insert stories;
        return stories;
    }   
}