/*Type Name: Chip_Detail_SWIFT_AUPD 
Author: Cognizant 
Created Date: 31-March-2014

……..
……..
 */
 
 
trigger Chip_Detail_SWIFT_AUPD on Chip_Detail__c (after update) {

    /*
    Set<String> setPTRFIds = new Set<String>();
    Set<String> setChipNames = new Set<String>();
     
    for(Chip_Detail__c objCD:trigger.new){
        if(!objCD.Tapeout__c && Trigger.oldMap.get(objCD.Id).Tapeout__c){
            setPTRFIds.add(objCD.PTRF__c); 
            setChipNames.add(objCD.Name);
        }   
    }
    
    if(setPTRFIds.size()>0 && setChipNames.size()>0){
        //MRSHandlerUtility.deselectChipInPTRF(setPTRFIds,setChipNames);
    }
    */
}