/* 
 Name: R_TeamRoomMemberHelper Class
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 12-06-2017
 Reason: Helper class which consist of logics used in R TeamRoom Triggers.
         This Class calls following methods
         @CreateTeamRoomShare(On Creation of Team Room Member it create corresponding Team Room SHare)
         @DeleteTeamRoomShare(On Deletion of Team Room Member it delete corresponding Team Room Share)
 ……..
--*/


public Class R_TeamRoomMemberHelper{

  public void CreateTeamRoomShare(List<R_Team_Room_Member__c> rteammemlist){
   List<Restricted_Team_Room__Share> newshares= new List<Restricted_Team_Room__Share>();
   for(R_Team_Room_Member__c rteam:rteammemlist){
    if(rteam.Team_Room_Role__c=='Moderator'){
     Restricted_Team_Room__Share rshares=new Restricted_Team_Room__Share();
     rshares.ParentId=rteam.Restricted_Team_Room__c;
     rshares.UserOrGroupId=rteam.User__c;
     rshares.AccessLevel='Edit';
     newshares.add(rshares);
    }
    else{
     Restricted_Team_Room__Share rshares=new Restricted_Team_Room__Share();
     rshares.ParentId=rteam.Restricted_Team_Room__c;
     rshares.UserOrGroupId=rteam.User__c;
     rshares.AccessLevel='Read';
     newshares.add(rshares);
    }
   }

   if(newshares.size()>0){
    try{
    insert newshares;
    }
    Catch(Exception e){
    System.debug('An exception occurred: ' + e.getMessage());
    }
   }
  }
  
  public void DeleteTeamRoomShare(List<R_Team_Room_Member__c> deleterteammemlist){
   
       set<Id> Userset=new set<Id>();
       set<Id> rteamset=new set<Id>();
       for(R_Team_Room_Member__c rt:deleterteammemlist){
       Userset.add(rt.User__c);
       rteamset.add(rt.Restricted_Team_Room__c);
       }
       
       List<Restricted_Team_Room__Share> sharesToDelete = [SELECT Id 
                                                FROM Restricted_Team_Room__Share
                                                WHERE UserorGroupId IN :Userset and ParentId=:rteamset];


        if(sharesToDelete .size()>0){
        try{
        delete sharesToDelete ;
        }
        Catch(Exception e){
        System.debug('An exception occurred: ' + e.getMessage());
        }
       }
      
      }

}