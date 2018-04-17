/*
Type Name: R_TeamRoomHelper Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 11-July-2017
Reason: This Class is having two Methods
        @OnTeamRoomCreationInsertFolder(On Creation of TeamRoom it insert folder with same name)
        @addCorrespondingTRAccount(On Creation of Team Room it insert corresponding account)
        @OnTRCreationaddUserasMember(On Creation of Team Room it insert owner as the member)
Change History:
Author: 
Modified Date: 
Reason: 
*/

Public Class R_TeamRoomHelper {
  
   public void OnTeamRoomCreationInsertFolder(List<Restricted_Team_Room__c>  rteamroomlist){
   
         List<Folder__c> NewFolderlist=new List<Folder__c>(); 
         for (Restricted_Team_Room__c trObj : rteamroomlist)
         {
               Folder__c fc=new Folder__c();
               fc.Name=trObj.Name;
               fc.Restricted_Team_Room__c=trObj.Id;
               
               NewFolderlist.add(fc);
         }
         insert NewFolderlist;
         
   }
   

   public  void addCorrespondingTRAccount(List<Restricted_Team_Room__c>  rteamroomlist){
     List<R_Team_Room_Account__c> newteamroomacctlist=new List<R_Team_Room_Account__c>();
     
        for(Restricted_Team_Room__c rt:rteamroomlist){
         if(rt.R_Primary_Account__c!=null){
         system.debug('Enter if loop');
         R_Team_Room_Account__c RTRA=new R_Team_Room_Account__c();
         RTRA.Association_Type__c='Primary Account';
         RTRA.Account__c=rt.R_Primary_Account__c;
         RTRA.Restricted_Team_Room__c=rt.Id;
         newteamroomacctlist.add(RTRA);
         }
        }
        if(newteamroomacctlist.size()>0){
         try{
          insert newteamroomacctlist;
         }
         Catch(Exception e){
          System.debug('An exception occurred: ' + e.getMessage());
         }
        }
   }
   
    public void OnTRCreationaddUserasMember(List<Restricted_Team_Room__c>  rtlist){
      
       List<R_Team_Room_Member__c> newmemlist=new List<R_Team_Room_Member__c>();
       
       for(Restricted_Team_Room__c  rt1:rtlist){
        R_Team_Room_Member__c RTRM=new R_Team_Room_Member__c();
        RTRM.Account__c=rt1.R_Primary_Account__c;
        RTRM.Restricted_Team_Room__c=rt1.Id;
        RTRM.User__c=rt1.OwnerId;
        RTRM.Team_Room_Role__c='Moderator';
        newmemlist.add(RTRM);
        }
        if(newmemlist.size()>0){
         try{
         insert newmemlist;
         }
         Catch(Exception e){
         system.debug('An exception occurred:'+e.getMessage());
         }
        }
       }
       
}