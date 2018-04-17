/*
Trigger Name: ManageEmailNotificationTrigger
Author: Cognizant Case Mgmt Team
Created Date: 13/08/2015
Reason: Reason: This is the generic class for Manage Email Notification
Test Class: 
Change History:
Author: 
Modified Date: 
……..//
……..
--
*/
public class ManageEmailNotificationTriggerHandler{
    public ManageEmailNotificationTriggerHandler(){
    }
    //Executes the before Insert event
    public void OnBeforeInsertManageEmail(List<Manage_Email_Notification__c> newManageEmail) {
        set<Id> manageEmailId = new set<Id>();
        for(Manage_Email_Notification__c manageEmailisBefore : newManageEmail){
            if(manageEmailisBefore.user__c == null){  
                manageEmailisBefore.user__c = userInfo.getUserId();
            }
        }
    }
    //Executes the after Insert Methods
    public void OnAfterInsertManageEmail(List<Manage_Email_Notification__c> newManageEmail) {
        List<Id> manageEmailId = new List<Id>();
        for(Manage_Email_Notification__c manageEmailTemp: newManageEmail){
            manageEmailId.add(manageEmailTemp.id);
        }
        reEvaluateRules(manageEmailId);
    }
    //Executes the after Update Methods
    public void OnAfterUpdateManageEmail(List<Manage_Email_Notification__c> oldManageEmail, List<Manage_Email_Notification__c> newManageEmail,Map < ID, Manage_Email_Notification__c > ManageEmailMap) {
        List<Id> manageEmailId = new List<Id>();
        for(Manage_Email_Notification__c manageEmailTemp: newManageEmail){
                manageEmailId.add(manageEmailTemp.id);
        }        
        reEvaluateRules(manageEmailId);
    }
    //Updates Bug Team Records when Re-evaluate Rules On Field Update field is true
    @future
    public static void reEvaluateRules(List<Id> manageEmailIds) {
    try{
        //Quering all the Manage Email Notification records which are in trigger.new
        List<Manage_Email_Notification__c> newManageEmail = [select id,Bug_Update_Only__c,Chatter_Only__c,User__c,Re_Evaluate__c from Manage_Email_Notification__c where id IN: manageEmailIds];
        List<string> userIds = new List<string>();
        List<Bug_Team__c> bugTeam = new List<Bug_Team__c>();
        
        //Checks Re-evaluate Rules On Field Update is true to update Bug Team
        for(Manage_Email_Notification__c manageEmailEach: newManageEmail){
            if(manageEmailEach.Re_Evaluate__c){
                userIds.add(manageEmailEach.user__c);
            }
        }
        if(!userIds.isEmpty()){
            bugTeam = [select id,User__c,Bug_Update_Only__c,Chatter_Only__c from Bug_Team__c where User__c IN: userIds];
        }
        List<Bug_Team__c> bugTeamToUpdate = new List<Bug_Team__c>();
        if(bugTeam !=null && bugTeam.size()>0){
            for (Bug_Team__c objbugTeam: bugTeam ) {
                for (Manage_Email_Notification__c  manageEmailNew: newManageEmail) {
                    if(objbugTeam.user__c == manageEmailNew.user__c){
                        if(manageEmailNew.Bug_Update_Only__c != objbugTeam.Bug_Update_Only__c){
                            objbugTeam.Bug_Update_Only__c = manageEmailNew.Bug_Update_Only__c;
                        }
                        if(manageEmailNew.Chatter_Only__c != objbugTeam.Chatter_Only__c){
                            objbugTeam.Chatter_Only__c = manageEmailNew.Chatter_Only__c;
                        }
                        bugTeamToUpdate.add(objbugTeam);                        
                    }
                }
            }
        }
        if(!bugTeamToUpdate.isEmpty()){
            update bugTeamToUpdate;
        }
    }
    catch(Exception e){
        CaseHandlerUtility.trackException('ManageEmailNotificationTriggerHandler.reEvaluateRules', e.getLineNumber(), e.getTypeName(), e.getMessage());
    }
    }
}