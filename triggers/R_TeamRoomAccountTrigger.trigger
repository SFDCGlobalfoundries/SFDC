/*
Type Name: R_TeamRoomAccountTrigger  Trigger
Author: Global Foundries(Dinesh Suggala)
Created Date: 20/6/2017
Reason: This Trigger is Calling R_TeamRoomAccoountHelper Class

Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

trigger R_TeamRoomAccountTrigger on R_Team_Room_Account__c (before delete,after delete) {
   new R_TeamRoomAccountHandler().run();
}