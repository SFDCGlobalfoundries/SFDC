/*
Type Name: CreateGFTaskValidation Trigger
Author: Cognizant 
Created Date: 8-july-2013
Reason: The trigger is used to show an error message when assigned to field in Gf task is not a member of the team room
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/


trigger CreateGFTaskValidation on GF_Task__c (before insert,before update,after insert,after update) 
{

 
 List<Team_Room_Member__c> TRMList=new List<Team_Room_Member__c>();
 List< GF_Task__Share> GFtaskShareInsertList=new List<GF_Task__Share>();
 List< GF_Task__Share> GFtaskSharedeleteList=new List<GF_Task__Share>();
 Set<Id> TeamRoomIdSet=new Set<Id>();
 Set<Id> UserIdSet=new Set<Id>();
 Set<Id> TaskIdSet=new Set<Id>();
 
 for (GF_Task__c objTask:trigger.new)
       {
        TeamRoomIdSet.add(objTask.Team_Room__c);
       } 
 if(trigger.isupdate)
 {    
 for (GF_Task__c objTask:trigger.old)
       {
        UserIdSet.add(objTask.assignTo__c);
        TaskIdSet.add(objTask.Id);
       } 
 }      
  system.debug('@@@UserIdSet'+UserIdSet);   
  system.debug('@@@TaskIdSet'+TaskIdSet);   
  
 TRMList=[Select Id,User__c,Team_Room__c from Team_Room_Member__c where Team_Room__c in:TeamRoomIdSet];
 Map<Id,Id> TeamRoomMemberMap=new Map<Id,Id>();
 for(Team_Room_Member__c objTRM:TRMList)
       {
       TeamRoomMemberMap.put(objTRM.User__c,objTRM.User__c);
       }
 
 if(trigger.isbefore)
 {
  
      for (GF_Task__c objTask:trigger.new)
      {
           for(Team_Room_Member__c objTRM:TRMList)
           {
               if(!(TeamRoomMemberMap.containskey(objTask.assignTo__c)))
               {
                objTask.assignTo__c.adderror('Assigned to is not a member of the Team Room');
               }
           }
       }
   
  GFtaskSharedeleteList=[SELECT ID FROM GF_Task__Share 
                                WHERE RowCause = 'Manual' and
                                UserOrGroupId IN:UserIdSet and ParentId In:TaskIdSet];
                                
   system.debug('@@@GFtaskSharedeleteList'+GFtaskSharedeleteList); 
    if(GFtaskSharedeleteList.size()>0)
    
    {
    
    database.delete(GFtaskSharedeleteList,false);
    }
       
   }
   
   if(trigger.isafter)
  {
    GF_Task__Share objTaskShare=new GF_Task__Share();
   
      for (GF_Task__c objTask:trigger.new)
      { 
         if(objTask.assignTo__c!=null)
         {
             objTaskShare=new GF_Task__Share();
             objTaskShare.ParentId=objTask.Id;
             objTaskShare.UserOrGroupId=objTask.assignTo__c;
             objTaskShare.AccessLevel='Edit';  
             
             GFtaskShareInsertList.add(objTaskShare);   
         }      
      }
  
  /*GFtaskSharedeleteList=[SELECT ID,UserOrGroupId FROM GF_Task__Share 
                                WHERE RowCause = 'Manual' and
                                UserOrGroupId IN:UserIdSet and ParentId In:TaskIdSet];
                                 system.debug('@@@GFtaskSharedeleteList'+GFtaskSharedeleteList); 
    if(GFtaskSharedeleteList.size()>0)
    
    {
    
    database.delete(GFtaskSharedeleteList,false);
    }     */                      
   if(GFtaskShareInsertList.size()>0)
             {
             system.debug('GFtaskShareInsertList'+GFtaskShareInsertList);
             database.insert(GFtaskShareInsertList,false); 
             
             } 
             
   }          
       
}