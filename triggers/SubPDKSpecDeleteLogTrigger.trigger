/*
Type Name: SubPDKSpecDeleteLogTrigger Trigger
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
trigger SubPDKSpecDeleteLogTrigger on Sub_PDK_Spec__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
for(Sub_PDK_Spec__c p:[select Sub_PDK__c,Sub_PDK__r.Sub_PDK_OpenText_Id__c,OTID__c,design_spec__c,design_spec__r.openText_id__c from Sub_PDK_Spec__c where id in: trigger.oldmap.keyset()]){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Sub PDK Spec';
    temp.Sub_PDK_OpenText_Id__c=String.valueof(p.Sub_PDK__r.Sub_PDK_OpenText_Id__c);
    temp.Sub_PDK_SF_Id__c=p.Sub_PDK__c;
    temp.Spec_OpenText_Id__c='';//String.valueof(p.design_spec__r.openText_id__c);
    temp.Spec_SF_Id__c=p.design_spec__c;
    temp.Sync_With_OpenText__c=false;
    temp.Sub_PDK_Spec_OtId__c =p.OTID__c; 
    
    lstLogs.add(temp);
}
try{
    insert lstLogs;

}catch(Exception e){}
}