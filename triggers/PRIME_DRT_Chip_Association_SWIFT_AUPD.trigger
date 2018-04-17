/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: After Update Trigger on Prime DRT Chip object
History:
created     04/5/2014     
*/
trigger PRIME_DRT_Chip_Association_SWIFT_AUPD  on PRIME_DRT_Chip_Association__c (after update){
    if(!IntegrationUserUtil.isSkipTrigger()){
      Set<string> drtID = new Set<string>();
        for(PRIME_DRT_Chip_Association__c pdl : Trigger.new){
            if( pdl.Synced_with_Oracle_DB__c)
                drtID.add(pdl.DRT__c);
            
        }
        
        if(!drtID.isEmpty()){
            SwiftUtility.checkDRTpackageSync(drtID);
        }   
        //Child record invokation at first time sync
        Set<string> setdrtID = new Set<string>();
        for(PRIME_DRT_Chip_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).created_at_Oracle_DB__c==false && pdl.created_at_Oracle_DB__c)
                setdrtID.add(pdl.DRT__c);
            
        }
        
        if(!setdrtID.isEmpty()){
            DRTpackageSyncHandler.syncDRTLayerChip(setdrtID);
        }
    }
}