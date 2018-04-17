/*
Type Name: SubPDKDeleteLogTrigger Trigger
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
trigger SubPDKDeleteLogTrigger on Sub_PDK__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
for(Sub_PDK__c p:trigger.old){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Sub PDK';
    temp.Sub_PDK_SF_Id__c=p.id;
    temp.Sub_PDK_OpenText_Id__c=String.valueof(p.Sub_PDK_OpenText_Id__c);
    temp.Sync_With_OpenText__c=false;
    
    lstLogs.add(temp);
}
try{
    insert lstLogs;

}catch(Exception e){}
}