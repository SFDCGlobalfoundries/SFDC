/*
Type Name: PackageSpecDeleteLogTrigger Trigger
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
trigger PackageSpecDeleteLogTrigger on Package_Spec__c (Before Delete) {
list<Document_Provisioning_Log__c> lstLogs=new list<Document_Provisioning_Log__c>();
for(Package_Spec__c p:[select Package__c,Package__r.OpenText_Id__c, design_spec__c,design_spec__r.openText_id__c from package_spec__c where id in: trigger.oldmap.keyset()]){
    Document_Provisioning_Log__c temp=new Document_Provisioning_Log__c();
    temp.entity__c='Package Spec';
    temp.Package_OpenText_Id__c=string.valueof(p.Package__r.OpenText_Id__c);
    temp.Package_SF_Id__c=p.Package__c;
    temp.Spec_OpenText_Id__c=string.valueof(p.design_spec__r.openText_id__c);
    temp.Spec_SF_Id__c=p.design_spec__c;
    temp.Sync_With_OpenText__c=false;
    
    lstLogs.add(temp);
}
try{
    insert lstLogs;

}catch(Exception e){}
}