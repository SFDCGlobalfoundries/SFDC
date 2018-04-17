/*
Type Name: CreateGFInviteeValidation Trigger
Author: Cognizant 
Created Date: 8-july-2013
Reason: The trigger is used to show an error message when User field in Gf Invitee is not a member of the team room
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


trigger CreateGFInviteeValidation on GF_Meeting_Invitee__c (before insert,before update) 
{

 List<GF_Meeting_Occurrence__c> GFOccurrenceList=new List<GF_Meeting_Occurrence__c >();
 Set<Id> OccurrenceIdSet=new Set<Id>();
 Set<Id> TeamRoomIdSet=new Set<Id>();
 List<Team_Room_Member__c> TRMList=new List<Team_Room_Member__c>();
 Map<Id,Id> TeamRoomMemberMap=new Map<Id,Id>();
 
 for (GF_Meeting_Invitee__c objInvitee:trigger.new)
       {
        OccurrenceIdSet.add(objInvitee.GF_Meeting_Occurrence__c);
       } 
       
       system.debug('@@OccurrenceIdSet'+OccurrenceIdSet);
       
  GFOccurrenceList=[Select  Id,
                            Team_Room_Meeting__c,
                            Team_Room_Meeting__r.Team_Room__c
                            from GF_Meeting_Occurrence__c 
                            where Id In:OccurrenceIdSet];
                        
  for(GF_Meeting_Occurrence__c objGFOccurrence:GFOccurrenceList)
  {
   TeamRoomIdSet.add(objGFOccurrence.Team_Room_Meeting__r.Team_Room__c);
  }                 
                        
  
     TRMList=[Select Id,User__c,Team_Room__c from Team_Room_Member__c where Team_Room__c in:TeamRoomIdSet];
     system.debug('@@TRMList'+TRMList);
     
     
     for(Team_Room_Member__c objTRM:TRMList)
           {
           TeamRoomMemberMap.put(objTRM.User__c,objTRM.User__c);
           }
           
           
     system.debug('@@TeamRoomMemberMap'+TeamRoomMemberMap);      
     for (GF_Meeting_Invitee__c objInvitee:trigger.new)
      {
       
           for(Team_Room_Member__c objTRM:TRMList)
           {
               if(!(TeamRoomMemberMap.containskey(objInvitee.User__c)))
               {
                objInvitee.user__c.adderror('User is not a member of the Team Room');
               }
           }
       }
  
}