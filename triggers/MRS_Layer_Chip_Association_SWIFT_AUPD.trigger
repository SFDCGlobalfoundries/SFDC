/*
Test is covered in TECNHandlerUtilityTest
- SWGp-982 portion is covered by MRSQueueableSendDataDotNetTest
 */
trigger MRS_Layer_Chip_Association_SWIFT_AUPD on MRS_Layer_Chip_Association__c (After Update) {
    
    set<id> voidLayerChipSet = new set<id>();
    set<id> layerSet = new set<id>();
    set<id> lcidSet = new set<id>();//swgp-998: this set will be used to reset syncing flag
    
    list<mrs_layer_chip_association__c> lstLayerChip = new list<mrs_layer_chip_association__c>();//swgp-982

    for(MRS_Layer_Chip_Association__c m: trigger.new) {
        
        boolean isStatusChange = trigger.oldMap.get(m.id).layer_chip_status__c != m.layer_chip_status__c ? true : false;
        
        //SWGP-134
        //when a layer chip is void
        //(A) >>> check for other layer chip of SAME PTRF and SAME LAYER (maybe query by layer unique: mst + layer num + layer rev + tech geo + (rom_code if have))
        //if ther are none (A) >>> proceed to lift tecn
        if(isStatusChange && m.layer_chip_status__c == 'Void') {
            voidLayerChipSet.add(m.id);
            layerSet.add(m.layer__c);
        }//SWGP-134-END
        
        //swgp-998
        DateTime t1 = m.Trigger_MSIH_Sync_Manual_for_Shadow__c;
        DateTime t2 = trigger.oldMap.get(m.Id).Trigger_MSIH_Sync_Manual_for_Shadow__c;
        if(null != t1 && t1 != t2) lcidSet.add(m.Id); 
        //swgp-998-END
        
        //swgp-982
        boolean isCancelVoid = 'Void;Cancel'.containsIgnoreCase(m.layer_chip_status__c) ? true : false;
        if(isStatusChange && isCancelVoid) {
            lstLayerChip.add(m);
        } else {
            if(trigger.oldMap.get(m.id).send_prime_data__c != 'Done' && m.send_prime_data__c == 'Done') {
                lstLayerChip.add(m);
            } else if(trigger.oldMap.get(m.id).send_frame_data__c != 'Done' && m.send_frame_data__c == 'Done') {
                lstLayerChip.add(m);
            }
        }
        //swgp-982-end
    }
    
    //swgp-998
    //from set_a >>> query MRS_Layer_Chip_Syncing_Status__c >>> set sync flag to FALSE
    MRSHandlerUtilityExtn.resetSyncingFlagChip(lcidSet);
    //swgp-998-END

    if(!voidLayerChipSet.isEmpty()) TECNHandlerUtility.liftOffUnUsedTECN_fromVoidLayerChip_future(voidLayerChipSet, layerSet);
    
    //swgp-982
    if(!lstLayerChip.isEmpty() && MRSCheckRecursive.isFirstRun()) {
        MRSQueueableSendDataDotNet queueJob = new MRSQueueableSendDataDotNet(lstLayerChip);
        System.enqueueJob(queueJob);
    }
    //swgp-982-end
}