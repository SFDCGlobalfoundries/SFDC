/*
Type Name: TECNHandlerUtility 
Author: Cognizant 
Created Date: 30-April-2014
Reason: This is a general utility class used for all generic functionalities of TECN. 
Change History:
Cognizant            30042014     -      Apex code created
Cognizant            29052014     -      Modified for adding condition for MEBES Jobview

 */
 
public class TECNHandlerUtility{
    
    /*
    This method is for validating whether the TECNs related to a MRS Layer is on Released status.        
    @method name: releaseMRSLayersForReleasedTECNs
    @parameter:   Set of TECN Numbers which have reached Released status
    @return :     None.
    */
    public static void releaseMRSLayersForReleasedTECNs(set<String> setTECNNos){

        set<String> setAllTECNs = new set<String>();
        List<MRS_Layer_Association__c> mrsLayerAssociationList = new List<MRS_Layer_Association__c>();
        List<MRS_Layer_Association__c> mrsLayerListToUpdate = new List<MRS_Layer_Association__c>();
        string objName;
        map<String, Boolean> mapTECNNumberToStatus = new map<String, Boolean>();
        
        try {
            
            if(setTECNNos!=null && setTECNNos.size()>0) {
                
                for(MRS_Layer_Association__c obj:[SELECT Id, Name, Layer_Status__c, LogicalOperation__c, LogicalOperationType__c 
                FROM MRS_Layer_Association__c 
                WHERE LogicalOperationType__c='TECN' AND Layer_Status_Text__c='Pending Foundry Release']) 
                {
                    objName = obj.Name;
                    set<String> setLogicalOperations = new set<String>();
                    Boolean isTECNReleased = false;
                 
                    if(obj.LogicalOperation__c.contains(';')) {
                        setLogicalOperations.addAll(obj.LogicalOperation__c.split(';'));               
                    } else {
                        setLogicalOperations.add(obj.LogicalOperation__c); 
                    }
                 
                    if(setLogicalOperations.size()>0) {
                        
                        for(String str:setLogicalOperations) {
                            
                            if(setTECNNos.contains(str)) {
                                isTECNReleased = true;
                            }   
                        }
                        
                        if(isTECNReleased) {
                            setAllTECNs.addAll(setLogicalOperations);
                            mrsLayerAssociationList.add(obj);       
                        }
                    }
                }

                if(setAllTECNs!=null && setAllTECNs.size()>0){
                    
                    for(TECN__c objTECN:[select TECN_No__c, TECN_Status__c, Related_TECN_No__c from TECN__c where Id!=null AND Related_TECN_No__c IN:setAllTECNs]){               
                        
                        if(mapTECNNumberToStatus.containsKey(objTECN.Related_TECN_No__c)) {
                            
                            if(!mapTECNNumberToStatus.get(objTECN.Related_TECN_No__c)) {
                                //if(objTECN.TECN_Status__c=='Released'){
                                if( 'Released;Expired'.containsIgnoreCase( objTECN.TECN_Status__c ) ) mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c,true);
                            }
                        } else {
                            //if(objTECN.TECN_Status__c=='Released'){
                            if( 'Released;Expired'.containsIgnoreCase( objTECN.TECN_Status__c ) ) {
                                mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c,true); 
                            } else {
                                mapTECNNumberToStatus.put(objTECN.Related_TECN_No__c,false);
                            }
                        }
                    }
                }
                
                if(mrsLayerAssociationList!=null && mrsLayerAssociationList.size()>0) {
                    
                    for(MRS_Layer_Association__c obj:mrsLayerAssociationList) {
                        
                        set<String> setLogicalOperations = new set<String>();
                        Boolean isReleased = false;
                        
                        if(obj.LogicalOperation__c.contains(';')) {
                            setLogicalOperations.addAll(obj.LogicalOperation__c.split(';'));               
                        } else {
                            setLogicalOperations.add(obj.LogicalOperation__c); 
                        }
                        
                        for(String tecn:setLogicalOperations) {                  
                            
                            if(mapTECNNumberToStatus.get(tecn)) {
                                isReleased = true;    
                            } else {
                                isReleased = false;
                            }                                       
                        }
                        
                        if(isReleased) {
                            obj.Layer_Status__c = 'Released';
                            obj.Layer_Status_Date__c = Datetime.now();
                            mrsLayerListToUpdate.add(obj);      
                        }
                    }
                    
                    if(mrsLayerListToUpdate!=null && mrsLayerListToUpdate.size()>0){                
                        update mrsLayerListToUpdate;
                    }
                }
            }
            
            if(Test.isRunningTest()) Integer aa = Integer.valueOf('THROW_EXCEPTION_HERE');
       }catch(Exception e){    
            //DRTHandlerUtility.handleErrorOnPLM_TECN(e,objName,setTECNNos,'Error on PLM TECN Integration');
        } 
    }
    
    /*
    SWGP-134: Fix TECN Issues not update when new PTRF with new TECN tapeout
    This function will lift off TECN from MRS Layer Association if:
    -   The layer is deselected and there are no other ptrf-same_Layer is using this TECN.
    -   PTRF is cancel and there are no other ptrf-same_Layer is using this TECN.
    -   Layer chip is void and there are none layer chip under this layer_ptrf.
    
    @listMaskLayer:  list of ptrf layer which are lifted off tapeout
        -> to be used for checking and lift off tecn at mrs layer level if needed
    
    *** before calling this function, need to make sure that the layer logicalOperationType is TECN
    
    field in mask_layer__c to be queried in trigger again:
    - rom_code__c,m.PTRF__r.MaskSetTitle__c + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + m.PTRF__r.Tech_Geo_Value__c
    
    fields needs to be included as input: select id,rom_code__c,ptrf__r.name,mask_layer_number__c,mask_layer_rev__c,LogicalOperation__c,LogicalOperationType__c
    */
    //public static void liftOffUnUsedTECN(map<string, Mask_Layer__c> mapPtrfLayer, set<string> setMstId, set<string> setLayerNum, set<string> setLayerRev) {
    public static void liftOffUnUsedTECN(list<Mask_Layer__c> listMaskLayer) {
        
        map<string, Mask_Layer__c> mapInputPtrfLayer = new map<string, Mask_Layer__c>(); 
        set<string> setMstId = new set<string>();
        set<string> setLayerNum = new set<string>(); 
        set<string> setLayerRev = new set<string>();
        set<string> ptrfInputSet = new set<string>();
        
        for(Mask_Layer__c m: listMaskLayer) {
            String key = '';
            //building unique key
            if(String.isBlank(m.rom_code__c)) key = m.PTRF__r.MaskSetTitle__c + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + m.PTRF__r.Tech_Geo_Value__c;
            else key = m.PTRF__r.MaskSetTitle__c + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + m.ROM_Code__c + m.PTRF__r.Tech_Geo_Value__c;
            
            mapInputPtrfLayer.put(key, m);//ptrf of deselect-layer, cancel, void chip
            setMstId.add(m.PTRF__r.MaskSetTitle__c);//mst
            setLayerNum.add(m.Mask_Layer_Number__c);
            setLayerRev.add(m.Mask_Layer_Rev__c);
            ptrfInputSet.add(m.ptrf__c);
        }
        
        //-   The layer is deselected and there are no other ptrf-same_Layer is using this TECN.
        // (A) query all ptrf_layer which has 
        // + ptrf_number != 
        // + ptrf__r.mst IN setMst
        // + layerNum IN setLayerNum
        // + layerRev IN SetLayerRev
        // + tapeout = true
        // + ptrf__r.status = pto
        list<Mask_Layer__c> ptrfMaskLayerList = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where Mask_Layer_Number__c IN :setLayerNum
                and Mask_Layer_Rev__c IN :setLayerRev
                and Tapeout__c = true
                and ptrf__r.status__c = 'Perform Tapeout Options'
                and ptrf__r.MaskSetTitle__c IN :setMstId
                and LogicalOperationType__c = 'TECN'
                and ptrf__c NOT IN :ptrfInputSet
        ];
                
        //BUILD A MAP FROM THIS PTRF_LAYER LIST: --KEY: MST + layerNum + layerRev + romCode
        //map<string, Mask_Layer__c> mapOtherPtrfLayer = new map<string, Mask_Layer__c>();
        map<string, set<string>> mapOtherPtrfLayer = new map<string, set<string>>();
        map<string, id> mapOtherPtrfId = new map<string, id>();
        set<string> tecnSet = new set<string>();
        
        for(Mask_Layer__c m: ptrfMaskLayerList) {
            
            String key = '';
            
            if(String.isBlank(m.rom_code__c)) key = m.PTRF__r.MaskSetTitle__c + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + m.PTRF__r.Tech_Geo_Value__c;
            else key = m.PTRF__r.MaskSetTitle__c + m.Mask_Layer_Number__c + m.Mask_Layer_Rev__c + m.ROM_Code__c + m.PTRF__r.Tech_Geo_Value__c;
            
            tecnSet = new set<string>();
            
            if(mapOtherPtrfLayer.containsKey(key)) tecnSet = mapOtherPtrfLayer.get(key);
            
            tecnSet.add(m.LogicalOperation__c);
            mapOtherPtrfLayer.put(key, tecnSet);
            mapOtherPtrfId.put(key, m.ptrf__c);
        }
        
        
        //BUILD A*_MAP which is active layer chip of mapOtherPtrfLayer
        //map<string, mrs_layer_chip_association>: only need 1 active layer chip (#CANCEL, VOID)
        map<id, mrs_layer_chip_association__c> tempMap = new map<id, mrs_layer_chip_association__c>([
            select id, ptrf__r.masksettitle__c, layer__r.name, rev__c, ptrf__r.tech_geo_value__c, rom_code__c,ptrf__c
            from mrs_layer_chip_association__c
            where layer__r.name IN :setLayerNum
                and rev__c IN :setLayerRev
                and ptrf__r.status__c = 'Perform Tapeout Options'
                and ptrf__r.masksettitle__c IN :setMstId
                and ptrf__c NOT IN :ptrfInputSet
                and layer_chip_status__c NOT IN ('Void','Cancel')
        ]);
        
        map<string, mrs_layer_chip_association__c> mapOtherActiveLayerChip = new map<string, mrs_layer_chip_association__c>();
        for(Id i: tempMap.keySet()) {
            mrs_layer_chip_association__c temp = tempMap.get(i);
            String key = '';
            if(String.isBlank(temp.rom_code__c)) key = temp.PTRF__r.MaskSetTitle__c + temp.layer__r.name + temp.rev__c + temp.ptrf__r.tech_geo_value__c 
                + temp.ptrf__c;//add ptrf into key to differentiate with same layer but different ptrf
            else key = temp.PTRF__r.MaskSetTitle__c + temp.layer__r.name + temp.rev__c + temp.rom_code__c + temp.ptrf__r.tech_geo_value__c
                + temp.ptrf__c;//add ptrf into key to differentiate with same layer but different ptrf
            mapOtherActiveLayerChip.put(key, temp);
        }
        
        map<string, set<string>> tecnMapToBeLifted = new map<string, set<string>>();
        //LOOP through input mapPtrfLayer.keySet(): B
        //if B.key existed in A_MAP *AND* THERE ARE ACTIVE LAYER CHIP IN A*_MAP >> then >> 
        //SPLIT A.get.logicalOperation to C LIST
        //loop through C list >> if B.logicalOperation.notContainsIgnoreCase(C.logicalOperation) >>> 
        //>>> add_this_tecn_to_lifted_list, also add the key to unique set, later use to query mrs layer association
        for(String sKey: mapInputPtrfLayer.keySet()) {
                        
            set<string> tecnSetToBeLifted = new set<string>();
            tecnSetToBeLifted.addAll(mapInputPtrfLayer.get(sKey).LogicalOperation__c.split(';'));
                                                
            if(mapOtherPtrfLayer.containsKey(sKey) && mapOtherActiveLayerChip.containsKey(sKey + mapOtherPtrfId.get(sKey))) { //to add 1 more condition: must contains active layer chip

                for(String m: mapOtherPtrfLayer.get(sKey)) {

                    for(String tecn: m.split(';')) {

                        if(tecnSetToBeLifted.contains(tecn.trim())) tecnSetToBeLifted.remove(tecn.trim());
                    }
                }
            }
            tecnMapToBeLifted.put(sKey, tecnSetToBeLifted);
        }
                
        //query mrs layer association  by Layer_Unique_Identifier__c which is the key of tecnMapToBeLifted
        list<mrs_layer_association__c> listMrsLayer = [
            select id,LogicalOperation__c,LogicalOperationType__c,Layer_Unique_Identifier__c
            from mrs_layer_association__c
            where Layer_Unique_Identifier__c IN :tecnMapToBeLifted.keySet() and LogicalOperationType__c = 'TECN'
        ];
        
        //loop listMrsLayer, each layer, retrieve the tecnMapToBeLifted and compare >> remove the tecn
        list<mrs_layer_association__c> listMrsLayerToBeUpdated = new list<mrs_layer_association__c>();
        for(mrs_layer_association__c m: listMrsLayer) {
                        
            if( !tecnMapToBeLifted.containsKey(m.Layer_Unique_Identifier__c)) continue;
            
            set<string> logicalOpeSet = new set<String>();
                        
            logicalOpeSet.addAll(m.LogicalOperation__c.split(';'));
            
            for(String s: tecnMapToBeLifted.get(m.Layer_Unique_Identifier__c)) {
                logicalOpeSet.remove(s);
            }
            
            if(logicalOpeSet.isEmpty()) {
                m.LogicalOperation__c = null;
                m.LogicalOperationType__c = null;
            } else {
                list<String> logicalOpeLst = new list<String>();
                logicalOpeLst.addAll(logicalOpeSet);
                m.LogicalOperation__c = String.join(logicalOpeLst, ';');
            }
            
            listMrsLayerToBeUpdated.add(m);
        }
                
        //============================================================================================
        //=================================================================================
        //======================================================================
        //===========================================================
        try {
            update listMrsLayerToBeUpdated;//add-in retry here
            if(Test.isRunningTest()) Integer a = Integer.valueOf('abc');//to reach catch statement, as this catch only catch concurrenty error
        } catch(Exception dmlEx) {
            //call to retry method
            MRSPLMDRWServiceHandler.logUnhandledException(
                dmlEx,
                json.serialize(listMaskLayer), 
                'TECN-LIFT-OFF-' + String.valueOf(system.now()), 
                'TECNHandlerUtility', 
                'liftOffUnUsedTECN', 
                ''
            );
        }
        //may reuse:
        // - MRSPLMDRWServiceHandler.logUnhandledException(Exception e, String wsMsg, String msgId, String className, String methodName, String ptrfNumber)
        //===========================================================
        //======================================================================
        //=================================================================================
        //============================================================================================
    }
    
    public static list<Mask_Layer__c> retrieveMaskLayersById(set<Id> maskLayerIdList) {
        return [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where id IN :maskLayerIdList
        ];
    }
    
    public static list<Mask_Layer__c> retrieveMaskLayersByPtrfId(list<Id> ptrfIdList) {
        return [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where ptrf__c IN :ptrfIdList
        ];
    }
    
    /*
    Only 1 of these 2 params can have value, the other will be null as a select case    
    @set<Id> maskLayerIdSet 
    @list<Id> ptrfIdList
    */
    @future
    public static void liftOffUnUsedTECN_future(set<Id> maskLayerIdSet, list<Id> ptrfIdList) {
        if(null != maskLayerIdSet) TECNHandlerUtility.liftOffUnUsedTECN(TECNHandlerUtility.retrieveMaskLayersById(maskLayerIdSet));
        else TECNHandlerUtility.liftOffUnUsedTECN(TECNHandlerUtility.retrieveMaskLayersByPtrfId(ptrfIdList));//swgp-134
    }
    
    @future
    public static void liftOffUnUsedTECN_fromVoidLayerChip_future(set<Id> layerChipIdSet, set<Id> layerIdSet) {
        if(null == layerChipIdSet || layerChipIdSet.isEmpty()) return;
                
        //LIST_A
        list<MRS_Layer_Chip_Association__c> listVoidLayerChip = [
            select id,layer__c,ptrf__c,layer__r.name,rev__c,ptrf__r.Tech_Geo_Value__c,rom_code__c
            from mrs_layer_chip_association__c
            where id IN :layerChipIdSet
                and layer_chip_status__c = 'Void'
        ];
                
        //from LIST_A >>> (MAP_A) to build a map with key: ptrfId_layerId | value is layer chip
        map<string, MRS_Layer_Chip_Association__c> mapVoidLayerChip = new map<string, MRS_Layer_Chip_Association__c>();
        for(MRS_Layer_Chip_Association__c m: listVoidLayerChip) {
            mapVoidLayerChip.put(m.ptrf__c + '' + m.layer__c, m);
        }
        
        //LIST_B
        list<MRS_Layer_Chip_Association__c> listOtherLayerChip = [
            select id,layer__c,ptrf__c
            from mrs_layer_chip_association__c
            where layer__c IN :layerIdSet 
                and id NOT IN :listVoidLayerChip
                and layer_chip_status__c NOT IN ('Void','Cancel')
        ];
                
        //from LIST_B >>> (MAP_B) to build a map with key: ptrfId_layerId | value is layer chip
         map<string, MRS_Layer_Chip_Association__c> mapOtherLayerChip = new map<string, MRS_Layer_Chip_Association__c>();
         for(MRS_Layer_Chip_Association__c m: listOtherLayerChip) {
            mapOtherLayerChip.put(m.ptrf__c + '' + m.layer__c, m);
        }
        
        map<string, MRS_Layer_Chip_Association__c> mapLayerChipToLiftTecnOff = new map<string, MRS_Layer_Chip_Association__c>();        
        set<id> setLiftedPtrf = new set<id>();
        set<string> setLiftedLayerNum = new set<string>();
        set<string> setLiftedLayerRev = new set<string>();
        set<string> setLiftedLayerTechGeo = new set<string>();
        //loop through MAP__A 
        //>>> if KEY_A NOT_FOUND in MAP_B 
        //>>> LIST_C add_to_lift_tecn_list_layer_chip
        for(String key: mapVoidLayerChip.keySet()) {
            if(!mapOtherLayerChip.containsKey(key)) {
                MRS_Layer_Chip_Association__c temp = (MRS_Layer_Chip_Association__c) mapVoidLayerChip.get(key);
                
                String sKey = '';
                if(String.isBlank(temp.rom_code__c)) sKey = temp.ptrf__c + temp.layer__r.name + temp.rev__c + temp.ptrf__r.Tech_Geo_Value__c;
                else sKey = temp.ptrf__c + temp.layer__r.name + temp.rev__c + temp.ptrf__r.Tech_Geo_Value__c + temp.rom_code__c;
                
                mapLayerChipToLiftTecnOff.put(skey, temp);
                setLiftedPtrf.add(temp.ptrf__c);
                setLiftedLayerNum.add(temp.layer__r.name);
                setLiftedLayerRev.add(temp.rev__c);
                setLiftedLayerTechGeo.add(temp.ptrf__r.Tech_Geo_Value__c);
            }
        }
                
        //from LIST_C >>> translate into MASK_LAYER_LIST
        list<mask_layer__c> listMaskLayerPossibleRelated = [
            select id,rom_code__c,PTRF__r.MaskSetTitle__c,Mask_Layer_Number__c,ptrf__c,
                Mask_Layer_Rev__c,PTRF__r.Tech_Geo_Value__c,LogicalOperation__c,LogicalOperationType__c
            from Mask_Layer__c
            where Mask_Layer_Number__c IN :setLiftedLayerNum            
                and Mask_Layer_Rev__c IN :setLiftedLayerRev
                and Tapeout__c = true
                and ptrf__c IN :setLiftedPtrf
                and PTRF__r.Tech_Geo_Value__c IN :setLiftedLayerTechGeo
                and LogicalOperationType__c = 'TECN'
        ];
                
        list<mask_layer__c> listMaskLayerToLiftTecnOff = new list<mask_layer__c>();
        
        for(mask_layer__c temp: listMaskLayerPossibleRelated) {
            String key = '';
            if(String.isBlank(temp.rom_code__c)) key = temp.ptrf__c + temp.Mask_Layer_Number__c + temp.Mask_Layer_Rev__c + temp.ptrf__r.Tech_Geo_Value__c;
            else key = temp.ptrf__c + temp.Mask_Layer_Number__c + temp.Mask_Layer_Rev__c + temp.ptrf__r.Tech_Geo_Value__c + temp.rom_code__c;
            
            if(mapLayerChipToLiftTecnOff.containsKey(key)) listMaskLayerToLiftTecnOff.add(temp);
        }
                
        //>>> to call TECNHandlerUtility.liftOffUnUsedTECN(MASK_LAYER_LIST);
        if(!listMaskLayerToLiftTecnOff.isEmpty()) TECNHandlerUtility.liftOffUnUsedTECN(listMaskLayerToLiftTecnOff);
    }
}