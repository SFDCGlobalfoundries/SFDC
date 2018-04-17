/*
If a layer is deselected >>> check and lift off tecn in MRS Layer if needed
*/
trigger Mask_Layer_SWIFT_AUPD on Mask_Layer__c (after update) {
    
    set<id> maskLayerIdSet = new set<id>();
    
    for(Mask_Layer__c m: trigger.new) {
        //swgp-134
        if(!m.tapeout__c && trigger.oldMap.get(m.Id).tapeout__c == true && m.LogicalOperationType__c == 'TECN') maskLayerIdSet.add(m.id);
    }
    
    //swgp-134
    if(!maskLayerIdSet.isEmpty()) TECNHandlerUtility.liftOffUnUsedTECN_future(maskLayerIdSet, null);
}