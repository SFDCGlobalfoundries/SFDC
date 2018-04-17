/*
Type Name: clsRteamroomshowlinkcontroller 
Author: Global Foundries(Dinesh Suggala)
Created Date: 25th-July-2017
Reason: This class is used for showing external document link in page

……..
……..
*/
public with sharing class clsRteamroomshowlinkcontroller {

   public String documentID{get;set;}
   
    public clsRteamroomshowlinkcontroller() {
     documentID=Apexpages.currentpage().getparameters().get('id');
     
    }

}