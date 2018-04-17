trigger MRS_Layer_Chip_SWIFT_AUPD on MRS_Layer_Chip_Association__c (after update) {
    //static boolean recursiveControl =true;
    if(!IntegrationUserUtil.isSkipTrigger()){
     //if(recursiveControl){
      if(checkRecursive.runOnce()||Test.isRunningTest()){
        //recursiveControl = false;
        Set<String> MRSId = new Set<String>();
        for(MRS_Layer_Chip_Association__c layerChip :Trigger.New){
            if(Trigger.oldMap.get(layerChip.Id).Synced_with_Oracle_DB__c ==false && layerChip.Synced_with_Oracle_DB__c){
                MRSId.add(layerChip.Layer__r.MRS__c);
                }
            }
        //call the method checkMRSpackageSync
            if(MRSId != null){
                MRSSwiftUtility.checkMRSpackageSync(MRSId);
             }
        
          
        //Update DRT Sync with Oracle DB to false
        set<id> setDRTIds = new set<id>();
        for(MRS_Layer_Chip_Association__c lc :trigger.new){
            if(trigger.Oldmap.get(lc.id).Synced_with_Oracle_DB__c && !lc.Synced_with_Oracle_DB__c){
                setDRTIds.add(lc.mrs_id__c);    
            }
        }
        list<MRS__c> lstDRT = new list<MRS__c>();
        if(!setDRTIds.isEmpty())
            lstDRT = [select id from MRS__c where id in :setDRTIds];
        if(lstDRT.size()>0){
            for(MRS__c drt: lstDRT){
                drt.Synced_with_Oracle_DB__c =false;
            }
            try{
            update lstDRT;
            }catch(exception e){
                system.debug('Error while updating MRS:'+e.getmessage());
            }
         
         }
       //************
         Set<String> setMRSID = new Set<String>();
         for(MRS_Layer_Chip_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).created_at_Oracle_DB__c==false && pdl.created_at_Oracle_DB__c)
                setMRSID.add(pdl.MRS_ID__c);
            
            }
          if(!setMRSID.isEmpty()){
           MRSpackageSyncHandler.syncMRSNotes(setMRSID); 
          }
       //*********
        set<string> setasyncFuture = new set<string>();
        profile p = [select id,name from profile where id=:userinfo.getProfileId()];
        if(p.name.tolowercase().indexof('integration')!=-1){
            for(MRS_Layer_Chip_Association__c lc :trigger.new){
                if(lc.Synced_with_Oracle_DB__c && !trigger.oldmap.get(lc.id).Synced_with_Oracle_DB__c)
                    setasyncFuture.add(lc.mrs_id__c);
            }
            if(!setasyncFuture.isEmpty() && Limits.getlimitFuturecalls()>0){
                swiftutility.checkMRSpackageSyncFunc(setasyncFuture);
            }
        }
      }   
    }
}