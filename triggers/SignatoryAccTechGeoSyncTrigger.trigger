/*
Type Name: SignatoryAccTechGeoSyncTrigger 
Author: Cognizant
Created Date: 30-August-2013
Reason: This trigger is used syncing NDA related Tech Geometries at account level. 
Change History:
Author: 
Modified Date:
Reason: 
……..
……..
*/
trigger SignatoryAccTechGeoSyncTrigger on Signatory__c (After Insert, After Delete) {
if(Trigger.isInsert && Trigger.isAfter){
set<id> setAgrIds=new set<id>();
map<id,string> mapAgrTechGeos=new map<id,string>();
map<id,string> mapAccTechGeos=new map<id,string>();
list<Signatory__c> lstsgntry=new list<Signatory__c>();

for(Signatory__c sg:Trigger.New){
    if(sg.status__c=='Activated'){
        setAgrIds.add(sg.Agreement__c); 
        lstsgntry.add(sg);   
    }    
}
for(Apttus__APTS_Agreement__c agr:[select id, geometries__c from Apttus__APTS_Agreement__c where id in :setAgrIds AND GF_Contract_Start_Date__c<=today and GF_Contract_End_Date__c>=today ]){
    mapAgrTechGeos.put(agr.id,agr.geometries__c);    
}


for(Signatory__c sg:lstsgntry){
    if(mapAccTechGeos!=null && !mapAccTechGeos.containskey(sg.account__c)){
        mapAccTechGeos.put(sg.account__c,mapAgrTechGeos.get(sg.Agreement__c));
    }
    else if(mapAccTechGeos!=null && mapAccTechGeos.containskey(sg.account__c)){
        string temp= mapAccTechGeos.get(sg.account__c)+';'+mapAgrTechGeos.get(sg.Agreement__c);
         mapAccTechGeos.put(sg.account__c,temp);
    }           
}
        
if(mapAccTechGeos!=null){
    AgreementAccountSyncUtility obj=new AgreementAccountSyncUtility();
    obj.setValidAccountTechGeos(mapAccTechGeos);
}
}
if(Trigger.isDelete  && Trigger.isAfter){
    set<id> accids=new set<id>();
    system.debug('***inside delete block');
    for(Signatory__c sg:Trigger.old){
        if(sg.status__c=='Activated'){
            accids.add(sg.account__c);  
            system.debug('***inside IF block');  
        }
    }
    
    if(!accids.isEmpty()){
        AgreementAccountSyncUtility obj=new AgreementAccountSyncUtility();
        obj.syncAccountTechGeos(accids);
    }
}

}