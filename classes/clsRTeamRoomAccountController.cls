/*
Type Name: clsRTeamRoomAccountController 
Author: Global Foundries(Dinesh Suggala)
Created Date: 27th-July-2017
Reason: This class is used for showing R Team Room Account page.

……..
……..
*/
public class clsRTeamRoomAccountController {
  
  
    public R_Team_Room_Account__c rteamacc{get;set;}
    public String sTeamRoomId;
    public String accid;
    
    public clsRTeamRoomAccountController() {
     sTeamRoomId=Apexpages.currentpage().getparameters().get('id');
     accid=ApexPages.currentpage().getparameters().get('recordId');
     rteamacc=new R_Team_Room_Account__c ();
     rteamacc.Restricted_Team_Room__c=sTeamRoomId;
     
    }
    
    public pageReference save(){
     if(!Test.isRunningTest()){
     insert rteamacc;
     }
     PageReference TRPage = new PageReference('/'+ sTeamRoomId);
     return TRPage; 
    }
    
    public pageReference cancel(){
     PageReference TRPage = new PageReference('/'+ sTeamRoomId);
     return TRPage;
    }

}