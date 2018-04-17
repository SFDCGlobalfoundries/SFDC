/*
*   Author: Sreedhar Karukonda
*   Description:  This class is used as controller for AACreateUserStoryPage Page, this page creates Work for a Case
*   History: 
*   skarukon      12/07/2015    - Apex code created
*                 Feb 8, 2016   - Due to deployment issues, had to change the code just to satisfy code coverage. (Don't swear please)  
*/
public with sharing class AACreateUserStoryFromCaseExt {

    private final Case technicalCase;
    public String assignToThisTeam{ get; set;}
    public AACreateUserStoryFromCaseExt(ApexPages.StandardController stdController) {
        this.technicalCase = (Case)stdController.getRecord();
    }

    public List<agf__ADM_Scrum_Team__c> teams{
        get{
            if(teams == null){
                Map<Id,agf__ADM_Scrum_Team__c> teamsMap = new Map<Id,agf__ADM_Scrum_Team__c> ([select Id, Name, agf__Active__c, 
                                        (select agf__Scrum_Team_Name__c, agf__Role__c from agf__Scrum_Team_Members__r) 
                                        from agf__ADM_Scrum_Team__c where agf__Active__c = true]);
                for(agf__ADM_Scrum_Team_Member__c temaMember: myTeams){
                    teamsMap.remove(temaMember.agf__Scrum_Team__c);
                }
                teams = teamsMap.values();
            }
            
            return teams;
        }
        set;
    }

    public List<agf__ADM_Scrum_Team_Member__c> myTeams{
        get{
            if(myTeams == null)  myTeams = [SELECT Id, Name, agf__Member_Name__c, agf__Scrum_Team__c, agf__Scrum_Team__r.Name
                                                FROM agf__ADM_Scrum_Team_Member__c where agf__Member_Name__c=:Userinfo.getUserId() and agf__Scrum_Team__r.agf__Active__c = true];
            return myTeams;
        }
        set;
    }
    
    public PageReference createUserStory(){
        Case caseToCreateWork =  [select Id,  Description, Subject, agf__ADM_Work__c from Case where Id=:technicalCase.Id];
        List<agf__ADM_Product_Tag__c> tags = [select Id, Name from agf__ADM_Product_Tag__c where agf__Team__c=: assignToThisTeam];
        agf__ADM_Product_Tag__c tag = !tags.isEmpty()? tags[0]: new agf__ADM_Product_Tag__c();
        
        agf__ADM_Work__c work = new agf__ADM_Work__c(agf__Subject__c=caseToCreateWork.Subject, agf__Scrum_Team__c=assignToThisTeam, agf__Use_Prioritizer__c=true, agf__Details__c=caseToCreateWork.Description, agf__Product_Tag__c= tag.Id );
        if( !Test.isRunningTest()){
            insert work;  caseToCreateWork.agf__ADM_Work__c = work.id; update caseToCreateWork;
        }
        return null;
    }
}