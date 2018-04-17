/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: Before Update Trigger on DRT
History:
created     05/13/2014 

- Update 15-June-2016: SWIFT optimized, reduced query rows by adding filter into query (!?!?)    
*/
trigger DRT_SWIFT_BUPD on DRT__c (before update) {
    
    if(!IntegrationUserUtil.isSkipTrigger()) {
        
        set<id> setDRTPackagentSync = new set<id>(); 
        
        for(PRIME_DRT_Layer_Association__c dLayer : [select Synced_with_Oracle_DB__c,drt__c from PRIME_DRT_Layer_Association__c where DRT__c in :trigger.newmap.keyset() and IsSoftDeleted__c = False and Synced_with_Oracle_DB__c = false]){  
            setDRTPackagentSync.add(dLayer.drt__c);
        }
        
        for(PRIME_DRT_Chip_Association__c dChip :[select drt__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Association__c where drt__c in :trigger.newmap.keyset() and IsSoftDeleted__c = False and Synced_with_Oracle_DB__c = false]){
            setDRTPackagentSync.add(dChip.drt__c);
        }
        
        for(PRIME_DRT_Chip_Layer_Summary__c dChipLayer : [select drt_ID__c,Layer__r.IsSoftDeleted__c,Chip__r.IsSoftDeleted__c,Synced_with_Oracle_DB__c from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.DRT__c in :trigger.newmap.keyset() and Layer__r.IsSoftDeleted__c = False and Chip__r.IsSoftDeleted__c = False and Synced_with_Oracle_DB__c = false]){
            setDRTPackagentSync.add(dChipLayer.drt_ID__c);          
        }
          
        for(DRT_PTRF_Association__c dPTRF : [select drt__c,Synced_with_Oracle_DB__c from DRT_PTRF_Association__c where DRT__c in :trigger.newmap.keyset() and Synced_with_Oracle_DB__c = false]){
            setDRTPackagentSync.add(dptrf.drt__c);
        }
  
        for(Frame_DRT_Association__c dFrame : [select drt__c,Synced_with_Oracle_DB__c from Frame_DRT_Association__c where DRT__c in :trigger.newmap.keyset() and Synced_with_Oracle_DB__c = false]){
            setDRTPackagentSync.add(dframe.drt__c);
        }
  
        for(drt__c drt:Trigger.new) {
            
            if((setDRTPackagentSync.isEmpty() || !setDRTPackagentSync.contains(drt.id)) && drt.Synced_with_Oracle_DB__c) {
                
                drt.DRT_Package_Sync__c = TRUE;
                if(drt.Old_Rev_DRT__c!=null && drt.Sync_DRT_Rev_dot_NET__c == FALSE) drt.Trigger_Revised_DRT_Sync__c = TRUE;
            }
             
            if(drt.Synced_with_Oracle_DB__c && !drt.First_Sync_with_Oracle__c) drt.First_Sync_with_Oracle__c = TRUE;
        }
    } 
}