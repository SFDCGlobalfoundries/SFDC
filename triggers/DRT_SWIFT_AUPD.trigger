/*
Author: Cognizant Technology Solutions
Company: 
Description:    DRT After update trigger
History:
    Cognizant     21032014     - Initial Version
*/ 
trigger DRT_SWIFT_AUPD on DRT__c (after update) 
{ 
    if(!IntegrationUserUtil.isSkipTrigger()){
    // ensure that activation emails are fired only once per update
    /*if(CheckRecursive.runOnce() || Test.isRunningTest()) {
        Set<String> setCustomerIds = new Set<String>();
        list<DRT__c> listActivatedDRT = new list<DRT__c>();
        for(DRT__c objDRT:trigger.new){
            if(objDRT.Status__c=='Active' && (Trigger.oldMap.get(objDRT.Id).Status__c == 'Draft')){        
                setCustomerIds.add(objDRT.Customer_Name__c);
                listActivatedDRT.add(objDRT);
            } 
        }        
        if(setCustomerIds!=null && setCustomerIds.size()>0){
            DRTHandlerUtility.sendMassEmailOnDRTActivation(listActivatedDRT,setCustomerIds);
        }
    }*/
    //Oracle DB Integration Sync related Code:Start        
    //Code for invoking first time sync of DRT child objects  (This code will be invoked by Integration user)
        set<id> setDRTIds = new set<id>();
        for(DRT__c rec :Trigger.new){
            if(rec.Synced_with_Oracle_DB__c && !trigger.oldmap.get(rec.id).Synced_with_Oracle_DB__c){
                setDRTIds.add(rec.id);
            }
            }
            
            if(setDRTIds!=null && !setDRTIds.isEmpty()){
                
                DRTpackageSyncHandler.invokeDRTchldSync(setDRTIds);
            }
        
    //Code for retrying Orcle DB sync for activated DRTs
    
    if(DRTpackageSyncHandler.brecursionCheck){
    set<id> setDRTs = new set<id>();
    for(DRT__c objDRT:trigger.new){
        if(objDRT.Status__c=='Active' && objDRT.First_Sync_with_Oracle__c != true && (Trigger.oldMap.get(objDRT.Id).Status__c != 'Active')){        
            setDRTs.add(objDRT.id);
        } 
    }
    if(setDRTs.size()>0){
        DRTpackageSyncHandler.reinvokeActivatedDRTsync(setDRTs);
    }
    DRTpackageSyncHandler.brecursionCheck = false;
    } 
    
           
    //Oracle DB Integartion Sync related Code: End
 }
}