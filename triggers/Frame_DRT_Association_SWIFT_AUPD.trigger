/*
Author: Cognizant Technology Solutions
Company: 
Description:    trigger for Frame DRT Association After Update
History:
    Cognizant     21032014     - Initial Version
*/ 
trigger Frame_DRT_Association_SWIFT_AUPD  on Frame_DRT_Association__c (after update){
    Set<String> drtID = new Set<String>();
        for(Frame_DRT_Association__c pdl : Trigger.new){
            if(Trigger.oldMap.get(pdl.id).Synced_with_Oracle_DB__c==false && pdl.Synced_with_Oracle_DB__c)
                drtID.add(pdl.DRT__c);
            
        }
        
        if(drtID!=null){
            SwiftUtility.checkDRTpackageSync(drtID);
            
        }
        //TASK-2356: Calling Future method for DRT Package Sync Check in order to handle Concurrent update scenarios where Frame DRT Association and  PTRF DRT Association records are updated concurrently  
         set<string> setasyncFuture = new set<string>();
         profile p = [select id,name from profile where id=:userinfo.getProfileId()];
         if(p.name.tolowercase().indexof('integration')!=-1){
             for(Frame_DRT_Association__c fd :trigger.new){
                 if(fd.Synced_with_Oracle_DB__c && !trigger.oldmap.get(fd.id).Synced_with_Oracle_DB__c)
                     setasyncFuture.add(fd.drt__c);
             }
             if(!setasyncFuture.isEmpty() && Limits.getlimitFuturecalls()>0){
                 swiftutility.checkDRTpackageSyncFunc(setasyncFuture);
             }
         }
}