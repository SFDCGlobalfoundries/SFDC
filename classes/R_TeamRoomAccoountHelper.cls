/*
Type Name: R_TeamRoomAccoountHelper Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 20/6/2017
Reason: This Class is having following methods
        @OndeletingAccDeleteMembersaAndShares (On Deleting Account it will delete related members of the respective account)

Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public Class R_TeamRoomAccoountHelper{
 
 public void OndeletingAccDeleteMembersaAndShares(List<R_Team_Room_Account__c> rtacclist){
 
  set<Id> accountset=new set<Id>();
  set<Id> teamroomid=new set<Id>(); 
  
  for(R_Team_Room_Account__c r: rtacclist){
   accountset.add(r.Account__c);
   teamroomid.add(r.Restricted_Team_Room__c);
  }                                                      
  
  system.debug('accsetclass'+accountset);
  system.debug('teamroomsetclass'+teamroomid);
  List<R_Team_Room_Member__c> deletememblist=[Select Id,User__c, Restricted_Team_Room__c,Team_Room_Role__c,Account__c
                                                        From R_Team_Room_Member__c where Restricted_Team_Room__c=: teamroomid and Account__c=:accountset];
 
  if(deletememblist.size()>0){
  delete deletememblist; 
  }
 }
  

}