/*
Type Name: MaskWIPHandlerUtility
Author: Cognizant 
Created Date: 30-May-2014
Reason: This is a general utility class used for all generic functionalities of Mask WIP. 
Change History:
Cognizant            30052014     -      Apex code created
*/
public class MaskWIPHandlerUtility {

    /**
        This method will validate the Pairing Table and if some matching MRS Layer Association records are found, then the layer status of these MRS Layers will be 
        updated to Shipped. 
        @method name: validatePairingTableToShipMRSLayer
        @parameter:   List of Mask WIP records.
        @return :     None.
    **/
    public static void validatePairingTableToShipMRSLayer (list<Mask_WIP__c> listMaskWIPs) {
        
           /******************NO PROCESSING IF INPUT IS EMPTY*****************/
          /******************************************************************/
         /**/if(listMaskWIPs == null || listMaskWIPs.size() == 0) return;/**/
        /******************************************************************/
        set<String> setMaskLayerNumRevTitle = new Set<String>();     
        set<String> setMaskTitles = new set<String>();
        set<String> setMaskSetTitles = new set<String>();
        set<String> setMaskTitlesNotInPairingTable = new set<String>();
        set<String> setMaskLayersFromPairingTable = new set<String>();
        set<String> setMaskLayersMatchingFoundButNotReleased = new set<String>();
        set<String> setMaskLayersMatchingNotFound = new set<String>();
        set<String> setLayerNumbersFromPairingTable = new set<String>();
        set<String> setMaskRevsFromPairingTable = new set<String>();
        list<MRS_Layer_Association__c> lstMRSLA = new list<MRS_Layer_Association__c>();
        map<String,Pairing_Table__c> mapMaskTitlesToPairingTable = new map<String,Pairing_Table__c>();
        map<String,Date> mapMaskTitlesToShippedDate = new map<String,Date>();
        map<String,String> mapMaskLayersToMSTs = new map<String,String>();
        map<String,MRS_Layer_Association__c> mapMaskLayersInHoldState = new map<String,MRS_Layer_Association__c>();  
        map<String,MRS_Layer_Association__c> mapMaskLayerToMRSLayerAssoc = new map<String,MRS_Layer_Association__c>();
        
        for(Mask_WIP__c objMWIP:listMaskWIPs) {
            
            if(objMWIP.Mask_Title__c!=null) {
                
                setMaskTitles.add(objMWIP.Mask_Title__c.substring(0,(objMWIP.Mask_Title__c.length()-4)));
                setMaskSetTitles.add(objMWIP.Mask_Set_Title_Text__c);
                mapMaskTitlesToShippedDate.put(objMWIP.Mask_Title__c,objMWIP.Shipped_Date__c);
            }                      
        }
        
        if(setMaskTitles.size()>0){
            for(Pairing_Table__c objPT:[select Id,Mask_Title__c,Mask_Set_Title__c,Mask_Set_Title__r.Name,Mask_Set_Title_Text__c,Image1__c,Image2__c,Image3__c,Image4__c 
                    from Pairing_Table__c where Mask_Title__c IN:setMaskTitles and Mask_Set_Title_Text__c IN:setMaskSetTitles]) {
                
                mapMaskTitlesToPairingTable.put(objPT.Mask_Title__c, objPT);
                
                if(objPT.Image1__c!=null){
                    setMaskLayerNumRevTitle.add(objPT.Image1__c.substring(0,objPT.Image1__c.length()-2)+objPT.Image1__c.substring(objPT.Image1__c.length()-2,objPT.Image1__c.length())+objPT.Mask_Set_Title_Text__c);
                    setMaskLayersFromPairingTable.add(objPT.Image1__c);
                    setLayerNumbersFromPairingTable.add(objPT.Image1__c.substring(0,objPT.Image1__c.length()-2));
                    setMaskRevsFromPairingTable.add(objPT.Image1__c.substring(objPT.Image1__c.length()-2,objPT.Image1__c.length()));
                    mapMaskLayersToMSTs.put(objPT.Image1__c,objPT.Mask_Set_Title_Text__c);
                }
                
                if(objPT.Image2__c!=null) {
                    setMaskLayerNumRevTitle.add(objPT.Image2__c.substring(0,objPT.Image2__c.length()-2)+objPT.Image2__c.substring(objPT.Image2__c.length()-2,objPT.Image2__c.length())+objPT.Mask_Set_Title_Text__c);
                    setMaskLayersFromPairingTable.add(objPT.Image2__c);
                    setLayerNumbersFromPairingTable.add(objPT.Image2__c.substring(0,objPT.Image2__c.length()-2));
                    setMaskRevsFromPairingTable.add(objPT.Image2__c.substring(objPT.Image2__c.length()-2,objPT.Image2__c.length()));
                    mapMaskLayersToMSTs.put(objPT.Image2__c,objPT.Mask_Set_Title_Text__c);
                }
                
                if(objPT.Image3__c!=null) {
                    setMaskLayerNumRevTitle.add(objPT.Image3__c.substring(0,objPT.Image3__c.length()-2)+objPT.Image3__c.substring(objPT.Image3__c.length()-2,objPT.Image3__c.length())+objPT.Mask_Set_Title_Text__c);
                    setMaskLayersFromPairingTable.add(objPT.Image3__c);
                    setLayerNumbersFromPairingTable.add(objPT.Image3__c.substring(0,objPT.Image3__c.length()-2));
                    setMaskRevsFromPairingTable.add(objPT.Image3__c.substring(objPT.Image3__c.length()-2,objPT.Image3__c.length()));
                    mapMaskLayersToMSTs.put(objPT.Image3__c,objPT.Mask_Set_Title_Text__c);
                }
                
                if(objPT.Image4__c!=null) {
                    setMaskLayerNumRevTitle.add(objPT.Image4__c.substring(0,objPT.Image4__c.length()-2)+objPT.Image4__c.substring(objPT.Image4__c.length()-2,objPT.Image4__c.length())+objPT.Mask_Set_Title_Text__c);
                    setMaskLayersFromPairingTable.add(objPT.Image4__c);
                    setLayerNumbersFromPairingTable.add(objPT.Image4__c.substring(0,objPT.Image4__c.length()-2));
                    setMaskRevsFromPairingTable.add(objPT.Image4__c.substring(objPT.Image4__c.length()-2,objPT.Image4__c.length()));
                    mapMaskLayersToMSTs.put(objPT.Image4__c,objPT.Mask_Set_Title_Text__c);
                }       
            }
            
            if(mapMaskTitlesToPairingTable.size()>0) {
                
                for(String maskTitle:setMaskTitles) {
                    
                    if(!mapMaskTitlesToPairingTable.keySet().contains(maskTitle)) {
                        setMaskTitlesNotInPairingTable.add(maskTitle);  
                    }   
                }   
            } else {
                setMaskTitlesNotInPairingTable.addAll(setMaskTitles);   
            }   
        }
        
        list<MRS_Layer_Association__c> listMRSLayerAssocMatchingNotFound = new list<MRS_Layer_Association__c>();
        
        
        /********************************************************************************/
        map<String,MRS_Layer_Association__c> mapMaskLayersWithDisapprove = new map<String,MRS_Layer_Association__c>();
        /*SWGP-604********************************************************************************/
        /********************************************************************************/
        list<MRS_Layer_Association__c> listLayer_notInPairingTable = new list<MRS_Layer_Association__c>();
        list<mrs_layer_chip_association__c> listLayerChip_notInPairingTable = new list<mrs_layer_chip_association__c>();
        map<id, list<mrs_layer_chip_association__c>> maplayerChipByLayer1 = new map<id, list<mrs_layer_chip_association__c>>();
        
        if(setMaskTitlesNotInPairingTable.size()>0) //to query list layer
        {
            listLayer_notInPairingTable = [
                select Id,LogicalOperation__c,Mask_Set_Title_Name__c,Layer_Status__c,Name,Mask_Layer_Rev__c,
                    ROM_Code__c,Generated_Mask_Title__c,Tech_Geo__c,MRS__r.Mask_Set_Title__r.Name,tech_geo_int__c,remark__c
                from MRS_Layer_Association__c 
                where Generated_Mask_Title__c IN:setMaskTitlesNotInPairingTable 
                    and (Layer_Status__c IN ('Released','Hold','In Progress','Not Ready'))
            ];
            
            //next: to query all layer chip under this list of layer
            listLayerChip_notInPairingTable = [
                select id,layer__c,ptrf__r.name,layer_chip_status__c,
                    Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,
                    Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c,
                    Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,
                    Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,
                    ORC__c,DRW__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c,
                    Customer_mebes_jobview__c,foundry_mebes_jobview__c,
                    Tapeout_Centre_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,
                    GlobalShuttle_MEBES_Jobview__c,mdp_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c                    
                from mrs_layer_chip_association__c
                where layer__c IN :listLayer_notInPairingTable
                    and layer__r.layer_status__c IN ('In Progress','Not Ready')
                    and layer_chip_status__c IN ('In Progress','Not Ready')
                    //and (Customer_Frame_Mockup__c = 'Disapprove' or Foundry_Frame_Mockup__c = 'Disapprove')
            ];
            
            for(MRS_Layer_Association__c m: listLayer_notInPairingTable) {
                
                list<mrs_layer_chip_association__c> tmpList = new list<mrs_layer_chip_association__c>();
                
                for(mrs_layer_chip_association__c mm: listLayerChip_notInPairingTable) {
                    
                    if(mm.layer__c == m.Id) {
                        
                        tmpList.add(mm);
                        maplayerChipByLayer1.put(m.Id, tmpList);
                    }
                }
            }    
        }

        list<MRS_Layer_Association__c> listLayer_fromPairingTable = new list<MRS_Layer_Association__c>();
        list<mrs_layer_chip_association__c> listLayerChip_fromPairingTable = new list<mrs_layer_chip_association__c>();
        map<id, list<mrs_layer_chip_association__c>> maplayerChipByLayer2 = new map<id, list<mrs_layer_chip_association__c>>();
        
        if(setMaskLayersFromPairingTable.size()>0) //to query
        {
            listLayer_fromPairingTable = [
                select Id,LogicalOperation__c,Layer_Status__c,Name,Mask_Layer_Rev__c,ROM_Code__c,MRS__r.Mask_Set_Title__c,
                    MRS__r.Mask_Set_Title__r.Name,Tech_Geo__c,Mask_Set_Title_Name__c,tech_geo_int__c,remark__c
                from MRS_Layer_Association__c 
                where Name IN:setLayerNumbersFromPairingTable and Mask_Layer_Rev__c IN:setMaskRevsFromPairingTable
                    and (Layer_Status__c IN ('Released','Hold','In Progress','Not Ready'))
            ];
            //next: to query all layer chip under this list of layer
            listLayerChip_fromPairingTable = [
                select id,layer__c,ptrf__r.name,layer_chip_status__c,
                    Customer_Prime_Remote_Jobview_Setup__c,Customer_Frame_Remote_Jobview_Setup__c,
                    Foundry_Prime_Remote_Jobview_Setup__c,Foundry_Frame_Remote_Jobview_Setup__c,
                    Customer_GDSOUT_Review__c,Foundry_GDSOUT_Review__c,Customer_Frame_Mockup__c,
                    Foundry_Frame_Mockup__c,Send_Prime_Data__c,Send_Frame_Data__c,
                    ORC__c,DRW__c,Prime_MEBES_Received__c,Frame_MEBES_Received__c,
                    Customer_mebes_jobview__c,foundry_mebes_jobview__c,
                    Tapeout_Centre_MEBES_Jobview__c,Tapeout_Applications_MEBES_Jobview__c,
                    GlobalShuttle_MEBES_Jobview__c,mdp_MEBES_Jobview__c,TDTI_MPW_MEBES_Jobview__c
                    
                from mrs_layer_chip_association__c
                where layer__c IN :listLayer_fromPairingTable
                    and layer__r.layer_status__c IN ('In Progress','Not Ready')
                    and layer_chip_status__c IN ('In Progress','Not Ready')
                    //and (Customer_Frame_Mockup__c = 'Disapprove' or Foundry_Frame_Mockup__c = 'Disapprove')
            ];
            
            for(MRS_Layer_Association__c m: listLayer_fromPairingTable) {
                
                list<mrs_layer_chip_association__c> tmpList = new list<mrs_layer_chip_association__c>();
                
                for(mrs_layer_chip_association__c mm: listLayerChip_fromPairingTable) {
                    
                    if(mm.layer__c == m.Id) {
                        
                        tmpList.add(mm);
                        maplayerChipByLayer2.put(m.Id, tmpList);
                    }
                }
            }    
        }
        
        /********************************************************************************/
        /*SWGP-604********************************************************************************/
        list<mrs_layer_chip_association__c> listLayerChipPatchToReleased = new list<mrs_layer_chip_association__c>();
        /********************************************************************************/
        //after above are completed -> to replace below with newly created list -> 2 more soql queries added to the transaction
        //SWGP-604
        //=========================================================================================
        //=========================================================================================
        //=========================================================================================
        if(setMaskTitlesNotInPairingTable.size()>0){
            
            //for(MRS_Layer_Association__c objMRSLA:[select Id,LogicalOperation__c,Mask_Set_Title_Name__c,Layer_Status__c,Name,Mask_Layer_Rev__c,ROM_Code__c,Generated_Mask_Title__c,Tech_Geo__c,MRS__r.Mask_Set_Title__r.Name,tech_geo_int__c from MRS_Layer_Association__c where Generated_Mask_Title__c 
            //IN:setMaskTitlesNotInPairingTable AND (Layer_Status__c IN ('Released','Hold','In Progress','Not Ready') /*(Layer_Status__c = 'Released') OR (Layer_Status__c = 'Hold')*/ )]){
            for(MRS_Layer_Association__c objMRSLA: listLayer_notInPairingTable) {
            
                //SWGP-604
                //add-in In Progress
                
                string layerCombo;
                if(objMRSLA.ROM_Code__c!=null && objMRSLA.ROM_Code__c!='####' && objMRSLA.ROM_Code__c!='null' && objMRSLA.ROM_Code__c!='NULL') {
                    layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c+objMRSLA.ROM_Code__c;
                } else {
                    layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c;
                }
                
                if('Not Ready;In Progress'.containsIgnoreCase(objMRSLA.Layer_Status__c)) {
                    
                    //if found disapprove -> continue -> send out email to notify
                    if(null != objMRSLA.Layer_Status__c && objMRSLA.Layer_Status__c == 'In Progress') {
                        if(null != maplayerChipByLayer1.get(objMRSLA.Id) && maplayerChipByLayer1.get(objMRSLA.Id).size() > 0) {
                            if(maplayerChipByLayer1.get(objMRSLA.Id).get(0).Customer_Frame_Mockup__c == 'Disapprove' || maplayerChipByLayer1.get(objMRSLA.Id).get(0).Foundry_Frame_Mockup__c == 'Disapprove') {
                                //add list send email here
                                mapMaskLayersWithDisapprove.put(layerCombo,objMRSLA);
                                continue;
                            }
                        }
                    } 

                    //shipped to layer and released to layer chip
                    //else: - add layer to layer list use for update later
                    objMRSLA.Layer_Status__c = 'Shipped';
                    DateTime thisTime = system.now().addHours(8);//conversion from GMT+0 to SGT (GMT+8)
                    if(null == objMRSLA.remark__c) objMRSLA.remark__c = '';
                    objMRSLA.remark__c = 'Patched due to layer is Shipped in MASKWIP on ' + thisTime + '.\r\n';
                    
                    lstMRSLA.add(objMRSLA); 
                    
                    //- add layer chip to layer chip list use for update later
                    listLayerChipPatchToReleased.addAll(maplayerChipByLayer1.get(objMRSLA.Id));
                    
                }else if(objMRSLA.Layer_Status__c=='Released') {
                    objMRSLA.Layer_Status__c = 'Shipped';
                    lstMRSLA.add(objMRSLA); 
                }else if(objMRSLA.Layer_Status__c=='Hold') { 
                    setMaskLayersMatchingFoundButNotReleased.add(layerCombo);
                    mapMaskLayersInHoldState.put(layerCombo,objMRSLA);
                }   
            }   
        }
        //=========================================================================================
        //=========================================================================================
        //=========================================================================================
        //SWGP-604-END
        //SWGP-604
        //=========================================================================================
        //=========================================================================================
        //=========================================================================================
        if(setMaskLayersFromPairingTable.size()>0){
            
            set<String> setMaskLayersMatchingFound = new set<String>();
            
            map<string,MRS_Layer_Association__c> mapMRSLayerAssoc = new map<string,MRS_Layer_Association__c>();
            
            //for(MRS_Layer_Association__c objMRSLA:[select Id,LogicalOperation__c,Layer_Status__c,Name,Mask_Layer_Rev__c,ROM_Code__c,MRS__r.Mask_Set_Title__c,
            //                                            MRS__r.Mask_Set_Title__r.Name,Tech_Geo__c,Mask_Set_Title_Name__c,tech_geo_int__c from MRS_Layer_Association__c 
            //                                            where Name IN:setLayerNumbersFromPairingTable and Mask_Layer_Rev__c IN:setMaskRevsFromPairingTable]){   
            for(MRS_Layer_Association__c objMRSLA: listLayer_fromPairingTable) {            
            
 
             if(setMaskLayerNumRevTitle.contains(objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c+objMRSLA.MRS__r.Mask_Set_Title__r.Name)) {              
                    
                string layerCombo;
                
                if(objMRSLA.ROM_Code__c!=null && objMRSLA.ROM_Code__c!='####' && objMRSLA.ROM_Code__c!='null' && objMRSLA.ROM_Code__c!='NULL') {
                    layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c+objMRSLA.ROM_Code__c;
                } else {
                    layerCombo= objMRSLA.Name+objMRSLA.Mask_Layer_Rev__c;
                }
                //mapMRSLayerAssoc.put(layerCombo, objMRSLA);
                
                mapMRSLayerAssoc.put(objMRSLA.Name, objMRSLA);
                                
                if(setMaskLayersFromPairingTable.contains(layerCombo)) {
                    
                    //SWGP-604
                    //add-in In Progress
                    
                    if('Not Ready;In Progress'.containsIgnoreCase(objMRSLA.Layer_Status__c)) {
                        
                        //if found disapprove -> continue -> send out email to notify
                        if(null != objMRSLA.Layer_Status__c && objMRSLA.Layer_Status__c == 'In Progress') {
                            if(null != maplayerChipByLayer2.get(objMRSLA.Id) && maplayerChipByLayer2.get(objMRSLA.Id).size() > 0) {
                                if(maplayerChipByLayer2.get(objMRSLA.Id).get(0).Customer_Frame_Mockup__c == 'Disapprove' || maplayerChipByLayer2.get(objMRSLA.Id).get(0).Foundry_Frame_Mockup__c == 'Disapprove') {
                                    //add list send email here
                                    mapMaskLayersWithDisapprove.put(layerCombo,objMRSLA);
                                    continue;
                                }
                            }
                        } 
                          
                        //shipped to layer and released to layer chip
                        //else: - add layer to layer list use for update later
                        objMRSLA.Layer_Status__c = 'Shipped';
                        DateTime thisTime = system.now().addHours(8);//conversion from GMT+0 to SGT (GMT+8)
                        if(null == objMRSLA.remark__c) objMRSLA.remark__c = ''; 
                        objMRSLA.remark__c += 'Patched due to layer is Shipped in MASKWIP on ' + thisTime + '.\r\n';
                        lstMRSLA.add(objMRSLA); 
                        
                        //      - add layer chip to layer chip list use for update later (need a separate function for this one
                        listLayerChipPatchToReleased.addAll(maplayerChipByLayer2.get(objMRSLA.Id));
                        
                    } else if(objMRSLA.Layer_Status__c=='Released') {                           
                        objMRSLA.Layer_Status__c = 'Shipped';
                        objMRSLA.Layer_Status_Date__c = DateTime.now();
                        lstMRSLA.add(objMRSLA); 
                    } else if(objMRSLA.Layer_Status__c=='Hold') {
                        setMaskLayersMatchingFoundButNotReleased.add(layerCombo);
                        mapMaskLayersInHoldState.put(layerCombo,objMRSLA);
                    }
                    
                    setMaskLayersMatchingFound.add(layerCombo);
                }
              }  
            }
            
            if(setMaskLayersMatchingFound.size()>0 && setMaskLayersFromPairingTable.size()>setMaskLayersMatchingFound.size()) {
                for(String m : setMaskLayersFromPairingTable) {
                    if(!setMaskLayersMatchingFound.contains(m)) {
                        setMaskLayersMatchingNotFound.add(m);
                        if(mapMRSLayerAssoc.containsKey(m)) {
                            // Pairing table mask layer matches with MRS Layer Assoc layer
                            listMRSLayerAssocMatchingNotFound.add(mapMRSLayerAssoc.get(m));
                        }
                        //mapMaskLayerToMRSLayerAssoc.put(maskLayers,objMRSLA);     
                    }   
                }                       
            }   
        }
        //=========================================================================================
        //=========================================================================================
        //=========================================================================================
        //SWGP-604-END
        
        //DML
        if(lstMRSLA.size()>0) MRSHandlerUtility.executeUpdateMLA(lstMRSLA);
        //patch layer chip if still in progress
        if(listLayerChipPatchToReleased.size() > 0) patchLayerChipToReleased(listLayerChipPatchToReleased);
        
        //EMAIL
        //Hold notification
        if(mapMaskLayersInHoldState.size()>0) EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_Hold_Mask_Layer_For_Shipped_Mask_WIP', mapMaskLayersInHoldState.values(),'');
        //In Progress with Disapprove mockup notification
        if(mapMaskLayersWithDisapprove.size() > 0) EmailHandlerUtilityPerMST.sendEmailPerMST('Swift_InProgress_Mask_Layer_For_Shipped_Mask_WIP', mapMaskLayersWithDisapprove.values(),'');
        //notification if there are no matched layer for maskwip record
        if(setMaskLayersMatchingNotFound.size()>0) sendEmailToSwiftAdminForNoMatchingLayers(setMaskLayersMatchingNotFound,mapMaskLayersToMSTs);
    }
    
    /*
    This function will patch layer chip field by field to Approve/Done/Released 
    -> Force release list of layer chips 
    */
    public static void patchLayerChipToReleased(list<mrs_layer_chip_association__c> lstLayerChip) {
        
        list<mrs_layer_chip_association__c> listToUpdate = new list<mrs_layer_chip_association__c>();
        
        for(mrs_layer_chip_association__c m: lstLayerChip) {
            //if(m.Customer_Prime_Remote_Jobview_Setup__c != 'N.A.') m.Customer_Prime_Remote_Jobview_Setup__c = 'Done';
            //if(m.Customer_Frame_Remote_Jobview_Setup__c != 'N.A.') m.Customer_Frame_Remote_Jobview_Setup__c = 'Done';
            //if(m.Foundry_Prime_Remote_Jobview_Setup__c != 'N.A.') m.Foundry_Prime_Remote_Jobview_Setup__c = 'Done';
            //if(m.Foundry_Frame_Remote_Jobview_Setup__c != 'N.A.') m.Foundry_Frame_Remote_Jobview_Setup__c = 'Done';
            if(m.Customer_GDSOUT_Review__c != 'N.A.') m.Customer_GDSOUT_Review__c = 'Approve';
            if(m.Foundry_GDSOUT_Review__c != 'N.A.') m.Foundry_GDSOUT_Review__c = 'Approve';
            if(m.Customer_Frame_Mockup__c != 'N.A.') m.Customer_Frame_Mockup__c = 'Approve';
            if(m.Foundry_Frame_Mockup__c != 'N.A.') m.Foundry_Frame_Mockup__c = 'Approve';
            if(m.Send_Prime_Data__c != 'N.A.') m.Send_Prime_Data__c = 'Done';
            if(m.Send_Frame_Data__c != 'N.A.') m.Send_Frame_Data__c = 'Done';
            if(m.ORC__c != 'N.A.') m.ORC__c = 'Done';
            if(m.DRW__c != 'N.A.') m.DRW__c = 'Done';
            if(m.Prime_MEBES_Received__c != 'N.A.') m.Prime_MEBES_Received__c = 'Done';
            if(m.Frame_MEBES_Received__c != 'N.A.') m.Frame_MEBES_Received__c = 'Done';
            if(m.Customer_mebes_jobview__c != 'N.A.') m.Customer_mebes_jobview__c = 'Released';
            if(m.foundry_mebes_jobview__c != 'N.A.') m.foundry_mebes_jobview__c = 'Released';
            if(m.Tapeout_Centre_MEBES_Jobview__c != 'N.A.') m.Tapeout_Centre_MEBES_Jobview__c = 'Released';
            if(m.Tapeout_Applications_MEBES_Jobview__c != 'N.A.') m.Tapeout_Applications_MEBES_Jobview__c = 'Released';
            if(m.GlobalShuttle_MEBES_Jobview__c != 'N.A.') m.GlobalShuttle_MEBES_Jobview__c = 'Released';
            if(m.mdp_MEBES_Jobview__c != 'N.A.') m.mdp_MEBES_Jobview__c = 'Released';
            if(m.TDTI_MPW_MEBES_Jobview__c != 'N.A.') m.TDTI_MPW_MEBES_Jobview__c = 'Released';     
            if(m.layer_Chip_status__c != 'N.A.') m.layer_Chip_status__c = 'Released';
            //add-to-update
            listToUpdate.add(m);
        }
        //dml -> this function has error handling mechanism -> error will be logged and ?notify?
        MRSHandlerUtility.executeUpdateMCLA(listToUpdate);
    }
    
    /*
    THIS METHOD IS CURRENTLY NOT IN USE -> THERE ARE NO EMAILS SEND OUT BY THIS
    ------
    This method is for sending Emails to Swift Admin Users whenever a Layer found Shipped in Mask WIP and Pairing Table is not present in MRS .        
    @method name: sendEmailToSwiftAdminForNoMatchingLayers
    @parameter:   1. Set of Mask Layers not found in MRS.
              2. Map of Mask Layers to MST Names
    @return :     None.
    */
    public static void sendEmailToSwiftAdminForNoMatchingLayers(set<String> setMaskLayersMatchingNotFound,map<String,String> mapMaskLayersToMSTs){
               
        OrgWideEmailAddress Orgid = [Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        EmailTemplate et = [Select id,Subject,Body,HtmlValue,DeveloperName from EmailTemplate where DeveloperName=:'Swift_No_Mask_Layer_For_Shipped_Mask_WIP'];                 
        
        /*
        //To Address -  Start
        list<String> lstSwiftAdmn = new list<String>();
        if(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.contains(';')){
            lstSwiftAdmn.addAll(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c.split(';'));
        }else{
            lstSwiftAdmn.add(Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c);
        }       
        String[] swiftAdmn ;
        Integer counter;
        if(lstSwiftAdmn != null){
            swiftAdmn  =new String[lstSwiftAdmn.size()];
            counter =0;            
            for(String email : lstSwiftAdmn){
                swiftAdmn[counter] = email ;
                counter++;
            }
        }   
        //To Address -  End
        */
        
        String subject;
        String plainBody;
        String layerName;
        Integer layerCounter = 0;
        plainBody = et.Body;
        string masksettitlename = '';   
        List<String> lstNoMatchingLayer = new List<String>();
        string temp= '';
         
        for(String layerId : setMaskLayersMatchingNotFound){
            /*                                  
            if(layerCounter ==0){               
                layerName = layerId;
            }else{
                layerName = layerName +'\n'+layerId;  
            }
            layerCounter  = layerCounter +1;            
            subject = et.subject; 
            if(mapMaskLayersToMSTs.get(layerId)!=null){ 
                subject=subject.replace('<MRS.Mask Set Title>',mapMaskLayersToMSTs.get(layerId));
                plainBody=plainBody.replace('<MRS.Mask Set Title>',mapMaskLayersToMSTs.get(layerId));
            }else{
                subject=subject.replace('<MRS.Mask Set Title>',''); 
                plainBody=plainBody.replace('<MRS.Mask Set Title>',''); 
            } 
            */
            temp = mapMaskLayersToMSTs.get(layerId);
            lstNoMatchingLayer.add(layerId);
        }
        
        masksettitlename = temp;
        EmailHandlerUtilityPerMST.sendEmailPerMSTNoMaskLayer('Swift_No_Mask_Layer_For_Shipped_Mask_WIP',masksettitlename, lstNoMatchingLayer);
        /*plainBody = plainBody.replace('<MRS.Mask Layer Details>',layerName);
        Messaging.SingleEmailMessage[] massEmail = new Messaging.SingleEmailMessage[]{};
        massEmail.addAll(MRSHandlerutility.partingToCCBccAddress(swiftAdmn,null,null,Orgid,false,subject,plainBody));
        if(massEmail.size() > 0){
            try{
                Messaging.SendEmailResult [] r = Messaging.sendEmail(massEmail);
            }catch(Exception ex){               
            }
        }
        */
   }
   
   /**
        This method is for sending Emails to Tapeout Centre Users whenever a Layer found Shipped in Mask WIP and Pairing Table is present as Hold in MRS .        
        @method name: sendEmailToTapeoutCentreForHoldLayers
        @parameter:   Map of Mask Layers
        @return :     None.
   **/     
   public static void sendEmailToTapeoutCentreForHoldLayers(map<String,MRS_Layer_Association__c> mapMaskLayersInHoldState) {   
        
        set<String> setCustomerIds = new set<String>();        
        OrgWideEmailAddress Orgid = [Select id, DisplayName From OrgWideEmailAddress where DisplayName=:'GLOBALFOUNDRIES' LIMIT 1];
        EmailTemplate et = [Select id,Subject,Body,HtmlValue from EmailTemplate where DeveloperName=:'Swift_Hold_Mask_Layer_For_Shipped_Mask_WIP'];
                         
        //To Address -  Start
        List<String> lstToAddress = new List<String>();
        List<String> mdplst = new List<String>();       
        Set<String> group_names = new Set<String>();
        Map<Id,Id> groupId_userIdMap = new Map<Id,Id>();
        list<GroupMember> lstgroupMember;
        list<User> lstUser;                     
        
        //Populating To Addresses from Tapeout Centre and MDP Groups
        //====
        //TOC
        String SWIFT_TAPEOUT_CENTRE_EMAIL = Environment_Variable__c.getInstance('SWIFT_TAPEOUT_CENTRE_EMAIL').Value__c;
        if(SWIFT_TAPEOUT_CENTRE_EMAIL.contains(';')) lstToAddress.addAll(SWIFT_TAPEOUT_CENTRE_EMAIL.split(';'));
        else lstToAddress.add(SWIFT_TAPEOUT_CENTRE_EMAIL);
        //MDP
        String SWIFT_MDP_EMAIL = Environment_Variable__c.getInstance('SWIFT_MDP_EMAIL').Value__c;
        if(SWIFT_MDP_EMAIL.contains(';')) mdplst.addAll(SWIFT_MDP_EMAIL.split(';'));
        else mdplst.add(SWIFT_MDP_EMAIL);
        //To Address -  End   
                       
        //Bcc Address -  Start
        list<String> lstSwiftAdmn = new list<String>();         
        //swift admin        
        String SWIFT_ADMIN_EMAIL = Environment_Variable__c.getInstance('SWIFT_ADMIN_EMAIL').Value__c;
        if(SWIFT_ADMIN_EMAIL.contains(';')) lstSwiftAdmn.addAll(SWIFT_ADMIN_EMAIL.split(';'));
        else lstSwiftAdmn.add(SWIFT_ADMIN_EMAIL);

        String[] swiftAdmn ;
        Integer counter;
        
        if(lstSwiftAdmn != null) {
            swiftAdmn = new String[lstSwiftAdmn.size()];
            counter = 0;            
            for(String email: lstSwiftAdmn) {
                swiftAdmn[counter] = email;
                counter++;
            }
        }
        //Bcc Address -  End
              
        String[] toAddress;
        String[] bccAddress;
        String subject;
        String plainBody;
        String layerName;
        Integer layerCounter = 0;
        Double mdpTechGeoCutoff = Double.valueOf(MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off','0.022'));    
        
        for(String layerId : mapMaskLayersInHoldState.keySet()){
            
            MRS_Layer_Association__c mrsLayerObject = mapMaskLayersInHoldState.get(layerId);           
            
            if(mapMaskLayersInHoldState.get(layerId).Tech_Geo__c != null) {
                
                if(Double.valueOf(mapMaskLayersInHoldState.get(layerId).Tech_Geo__c.substringBefore('UM')) <= mdpTechGeoCutoff) {
                    lstToAddress.addAll(mdplst);
                }   
            }                         
            
            if(layerCounter ==0) {
                if(mrsLayerObject.ROM_Code__c!=null && mrsLayerObject.ROM_Code__c!='####') {
                    layerName = mrsLayerObject.Name+mrsLayerObject.Mask_Layer_Rev__c+'('+mrsLayerObject.ROM_Code__c+')';
                } else {
                    layerName = mrsLayerObject.Name+mrsLayerObject.Mask_Layer_Rev__c; 
                }
            } else {
                if(mrsLayerObject.ROM_Code__c!=null && mrsLayerObject.ROM_Code__c!='####') {
                    layerName = layerName +'\n'+mrsLayerObject.Name+mrsLayerObject.Mask_Layer_Rev__c+'('+mrsLayerObject.ROM_Code__c+')';
                } else {
                    layerName = layerName +'\n'+mrsLayerObject.Name+mrsLayerObject.Mask_Layer_Rev__c;  
                }
            }
            
            layerCounter  = layerCounter +1;
            Integer toAddressCounter =0;                
            
            if(lstToAddress != null && lstToAddress.size()>0) {
                
                toAddress = new String[lstToAddress.size()];
                
                for(String toAddressObj : lstToAddress) {
                    toAddress[toAddressCounter] =toAddressObj ;
                    toAddressCounter ++;
                }
            }
              
            subject = et.subject;
            subject=subject.replace('<MRS.Mask Set Title>',mrsLayerObject.MRS__r.Mask_Set_Title__r.Name);
            plainBody = et.Body;            
            plainBody=plainBody.replace('<MRS.Mask Set Title>',mrsLayerObject.MRS__r.Mask_Set_Title__r.Name);
        }
        
        plainBody = plainBody.replace('<MRS.Mask Layer Details>',layerName);
        Messaging.SingleEmailMessage[] massEmail = new Messaging.SingleEmailMessage[]{};
        massEmail.addAll(MRSHandlerutility.partingToCCBccAddress(toAddress,null,swiftAdmn,Orgid,false,subject,plainBody));
        
        if(massEmail.size() > 0) try { Messaging.SendEmailResult [] r = Messaging.sendEmail(massEmail); } catch (Exception ex){ }
    }
}