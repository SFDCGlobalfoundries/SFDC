/*
Author: Cognizant
Company: Cognizant Tech Solutions
Description: After Update Trigger on MRS Layer Association
History:
created     24/5/2014     

Test class:
MRSCADLGServiceTest

MRSSwiftUtilityTest
*/
trigger MRS_Layer_Association_SWIFT_AUPD on MRS_Layer_Association__c (after update) {
        
        /** Code for functional development (outside !IntegrationUserUtil.isSkipTrigger()) Start**/
        set<String> setShippedLayerIds = new set<String>();
        set<id> setLayerIds = new set<id>();
        set<String> MRSId = new set<String>();
        set<String> setdrtID = new set<String>();
        set<MRS_Layer_Association__c> mrsLayerAssolst = new set<MRS_Layer_Association__c>();
        map<String,MRS_Layer_Association__c> mapReleasedLayerIds = new map<String,MRS_Layer_Association__c>(); 
        //TASK-1989
        map<String,MRS_Layer_Association__c> mapReleasedOldHeldLayerIds = new map<String,MRS_Layer_Association__c>();
        //TASK-1989

        set<id> lidSet = new set<id>();//swgp-998: this set will be used to reset syncing flag

        for(MRS_Layer_Association__c layer :Trigger.new){
            
            //swgp-998
            DateTime t1 = layer.Trigger_MSIH_Sync_Manual_for_Shadow__c;
            DateTime t2 = trigger.oldMap.get(layer.Id).Trigger_MSIH_Sync_Manual_for_Shadow__c;
            
            if(null != t1 && t1 != t2) {
                //extract layer id to set_a
                lidSet.add(layer.Id);
            }
            //swgp-998-END
            
            
             if(Trigger.oldmap.get(layer.id).Layer_Status__c !='Pending Foundry Release' && Trigger.newmap.get(layer.id).Layer_Status__c =='Pending Foundry Release' && (layer.Last_Sync_Request_Timestamp__c==Trigger.oldmap.get(layer.id).Last_Sync_Request_Timestamp__c) && (layer.Layer_Old_Status__c==Trigger.oldmap.get(layer.id).Layer_Old_Status__c)){ mrsLayerAssolst.add(layer); }
                
            //TASK-1989
            if((layer.Layer_Status__c!=Trigger.oldmap.get(layer.id).Layer_Status__c) 
            && (layer.Layer_Status__c == 'Released')  
            && (layer.Last_Sync_Request_Timestamp__c==Trigger.oldmap.get(layer.id).Last_Sync_Request_Timestamp__c) 
            && (layer.Layer_Old_Status__c==Trigger.oldmap.get(layer.id).Layer_Old_Status__c)){ 
                if(Trigger.oldmap.get(layer.id).Layer_Status__c!=null && Trigger.oldmap.get(layer.id).Layer_Status__c!='Hold'){ 
                    mapReleasedLayerIds.put(layer.id,layer);  
                }else{ 
                    mapReleasedOldHeldLayerIds.put(layer.id,layer); 
                } 
            }
            //TASK-1989
             
             if(layer.Layer_Status__c!=Trigger.oldmap.get(layer.id).Layer_Status__c && (layer.Layer_Status__c == 'Released' || layer.Layer_Status__c == 'Hold' || layer.Layer_Status__c == 'Void' || layer.Layer_Status__c == 'Shipped')){
                 setLayerIds.add(layer.id);
             }
             if(Trigger.oldMap.get(layer.Id).Synced_with_Oracle_DB__c ==false && layer.Synced_with_Oracle_DB__c){ MRSId.add(layer.MRS__c); }
             if(Trigger.oldMap.get(layer.id).created_at_Oracle_DB__c==false && layer.created_at_Oracle_DB__c){ setdrtID.add(layer.MRS__c); }
        }
        
        //swgp-998
        //from set_a >>> query MRS_Layer_Chip_Syncing_Status__c >>> set sync flag to FALSE
        MRSHandlerUtilityExtn.resetSyncingFlagLayer(lidSet);
        //swgp-998-END
        
        //TASK-1989
        if(mapReleasedOldHeldLayerIds.size()>0){
            set<String> setLayerIdsHoldAndReleased = new set<String>();
            for(MRS_Layer_Association__History MRSLHis:[select Field,NewValue,OldValue,ParentId,CreatedDate FROM MRS_Layer_Association__History 
            where ParentId IN:mapReleasedOldHeldLayerIds.keySet() and Field='Layer_Status__c' ORDER BY CreatedDate DESC]){              
                if(!setLayerIdsHoldAndReleased.contains(MRSLHis.ParentId)){
                    if(MRSLHis.NewValue=='Hold'){
                        setLayerIdsHoldAndReleased.add(MRSLHis.ParentId);                   
                        if(MRSLHis.OldValue!='Released'){
                            mapReleasedLayerIds.put(MRSLHis.ParentId,mapReleasedOldHeldLayerIds.get(MRSLHis.ParentId)); 
                        }
                    }  
                }                                           
            }
        }
        //TASK-1989
        //TASK-1983
        list<String> listLayerIds = new list<String>();
        list<MRS_Layer_Association__c> listLayersSorted = new list<MRS_Layer_Association__c>();   
        if(mapReleasedLayerIds.size()>0){
            set<String> setPTRFIds = new set<String>();                 
            for(MRS_Layer_Chip_Association__c layerChip:[select Id, PTRF__c, Layer__c from MRS_Layer_Chip_Association__c where Layer__c IN:mapReleasedLayerIds.keySet() and PTRF__c!=null]){
                setPTRFIds.add(layerChip.PTRF__c);          
            }
            if(setPTRFIds.size()>0){ listLayersSorted.addAll(MRSHandlerUtility.sortMaskLayer(setPTRFIds,mapReleasedLayerIds.values())); }
            if(listLayersSorted.size()>0){ for(MRS_Layer_Association__c layer:listLayersSorted){ listLayerIds.add(layer.Id); } }
        }
        //TASK-1983
        
        if(mapReleasedLayerIds!=null && !mapReleasedLayerIds.isEmpty()){
            try{ MRSHandlerUtility.sendEmailOnReleasedLayers(mapReleasedLayerIds,listLayerIds); }catch(Exception e){ }
            try{ MRSHandlerUtility.sendEmailOnReleasedLayersToCustomerFoundryFE(mapReleasedLayerIds,listLayersSorted); }catch(Exception e){ }
        }         
        if(mrsLayerAssolst.size() > 0){ try{ MRSHandlerUtility.sendEmailToTECNReviewers(mrsLayerAssolst); }catch(Exception e){} }
        /** Code for functional development (outside !IntegrationUserUtil.isSkipTrigger()) End**/
         
     if(!IntegrationUserUtil.isSkipTrigger()){                   
        map<string,MRS_Layer_Chip_Association__c> mapPTRFlayerChip = new map<string,MRS_Layer_Chip_Association__c>();
        //call the method checkMRSpackageSync
        if(MRSId != null){ MRSSwiftUtility.checkMRSpackageSync(MRSId); }
        if(!setdrtID.isEmpty()){ MRSpackageSyncHandler.syncMRSLayerChip(setdrtID); }
    }
    
    //fixing send layer status sometime not sent
    if(setLayerIds!=null && !setLayerIds.isEmpty()){
        if(MRSSwiftUtility.bLayerStatus){
            MRSSwiftUtility.bLayerStatus= false;
            MRSSwiftUtility.sendLayerStatusUpdate(setLayerIds);    
        }
    }
}