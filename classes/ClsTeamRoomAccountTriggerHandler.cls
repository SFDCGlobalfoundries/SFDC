/*
Type Name: ClsTeamRoomAccountTriggerHandler 
Author: Cognizant
Created Date: 20-May-2013
Reason: This class updates Primary Account field on parent team room whenever the first account is added to the team room.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


public class ClsTeamRoomAccountTriggerHandler {

    /** Modified By Cognizant on 25042013 Start
     **/
    /**
        This method updates Primary Account field on parent team room whenever the first account is added to the team room.
        @method name: updatePrimaryAccount
        @parameter:   List of TeamRoomAccountIds, map of TeamRoomAccountIds and its Account Ids, List of TeamRoomIds .
        @return :     none
    **/ 
    
   // This method updates Primary Account field on parent team room whenever the first account is added to the team room.
   public static void updatePrimaryAccount(List<Id> teamRoomAccntIdInitList, Map <Id, Id> idTeammRmAccountMap, List<Id> teamRoomIdList){
   
     if(teamRoomIdList!= null && !(teamRoomIdList.isEmpty())) {

         List<Team_Room__c> teamRoomList = [SELECT Id FROM Team_Room__c where Id in :teamRoomIdList];
         
         // If teamRoomAccntIdInitList is not null or blank. 
         if(teamRoomAccntIdInitList!= null && !(teamRoomAccntIdInitList.isEmpty())) {
                for(Id teamRoomAccntId : teamRoomAccntIdInitList) {
                    Id primaryAccountId = idTeammRmAccountMap.get(teamRoomAccntId);
                    
                    if(teamRoomList.size() > 0){
                        for(Team_Room__c teamRoomObj : teamRoomList)
                        {
                            teamRoomObj.Primary_Account__c = primaryAccountId;
                        }
                    }
                    
                }
           } 
          
       // Finally get the teamRoomList and update it.
       try{     
          update teamRoomList;   
       }catch(DMLException de){
            System.debug(de.getMessage());
       }    
   }
  }
}