/*
Author: Cognizant Technology Solutions
Company: 
Description:    DRT After update trigger
History:
    Cognizant     29052014     - Initial Version
*/ 
trigger MRS_SWIFT_AUPD on MRS__c (after update) 
{
    if(!IntegrationUserUtil.isSkipTrigger()){
    //Oracle DB Integration Sync related Code:Start        
    //Code for invoking first time sync of MRS child objects  (This code will be invoked by Integration user)
        set<id> setMRSIds = new set<id>();
        for(MRS__c rec :Trigger.new){
            if(rec.Synced_with_Oracle_DB__c && !trigger.oldmap.get(rec.id).Synced_with_Oracle_DB__c){
                setMRSIds.add(rec.id);
            }
            
            if(setMRSIds!=null && !setMRSIds.isEmpty()){
                
                MRSpackageSyncHandler.invokeMRSchldSync(setMRSIds);
            }
        }   
    //Oracle DB Integartion Sync related Code: End
    }  
}