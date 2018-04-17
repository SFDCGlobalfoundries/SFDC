/*
Type Name: TeamRoomDocDeleteLogTrigger Trigger
Author: Cognizant 
Created Date: 9-July-2013
Reason: To save the delete log to deleted records which gets integrated with OpenText
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger TeamRoomDocDeleteLogTrigger on Team_Room_Doc__c (Before Delete, After Insert, After Update) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
Profile profileIntegration=[Select Id, Name from Profile where Name='GF Integration'];

if(profileIntegration!=null && UserInfo.getProfileId()!=profileIntegration.Id){
if(trigger.isdelete){
for(Team_Room_Doc__c p:Trigger.old){
    if(p.Design_Spec__c!=null){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Team Room Spec';
    temp.Team_Room_SF_Id__c=p.id;
    if(p.Team_Room_OpenText_ID__c!=null)
    temp.Team_Room_OpenText_Id__c=String.valueOf(p.Team_Room_OpenText_ID__c);
    if(p.Team_Room_Doc_Folder_Id__c!=null)    
    temp.Team_Room_Doc_Folder_Id__c=Integer.valueOf(p.Team_Room_Doc_Folder_Id__c);
    temp.Spec_SF_Id__c=p.Team_Room_Doc_Folder_Id__c;
    temp.Spec_OpenText_Id__c=String.valueOf(p.Spec_OpenText_Id__c);
    temp.Sync_With_OpenText__c=false;
    lstLogs.add(temp);
    }
    else if(p.Sub_PDK__c!=null){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Team Room Sub PDK';
    temp.Team_Room_SF_Id__c=p.id;
    if(p.Team_Room_OpenText_ID__c!=null)
    temp.Team_Room_OpenText_Id__c=String.valueOf(p.Team_Room_OpenText_ID__c);
    if(p.Team_Room_Doc_Folder_Id__c!=null)    
    temp.Team_Room_Doc_Folder_Id__c=Integer.valueOf(p.Team_Room_Doc_Folder_Id__c);
    temp.Sub_PDK_SF_Id__c=p.Sub_PDK__c;
    if(p.Sub_PDK_OpenText_Id__c!=null)
    temp.Sub_PDK_OpenText_Id__c=String.valueOf(p.Sub_PDK_OpenText_Id__c);
    temp.Sync_With_OpenText__c=false;
    lstLogs.add(temp);
    }
    else if(p.Design_Package__c!=null){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Team Room Sub PDK';
    temp.Team_Room_SF_Id__c=p.id;
    if(p.Team_Room_OpenText_ID__c!=null)
    temp.Team_Room_OpenText_Id__c=String.valueOf(p.Team_Room_OpenText_ID__c);
    if(p.Team_Room_Doc_Folder_Id__c!=null)
    temp.Team_Room_Doc_Folder_Id__c=Integer.valueOf(p.Team_Room_Doc_Folder_Id__c);
    temp.Package_SF_Id__c=p.Design_Package__c;
    if(p.Package_OpenText_Id__c!=null)
    temp.Package_OpenText_Id__c=String.valueOf(p.Package_OpenText_Id__c);
    temp.Sync_With_OpenText__c=false;
    lstLogs.add(temp);
    }
    
}
try{
    insert lstLogs;

}catch(Exception e){}
}
    if(/*(*/trigger.isinsert/* || trigger.isupdate) && UserInfo.getProfileId()!=profileIntegration.Id*/){
        DesignSpecTriggerHandler.createTeamRoomProvisioningByAddingDocs(trigger.new);       
  }
  if(trigger.isdelete){
        DesignSpecTriggerHandler.teamRoomDeprovisioningByRemovingDocs(Trigger.old); 
  }
}
}