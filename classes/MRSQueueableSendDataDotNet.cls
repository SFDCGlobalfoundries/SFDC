/*
SWGP-982: [MRS ws to PTRF] Send Prime/Frame is failed to triggered

High level logic
- 1 static class to hold all layer chip record which is extracted (1) from after update trigger
(1): only those that have Send_Prime_Data__c / Send_Prime_Data__c changed from Not Done to Done
OR Layer_Chip_Status__c changed from any to Cancel/Void

- edit MRS_Layer_Chip_Association_SWIFT_AUPD to catch value change
> invoke queueable MRSQueueableSendDataDotNet to submit a job that will send signal to .net by updating All_Send_Prime_Done__c / All_Send_Frame_Done__c
==============
need a static class to hold all layer chip record resulted from after update trigger which has send data prime/frame to Done OR layer chip status change to Cancel/Void
=======
This class is used to calculate Send_Prime_Data__c / Send_Prime_Data__c of all layer chip under a PTRF is completed.

Concern:
- Race condition when 2 same send data update different chip of same ptrf at the same time,
either of those transaction will get not-done send data value thus there is no send data complete
although after 2 transaction are completed, send data is actually completed.

NEED TO TEST SOQL ACTUALLY GETS NEW VALUE IN AFTER UPDATE TRIGGER???

OR MAYBE: lstLayerChip contains only Send Data done (cancel/void consider done as well) 
>>> (1) query layer chip that not in lstLayerChip which has layer status != cancel/void and send data is not Done
>>> if (1) is empty >>> trigger signal to ptrf for closure
*/
public class MRSQueueableSendDataDotNet implements Queueable {
    
    //lstLayerChip will hold list of layer chip which has value change in:
    // - send data prime/frame to Done
    // - OR layer chip status change to Cancel/Void
    private list<mrs_layer_chip_association__c> lstLayerChip;
    public MRSQueueableSendDataDotNet(list<mrs_layer_chip_association__c> lstLayerChip) {
        //lstLayerChip is passed-in from MRS_Layer_Chip_Association_SWIFT_AUPD trigger
        this.lstLayerChip = lstLayerChip;
    }
    
    public void execute(QueueableContext context) {
        
        //extract lstLayerChip into (AA)map<key,layer_chip>: key is ptrf_id + prime/frame
        //also extract ptrf_id into ptrfSet for query filter in execute (3)
        map<String, mrs_layer_chip_association__c> mapUniqueChip = new map<String, mrs_layer_chip_association__c>();
        set<id> ptrfIdSet = new set<id>();
        set<id> lchipIdSet = new set<id>();
        for(mrs_layer_chip_association__c m: lstLayerChip) {
            String framePrime = m.send_prime_data__c != 'N.A.' ? 'prime' : 'frame';
            String key = String.valueOf(m.ptrf__c+framePrime);
            mapUniqueChip.put(key, m);//(AA)
            ptrfIdSet.add(m.ptrf__c);//(3)
        }
        
        //(2) execute logic:
        //query layer chip (B) which: not in lstLayerChip
        //                            ptrf__c in ptrfSet(3)
        //                            layer chip status != cancel/void
        //                            [(send_prime != Done and send_prime != N.A.) OR (send_frame != Done and send_frame != N.A.)]
        list<mrs_layer_chip_association__c> listNotCompleteChip = [
            select id,send_prime_data__c,send_frame_data__c,ptrf__c
            from mrs_layer_chip_association__c
            where id not in :lchipIdSet//those in lstLayerChip are completed send data already >>> no need to query them
                and ptrf__c in :ptrfIdSet
                and layer_chip_status__c != 'Cancel' and layer_chip_status__c != 'Void'
                and (Send_Frame_Data__c = 'Not Done' OR Send_Prime_Data__c = 'Not Done')
        ];
        
        //if(listNotCompleteChip.isEmpty()) return;
        
        //loop list (B) > extract (CC)map<key,layer_chip>: key is ptrf_id + prime/frame
        //
        map<String, mrs_layer_chip_association__c> mapNotCompleteChip = new map<String, mrs_layer_chip_association__c>();
        for(mrs_layer_chip_association__c m: listNotCompleteChip) {
            String framePrime = m.send_prime_data__c != 'N.A.' ? 'prime' : 'frame';
            String key = String.valueOf(m.ptrf__c+framePrime);
            mapNotCompleteChip.put(key,m);//(CC)
        }
        
        //loop keySet map(AA) > if map(CC) contains key_of_AA > map(AA).remove(looped_key)
        //
        //map(AA) after removed(looped_key) > loop map(AA) and set All_Send_Prime_Done__c / All_Send_Frame_Done__c accordingly
        list<mrs_layer_chip_association__c> lstChipToUpdate = new list<mrs_layer_chip_association__c>();
        for(String s: mapUniqueChip.keySet()) {
            if(mapNotCompleteChip.containsKey(s)) mapUniqueChip.remove(s);
            else {
                mrs_layer_chip_association__c temp = new mrs_layer_chip_association__c(id = mapUniqueChip.get(s).id);
                if(s.containsIgnoreCase('prime')) { 
                    temp.Trigger_Oracle_DB_SendPrimeSync_Manual__c = true;
                    if(mapUniqueChip.get(s).send_prime_data__c == 'Not Done') temp.send_prime_data__c = 'Done';//SWGP-1175
                } else { 
                    temp.Trigger_Oracle_DB_SendFrameSync_Manual__c = true;
                    if(mapUniqueChip.get(s).send_frame_data__c == 'Not Done') temp.send_frame_data__c = 'Done';//SWGP-1175
                }
                lstChipToUpdate.add(temp);
            }
        }
        
        if(!lstChipToUpdate.isEmpty()) update lstChipToUpdate;
    }
}