trigger MaskWIP_SWIFT_BINS on Mask_WIP__c (Before Insert) {
set<string> setMST = new set<string>();
map<string,string> mapMST = new map<string,string>();
for(Mask_WIP__c mw :Trigger.New){
    setMST.add(mw.Mask_Set_Title_Text__c);
}
if(!setMST.isEmpty()){
    for(Mask_Set_Title__c mst :[select id,name from Mask_Set_Title__c where name in :setMST and status__c='Active']){
        mapMST.put(mst.Name,mst.Id);
    }
}
if(mapMST.keyset()!=null && !mapMST.keySet().isEmpty()){
    for(Mask_WIP__c mw :Trigger.New){
        if(mapMST.containskey(mw.Mask_Set_Title_Text__c)){
            mw.Mask_Set_Title__c = mapMST.get(mw.Mask_Set_Title_Text__c);
        }
    }
}
}