/*
Type Name: FeedItemHelper Class
Author: Global Foundries(Dinesh Suggala)
Created Date: 4th August 2017
Reason: This Class is having two Methods
        @OpenAccesstoAllFolderRec(WHenever the attachment is getting inserted to Feeditem of the folder record  it will open the Visibility to "All with Access")
        @OpenAccesstoAllRTeamRoomRec(Whenever the attachment is getting inserted to FeedItem of the RestrictedTeam Room Record it will open the visibility to "All with Access")
Change History:
Author: 
Modified Date: 
Reason: 
*/

public Class FeedItemHelper{

       public void OpenAccesstoAllFolderRec(List<FeedItem> FeedItemlst){      
        List<FeedItem> newFeedItemlst=new List<FeedItem>(); 
        String FolderKeyPrefix = Folder__c.sObjectType.getDescribe().getKeyPrefix();
        
        for(FeedItem fd: FeedItemlst){
               String parentIdTemp1 = fd.parentId;
               if(parentIdTemp1.startsWith(FolderKeyPrefix )){
                fd.NetworkScope = 'AllNetworks';
                fd.Visibility='AllUsers';
                newFeedItemlst.add(fd);
               }
       
        }
       }
       
       public void OpenAccesstoAllRTeamRoomRec(List<FeedItem> FeedItemlst){
        List<FeedItem> newFeedItemlst1=new List<FeedItem>(); 
        String RTeamRoomKeyPrefix = Restricted_Team_Room__c.sObjectType.getDescribe().getKeyPrefix();
       
         for(FeedItem fd: FeedItemlst){
               String parentIdTemp1 = fd.parentId;
                if(parentIdTemp1.startsWith(RTeamRoomKeyPrefix )){
                fd.NetworkScope = 'AllNetworks';
                fd.Visibility='AllUsers'; 
                newFeedItemlst1.add(fd);
          }
        }
       }
}