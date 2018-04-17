/*
Type Name: PTRF_SWIFT_AUPD
Author: Cognizant 
Created Date: 17-March-2014
Reason: PTRF After Update Trigger for making Mask Set Title Object's Is Available For Use field to true
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/

trigger PTRF_SWIFT_AUPD on PTRF__c (after update) 
{
    /** Set Variables Declaration **/
    Set<String> setStatus = new Set<String>{'Perform Tapeout Options','Jobview','Mask Making','Closed'};
    Set<String> setMaskSetTitleLookUp = new Set<String>();
    Set<String> setDRTforClose = new Set<String>(); 
    Set<String> setPartialCancelPrimePTRFs = new  Set<String>();
    Set<String> setPartialCancelFramePTRFs = new  Set<String>();
    Set<String> setPartialCancelDRCDRW = new  Set<String>(); 
    Set<String> setPTRFtoMRS = new  Set<String>();
    /** Map Variables Declaration **/
    map<String,PTRF__c> mapPTRFtoMRS = new map<String,PTRF__c>();
    map<String,PTRF__c> mapCancelPTRF = new map<String,PTRF__c>();
    
    List<Id> ptrfIdList = new List<Id>();    // TASK-2153
                 
    for(PTRF__c ptrf : trigger.new)
    {             
        /** Fetching all the MaskSetTitle__c lookup fields of PTRF which fulfills the conditions.
         **/
        if((ptrf.Prime_TapeOut__c|| ptrf.Frame_TapeOut__c) && ptrf.MaskSetTitle__c != null && setStatus.Contains(ptrf.Status__c)){
              setMaskSetTitleLookUp.add(ptrf.MaskSetTitle__c);                          
        }
       
        /** Fetching all the PTRFs to be added to MRS**/     
        if((ptrf.Prime_TapeOut__c|| ptrf.Frame_TapeOut__c) && trigger.oldmap.get(ptrf.id).Status__c!='Perform Tapeout Options' && ptrf.Status__c=='Perform Tapeout Options'){ 
            setPTRFtoMRS.add(ptrf.Id);
        }
        
        /** Fetching all the PTRFs which are Cancelled **/ 
        if(ptrf.Status__c=='Cancel' && !(trigger.oldmap.get(ptrf.id).Status__c=='Cancel')){
            mapCancelPTRF.put(ptrf.Id, ptrf);
            
            ptrfIdList.add(ptrf.Id);      // TASK-2153
        }
        
        /** Fetching all the PTRFs with Partial Prime Tapeout **/ 
        if(!ptrf.Prime_TapeOut__c && Trigger.oldMap.get(ptrf.Id).Prime_TapeOut__c){
            setPartialCancelPrimePTRFs.add(ptrf.Id);
        }
        
        /** Fetching all the PTRFs with Partial Frame Tapeout **/ 
        if(!ptrf.Frame_TapeOut__c && Trigger.oldMap.get(ptrf.Id).Frame_TapeOut__c){
            setPartialCancelFramePTRFs.add(ptrf.Id);
        }
        
        /** Fetching all the PTRFs with DRC DRW Status Cancelled **/ 
        if(ptrf.DRC_DRW_Status__c=='Cancelled DRC DRW' && (trigger.oldmap.get(ptrf.id).Status__c!='Cancelled DRC DRW')){
            setPartialCancelDRCDRW.add(ptrf.Id);
        }
        
        /** Fetching all the PTRFs which have Closed/Cancel/Deleted status **/ 
        if(ptrf.Status__c=='Closed' || ptrf.Status__c=='Cancel' || ptrf.Status__c=='Deleted'){
            setDRTforClose.add(ptrf.Id);
        }        
    }
    
    /*--------------------TASK-2153-----------------------*/
    if(!ptrfIdList.isEmpty()){
        //MRSHandlerUtility_For_LogicalOperation.updateLogicalOperation(ptrfIdList);//old function to lift off tecn written by Saurav
        TECNHandlerUtility.liftOffUnUsedTECN_future(null, ptrfIdList);//swgp-134
    }
    /*----------------------------------------------------*/ 
    
    if(setDRTforClose!=null && setDRTforClose.size()>0){
        DRTHandlerUtility.closeDRTonPTRFclose(setDRTforClose);
    }
    
    /** Calling the ptrfIsAvailableForUse method for updating the isAvailableForUse field of the parent MST record.
     **/
    if(setMaskSetTitleLookUp != null && setMaskSetTitleLookUp.size() > 0){    
        //PTRFHandler.ptrfIsAvailableForUse(setMaskSetTitleLookUp);       
    }
      
    /** Calling the addingPTRFToMRS method for adding PTRF to MRS. - Start
     **/   
    if(setPTRFtoMRS!= null && setPTRFtoMRS.size() > 0){
        if (System.isBatch() || System.isFuture()){
            MRSHandlerUtility.addingPTRFToMRS(setPTRFtoMRS); 
        }else{
            MRSHandlerUtility.addingPTRFToMRSFuture(setPTRFtoMRS); 
        } 
        //MRSHandlerUtility.addingPTRFToMRS(mapPTRFtoMRS);           
    }
    /** Calling the addingPTRFToMRS method for adding PTRF to MRS. - End
     **/
    
    /** Calling the cancelPTRFInMRS method for cancelling PTRF from MRS. - Start
     **/ 
    if(mapCancelPTRF!= null && mapCancelPTRF.size() > 0){  
        MRSHandlerUtility.cancelPTRFInMRS(mapCancelPTRF);
    }
    /** Calling the cancelPTRFInMRS method for cancelling PTRF from MRS. - End
     **/
    
    /** Calling the partialCancelPrimePTRFs method for partially cancelling Prime PTRF from MRS. - Start
     **/ 
    if(setPartialCancelPrimePTRFs!= null && setPartialCancelPrimePTRFs.size() > 0){  
        MRSHandlerUtility.partialCancelPrimePTRFs(setPartialCancelPrimePTRFs);
    }
    /** Calling the partialCancelPrimePTRFs method for partially cancelling Prime PTRF from MRS. - End
     **/ 
    
    /** Calling the partialCancelFramePTRFs method for partially cancelling Frame PTRF from MRS. - Start
     **/ 
    if(setPartialCancelFramePTRFs!= null && setPartialCancelFramePTRFs.size() > 0){  
        MRSHandlerUtility.partialCancelFramePTRFs(setPartialCancelFramePTRFs);
    }
    /** Calling the partialCancelFramePTRFs method for partially cancelling Frame PTRF from MRS. - Start
     **/
    
    /** Calling the partialCancelDRCDRW method for cancelling DRC DRW from MRS. - Start
     **/
    if(setPartialCancelDRCDRW!= null && setPartialCancelDRCDRW.size() > 0)
    {  
        MRSHandlerUtility.partialCancelDRCDRW(setPartialCancelDRCDRW);
    }
    /** Calling the partialCancelDRCDRW method for cancelling DRC DRW from MRS. - Start
     **/
     
     
     // code for FRAME GENERATION and DRW STATUS  completed and rerun
        set<id> ptrfIdFG = new set<id>();
        set<id> ptrfIdDRW = new set<id>();
        set<id> ptrfIdDRWNoOrder = new set<id>();
        set<id> ptrfIdRerunDRW = new set<id>();
        set<id> ptrfIdreRunFG = new set<id>(); 
        set<id> ptrfIdStartDRW = new set<id>();
        string ptrf_AUPD;
        set<string> ptrfnumberSet = new set<string>();
        for(PTRF__c ptrf : Trigger.new)
        { 
        ptrfnumberSet.add(ptrf.Name);
        if(Trigger.oldMap.get(ptrf.id).Frame_Status__c != Trigger.newMap.get(ptrf.id).Frame_Status__c && Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Completed')
        {
            ptrfIdFG.add(ptrf.id);
            ptrf_AUPD = 'FRAME GENERATION';
        }
        else if(Trigger.oldMap.get(ptrf.id).Frame_Status__c != Trigger.newMap.get(ptrf.id).Frame_Status__c && Trigger.newMap.get(ptrf.id).Frame_Status__c == 'Frame Generation')
        {
            ptrfIdreRunFG.add(ptrf.id);
            ptrf_AUPD = 'FRAME GENERATION RERUN';
        }
        
        if(Trigger.newMap.get(ptrf.id).DRC_Only__c && Trigger.newMap.get(ptrf.id).Prime_Tapeout__c && (Trigger.newMap.get(ptrf.id).PTRF_DRC_Option__c == 'Foundry run and gating mask release' || Trigger.newMap.get(ptrf.id).PTRF_DRC_Option__c == 'Customer run and gating mask release')){
        if(Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c != Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c && Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Completed')
        {
           if(Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'No violations' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Violations waive' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Tapeout layers with no violations' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Risk tapeout with violations')
            ptrfIdDRW.add(ptrf.id);
            ptrf_AUPD = 'DRW COMPLETED';
        }
         
        else if(Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c != Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c && Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'DRW')// && !Trigger.newMap.get(ptrf.id).DRC_Rerun__c)
        {
           ptrfIdStartDRW.add(ptrf.id); 
           ptrf_AUPD = 'DRW START'; 
        }
        else if( Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c == 'DRW' || Trigger.oldMap.get(ptrf.id).DRC_DRW_Status__c == 'Completed' && Trigger.newMap.get(ptrf.id).DRC_DRW_Status__c == 'Completed')
        {
           if(Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'No violations' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Violations waive' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Tapeout layers with no violations' ||
           Trigger.newMap.get(ptrf.id).DRW_Disposition__c == 'Risk tapeout with violations')
           ptrfIdDRWNoOrder.add(ptrf.id); 
           ptrf_AUPD = 'DRW START'; 
        }
       }
    }
    
    if(ptrfIdDRWNoOrder != null && ptrfIdDRWNoOrder.size() > 0)
    {
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWNoOrderStatus(ptrfIdDRWNoOrder, ptrfnumberSet);
    }
    
    if(ptrfIdStartDRW != null && ptrfIdStartDRW.size() > 0)
    {
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWStartStatus(ptrfIdStartDRW, ptrfnumberSet);
    }
    
    if(ptrfIdDRW != null && ptrfIdDRW.size() > 0)
    {
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_DRWCompletedStatus(ptrfIdDRW,ptrfnumberSet);
    }
    
    if(ptrfIdFG != null && ptrfIdFG.size() > 0)
    {
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGStatus(ptrfIdFG, ptrfnumberSet);
    }
    
    if(ptrfIdreRunFG != null && ptrfIdreRunFG.size() > 0)
    {
    PTRF_FrameGen_DRW_StatusUpdate.FrameGen_FGRerunStatus(ptrfIdreRunFG,ptrfnumberSet);
    }
    
    
    
    //   end 
     
     
    // code for DRT UPDATE IN PTRF
    set<string> primeFrameDrtNameList= new set<string>();
    set<id> primeDrtDel= new set<id>();
    set<id> FrameDrtDel= new set<id>();
    set<string> ptrfNumberDRTSet = new set<string>();
    list<string> ptrfList = new list<string>();
    
    for(PTRF__c ptrf : Trigger.new)
    {
        ptrfNumberDRTSet.add(ptrf.Name);
        if(Trigger.oldMap.get(ptrf.id).Prime_DRT__c != Trigger.newMap.get(ptrf.id).Prime_DRT__c && Trigger.newMap.get(ptrf.id).Prime_DRT__c != null && Trigger.newMap.get(ptrf.id).Prime_DRT__c != '' && PTRF_DotNetService.recursivecall != 'NO')
        {     primeFrameDrtNameList.add(ptrf.Prime_DRT__c);
              primeDrtDel.add(ptrf.Id);
        }
       
        if(Trigger.oldMap.get(ptrf.id).Frame_DRT__c != Trigger.newMap.get(ptrf.id).Frame_DRT__c && Trigger.newMap.get(ptrf.id).Frame_DRT__c != null && Trigger.newMap.get(ptrf.id).Frame_DRT__c != '' && PTRF_DotNetService.recursivecall != 'NO')
        {     primeFrameDrtNameList.add(ptrf.Frame_DRT__c);
              FrameDrtDel.add(ptrf.id);
        }
        ptrfList.add(ptrf.Id);
        if(Trigger.oldMap.get(ptrf.id).Prime_DRT__c != Trigger.newMap.get(ptrf.id).Prime_DRT__c && PTRF_DotNetService.recursivecall != 'NO' && (Trigger.newMap.get(ptrf.id).Prime_DRT__c == null || Trigger.newMap.get(ptrf.id).Prime_DRT__c == ''))
             primeDrtDel.add(ptrf.Id); 
         
        if(Trigger.oldMap.get(ptrf.id).Frame_DRT__c != Trigger.newMap.get(ptrf.id).Frame_DRT__c && PTRF_DotNetService.recursivecall != 'NO' && (Trigger.newMap.get(ptrf.id).Frame_DRT__c == null || Trigger.newMap.get(ptrf.id).Frame_DRT__c == ''))
             FrameDrtDel.add(ptrf.Id); 
    }  
    
    if((primeFrameDrtNameList != null && primeFrameDrtNameList.size() > 0 )|| (FrameDrtDel != null && FrameDrtDel.size() > 0)|| (primeDrtDel != null && primeDrtDel.size() > 0) )
    {
    PTRF_FrameGen_DRW_StatusUpdate.DRT_PtrfAssociationupdate(ptrfIdList,FrameDrtDel,primeDrtDel,primeFrameDrtNameList,ptrfList,ptrfNumberDRTSet);
    }     
}