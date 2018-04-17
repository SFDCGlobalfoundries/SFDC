/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: After Update Trigger on Prime DRT Layer Chip object
History:
created     04/5/2014     
*/
trigger PRIME_DRT_Chip_Layer_Summary_SWIFT_AUPD  on PRIME_DRT_Chip_Layer_Summary__c (after update){
    static boolean recursiveControl =true;
    if(!IntegrationUserUtil.isSkipTrigger()){      
        if(recursiveControl){
        recursiveControl = false;
        Set<String> drtID = new Set<String>();
        for(PRIME_DRT_Chip_Layer_Summary__c pdl : Trigger.new){
            if( pdl.Synced_with_Oracle_DB__c && !trigger.Oldmap.get(pdl.id).Synced_with_Oracle_DB__c)
                drtID.add(pdl.DRT_ID__c);
            
        }
        
        if(drtID!=null){
            SwiftUtility.checkDRTpackageSync(drtID);
        }
        
        //Update DRT Sync with Oracle DB to false
        set<id> setDRTIds = new set<id>();
        for(PRIME_DRT_Chip_Layer_Summary__c lc :trigger.new){
            if(trigger.Oldmap.get(lc.id).Synced_with_Oracle_DB__c && !lc.Synced_with_Oracle_DB__c){
                setDRTIds.add(lc.drt_id__c);    
            }
        }
        list<DRT__c> lstDRT = new list<DRT__c>();
        if(!setDRTIds.isEmpty())
            lstDRT = [select id from DRT__c where id in :setDRTIds];
        if(lstDRT.size()>0){
            for(DRT__c drt: lstDRT){
                drt.Synced_with_Oracle_DB__c =false;
            }
            try{
            update lstDRT;
            }catch(exception e){
                system.debug('Error while updating DRT:'+e.getmessage());
            }
         
         }
        }
        set<string> setasyncFuture = new set<string>();
        profile p = [select id,name from profile where id=:userinfo.getProfileId()];
        if(p.name.tolowercase().indexof('integration')!=-1){
            for(PRIME_DRT_Chip_Layer_Summary__c lc :trigger.new){
                if(lc.Synced_with_Oracle_DB__c && !trigger.oldmap.get(lc.id).Synced_with_Oracle_DB__c)
                    setasyncFuture.add(lc.drt_id__c);
            }
            if(!setasyncFuture.isEmpty() && Limits.getlimitFuturecalls()>0){
                swiftutility.checkDRTpackageSyncFunc(setasyncFuture);
            }
        }
    }
}