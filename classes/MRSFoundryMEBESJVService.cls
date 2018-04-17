public class MRSFoundryMEBESJVService extends MRSGeneralService{

    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override Map<String, String> getFieldMap(){
        return new Map<String, String> {
            FIELD_JV                => 'Foundry_MEBES_Jobview__c',
            FIELD_APPROVAL_DATE     => 'Foundry_MEBES_Jobview_Date__c',
            FIELD_APPROVER          => 'FoundryMebesJobViewApprover__c'
        }; 
    }
    
    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override String getSourceForApprovalEmail(){
        return 'MEBES Jobview - Foundry';
    }
    
    /*
    * @description 
    * @param ptrf
    * @return 
    */
    public override String getNoteCategory(){
        return 'Foundry MEBES Jobview';
    }
    
    
    
    public override void performApproval(MRSApprovalService.MRSApprovalMsg msg){
        Set<String> mstSet              = new Set<String>{ msg.maskSetTitle };
        Set<String> ptrfSet             = new Set<String>{ msg.ptrfNumber };
        Set<String> inputLayerNumberSet      = new Set<String>();
        Set<String> inputLayerRevSet         = new Set<String>();
        Map<String,String> commentMap   = new Map<String,String>();//Key map is layer unique id, this is used to create note for layer chip
        Set<String> inputChipNameSet         = new Set<String>();
        String layerUniqueIdentifier    = '';
        String chipUniqueIdentifier     = '';
        
        for(MRSApprovalService.MRSLayerData layer: msg.layers){
            if( !inputLayerNumberSet.contains(layer.layerNumber) ){
                inputLayerNumberSet.add(layer.layerNumber);
            }
            if( !inputLayerRevSet.contains(layer.layerRev) ){
                inputLayerRevSet.add(layer.layerRev);
            }
            layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
            if( !commentMap.containsKey(layerUniqueIdentifier) ){
                commentMap.put(layerUniqueIdentifier, String.isBlank(layer.comment)? '': layer.comment);
            }
            
            for(MRSApprovalService.MRSLayerChipData chip: layer.layerChips){
                if( !inputChipNameSet.contains(chip.chipName) ){
                    inputChipNameSet.add(chip.chipName);
                }
            }
        }
        
        List<MRS_Layer_Chip_Association__c> lcList          = retrieveMRSLayerChips(mstSet, ptrfSet, inputChipNameSet, inputLayerNumberSet, inputLayerRevSet);
        
        if(lcList.isEmpty()){
            Message errorMsg = new Message('Layer or chip not found','',true);
            if( isValidationErrorLogged() ) MRSApprovalUtility.logValidationError( errorMsg, msg);
            //build response
            handleResponse(msg, errorMsg);
            return;
        }
        
        Set<String> layerNumberSet      = new Set<String>();
        Set<String> layerRevSet         = new Set<String>();
        Set<String> layerUniqueIdSet    = new Set<String>();//Combination of Layer Number + Rev + Rom Code
        Set<String> chipNameSet         = new Set<String>();
        Set<String> chipUniqueIdSet     = new Set<String>();
        Map<String, MRS_Layer_Chip_Association__c> layerChipMap = new Map<String, MRS_Layer_Chip_Association__c>();
        Map<String, Message> layerErrMap                        = new Map<String, Message>();
        Map<String, Message> layerChipErrMap                    = new Map<String, Message>();
        
        for(MRS_Layer_Chip_Association__c lc : lcList){
            //Add Layer Number, Layer Rev, Chip name...to data sets
            if( !layerNumberSet.contains(lc.Layer__r.Name) ){
                layerNumberSet.add(lc.Layer__r.Name);
            }
            if( !layerRevSet.contains(lc.Layer__r.Mask_Layer_Rev__c) ){
                layerRevSet.add(lc.Layer__r.Mask_Layer_Rev__c);
            }
            
            layerUniqueIdentifier = lc.Layer__r.Name + lc.Layer__r.Mask_Layer_Rev__c;
            if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ){
                layerUniqueIdSet.add(layerUniqueIdentifier);
            }
            
            if( !chipNameSet.contains(lc.Chip__r.Name) ){
                chipNameSet.add(lc.Chip__r.Name);
            }
            chipUniqueIdentifier    = layerUniqueIdentifier + lc.Chip__r.Name;
            if( !chipUniqueIdSet.contains( chipUniqueIdentifier ) ){
                chipUniqueIdSet.add(chipUniqueIdentifier);
                layerChipMap.put(chipUniqueIdentifier, lc);
            }
        }
        
        Set<string> layerReleasedShippedMap = new Set<string>();
        
        list<MRS_Layer_Association__c> lstLayers = [
            select Mask_Set_Title_Name__c, Name, Mask_Layer_Rev__c, ROM_Code__c
            from MRS_Layer_Association__c
            where Mask_Set_Title_Name__c in :mstSet and Name in :layerNumberSet and Mask_Layer_Rev__c in :layerRevSet and Layer_Status__c in ('Released','Shipped')
        ];
        
        for(MRS_Layer_Association__c lyr : lstLayers){ layerReleasedShippedMap.add(lyr.Name+lyr.Mask_Layer_Rev__c );}
        
        List<MRS_Layer_Chip_Association__c> lcToUpdateList  = new List<MRS_Layer_Chip_Association__c>();
        User approver   = MRSApprovalUtility.getUserFromEmployeeID(msg.employeeID, msg.source);
        
        for(MRSApprovalService.MRSLayerData layer: msg.layers){
            layerUniqueIdentifier   = layer.layerNumber + layer.layerRev;
            //Check if Layer Status is valid
            if( !layerUniqueIdSet.contains(layerUniqueIdentifier) ){
                //Missing Layer
                if( layerReleasedShippedMap.contains(layerUniqueIdentifier) ){
                    layerErrMap.put( layerUniqueIdentifier, new Message('Layer is Released or Shipped','',true) );
                }else{
                    layerErrMap.put( layerUniqueIdentifier, new Message('MRS Layer not found.','',true) );
                }
                continue;
            }
            //Get fields to be updated: FOUNDRY
            Map<String,String> fieldMap = getFieldMap();
            String jvField                  = fieldMap.get( FIELD_JV );
            String approvalDateField        = fieldMap.get( FIELD_APPROVAL_DATE );
            String approverField            = fieldMap.get( FIELD_APPROVER );
            
            //TDTI FIELDS
            Map<String,String> fieldMap_tdti = new MRSTDTIMPWService().getFieldMap();
            String jvField_tdti                  = fieldMap_tdti.get( FIELD_JV );
            String approvalDateField_tdti        = fieldMap_tdti.get( FIELD_APPROVAL_DATE );
            String approverField_tdti            = fieldMap_tdti.get( FIELD_APPROVER );
            
            //Process layer chips
            for(MRSApprovalService.MRSLayerChipData chip: layer.layerChips){
                chipUniqueIdentifier    = layerUniqueIdentifier + chip.chipName;
                if( !chipUniqueIdSet.contains(chipUniqueIdentifier) ){//Missing chip
                    layerChipErrMap.put( chipUniqueIdentifier, new Message('MRS Layer Chip not found.','',true) );
                    continue;
                }
                
                if( String.isBlank(chip.status) || !chip.status.equalsIgnoreCase('Released') ){
                    layerChipErrMap.put( chipUniqueIdentifier, new Message('Invalid approval status: ' + chip.status,'',false) );
                    continue;
                }
                
                //Get layer chip from the map
                MRS_Layer_Chip_Association__c tmpChip = layerChipMap.get(chipUniqueIdentifier);
                
                //Update chip jobview status, date & approver 
                MRS_Layer_Chip_Association__c chipToUpdate = new MRS_Layer_Chip_Association__c(Id = tmpChip.Id);//Init a new object to make sure that only changed fields are save.
                
                boolean isUpdated = false;
                
                //==========================================================================================
                //SWGP-740
                String chipErrorMsg = ':';
                //==========================================================================================
                //FOUNDRY===================================================================================
                //Check chip status
                if( String.valueOf( tmpChip.get( jvField ) )== 'Released'){
                    layerChipErrMap.put( chipUniqueIdentifier, new Message('[Foundry] Layer Chip has been Released','',false) );
                } else if( String.valueOf( tmpChip.get( jvField ) )== 'N.A.'){
                    layerChipErrMap.put( chipUniqueIdentifier, new Message('[Foundry] Approval Status is N.A.','',false) );
                } else if( String.valueOf( tmpChip.get( jvField ) )=='Not Ready' ){
                    //Invalid Chip status
                    //SWGP-740
                    chipErrorMsg += '[Foundry] Invalid Layer Chip status - ' + String.valueOf( tmpChip.get( jvField ) );
                    //layerChipErrMap.put( chipUniqueIdentifier, new Message('[Foundry] Invalid Layer Chip status: ' + String.valueOf( tmpChip.get( jvField ) ),'',true) );
                } else {
                    isUpdated = true;
                    chipToUpdate.put( jvField, chip.status );
                    chipToUpdate.put( approvalDateField, System.now() );
                    if(approver!=null){
                        chipToUpdate.put( approverField, String.valueOf(approver.ID) );
                    }else{//Bypass validation
                        chipToUpdate.put( approverField, UserInfo.getUserId() );
                    }    
                }
                //FOUNDRY===================================================================================
                //==========================================================================================
                
                //swgp-1076: remove TDTI
                //TDTI======================================================================================
                //Check chip status
                //if( String.valueOf( tmpChip.get( jvField_tdti ) )== 'Released'){ 
                    //layerChipErrMap.put( chipUniqueIdentifier, new Message('[TDTI] Layer Chip has been Released','',false) ); 
                //} else if( String.valueOf( tmpChip.get( jvField_tdti ) )== 'N.A.'){ 
                    //layerChipErrMap.put( chipUniqueIdentifier, new Message('[TDTI] Approval Status is N.A.','',false) ); 
                //} else if( String.valueOf( tmpChip.get( jvField_tdti ) )=='Not Ready' ){
                    //SWGP-740
                //    chipErrorMsg += '; [TDTI] Invalid Layer Chip status - ' + String.valueOf( tmpChip.get( jvField_tdti ) );
                    //layerChipErrMap.put( chipUniqueIdentifier, new Message('[TDTI] Invalid Layer Chip status: ' + String.valueOf( tmpChip.get( jvField_tdti ) ),'',true) );
                //} else {
                //    isUpdated = true;
                //    chipToUpdate.put( jvField_tdti, chip.status );
                //    chipToUpdate.put( approvalDateField_tdti, System.now() );
                //    if(approver!=null){chipToUpdate.put(approverField_tdti, String.valueOf(approver.ID));}else{chipToUpdate.put( approverField_tdti, UserInfo.getUserId() );}
                //}
                //TDTI=======================================================================================
                //swgp-1076: remove TDTI-END
                
                //SWGP-740
                if(String.isNotBlank(chipErrorMsg)) layerChipErrMap.put( chipUniqueIdentifier, new Message(chipErrorMsg,'',true));
                //===========================================================================================
                //Set value for Jobview approver
                if(isUpdated) { 
                    //=========================
                    //SWGP-588
                    if(String.valueOf(tmpChip.get('Send_Prime_Data__c')) == 'Not Done') chipToUpdate.put('Send_Prime_Data__c','Done');
                    if(String.valueOf(tmpChip.get('Send_Frame_Data__c')) == 'Not Done') chipToUpdate.put('Send_Frame_Data__c','Done');
                    if(String.valueOf(tmpChip.get('Frame_MEBES_Received__c')) == 'Not Done') chipToUpdate.put('Frame_MEBES_Received__c','Done');
                    if(String.valueOf(tmpChip.get('Prime_MEBES_Received__c')) == 'Not Done') chipToUpdate.put('Prime_MEBES_Received__c','Done');
                    //SWGP-588
                    //=========================

                    lcToUpdateList.add(chipToUpdate);
                }
            }
        }
        
        //Update layer chip
        if( !lcToUpdateList.isEmpty() ){
            update lcToUpdateList;
            //Send email
            doPostApprovalActions(lcToUpdateList, commentMap);
        }
        //build response
        handleResponse(msg, layerErrMap, layerChipErrMap, new Message('','', false));
    }
}