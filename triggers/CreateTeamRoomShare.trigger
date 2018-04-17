/*
Type Name: CreateTeamRoomShare Trigger
Author: Cognizant 
Created Date: 4-july-2013
Reason: The trigger create Team Room share record and delete Team room share record
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger CreateTeamRoomShare on Team_Room_Member__c (after insert,after update,before delete) 
{

   List<Team_Room__Share> TeamRoomShareDelList= new List<Team_Room__Share> (); 
   List<Team_Room__Share> TeamRoomShareList=new List<Team_Room__Share>();
   List<Team_Room_Member__c> TRMList=new List<Team_Room_Member__c>();
   Set<Id> TRMIdSet=new Set<id>();
   Set<Id> userIDSet=new Set<id>();
   Set<Id> TeamRoomIdSet=new Set<id>();
   
   system.debug('trigger.new'+trigger.old);
   if(trigger.isdelete)
   {
      for (Team_Room_Member__c objTRM:trigger.old)
       {
        TRMIdSet.add(objTRM.Id);
       } 
     system.debug(' TRMIdSet'+TRMIdSet); 
    }  
       TRMList=[Select Id,User__c,Team_Room__c from Team_Room_Member__c where Id In:TRMIdSet];

        system.debug('TRMList'+TRMList);
       for(Team_Room_Member__c trmobj:TRMList)
       {
       userIDSet.add(trmobj.User__c);
       
       TeamRoomIdSet.add(trmobj.Team_Room__c);
       }
       
        if(trigger.isinsert || trigger.isupdate)
        {
           Team_Room__Share objTeamRoomShare=new Team_Room__Share();
           for (Team_Room_Member__c objTRM: trigger.new)
           {
             objTeamRoomShare=new Team_Room__Share();
             objTeamRoomShare.ParentId=objTRM.Team_Room__c;
             objTeamRoomShare.UserOrGroupId=objTRM.User__c;
             objTeamRoomShare.AccessLevel='Read';
             
             TeamRoomShareList.add(objTeamRoomShare);
             
             system.debug('@@@TeamRoomShareList'+TeamRoomShareList);
             
           }
             if(TeamRoomShareList.size()>0)
             {
             Database.insert(TeamRoomShareList, false); 
             
             } 

      }
      if(trigger.isdelete)
      {
       TeamRoomShareDelList=[SELECT ID FROM Team_Room__Share WHERE RowCause = 'Manual' and UserOrGroupId IN: userIDSet and ParentId In:TeamRoomIdSet];
       
       system.debug('TeamRoomShareDelList'+TeamRoomShareDelList);
       system.debug('TeamRoomShareDelList.size'+TeamRoomShareDelList.size());
        if (TeamRoomShareDelList.size()>0) 
        {
          delete TeamRoomShareDelList;
                        
         }
    
      }
      
      if(trigger.isinsert || trigger.isupdate){
            DesignSpecTriggerHandler.createTeamRoomProvisioningByAddingMembers(trigger.new);        
      }
      if(trigger.isdelete){
            DesignSpecTriggerHandler.teamRoomDeprovisioningByRemovingMembers(Trigger.old);  
      }

}