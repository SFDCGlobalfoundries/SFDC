/*
Author: Cognizant
Company: Cognizant
Description: Before Insert Trigger on TECN
History:
created     10/6/2014     
*/
trigger MRS_TECN_SWIFT_BINS on TECN__c (Before Insert) {
 if(!IntegrationUserUtil.isSkipTrigger()){
map<string,datetime> mapTECNUpdatetime = new map<string,datetime>();
set<string> settecn = new set<string>();

    for(TECN__c tp :Trigger.new){
            mapTECNUpdatetime.put(tp.TECN_No__c,tp.update_Time__c);      
    }
    list<TECN__c> lstTECNdel = new list<TECN__c>();
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    
    if(!mapTECNUpdatetime.keyset().isEmpty() && profileName.tolowercase().indexof('integration')!=-1){  
    for(TECN__c tecn :[select TECN_No__c,update_time__c from TECN__c where TECN_No__c in :mapTECNUpdatetime.keyset()]){
        if(mapTECNUpdatetime.containskey(tecn.TECN_No__c) && mapTECNUpdatetime.get(tecn.TECN_No__c)>tecn.update_time__c){
            lstTECNdel.add(tecn);
        }
    }
    if(lstTECNdel.size()>0){
        delete lstTECNdel;
    }
    }
 }
}