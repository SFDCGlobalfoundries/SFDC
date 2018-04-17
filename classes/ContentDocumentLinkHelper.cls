/*
Type Name: ContentDocumentLinkHelper 
Author: Dinesh Suggala(Global Foundries)
Created Date: 26-February-2018
Reason: This class is used for updating the checkbox "Prevents Others from sharing and unsharing" from the file Object
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public Class ContentDocumentLinkHelper {

 public void PreventCheckboxforfile(List<ContentDocumentLink> contentlink){
   
   set<Id> contlinkset=new set<Id>();
   String FolderKeyPrefix = Folder__c.sObjectType.getDescribe().getKeyPrefix();
   
   for(ContentDocumentLink cntLink:contentlink){
   
   String linkid=String.ValueOf(cntLink.LinkedEntityId);
    if(linkid.StartsWith(FolderKeyPrefix)){
    contlinkset.add(cntLink.ContentDocumentId);
    }
   }
  
  
   if(contlinkset.size()>0){
    List<ContentVersion> converslist=[Select Id,SharingOption,ContentDocumentId from ContentVersion where ContentDocumentId IN: contlinkset];
    List<ContentVersion> newconvlist=new List<ContentVersion>();
    for(ContentVersion conver:converslist){
     conver.SharingOption='R';
     newconvlist.add(conver);
    }
    try{
    Database.update(newconvlist,false);  
    }
    Catch(DMLException e){
    //Adding code for exception framework   
    for(Integer i = 0; i < e.getNumDml(); i++) {
        // Process exception here
        GlobalUtility.logMessage('Error','ContentDocumentLinkHelper','ITAR Restricted Team Room','',e.getDmlMessage(i),String.valueof(e.getMessage()),'','ITAR Restricted Team Room',e,0);
        System.debug(e.getDmlMessage(i)); 
      }
    }
   }
 
 }


}