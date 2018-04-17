/*
Type Name: clsRteamroomshowlinkcontrollerTest Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 25/7/2017
Reason: This test class is used to pass the COntroller Class clsRteamroomshowlinkcontroller 

Change History:
Author: 
Modified Date: 
Reason: 
*/
@isTest

public Class clsRteamroomshowlinkcontrollerTest{

  public static testMethod void method1(){
   clsRteamroomshowlinkcontroller controller=new clsRteamroomshowlinkcontroller();
   controller.documentID='STest';
   system.assert(controller.documentID!=null);
  }

}