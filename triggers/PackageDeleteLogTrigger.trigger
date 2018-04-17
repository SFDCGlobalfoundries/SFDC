/*
Type Name: PackageDeleteLogTrigger Trigger
Author: Cognizant 
Created Date: 9-July-2013
Reason: To save the delete log to deleted records which gets integarted with OpenText
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/
trigger PackageDeleteLogTrigger on Package__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
for(package__c p:trigger.old){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Package';
    temp.Package_SF_Id__c=p.id;
    temp.Package_OpenText_Id__c=String.valueof(p.OTID__c);
    temp.Sync_With_OpenText__c=false;
    
    lstLogs.add(temp);
}
try{
    insert lstLogs;

}catch(Exception e){}
}