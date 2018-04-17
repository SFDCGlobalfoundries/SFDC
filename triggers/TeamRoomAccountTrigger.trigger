/*
Type Name: TeamRoomAccountTrigger Trigger
Author: Cognizant 
Created Date: 20-May-2013
Reason: The trigger will call the method updatePrimaryAccount of the trigger handler class TeamRoomAccountTriggerHandler
        to update Primary account on parent team room.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger TeamRoomAccountTrigger on Team_Room_Account__c (after Insert,after Update) {

    /** This  section will call the method updatePrimaryAccount of the trigger handler class 
        TeamRoomAccountTriggerHandler to update Primary account on parent team room.
    **/      

      List<Id> teamRoomAccntIdInitList = new List<Id>();
      Map <Id, Id> idTeammRmAccountMap = new Map<Id, Id>(); 
      List<Id> teamRoomIdList = new List<Id>();
   
      for(Team_Room_Account__c teamRoomAccntObj :  trigger.new){
        teamRoomAccntIdInitList.add(teamRoomAccntObj.Id);
      }
      
     List<Team_Room_Account__c> teamRoomAccntProcessingList = [SELECT Id,Account__c,Team_Room__c FROM Team_Room_Account__c where Id in :teamRoomAccntIdInitList and Association_Type__c='Primary Account'];
     
     for(Team_Room_Account__c teamRoomAccntObj : teamRoomAccntProcessingList) {
        idTeammRmAccountMap.put(teamRoomAccntObj.Id, teamRoomAccntObj.Account__c);
        teamRoomIdList.add(teamRoomAccntObj.Team_Room__c);
     }         

     // This method updates Primary Account field on parent team room whenever the first account is added to the team room.
     ClsTeamRoomAccountTriggerHandler.updatePrimaryAccount(teamRoomAccntIdInitList,idTeammRmAccountMap, teamRoomIdList);      

}