/*
Type Name: CreateShareforInvitee Trigger
Author: Cognizant 
Created Date: 4-july-2013
Reason: The trigger is used to create GF_Meeting_Invitee__c share records when Invitee is created
and delete GF_Meeting_Invitee__c share records when Invitee is deleted
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger CreateShareforInvitee on GF_Meeting_Invitee__c (after insert,after update,before delete) 

{
   List<GF_Meeting_Occurrence__Share> GFmettingoccShareDelList= new List<GF_Meeting_Occurrence__Share>(); 
   List<GF_Meeting_Occurrence__Share> GFmettingoccShareInsertList=new List<GF_Meeting_Occurrence__Share>();
   List<GF_Meeting_Invitee__c> InviteeOldList=new List<GF_Meeting_Invitee__c>();
   List<GF_Meeting_Invitee__c> InviteeNewList=new List<GF_Meeting_Invitee__c>();
   List<GF_Meeting_Occurrence__c> OccOldList=new List<GF_Meeting_Occurrence__c>();
   List<GF_Meeting_Occurrence__c> OccNewList=new List<GF_Meeting_Occurrence__c>();
   
   Set<Id> InviteeOldIdSet=new Set<id>();
   Set<Id> InviteeNewIdSet=new Set<id>();
   Set<Id> userIDSet=new Set<id>();
   Set<Id> TeamRoomMeetingIdSet=new Set<id>();
   Set<Id> OccurrenceIdSet=new Set<id>();
   Set<Id> usernewIDSet=new Set<id>();
   Set<Id> TeamRoomMeetingnewIdSet=new Set<id>();
   Set<Id> OccurrencenewIdSet=new Set<id>();
   
   if(trigger.isdelete)
   {
      for (GF_Meeting_Invitee__c objInvitee:trigger.old)
       {
        InviteeOldIdSet.add(objInvitee.Id);
       } 
     
    }  
   InviteeOldList=[Select Id,User__c,Team_Room_Meeting__c,GF_Meeting_Occurrence__c from GF_Meeting_Invitee__c where Id In:InviteeOldIdSet];
   
     for(GF_Meeting_Invitee__c objInvitee:InviteeOldList)
       {
           if(objInvitee.GF_Meeting_Occurrence__c==null)
           {
            userIDSet.add(objInvitee.User__c);
            TeamRoomMeetingIdSet.add(objInvitee.Team_Room_Meeting__c);
            }
          else if(objInvitee.GF_Meeting_Occurrence__c!=null)
           {
            userIDSet.add(objInvitee.User__c);
            OccurrenceIdSet.add(objInvitee.GF_Meeting_Occurrence__c);
            }
            
           
       }
   if(TeamRoomMeetingIdSet.size()>0)
   {
   OccOldList=[Select Id,Name,Team_Room_Meeting__c from GF_Meeting_Occurrence__c where Team_Room_Meeting__c In:TeamRoomMeetingIdSet];  
   system.debug('OccOldList'+OccOldList);
   }
   if(OccOldList.size()>0)
   {
       for(GF_Meeting_Occurrence__c occObj:OccOldList)
       {
        OccurrenceIdSet.add(occObj.Id);
       
       }
   }
   system.debug('OccurrenceIdSet'+OccurrenceIdSet);
   if(trigger.isinsert)
   {   
    for (GF_Meeting_Invitee__c objInvitee:trigger.new)
       {
       InviteeNewIdSet.add(objInvitee.Id);
       }
   }  
   
    InviteeNewList=[Select Id,User__c,Team_Room_Meeting__c,GF_Meeting_Occurrence__c from GF_Meeting_Invitee__c where Id In:InviteeNewIdSet];
    system.debug('InviteeNewList'+InviteeNewList);   
    
     for(GF_Meeting_Invitee__c objInvitee:InviteeNewList)
       {
        usernewIDSet.add(objInvitee.User__c);
        TeamRoomMeetingnewIdSet.add(objInvitee.Team_Room_Meeting__c);
        OccurrencenewIdSet.add(objInvitee.GF_Meeting_Occurrence__c);
       }
       
  
   OccNewList=[Select Id,Name,Team_Room_Meeting__c from GF_Meeting_Occurrence__c where Team_Room_Meeting__c In:TeamRoomMeetingnewIdSet];
   system.debug('OccNewList'+OccNewList);   
     if(trigger.isinsert)
        {
         system.debug('enter insert');
           GF_Meeting_Occurrence__Share objOccurrenceShare=new GF_Meeting_Occurrence__Share();
           for (GF_Meeting_Invitee__c objInvitee:trigger.new)
           {
             if(objInvitee.GF_Meeting_Occurrence__c!=null && objInvitee.User__c!=null)
             {
             system.debug('GF_Meeting_Occurrence__c!=null');
             system.debug('objInvitee'+objInvitee);
             objOccurrenceShare=new GF_Meeting_Occurrence__Share();
             objOccurrenceShare.ParentId=objInvitee.GF_Meeting_Occurrence__c;
             objOccurrenceShare.UserOrGroupId=objInvitee.User__c;
             objOccurrenceShare.AccessLevel='Edit';  
             system.debug('objOccurrenceShare'+objOccurrenceShare);
             GFmettingoccShareInsertList.add(objOccurrenceShare);
             }
             else
             {
                 system.debug('GF_Meeting_Occurrence__c==null');
                 for(GF_Meeting_Occurrence__c occobj:OccNewList)
                 {
                 system.debug('Enter for');
                 objOccurrenceShare=new GF_Meeting_Occurrence__Share();
                 objOccurrenceShare.ParentId=occobj.Id;
                 objOccurrenceShare.UserOrGroupId=objInvitee.User__c;
                 objOccurrenceShare.AccessLevel='Edit';  
                 system.debug('objOccurrenceShare1'+objOccurrenceShare);
                 GFmettingoccShareInsertList.add(objOccurrenceShare);
                 }
              }
             
              
             }
             
            
             if(GFmettingoccShareInsertList.size()>0)
             {
             system.debug('GFmettingoccShareInsertList1'+GFmettingoccShareInsertList);
             database.insert(GFmettingoccShareInsertList,false); 
             system.debug('GFmettingoccShareInsertList2'+GFmettingoccShareInsertList);
             } 
        }
      
     if(trigger.isdelete)
      {
       GFmettingoccShareDelList=[SELECT ID FROM GF_Meeting_Occurrence__Share WHERE RowCause = 'Manual' and UserOrGroupId IN: userIDSet and ParentId In:OccurrenceIdSet];
       
       system.debug('GFmettingoccShareDelList'+GFmettingoccShareDelList);
        if (GFmettingoccShareDelList.size()>0) 
        {
         database.delete(GFmettingoccShareDelList,false);
                        
         }
      }
}