/*
Type Name: TeamRoomDeleteLogTrigger Trigger
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
trigger TeamRoomDeleteLogTrigger on Team_Room__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
RecordType r = [select id,Name from RecordType where name='Pre FV2 Teamroom'];
for(Team_Room__c p:Trigger.old){
    if(p.recordTypeId != r.id){
        Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
        temp.entity__c='Team Room';
        temp.Team_Room_OpenText_Id__c=string.valueof(p.OpenText_Id__c);
        temp.Team_Room_SF_Id__c=p.id;
        temp.Sync_With_OpenText__c=false;
    
        lstLogs.add(temp);
    }
}
try{
    if(lstLogs.size()>0)
        insert lstLogs;

}catch(Exception e){}
}