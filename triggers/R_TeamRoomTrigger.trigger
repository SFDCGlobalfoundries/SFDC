/*
Type Name: R_TeamRoomTrigger Trigger
Author: Global Foundries
Created Date: 24-May-2017
Reason: This trigger fires on Restricted_Team_Room__c on creating or editing the "R Team Room " in the Org

*/


trigger R_TeamRoomTrigger on Restricted_Team_Room__c(before insert, before update,after insert, after update) {
      new R_TeamRoomHandler().run();
   
}