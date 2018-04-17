trigger SignatoryAfterUpdateTrigger on Signatory__c (after insert, after update) {

List<String> ids = new List<String>();
List<String> armntIds = new List<String>();

List<Apttus__APTS_Agreement__c > armntList = new List<Apttus__APTS_Agreement__c >(); 
Map <String,Schema.RecordTypeInfo> SigrecordTypes = Signatory__c.sObjectType.getDescribe().getRecordTypeInfosByName();
Id NDA_Agreement_SignatoryId = SigrecordTypes.get(System.Label.NDA_Non_Tagging_Rec_Type).getRecordTypeId(); 
RecordType recordType = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where Id = :NDA_Agreement_SignatoryId ];
 
//POPULATE LIST 
for(Signatory__c sig : Trigger.NEW){
    if(sig.RecordTypeId == NDA_Agreement_SignatoryId){
    ids.add(sig.Id);armntIds.add(sig.Agreement__c);
 }   
}

//GRAB signatory INFORMATION
List<Apttus__APTS_Agreement__c> full = [select id, UpdatedSignatory__c,Apttus__Status__c
from Apttus__APTS_Agreement__c where id in :armntIds];

system.debug('Agreement lsit' + full);

Apttus__APTS_Agreement__c ag = new Apttus__APTS_Agreement__c();

    for(Apttus__APTS_Agreement__c agreement: full ){
        if(agreement.Apttus__Status__c == 'Activated'){
        ag.Id = agreement.Id;ag.UpdatedSignatory__c = 'Signatory Update'; 
        armntList.add(ag); 
        }
        
    System.debug('agreement update list' +armntList); }

if(armntList.size() > 0 || armntList != null){ update armntList;}
 
}