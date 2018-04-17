/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: After Update Trigger on Prime DRT Layer Association object
History:
created     04/5/2014     
*/
trigger PRIME_DRT_Layer_Association_SWIFT_AUPD  on PRIME_DRT_Layer_Association__c (after update){
    if(!IntegrationUserUtil.isSkipTrigger()){
        Set<String> drtID = new Set<String>();
        for(PRIME_DRT_Layer_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).Synced_with_Oracle_DB__c==false && pdl.Synced_with_Oracle_DB__c)
                drtID.add(pdl.DRT__c);
            
        }
    if(!drtID.isEmpty()){
           SwiftUtility.checkDRTpackageSync(drtID); 
    }
    //Invocation of child record sync
    Set<String> setdrtID = new Set<String>();
        for(PRIME_DRT_Layer_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).created_at_Oracle_DB__c==false && pdl.created_at_Oracle_DB__c)
                setdrtID.add(pdl.DRT__c);
            
        }
    if(!setdrtID.isEmpty()){
           DRTpackageSyncHandler.syncDRTLayerChip(setdrtID); 
    }      
    }       
}