/*
Type Name: SwiftUtility
Author          : Cognizant 
Created Date    : 16-December-2014
Reason          : PTRF Status updation operation
Edit History:
* 31-Aug-2015: SWIFT Team add logging and error emai notified
 */
public class PTRF_FrameGen_DRW_StatusUpdate {
    
    @future
    public static void FrameGen_DRWNoOrderStatus(set < Id > ptrfIdDRWNoOrder, set < string > ptrfnumberSet) {
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        map < id, MRS_Layer_Chip_Association__c > mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
        string ptrf_AUPD = 'DRW COMPLETED';

        string Ptrfnumber;
        try {
            if (ptrfIdDRWNoOrder != null && ptrfIdDRWNoOrder.size() > 0) {
                mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
                mrsChipLayerAssIns = [
                    select m.PTRF__c,m.PTRF_Number__c,m.Name,m.Mask_Layer__c,m.Id,m.DRW__c,m.Chip_Name__c 
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c IN: ptrfIdDRWNoOrder AND m.Chip_Name__c != 'FRAME' AND m.DRW__c != 'Done' AND m.DRT__c = null
                ];
                for (MRS_Layer_Chip_Association__c mrsIns: mrsChipLayerAssIns) {
                    Ptrfnumber = mrsIns.PTRF_Number__c;
                    if (mrsIns.DRW__c == 'Not Ready' || mrsIns.DRW__c == 'In Progress') {
                        mrsIns.DRW__c = 'Done';
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                    }
                }
                //try {
                if (!mapmrsChipLayerAssInsUpdate.isEmpty() && mapmrsChipLayerAssInsUpdate.values().size() > 0) {
                    MRSHandlerUtility.numberOfLayerChipRecords = mapmrsChipLayerAssInsUpdate.values().size();
                    update mapmrsChipLayerAssInsUpdate.values();
                }
                //} catch (Exception e) { if (e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) update mapmrsChipLayerAssInsUpdate.values(); }
            }
        } catch (Exception e) { handleError(e, ptrfIdDRWNoOrder, ptrfnumberSet, 'DRW_COMPLETED', 'FrameGen_DRWNoOrderStatus'); }
    }

    @future
    public static void FrameGen_DRWStartStatus(set < Id > ptrfIdStartDRW, set < string > ptrfnumberSet) {
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        map < id, MRS_Layer_Chip_Association__c > mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
        string ptrf_AUPD = 'DRW START';
        string Ptrfnumber;
        try {
            if (ptrfIdStartDRW != null && ptrfIdStartDRW.size() > 0) {
                mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
                mrsChipLayerAssIns = [
                    select m.PTRF__c,m.PTRF_Number__c,m.Name,m.Mask_Layer__c,m.Id,m.DRW__c,m.Chip_Name__c 
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c IN: ptrfIdStartDRW AND m.Chip_Name__c != 'FRAME' AND m.DRT__c = null
                ];
                
                for (MRS_Layer_Chip_Association__c mrsIns: mrsChipLayerAssIns) {
                    Ptrfnumber = mrsIns.PTRF_Number__c;
                    if (mrsIns.DRW__c == 'Not Ready') {
                        mrsIns.DRW__c = 'In Progress';
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                    }
                }
                //try {
                if (!mapmrsChipLayerAssInsUpdate.isEmpty() && mapmrsChipLayerAssInsUpdate.values().size() > 0) {                        
                    MRSHandlerUtility.numberOfLayerChipRecords = mapmrsChipLayerAssInsUpdate.values().size();
                    update mapmrsChipLayerAssInsUpdate.values();
                }
                //} catch (Exception e) { if (e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) update mapmrsChipLayerAssInsUpdate.values(); }
            }
        } catch (Exception e) { handleError(e, ptrfIdStartDRW, ptrfnumberSet, 'DRW_STARTED', 'FrameGen_DRWStartStatus'); }
    }

    @future  
    public static void FrameGen_DRWCompletedStatus(set < Id > ptrfIdDRW, set < string > ptrfnumberSet) {
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        map < id, MRS_Layer_Chip_Association__c > mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
        string ptrf_AUPD = 'DRW COMPLETED';
        string Ptrfnumber;
        try {
            if (ptrfIdDRW != null && ptrfIdDRW.size() > 0) {
                mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
                mrsChipLayerAssIns = [
                    select m.PTRF__c,m.PTRF_Number__c,m.Name,m.Mask_Layer__c,m.Id,m.DRW__c,m.Chip_Name__c 
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c IN: ptrfIdDRW AND m.Chip_Name__c != 'FRAME' AND m.DRT__c = null
                ];
                
                for (MRS_Layer_Chip_Association__c mrsIns: mrsChipLayerAssIns) {
                    Ptrfnumber = mrsIns.PTRF_Number__c;
                    if (mrsIns.DRW__c == 'In Progress') {
                        mrsIns.DRW__c = 'Done';
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                    }
                }
                //try {
                if (!mapmrsChipLayerAssInsUpdate.isEmpty() && mapmrsChipLayerAssInsUpdate.values().size() > 0) {
                    MRSHandlerUtility.numberOfLayerChipRecords = mapmrsChipLayerAssInsUpdate.values().size();
                    update mapmrsChipLayerAssInsUpdate.values();
                }
                //} catch (DMLException e) { if (e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) update mapmrsChipLayerAssInsUpdate.values(); }
            }
        } catch (Exception e) { handleError(e, ptrfIdDRW, ptrfnumberSet, 'DRW_COMPLETED', 'FrameGen_DRWCompletedStatus'); }
    }

    @future
    public static void FrameGen_FGStatus(set < Id > ptrfIdFG, set < string > ptrfnumberSet) {
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        map < id, MRS_Layer_Chip_Association__c > mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
        string ptrf_AUPD = 'FRAME GENERATION';
        string Ptrfnumber;
        try {
            if (ptrfIdFG != null && ptrfIdFG.size() > 0) {
                mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
                set < MRS_Layer_Chip_Association__c > setLayerChipSendReadymail = new set < MRS_Layer_Chip_Association__c > ();
                mrsChipLayerAssIns = [Select m.chip__c, m.Layer__c, m.Layer_Chip_Status__c,
                m.PTRF__r.Tech_Geo__c, m.Mask_Set_Title_Name__c,
                m.Customer_Name__c, m.PTRF__r.MaskSetTitle__c,
                m.PTRF_Number__c,
                m.Name,
                m.Mask_Layer__c, m.Send_Frame_Data__c,
                m.Id,
                m.Customer_Frame_Mockup__c, m.Foundry_Frame_Mockup__c,
                m.Chip_Name__c From MRS_Layer_Chip_Association__c m
                where m.PTRF__c IN: ptrfIdFG AND m.Chip_Name__c = : 'Frame'];
                
                for (MRS_Layer_Chip_Association__c mrsIns: mrsChipLayerAssIns) {
                    Ptrfnumber = mrsIns.PTRF_Number__c;
                    if (mrsIns.Customer_Frame_Mockup__c == 'Not Ready') {
                        mrsIns.Customer_Frame_Mockup__c = 'Ready';
                        mrsIns.Customer_Frame_Mockup_Notified_Date__c = system.now();
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                        setLayerChipSendReadymail.add(mrsIns);
                    }
                    
                    if (mrsIns.Foundry_Frame_Mockup__c == 'Not Ready') {
                        mrsIns.Foundry_Frame_Mockup__c = 'Ready';
                        mrsIns.Foundry_Frame_Mockup_Notified_Date__c = system.now();
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                        setLayerChipSendReadymail.add(mrsIns);

                    }
                    
                    //swgp-270 Frame Mockup approval should not set Send Data from Not Ready to Ready
                    //if (mrsIns.Foundry_Frame_Mockup__c == 'N.A.' && mrsIns.Customer_Frame_Mockup__c == 'N.A.' && mrsIns.Send_Frame_Data__c == 'Not Ready') {
                    //    mrsIns.Send_Frame_Data__c = 'Ready';
                    //    mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);

                    //}
                    //system.debug('testing%%%' + mrsIns);
                }
                
                //try {
                if (!mapmrsChipLayerAssInsUpdate.isEmpty() && mapmrsChipLayerAssInsUpdate.values().size() > 0) update mapmrsChipLayerAssInsUpdate.values();
                //} catch (Exception e) { if (e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) update mapmrsChipLayerAssInsUpdate.values(); }

                if (!setLayerChipSendReadymail.isEmpty()) {
                    list < MRS_Layer_Chip_Association__c > lstlc = new list < MRS_Layer_Chip_Association__c > ();
                    lstlc.addAll(setLayerChipSendReadymail);
                    MRSHandlerUtility.sendRedyMailToCustomerAndFoundry(lstlc);
                }
            }
        } catch (Exception e) { handleError(e, ptrfIdFG, ptrfnumberSet, 'FRAME_GENERATION', 'FrameGen_FGStatus'); }
    }

    @future
    public static void FrameGen_FGRerunStatus(set < Id > ptrfIdreRunFG, set < string > ptrfnumberSet) {
        list < MRS_Layer_Chip_Association__c > mrsChipLayerAssIns = new list < MRS_Layer_Chip_Association__c > ();
        map < id, MRS_Layer_Chip_Association__c > mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
        string ptrf_AUPD = 'FRAME GENERATION RERUN';
        string Ptrfnumber;
        try {
            Set < String > setJobview = new Set < String > { 'Not Required', 'Not gating mask release' };
            Set < String > setOrderType = new Set < String > { 'New Prototype', 'Retrofit' };
            Set < String > setPTLP = new Set < String > { 'M5 [Productization]', 'M6 [Technology Qualification]', 'M7 [Volume Qualification]', 'Production' };

            if (ptrfIdreRunFG != null && ptrfIdreRunFG.size() > 0) {
                mapmrsChipLayerAssInsUpdate = new map < id, MRS_Layer_Chip_Association__c > ();
                mrsChipLayerAssIns = [
                    select m.PTRF__c,m.Name,m.Tech_Geo__c,m.Tapeout_Centre_MEBES_Jobview__c,m.MDP_MEBES_Jobview__c,m.TDTI_MPW_MEBES_Jobview__c,
                       m.GlobalShuttle_MEBES_Jobview__c,m.Tapeout_Applications_MEBES_Jobview__c,m.PTRF__r.Order_Type__c,PTRF__r.Mask_Set_Title_Name__c,
                       m.PTRF__r.Customer_jobview__c,m.PTRF__r.Foundry_Jobview__c,m.PTRF__r.Process_Technology_Lifecycle_Phase__c,
                       m.PTRF__r.MaskSetTitle__c,m.PTRF_Number__c,m.Mask_Layer__c,m.Send_Frame_Data__c,m.Send_Prime_Data__c,m.Id,
                       m.Prime_MEBES_Received__c,m.Frame_MEBES_Received__c,m.Customer_Frame_Mockup__c,m.Foundry_Frame_Mockup__c,
                       m.Foundry_Frame_Remote_Jobview_Setup__c,m.Customer_Frame_Remote_Jobview_Setup__c,m.Foundry_Prime_Remote_Jobview_Setup__c,
                       m.Foundry_MEBES_Jobview__c,m.Customer_Prime_Remote_Jobview_Setup__c,m.Customer_MEBES_Jobview__c,m.Chip_Name__c
                    from MRS_Layer_Chip_Association__c m
                    where m.PTRF__c IN: ptrfIdreRunFG AND m.Chip_Name__c = : 'Frame'
                ];
                Double mdpTechGeoCutoff       = Double.valueOf( MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022') );
                for (MRS_Layer_Chip_Association__c mrsIns: mrsChipLayerAssIns) {
                    Ptrfnumber = mrsIns.PTRF_Number__c;
                    if (mrsIns.Customer_Frame_Mockup__c == 'Ready' || mrsIns.Customer_Frame_Mockup__c == 'Approve') {
                        mrsIns.Customer_Frame_Mockup__c = 'Not Ready';
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                    }
                    if (mrsIns.Foundry_Frame_Mockup__c == 'Ready' || mrsIns.Foundry_Frame_Mockup__c == 'Approve') {
                        mrsIns.Foundry_Frame_Mockup__c = 'Not Ready';
                        mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);
                    }

                    mrsIns.Send_Frame_Data__c = 'Not Done';
                    mrsIns.Send_Prime_Data__c = 'N.A.';
                    mrsIns.Foundry_Prime_Remote_Jobview_Setup__c = 'N.A.';
                    mrsIns.Customer_Prime_Remote_Jobview_Setup__c = 'N.A.';
                    mrsIns.Foundry_Frame_Remote_Jobview_Setup__c = 'N.A.';
                    mrsIns.Customer_Frame_Remote_Jobview_Setup__c = 'N.A.';
                    if (mrsIns.Prime_MEBES_Received__c != 'N.A.') mrsIns.Prime_MEBES_Received__c = 'Not Ready';
                    mrsIns.Frame_MEBES_Received__c = 'Not Done';
                    if (mrsIns.Foundry_MEBES_Jobview__c != 'N.A.') mrsIns.Foundry_MEBES_Jobview__c = 'Not Ready';
                    if (mrsIns.Customer_MEBES_Jobview__c != 'N.A.') mrsIns.Customer_MEBES_Jobview__c = 'Not Ready';
                    mapmrsChipLayerAssInsUpdate.put(mrsIns.id, mrsIns);

                    if (mrsIns.Tech_Geo__c != null) {
                        Double techGeo = Double.valueOf(mrsIns.Tech_Geo__c.toUppercase().substringBefore('UM').trim());
                        /** Setting default values for Tapeout Centre,MDP,TDTI/MPW,Globalshuttle MEBES Jobviews. **/
                        if (techGeo > 0.02) {
                            mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                            if (mrsIns.PTRF__r.Mask_Set_Title_Name__c.startsWith('MPW')) { mrsIns.GlobalShuttle_MEBES_Jobview__c = 'Not Ready'; } else { mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.'; }
                        } else {
                            mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                            if (mrsIns.PTRF__r.Mask_Set_Title_Name__c.startsWith('MPW')) {
                                mrsIns.TDTI_MPW_MEBES_Jobview__c = 'Not Ready';
                            } else {
                                mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                            }
                        }
                        //SWGP-347
                        if(techGeo > mdpTechGeoCutoff){
                            mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'Not Ready';
                            mrsIns.MDP_MEBES_Jobview__c = 'N.A.';
                        }else{
                            mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
                            mrsIns.MDP_MEBES_Jobview__c = 'Not Ready';
                        }

                        /** Setting default value for Tapeout Application MEBES Jobview. **/
                        if (techGeo <= 0.18 && techGeo >= 0.11 && (mrsIns.PTRF__r.Order_Type__c == 'New Prototype') && setJobview.contains(mrsIns.PTRF__r.Customer_jobview__c) && setJobview.contains(mrsIns.PTRF__r.Foundry_Jobview__c)) {
                            mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
                        } else if (techGeo <= 0.09 && setOrderType.contains(mrsIns.PTRF__r.Order_Type__c) && setJobview.contains(mrsIns.PTRF__r.Customer_jobview__c) && setJobview.contains(mrsIns.PTRF__r.Foundry_Jobview__c) && setPTLP.contains(mrsIns.PTRF__r.Process_Technology_Lifecycle_Phase__c)) {
                            mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'Not Ready';
                        } else if (techGeo <= 0.09 && (mrsIns.PTRF__r.Order_Type__c == 'New Prototype') && setPTLP.contains(mrsIns.PTRF__r.Process_Technology_Lifecycle_Phase__c) && ((mrsIns.PTRF__r.Customer_jobview__c == 'Gating mask release') || (mrsIns.PTRF__r.Foundry_Jobview__c == 'Gating mask release'))) {
                            mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                        } else {
                            mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                        }
                    } else {
                        mrsIns.GlobalShuttle_MEBES_Jobview__c = 'N.A.';
                        mrsIns.TDTI_MPW_MEBES_Jobview__c = 'N.A.';
                        mrsIns.Tapeout_Centre_MEBES_Jobview__c = 'N.A.';
                        mrsIns.MDP_MEBES_Jobview__c = 'N.A.';
                        mrsIns.Tapeout_Applications_MEBES_Jobview__c = 'N.A.';
                    }
                }

                //try {
                if (!mapmrsChipLayerAssInsUpdate.isEmpty() && mapmrsChipLayerAssInsUpdate.values().size() > 0) update mapmrsChipLayerAssInsUpdate.values();
                //} catch (Exception e) { if (e.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW) update mapmrsChipLayerAssInsUpdate.values(); }
            }
        } catch (Exception e) { handleError(e, ptrfIdreRunFG, ptrfnumberSet, 'FRAME_GENERATION_RERUN', 'FrameGen_FGRerunStatus'); }
    }

    public static void DRT_PtrfAssociationupdate(List < Id > ptrfIdList, set < Id > FrameDrtDel, set < Id > primeDrtDel, set < string > primeFrameDrtNameList, list < string > ptrfList, set < string > ptrfNumberDRTSet) {
        try {
            list < DRT_PTRF_Association__c > delDrtPrimePtrf = new list < DRT_PTRF_Association__c > ();
            list < DRT_PTRF_Association__c > delDrtFramePtrf = new list < DRT_PTRF_Association__c > ();
            if (FrameDrtDel != null && FrameDrtDel.size() > 0) delDrtFramePtrf = [Select d.PTRF__c, d.IsDeleted, d.Id, d.DRT__c, d.DRT_Type__c, d.DRT_Name__c From DRT_PTRF_Association__c d where PTRF__c IN: FrameDrtDel AND d.DRT_Type__c = : 'FRAME'];

            if (primeDrtDel != null && primeDrtDel.size() > 0) delDrtPrimePtrf = [Select d.PTRF__c, d.IsDeleted, d.Id, d.DRT__c, d.DRT_Type__c, d.DRT_Name__c From DRT_PTRF_Association__c d where PTRF__c IN: primeDrtDel AND d.DRT_Type__c = : 'PRIME'];

            if (delDrtPrimePtrf != null && delDrtPrimePtrf.size() > 0) delete delDrtPrimePtrf;

            if (delDrtFramePtrf != null && delDrtFramePtrf.size() > 0) delete delDrtFramePtrf;

            DRT_PtrfAssociationNewUpdate(primeFrameDrtNameList, ptrfList, ptrfNumberDRTSet);
        } catch (Exception e) {
            DRTHandlerUtility.handleErrorOnPTRF_AUPD(e, ptrfNumberDRTSet, 'Add DRT to PTRF', 'Exception on Adding DRT to PTRF');
        }
    }
    
    @future
    public static void DRT_PtrfAssociationNewUpdate(set < string > primeFrameDrtNameList, list < string > ptrfList, set < string > ptrfNumberDRTSet) {
        set < string > primeFrameDrt = new set < string > ();
        map < string, set < string >> drtPtrfMap = new map < string, set < string >> ();
        map < string, id > drtIdNameMap = new map < string, Id > ();
        map < id, PTRF__c > ptrfNewMap = queryPTRF(ptrfList);
        list < DRT_PTRF_Association__c > drtPtrfInsertList = new list < DRT_PTRF_Association__c > ();

        try {
            if (primeFrameDrtNameList != null && primeFrameDrtNameList.size() > 0) {
                for (DRT__c DRTIns: [Select d.Name, d.Id From DRT__c d where d.Name IN: primeFrameDrtNameList]) {
                    primeFrameDrt.add(DRTIns.Id);
                    drtIdNameMap.put(DRTIns.Name, DRTIns.Id);
                }
            }
            if (primeFrameDrt != null && primeFrameDrt.size() > 0) {
                list < DRT_PTRF_Association__c > drtPtrf = [Select d.PTRF__c, d.Name, d.DRT_Name__c, d.Id, d.DRT__c From DRT_PTRF_Association__c d where d.PTRF__c IN: ptrfList];
                list < DRT_PTRF_Association__c > drtPtrfdel = new list < DRT_PTRF_Association__c > ();
                for (string ptrfId: ptrfList) {
                    set < string > drtPtrfAss = new set < string > ();
                    for (DRT_PTRF_Association__c drtPtrfIns: drtPtrf) { if (ptrfId == drtPtrfIns.PTRF__c) { drtPtrfAss.add(drtPtrfIns.DRT_Name__c); } }
                    if (drtPtrfAss != null && drtPtrfAss.size() > 0) drtPtrfMap.put(ptrfId, drtPtrfAss); //map of ptrf and list of drt name associated
                }

                for (PTRF__c ptrf: ptrfNewMap.Values()) {
                    if (drtPtrfMap.keySet().contains(ptrf.id)) { if (drtPtrfMap.get(ptrf.id).contains(ptrf.Prime_DRT__c)) {} else { if (drtIdNameMap.get(ptrf.Prime_DRT__c) != null) {
                                DRT_PTRF_Association__c drtPtrfAssIns = new DRT_PTRF_Association__c();
                                drtPtrfAssIns.PTRF__c = ptrf.id;
                                drtPtrfAssIns.DRT__c = drtIdNameMap.get(ptrf.Prime_DRT__c);
                                drtPtrfInsertList.add(drtPtrfAssIns);
                            }
                        }
                        if (drtPtrfMap.get(ptrf.id).contains(ptrf.Frame_DRT__c)) {} else {
                            if (drtIdNameMap.get(ptrf.Frame_DRT__c) != null) {
                                //FrameDrtDel.add(ptrf.id);
                                DRT_PTRF_Association__c drtPtrfAssIns = new DRT_PTRF_Association__c();
                                drtPtrfAssIns.PTRF__c = ptrf.id;
                                drtPtrfAssIns.DRT__c = drtIdNameMap.get(ptrf.Frame_DRT__c);
                                drtPtrfInsertList.add(drtPtrfAssIns);
                            }
                        }
                    } else { //Add first DRT Associated to PTRF
                        if (ptrf.Prime_DRT__c != null && ptrf.Prime_DRT__c != '' && drtIdNameMap.get(ptrf.Prime_DRT__c) != null) {
                            DRT_PTRF_Association__c drtPtrfAssIns = new DRT_PTRF_Association__c();
                            drtPtrfAssIns.PTRF__c = ptrf.id;
                            drtPtrfAssIns.DRT__c = drtIdNameMap.get(ptrf.Prime_DRT__c);
                            drtPtrfInsertList.add(drtPtrfAssIns);
                        }
                        if (ptrf.Frame_DRT__c != null && ptrf.Frame_DRT__c != '' && drtIdNameMap.get(ptrf.Frame_DRT__c) != null) {
                            DRT_PTRF_Association__c drtPtrfAssIns = new DRT_PTRF_Association__c();
                            drtPtrfAssIns.PTRF__c = ptrf.id;
                            drtPtrfAssIns.DRT__c = drtIdNameMap.get(ptrf.Frame_DRT__c);
                            drtPtrfInsertList.add(drtPtrfAssIns);
                        }
                    }
                }

                if (drtPtrfInsertList != null && drtPtrfInsertList.size() > 0) { try { insert drtPtrfInsertList; } catch (Exception e) { DRTHandlerUtility.handleErrorOnPTRF_AUPD(e, ptrfNumberDRTSet, 'Add DRT to PTRF', 'Exception on Adding DRT to PTRF'); } }
            }
        } catch (Exception e) {
            DRTHandlerUtility.handleErrorOnPTRF_AUPD(e, ptrfNumberDRTSet, 'Add DRT to PTRF', 'Exception on Adding DRT to PTRF');
        }
    }

    public static map < Id, PTRF__c > queryPTRF(List < string > ptrfId) {
        map < Id, PTRF__c > ptrfMap = new map < Id, PTRF__C > ();
        for (PTRF__c ptrfIns: 
            [
                select id,Name,Frame_Status__c,DRC_Only__c,Prime_Tapeout__c,PTRF_DRC_Option__c,DRC_DRW_Status__c,DRW_Disposition__c,Prime_DRT__c,Frame_DRT__c 
                from PTRF__c 
                where ID IN: ptrfId
            ]
        ) {
            ptrfMap.put(ptrfIns.Id, ptrfIns);
        }
        return ptrfMap;
    }

    /**
    * Deprecated. 
    * Please use sendErrorEmail instead.
    */
    public static void sendMail(String e, String ptrfNumber, string operation) {
        try {
            string ptrfNum = 'PTRF Number = ' + ptrfNumber + '\n';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String[] toAddresses = new String[] {};
            if (Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')) { toAddresses.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';')); }
            else { toAddresses.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c); }
            mail.setToAddresses(toAddresses);            
            mail.setSubject('PTRF ' + operation + ' status update error :' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(ptrfNum + e);
                        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); } catch (exception exp) {}
    }
    
    public static void sendErrorEmail(String subjectPrefix, Exception e, String errorMsg, String logId, String wsClass, String msgId, String mst, String ptrfNumber, String source){
        EmailTemplate template= [select id,Subject,Body,HtmlValue,Developername from EmailTemplate where DeveloperName=:MRSApprovalUtility.SWIFT_WS_Unhandled_Exception];
        
        String subject = ('' == subjectPrefix || null == subjectPrefix) ? template.subject : subjectPrefix + ' # ' + template.subject;
        subject        = subject.replace('<Source>', source);
        //
        String subMsg = ' <' + ptrfNumber + '> ';//append to subject
        String bodyMsg = '';//put in error of body
        if(null != e) { subMsg += e.getMessage(); bodyMsg += e.getMessage(); } else { subMsg += ' - Please Check'; bodyMsg += errorMsg; }
        //
        subject             = subject.replace('<Message>', subMsg);
        //===========================================================================
        String body         = template.Body ;
        body                = body.replace('<Status_Type>', '');//TODO
        body                = body.replace('<Source>', '');//TODO
        //===========================================================================
        body                = body.replace('<MessageId>', msgId);
        body                = body.replace('<timestamp>', String.valueOf(System.now()));
        body                = body.replace('<MST>', mst);
        body                = body.replace('<PTRF>', ptrfNumber + '\r\n');
        body                = body.replace('<Message>', '\r\n**********************\r\n' + bodyMsg + '\r\n**********************\r\n');
        body                = body.replace('<Debug_Log_Url>', URL.getSalesforceBaseUrl().toExternalForm() + '/' + logId);
        //get ECS records to build recipients
        List<Email_Config_Settings__c> ecsList = [
            SELECT Email_Template_Name__c,BCC__c,CC__c,Id, Customer_Jobviewer_Type__c,Foundry_Jobviewer_Type__c,Name,MPW_PTRF__c,Send_Mail_To_Customer_AS_Submitter__c, Tech_Geo_Value__c,TO__c,Send_Mail_To_Customer__c 
            FROM Email_Config_Settings__c 
            WHERE Email_Template_Name__c = :MRSApprovalUtility.SWIFT_WS_Unhandled_Exception and Available_For_Use__c = true and Source__c = :source and RecordType.Name = 'General' limit 1
        ];
        
        //build recipients
        Map<String, List<String>> recipientList = MRSApprovalUtility.buildRecipientList(ecsList);
        //construct email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        mail.setToAddresses( recipientList.get('TO') );
        mail.setCcAddresses( recipientList.get('CC') );
        mail.setBccAddresses( recipientList.get('BCC') );
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        //send
        if(!recipientlist.get('TO').isEmpty() || !recipientlist.get('CC').isEmpty() || !recipientlist.get('BCC').isEmpty()) { if(!Test.isRunningTest()) Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail}); }
    }
    
    public static void handleError(Exception e, set<id> ptrfIdSet, set < string > ptrfnumberSet, String signalShortName, String methodName) {
        
        //use to captured argument of start/complete signal and later use for retry in case failure
        MRSPLMDRWRetryController.DrwStartCompleteParam retryParam = new MRSPLMDRWRetryController.DrwStartCompleteParam(ptrfIdSet, ptrfnumberSet);
        String msgId = signalShortName + ' | ' + system.now();
        list<ptrf__c> listPtrfError = [select id,name from ptrf__c where id in :ptrfIdSet];
        //log
        SWIFT_Application_Log__c exLog = MRSPLMDRWServiceHandler.logUnhandledException(
            e, 
            json.serialize(retryParam), 
            msgId, 
            'PTRF_FrameGen_DRW_StatusUpdate', 
            methodName, 
            listPtrfError.get(0).name
        );
              
        //send email to swift_admin
        sendErrorEmail('[MRS] ' + signalShortName, e, e.getMessage(), exLog.id, 'PTRF_FrameGen_DRW_StatusUpdate', msgId, '', listPtrfError.get(0).name, 'PTRF_MRS_DRW');
    }
}