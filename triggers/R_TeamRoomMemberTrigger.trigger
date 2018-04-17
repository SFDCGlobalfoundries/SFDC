/* 
 Name: R_TeamRoomMemberTrigger
 Author: Global Foundries(Dinesh Suggala)
 Created Date: 12-06-2017
 Reason: This trigger fires on R Team Room Member while creation and editing the R Team Room Members in org …….. 
 ……..
--*/

trigger R_TeamRoomMemberTrigger on R_Team_Room_Member__c (before insert,before update,after insert,after update,after delete) {
 
   new R_TeamRoomMemberHandler().run();
  
}