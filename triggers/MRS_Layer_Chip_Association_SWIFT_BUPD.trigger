/*
Type Name: MRS_Layer_Chip_Association_SWIFT_BUPD
Author: Cognizant 
Created Date: 23-April-2014
Reason: MRS_Layer_Chip_Association__c  Before Update trigger
Change History:
Author: Cognizant Technology Solutions
Modified Date: 9/17/2014
Reason: Task 1998 ,all the non cancel layer chip should be consider while sending outbound to Dot Net system

Test classes: MRSCADMEBESReceivedServiceTest, MRSCADSendDataServiceTest, MRSCADRJVServiceTest

 */

trigger MRS_Layer_Chip_Association_SWIFT_BUPD on MRS_Layer_Chip_Association__c(before update) {

    /** Code for Calculating Layer Chip Status and setting Timestamp for Layer Chips **/
    /**/
    if (MRSHandlerUtility.numberOfLayerChipRecords != null) {
        if(MRSHandlerUtility.mapOldLayerChips==null || ( MRSHandlerUtility.mapOldLayerChips!=null && !MRSHandlerUtility.mapOldLayerChips.containsKey( Trigger.new.get(0).ID ) ) ){
            MRSHandlerUtility.numberOfLayerChipRecords = MRSHandlerUtility.numberOfLayerChipRecords - trigger.new.size();
            if (MRSHandlerUtility.listNew == null) {
                MRSHandlerUtility.listNew = new List < MRS_Layer_Chip_Association__c > ();
            }
            MRSHandlerUtility.listNew.addAll(trigger.new);
            if (MRSHandlerUtility.mapOldLayerChips == null) {
                MRSHandlerUtility.mapOldLayerChips = new map < Id, MRS_Layer_Chip_Association__c > ();
            }
            MRSHandlerUtility.mapOldLayerChips.putAll(trigger.oldMap);
            
            MRSHandlerUtility.setLayerChipStatus(Trigger.new);
            MRSHandlerUtility.setTimeStampForLayerChips(Trigger.new, Trigger.oldMap);
        }
    } else {
        /**/
        Boolean flag = false;
        if ((trigger.new[0].First_Sync_with_Oracle__c == Trigger.oldMap.get(trigger.new[0].Id).First_Sync_with_Oracle__c) && (trigger.new[0].Synced_with_Oracle_DB__c == Trigger.oldMap.get(trigger.new[0].Id).Synced_with_Oracle_DB__c) && (trigger.new[0].Last_Sync_Req_Timestamp__c == Trigger.oldMap.get(trigger.new[0].Id).Last_Sync_Req_Timestamp__c)) {
            flag = true;
        }
        if (flag) {
            MRSHandlerUtility.setLayerChipStatus(trigger.new);
            MRSHandlerUtility.setTimeStampForLayerChips(trigger.new, trigger.oldMap);
        }
        /**/
    }

    /** Code for Calculating Rollup Status and Layer Status for Layer Chips **/
    set < String > setLayerIds = new set < String > ();
    set < String > setLayerChipIds = new set < String > ();
    set < String > setLayerIdsVoidCancel = new set < String > ();
    set < String > setLayerChipIdsVoidCancel = new set < String > ();
    set < String > setLayerIdsForFrameMockupDisAppr = new set < String > ();
    set < String > setLayerChipIdsForFrameMockupDisAppr = new set < String > ();
    map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChips = new map < String, List < MRS_Layer_Chip_Association__c >> ();
    map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChipsVoidCancel = new map < String, List < MRS_Layer_Chip_Association__c >> ();
    map < String, List < MRS_Layer_Chip_Association__c >> mapLayerIdToLayerChipsForFrameMockupDisAppr = new map < String, List < MRS_Layer_Chip_Association__c >> ();
    
    boolean bCalculateLayerStatus = false;
    if (MRSHandlerUtility.numberOfLayerChipRecords != null) {
        if (MRSHandlerUtility.numberOfLayerChipRecords == 0) {
            bCalculateLayerStatus = true;
        }
    } else {
        bCalculateLayerStatus = true;
        if (MRSHandlerUtility.listNew == null) {
            MRSHandlerUtility.listNew = new List < MRS_Layer_Chip_Association__c > ();
        }
        MRSHandlerUtility.listNew.addAll(trigger.new);
        if (MRSHandlerUtility.mapOldLayerChips == null) {
            MRSHandlerUtility.mapOldLayerChips = new map < Id, MRS_Layer_Chip_Association__c > ();
        }
        MRSHandlerUtility.mapOldLayerChips.putAll(trigger.oldMap);
    }
    
    if(bCalculateLayerStatus){
        for (MRS_Layer_Chip_Association__c mrsLayerChipObject: MRSHandlerUtility.listNew) {
            if (((mrsLayerChipObject.CAD_Update__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).CAD_Update__c) && mrsLayerChipObject.CAD_Update__c) 
                || mrsLayerChipObject.Layer__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Layer__c 
                || mrsLayerChipObject.Customer_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Customer_MEBES_Jobview__c 
                || mrsLayerChipObject.Foundry_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Foundry_MEBES_Jobview__c 
                || mrsLayerChipObject.GlobalShuttle_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).GlobalShuttle_MEBES_Jobview__c 
                || mrsLayerChipObject.MDP_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).MDP_MEBES_Jobview__c 
                || mrsLayerChipObject.Tapeout_Applications_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Tapeout_Applications_MEBES_Jobview__c 
                || mrsLayerChipObject.Tapeout_Centre_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Tapeout_Centre_MEBES_Jobview__c 
                || mrsLayerChipObject.TDTI_MPW_MEBES_Jobview__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).TDTI_MPW_MEBES_Jobview__c 
                || mrsLayerChipObject.Customer_Frame_Remote_Jobview_Setup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Customer_Frame_Remote_Jobview_Setup__c
                 || mrsLayerChipObject.Customer_Prime_Remote_Jobview_Setup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Customer_Prime_Remote_Jobview_Setup__c 
                 || mrsLayerChipObject.Foundry_Frame_Remote_Jobview_Setup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Foundry_Frame_Remote_Jobview_Setup__c 
                 || mrsLayerChipObject.Foundry_Prime_Remote_Jobview_Setup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Foundry_Prime_Remote_Jobview_Setup__c 
                 || mrsLayerChipObject.Prime_MEBES_Received__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Prime_MEBES_Received__c 
                 || mrsLayerChipObject.Frame_MEBES_Received__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Frame_MEBES_Received__c 
                 || mrsLayerChipObject.DRW__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).DRW__c 
                 || mrsLayerChipObject.ORC__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).ORC__c 
                 || mrsLayerChipObject.Customer_GDSOUT_Review__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Customer_GDSOUT_Review__c 
                 || mrsLayerChipObject.Foundry_GDSOUT_Review__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Foundry_GDSOUT_Review__c 
                 || mrsLayerChipObject.Customer_Frame_Mockup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Customer_Frame_Mockup__c 
                 || mrsLayerChipObject.Foundry_Frame_Mockup__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Foundry_Frame_Mockup__c 
                 || mrsLayerChipObject.Send_Prime_Data__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Send_Prime_Data__c 
                 || mrsLayerChipObject.Send_Frame_Data__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Send_Frame_Data__c 
                 || mrsLayerChipObject.Layer_Chip_Status__c != MRSHandlerUtility.mapOldLayerChips.get(mrsLayerChipObject.Id).Layer_Chip_Status__c
               ) {
                list < MRS_Layer_Chip_Association__c > tempList = new list < MRS_Layer_Chip_Association__c > ();
                String layerId = mrsLayerChipObject.Layer__c;
                setLayerChipIds.add(mrsLayerChipObject.Id);
                setLayerIds.add(layerId);

                if (mapLayerIdToLayerChips.containsKey(layerId)) {
                    tempList.addAll(mapLayerIdToLayerChips.get(layerId));
                }
                tempList.add(mrsLayerChipObject);
                mapLayerIdToLayerChips.put(layerId, tempList);
            }
            
            //TASK-2395                           
            if (mrsLayerChipObject.CAD_Update__c) {
                mrsLayerChipObject.CAD_Update__c = false;
            }
            //TASK-2395                           
        }
        if (setLayerIds.size() > 0) {
            MRSHandlerUtility.setMRSLayerRecalculatedValuesOnLayerUpdate(setLayerIds, mapLayerIdToLayerChips, setLayerChipIds);
        }
    }

    //SWGP-982: all below comment out >>> retired this logic >>> new logic ahjhj
    //Laye Chip Send Prime Status Update
    //COMMENTED-OUT-CODEs BLOCK HERE
    //SWGP-982:end    
    
    //TASK-2462 - Update Last Sync Date
    MRSHandlerUtilityExtn.updateLastSyncDate(Trigger.oldMap, Trigger.newMap);
    // Code for handling concurrent CAD call issue - SWGP-440
    Id profileId = userinfo.getProfileId();
    String profileName = [Select Id, Name from Profile where Id = : profileId].Name;
    for (MRS_Layer_Chip_Association__c lc: Trigger.new) {
        
        if ((lc.Last_Sync_Req_Timestamp_Layer_Gen__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Layer_Gen__c != null && lc.Last_Sync_Req_Timestamp_Layer_Gen__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Layer_Gen__c) 
                || (lc.Last_Sync_Req_Timestamp_ORCN_Job__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_ORCN_Job__c != null && lc.Last_Sync_Req_Timestamp_ORCN_Job__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_ORCN_Job__c)         
                || (lc.Last_Sync_Req_Timestamp_Receive_MEBES__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Receive_MEBES__c != null && lc.Last_Sync_Req_Timestamp_Receive_MEBES__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Receive_MEBES__c) 
                || (lc.Last_Sync_Req_Timestamp_Remote_JobCust__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Remote_JobCust__c != null && lc.Last_Sync_Req_Timestamp_Remote_JobCust__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Remote_JobCust__c) 
                || (lc.Last_Sync_Req_Timestamp_Remote_Jobview__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Remote_Jobview__c != null && lc.Last_Sync_Req_Timestamp_Remote_Jobview__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Remote_Jobview__c) 
                || (lc.Last_Sync_Req_Timestamp_Send_Frame__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Send_Frame__c != null && lc.Last_Sync_Req_Timestamp_Send_Frame__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Send_Frame__c) 
                || (lc.Last_Sync_Req_Timestamp_Send_Prime__c != null && trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Send_Prime__c != null && lc.Last_Sync_Req_Timestamp_Send_Prime__c < trigger.oldMap.get(lc.id).Last_Sync_Req_Timestamp_Send_Prime__c)) {

            if (profileName.tolowercase().indexof('integration') != -1) {
                lc.addError('Record synced with updated request');
            }
        }
    }
}