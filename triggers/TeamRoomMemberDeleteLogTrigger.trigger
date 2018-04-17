/*
Type Name: TeamRoomMemberDeleteLogTrigger Trigger
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
trigger TeamRoomMemberDeleteLogTrigger on Team_Room_Member__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
for(Team_Room_Member__c p:Trigger.old){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Team Room Member';
    temp.Team_Room_SF_Id__c=p.Team_Room__c;
    if(p.Team_Room_OpenText_ID__c!=null)
    temp.Team_Room_OpenText_Id__c=String.valueOf(p.Team_Room_OpenText_ID__c);
    if(p.Team_Room_Doc_Folder_Id__c!=null)
    temp.Team_Room_Doc_Folder_Id__c=Integer.valueOf(p.Team_Room_Doc_Folder_Id__c);
    temp.Team_Room_Member_Short_Name__c=p.User_Short_Name__c;
    temp.Team_Member_Role__c=p.Team_Room_Role__c;
    temp.Sync_With_OpenText__c=false;
    lstLogs.add(temp);
    
}
try{
    insert lstLogs;

}catch(Exception e){}
}