/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: sfdc - .net Integration Webservice
History:
created     19/5/2014     
*/
public class DRTpackageSyncHandler{
public static boolean brecursionCheck = true;
//Method to invoke sync of DRT child objects
public static void invokeDRTchldSync(set<id> drtIds){
set<string> idSet = new set<string>();
try
{
list<DRT_PTRF_Association__c> lstDRTptrf = new list<DRT_PTRF_Association__c>([select id from DRT_PTRF_Association__c where drt__c in :drtIds]);
list<Frame_DRT_Association__c> lstDRTFrameLayer = new list<Frame_DRT_Association__c>([select id from Frame_DRT_Association__c where drt__c in :drtIds]);
list<PRIME_DRT_Chip_Association__c>lstDRTChip =  new list<PRIME_DRT_Chip_Association__c>([select id from PRIME_DRT_Chip_Association__c where drt__c in :drtIds and IsSoftDeleted__c = False]);
list<PRIME_DRT_Layer_Association__c> lstDRTlayer = new list<PRIME_DRT_Layer_Association__c>([select id from PRIME_DRT_Layer_Association__c where drt__c in :drtIds and IsSoftDeleted__c = False]);

    if(lstDRTptrf .size()>0){
        idSet = new set<string>();
        for(DRT_PTRF_Association__c rec :lstDRTptrf){
            rec.First_Sync_with_Oracle__c=true;
            idSet.add(rec.id);
        }
        update lstDRTptrf;

    }

    if(lstDRTFrameLayer.size()>0){
        idSet = new set<string>();
        for(Frame_DRT_Association__c rec :lstDRTFrameLayer){
            rec.First_Sync_with_Oracle__c=true;
            idSet.add(rec.id);
        }
        update lstDRTFrameLayer;
    }
    if(lstDRTChip.size()>0){
        idSet = new set<string>();
        for(PRIME_DRT_Chip_Association__c rec :lstDRTChip){
            rec.First_Sync_with_Oracle__c=true;
            idSet.add(rec.id);
        }
        update lstDRTChip;
    }

    if(lstDRTlayer.size()>0){
        idSet = new set<string>();
        for(PRIME_DRT_Layer_Association__c rec :lstDRTlayer){
            rec.First_Sync_with_Oracle__c=true;
            idSet.add(rec.id);
        }
        update lstDRTlayer;
    }
   }
   catch(exception e)
   {
   List<String> idList = new List<String>(idSet);
   DRTHandlerUtility.handleErrorOnSyncDRTPackageSync(e,idList,'Exception on DRT Package Sync');
   }
}

//Method to invoke sync of DRT Layer Chip object records
public static void syncDRTLayerChip(set<string> DRTIds){
list<PRIME_DRT_Chip_Association__c> lstDRTChip = new list<PRIME_DRT_Chip_Association__c>();
list<PRIME_DRT_Layer_Association__c> lstDRTlayer = new list<PRIME_DRT_Layer_Association__c>(); 
list<PRIME_DRT_Chip_Layer_Summary__c> lstlayerChip = new list<PRIME_DRT_Chip_Layer_Summary__c>();
set<id> setDTRchip = new set<id>();
set<id> setDTRlayer = new set<id>();
set<id> setupdateDRT = new set<id>();
set<string> idSet = new set<string>();
try
{
lstDRTChip = [select id,drt__c from PRIME_DRT_Chip_Association__c where created_at_Oracle_DB__c=false and IsSoftDeleted__c = False and drt__c in :DRTIds];
lstDRTlayer = [select id,drt__c from PRIME_DRT_Layer_Association__c where created_at_Oracle_DB__c=false and IsSoftDeleted__c = False and drt__c in :DRTIds];
set<string> setDTRlayeroutofsync = new set<string>();
//
//

if(lstDRTChip!=null && lstDRTChip.size()>0){
idSet = new set<string>();
    for(PRIME_DRT_Chip_Association__c chip :lstDRTChip){
        setDTRchip.add(chip.drt__c);
        //
        idSet.add(chip.id);
    }
}

if(lstDRTlayer!=null && lstDRTlayer.size()>0){
idSet = new set<string>();
    for(PRIME_DRT_Layer_Association__c layer :lstDRTlayer){
        setDTRlayer.add(layer.drt__c);
        //
        idSet.add(layer.id);
    }
}
list<string> lstIds = new list<string>(); 
lstIds.addALl(DRTIds);
for(id drtid :lstIds){
    if(setDTRchip!=null && !setDTRchip.isEmpty()){
       if(setDTRchip.contains(drtid))
           setDTRlayeroutofsync.add(drtid);
    } 
    if(setDTRlayer!=null && !setDTRlayer.isEmpty()){
       if(setDTRlayer.contains(drtid)) 
           setDTRlayeroutofsync.add(drtid);
        }    
    if(setDTRlayeroutofsync.isEmpty() || (!setDTRlayeroutofsync.isEmpty() && !setDTRlayeroutofsync.contains(drtid)))
        setupdateDRT.add(drtid); 
        
}
//

if(setupdateDRT!=null && !setupdateDRT.isEmpty()){
 lstlayerChip=[select id,IsSoftDeleted__c from PRIME_DRT_Chip_Layer_Summary__c where Chip__r.DRT__c in :setupdateDRT and Chip__r.IsSoftDeleted__c = False and Layer__r.IsSoftDeleted__c = False and Chip__r.DRT__c NOT in :setDTRlayeroutofsync];  
 //
 if(lstlayerChip!=null && lstlayerChip.size()>0){
     for(PRIME_DRT_Chip_Layer_Summary__c lc :lstlayerChip){
         lc.First_Sync_with_Oracle__c = true;    
         // 
     }
     //
     update lstlayerChip;
 }
 }
 }
 catch(Exception e)
 {
 List<String> idList = new List<String>(idSet);
 DRTHandlerUtility.handleErrorOnSyncDRTPackageSync(e,idList,'Exception on DRT Package Sync');
 }  

}

//Method to re-invoke DRT Sync for newly activated DRTs
public static void reinvokeActivatedDRTsync(set<id> drtIds){
if(system.isFuture() || system.isBatch()){
    reinvokeActivatedDRTsyncnonFuture(drtIds);
}
else{
    if(Limits.getLimitFutureCalls()>0){
        reinvokeActivatedDRTsyncFuture(drtIds);
    }
}
}

@Future
public static void reinvokeActivatedDRTsyncFuture(set<id> drtIds){
    reinvokeActivatedDRTsyncnonFuture(drtIds);
}

public static void reinvokeActivatedDRTsyncnonFuture(set<id> drtIds){
list<drt__c> lstDRT =new list<DRT__c>();
for(DRT__c drt :[select id from DRT__c where id in :drtIds and First_Sync_with_Oracle__c!=true and status__c='Active']){
    drt.Trigger_Oracle_DB_Sync_Manual__c=TRUE;
    lstDRT.add(drt);
}
if(lstDRT.size()>0){
try{
    update lstDRT;
}catch(exception e){}
}
}


}